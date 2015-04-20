From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: drbg - Initialise mutex in drbg_healthcheck_sanity
Date: Mon, 20 Apr 2015 11:26:48 +0800
Message-ID: <20150420032648.GA17746@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Stephan Mueller <smueller@chronox.de>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42907 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbbDTD0z (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 19 Apr 2015 23:26:55 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As we moved the mutex init out of drbg_instantiate and into cra_init
we need to explicitly initialise the mutex in drbg_healthcheck_sanity.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 30ec2a6..57fd479 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1741,6 +1741,8 @@ static inline int __init drbg_healthcheck_sanity(void)
 	if (!drbg)
 		return -ENOMEM;
 
+	mutex_init(&drbg->drbg_mutex);
+
 	/*
 	 * if the following tests fail, it is likely that there is a buffer
 	 * overflow as buf is much smaller than the requested or provided
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
