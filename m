From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/5] crypto: testmgr - Reenable rfc4309 test
Date: Tue, 14 Jul 2015 16:53:22 +0800
Message-ID: <E1ZEvxq-0005dz-Cr@gondolin.me.apana.org.au>
References: <20150714084547.GA21551@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44832 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbbGNIx0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jul 2015 04:53:26 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1ZEvxr-0000Y9-57
	for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2015 18:53:23 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Now that all implementations of rfc4309 have been converted we can
reenable the test.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/testmgr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index f89b028..d0a42bd 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3508,7 +3508,7 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
-		.alg = "rfc4309(ccm(aes))-disabled",
+		.alg = "rfc4309(ccm(aes))",
 		.test = alg_test_aead,
 		.fips_allowed = 1,
 		.suite = {
