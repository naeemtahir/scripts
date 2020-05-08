BEGIN {
    print "Time,Direction,Source,Source Port,Destination,Destination Port,Protocol,Status"
}
{ 
	# Remove extraneous fields
	sub(/MAC[^ ]*/,""); 
	sub(/LEN[^ ]*/,""); 
	sub(/TOS[^ ]*/,""); 
	sub(/PREC[^ ]*/,"");
	sub(/TTL[^ ]*/,"");
	sub(/ID[^ ]*/,"");
	sub(/DF/,"");
	
	# Classify traffic based on its flow
	sub(/IN=br0 OUT=vlan1/,"OUT")  
	sub(/IN=vlan1 OUT=/,"IN")   
	sub(/IN=br0 OUT=/,"LOCAL")
	
	# Set optional fields if available
	spt = ""
	dpt = ""
	proto = ""
	for(i = 1; i <= NF; i++) {
		if (match($i, "SPT")) {
			spt = $i
			sub(/SPT=/,"", spt); 
		} else if (match($i, "DPT")) {
			dpt = $i
			sub(/DPT=/,"", dpt); 
		} else if (match($i, "PROTO")) {
			proto = $i
			sub(/PROTO=/,"", proto); 
		} 
	}
	
	# Resolve source IP
	sub(/SRC=/,""); 
	resolve_src = "host "$8;
	resolve_src | getline srchost;
	close(resolve_src)
	len_s = split(srchost, s)
	shost = s[len_s]
	if (shost == "3(NXDOMAIN)")
		shost = $8
	else
		shost = substr(shost, 1, length(shost)-1)

	# Resolve destination IP
	sub(/DST=/,""); 
	resolve_dst = "host "$9;
	resolve_dst | getline dsthost;
	close(resolve_dst)
	len_d = split(dsthost, d)
	dhost = d[len_d]
	if (dhost == "3(NXDOMAIN)")
		dhost = $9
	else
		dhost = substr(dhost, 1, length(dhost)-1)

	# Print CSV (Time,Direction,Source,Source Port,Destination,Destination Port,Protocol,Status)
	printf "%s %s %s,%s,%s,%s,%s,%s,%s,%s\n", $1, $2, $3, $7, shost, spt, dhost, dpt, proto, $6
}