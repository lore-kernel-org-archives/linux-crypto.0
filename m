From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH 05/10] crypto: caam - fix DMA unmapping error in hash_digest_key
Date: Fri, 11 Jul 2014 15:34:50 +0300
Message-ID: <1405082095-30146-6-git-send-email-horia.geanta@freescale.com>
References: <1405082095-30146-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Ruchika Gupta <ruchika.gupta@freescale.com>,
	Vakul Garg <vakul@freescale.com>,
	Kim Phillips <kim.phillips@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:38093
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753507AbaGKMgO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Jul 2014 08:36:14 -0400
In-Reply-To: <1405082095-30146-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Key being hashed is unmapped using the digest size instead of
initial length:

caam_jr ffe301000.jr: DMA-API: device driver frees DMA memory with different size [device address=0x000000002eeedac0] [map size=80 bytes] [unmap size=20 bytes]
------------[ cut here ]------------
WARNING: at lib/dma-debug.c:1090
Modules linked in: caamhash(+)
CPU: 0 PID: 1327 Comm: cryptomgr_test Not tainted 3.16.0-rc1 #23
task: eebda5d0 ti: ee26a000 task.ti: ee26a000
NIP: c0288790 LR: c0288790 CTR: c02d7020
REGS: ee26ba30 TRAP: 0700   Not tainted  (3.16.0-rc1)
MSR: 00021002 <CE,ME>  CR: 44022082  XER: 00000000

GPR00: c0288790 ee26bae0 eebda5d0 0000009f c1de3478 c1de382c 00000000 00021002
GPR08: 00000007 00000000 01660000 0000012f 82022082 00000000 c07a1900 eeda29c0
GPR16: 00000000 c61deea0 000c49a0 00000260 c07e1e10 c0da1180 00029002 c0d9ef08
GPR24: c07a0000 c07a4acc ee26bb38 ee2765c0 00000014 ee130210 00000000 00000014
NIP [c0288790] check_unmap+0x640/0xab0
LR [c0288790] check_unmap+0x640/0xab0
Call Trace:
[ee26bae0] [c0288790] check_unmap+0x640/0xab0 (unreliable)
[ee26bb30] [c0288c78] debug_dma_unmap_page+0x78/0x90
[ee26bbb0] [f929c3d4] ahash_setkey+0x374/0x720 [caamhash]
[ee26bc30] [c022fec8] __test_hash+0x228/0x6c0
[ee26bde0] [c0230388] test_hash+0x28/0xb0
[ee26be00] [c0230458] alg_test_hash+0x48/0xc0
[ee26be20] [c022fa94] alg_test+0x114/0x2e0
[ee26bea0] [c022cd1c] cryptomgr_test+0x4c/0x60
[ee26beb0] [c00497a4] kthread+0xc4/0xe0
[ee26bf40] [c000f2fc] ret_from_kernel_thread+0x5c/0x64
Instruction dump:
41de03e8 83da0020 3c60c06d 83fa0024 3863f520 813b0020 815b0024 80fa0018
811a001c 93c10008 93e1000c 4830cf6d <0fe00000> 3c60c06d 3863f0f4 4830cf5d
---[ end trace db1fae088c75c26c ]---
Mapped at:
 [<f929c15c>] ahash_setkey+0xfc/0x720 [caamhash]
 [<c022fec8>] __test_hash+0x228/0x6c0
 [<c0230388>] test_hash+0x28/0xb0
 [<c0230458>] alg_test_hash+0x48/0xc0
 [<c022fa94>] alg_test+0x114/0x2e0

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/caam/caamhash.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 39f7a933c8fa..9ee4e0478220 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -499,11 +499,11 @@ static int hash_digest_key(struct caam_hash_ctx *ctx, const u8 *key_in,
 			       digestsize, 1);
 #endif
 	}
-	*keylen = digestsize;
-
 	dma_unmap_single(jrdev, src_dma, *keylen, DMA_TO_DEVICE);
 	dma_unmap_single(jrdev, dst_dma, digestsize, DMA_FROM_DEVICE);
 
+	*keylen = digestsize;
+
 	kfree(desc);
 
 	return ret;
-- 
1.8.3.1
