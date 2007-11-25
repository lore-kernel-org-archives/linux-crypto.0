From: Mikko Herranen <mikko.herranen@cs.helsinki.fi>
Subject: Givcipher bug?
Date: Sun, 25 Nov 2007 13:45:20 +0200 (EET)
Message-ID: <Pine.LNX.4.64.0711251324330.3663@antarct>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154]:41795 "EHLO
	pne-smtpout4-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751851AbXKYLqF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 25 Nov 2007 06:46:05 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

The newest cryptodev kernel hangs on "testing ctr(aes,4,8,4) encryption"
in tcrypt. Stack trace:

[<c0291520>] schedule_timeout+0x6a/0xa4
[<c0291383>] wait_for_common+0xad/0x104
[<c0291433>] wait_for_completion+0x12/0x14
[<c012a509>] call_usermodehelper_exec+0x76/0x8a
[<c012a679>] request_module+0x98/0xdc
[<c01c5be3>] crypto_larval_lookup+0x56/0x136
[<d20213f9>] crypto_givcipher_default+0x20/0x11c [crypto_blkcipher]
[<d2021512>] crypto_init_blkcipher_ops+0x1d/0xb7 [crypto_blkcipher]
[<c01c5864>] __crypto_alloc_tfm+0x5c/0x122
[<c01c5d9b>] crypto_alloc_base+0x31/0x6a
[<d20c497e>] test_cipher+0xda/0x814 [tcrypt]
[<d202751e>] init+0x151e/0x192b [tcrypt]
[<c0141505>] sys_init_module+0x122/0x1959
[<c0103f9e>] sysenter_past_esp+0x5f/0xa5

-- 
Mikko Herranen
