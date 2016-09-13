From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/2] crypto: arm64/aes-ctr: fix NULL dereference in tail processing
Date: Tue, 13 Sep 2016 09:48:53 +0100
Message-ID: <1473756533-21078-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1473756533-21078-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: xiakaixu@huawei.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:38227 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756474AbcIMItB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Sep 2016 04:49:01 -0400
Received: by mail-wm0-f50.google.com with SMTP id 1so187941171wmz.1
        for <linux-crypto@vger.kernel.org>; Tue, 13 Sep 2016 01:49:01 -0700 (PDT)
In-Reply-To: <1473756533-21078-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The AES-CTR glue code avoids calling into the blkcipher API for the
tail portion of the walk, by comparing the remainder of walk.nbytes
modulo AES_BLOCK_SIZE with the residual nbytes, and jumping straight
into the tail processing block if they are equal. This tail processing
block checks whether nbytes != 0, and does nothing otherwise.

However, in case of an allocation failure in the blkcipher layer, we
may enter this code with walk.nbytes == 0, while nbytes > 0. In this
case, we should not dereference the source and destination pointers,
since they may be NULL. So instead of checking for nbytes != 0, check
for (walk.nbytes % AES_BLOCK_SIZE) != 0, which implies the former in
non-error conditions.

Fixes: 49788fe2a128 ("arm64/crypto: AES-ECB/CBC/CTR/XTS using ARMv8 NEON and Crypto Extensions")
Reported-by: xiakaixu <xiakaixu@huawei.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/crypto/aes-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
index 5c888049d061..6b2aa0fd6cd0 100644
--- a/arch/arm64/crypto/aes-glue.c
+++ b/arch/arm64/crypto/aes-glue.c
@@ -216,7 +216,7 @@ static int ctr_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
 		err = blkcipher_walk_done(desc, &walk,
 					  walk.nbytes % AES_BLOCK_SIZE);
 	}
-	if (nbytes) {
+	if (walk.nbytes % AES_BLOCK_SIZE) {
 		u8 *tdst = walk.dst.virt.addr + blocks * AES_BLOCK_SIZE;
 		u8 *tsrc = walk.src.virt.addr + blocks * AES_BLOCK_SIZE;
 		u8 __aligned(8) tail[AES_BLOCK_SIZE];
-- 
2.7.4
