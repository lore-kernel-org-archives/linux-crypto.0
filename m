From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] crypto: drbg - fix an error code in drbg_init_sym_kernel()
Date: Fri, 17 Jun 2016 12:16:19 +0300
Message-ID: <20160617091618.GC25609@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29042 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbcFQJQn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Jun 2016 05:16:43 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

We accidentally return PTR_ERR(NULL) which is success but we should
return -ENOMEM.

Fixes: 355912852115 ('crypto: drbg - use CTR AES instead of ECB AES')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/crypto/drbg.c b/crypto/drbg.c
index ded8638..6872d15 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1686,7 +1686,7 @@ static int drbg_init_sym_kernel(struct drbg_state *drbg)
 	if (!req) {
 		pr_info("DRBG: could not allocate request queue\n");
 		drbg_fini_sym_kernel(drbg);
-		return PTR_ERR(req);
+		return -ENOMEM;
 	}
 	drbg->ctr_req = req;
 	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
