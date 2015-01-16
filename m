From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: cts - Weed out non-CBC algorithms
Date: Fri, 16 Jan 2015 19:38:17 +1100
Message-ID: <20150116083817.GA9713@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Kevin Coffman <kwc@citi.umich.edu>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:44364 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbbAPIiV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 Jan 2015 03:38:21 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The cts algorithm as currently implemented assumes the underlying
is a CBC-mode algorithm.  So this patch adds a check for that to
eliminate bogus combinations of cts with non-CBC modes.
 
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/cts.c b/crypto/cts.c
index 6a8089c..e467ec0 100644
--- a/crypto/cts.c
+++ b/crypto/cts.c
@@ -290,6 +290,9 @@ static struct crypto_instance *crypto_cts_alloc(struct rtattr **tb)
 	if (!is_power_of_2(alg->cra_blocksize))
 		goto out_put_alg;
 
+	if (strncmp(alg->cra_name, "cbc(", 4))
+		goto out_put_alg;
+
 	inst = crypto_alloc_instance("cts", alg);
 	if (IS_ERR(inst))
 		goto out_put_alg;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
