From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: [PATCH 2/2] crypto: testmgr - add test for lz4 and lz4hc
Date: Fri, 22 Aug 2014 10:44:36 +0200
Message-ID: <1408697076-20272-2-git-send-email-hidden@sch.bme.hu>
References: <1408697076-20272-1-git-send-email-hidden@sch.bme.hu>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	KOVACS Krisztian <hidden@sch.bme.hu>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from max.sch.bme.hu ([152.66.208.194]:27273 "EHLO max.sch.bme.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413AbaHVIuZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Aug 2014 04:50:25 -0400
In-Reply-To: <1408697076-20272-1-git-send-email-hidden@sch.bme.hu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds a simple test vector for the lz4 and lz4hc compression
algorithms.

Signed-off-by: KOVACS Krisztian <hidden@sch.bme.hu>
---
 crypto/testmgr.c | 32 +++++++++++++++++++++++++++
 crypto/testmgr.h | 66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 98 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index ac2b631..3e0b4ce 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3213,6 +3213,38 @@ static const struct alg_test_desc alg_test_descs[] = {
 			}
 		}
 	}, {
+		.alg = "lz4",
+		.test = alg_test_comp,
+		.fips_allowed = 1,
+		.suite = {
+			.comp = {
+				.comp = {
+					.vecs = lz4_comp_tv_template,
+					.count = LZ4_COMP_TEST_VECTORS
+				},
+				.decomp = {
+					.vecs = lz4_decomp_tv_template,
+					.count = LZ4_DECOMP_TEST_VECTORS
+				}
+			}
+		}
+	}, {
+		.alg = "lz4hc",
+		.test = alg_test_comp,
+		.fips_allowed = 1,
+		.suite = {
+			.comp = {
+				.comp = {
+					.vecs = lz4hc_comp_tv_template,
+					.count = LZ4HC_COMP_TEST_VECTORS
+				},
+				.decomp = {
+					.vecs = lz4hc_decomp_tv_template,
+					.count = LZ4HC_DECOMP_TEST_VECTORS
+				}
+			}
+		}
+	}, {
 		.alg = "lzo",
 		.test = alg_test_comp,
 		.fips_allowed = 1,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 6597203..62e2485 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -29473,4 +29473,70 @@ static struct hash_testvec bfin_crc_tv_template[] = {
 
 };
 
+#define LZ4_COMP_TEST_VECTORS 1
+#define LZ4_DECOMP_TEST_VECTORS 1
+
+static struct comp_testvec lz4_comp_tv_template[] = {
+	{
+		.inlen	= 70,
+		.outlen	= 45,
+		.input	= "Join us now and share the software "
+			  "Join us now and share the software ",
+		.output = "\xf0\x10\x4a\x6f\x69\x6e\x20\x75"
+			  "\x73\x20\x6e\x6f\x77\x20\x61\x6e"
+			  "\x64\x20\x73\x68\x61\x72\x65\x20"
+			  "\x74\x68\x65\x20\x73\x6f\x66\x74"
+			  "\x77\x0d\x00\x0f\x23\x00\x0b\x50"
+			  "\x77\x61\x72\x65\x20",
+	},
+};
+
+static struct comp_testvec lz4_decomp_tv_template[] = {
+	{
+		.inlen	= 45,
+		.outlen	= 70,
+		.input  = "\xf0\x10\x4a\x6f\x69\x6e\x20\x75"
+			  "\x73\x20\x6e\x6f\x77\x20\x61\x6e"
+			  "\x64\x20\x73\x68\x61\x72\x65\x20"
+			  "\x74\x68\x65\x20\x73\x6f\x66\x74"
+			  "\x77\x0d\x00\x0f\x23\x00\x0b\x50"
+			  "\x77\x61\x72\x65\x20",
+		.output	= "Join us now and share the software "
+			  "Join us now and share the software ",
+	},
+};
+
+#define LZ4HC_COMP_TEST_VECTORS 1
+#define LZ4HC_DECOMP_TEST_VECTORS 1
+
+static struct comp_testvec lz4hc_comp_tv_template[] = {
+	{
+		.inlen	= 70,
+		.outlen	= 45,
+		.input	= "Join us now and share the software "
+			  "Join us now and share the software ",
+		.output = "\xf0\x10\x4a\x6f\x69\x6e\x20\x75"
+			  "\x73\x20\x6e\x6f\x77\x20\x61\x6e"
+			  "\x64\x20\x73\x68\x61\x72\x65\x20"
+			  "\x74\x68\x65\x20\x73\x6f\x66\x74"
+			  "\x77\x0d\x00\x0f\x23\x00\x0b\x50"
+			  "\x77\x61\x72\x65\x20",
+	},
+};
+
+static struct comp_testvec lz4hc_decomp_tv_template[] = {
+	{
+		.inlen	= 45,
+		.outlen	= 70,
+		.input  = "\xf0\x10\x4a\x6f\x69\x6e\x20\x75"
+			  "\x73\x20\x6e\x6f\x77\x20\x61\x6e"
+			  "\x64\x20\x73\x68\x61\x72\x65\x20"
+			  "\x74\x68\x65\x20\x73\x6f\x66\x74"
+			  "\x77\x0d\x00\x0f\x23\x00\x0b\x50"
+			  "\x77\x61\x72\x65\x20",
+		.output	= "Join us now and share the software "
+			  "Join us now and share the software ",
+	},
+};
+
 #endif	/* _CRYPTO_TESTMGR_H */
-- 
2.1.0
