Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3D1CCD68ED
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Oct 2023 06:42:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442267AbjJJGmu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Oct 2023 02:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442233AbjJJGmu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Oct 2023 02:42:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF779D
        for <linux-crypto@vger.kernel.org>; Mon,  9 Oct 2023 23:42:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED293C433C8
        for <linux-crypto@vger.kernel.org>; Tue, 10 Oct 2023 06:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696920168;
        bh=L4yU/BVy14kPKDLx6I+c3rVOJQcT5xrzmXdNaUunEQo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=UTDWpMNxCuVwQzmCBiyI+bcactgQACJcFOxPV2eQ6IYUKQmd8rz7KutG43cI3xwo6
         W728qLeNztu60+CucXXQyyNwpatIBdS3Mc8Kicc4apFGP28yzFqaWinOZO+/65Ijvm
         mginNdLWjGjOLdfpCE+vdTvT1B8Qj7iYLQC429IV2Bm3E5rvRILhrLE3rMpvXKUeh6
         qUKj4kQAMNcqfIRWv1BBFc5HPhJY63VMUculUMTqx9g0/2B7E8I/rUJSRZUq454nhN
         /UsqecBJo/JmB1WDdCS6jExIHDUsc6RoLc/y6nNo2WCTKLr38qs+DUo/KmLDsvqOki
         pWSqR/n5oGkiA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 1/5] crypto: arm64/sha1-ce - clean up backwards function names
Date:   Mon,  9 Oct 2023 23:41:23 -0700
Message-ID: <20231010064127.323261-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231010064127.323261-1-ebiggers@kernel.org>
References: <20231010064127.323261-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

In the Linux kernel, a function whose name has two leading underscores
is conventionally called by the same-named function without leading
underscores -- not the other way around.  __sha1_ce_transform() got this
backwards.  Fix this.  No change in behavior.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm64/crypto/sha1-ce-core.S |  8 ++++----
 arch/arm64/crypto/sha1-ce-glue.c | 21 +++++++++++----------
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/crypto/sha1-ce-core.S b/arch/arm64/crypto/sha1-ce-core.S
index 889ca0f8972b3..9b1f2d82a6fea 100644
--- a/arch/arm64/crypto/sha1-ce-core.S
+++ b/arch/arm64/crypto/sha1-ce-core.S
@@ -62,10 +62,10 @@
 	.endm
 
 	/*
-	 * int sha1_ce_transform(struct sha1_ce_state *sst, u8 const *src,
-	 *			 int blocks)
+	 * int __sha1_ce_transform(struct sha1_ce_state *sst, u8 const *src,
+	 *			   int blocks)
 	 */
-SYM_FUNC_START(sha1_ce_transform)
+SYM_FUNC_START(__sha1_ce_transform)
 	/* load round constants */
 	loadrc		k0.4s, 0x5a827999, w6
 	loadrc		k1.4s, 0x6ed9eba1, w6
@@ -147,4 +147,4 @@ CPU_LE(	rev32		v11.16b, v11.16b	)
 	str		dgb, [x0, #16]
 	mov		w0, w2
 	ret
-SYM_FUNC_END(sha1_ce_transform)
+SYM_FUNC_END(__sha1_ce_transform)
diff --git a/arch/arm64/crypto/sha1-ce-glue.c b/arch/arm64/crypto/sha1-ce-glue.c
index 71fa4f1122d74..1dd93e1fcb39a 100644
--- a/arch/arm64/crypto/sha1-ce-glue.c
+++ b/arch/arm64/crypto/sha1-ce-glue.c
@@ -29,18 +29,19 @@ struct sha1_ce_state {
 extern const u32 sha1_ce_offsetof_count;
 extern const u32 sha1_ce_offsetof_finalize;
 
-asmlinkage int sha1_ce_transform(struct sha1_ce_state *sst, u8 const *src,
-				 int blocks);
+asmlinkage int __sha1_ce_transform(struct sha1_ce_state *sst, u8 const *src,
+				   int blocks);
 
-static void __sha1_ce_transform(struct sha1_state *sst, u8 const *src,
-				int blocks)
+static void sha1_ce_transform(struct sha1_state *sst, u8 const *src,
+			      int blocks)
 {
 	while (blocks) {
 		int rem;
 
 		kernel_neon_begin();
-		rem = sha1_ce_transform(container_of(sst, struct sha1_ce_state,
-						     sst), src, blocks);
+		rem = __sha1_ce_transform(container_of(sst,
+						       struct sha1_ce_state,
+						       sst), src, blocks);
 		kernel_neon_end();
 		src += (blocks - rem) * SHA1_BLOCK_SIZE;
 		blocks = rem;
@@ -59,7 +60,7 @@ static int sha1_ce_update(struct shash_desc *desc, const u8 *data,
 		return crypto_sha1_update(desc, data, len);
 
 	sctx->finalize = 0;
-	sha1_base_do_update(desc, data, len, __sha1_ce_transform);
+	sha1_base_do_update(desc, data, len, sha1_ce_transform);
 
 	return 0;
 }
@@ -79,9 +80,9 @@ static int sha1_ce_finup(struct shash_desc *desc, const u8 *data,
 	 */
 	sctx->finalize = finalize;
 
-	sha1_base_do_update(desc, data, len, __sha1_ce_transform);
+	sha1_base_do_update(desc, data, len, sha1_ce_transform);
 	if (!finalize)
-		sha1_base_do_finalize(desc, __sha1_ce_transform);
+		sha1_base_do_finalize(desc, sha1_ce_transform);
 	return sha1_base_finish(desc, out);
 }
 
@@ -93,7 +94,7 @@ static int sha1_ce_final(struct shash_desc *desc, u8 *out)
 		return crypto_sha1_finup(desc, NULL, 0, out);
 
 	sctx->finalize = 0;
-	sha1_base_do_finalize(desc, __sha1_ce_transform);
+	sha1_base_do_finalize(desc, sha1_ce_transform);
 	return sha1_base_finish(desc, out);
 }
 
-- 
2.42.0

