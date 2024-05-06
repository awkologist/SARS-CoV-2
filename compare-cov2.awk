BEGIN{
if(id2=="" || seq=="" || anno==""){
  print "  Run as:"
  print "    awk -f compare-cov2.awk -v seq=seqs.tab -v anno=annos.tab -v id1=ID1 -v id2=ID2"
  print "  where seqs.tab is the sequence file in tab format and"
  print "        annos.tab is the annotation file in tab format."
  print "  If -v id1=... is omitted, the reference genome ID NC_045512.2 will be used." 
  exit}

if(id1==""){id1="NC_045512"}

while(getline < seq > 0){
    gsub(/\.[0-9]/,"",$1); # remove .2 oder so
    sequence[$1]=$2
    }

while(getline < anno > 0){gsub(/\.[0-9]/,"",$1);date[$1]=$3; place[$1]=$2}

if(sequence[id1] != "" && sequence[id2] != ""){
  print "# "id1" > "id2" | "date[id1]" > "date[id2]" | "place[id1]" > "place[id2]
  }
  else{print "ID not found!"; exit}

spike="MFVFLVLLPLVSSQCVNLTTRTQLPPAYTNSFTRGVYYPDKVFRSSVLHSTQDLFLPFFSNVTWFHAIHVSGTNGTKRFDNPVLPFNDGVYFASTEKSNIIRGWIFGTTLDSKTQSLLIVNNATNVVIKVCEFQFCNDPFLGVYYHKNNKSWMESEFRVYSSANNCTFEYVSQPFLMDLEGKQGNFKNLREFVFKNIDGYFKIYSKHTPINLVRDLPQGFSALEPLVDLPIGINITRFQTLLALHRSYLTPGDSSSGWTAGAAAYYVGYLQPRTFLLKYNENGTITDAVDCALDPLSETKCTLKSFTVEKGIYQTSNFRVQPTESIVRFPNITNLCPFGEVFNATRFASVYAWNRKRISNCVADYSVLYNSASFSTFKCYGVSPTKLNDLCFTNVYADSFVIRGDEVRQIAPGQTGKIADYNYKLPDDFTGCVIAWNSNNLDSKVGGNYNYLYRLFRKSNLKPFERDISTEIYQAGSTPCNGVEGFNCYFPLQSYGFQPTNGVGYQPYRVVVLSFELLHAPATVCGPKKSTNLVKNKCVNFNFNGLTGTGVLTESNKKFLPFQQFGRDIADTTDAVRDPQTLEILDITPCSFGGVSVITPGTNTSNQVAVLYQDVNCTEVPVAIHADQLTPTWRVYSTGSNVFQTRAGCLIGAEHVNNSYECDIPIGAGICASYQTQTNSPRRARSVASQSIIAYTMSLGAENSVAYSNNSIAIPTNFTISVTTEILPVSMTKTSVDCTMYICGDSTECSNLLLQYGSFCTQLNRALTGIAVEQDKNTQEVFAQVKQIYKTPPIKDFGGFNFSQILPDPSKPSKRSFIEDLLFNKVTLADAGFIKQYGDCLGDIAARDLICAQKFNGLTVLPPLLTDEMIAQYTSALLAGTITSGWTFGAGAALQIPFAMQMAYRFNGIGVTQNVLYENQKLIANQFNSAIGKIQDSLSSTASALGKLQDVVNQNAQALNTLVKQLSSNFGAISSVLNDILSRLDKVEAEVQIDRLITGRLQSLQTYVTQQLIRAAEIRASANLAATKMSECVLGQSKRVDFCGKGYHLMSFPQSAPHGVVFLHVTYVPAQEKNFTTAPAICHDGKAHFPREGVFVSNGTHWFVTQRNFYEPQIITTDNTFVSGNCDVVIGIVNNTVYDPLQPELDSFKEELDKYFKNHTSPDVDLGDISGINASVVNIQKEIDRLNEVAKNLNESLIDLQELGKYEQYIKWPWYIWLGFIAGLIAIVMVTIMLCCMTSCCSCLKGCCSCGSCCKFDEDDSEPVLKGVKLHYT"

split(spike,spikearray,"")

split(sequence[id1],seq1,""); split(sequence[id2],seq2,"")

for(i=1; i<=length(sequence[id1]); i++){
  if(seq1[i] == "N" || seq2[i] == "N"){n++}
  if(seq1[i] != seq2[i] && seq1[i] != "N" && seq2[i] != "N"){
	if(i >=21563 && i<= 25383){name="SPIKE NT:"i-21563+1" AA:"1+int((i-21563+1)/3)" -> "spikearray[1+int((i-21563+1)/3)]}
	if(i >=22517 && i<= 23183){name=name" RBDomain"}
	if(i >=22871 && i<= 23084){name=name" RBMotif"}
	print id2" "i": "seq1[i]">"seq2[i]" "name; 
	name=""
	ex++}
  }
if(n==""){n=0}; if(ex==""){ex=0}
print "# of N's: "n" of "length(sequence[id1])
print "# of exchanges: "ex" of "length(sequence[id1])
}
