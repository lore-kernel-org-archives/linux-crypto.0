Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF664CD68F4
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Oct 2023 06:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442156AbjJJGmw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Oct 2023 02:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442242AbjJJGmu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Oct 2023 02:42:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF7D9E
        for <linux-crypto@vger.kernel.org>; Mon,  9 Oct 2023 23:42:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A21CC433C9
        for <linux-crypto@vger.kernel.org>; Tue, 10 Oct 2023 06:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696920168;
        bh=GyflcT96AqfrA3c3HtScpLilgBjWsOhLiLnsAjVIMVM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=V31pZcREPLvqALT6Llmm+UylrYDW8+PfN647YVAzLgVWehl2i7HjtLYQxtij/OKCr
         USIUx3L2NoVuNCwzQgnsA3QQQWDsJ8M+ID2Y5YlqsBkcuyTRg38mDfSrKPZdizgMmu
         e3hFuPCLTf6xYOwTI4MEk13f/Qto+BACKPJjKUN89WmHK9tCrhRqBKbSpd0kX4UAjx
         ScI0MvroLlGgs5lJml7B1n0ncqCUBwGR+ERmDm/La7+8JuhQlXj9LzKutDXYdSGn2I
         lYKweCuqoZozR2lgB0IMiYxK85CTTwqdUAnwj53YpWNT0IHUcKo5JPQFpaHSI30PXK
         8eXYG90+6cU5A==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 2/5] crypto: arm64/sha2-ce - clean up backwards function names
Date:   Mon,  9 Oct 2023 23:41:24 -0700
Message-ID: <20231010064127.323261-3-ebiggers@kernel.org>
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
underscores -- not the other way around.  __sha2_ce_transform() and
__sha256_block_data_order() got this backwards.  Fix this, albeit
without changing "sha256_block_data_order" in the perlasm since that is
OpenSSL code.  No change in behavior.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm64/crypto/sha2-ce-core.S |  8 ++++----
 arch/arm64/crypto/sha2-ce-glue.c | 31 ++++++++++++++++---------------
 2 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/crypto/sha2-ce-core.S b/arch/arm64/crypto/sha2-ce-core.S
index 491179922f498..fce84d88ddb2c 100644
--- a/arch/arm64/crypto/sha2-ce-core.S
+++ b/arch/arm64/crypto/sha2-ce-core.S
@@ -71,11 +71,11 @@
 	.word		0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
 
 	/*
-	 * void sha2_ce_transform(struct sha256_ce_state *sst, u8 const *src,
-	 *			  int blocks)
+	 * int __sha256_ce_transform(struct sha256_ce_state *sst, u8 const *src,
+	 *			     int blocks)
 	 */
 	.text
-SYM_FUNC_START(sha2_ce_transform)
+SYM_FUNC_START(__sha256_ce_transform)
 	/* load round constants */
 	adr_l		x8, .Lsha2_rcon
 	ld1		{ v0.4s- v3.4s}, [x8], #64
@@ -154,4 +154,4 @@ CPU_LE(	rev32		v19.16b, v19.16b	)
 3:	st1		{dgav.4s, dgbv.4s}, [x0]
 	mov		w0, w2
 	ret
-SYM_FUNC_END(sha2_ce_transform)
+SYM_FUNC_END(__sha256_ce_transform)
diff --git a/arch/arm64/crypto/sha2-ce-glue.c b/arch/arm64/crypto/sha2-ce-glue.c
index c57a6119fefc5..cdeefdcbe101b 100644
--- a/arch/arm64/crypto/sha2-ce-glue.c
+++ b/arch/arm64/crypto/sha2-ce-glue.c
@@ -30,18 +30,19 @@ struct sha256_ce_state {
 extern const u32 sha256_ce_offsetof_count;
 extern const u32 sha256_ce_offsetof_finalize;
 
-asmlinkage int sha2_ce_transform(struct sha256_ce_state *sst, u8 const *src,
-				 int blocks);
+asmlinkage int __sha256_ce_transform(struct sha256_ce_state *sst, u8 const *src,
+				     int blocks);
 
-static void __sha2_ce_transform(struct sha256_state *sst, u8 const *src,
+static void sha256_ce_transform(struct sha256_state *sst, u8 const *src,
 				int blocks)
 {
 	while (blocks) {
 		int rem;
 
 		kernel_neon_begin();
-		rem = sha2_ce_transform(container_of(sst, struct sha256_ce_state,
-						     sst), src, blocks);
+		rem = __sha256_ce_transform(container_of(sst,
+							 struct sha256_ce_state,
+							 sst), src, blocks);
 		kernel_neon_end();
 		src += (blocks - rem) * SHA256_BLOCK_SIZE;
 		blocks = rem;
@@ -55,8 +56,8 @@ const u32 sha256_ce_offsetof_finalize = offsetof(struct sha256_ce_state,
 
 asmlinkage void sha256_block_data_order(u32 *digest, u8 const *src, int blocks);
 
-static void __sha256_block_data_order(struct sha256_state *sst, u8 const *src,
-				      int blocks)
+static void sha256_arm64_transform(struct sha256_state *sst, u8 const *src,
+				   int blocks)
 {
 	sha256_block_data_order(sst->state, src, blocks);
 }
@@ -68,10 +69,10 @@ static int sha256_ce_update(struct shash_desc *desc, const u8 *data,
 
 	if (!crypto_simd_usable())
 		return sha256_base_do_update(desc, data, len,
-				__sha256_block_data_order);
+					     sha256_arm64_transform);
 
 	sctx->finalize = 0;
-	sha256_base_do_update(desc, data, len, __sha2_ce_transform);
+	sha256_base_do_update(desc, data, len, sha256_ce_transform);
 
 	return 0;
 }
@@ -85,8 +86,8 @@ static int sha256_ce_finup(struct shash_desc *desc, const u8 *data,
 	if (!crypto_simd_usable()) {
 		if (len)
 			sha256_base_do_update(desc, data, len,
-				__sha256_block_data_order);
-		sha256_base_do_finalize(desc, __sha256_block_data_order);
+					      sha256_arm64_transform);
+		sha256_base_do_finalize(desc, sha256_arm64_transform);
 		return sha256_base_finish(desc, out);
 	}
 
@@ -96,9 +97,9 @@ static int sha256_ce_finup(struct shash_desc *desc, const u8 *data,
 	 */
 	sctx->finalize = finalize;
 
-	sha256_base_do_update(desc, data, len, __sha2_ce_transform);
+	sha256_base_do_update(desc, data, len, sha256_ce_transform);
 	if (!finalize)
-		sha256_base_do_finalize(desc, __sha2_ce_transform);
+		sha256_base_do_finalize(desc, sha256_ce_transform);
 	return sha256_base_finish(desc, out);
 }
 
@@ -107,12 +108,12 @@ static int sha256_ce_final(struct shash_desc *desc, u8 *out)
 	struct sha256_ce_state *sctx = shash_desc_ctx(desc);
 
 	if (!crypto_simd_usable()) {
-		sha256_base_do_finalize(desc, __sha256_block_data_order);
+		sha256_base_do_finalize(desc, sha256_arm64_transform);
 		return sha256_base_finish(desc, out);
 	}
 
 	sctx->finalize = 0;
-	sha256_base_do_finalize(desc, __sha2_ce_transform);
+	sha256_base_do_finalize(desc, sha256_ce_transform);
 	return sha256_base_finish(desc, out);
 }
 
-- 
2.42.0

