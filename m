Return-Path: <SRS0=edWn=O6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:65320 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730509AbeLUIHz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Dec 2018 03:07:55 -0500
Message-Id: <ae7b64e9415874060977e32ed48b62f1f6148084.1545346337.git.christophe.leroy@c-s.fr>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v3] crypto: talitos - fix ablkcipher for CONFIG_VMAP_STACK
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Horia Geanta <horia.geanta@nxp.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
Date: Fri, 21 Dec 2018 08:07:52 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[    2.364486] WARNING: CPU: 0 PID: 60 at ./arch/powerpc/include/asm/io.h:837 dma_nommu_map_page+0x44/0xd4
[    2.373579] CPU: 0 PID: 60 Comm: cryptomgr_test Tainted: G        W         4.20.0-rc5-00560-g6bfb52e23a00-dirty #531
[    2.384740] NIP:  c000c540 LR: c000c584 CTR: 00000000
[    2.389743] REGS: c95abab0 TRAP: 0700   Tainted: G        W          (4.20.0-rc5-00560-g6bfb52e23a00-dirty)
[    2.400042] MSR:  00029032 <EE,ME,IR,DR,RI>  CR: 24042204  XER: 00000000
[    2.406669]
[    2.406669] GPR00: c02f2244 c95abb60 c6262990 c95abd80 0000256a 00000001 00000001 00000001
[    2.406669] GPR08: 00000000 00002000 00000010 00000010 24042202 00000000 00000100 c95abd88
[    2.406669] GPR16: 00000000 c05569d4 00000001 00000010 c95abc88 c0615664 00000004 00000000
[    2.406669] GPR24: 00000010 c95abc88 c95abc88 00000000 c61ae210 c7ff6d40 c61ae210 00003d68
[    2.441559] NIP [c000c540] dma_nommu_map_page+0x44/0xd4
[    2.446720] LR [c000c584] dma_nommu_map_page+0x88/0xd4
[    2.451762] Call Trace:
[    2.454195] [c95abb60] [82000808] 0x82000808 (unreliable)
[    2.459572] [c95abb80] [c02f2244] talitos_edesc_alloc+0xbc/0x3c8
[    2.465493] [c95abbb0] [c02f2600] ablkcipher_edesc_alloc+0x4c/0x5c
[    2.471606] [c95abbd0] [c02f4ed0] ablkcipher_encrypt+0x20/0x64
[    2.477389] [c95abbe0] [c02023b0] __test_skcipher+0x4bc/0xa08
[    2.483049] [c95abe00] [c0204b60] test_skcipher+0x2c/0xcc
[    2.488385] [c95abe20] [c0204c48] alg_test_skcipher+0x48/0xbc
[    2.494064] [c95abe40] [c0205cec] alg_test+0x164/0x2e8
[    2.499142] [c95abf00] [c0200dec] cryptomgr_test+0x48/0x50
[    2.504558] [c95abf10] [c0039ff4] kthread+0xe4/0x110
[    2.509471] [c95abf40] [c000e1d0] ret_from_kernel_thread+0x14/0x1c
[    2.515532] Instruction dump:
[    2.518468] 7c7e1b78 7c9d2378 7cbf2b78 41820054 3d20c076 8089c200 3d20c076 7c84e850
[    2.526127] 8129c204 7c842e70 7f844840 419c0008 <0fe00000> 2f9e0000 54847022 7c84fa14
[    2.533960] ---[ end trace bf78d94af73fe3b8 ]---
[    2.539123] talitos ff020000.crypto: master data transfer error
[    2.544775] talitos ff020000.crypto: TEA error: ISR 0x20000000_00000040
[    2.551625] alg: skcipher: encryption failed on test 1 for ecb-aes-talitos: ret=22

IV cannot be on stack when CONFIG_VMAP_STACK is selected because the stack
cannot be DMA mapped anymore.

This patch copies the IV into the extended descriptor when iv is not
a valid linear address.

