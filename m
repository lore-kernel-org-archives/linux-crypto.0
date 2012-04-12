From: Dale Amon <amon@vnl.com>
Subject: cryptsetup stopped working
Date: Thu, 12 Apr 2012 23:59:40 +0100
Message-ID: <20120412225940.GA3257@vnl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: amon@vnl.com
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from grendel.xisp.net ([96.255.255.193]:41346 "EHLO ba-blue.xisp.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751197Ab2DLXhy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Apr 2012 19:37:54 -0400
Received: from otv2 (cpc6-glen4-2-0-cust217.2-1.cable.virginmedia.com [80.4.162.218])
	by ba-blue.xisp.net (8.13.8/8.13.8) with ESMTP id q3CNbNsr017008
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <linux-crypto@vger.kernel.org>; Thu, 12 Apr 2012 19:37:26 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Here is a trace of shell script I am working on. I got
through the cryptsetup earlier this evening but for some
reason it just stopped working. 

Just in case, I've rebooted to see if anything needed 
tidied up. Nope.

I also tried using loop1 instead. Also no difference.

When the cfdisk ran, I gave it a single Primary 
partition that takes all the space and is not marked 
Bootable.

At the point of failure /dev/mapper/loop9p1 exists and
I can 'cat' it, so the kpartx is happy enough with the file.

Ideas welcome...

-------------------------------------------------------------

+ dd if=/dev/zero of=/MyDisk/foo.raw count=2097152
2097152+0 records in
2097152+0 records out
1073741824 bytes (1.1 GB) copied, 28.2482 s, 38.0 MB/s
+ losetup /dev/loop0 /MyDisk/foo.raw
+ badblocks -c 10240 -s -w -t random -v /dev/loop0
Checking for bad blocks in read-write mode
>From block 0 to 1048575
Testing with random pattern: done                                
Reading and comparing: done                                
Pass completed, 0 bad blocks found.
+ cfdisk /dev/loop0

+ kpartx -a /dev/loop0
+ cryptsetup --verbose --verify-passphrase luksFormat /dev/mapper/loop0p1

WARNING!
========
This will overwrite data on /dev/mapper/loop0p1 irrevocably.

Are you sure? (Type uppercase yes): yes
Command failed with code 22: Invalid argument
