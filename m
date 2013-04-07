From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [PATCH 4/4] crypto: testmgr - add empty test vectors for null
 ciphers
Date: Sun, 07 Apr 2013 16:43:56 +0300
Message-ID: <20130407134356.8718.61691.stgit@localhost6.localdomain6>
References: <20130407134340.8718.96643.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:42043 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933630Ab3DGNn6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Apr 2013 09:43:58 -0400
In-Reply-To: <20130407134340.8718.96643.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Without these, kernel log shows:
[    5.984881] alg: No test for cipher_null (cipher_null-generic)
[    5.985096] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    5.985170] alg: No test for compress_null (compress_null-generic)
[    5.985297] alg: No test for digest_null (digest_null-generic)

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 crypto/testmgr.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 442ddb4..f37e544 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1913,6 +1913,9 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "compress_null",
+		.test = alg_test_null,
+	}, {
 		.alg = "crc32c",
 		.test = alg_test_crc32c,
 		.fips_allowed = 1,
@@ -2127,6 +2130,9 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "digest_null",
+		.test = alg_test_null,
+	}, {
 		.alg = "ecb(__aes-aesni)",
 		.test = alg_test_null,
 		.fips_allowed = 1,
@@ -2237,6 +2243,9 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "ecb(cipher_null)",
+		.test = alg_test_null,
+	}, {
 		.alg = "ecb(des)",
 		.test = alg_test_skcipher,
 		.fips_allowed = 1,
