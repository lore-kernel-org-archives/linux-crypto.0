Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84B60C05027
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Feb 2023 09:41:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbjBJJlO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Feb 2023 04:41:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbjBJJlM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Feb 2023 04:41:12 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F73772882
        for <linux-crypto@vger.kernel.org>; Fri, 10 Feb 2023 01:41:10 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pQPtp-009bul-2c; Fri, 10 Feb 2023 17:40:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 Feb 2023 17:40:57 +0800
Date:   Fri, 10 Feb 2023 17:40:57 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Neal Liu <neal_liu@aspeedtech.com>, Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-aspeed@lists.ozlabs.org
Subject: [PATCH] crypto: aspeed - Fix modular aspeed-acry
Message-ID: <Y+YRKdWUA4jjoUZ2@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When aspeed-acry is enabled as a module it doesn't get built at
all.  Fix this by adding it to obj-m.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/aspeed/Makefile b/drivers/crypto/aspeed/Makefile
index 24284d812b79..15862752c053 100644
--- a/drivers/crypto/aspeed/Makefile
+++ b/drivers/crypto/aspeed/Makefile
@@ -6,4 +6,6 @@ aspeed_crypto-objs := aspeed-hace.o	\
 		      $(hace-hash-y)	\
 		      $(hace-crypto-y)
 
-obj-$(CONFIG_CRYPTO_DEV_ASPEED_ACRY) += aspeed-acry.o
+aspeed_acry-$(CONFIG_CRYPTO_DEV_ASPEED_ACRY) += aspeed-acry.o
+
+obj-$(CONFIG_CRYPTO_DEV_ASPEED) += $(aspeed_acry-y)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
