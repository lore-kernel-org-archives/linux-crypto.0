From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: tcrypt - Add rfc4309(ccm(aes)) speed test
Date: Wed, 17 Jun 2015 14:04:21 +0800
Message-ID: <20150617060421.GA9227@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51265 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbbFQGEY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Jun 2015 02:04:24 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds a speed test for rfc4309(ccm(aes)) as mode 212.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/tcrypt.c |    5 +++++
 crypto/tcrypt.h |    1 +
 2 files changed, 6 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 4b4a931..5146367 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1761,6 +1761,11 @@ static int do_test(const char *alg, u32 type, u32 mask, int m)
 				NULL, 0, 16, 8, aead_speed_template_20);
 		break;
 
+	case 212:
+		test_aead_speed("rfc4309(ccm(aes))", ENCRYPT, sec,
+				NULL, 0, 16, 8, aead_speed_template_19);
+		break;
+
 	case 300:
 		if (alg) {
 			test_hash_speed(alg, sec, generic_hash_speed_template);
diff --git a/crypto/tcrypt.h b/crypto/tcrypt.h
index 6c7e21a..6cc1b85 100644
--- a/crypto/tcrypt.h
+++ b/crypto/tcrypt.h
@@ -65,6 +65,7 @@ static u8 speed_template_32_64[] = {32, 64, 0};
 /*
  * AEAD speed tests
  */
+static u8 aead_speed_template_19[] = {19, 0};
 static u8 aead_speed_template_20[] = {20, 0};
 
 /*
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
