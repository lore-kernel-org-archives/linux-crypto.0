From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 14/14] crypto: testmgr - Reenable rfc4106 test
Date: Thu, 09 Jul 2015 07:17:34 +0800
Message-ID: <E1ZCyas-0007bI-Kw@gondolin.me.apana.org.au>
References: <20150708231330.GA28797@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39645 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbbGHXRi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jul 2015 19:17:38 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1ZCyau-0005IZ-4T
	for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2015 09:17:36 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Now that all implementations of rfc4106 have been converted we can
reenable the test.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/testmgr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index c4fe6a8..d0a42bd 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3492,7 +3492,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		.alg = "rfc4106(gcm(aes))-disabled",
+		.alg = "rfc4106(gcm(aes))",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
