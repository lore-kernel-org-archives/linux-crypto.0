From: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: hanging modprobe aes_s390
Date: Tue, 24 Feb 2009 18:52:04 +0000
Message-ID: <1235501524.17311.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:53814 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759560AbZBXRwm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Feb 2009 12:52:42 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate5.de.ibm.com (8.14.3/8.13.8) with ESMTP id n1OHppih345798
	for <linux-crypto@vger.kernel.org>; Tue, 24 Feb 2009 17:51:51 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n1OHppPQ2252850
	for <linux-crypto@vger.kernel.org>; Tue, 24 Feb 2009 18:51:51 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n1OHppWh011157
	for <linux-crypto@vger.kernel.org>; Tue, 24 Feb 2009 18:51:51 +0100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

commit 73d3864a4823abda19ebc4387b6ddcbf416e3a77 leads to a
hanging modprobe aes_s390 process. If the process is 
interrupted the following oops occurs:

------------[ cut here ]------------
Badness at crypto/algapi.c:293
Modules linked in: aes_generic aes_s390(+) binfmt_misc
CPU: 0 Not tainted 2.6.27-rc5-00010-g1aa4ecd #23
Process modprobe (pid: 3401, task: 000000003ea2c048, ksp: 000000003eb13b78)
Krnl PSW : 0704100180000000 000000000013af2c (crypto_wait_for_test+0x74/0x80)
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:1 PM:0 EA:3
Krnl GPRS: 00000000010a4000 000000003eb14000 fffffffffffffe00 0000000000000000
           000000000013af12 00000000003e8900 0000000000007aa8 0000000000000000
           0000000000458048 000000003eb10000 000003e000017000 000003e000000000
           000000003d6cc600 00000000002dcfc8 000000000013af12 000000003eb13d18
Krnl Code: 000000000013af1c: ebcff0a00004       lmg     %r12,%r15,160(%r15)
           000000000013af22: c0f4ffffedf1       brcl    15,138b04
           000000000013af28: a7f40001           brc     15,13af2a
          >000000000013af2c: a7f4fff6           brc     15,13af18
           000000000013af30: a7f40001           brc     15,13af32
           000000000013af34: a7f4fff2           brc     15,13af18
           000000000013af38: ebcff0780024       stmg    %r12,%r15,120(%r15)
           000000000013af3e: a7f13f00           tmll    %r15,16128
Call Trace:
([<000000000013af12>] crypto_wait_for_test+0x5a/0x80)
 [<000000000013b288>] crypto_register_alg+0x80/0x98
 [<000003e000017136>] aes_s390_init+0x136/0x1e4 [aes_s390]
 [<00000000000120c0>] do_one_initcall+0x40/0x17c
 [<000000000006618e>] sys_init_module+0xc6/0x1e4
 [<0000000000023d18>] sysc_noemu+0x10/0x16
 [<000002000011cda2>] 0x2000011cda2
Last Breaking-Event-Address:
 [<000000000013af28>] crypto_wait_for_test+0x70/0x80

That only happens if the aes_generic module isn't loaded. If
aes_generic is already present the aes_s390 loads without problems.

Any idea how to solve this? Is something missing in the fallback code
that uses aes_generic?

Cheers, Jan


