Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02FAAC433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 18:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A843A64EA5
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Feb 2021 18:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhBASES (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Feb 2021 13:04:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:54034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229984AbhBASER (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Feb 2021 13:04:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 143AA64EB9;
        Mon,  1 Feb 2021 18:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612202583;
        bh=dMhNJLwKQBJSk+VkWRbESrah6c7o3LbQV4IQtCiiilY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ecQJNXAaBSVdun1+ji4aTojFXYJcdyTJXumTnZAqtZNcCOzVpOfPBZ8pesslrUhxC
         vMwsp9nLL1bQXKLb+WBcNtySMuibM5Nbbah6XSpWIHcFeff7nsq9Izg89hMeA4NEnR
         lSR/eYa7Ks/tsSh6bB1mOk1MjtSdOVhARyhovzsfb09C8kFpzaCchfIJSa7iSasb4e
         ZMbTd6619Gfd7JYBYKRrFCM6JOcR0NrAcD6ZosqD98J8KI/AzfwZCGT34xTqH7J9XB
         qkUNWMoLDK5a+gRStPkujnxRSozy5mIeFaUn7NF2oe4l7cwedwj2wSvCfWF8BhzN+s
         yQ115KV+m2V7w==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5/9] crypto: camellia - use unaligned accessors instead of alignmask
Date:   Mon,  1 Feb 2021 19:02:33 +0100
Message-Id: <20210201180237.3171-6-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210201180237.3171-1-ardb@kernel.org>
References: <20210201180237.3171-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of using an alignmask of 0x3 to ensure 32-bit alignment of the
Camellia input and output blocks, which propagates to mode drivers, and
results in pointless copying on architectures that don't care about
alignment, use the unaligned accessors, which will do the right thing on
each respective architecture, avoiding the need for double buffering.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/camellia_generic.c | 45 +++++++-------------
 1 file changed, 16 insertions(+), 29 deletions(-)

diff --git a/crypto/camellia_generic.c b/crypto/camellia_generic.c
index 0b9f409f7370..fd1a88af9e77 100644
--- a/crypto/camellia_generic.c
+++ b/crypto/camellia_generic.c
@@ -9,14 +9,6 @@
  *  https://info.isl.ntt.co.jp/crypt/eng/camellia/specifications.html
  */
 
-/*
- *
- * NOTE --- NOTE --- NOTE --- NOTE
- * This implementation assumes that all memory addresses passed
- * as parameters are four-byte aligned.
- *
- */
-
 #include <linux/crypto.h>
 #include <linux/errno.h>
 #include <linux/init.h>
@@ -994,16 +986,14 @@ camellia_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 static void camellia_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	const struct camellia_ctx *cctx = crypto_tfm_ctx(tfm);
-	const __be32 *src = (const __be32 *)in;
-	__be32 *dst = (__be32 *)out;
 	unsigned int max;
 
 	u32 tmp[4];
 
-	tmp[0] = be32_to_cpu(src[0]);
-	tmp[1] = be32_to_cpu(src[1]);
-	tmp[2] = be32_to_cpu(src[2]);
-	tmp[3] = be32_to_cpu(src[3]);
+	tmp[0] = get_unaligned_be32(in);
+	tmp[1] = get_unaligned_be32(in + 4);
+	tmp[2] = get_unaligned_be32(in + 8);
+	tmp[3] = get_unaligned_be32(in + 12);
 
 	if (cctx->key_length == 16)
 		max = 24;
@@ -1013,25 +1003,23 @@ static void camellia_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	camellia_do_encrypt(cctx->key_table, tmp, max);
 
 	/* do_encrypt returns 0,1 swapped with 2,3 */
-	dst[0] = cpu_to_be32(tmp[2]);
-	dst[1] = cpu_to_be32(tmp[3]);
-	dst[2] = cpu_to_be32(tmp[0]);
-	dst[3] = cpu_to_be32(tmp[1]);
+	put_unaligned_be32(tmp[2], out);
+	put_unaligned_be32(tmp[3], out + 4);
+	put_unaligned_be32(tmp[0], out + 8);
+	put_unaligned_be32(tmp[1], out + 12);
 }
 
 static void camellia_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	const struct camellia_ctx *cctx = crypto_tfm_ctx(tfm);
-	const __be32 *src = (const __be32 *)in;
-	__be32 *dst = (__be32 *)out;
 	unsigned int max;
 
 	u32 tmp[4];
 
-	tmp[0] = be32_to_cpu(src[0]);
-	tmp[1] = be32_to_cpu(src[1]);
-	tmp[2] = be32_to_cpu(src[2]);
-	tmp[3] = be32_to_cpu(src[3]);
+	tmp[0] = get_unaligned_be32(in);
+	tmp[1] = get_unaligned_be32(in + 4);
+	tmp[2] = get_unaligned_be32(in + 8);
+	tmp[3] = get_unaligned_be32(in + 12);
 
 	if (cctx->key_length == 16)
 		max = 24;
@@ -1041,10 +1029,10 @@ static void camellia_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 	camellia_do_decrypt(cctx->key_table, tmp, max);
 
 	/* do_decrypt returns 0,1 swapped with 2,3 */
-	dst[0] = cpu_to_be32(tmp[2]);
-	dst[1] = cpu_to_be32(tmp[3]);
-	dst[2] = cpu_to_be32(tmp[0]);
-	dst[3] = cpu_to_be32(tmp[1]);
+	put_unaligned_be32(tmp[2], out);
+	put_unaligned_be32(tmp[3], out + 4);
+	put_unaligned_be32(tmp[0], out + 8);
+	put_unaligned_be32(tmp[1], out + 12);
 }
 
 static struct crypto_alg camellia_alg = {
@@ -1054,7 +1042,6 @@ static struct crypto_alg camellia_alg = {
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	CAMELLIA_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct camellia_ctx),
-	.cra_alignmask		=	3,
 	.cra_module		=	THIS_MODULE,
 	.cra_u			=	{
 		.cipher = {
-- 
2.20.1

