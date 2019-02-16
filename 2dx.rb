def ttt(_a)
	return _a.to_s.gsub("[","").gsub("]","").to_i
end
nn=ARGV[0].to_s
if nn.size >0 and /.2dx/ =~ nn
	nn2=nn.split(".")[0].to_s+".def"
	file=File.open(nn,"rb")
	file2=File.open(nn2)
	puts file.read(16).unpack("a*").to_s.gsub("[","").gsub("]","").gsub("\\x00","").gsub("\"","")
	#file1 start
	offs=ttt(file.read(4).unpack("V"))
	files=ttt(file.read(4).unpack("V"))
	file.seek(offs-files*4)
	$fhead=[0,0]
	$qzi=[0,0]
	for i in 0..(files-1)
		$fhead[i] = ttt(file.read(4).unpack("V"))
		#$fhead[i]=$fhead[i]+".2DX9"
	end
	$fhead[files]=file.size
	$fhead.each do |line|
		puts "offset 0x#{line.to_s(16)}"
	end
	quzi=0
	file2.each_line do |pline|
		$qzi[quzi]=pline.chomp("\n").split(" ")[1].to_s+".2DX9"
		quzi+=1
	end
	#puts $qzi[2]
	q1=0
	q2=1
	file3=File.open("un.bms","a")
	for m in 0..(files-1)
		file3.print "log \"",$qzi[m],"\" 0x",$fhead[q1].to_s(16)," 0x",($fhead[q2]-$fhead[q1]).to_s(16)
		file3.print "\n"
		q1+=1
		q2+=1
	end
	file3.close
	file2.close
	file.close
	system "quickbms.exe un.bms #{nn}"
	system "del un.bms"
	for ff in 0..(files-1)
		vv=File.open($qzi[ff].to_s,"rb")
		vv.seek(4)
		_file_name=$qzi[ff].gsub(".2DX9","")+".wav"
		_file_off=ttt(vv.read(4).unpack("V"))
		_file_size=vv.size.to_i-_file_off.to_i
		file4=File.open("re.bms","a")
		file4.print "log \"",_file_name,"\" 0x",_file_off.to_s(16)," 0x",_file_size.to_s(16)
		file4.print "\n"
		file4.close
		system "quickbms.exe re.bms #{$qzi[ff]}"
		system "del re.bms"
	end
	#for dd in 0..(files-1)
	#	system "del #{$qzi[dd]}"
	#end
else
	print "2dx?"
end