Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD3BDE95A8E
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Oct 2023 08:19:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbjJIITl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Oct 2023 04:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbjJIITk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Oct 2023 04:19:40 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF438F
        for <linux-crypto@vger.kernel.org>; Mon,  9 Oct 2023 01:19:38 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB1AC433C7
        for <linux-crypto@vger.kernel.org>; Mon,  9 Oct 2023 08:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696839577;
        bh=6K/98GWXvqvYq13t70RfzRM2WPYM3viasqCT7Cjb1IA=;
        h=From:To:Subject:Date:From;
        b=MpJPA+LR1x8FOJoREZkAY/aqckYWbE/i5QH2wUhRFtYsxqk0hxbmayS4khAc72sSn
         LYTqhFEiZzHchS02Lpw3D762TIMgqr00LRsnRDROVPMqvRaaFBR0vsSWgJpQwzbT11
         xzSMi71k/NlDOgoqeDcAh7DE5Yj5nfMPqvYbswTEYa6+n61mqKI3iOwJwFNtyV4Jra
         duYGFiItMxKoAJUyMsI4B/b6Wh00job30rltMFgWA+AXdfj6cjO11W0u1jJkJn0373
         IVr6lzrBPK/0aAmolVcDLt81ad0ItLdmvpU42OXItwmjGc1dTuc+VcE/xIESM5xtgX
         XadnZ+nCUraLQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: x86/sha256 - implement ->digest for sha256
Date:   Mon,  9 Oct 2023 01:19:00 -0700
Message-ID: <20231009081900.503086-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Implement a ->digest function for sha256-ssse3, sha256-avx, sha256-avx2,
and sha256-ni.  This improves the performance of crypto_shash_digest()
with these algorithms by reducing the number of indirect calls that are
made.

