cd /scratch/erin/Ulithi23/02_symbiont_composition/00_references
# Symbiodinium=2949
# Taxonomy identifiers for various clades
# Cladocopium=2486696
# Montipora=467036699
# Symbiodinium=2949
# Breviolum=2499524
# Cladocopium=2486696
# Durusdinium=2486699s must contain “|kraken:taxid|$TAXID”.
# Effrenium=2562238
# Fugacium=2558456
# Ulithi Montipora sp.
# Kraken FASTA headers must contain “|kraken:taxid|$TAXID”.}' 01_original_format/Montipora_sp1_aff_capitata_ULFMv1.assembly.fasta > 02_genome_krakenfa/Msp1.fa

# Ulithi Montipora sp.ata
awk '/^>/ { print $0 "|kraken:taxid|46703"; next } { print }' 01_original_format/Montipora_sp1_aff_capitata_ULFMv1.assembly.fasta > 02_genome_krakenfa/Msp1.fa/Montipora_capitata_KBHIv3.assembly.fasta > 02_genome_krakenfa/Mcap.fa
# KBay Montipora capitata
awk '/^>/ { print $0 "|kraken:taxid|46703"; next } { print }' 01_original_format/Montipora_capitata_KBHIv3.assembly.fasta > 02_genome_krakenfa/Mcap.fa

# Symbiodinium
awk '/^>/ { print $0 "|kraken:taxid|2949"; next } { print }' 01_original_format/Symbiodinium_microadriaticum_CCMP2467.Smic1.1.assembly.fasta > 02_genome_krakenfa/Smic.fa

# Breviolum
awk '/^>/ { print $0 "|kraken:taxid|2499524"; next } { print }' 01_original_format/Breviolum_minutum_RT002.pyBreMinu3.1.assembly.fasta > 02_genome_krakenfa/Bmin.fa

# Cladocopium
awk '/^>/ { print $0 "|kraken:taxid|2486696"; next } { print }' 01_original_format/Cladocopium_goreaui_SCF055.Cgor1.1.assembly.fasta > 02_genome_krakenfa/Cgor.fa

# Durusdinium
awk '/^>/ { print $0 "|kraken:taxid|2486699"; next } { print }' 01_original_format/Durusdinium_trenchii_CCMP2556.Dtren1.1.assembly.fasta > 02_genome_krakenfa/Dtre.fa

# Effrenium
awk '/^>/ { print $0 "|kraken:taxid|2562238"; next } { print }' 01_original_format/Effrenium_voratum_CCMP3420.Evrt383.1.assembly.fasta > 02_genome_krakenfa/Evor.fa

# Fugacium
awk '/^>/ { print $0 "|kraken:taxid|2558456"; next } { print }' 01_original_format/Fugacium_kawagutii_CCMP2468.Fkaw3.1.assembly.fasta > 02_genome_krakenfa/Fkaw.fa