Return-Path: <SRS0=ou8b=6Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A01FC3A5A9
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 05:33:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20D862184D
	for <linux-crypto@archiver.kernel.org>; Sat,  2 May 2020 05:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588397626;
	bh=uzoN4MbeYC3SID044kBzYTpAiW1qfV2K/bhZYWaEBFc=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=FQJ2gsMiv1dVmZgqoMg6aXLrEKVraDD0HaYsdN3PGvbWrQ1R3sP1cWUux/BZZsROP
	 07CJuyMgzL6pdEmMOT6bMKt1SnMKsNDsWI0YvyaTwOvZM2SlXWM8K41fHs3tkJEhlZ
	 0LCegc45QsCBDDHmCEEh8kxryVnTtQYp1K+djhXI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgEBFdo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 May 2020 01:33:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:39220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727776AbgEBFdo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 May 2020 01:33:44 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA7C82184D
        for <linux-crypto@vger.kernel.org>; Sat,  2 May 2020 05:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588397623;
        bh=uzoN4MbeYC3SID044kBzYTpAiW1qfV2K/bhZYWaEBFc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=nMGD3X10FTUNAYs7wDGo6i65S85g2TUudSNMOmc6QzHLSN77ud7VE95bjhabsrhrf
         lg0ZdPgO7mM5N6GbbnUmsOyznBmezL6PjVVTjNCxJIXjQ/HIhOT7xB2tfibwpx8iF6
         /0iqDXuzXhDujB0td+5fL3JKl/3mgHIVYR3MSI5A=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 09/20] crypto: n2 - use crypto_shash_tfm_digest()
Date:   Fri,  1 May 2020 22:31:11 -0700
Message-Id: <20200502053122.995648-10-ebiggers@kernel.org>
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
 drivers/crypto/n2_core.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index f5c468f2cc82e9..6a828bbecea400 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -462,7 +462,6 @@ static int n2_hmac_async_setkey(struct crypto_ahash *tfm, const u8 *key,
 	struct n2_hmac_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct crypto_shash *child_shash = ctx->child_shash;
 	struct crypto_ahash *fallback_tfm;
-	SHASH_DESC_ON_STACK(shash, child_shash);
 	int err, bs, ds;
 
 	fallback_tfm = ctx->base.fallback_tfm;
@@ -470,14 +469,12 @@ static int n2_hmac_async_setkey(struct crypto_ahash *tfm, const u8 *key,
 	if (err)
 		return err;
 
-	shash->tfm = child_shash;
-
 	bs = crypto_shash_blocksize(child_shash);
 	ds = crypto_shash_digestsize(child_shash);
 	BUG_ON(ds > N2_HASH_KEY_MAX);
 	if (keylen > bs) {
-		err = crypto_shash_digest(shash, key, keylen,
-					  ctx->hash_key);
+		err = crypto_shash_tfm_digest(child_shash, key, keylen,
+					      ctx->hash_key);
 		if (err)
 			return err;
 		keylen = ds;
-- 
2.26.2

