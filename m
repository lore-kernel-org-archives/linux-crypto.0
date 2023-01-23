Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB23CC05027
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Jan 2023 10:09:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjAWKJC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Jan 2023 05:09:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbjAWKJB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Jan 2023 05:09:01 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2B3CC21
        for <linux-crypto@vger.kernel.org>; Mon, 23 Jan 2023 02:08:59 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pJtl2-0032OF-SJ; Mon, 23 Jan 2023 18:08:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 23 Jan 2023 18:08:56 +0800
Date:   Mon, 23 Jan 2023 18:08:56 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] Revert "crypto: rsa-pkcs1pad - Replace GFP_ATOMIC with
 GFP_KERNEL in pkcs1pad_encrypt_sign_complete"
Message-ID: <Y85cuHaIIF47TfAs@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This reverts commit 1ca2809897155f1adc43e4859b4a3582e235c09a.

While the akcipher API as a whole is designed to be called only
from thread context, its completion path is still called from
softirq context as usual.  Therefore we must not use GFP_KERNEL
on that path.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 6ee5b8a060c0..141f7e08df6a 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -190,7 +190,7 @@ static int pkcs1pad_encrypt_sign_complete(struct akcipher_request *req, int err)
 	if (likely(!pad_len))
 		goto out;
 
-	out_buf = kzalloc(ctx->key_size, GFP_KERNEL);
+	out_buf = kzalloc(ctx->key_size, GFP_ATOMIC);
 	err = -ENOMEM;
 	if (!out_buf)
 		goto out;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
