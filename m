Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 355C3C54EED
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Jan 2023 08:58:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233324AbjA3I65 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Jan 2023 03:58:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233298AbjA3I64 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Jan 2023 03:58:56 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915531C58C
        for <linux-crypto@vger.kernel.org>; Mon, 30 Jan 2023 00:58:54 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pMQ03-005WO7-Ft; Mon, 30 Jan 2023 16:58:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 30 Jan 2023 16:58:51 +0800
Date:   Mon, 30 Jan 2023 16:58:51 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH] crypto: arm64/aes-ccm - Rewrite skcipher walker loop
Message-ID: <Y9eGyzZ+JAqRQvtm@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

An often overlooked aspect of the skcipher walker API is that an
error is not just indicated by a non-zero return value, but by the
fact that walk->nbytes is zero.

Thus it is an error to call skcipher_walk_done after getting back
walk->nbytes == 0 from the previous interaction with the walker.

This is because when walk->nbytes is zero the walker is left in
an undefined state and any further calls to it may try to free
uninitialised stack memory.

The arm64 ccm code has to deal with zero-length messages, and
it needs to process data even when walk->nbytes == 0 is returned.
It doesn't have this bug because there is an explicit check for
walk->nbytes != 0 prior to the skcipher_walk_done call.

However, the loop is still sufficiently different from the usual
layout and it appears to have been copied into other code which
then ended up with this bug.  This patch rewrites it to follow the
usual convention of checking walk->nbytes.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/arm64/crypto/aes-ce-ccm-glue.c b/arch/arm64/crypto/aes-ce-ccm-glue.c
index c4f14415f5f0..25cd3808ecbe 100644
--- a/arch/arm64/crypto/aes-ce-ccm-glue.c
+++ b/arch/arm64/crypto/aes-ce-ccm-glue.c
@@ -161,43 +161,39 @@ static int ccm_encrypt(struct aead_request *req)
 	memcpy(buf, req->iv, AES_BLOCK_SIZE);
 
 	err = skcipher_walk_aead_encrypt(&walk, req, false);
-	if (unlikely(err))
-		return err;
 
 	kernel_neon_begin();
 
 	if (req->assoclen)
 		ccm_calculate_auth_mac(req, mac);
 
-	do {
+	while (walk.nbytes) {
 		u32 tail = walk.nbytes % AES_BLOCK_SIZE;
+		bool final = walk.nbytes == walk.total;
 
-		if (walk.nbytes == walk.total)
+		if (final)
 			tail = 0;
 
 		ce_aes_ccm_encrypt(walk.dst.virt.addr, walk.src.virt.addr,
 				   walk.nbytes - tail, ctx->key_enc,
 				   num_rounds(ctx), mac, walk.iv);
 
-		if (walk.nbytes == walk.total)
-			ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
+		if (!final)
+			kernel_neon_end();
+		err = skcipher_walk_done(&walk, tail);
+		if (!final)
+			kernel_neon_begin();
+	}
 
-		kernel_neon_end();
+	ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
 
-		if (walk.nbytes) {
-			err = skcipher_walk_done(&walk, tail);
-			if (unlikely(err))
-				return err;
-			if (unlikely(walk.nbytes))
-				kernel_neon_begin();
-		}
-	} while (walk.nbytes);
+	kernel_neon_end();
 
 	/* copy authtag to end of dst */
 	scatterwalk_map_and_copy(mac, req->dst, req->assoclen + req->cryptlen,
 				 crypto_aead_authsize(aead), 1);
 
-	return 0;
+	return err;
 }
 
 static int ccm_decrypt(struct aead_request *req)
@@ -219,37 +215,36 @@ static int ccm_decrypt(struct aead_request *req)
 	memcpy(buf, req->iv, AES_BLOCK_SIZE);
 
 	err = skcipher_walk_aead_decrypt(&walk, req, false);
-	if (unlikely(err))
-		return err;
 
 	kernel_neon_begin();
 
 	if (req->assoclen)
 		ccm_calculate_auth_mac(req, mac);
 
-	do {
+	while (walk.nbytes) {
 		u32 tail = walk.nbytes % AES_BLOCK_SIZE;
+		bool final = walk.nbytes == walk.total;
 
-		if (walk.nbytes == walk.total)
+		if (final)
 			tail = 0;
 
 		ce_aes_ccm_decrypt(walk.dst.virt.addr, walk.src.virt.addr,
 				   walk.nbytes - tail, ctx->key_enc,
 				   num_rounds(ctx), mac, walk.iv);
 
-		if (walk.nbytes == walk.total)
-			ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
+		if (!final)
+			kernel_neon_end();
+		err = skcipher_walk_done(&walk, tail);
+		if (!final)
+			kernel_neon_begin();
+	}
 
-		kernel_neon_end();
+	ce_aes_ccm_final(mac, buf, ctx->key_enc, num_rounds(ctx));
 
-		if (walk.nbytes) {
-			err = skcipher_walk_done(&walk, tail);
-			if (unlikely(err))
-				return err;
-			if (unlikely(walk.nbytes))
-				kernel_neon_begin();
-		}
-	} while (walk.nbytes);
+	kernel_neon_end();
+
+	if (unlikely(err))
+		return err;
 
 	/* compare calculated auth tag with the stored one */
 	scatterwalk_map_and_copy(buf, req->src,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
