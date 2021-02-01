Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E753C433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 18:04:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA02A64E97
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 18:04:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbhBASEX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Feb 2021 13:04:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:54078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230091AbhBASEW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Feb 2021 13:04:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02A1664EBB;
        Mon,  1 Feb 2021 18:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612202589;
        bh=ppI7NuivS4D+nsSpFKK/EI0QBwCj15b8dU0LtLpjlG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CJpG8dOKN3PiRx5LMuofswFACZ5Q6FqAHwWA8iEmDOwKMqie8jra7aHbipNCDeHHc
         5jpO5PrSRBXo7w4MKiFI7ikcPQJlzE+CYVR07U7e6/YyxpL3z43PyO2mLI/Wgtn0kq
         aUtUV+OAtyjkw6LeEsH4rs9i8rS5/vmoPYH1qnCws9I5Ec/fCeI4FV2TFLG9d0addS
         jXMt5kE3agCu0vme5kGKw9Dollv3AbxSH+iII/ZR0V5cnr2Qp1FbDE9qX712F2plYY
         IkLAm9+uNDD26FLyx65W+rNW9Or/BBVggP8EalVbSEBXBddXBiBUS+VBVtWyJcUtHw
         SidO8XELgI7PQ==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 9/9] crypto: twofish - use unaligned accessors instead of alignmask
Date:   Mon,  1 Feb 2021 19:02:37 +0100
Message-Id: <20210201180237.3171-10-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210201180237.3171-1-ardb@kernel.org>
References: <20210201180237.3171-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of using an alignmask of 0x3 to ensure 32-bit alignment of the
Twofish input and output blocks, which propagates to mode drivers, and
results in pointless copying on architectures that don't care about
alignment, use the unaligned accessors, which will do the right thing on
each respective architecture, avoiding the need for double buffering.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/twofish_generic.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/crypto/twofish_generic.c b/crypto/twofish_generic.c
index 4f7c033224f9..86b2f067a416 100644
--- a/crypto/twofish_generic.c
+++ b/crypto/twofish_generic.c
@@ -24,7 +24,7 @@
  * Third Edition.
  */
 
-#include <asm/byteorder.h>
+#include <asm/unaligned.h>
 #include <crypto/twofish.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -83,11 +83,11 @@
  * whitening subkey number m. */
 
 #define INPACK(n, x, m) \
-   x = le32_to_cpu(src[n]) ^ ctx->w[m]
+   x = get_unaligned_le32(in + (n) * 4) ^ ctx->w[m]
 
 #define OUTUNPACK(n, x, m) \
    x ^= ctx->w[m]; \
-   dst[n] = cpu_to_le32(x)
+   put_unaligned_le32(x, out + (n) * 4)
 
 
 
@@ -95,8 +95,6 @@
 static void twofish_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct twofish_ctx *ctx = crypto_tfm_ctx(tfm);
-	const __le32 *src = (const __le32 *)in;
-	__le32 *dst = (__le32 *)out;
 
 	/* The four 32-bit chunks of the text. */
 	u32 a, b, c, d;
@@ -132,8 +130,6 @@ static void twofish_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 static void twofish_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	struct twofish_ctx *ctx = crypto_tfm_ctx(tfm);
-	const __le32 *src = (const __le32 *)in;
-	__le32 *dst = (__le32 *)out;
   
 	/* The four 32-bit chunks of the text. */
 	u32 a, b, c, d;
@@ -172,7 +168,6 @@ static struct crypto_alg alg = {
 	.cra_flags          =   CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize      =   TF_BLOCK_SIZE,
 	.cra_ctxsize        =   sizeof(struct twofish_ctx),
-	.cra_alignmask      =	3,
 	.cra_module         =   THIS_MODULE,
 	.cra_u              =   { .cipher = {
 	.cia_min_keysize    =   TF_MIN_KEY_SIZE,
-- 
2.20.1

