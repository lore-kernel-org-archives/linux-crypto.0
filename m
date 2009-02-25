From: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: Re: hanging modprobe aes_s390
Date: Wed, 25 Feb 2009 17:33:50 +0000
Message-ID: <1235583230.17311.57.camel@localhost.localdomain>
References: <20090225035137.GA31538@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-P0mlJ+GIhTmdxfZvu3wr"
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:56732 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759546AbZBYQeI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Feb 2009 11:34:08 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate7.de.ibm.com (8.14.3/8.13.8) with ESMTP id n1PGXcbF081728
	for <linux-crypto@vger.kernel.org>; Wed, 25 Feb 2009 16:33:38 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n1PGXch2897098
	for <linux-crypto@vger.kernel.org>; Wed, 25 Feb 2009 17:33:38 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n1PGXc2c001550
	for <linux-crypto@vger.kernel.org>; Wed, 25 Feb 2009 17:33:38 +0100
In-Reply-To: <20090225035137.GA31538@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-P0mlJ+GIhTmdxfZvu3wr
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, 2009-02-25 at 11:51 +0800, Herbert Xu wrote:
> Jan Glauber <jang@linux.vnet.ibm.com> wrote:
> >
> > That only happens if the aes_generic module isn't loaded. If
> > aes_generic is already present the aes_s390 loads without problems.
> > 
> > Any idea how to solve this? Is something missing in the fallback code
> > that uses aes_generic?
> 
> Yeah it looks like it's waiting for the fallback to come up.
> However, the interesting bit is in the other processes, i.e., the
> one that's actually testing aes_s390 or constructing the aes-generic.
> 
> Could you get those back traces please?

I've found 4 processes/threads that seem to be involved. And in case
that is relevant the oops message occured 3 times, see the attachment.

STACK TRACE FOR TASK: 0x394e37c8 (modprobe)

 STACK:
 0 schedule+1136 [0x2df82c]
 1 schedule_timeout+198 [0x2e016e]
 2 wait_for_common+256 [0x2df14c]
 3 wait_for_completion_interruptible+56 [0x2df2ac]
 4 crypto_wait_for_test+94 [0x16a28a]
 5 crypto_register_alg+132 [0x16a598]
 6 <sym not found>+<ERROR> [0x3e000daa13a]
 7 do_one_initcall+68 [0x120c4]
 8 sys_init_module+206 [0x825da]
 9 sysc_noemu+16 [0x27a5e]

STACK TRACE FOR TASK: 0x3dcc4a60 (cryptomgr_test)

 STACK:
 0 schedule+1136 [0x2df82c]
 1 schedule_timeout+198 [0x2e016e]
 2 wait_for_common+256 [0x2df14c]
 3 wait_for_completion+56 [0x2df344]
 4 call_usermodehelper_exec+152 [0x5aec8]
 5 request_module+272 [0x5b15c]
 6 crypto_larval_lookup+176 [0x1681ec]
 7 crypto_alg_mod_lookup+70 [0x1682f6]
 8 crypto_alloc_base+70 [0x168416]
 9 <sym not found>+<ERROR> [0x3e000d92d18]
10 __crypto_alloc_tfm+166 [0x16797a]
11 crypto_alloc_base+100 [0x168434]
12 alg_test+280 [0x17159c]
13 cryptomgr_test+80 [0x16fb4c]
14 kthread+106 [0x60d4a]
15 kernel_thread_starter+6 [0x1b01a]

STACK TRACE FOR TASK: 0x394fb7c8 (khelper)

 STACK:
 0 schedule+1136 [0x2df82c]
 1 do_wait+672 [0x480c0]
 2 sys_wait4+160 [0x48330]
 3 wait_for_helper+102 [0x5afe2]
 4 kernel_thread_starter+6 [0x1b01a]

STACK TRACE FOR TASK: 0x3f6137c8 (modprobe)

 STACK:
 0 schedule+1136 [0x2df82c]
 1 fcntl_setlk+412 [0x107a0c]
 2 sys_fcntl+262 [0xd7076]
 3 sysc_noemu+16 [0x27a5e]

Cheers, Jan

--=-P0mlJ+GIhTmdxfZvu3wr
Content-Disposition: attachment; filename=oops.txt
Content-Type: text/plain; name=oops.txt; charset=us-ascii
Content-Transfer-Encoding: 7bit

aes_s390.cb83bb: AES hardware acceleration is only available for 128-bit keys
------------[ cut here ]------------
Badness at crypto/algapi.c:293
Modules linked in: aes_generic aes_s390(+) qeth_l3 qeth_l2 binfmt_misc zfcp qeth ccwgroup
CPU: 5 Not tainted 2.6.28 #25
Process modprobe (pid: 5270, task: 000000003c1e5cf8, ksp: 000000003be83a18)
Krnl PSW : 0704100180000000 000000000016a2ac (crypto_wait_for_test+0x80/0x8c)
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:1 PM:0 EA:3
Krnl GPRS: 0000000000000000 000000003be84000 fffffffffffffe00 0000000000eb8e6e
           000000000016a28a 00000000002f1b60 00000000000476b1 0000000000000000
           0000000000673048 000000003be80000 000003e000000000 000000003be83bf8
           000000003d866400 00000000002ffd20 000000000016a28a 000000003be83bf8
