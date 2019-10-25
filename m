Return-Path: <SRS0=9dQ/=YS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58159C47E49
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 19:45:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28878222C2
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 19:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572032726;
	bh=F/Itm5Sg58J8q/KcqAjEUFGiQ4E5Atl6EkfG8bOviUs=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=XiWeX6hmH42F6TtQpD/Zzdv5CMvMJMVJEw2+RDkCn9ijIpbuJAyd99AxBX03fmRet
	 ESuXoPdt/MOvFIJuikJz/oR2MRh4+0yOnnAuxM6qocpyDQ0ItLpE6h5BiYHbBUamTs
	 dQH55iJTfR2avRNZgT3FIUSZMcLTBO4Z2hZO2z2g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbfJYTpZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Oct 2019 15:45:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727546AbfJYTpZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Oct 2019 15:45:25 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2309F222BE
        for <linux-crypto@vger.kernel.org>; Fri, 25 Oct 2019 19:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572032724;
        bh=F/Itm5Sg58J8q/KcqAjEUFGiQ4E5Atl6EkfG8bOviUs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=pmeQ9BFlG1JNdbGvEqtjF/3xJeg7OiT2P7pO3jB5OyYsEl7t7YwUh5Ww0UtnW4bVU
         Cj+t7W3Pr/VDkKcYQwfWASdnJDae01eG4vLiwUSPll1yJRkkykqTE3F6f5nwOFrdS5
         smSAU5ZmjUQ3UvT/rb8uk2SA/lVYAbyW8Uere8/g=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 3/5] crypto: rename crypto_skcipher_type2 to crypto_skcipher_type
Date:   Fri, 25 Oct 2019 12:41:11 -0700
Message-Id: <20191025194113.217451-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191025194113.217451-1-ebiggers@kernel.org>
References: <20191025194113.217451-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Now that the crypto_skcipher_type() function has been removed, there's
no reason to call the crypto_type struct for skciphers
"crypto_skcipher_type2".  Rename it to simply "crypto_skcipher_type".

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/skcipher.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 233678d07816..490a3f4b5102 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -964,7 +964,7 @@ static int crypto_skcipher_report(struct sk_buff *skb, struct crypto_alg *alg)
 }
 #endif
 
-static const struct crypto_type crypto_skcipher_type2 = {
+static const struct crypto_type crypto_skcipher_type = {
 	.extsize = crypto_skcipher_extsize,
 	.init_tfm = crypto_skcipher_init_tfm,
 	.free = crypto_skcipher_free_instance,
@@ -981,7 +981,7 @@ static const struct crypto_type crypto_skcipher_type2 = {
 int crypto_grab_skcipher(struct crypto_skcipher_spawn *spawn,
 			  const char *name, u32 type, u32 mask)
 {
-	spawn->base.frontend = &crypto_skcipher_type2;
+	spawn->base.frontend = &crypto_skcipher_type;
 	return crypto_grab_spawn(&spawn->base, name, type, mask);
 }
 EXPORT_SYMBOL_GPL(crypto_grab_skcipher);
@@ -989,7 +989,7 @@ EXPORT_SYMBOL_GPL(crypto_grab_skcipher);
 struct crypto_skcipher *crypto_alloc_skcipher(const char *alg_name,
 					      u32 type, u32 mask)
 {
-	return crypto_alloc_tfm(alg_name, &crypto_skcipher_type2, type, mask);
+	return crypto_alloc_tfm(alg_name, &crypto_skcipher_type, type, mask);
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_skcipher);
 
@@ -1001,7 +1001,7 @@ struct crypto_sync_skcipher *crypto_alloc_sync_skcipher(
 	/* Only sync algorithms allowed. */
 	mask |= CRYPTO_ALG_ASYNC;
 
-	tfm = crypto_alloc_tfm(alg_name, &crypto_skcipher_type2, type, mask);
+	tfm = crypto_alloc_tfm(alg_name, &crypto_skcipher_type, type, mask);
 
 	/*
 	 * Make sure we do not allocate something that might get used with
@@ -1019,8 +1019,7 @@ EXPORT_SYMBOL_GPL(crypto_alloc_sync_skcipher);
 
 int crypto_has_skcipher(const char *alg_name, u32 type, u32 mask)
 {
-	return crypto_type_has_alg(alg_name, &crypto_skcipher_type2,
-				   type, mask);
+	return crypto_type_has_alg(alg_name, &crypto_skcipher_type, type, mask);
 }
 EXPORT_SYMBOL_GPL(crypto_has_skcipher);
 
@@ -1037,7 +1036,7 @@ static int skcipher_prepare_alg(struct skcipher_alg *alg)
 	if (!alg->walksize)
 		alg->walksize = alg->chunksize;
 
-	base->cra_type = &crypto_skcipher_type2;
+	base->cra_type = &crypto_skcipher_type;
 	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
 	base->cra_flags |= CRYPTO_ALG_TYPE_SKCIPHER;
 
-- 
2.23.0

