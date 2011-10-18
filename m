From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 14/18] crypto: tcrypt: add xts(serpent) tests
Date: Tue, 18 Oct 2011 13:33:22 +0300
Message-ID: <20111018103322.3074.79308.stgit@localhost6.localdomain6>
References: <20111018103208.3074.11546.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:39450 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab1JRKde (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 Oct 2011 06:33:34 -0400
In-Reply-To: <20111018103208.3074.11546.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/tcrypt.c |    9 +++++++++
 crypto/tcrypt.h |    1 +
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 0120383..a664595 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -998,6 +998,7 @@ static int do_test(int m)
 		ret += tcrypt_test("cbc(serpent)");
 		ret += tcrypt_test("ctr(serpent)");
 		ret += tcrypt_test("lrw(serpent)");
+		ret += tcrypt_test("xts(serpent)");
 		break;
 
 	case 10:
@@ -1315,6 +1316,10 @@ static int do_test(int m)
 				  speed_template_32_48);
 		test_cipher_speed("lrw(serpent)", DECRYPT, sec, NULL, 0,
 				  speed_template_32_48);
+		test_cipher_speed("xts(serpent)", ENCRYPT, sec, NULL, 0,
+				  speed_template_32_64);
+		test_cipher_speed("xts(serpent)", DECRYPT, sec, NULL, 0,
+				  speed_template_32_64);
 		break;
 
 	case 300:
@@ -1535,6 +1540,10 @@ static int do_test(int m)
 				   speed_template_32_48);
 		test_acipher_speed("lrw(serpent)", DECRYPT, sec, NULL, 0,
 				   speed_template_32_48);
+		test_acipher_speed("xts(serpent)", ENCRYPT, sec, NULL, 0,
+				   speed_template_32_64);
+		test_acipher_speed("xts(serpent)", DECRYPT, sec, NULL, 0,
+				   speed_template_32_64);
 		break;
 
 	case 1000:
diff --git a/crypto/tcrypt.h b/crypto/tcrypt.h
index 3eceaef..5be1fc8 100644
--- a/crypto/tcrypt.h
+++ b/crypto/tcrypt.h
@@ -53,6 +53,7 @@ static u8 speed_template_16_24_32[] = {16, 24, 32, 0};
 static u8 speed_template_32_40_48[] = {32, 40, 48, 0};
 static u8 speed_template_32_48[] = {32, 48, 0};
 static u8 speed_template_32_48_64[] = {32, 48, 64, 0};
+static u8 speed_template_32_64[] = {32, 64, 0};
 
 /*
  * Digest speed tests
