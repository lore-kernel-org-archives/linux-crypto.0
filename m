From: Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
Subject: Bug when modprobing tcrypt
Date: Mon, 29 Jun 2009 15:17:05 +0200
Message-ID: <1246281425.3688.13.camel@queen>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.pawisda.de ([213.157.4.156]:35001 "EHLO
	mailrelay.pawisda.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbZF2Ni3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 29 Jun 2009 09:38:29 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

i can repeatedly trigger the following bug when modprobing tcrypt
to test the crypto algorithms with todays -git

[  122.967099] BUG: sleeping function called from invalid context at
kernel/rwsem.c:21
[  122.967398] in_atomic(): 1, irqs_disabled(): 0, pid: 4926, name:
modprobe
[  122.967643] INFO: lockdep is turned off.
[  122.967858] Pid: 4926, comm: modprobe Tainted: G   M
2.6.31-rc1-22297-g5298976 #24
[  122.968176] Call Trace:
[  122.968411]  [<c011dd93>] __might_sleep+0xf9/0x101
[  122.968677]  [<c0777aa0>] down_read+0x16/0x68
[  122.968928]  [<c048bf04>] crypto_alg_lookup+0x16/0x34
[  122.969479]  [<c048bf52>] crypto_larval_lookup+0x30/0xf9
[  122.969722]  [<c048c038>] crypto_alg_mod_lookup+0x1d/0x62
[  122.969977]  [<c048c13e>] crypto_alloc_base+0x1e/0x64
[  122.970271]  [<c04bf991>] reset_prng_context+0xab/0x13f
[  122.970523]  [<c04e5cfc>] ? __spin_lock_init+0x27/0x51
[  122.970777]  [<c04bfce1>] cprng_init+0x2a/0x42
[  122.971012]  [<c048bb4c>] __crypto_alloc_tfm+0xfa/0x128
[  122.971304]  [<c048c153>] crypto_alloc_base+0x33/0x64
[  122.971556]  [<c04933c9>] alg_test_cprng+0x30/0x1f4
[  122.971809]  [<c0493329>] alg_test+0x12f/0x19f
[  122.972103]  [<c0177f1f>] ? __alloc_pages_nodemask+0x14d/0x481
[  122.972356]  [<d09219e2>] do_test+0xf9d/0x163f [tcrypt]
[  122.972613]  [<d0920de6>] do_test+0x3a1/0x163f [tcrypt]
[  122.972855]  [<d0926035>] tcrypt_mod_init+0x35/0x7c [tcrypt]
[  122.973488]  [<c010113c>] _stext+0x54/0x12c
[  122.974575]  [<d0926000>] ? tcrypt_mod_init+0x0/0x7c [tcrypt]
[  122.974836]  [<c01398a3>] ? up_read+0x16/0x2b
[  122.975126]  [<c0139fc4>] ? __blocking_notifier_call_chain+0x40/0x4c
[  122.975376]  [<c014ee8d>] sys_init_module+0xa9/0x1bf
[  122.975635]  [<c010292b>] sysenter_do_call+0x12/0x32

(gdb) l *(crypto_alg_lookup+0x16)
0xc048bf04 is in crypto_alg_lookup (crypto/api.c:201).
196	struct crypto_alg *crypto_alg_lookup(const char *name, u32 type, u32
mask)
197	{
198		struct crypto_alg *alg;
199	
200		down_read(&crypto_alg_sem);
201		alg = __crypto_alg_lookup(name, type, mask);
202		up_read(&crypto_alg_sem);
203	
204		return alg;
205	}

Please let me know if you need further information or have patches to
test.

Regards, Eric

