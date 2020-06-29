Return-Path: <SRS0=qXKu=AK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D47F8C433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 21:38:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B037D206A1
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 21:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593466718;
	bh=1lVAbp/UQbFBMKlA8XOV50C3oMXVrVeEBOUNHDf/JDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=TErxal77qVNTJ7RwgWvKwcpg1hFIc67oJnBAWWD+8q1JepLBLk7B6CqqoLbboUKsP
	 t1D0v20BJTiuPIOTzhm3u1P6JZ6YvepxvhKoZTYeJQSeVGf7DL2DXCsu5Op3TVgjEA
	 0wHdOMUJAhPVmF5UQ4EutLNaOBYmhAt5doftf+Mo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbgF2Vih (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jun 2020 17:38:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728357AbgF2Skd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jun 2020 14:40:33 -0400
Received: from localhost.localdomain (82-64-249-211.subs.proxad.net [82.64.249.211])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60E2423332;
        Mon, 29 Jun 2020 07:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593416386;
        bh=1lVAbp/UQbFBMKlA8XOV50C3oMXVrVeEBOUNHDf/JDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zn3axqxtue0dZKx1y+9aereVNpaMWWsPBMGeeTzVK6O8zbB6czukuvJW0VPGBplLm
         cdN2POyjPvrFCYnzMNiC8FHrz5Bx7pLAeycHRF4KbKDb4BaB0ITH+P0wL9/gk8JDff
         LEVQ+fCoaNbX6Q7FOt+cxGUXWlC04gJ9S6n9Dots=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4/5] crypto: arm64/gcm - use inline helper to suppress indirect calls
Date:   Mon, 29 Jun 2020 09:39:24 +0200
Message-Id: <20200629073925.127538-5-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200629073925.127538-1-ardb@kernel.org>
References: <20200629073925.127538-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Introduce an inline wrapper for ghash_do_update() that incorporates
the indirect call to the asm routine that is passed as an argument,
and keep the non-SIMD fallback code out of line. This ensures that
all references to the function pointer are inlined where the address
is taken, removing the need for any indirect calls to begin with.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/crypto/ghash-ce-glue.c | 85 +++++++++++---------
 1 file changed, 46 insertions(+), 39 deletions(-)

diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
index 2ae95dcf648f..da1034867aaa 100644
--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -69,36 +69,43 @@ static int ghash_init(struct shash_desc *desc)
 }
 
 static void ghash_do_update(int blocks, u64 dg[], const char *src,
-			    struct ghash_key *key, const char *head,
-			    void (*simd_update)(int blocks, u64 dg[],
-						const char *src,
-						u64 const h[][2],
-						const char *head))
+			    struct ghash_key *key, const char *head)
 {
-	if (likely(crypto_simd_usable() && simd_update)) {
+	be128 dst = { cpu_to_be64(dg[1]), cpu_to_be64(dg[0]) };
+
+	do {
+		const u8 *in = src;
+
+		if (head) {
+			in = head;
+			blocks++;
+			head = NULL;
+		} else {
+			src += GHASH_BLOCK_SIZE;
+		}
+
+		crypto_xor((u8 *)&dst, in, GHASH_BLOCK_SIZE);
+		gf128mul_lle(&dst, &key->k);
+	} while (--blocks);
+
+	dg[0] = be64_to_cpu(dst.b);
+	dg[1] = be64_to_cpu(dst.a);
+}
+
+static __always_inline
+void ghash_do_simd_update(int blocks, u64 dg[], const char *src,
+			  struct ghash_key *key, const char *head,
+			  void (*simd_update)(int blocks, u64 dg[],
+					      const char *src,
+					      u64 const h[][2],
+					      const char *head))
+{
+	if (likely(crypto_simd_usable())) {
 		kernel_neon_begin();
 		simd_update(blocks, dg, src, key->h, head);
 		kernel_neon_end();
 	} else {
-		be128 dst = { cpu_to_be64(dg[1]), cpu_to_be64(dg[0]) };
-
-		do {
-			const u8 *in = src;
-
-			if (head) {
-				in = head;
-				blocks++;
-				head = NULL;
-			} else {
-				src += GHASH_BLOCK_SIZE;
-			}
-
-			crypto_xor((u8 *)&dst, in, GHASH_BLOCK_SIZE);
-			gf128mul_lle(&dst, &key->k);
-		} while (--blocks);
-
-		dg[0] = be64_to_cpu(dst.b);
-		dg[1] = be64_to_cpu(dst.a);
+		ghash_do_update(blocks, dg, src, key, head);
 	}
 }
 
@@ -131,9 +138,9 @@ static int ghash_update(struct shash_desc *desc, const u8 *src,
 		do {
 			int chunk = min(blocks, MAX_BLOCKS);
 
-			ghash_do_update(chunk, ctx->digest, src, key,
-					partial ? ctx->buf : NULL,
-					pmull_ghash_update_p8);
+			ghash_do_simd_update(chunk, ctx->digest, src, key,
+					     partial ? ctx->buf : NULL,
+					     pmull_ghash_update_p8);
 
 			blocks -= chunk;
 			src += chunk * GHASH_BLOCK_SIZE;
@@ -155,8 +162,8 @@ static int ghash_final(struct shash_desc *desc, u8 *dst)
 
 		memset(ctx->buf + partial, 0, GHASH_BLOCK_SIZE - partial);
 
-		ghash_do_update(1, ctx->digest, ctx->buf, key, NULL,
-				pmull_ghash_update_p8);
+		ghash_do_simd_update(1, ctx->digest, ctx->buf, key, NULL,
+				     pmull_ghash_update_p8);
 	}
 	put_unaligned_be64(ctx->digest[1], dst);
 	put_unaligned_be64(ctx->digest[0], dst + 8);
@@ -280,9 +287,9 @@ static void gcm_update_mac(u64 dg[], const u8 *src, int count, u8 buf[],
 	if (count >= GHASH_BLOCK_SIZE || *buf_count == GHASH_BLOCK_SIZE) {
 		int blocks = count / GHASH_BLOCK_SIZE;
 
-		ghash_do_update(blocks, dg, src, &ctx->ghash_key,
-				*buf_count ? buf : NULL,
-				pmull_ghash_update_p64);
+		ghash_do_simd_update(blocks, dg, src, &ctx->ghash_key,
+				     *buf_count ? buf : NULL,
+				     pmull_ghash_update_p64);
 
 		src += blocks * GHASH_BLOCK_SIZE;
 		count %= GHASH_BLOCK_SIZE;
@@ -326,8 +333,8 @@ static void gcm_calculate_auth_mac(struct aead_request *req, u64 dg[])
 
 	if (buf_count) {
 		memset(&buf[buf_count], 0, GHASH_BLOCK_SIZE - buf_count);
-		ghash_do_update(1, dg, buf, &ctx->ghash_key, NULL,
-				pmull_ghash_update_p64);
+		ghash_do_simd_update(1, dg, buf, &ctx->ghash_key, NULL,
+				     pmull_ghash_update_p64);
 	}
 }
 
@@ -403,7 +410,7 @@ static int gcm_encrypt(struct aead_request *req)
 			} while (--remaining > 0);
 
 			ghash_do_update(blocks, dg, walk.dst.virt.addr,
-					&ctx->ghash_key, NULL, NULL);
+					&ctx->ghash_key, NULL);
 
 			err = skcipher_walk_done(&walk,
 						 walk.nbytes % AES_BLOCK_SIZE);
@@ -422,7 +429,7 @@ static int gcm_encrypt(struct aead_request *req)
 
 		tag = (u8 *)&lengths;
 		ghash_do_update(1, dg, tag, &ctx->ghash_key,
-				walk.nbytes ? buf : NULL, NULL);
+				walk.nbytes ? buf : NULL);
 
 		if (walk.nbytes)
 			err = skcipher_walk_done(&walk, 0);
@@ -507,7 +514,7 @@ static int gcm_decrypt(struct aead_request *req)
 			u8 *dst = walk.dst.virt.addr;
 
 			ghash_do_update(blocks, dg, walk.src.virt.addr,
-					&ctx->ghash_key, NULL, NULL);
+					&ctx->ghash_key, NULL);
 
 			do {
 				aes_encrypt(&ctx->aes_key, buf, iv);
@@ -530,7 +537,7 @@ static int gcm_decrypt(struct aead_request *req)
 
 		tag = (u8 *)&lengths;
 		ghash_do_update(1, dg, tag, &ctx->ghash_key,
-				walk.nbytes ? buf : NULL, NULL);
+				walk.nbytes ? buf : NULL);
 
 		if (walk.nbytes) {
 			aes_encrypt(&ctx->aes_key, buf, iv);
-- 
2.20.1