For now, don't bother with this for sha224, since sha224 is rarely used.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/sha256_ssse3_glue.c | 32 +++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
index d25235f0ccafc..4c0383a90e114 100644
--- a/arch/x86/crypto/sha256_ssse3_glue.c
+++ b/arch/x86/crypto/sha256_ssse3_glue.c
@@ -100,26 +100,34 @@ static int sha256_ssse3_finup(struct shash_desc *desc, const u8 *data,
 {
 	return sha256_finup(desc, data, len, out, sha256_transform_ssse3);
 }
 
 /* Add padding and return the message digest. */
 static int sha256_ssse3_final(struct shash_desc *desc, u8 *out)
 {
 	return sha256_ssse3_finup(desc, NULL, 0, out);
 }
 
+static int sha256_ssse3_digest(struct shash_desc *desc, const u8 *data,
+	      unsigned int len, u8 *out)
+{
+	return sha256_base_init(desc) ?:
+	       sha256_ssse3_finup(desc, data, len, out);
+}
+
 static struct shash_alg sha256_ssse3_algs[] = { {
 	.digestsize	=	SHA256_DIGEST_SIZE,
 	.init		=	sha256_base_init,
 	.update		=	sha256_ssse3_update,
 	.final		=	sha256_ssse3_final,
 	.finup		=	sha256_ssse3_finup,
+	.digest		=	sha256_ssse3_digest,
 	.descsize	=	sizeof(struct sha256_state),
 	.base		=	{
 		.cra_name	=	"sha256",
 		.cra_driver_name =	"sha256-ssse3",
 		.cra_priority	=	150,
 		.cra_blocksize	=	SHA256_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
 }, {
 	.digestsize	=	SHA224_DIGEST_SIZE,
@@ -165,26 +173,34 @@ static int sha256_avx_finup(struct shash_desc *desc, const u8 *data,
 		      unsigned int len, u8 *out)
 {
 	return sha256_finup(desc, data, len, out, sha256_transform_avx);
 }
 
 static int sha256_avx_final(struct shash_desc *desc, u8 *out)
 {
 	return sha256_avx_finup(desc, NULL, 0, out);
 }
 
+static int sha256_avx_digest(struct shash_desc *desc, const u8 *data,
+		      unsigned int len, u8 *out)
+{
+	return sha256_base_init(desc) ?:
+	       sha256_avx_finup(desc, data, len, out);
+}
+
 static struct shash_alg sha256_avx_algs[] = { {
 	.digestsize	=	SHA256_DIGEST_SIZE,
 	.init		=	sha256_base_init,
 	.update		=	sha256_avx_update,
 	.final		=	sha256_avx_final,
 	.finup		=	sha256_avx_finup,
+	.digest		=	sha256_avx_digest,
 	.descsize	=	sizeof(struct sha256_state),
 	.base		=	{
 		.cra_name	=	"sha256",
 		.cra_driver_name =	"sha256-avx",
 		.cra_priority	=	160,
 		.cra_blocksize	=	SHA256_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
 }, {
 	.digestsize	=	SHA224_DIGEST_SIZE,
@@ -241,26 +257,34 @@ static int sha256_avx2_finup(struct shash_desc *desc, const u8 *data,
 		      unsigned int len, u8 *out)
 {
 	return sha256_finup(desc, data, len, out, sha256_transform_rorx);
 }
 
 static int sha256_avx2_final(struct shash_desc *desc, u8 *out)
 {
 	return sha256_avx2_finup(desc, NULL, 0, out);
 }
 
+static int sha256_avx2_digest(struct shash_desc *desc, const u8 *data,
+		      unsigned int len, u8 *out)
+{
+	return sha256_base_init(desc) ?:
+	       sha256_avx2_finup(desc, data, len, out);
+}
+
 static struct shash_alg sha256_avx2_algs[] = { {
 	.digestsize	=	SHA256_DIGEST_SIZE,
 	.init		=	sha256_base_init,
 	.update		=	sha256_avx2_update,
 	.final		=	sha256_avx2_final,
 	.finup		=	sha256_avx2_finup,
+	.digest		=	sha256_avx2_digest,
 	.descsize	=	sizeof(struct sha256_state),
 	.base		=	{
 		.cra_name	=	"sha256",
 		.cra_driver_name =	"sha256-avx2",
 		.cra_priority	=	170,
 		.cra_blocksize	=	SHA256_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
 }, {
 	.digestsize	=	SHA224_DIGEST_SIZE,
@@ -316,26 +340,34 @@ static int sha256_ni_finup(struct shash_desc *desc, const u8 *data,
 		      unsigned int len, u8 *out)
 {
 	return sha256_finup(desc, data, len, out, sha256_ni_transform);
 }
 
 static int sha256_ni_final(struct shash_desc *desc, u8 *out)
 {
 	return sha256_ni_finup(desc, NULL, 0, out);
 }
 
+static int sha256_ni_digest(struct shash_desc *desc, const u8 *data,
+		      unsigned int len, u8 *out)
+{
+	return sha256_base_init(desc) ?:
+	       sha256_ni_finup(desc, data, len, out);
+}
+
 static struct shash_alg sha256_ni_algs[] = { {
 	.digestsize	=	SHA256_DIGEST_SIZE,
 	.init		=	sha256_base_init,
 	.update		=	sha256_ni_update,
 	.final		=	sha256_ni_final,
 	.finup		=	sha256_ni_finup,
+	.digest		=	sha256_ni_digest,
 	.descsize	=	sizeof(struct sha256_state),
 	.base		=	{
 		.cra_name	=	"sha256",
 		.cra_driver_name =	"sha256-ni",
 		.cra_priority	=	250,
 		.cra_blocksize	=	SHA256_BLOCK_SIZE,
 		.cra_module	=	THIS_MODULE,
 	}
 }, {
 	.digestsize	=	SHA224_DIGEST_SIZE,

base-commit: 8468516f9f93a41dc65158b6428a1a1039c68f20
-- 
2.42.0

