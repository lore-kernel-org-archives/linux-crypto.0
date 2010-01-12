From: Karl Hiramoto <karl@hiramoto.org>
Subject: [PATCH] ixp4xx_crypto: fix possible sleep while atomic
Date: Tue, 12 Jan 2010 16:06:05 +0100
Message-ID: <1263308765-17427-1-git-send-email-karl@hiramoto.org>
Cc: linux-crypto@vger.kernel.org, Karl Hiramoto <karl@hiramoto.org>
To: chohnstaedt@innominate.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:57395 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab0ALPIM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jan 2010 10:08:12 -0500
Received: from homiemail-a27.g.dreamhost.com (caiajhbdcahe.dreamhost.com [208.97.132.74])
	by hapkido.dreamhost.com (Postfix) with ESMTP id 8311C17828E
	for <linux-crypto@vger.kernel.org>; Tue, 12 Jan 2010 07:07:25 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

use GFP_ATOMIC to allocate crypt_virt

BUG: sleeping function called from invalid context at mm/page_alloc.c:1470
in_atomic(): 0, irqs_disabled(): 128, pid: 1376, name: cryptomgr_test
1 lock held by cryptomgr_test/1376:
 #0:  (&desc_lock){....}, at: [<bf147050>] get_crypt_desc+0x14/0xe8 [ixp4xx_crypto]
[<c0028954>] (dump_stack+0x0/0x14) from [<c0030f2c>] (__might_sleep+0xcc/0xe8)
[<c0030e60>] (__might_sleep+0x0/0xe8) from [<c00676e4>] (__alloc_pages_internal+0xa4/0x430)
 r4:000000d0
[<c0067640>] (__alloc_pages_internal+0x0/0x430) from [<c0029ea8>] (__dma_alloc+0x180/0x3e8)
[<c0029d28>] (__dma_alloc+0x0/0x3e8) from [<c002a198>] (dma_alloc_coherent+0x58/0x64)
[<c002a140>] (dma_alloc_coherent+0x0/0x64) from [<bf147078>] (get_crypt_desc+0x3c/0xe8 [ixp4xx_crypto])
 r7:c3bc3ce8 r6:c3bc3cc0 r5:20000013 r4:bf14a81c
[<bf14703c>] (get_crypt_desc+0x0/0xe8 [ixp4xx_crypto]) from [<bf147788>] (ablk_perform+0x68/0x248 [ixp4xx_crypto])
 r7:c3bc3ce8 r6:c3bc3cc0 r5:c2cefc2c r4:00000000
[<bf147720>] (ablk_perform+0x0/0x248 [ixp4xx_crypto]) from [<bf1479f0>] (ablk_encrypt+0x14/0x18 [ixp4xx_crypto])
[<bf1479dc>] (ablk_encrypt+0x0/0x18 [ixp4xx_crypto]) from [<c012bf4c>] (test_skcipher+0x1bc/0x668)
[<c012bd90>] (test_skcipher+0x0/0x668) from [<c012d428>] (alg_test_skcipher+0x60/0xa0)
[<c012d3c8>] (alg_test_skcipher+0x0/0xa0) from [<c012ce84>] (alg_test+0x128/0x160)
 r7:00000000 r6:00000286 r5:c39ddd80 r4:c39dddc0
[<c012cd5c>] (alg_test+0x0/0x160) from [<c012bb0c>] (cryptomgr_test+0x38/0x58)
[<c012bad4>] (cryptomgr_test+0x0/0x58) from [<c004bc7c>] (kthread+0x58/0x90)
 r4:c2e38000
[<c004bc24>] (kthread+0x0/0x90) from [<c0039ed4>] (do_exit+0x0/0x6d0)
 r6:00000000 r5:00000000 r4:00000000

Note this is somewhat hard to reproduce, but can be reproduced under memory pressure when you first initialize ixp4xx_crypto.

Signed-off-by: Karl Hiramoto <karl@hiramoto.org>
---
 drivers/crypto/ixp4xx_crypto.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 6c6656d..564d68f 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -246,7 +246,7 @@ static int setup_crypt_desc(void)
 	BUILD_BUG_ON(sizeof(struct crypt_ctl) != 64);
 	crypt_virt = dma_alloc_coherent(dev,
 			NPE_QLEN * sizeof(struct crypt_ctl),
-			&crypt_phys, GFP_KERNEL);
+			&crypt_phys, GFP_ATOMIC);
 	if (!crypt_virt)
 		return -ENOMEM;
 	memset(crypt_virt, 0, NPE_QLEN * sizeof(struct crypt_ctl));
-- 
1.6.4.4

