Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A7C2CD68F6
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Oct 2023 06:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442242AbjJJGmw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Oct 2023 02:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442241AbjJJGmu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Oct 2023 02:42:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA059F
        for <linux-crypto@vger.kernel.org>; Mon,  9 Oct 2023 23:42:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB50C433CA
        for <linux-crypto@vger.kernel.org>; Tue, 10 Oct 2023 06:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696920168;
        bh=BcYhmSeVUAPXZ0qSAcjgAY3t+u4rElhCrk1t4FuP7b0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=o9LbENFbriho/8FVgxgKKZ3zCvcrNe9EsP5i3Taz7tOp69RQIv0d/6jBUh/q94L3/
         fnr/Zafw1vsGW3L6HukG71rvueDnECIixrmbhdbyvabErRM9ISXRvC9R35bJR8/rOd
         Ta44uE8ywrCqhGpwz2Uh/4IbimqvevXqdmvJ+8US4tc4U56rvOJVvY/gXJRRkfY46E
         rn1uCv4c8tW/D78HxcVEnrFWtupTY+z+QEo22zE5Nb4+Rk3OjDMGMqg6UNLqoNfoSN
         k87jpQC85nuSo5BbFnWRCOAMhFajcPffPVp54r6cVF4KUROh099/P+FVD4CvlUefA8
         m+zdfBk+plZfQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 3/5] crypto: arm64/sha512-ce - clean up backwards function names
Date:   Mon,  9 Oct 2023 23:41:25 -0700
Message-ID: <20231010064127.323261-4-ebiggers@kernel.org>
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
underscores -- not the other way around.  __sha512_ce_transform() and
__sha512_block_data_order() got this backwards.  Fix this, albeit
without changing "sha512_block_data_order" in the perlasm since that is
OpenSSL code.  No change in behavior.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm64/crypto/sha512-ce-core.S |  8 ++++----
 arch/arm64/crypto/sha512-ce-glue.c | 26 +++++++++++++-------------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/crypto/sha512-ce-core.S b/arch/arm64/crypto/sha512-ce-core.S
index b6a3a36e15f58..91ef68b15fcc6 100644
--- a/arch/arm64/crypto/sha512-ce-core.S
+++ b/arch/arm64/crypto/sha512-ce-core.S
@@ -102,11 +102,11 @@
 	.endm
 
 	/*
-	 * void sha512_ce_transform(struct sha512_state *sst, u8 const *src,
-	 *			  int blocks)
+	 * int __sha512_ce_transform(struct sha512_state *sst, u8 const *src,
+	 *			     int blocks)
 	 */
 	.text
-SYM_FUNC_START(sha512_ce_transform)
+SYM_FUNC_START(__sha512_ce_transform)
 	/* load state */
 	ld1		{v8.2d-v11.2d}, [x0]
 
@@ -203,4 +203,4 @@ CPU_LE(	rev64		v19.16b, v19.16b	)
 3:	st1		{v8.2d-v11.2d}, [x0]
 	mov		w0, w2
 	ret
-SYM_FUNC_END(sha512_ce_transform)
+SYM_FUNC_END(__sha512_ce_transform)
diff --git a/arch/arm64/crypto/sha512-ce-glue.c b/arch/arm64/crypto/sha512-ce-glue.c
index 94cb7580deb7b..f3431fc623154 100644
--- a/arch/arm64/crypto/sha512-ce-glue.c
+++ b/arch/arm64/crypto/sha512-ce-glue.c
@@ -26,27 +26,27 @@ MODULE_LICENSE("GPL v2");
 MODULE_ALIAS_CRYPTO("sha384");
 MODULE_ALIAS_CRYPTO("sha512");
 
-asmlinkage int sha512_ce_transform(struct sha512_state *sst, u8 const *src,
-				   int blocks);
+asmlinkage int __sha512_ce_transform(struct sha512_state *sst, u8 const *src,
+				     int blocks);
 
 asmlinkage void sha512_block_data_order(u64 *digest, u8 const *src, int blocks);
 
-static void __sha512_ce_transform(struct sha512_state *sst, u8 const *src,
-				  int blocks)
+static void sha512_ce_transform(struct sha512_state *sst, u8 const *src,
+				int blocks)
 {
 	while (blocks) {
 		int rem;
 
 		kernel_neon_begin();
-		rem = sha512_ce_transform(sst, src, blocks);
+		rem = __sha512_ce_transform(sst, src, blocks);
 		kernel_neon_end();
 		src += (blocks - rem) * SHA512_BLOCK_SIZE;
 		blocks = rem;
 	}
 }
 
-static void __sha512_block_data_order(struct sha512_state *sst, u8 const *src,
-				      int blocks)
+static void sha512_arm64_transform(struct sha512_state *sst, u8 const *src,
+				   int blocks)
 {
 	sha512_block_data_order(sst->state, src, blocks);
 }
@@ -54,8 +54,8 @@ static void __sha512_block_data_order(struct sha512_state *sst, u8 const *src,
 static int sha512_ce_update(struct shash_desc *desc, const u8 *data,
 			    unsigned int len)
 {
-	sha512_block_fn *fn = crypto_simd_usable() ? __sha512_ce_transform
-						   : __sha512_block_data_order;
+	sha512_block_fn *fn = crypto_simd_usable() ? sha512_ce_transform
+						   : sha512_arm64_transform;
 
 	sha512_base_do_update(desc, data, len, fn);
 	return 0;
@@ -64,8 +64,8 @@ static int sha512_ce_update(struct shash_desc *desc, const u8 *data,
 static int sha512_ce_finup(struct shash_desc *desc, const u8 *data,
 			   unsigned int len, u8 *out)
 {
-	sha512_block_fn *fn = crypto_simd_usable() ? __sha512_ce_transform
-						   : __sha512_block_data_order;
+	sha512_block_fn *fn = crypto_simd_usable() ? sha512_ce_transform
+						   : sha512_arm64_transform;
 
 	sha512_base_do_update(desc, data, len, fn);
 	sha512_base_do_finalize(desc, fn);
@@ -74,8 +74,8 @@ static int sha512_ce_finup(struct shash_desc *desc, const u8 *data,
 
 static int sha512_ce_final(struct shash_desc *desc, u8 *out)
 {
-	sha512_block_fn *fn = crypto_simd_usable() ? __sha512_ce_transform
-						   : __sha512_block_data_order;
+	sha512_block_fn *fn = crypto_simd_usable() ? sha512_ce_transform
+						   : sha512_arm64_transform;
 
 	sha512_base_do_finalize(desc, fn);
 	return sha512_base_finish(desc, out);
-- 
2.42.0

