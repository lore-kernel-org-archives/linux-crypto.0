Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC3F0E95A8E
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Oct 2023 07:54:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345451AbjJIHyJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Oct 2023 03:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234372AbjJIHyI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Oct 2023 03:54:08 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC751AB
        for <linux-crypto@vger.kernel.org>; Mon,  9 Oct 2023 00:54:06 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B27CC433C8
        for <linux-crypto@vger.kernel.org>; Mon,  9 Oct 2023 07:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696838046;
        bh=DtOdqHJM2o4D/hsHI+LBPTBTuQoe17srScWir4PTaGE=;
        h=From:To:Subject:Date:From;
        b=FSz+m9kTVgXbRhuhE0J8bvlr7P1QS/WqpP0XiwyBivBFewHMViDxO7P6TijG792zh
         jwvnFABFpm92noaK6zeZBxELJaY4F8x03z8a81glCohLYb5W6wNdmJYZSrK+0TaT3P
         9DPp/WYvm8S3Xi47Cgyln6D1m0xYvOvRixhzcMvYXfoOfbRyBTm/r+od2XTqLyHKCu
         Sj3dxeBq/n3LZEq13dIDjAtp+WLDOyIY5SKygL6+Nl2PNU+Tjc+k8/hOhfrYBFvGnT
         jNXgYoaoXaDHXRM0V+tczBe1wEoamlCIdtvolufTH0uuxqUI0/KRQNF+opUw5IacxC
         VgH2DM2r4jixA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: arm64/sha2-ce - implement ->digest for sha256
Date:   Mon,  9 Oct 2023 00:53:27 -0700
Message-ID: <20231009075327.446840-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Implement a ->digest function for sha256-ce.  This improves the
performance of crypto_shash_digest() with this algorithm by reducing the
number of indirect calls that are made.  This only adds ~112 bytes of
code, mostly for the inlined init, as the finup function is tail-called.

For now, don't bother with this for sha224, since sha224 is rarely used.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm64/crypto/sha2-ce-glue.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/crypto/sha2-ce-glue.c b/arch/arm64/crypto/sha2-ce-glue.c
index c57a6119fefc5..f2f118b0e1c1f 100644
--- a/arch/arm64/crypto/sha2-ce-glue.c
+++ b/arch/arm64/crypto/sha2-ce-glue.c
@@ -109,20 +109,27 @@ static int sha256_ce_final(struct shash_desc *desc, u8 *out)
 	if (!crypto_simd_usable()) {
 		sha256_base_do_finalize(desc, __sha256_block_data_order);
 		return sha256_base_finish(desc, out);
 	}
 
 	sctx->finalize = 0;
 	sha256_base_do_finalize(desc, __sha2_ce_transform);
 	return sha256_base_finish(desc, out);
 }
 
+static int sha256_ce_digest(struct shash_desc *desc, const u8 *data,
+			    unsigned int len, u8 *out)
+{
+	sha256_base_init(desc);
+	return sha256_ce_finup(desc, data, len, out);
+}
+
 static int sha256_ce_export(struct shash_desc *desc, void *out)
 {
 	struct sha256_ce_state *sctx = shash_desc_ctx(desc);
 
 	memcpy(out, &sctx->sst, sizeof(struct sha256_state));
 	return 0;
 }
 
 static int sha256_ce_import(struct shash_desc *desc, const void *in)
 {
@@ -148,20 +155,21 @@ static struct shash_alg algs[] = { {
 		.cra_driver_name	= "sha224-ce",
 		.cra_priority		= 200,
 		.cra_blocksize		= SHA256_BLOCK_SIZE,
 		.cra_module		= THIS_MODULE,
 	}
 }, {
 	.init			= sha256_base_init,
 	.update			= sha256_ce_update,
 	.final			= sha256_ce_final,
 	.finup			= sha256_ce_finup,
+	.digest			= sha256_ce_digest,
 	.export			= sha256_ce_export,
 	.import			= sha256_ce_import,
 	.descsize		= sizeof(struct sha256_ce_state),
 	.statesize		= sizeof(struct sha256_state),
 	.digestsize		= SHA256_DIGEST_SIZE,
 	.base			= {
 		.cra_name		= "sha256",
 		.cra_driver_name	= "sha256-ce",
 		.cra_priority		= 200,
 		.cra_blocksize		= SHA256_BLOCK_SIZE,

base-commit: 8468516f9f93a41dc65158b6428a1a1039c68f20
-- 
2.42.0

