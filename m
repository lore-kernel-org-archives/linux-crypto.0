From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 1/5] crypto: tcrypt - include rsa test
Date: Tue, 25 Apr 2017 16:26:35 +0300
Message-ID: <20170425132639.20178-2-horia.geanta@nxp.com>
References: <20170425132639.20178-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Radu Alexe <radu.alexe@nxp.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam02on0087.outbound.protection.outlook.com ([104.47.36.87]:56784
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1430993AbdDYN1N (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Apr 2017 09:27:13 -0400
In-Reply-To: <20170425132639.20178-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Radu Alexe <radu.alexe@nxp.com>

Signed-off-by: Radu Alexe <radu.alexe@nxp.com>
Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 crypto/tcrypt.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 9a11f3c2bf98..012fcd14c675 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -76,7 +76,7 @@ static char *check[] = {
 	"khazad", "wp512", "wp384", "wp256", "tnepres", "xeta",  "fcrypt",
 	"camellia", "seed", "salsa20", "rmd128", "rmd160", "rmd256", "rmd320",
 	"lzo", "cts", "zlib", "sha3-224", "sha3-256", "sha3-384", "sha3-512",
-	NULL
+	"rsa", NULL
 };
 
 struct tcrypt_result {
@@ -1333,6 +1333,10 @@ static int do_test(const char *alg, u32 type, u32 mask, int m)
 		ret += tcrypt_test("hmac(sha3-512)");
 		break;
 
+	case 115:
+		ret += tcrypt_test("rsa");
+		break;
+
 	case 150:
 		ret += tcrypt_test("ansi_cprng");
 		break;
-- 
2.12.0.264.gd6db3f216544
