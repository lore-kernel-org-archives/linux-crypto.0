Return-Path: <SRS0=ou8b=6Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7661C47254
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 05:33:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFF512071E
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 05:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588397626;
	bh=i49rYlWOgGRkpQzKkI6h8x4Gn4+mja8Y0bFYbbJ2QY0=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Ajo4sCiUbQahUje36kszrApXE8/a6lnjqKy2ox29cKJSdQOkl/TZVBVW+k3xhVWLi
	 Kl/aYL4cbT8D7aIraE2oXtJb9X+XOrwEtH2xTrhKTa9/FvOMwiY4tOVKm92ov5DYxZ
	 Sf99Sv+3CBvz3UtG7OSQMFuvQCbUoZ+afXhM7VKA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgEBFdp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 May 2020 01:33:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727778AbgEBFdo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 May 2020 01:33:44 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1E6324957
        for <linux-crypto@vger.kernel.org>; Sat,  2 May 2020 05:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588397624;
        bh=i49rYlWOgGRkpQzKkI6h8x4Gn4+mja8Y0bFYbbJ2QY0=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=gnQ0t06SZ883q3MY07cVsMqByZiysc+XyC0zDThT390R0X8MXqbUjHcG7QwA6bcHT
         ACyP1VWn0mb9DbPwzKrJgzaWwq5ly8m7j4bE9axqx6hHWyuvJl2/kJo0ORrqXh+y7j
         QLYNRO9SvGxwOdjD2+K/+XDkiRVbNfbcEYqtiZeA=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 10/20] crypto: omap-sham - use crypto_shash_tfm_digest()
Date:   Fri,  1 May 2020 22:31:12 -0700
Message-Id: <20200502053122.995648-11-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200502053122.995648-1-ebiggers@kernel.org>
References: <20200502053122.995648-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Instead of manually allocating a 'struct shash_desc' on the stack and
calling crypto_shash_digest(), switch to using the new helper function
crypto_shash_tfm_digest() which does this for us.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/omap-sham.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index e4072cd385857c..d600c5b3fdd3f6 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1245,16 +1245,6 @@ static int omap_sham_update(struct ahash_request *req)
 	return omap_sham_enqueue(req, OP_UPDATE);
 }
 
-static int omap_sham_shash_digest(struct crypto_shash *tfm, u32 flags,
-				  const u8 *data, unsigned int len, u8 *out)
-{
-	SHASH_DESC_ON_STACK(shash, tfm);
-
-	shash->tfm = tfm;
-
-	return crypto_shash_digest(shash, data, len, out);
-}
-
 static int omap_sham_final_shash(struct ahash_request *req)
 {
 	struct omap_sham_ctx *tctx = crypto_tfm_ctx(req->base.tfm);
@@ -1270,9 +1260,8 @@ static int omap_sham_final_shash(struct ahash_request *req)
 	    !test_bit(FLAGS_AUTO_XOR, &ctx->dd->flags))
 		offset = get_block_size(ctx);
 
-	return omap_sham_shash_digest(tctx->fallback, req->base.flags,
-				      ctx->buffer + offset,
-				      ctx->bufcnt - offset, req->result);
+	return crypto_shash_tfm_digest(tctx->fallback, ctx->buffer + offset,
+				       ctx->bufcnt - offset, req->result);
 }
 
 static int omap_sham_final(struct ahash_request *req)
@@ -1351,9 +1340,8 @@ static int omap_sham_setkey(struct crypto_ahash *tfm, const u8 *key,
 		return err;
 
 	if (keylen > bs) {
-		err = omap_sham_shash_digest(bctx->shash,
-				crypto_shash_get_flags(bctx->shash),
-				key, keylen, bctx->ipad);
+		err = crypto_shash_tfm_digest(bctx->shash, key, keylen,
+					      bctx->ipad);
 		if (err)
 			return err;
 		keylen = ds;
-- 
2.26.2

