From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 06/18] crypto: tcrypt: add lrw(serpent) tests
Date: Tue, 18 Oct 2011 13:32:39 +0300
Message-ID: <20111018103239.3074.35142.stgit@localhost6.localdomain6>
References: <20111018103208.3074.11546.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:43378 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab1JRKco (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 Oct 2011 06:32:44 -0400
In-Reply-To: <20111018103208.3074.11546.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 crypto/tcrypt.c |    9 +++++++++
 crypto/tcrypt.h |    1 +
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 5526065..9a9e170 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -996,6 +996,7 @@ static int do_test(int m)
 		ret += tcrypt_test("ecb(serpent)");
 		ret += tcrypt_test("cbc(serpent)");
 		ret += tcrypt_test("ctr(serpent)");
+		ret += tcrypt_test("lrw(serpent)");
 		break;
 
 	case 10:
@@ -1305,6 +1306,10 @@ static int do_test(int m)
 				  speed_template_16_32);
 		test_cipher_speed("ctr(serpent)", DECRYPT, sec, NULL, 0,
 				  speed_template_16_32);
+		test_cipher_speed("lrw(serpent)", ENCRYPT, sec, NULL, 0,
+				  speed_template_32_48);
+		test_cipher_speed("lrw(serpent)", DECRYPT, sec, NULL, 0,
+				  speed_template_32_48);
 		break;
 
 	case 300:
@@ -1521,6 +1526,10 @@ static int do_test(int m)
 				   speed_template_16_32);
 		test_acipher_speed("ctr(serpent)", DECRYPT, sec, NULL, 0,
 				   speed_template_16_32);
+		test_acipher_speed("lrw(serpent)", ENCRYPT, sec, NULL, 0,
+				   speed_template_32_48);
+		test_acipher_speed("lrw(serpent)", DECRYPT, sec, NULL, 0,
+				   speed_template_32_48);
 		break;
 
 	case 1000:
diff --git a/crypto/tcrypt.h b/crypto/tcrypt.h
index 10cb925..3eceaef 100644
--- a/crypto/tcrypt.h
+++ b/crypto/tcrypt.h
@@ -51,6 +51,7 @@ static u8 speed_template_8_32[] = {8, 32, 0};
 static u8 speed_template_16_32[] = {16, 32, 0};
 static u8 speed_template_16_24_32[] = {16, 24, 32, 0};
 static u8 speed_template_32_40_48[] = {32, 40, 48, 0};
+static u8 speed_template_32_48[] = {32, 48, 0};
 static u8 speed_template_32_48_64[] = {32, 48, 64, 0};
 
 /*
