From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/2] crypto: arm/aes-ctr: fix NULL dereference in tail processing
Date: Tue, 13 Sep 2016 09:48:52 +0100
Message-ID: <1473756533-21078-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: xiakaixu@huawei.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:37109 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755555AbcIMItA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Sep 2016 04:49:00 -0400
Received: by mail-wm0-f41.google.com with SMTP id c131so99834822wmh.0
        for <linux-crypto@vger.kernel.org>; Tue, 13 Sep 2016 01:48:59 -0700 (PDT)
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

Fixes: 86464859cc77 ("crypto: arm - AES in ECB/CBC/CTR/XTS modes using ARMv8 Crypto Extensions")
Reported-by: xiakaixu <xiakaixu@huawei.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/crypto/aes-ce-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/crypto/aes-ce-glue.c b/arch/arm/crypto/aes-ce-glue.c
index da3c0428507b..aef022a87c53 100644
--- a/arch/arm/crypto/aes-ce-glue.c
+++ b/arch/arm/crypto/aes-ce-glue.c
@@ -284,7 +284,7 @@ static int ctr_encrypt(struct blkcipher_desc *desc, struct scatterlist *dst,
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
