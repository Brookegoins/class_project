#Assignment 5, Diagrams code

library(DiagrammeR)

grViz("
digraph invertebrate_database {
  graph [layout = dot, rankdir = TB, nodesep=0.5, ranksep=0.8]
  
  node [shape = box, style = filled, fontname = Helvetica, fontsize = 10]
  
  # Root tables (no foreign keys) - green
  \"SITES\\n_site_id_\" [fillcolor = \"#C7E9C0\"]
  
  \"TAXONOMY\\n_taxon_id_\\norder_name\\nfamily\\ngenus\\ncommon_name\\nfunctional_group\" [fillcolor = \"#C7E9C0\"]
  
  # Tables with foreign keys - blue
  \"EVENTS\\n_event_id_\\n*site_id*\\nsample_date\\nreach\\ntransect\\nmethod\" [fillcolor = \"lightblue\"]
  
  \"SAMPLES\\n_sample_id_\\n*event_id*\\nfield_id\\nsource\\nid_date\\nprocessor\\nqa_qc\\nnotes\" [fillcolor = \"lightblue\"]
  
  \"OBSERVATIONS\\n_observation_id_\\n*sample_id*\\n*taxon_id*\\nlife_stage\\nlength_mm\\nweight_mg\\na\\nb\" [fillcolor = \"lightblue\"]
  
  # Align root tables
  { rank = same; \"SITES\\n_site_id_\"; \"TAXONOMY\\n_taxon_id_\\norder_name\\nfamily\\ngenus\\ncommon_name\\nfunctional_group\" }
  
  # Invisible edge to align roots nicely
  \"SITES\\n_site_id_\" -> \"TAXONOMY\\n_taxon_id_\\norder_name\\nfamily\\ngenus\\ncommon_name\\nfunctional_group\" [style=invis];
  
  # Relationships
  \"SITES\\n_site_id_\" -> \"EVENTS\\n_event_id_\\n*site_id*\\nsample_date\\nreach\\ntransect\\nmethod\"
  
  \"EVENTS\\n_event_id_\\n*site_id*\\nsample_date\\nreach\\ntransect\\nmethod\" -> \"SAMPLES\\n_sample_id_\\n*event_id*\\nfield_id\\nsource\\nid_date\\nprocessor\\nqa_qc\\nnotes\"
  
  \"SAMPLES\\n_sample_id_\\n*event_id*\\nfield_id\\nsource\\nid_date\\nprocessor\\nqa_qc\\nnotes\" -> \"OBSERVATIONS\\n_observation_id_\\n*sample_id*\\n*taxon_id*\\nlife_stage\\nlength_mm\\nweight_mg\\na\\nb\"
  
  \"TAXONOMY\\n_taxon_id_\\norder_name\\nfamily\\ngenus\\ncommon_name\\nfunctional_group\" -> \"OBSERVATIONS\\n_observation_id_\\n*sample_id*\\n*taxon_id*\\nlife_stage\\nlength_mm\\nweight_mg\\na\\nb\"
}
")
