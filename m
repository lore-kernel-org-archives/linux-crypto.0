Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C42FCC25B4E
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Jan 2023 08:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjAVI4K (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Jan 2023 03:56:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjAVI4J (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Jan 2023 03:56:09 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B121E2BD
        for <linux-crypto@vger.kernel.org>; Sun, 22 Jan 2023 00:56:05 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pJW8w-002kcO-O5; Sun, 22 Jan 2023 16:56:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 22 Jan 2023 16:56:02 +0800
Date:   Sun, 22 Jan 2023 16:56:02 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: engine - Fix excess parameter doc warning
Message-ID: <Y8z6IsgLYVTzPzui@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The engine parameter should not be marked for kernel doc as it
triggers a warning.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index bb8e77077f02..64dc9aa3ca24 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -499,7 +499,7 @@ EXPORT_SYMBOL_GPL(crypto_engine_stop);
  *                This has the form:
  *                callback(struct crypto_engine *engine)
  *                where:
- *                @engine: the crypto engine structure.
+ *                engine: the crypto engine structure.
  * @rt: whether this queue is set to run as a realtime task
  * @qlen: maximum size of the crypto-engine queue
  *
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
