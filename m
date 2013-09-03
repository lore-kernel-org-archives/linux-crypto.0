From: James Yonan <james@openvpn.net>
Subject: possible race in crypto_alg_mod_lookup
Date: Tue, 03 Sep 2013 06:14:20 -0600
Message-ID: <5225D29C.2000804@openvpn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from magnetar.openvpn.net ([74.52.27.18]:39958 "EHLO
	magnetar.openvpn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932814Ab3ICMud (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Sep 2013 08:50:33 -0400
Received: from moab.lan (c-24-9-78-222.hsd1.co.comcast.net [24.9.78.222])
	(authenticated bits=0)
	by magnetar.openvpn.net (8.13.1/8.13.1) with ESMTP id r83CEKTM012130
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-crypto@vger.kernel.org>; Tue, 3 Sep 2013 06:14:20 -0600
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I'm seeing a GPF when code on several CPUs calls crypto_alloc_aead at 
the same time, and in order for crypto_alloc_aead to satisfy the 
request, it needs to lookup a kernel module (in this case aesni_intel 
and aes_x86_64).

Shouldn't the bulk of the code in crypto_alg_mod_lookup be protected by 
a mutex to prevent module lookup/load races?

> [ 1215.030400] general protection fault: 0000 [#1] SMP
> [ 1215.030413] Modules linked in: gcm jytest(OF) isofs dm_crypt fb_sys_fops psmouse syscopyarea sysfillrect sysimgblt serio_raw i2c_piix4 microcode mac_hid crc32_pclmul ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd floppy
> [ 1215.030418] CPU: 31 PID: 2341 Comm: peer Tainted: GF          O 3.10.10-031010-generic #201308291422
> [ 1215.030420] Hardware name: Xen HVM domU, BIOS 4.2.amazon 06/22/2013
> [ 1215.030422] task: ffff881decef4650 ti: ffff881ded528000 task.ti: ffff881ded528000
> [ 1215.030434] RIP: 0010:[<ffffffff813158eb>]  [<ffffffff813158eb>] crypto_larval_kill+0x2b/0x90
> [ 1215.030436] RSP: 0018:ffff881ded529b20  EFLAGS: 00010282
> [ 1215.030437] RAX: dead000000200200 RBX: ffff883c5fadc200 RCX: dead000000200200
> [ 1215.030440] RDX: dead000000100100 RSI: 0000000000003a98 RDI: ffffffff81c82720
> [ 1215.030442] RBP: ffff881ded529b30 R08: 0000000000017950 R09: ffffea00f17e8800
> [ 1215.030444] R10: ffffffff81056610 R11: 0000000000000002 R12: fffffffffffffffe
> [ 1215.030446] R13: ffff881ded529bc8 R14: 0000000000000000 R15: ffff881decef4650
> [ 1215.030452] FS:  00007ffd369e6700(0000) GS:ffff883c9dde0000(0000) knlGS:0000000000000000
> [ 1215.030453] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1215.030456] CR2: 00007f256543e0c0 CR3: 0000001deb69c000 CR4: 00000000000407e0
> [ 1215.030459] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1215.030460] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 1215.030461] Stack:
> [ 1215.030468]  ffff883c5fadc200 fffffffffffffffe ffff881ded529b50 ffffffff81315dab
> [ 1215.030473]  ffffffff8183ffc0 0000000000000000 ffff881ded529ba0 ffffffff81315a8d
> [ 1215.030479]  0000000000000286 0000000000000020 ffff881ded529bc0 0000000000000000
> [ 1215.030481] Call Trace:
> [ 1215.030559] encrypt crypto_alloc_aead failed, err=-2
> [ 1215.030566]  [<ffffffff81315dab>] crypto_alg_mod_lookup+0x6b/0x90
> [ 1215.030570]  [<ffffffff81315a8d>] crypto_alloc_tfm+0x6d/0xe0
> [ 1215.030575]  [<ffffffff8131c399>] crypto_alloc_ahash+0x19/0x20
> [ 1215.030585]  [<ffffffffa001a996>] cryptd_alloc_ahash+0x76/0xb0 [cryptd]
> [ 1215.030593]  [<ffffffff811885dc>] ? __kmalloc+0x15c/0x1a0
> [ 1215.030598]  [<ffffffff81315989>] ? crypto_create_tfm+0x39/0xd0
> [ 1215.030605]  [<ffffffff817057a7>] ? wait_for_completion_interruptible_timeout+0x117/0x140
> [ 1215.030609]  [<ffffffff81315989>] ? crypto_create_tfm+0x39/0xd0
> [ 1215.030615]  [<ffffffffa02ce2c1>] ghash_async_init_tfm+0x21/0x40 [ghash_clmulni_intel]
> [ 1215.030620]  [<ffffffff813159e9>] crypto_create_tfm+0x99/0xd0
> [ 1215.030624]  [<ffffffff81316c59>] crypto_spawn_tfm2+0x39/0x70
> [ 1215.030629]  [<ffffffff811885dc>] ? __kmalloc+0x15c/0x1a0
> [ 1215.030635]  [<ffffffffa0053bdc>] crypto_gcm_init_tfm+0x2c/0xb0 [gcm]
> [ 1215.030641]  [<ffffffff81315829>] __crypto_alloc_tfm+0xc9/0x160
> [ 1215.030644]  [<ffffffff8131873b>] crypto_alloc_aead+0x6b/0xc0

  . . .

> [ 1215.030743] Code: 66 66 66 66 90 55 48 89 e5 53 48 89 fb 48 c7 c7 20 27 c8 81 48 83 ec 08 e8 e3 ec 3e 00 48 8b 13 48 8b 43 08 48 c7 c7 20 27 c8 81 <48> 89 42 08 48 89 10 48 b8 00 01 10 00 00 00 ad de 48 ba 00 02
> [ 1215.030748] RIP  [<ffffffff813158eb>] crypto_larval_kill+0x2b/0x90
> [ 1215.030749]  RSP <ffff881ded529b20>
> [ 1215.039543] ---[ end trace 3599c09d681d8550 ]---

James