Fixes: 4de9d0b547b9 ("crypto: talitos - Add ablkcipher algorithms")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 v3: Using struct edesc buffer.

 v2: Using per-request context.

 drivers/crypto/talitos.c | 35 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 6988012deca4..160702b119bb 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1355,29 +1355,23 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 {
 	struct talitos_edesc *edesc;
 	int src_nents, dst_nents, alloc_len, dma_len, src_len, dst_len;
-	dma_addr_t iv_dma = 0;
 	gfp_t flags = cryptoflags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
 		      GFP_ATOMIC;
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	bool is_sec1 = has_ftr_sec1(priv);
 	int max_len = is_sec1 ? TALITOS1_MAX_DATA_LEN : TALITOS2_MAX_DATA_LEN;
-	void *err;
 
 	if (cryptlen + authsize > max_len) {
 		dev_err(dev, "length exceeds h/w max limit\n");
 		return ERR_PTR(-EINVAL);
 	}
 
-	if (ivsize)
-		iv_dma = dma_map_single(dev, iv, ivsize, DMA_TO_DEVICE);
-
 	if (!dst || dst == src) {
 		src_len = assoclen + cryptlen + authsize;
 		src_nents = sg_nents_for_len(src, src_len);
 		if (src_nents < 0) {
 			dev_err(dev, "Invalid number of src SG.\n");
-			err = ERR_PTR(-EINVAL);
-			goto error_sg;
+			return ERR_PTR(-EINVAL);
 		}
 		src_nents = (src_nents == 1) ? 0 : src_nents;
 		dst_nents = dst ? src_nents : 0;
@@ -1387,16 +1381,14 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 		src_nents = sg_nents_for_len(src, src_len);
 		if (src_nents < 0) {
 			dev_err(dev, "Invalid number of src SG.\n");
-			err = ERR_PTR(-EINVAL);
-			goto error_sg;
+			return ERR_PTR(-EINVAL);
 		}
 		src_nents = (src_nents == 1) ? 0 : src_nents;
 		dst_len = assoclen + cryptlen + (encrypt ? authsize : 0);
 		dst_nents = sg_nents_for_len(dst, dst_len);
 		if (dst_nents < 0) {
 			dev_err(dev, "Invalid number of dst SG.\n");
-			err = ERR_PTR(-EINVAL);
-			goto error_sg;
+			return ERR_PTR(-EINVAL);
 		}
 		dst_nents = (dst_nents == 1) ? 0 : dst_nents;
 	}
@@ -1423,17 +1415,24 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 	/* if its a ahash, add space for a second desc next to the first one */
 	if (is_sec1 && !dst)
 		alloc_len += sizeof(struct talitos_desc);
+	if (ivsize && !virt_addr_valid(iv))
+		alloc_len += ivsize;
 
 	edesc = kmalloc(alloc_len, GFP_DMA | flags);
-	if (!edesc) {
-		err = ERR_PTR(-ENOMEM);
-		goto error_sg;
-	}
+	if (!edesc)
+		return ERR_PTR(-ENOMEM);
 	memset(&edesc->desc, 0, sizeof(edesc->desc));
 
+	if (ivsize && !virt_addr_valid(iv))
+		iv = memcpy(((u8 *)edesc) + alloc_len - ivsize, iv, ivsize);
+
 	edesc->src_nents = src_nents;
 	edesc->dst_nents = dst_nents;
-	edesc->iv_dma = iv_dma;
+	if (ivsize)
+		edesc->iv_dma = dma_map_single(dev, iv, ivsize, DMA_TO_DEVICE);
+	else
+		edesc->iv_dma = 0;
+
 	edesc->dma_len = dma_len;
 	if (dma_len) {
 		void *addr = &edesc->link_tbl[0];
@@ -1445,10 +1444,6 @@ static struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 						     DMA_BIDIRECTIONAL);
 	}
 	return edesc;
-error_sg:
-	if (iv_dma)
-		dma_unmap_single(dev, iv_dma, ivsize, DMA_TO_DEVICE);
-	return err;
 }
 
 static struct talitos_edesc *aead_edesc_alloc(struct aead_request *areq, u8 *iv,
-- 
2.13.3
