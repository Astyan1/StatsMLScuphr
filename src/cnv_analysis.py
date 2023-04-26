import dendropy
import pandas as pd
import argparse
import numpy as np


def reconstruct_tree(parent_nodes, leaf_nodes, output_file,cnv_nodes=[]):
    new_leafs=["V"+str(i) for i in range(len(leaf_nodes)+1)]
    tree = dendropy.Tree()
    # Create internal nodes
    internal_nodes = {}
    for i, parent in enumerate(parent_nodes):
        if parent not in internal_nodes:
          internal_nodes[parent] = dendropy.Node()
          node = dendropy.Node()
          internal_nodes[parent_nodes[parent]].add_child(node)
          internal_nodes[parent] = node
          node.taxon = dendropy.Taxon(label=str(parent))
          node.label=str(parent)
    # Create leaf nodes
    for i,leaf_node in enumerate(leaf_nodes):
        parent = parent_nodes[leaf_node] # Use integer division to get parent node
        node = dendropy.Node()
        node.taxon = dendropy.Taxon(label=str(new_leafs[i]))
        node.label=str(leaf_node)
        internal_nodes[parent].add_child(node)
    # Set tree as rooted and write to file
    tree.seed_node=internal_nodes[0]
    tree.seed_node.taxon=dendropy.Taxon(label=str(new_leafs[-1]))
    tree.is_rooted = True

    for node in cnv_nodes:
      # Modify a node to show a "*" instead of a "+"
      target_node = tree.find_node_with_label(str(node))
      parent_node=target_node.parent_node
      old_taxon=str(parent_node.taxon)
      if target_node==None:
        parent_node=target_node.parent_node
        target_node=target_node = tree.find_node_with_label('*'+str(node))
        old_taxon='*'+str(parent_node.taxon)
        if target_node==None:
          parent_node=target_node.parent_node
          target_node=target_node = tree.find_node_with_label(str(node)+'*')
          old_taxon=str(parent_node.taxon)+'*'
          if target_node==None:
            continue
      child_nodes = parent_node.child_nodes()
    
      if target_node == child_nodes[0]:
        new_label='*'+old_taxon
      elif target_node == child_nodes[-1]:
        new_label=old_taxon+'*'
      parent_node.taxon = dendropy.Taxon(label=new_label)


    # Print tree
    tree.write_to_path(output_file, 'newick')
    tree = tree.as_ascii_plot(show_internal_node_labels=True)
    tree=tree.replace("'",' ')
    return tree


def tree_analysis(PATH):
    leafs = pd.read_pickle(PATH+"leaf_nodes.pickle")
    parents = pd.read_pickle(PATH+"parent_nodes.pickle")

    mut = pd.DataFrame(pd.read_pickle(PATH+"mut_origin_nodes.pickle"))[0].value_counts()
    cnv_origin=pd.read_csv(PATH+"cnv_origin_nodes.txt",header=None)[0].value_counts()

    proportion=cnv_origin.divide(mut)
    threshold=proportion.mean()+proportion.std()
    cnv=proportion>threshold #Significative proportion of CNV (More than mean(p_cnv)+std(cnv))
    list_cnv=list(np.where(list(cnv.to_numpy()))[0]+1)
    print("Mean Proportion CNV:",proportion.mean())
    print("STD Proportion CNV:",proportion.std())
    print("Threshold",threshold)
    #proportion.plot.bar()
    print("CNV:",list_cnv)
    tree=reconstruct_tree(parents,leafs,PATH+"truth_tree.txt",list_cnv)
    return tree,list_cnv


def main():
    # code to process command line arguments
    parser = argparse.ArgumentParser(description='CNV_Analysis')
    parser.add_argument('--truth_dir', help="Specify the directory.", type=str)
    parser.add_argument('--res_dir', help="Specify the directory.", type=str)
    args = parser.parse_args()

    tree=tree_analysis(args.truth_dir)
    tree_inferred=dendropy.Tree.get(path=args.res_dir+'inferred_w_bulk_root.tre',schema='newick')
    print("True Tree with CNV:\n",tree)
    print("Inferred Tree:\n",tree_inferred.as_ascii_plot(show_internal_node_labels=True))

if __name__ == "__main__":
    main()
