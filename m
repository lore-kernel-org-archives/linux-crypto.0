Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EE99C54EE9
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Sep 2022 10:53:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbiIPKx4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Sep 2022 06:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231931AbiIPKxj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Sep 2022 06:53:39 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74AF89CE6
        for <linux-crypto@vger.kernel.org>; Fri, 16 Sep 2022 03:35:54 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oZ8hK-005Gvs-VS; Fri, 16 Sep 2022 20:35:52 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 Sep 2022 18:35:50 +0800
Date:   Fri, 16 Sep 2022 18:35:50 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Lars Persson <lars.persson@axis.com>, linux-arm-kernel@axis.com
Subject: [PATCH] crypto: artpec6 - Fix printk warning on size_t/%d
Message-ID: <YyRRhv8mHcS4SFQY@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Switch to %zu instead of %d for printing size_t.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/axis/artpec6_crypto.c b/drivers/crypto/axis/artpec6_crypto.c
index b4820594ab80..51c66afbe677 100644
--- a/drivers/crypto/axis/artpec6_crypto.c
+++ b/drivers/crypto/axis/artpec6_crypto.c
@@ -1712,7 +1712,7 @@ static int artpec6_crypto_prepare_crypto(struct skcipher_request *areq)
 		cipher_len = regk_crypto_key_256;
 		break;
 	default:
-		pr_err("%s: Invalid key length %d!\n",
+		pr_err("%s: Invalid key length %zu!\n",
 			MODULE_NAME, ctx->key_length);
 		return -EINVAL;
 	}
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
