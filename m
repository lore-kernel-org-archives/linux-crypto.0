From: =?ISO-8859-1?Q?S=E9guier_R=E9gis?= <rseguier@e-teleport.net>
Subject: Padlock SHA1 failed at boot time
Date: Sun, 20 Sep 2009 18:23:28 +0200
Message-ID: <4AB65700.5010703@e-teleport.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.e-teleport.net ([213.190.64.162]:38010 "EHLO
	smtp.e-teleport.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507AbZITQtW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 20 Sep 2009 12:49:22 -0400
Received: from [213.190.80.30] (30-80-190-213.intermediasud.com [213.190.80.30])
	by smtp.e-teleport.net (Postfix) with ESMTP id 27AF911407B
	for <linux-crypto@vger.kernel.org>; Sun, 20 Sep 2009 18:23:29 +0200 (CEST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

With 2.6.31, at boot time,i got this error.
The previous version i use was 2.6.31-rc6 and work fine for me.

cpuidle: using governor menu
padlock: Using VIA PadLock ACE for AES algorithm.
general protection fault: 0000 [#1] PREEMPT
last sysfs file:

Pid: 83, comm: cryptomgr_test Not tainted (2.6.31EPIA_NAB7500 #311)=20
CN896-8251
EIP: 0060:[<c1247ef5>] EFLAGS: 00010202 CPU: 0
EIP is at padlock_sha1_finup+0x1a2/0x1f3
EAX: 00000000 EBX: 00000003 ECX: 00000003 EDX: 00000001
ESI: f734f000 EDI: f7367c88 EBP: f7367d18 ESP: f7367c18
 DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
Process cryptomgr_test (pid: 83, ti=3Df7366000 task=3Df71c9460 task.ti=3D=
f7366000)
Stack:
 f7367ed0 f734f000 f734eee8 f734eef0 00000000 00000000 00000000 6745230=
1
<0> efcdab89 98badcfe 10325476 c3d2e1f0 00000000 00000000 00000000 0000=
0000
<0> 00000000 00000000 00000000 00000000 00000000 00000000 00000000 0000=
0000
Call Trace:
 [<c101dc1d>] ? kmap_atomic_prot+0xb5/0xc3
 [<c101dc48>] ? kmap_atomic+0x1d/0x30
 [<c1103f76>] ? hash_walk_next+0x43/0x7d
 [<c1104ccd>] ? crypto_shash_finup+0x3d/0x57
 [<c1104ed8>] ? shash_ahash_finup+0x4d/0x81
 [<c1104fff>] ? shash_ahash_digest+0xb7/0xd4
 [<c1105045>] ? shash_async_digest+0x29/0x3c
 [<c1103bc6>] ? crypto_ahash_op+0x9a/0xb6
 [<c110501c>] ? shash_async_digest+0x0/0x3c
 [<c1103bff>] ? crypto_ahash_digest+0x1d/0x30
 [<c110626a>] ? test_hash+0x196/0x53a
 [<c10fe1fd>] ? crypto_alloc_tfm+0x51/0x96
 [<c1104980>] ? crypto_alloc_shash+0x20/0x36
 [<c1247fd4>] ? padlock_cra_init+0x2a/0x6a
 [<c10fe16b>] ? crypto_create_tfm+0x67/0xa8
 [<c1104488>] ? crypto_init_shash_ops_async+0x39/0xca
 [<c110665c>] ? alg_test_hash+0x4e/0x75
 [<c1107f91>] ? alg_test+0x11a/0x171
 [<c1022291>] ? finish_task_switch+0x48/0x97
 [<c13a80c1>] ? schedule+0x364/0x385
 [<c1105614>] ? cryptomgr_test+0x0/0x48
 [<c1105642>] ? cryptomgr_test+0x2e/0x48
 [<c1039bbe>] ? kthread+0x6b/0x70
 [<c1039b53>] ? kthread+0x0/0x70
 [<c100353b>] ? kernel_thread_helper+0x7/0x10
Code: 39 c2 74 10 0f 20 c0 a8 08 74 09 0f 06 ba 01 00 00 00 eb 02 31 d2=
=20
8b 85 14 ff ff ff 8d bd 70 ff ff ff 8b b5 04 ff ff ff 8d 0c 03 <f3> 0f=20
a6 c8 85 d2 74 09 0f 20 c0 83 c8 08 0f 22 c0 8b 8d 00 ff
EIP: [<c1247ef5>] padlock_sha1_finup+0x1a2/0x1f3 SS:ESP 0068:f7367c18
---[ end trace 853c7a9cbb58c0f4 ]---
note: cryptomgr_test[83] exited with preempt_count 1



/proc/cpuinfo :
processor       : 0
vendor_id       : CentaurHauls
cpu family      : 6
model           : 10
model name      : VIA Esther processor 1500MHz
stepping        : 9
cpu MHz         : 798.040
cache size      : 128 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge=20
cmov pat clflush acpi mmx fxsr sse sse2 tm nx pni est tm2 rng rng_en ac=
e=20
ace_en ace2 ace2_en phe phe_en pmm pmm_en
bogomips        : 1596.08
clflush size    : 64
cache_alignment : 64
address sizes   : 36 bits physical, 32 bits virtual
power management:


--=20
R=E9gis S=E9guier
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
