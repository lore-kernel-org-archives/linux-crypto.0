From: Rameshwar Prasad Sahu <rsahu@apm.com>
Subject: [PATCH v1 4/4] Crypto: tcrypt: Add test case for APM X-Gene SoC CRC32C algo
Date: Thu, 30 Jul 2015 17:41:08 +0530
Message-ID: <1438258268-3099-5-git-send-email-rsahu@apm.com>
References: <1438258268-3099-1-git-send-email-rsahu@apm.com>
Cc: linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org,
	arnd@arndb.de, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	jcm@redhat.com, patches@apm.com,
	Rameshwar Prasad Sahu <rsahu@apm.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com,
	herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438258268-3099-1-git-send-email-rsahu@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch adds test case for APM X-Gene SoC CRC32C algorithm.

Signed-off-by: Rameshwar Prasad Sahu <rsahu@apm.com>
---
 crypto/tcrypt.c  | 4 ++++
 crypto/testmgr.c | 9 +++++++++
 2 files changed, 13 insertions(+)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 9f6f10b..0bbb1e2 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1465,6 +1465,10 @@ static int do_test(const char *alg, u32 type, u32 mask, int m)
 		ret += tcrypt_test("crct10dif");
 		break;

+	case 48:
+		ret += tcrypt_test("xgene(crc32c)");
+		break;
+
 	case 100:
 		ret += tcrypt_test("hmac(md5)");
 		break;
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index d0a42bd..a65860e 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3748,6 +3748,15 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "xgene(crc32c)",
+		.test = alg_test_hash,
+		.suite = {
+			.hash = {
+				.vecs = crc32c_tv_template,
+				.count = CRC32C_TEST_VECTORS
+			}
+		}
+	}, {
 		.alg = "xts(aes)",
 		.test = alg_test_skcipher,
 		.fips_allowed = 1,
--
1.8.2.1
