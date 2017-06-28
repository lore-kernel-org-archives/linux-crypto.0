From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: testmgr - Reenable sha1/aes in FIPS mode
Date: Wed, 28 Jun 2017 19:09:07 +0800
Message-ID: <20170628110907.GA14186@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:41506 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751498AbdF1LJb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Jun 2017 07:09:31 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The combination of sha1 and aes was disabled in FIPS Mode
accidentally.  This patch reenables it.

Fixes: 284a0f6e87b0 ("crypto: testmgr - Disable fips-allowed for...")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 32087a7..7125ba3 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2366,6 +2366,7 @@ static int alg_test_null(const struct alg_test_desc *desc,
 	}, {
 		.alg = "authenc(hmac(sha1),cbc(aes))",
 		.test = alg_test_aead,
+		.fips_allowed = 1,
 		.suite = {
 			.aead = {
 				.enc = __VECS(hmac_sha1_aes_cbc_enc_tv_temp)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