Krnl Code: 000000000016a2a0: ebbfb0a00004	lmg	%r11,%r15,160(%r11)
           000000000016a2a6: 07f4		bcr	15,%r4
           000000000016a2a8: a7f40001		brc	15,16a2aa
          >000000000016a2ac: a7f4fff2		brc	15,16a290
           000000000016a2b0: a7f40001		brc	15,16a2b2
           000000000016a2b4: a7f4ffee		brc	15,16a290
           000000000016a2b8: ebbff0700024	stmg	%r11,%r15,112(%r15)
           000000000016a2be: a7f13f00		tmll	%r15,16128
Call Trace:
([<000000000016a28a>] crypto_wait_for_test+0x5e/0x8c)
 [<000000000016a598>] crypto_register_alg+0x84/0x9c
 [<000003e000bce13a>] aes_s390_init+0x13a/0x1f0 [aes_s390]
 [<00000000000120c4>] do_one_initcall+0x44/0x184
 [<00000000000825da>] sys_init_module+0xce/0x1f4
 [<0000000000027a5e>] sysc_noemu+0x10/0x16
 [<000002000011fda2>] 0x2000011fda2
no locks held by modprobe/5270.
Last Breaking-Event-Address:
 [<000000000016a2a8>] crypto_wait_for_test+0x7c/0x8c
------------[ cut here ]------------
Badness at crypto/algapi.c:293
Modules linked in: aes_generic aes_s390(+) qeth_l3 qeth_l2 binfmt_misc zfcp qeth ccwgroup
CPU: 5 Tainted: G        W  2.6.28 #25
Process modprobe (pid: 5270, task: 000000003c1e5cf8, ksp: 000000003be83728)
Krnl PSW : 0704100180000000 000000000016a2ac (crypto_wait_for_test+0x80/0x8c)
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:1 PM:0 EA:3
Krnl GPRS: 0000000000000001 000000003be84000 fffffffffffffe00 00000000003aa6c4
           000000000016a28a 000000003be83c00 00000000000476b1 0000000000000000
           0000000000673048 000000003be80000 000003e000000000 000000003be83bf8
           000000003be28c00 00000000002ffd20 000000000016a28a 000000003be83bf8
Krnl Code: 000000000016a2a0: ebbfb0a00004	lmg	%r11,%r15,160(%r11)
           000000000016a2a6: 07f4		bcr	15,%r4
           000000000016a2a8: a7f40001		brc	15,16a2aa
          >000000000016a2ac: a7f4fff2		brc	15,16a290
           000000000016a2b0: a7f40001		brc	15,16a2b2
           000000000016a2b4: a7f4ffee		brc	15,16a290
           000000000016a2b8: ebbff0700024	stmg	%r11,%r15,112(%r15)
           000000000016a2be: a7f13f00		tmll	%r15,16128
Call Trace:
([<000000000016a28a>] crypto_wait_for_test+0x5e/0x8c)
 [<000000000016a598>] crypto_register_alg+0x84/0x9c
 [<000003e000bce180>] aes_s390_init+0x180/0x1f0 [aes_s390]
 [<00000000000120c4>] do_one_initcall+0x44/0x184
 [<00000000000825da>] sys_init_module+0xce/0x1f4
 [<0000000000027a5e>] sysc_noemu+0x10/0x16
 [<000002000011fda2>] 0x2000011fda2
INFO: lockdep is turned off.
Last Breaking-Event-Address:
 [<000000000016a2a8>] crypto_wait_for_test+0x7c/0x8c
------------[ cut here ]------------
Badness at crypto/algapi.c:293
Modules linked in: aes_generic aes_s390(+) qeth_l3 qeth_l2 binfmt_misc zfcp qeth ccwgroup
CPU: 5 Tainted: G        W  2.6.28 #25
Process modprobe (pid: 5270, task: 000000003c1e5cf8, ksp: 000000003be83728)
Krnl PSW : 0704100180000000 000000000016a2ac (crypto_wait_for_test+0x80/0x8c)
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:1 PM:0 EA:3
Krnl GPRS: 0000000000000001 000000003be84000 fffffffffffffe00 00000000003aa6c4
           000000000016a28a 000000003be83c00 00000000000476b1 0000000000000000
           0000000000673048 000000003be80000 000003e000000000 000000003be83bf8
           000000003be28c00 00000000002ffd20 000000000016a28a 000000003be83bf8
Krnl Code: 000000000016a2a0: ebbfb0a00004	lmg	%r11,%r15,160(%r11)
           000000000016a2a6: 07f4		bcr	15,%r4
           000000000016a2a8: a7f40001		brc	15,16a2aa
          >000000000016a2ac: a7f4fff2		brc	15,16a290
           000000000016a2b0: a7f40001		brc	15,16a2b2
           000000000016a2b4: a7f4ffee		brc	15,16a290
           000000000016a2b8: ebbff0700024	stmg	%r11,%r15,112(%r15)
           000000000016a2be: a7f13f00		tmll	%r15,16128
Call Trace:
([<000000000016a28a>] crypto_wait_for_test+0x5e/0x8c)
 [<000000000016a598>] crypto_register_alg+0x84/0x9c
 [<000003e000bce192>] aes_s390_init+0x192/0x1f0 [aes_s390]
 [<00000000000120c4>] do_one_initcall+0x44/0x184
 [<00000000000825da>] sys_init_module+0xce/0x1f4
 [<0000000000027a5e>] sysc_noemu+0x10/0x16
 [<000002000011fda2>] 0x2000011fda2
INFO: lockdep is turned off.
Last Breaking-Event-Address:
 [<000000000016a2a8>] crypto_wait_for_test+0x7c/0x8c
alg: Unexpected test result for aes-s390: 0

--=-P0mlJ+GIhTmdxfZvu3wr--

