Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D5E1CD68F5
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Oct 2023 06:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442233AbjJJGmv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Oct 2023 02:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442156AbjJJGmu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Oct 2023 02:42:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB63AA3
        for <linux-crypto@vger.kernel.org>; Mon,  9 Oct 2023 23:42:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B00BC433CB
        for <linux-crypto@vger.kernel.org>; Tue, 10 Oct 2023 06:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696920168;
        bh=iWuYXfnhEc+bf87cxTXTdxAIlzAFplm3u0hm6+aFeX8=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=msyg7l28tWbeu6V7vEH7A79uDrzP5SeDGWMUQoO9pv/fMr51Sj1tdblNPBPV6f/+r
         e+66XMX1vmTZqyyiCgjuAtuijm8XVII7NKvQDwBMNoxXnRbQw157FtL3NNfPF78/sR
         GfDzKU2SJeTP44qyjGulPNIVn4WxZ1PWUl+1lq+LZLCfUPur54ARa8v22GolPMPlhq
         gxDBRRy2Y/MgPAiLZCAbIY3ybftxmVM4R+nWRz7/583esOiB+pkL/vVTe9SHhFlUxB
         rEbAID1pOzRJpt9xgLqNr9boxt1E/a5kKzA2Dk7ZN6CRF+2cJgkYxhGE0/IQOmyPAh
         Ajgyw5sBAVt/w==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 4/5] crypto: arm64/sha256 - clean up backwards function names
Date:   Mon,  9 Oct 2023 23:41:26 -0700
Message-ID: <20231010064127.323261-5-ebiggers@kernel.org>
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
underscores -- not the other way around.  __sha256_block_data_order()
and __sha256_block_neon() got this backwards.  Fix this, albeit without
changing the names in the perlasm since that is OpenSSL code.  No change
in behavior.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm64/crypto/sha256-glue.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/crypto/sha256-glue.c b/arch/arm64/crypto/sha256-glue.c
index 9b5c86e07a9af..35356987cc1e0 100644
--- a/arch/arm64/crypto/sha256-glue.c
+++ b/arch/arm64/crypto/sha256-glue.c
@@ -27,8 +27,8 @@ asmlinkage void sha256_block_data_order(u32 *digest, const void *data,
 					unsigned int num_blks);
 EXPORT_SYMBOL(sha256_block_data_order);
 
-static void __sha256_block_data_order(struct sha256_state *sst, u8 const *src,
-				      int blocks)
+static void sha256_arm64_transform(struct sha256_state *sst, u8 const *src,
+				   int blocks)
 {
 	sha256_block_data_order(sst->state, src, blocks);
 }
@@ -36,8 +36,8 @@ static void __sha256_block_data_order(struct sha256_state *sst, u8 const *src,
 asmlinkage void sha256_block_neon(u32 *digest, const void *data,
 				  unsigned int num_blks);
 
-static void __sha256_block_neon(struct sha256_state *sst, u8 const *src,
-				int blocks)
+static void sha256_neon_transform(struct sha256_state *sst, u8 const *src,
+				  int blocks)
 {
 	sha256_block_neon(sst->state, src, blocks);
 }
@@ -45,17 +45,15 @@ static void __sha256_block_neon(struct sha256_state *sst, u8 const *src,
 static int crypto_sha256_arm64_update(struct shash_desc *desc, const u8 *data,
 				      unsigned int len)
 {
-	return sha256_base_do_update(desc, data, len,
-				     __sha256_block_data_order);
+	return sha256_base_do_update(desc, data, len, sha256_arm64_transform);
 }
 
 static int crypto_sha256_arm64_finup(struct shash_desc *desc, const u8 *data,
 				     unsigned int len, u8 *out)
 {
 	if (len)
-		sha256_base_do_update(desc, data, len,
-				      __sha256_block_data_order);
-	sha256_base_do_finalize(desc, __sha256_block_data_order);
+		sha256_base_do_update(desc, data, len, sha256_arm64_transform);
+	sha256_base_do_finalize(desc, sha256_arm64_transform);
 
 	return sha256_base_finish(desc, out);
 }
@@ -98,7 +96,7 @@ static int sha256_update_neon(struct shash_desc *desc, const u8 *data,
 
 	if (!crypto_simd_usable())
 		return sha256_base_do_update(desc, data, len,
-				__sha256_block_data_order);
+				sha256_arm64_transform);
 
 	while (len > 0) {
 		unsigned int chunk = len;
@@ -114,7 +112,7 @@ static int sha256_update_neon(struct shash_desc *desc, const u8 *data,
 				sctx->count % SHA256_BLOCK_SIZE;
 
 		kernel_neon_begin();
-		sha256_base_do_update(desc, data, chunk, __sha256_block_neon);
+		sha256_base_do_update(desc, data, chunk, sha256_neon_transform);
 		kernel_neon_end();
 		data += chunk;
 		len -= chunk;
@@ -128,13 +126,13 @@ static int sha256_finup_neon(struct shash_desc *desc, const u8 *data,
 	if (!crypto_simd_usable()) {
 		if (len)
 			sha256_base_do_update(desc, data, len,
-				__sha256_block_data_order);
-		sha256_base_do_finalize(desc, __sha256_block_data_order);
+				sha256_arm64_transform);
+		sha256_base_do_finalize(desc, sha256_arm64_transform);
 	} else {
 		if (len)
 			sha256_update_neon(desc, data, len);
 		kernel_neon_begin();
-		sha256_base_do_finalize(desc, __sha256_block_neon);
+		sha256_base_do_finalize(desc, sha256_neon_transform);
 		kernel_neon_end();
 	}
 	return sha256_base_finish(desc, out);
-- 
2.42.0

