From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/5] [CRYPTO] tcrypt: Make gcm available as a standalone test
Date: Fri, 07 Dec 2007 16:19:43 +0800
Message-ID: <E1J0YQx-00021g-00@gondolin.me.apana.org.au>
References: <20071207081904.GA7733@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1987 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751703AbXLGITq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Dec 2007 03:19:46 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J0YQy-0005EO-11
	for <linux-crypto@vger.kernel.org>; Fri, 07 Dec 2007 19:19:44 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] tcrypt: Make gcm available as a standalone test

Currently the gcm(aes) tests have to be taken together with all other
ciphers.  This patch makes it available by itself at number 35.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/tcrypt.c |    7 +++++++
 1 files changed, 7 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 387d105..df93595 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1548,6 +1548,13 @@ static void do_test(void)
 			    SALSA20_STREAM_ENC_TEST_VECTORS);
 		break;
 
+	case 35:
+		test_aead("gcm(aes)", ENCRYPT, aes_gcm_enc_tv_template,
+			  AES_GCM_ENC_TEST_VECTORS);
+		test_aead("gcm(aes)", DECRYPT, aes_gcm_dec_tv_template,
+			  AES_GCM_DEC_TEST_VECTORS);
+		break;
+
 	case 100:
 		test_hash("hmac(md5)", hmac_md5_tv_template,
 			  HMAC_MD5_TEST_VECTORS);
