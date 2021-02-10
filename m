Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4BF3C433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Feb 2021 07:16:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86EC86146D
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Feb 2021 07:16:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbhBJHQl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Feb 2021 02:16:41 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:50128 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230357AbhBJHQk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Feb 2021 02:16:40 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1l9jjB-0001BL-61; Wed, 10 Feb 2021 18:15:58 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 10 Feb 2021 18:15:57 +1100
Date:   Wed, 10 Feb 2021 18:15:57 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        ebiggers@kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] crypto: serpent - Fix sparse byte order warnings
Message-ID: <20210210071556.GA24991@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes the byte order markings in serpent.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/serpent_generic.c b/crypto/serpent_generic.c
index 236c87547a17..45f98b750053 100644
--- a/crypto/serpent_generic.c
+++ b/crypto/serpent_generic.c
@@ -272,6 +272,7 @@ int __serpent_setkey(struct serpent_ctx *ctx, const u8 *key,
 	u32 *k = ctx->expkey;
 	u8  *k8 = (u8 *)k;
 	u32 r0, r1, r2, r3, r4;
+	__le32 *lk;
 	int i;
 
 	/* Copy key, add padding */
@@ -283,22 +284,32 @@ int __serpent_setkey(struct serpent_ctx *ctx, const u8 *key,
 	while (i < SERPENT_MAX_KEY_SIZE)
 		k8[i++] = 0;
 
+	lk = (__le32 *)k;
+	k[0] = le32_to_cpu(lk[0]);
+	k[1] = le32_to_cpu(lk[1]);
+	k[2] = le32_to_cpu(lk[2]);
+	k[3] = le32_to_cpu(lk[3]);
+	k[4] = le32_to_cpu(lk[4]);
+	k[5] = le32_to_cpu(lk[5]);
+	k[6] = le32_to_cpu(lk[6]);
+	k[7] = le32_to_cpu(lk[7]);
+
 	/* Expand key using polynomial */
 
-	r0 = le32_to_cpu(k[3]);
-	r1 = le32_to_cpu(k[4]);
-	r2 = le32_to_cpu(k[5]);
-	r3 = le32_to_cpu(k[6]);
-	r4 = le32_to_cpu(k[7]);
-
-	keyiter(le32_to_cpu(k[0]), r0, r4, r2, 0, 0);
-	keyiter(le32_to_cpu(k[1]), r1, r0, r3, 1, 1);
-	keyiter(le32_to_cpu(k[2]), r2, r1, r4, 2, 2);
-	keyiter(le32_to_cpu(k[3]), r3, r2, r0, 3, 3);
-	keyiter(le32_to_cpu(k[4]), r4, r3, r1, 4, 4);
-	keyiter(le32_to_cpu(k[5]), r0, r4, r2, 5, 5);
-	keyiter(le32_to_cpu(k[6]), r1, r0, r3, 6, 6);
-	keyiter(le32_to_cpu(k[7]), r2, r1, r4, 7, 7);
+	r0 = k[3];
+	r1 = k[4];
+	r2 = k[5];
+	r3 = k[6];
+	r4 = k[7];
+
+	keyiter(k[0], r0, r4, r2, 0, 0);
+	keyiter(k[1], r1, r0, r3, 1, 1);
+	keyiter(k[2], r2, r1, r4, 2, 2);
+	keyiter(k[3], r3, r2, r0, 3, 3);
+	keyiter(k[4], r4, r3, r1, 4, 4);
+	keyiter(k[5], r0, r4, r2, 5, 5);
+	keyiter(k[6], r1, r0, r3, 6, 6);
+	keyiter(k[7], r2, r1, r4, 7, 7);
 
 	keyiter(k[0], r3, r2, r0, 8, 8);
 	keyiter(k[1], r4, r3, r1, 9, 9);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
