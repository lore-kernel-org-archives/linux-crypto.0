From: Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: [PATCH 3/3] crypto: testmgr - Add missing tests for internal sha512-mb implementation
Date: Wed, 26 Oct 2016 15:04:45 -0200
Message-ID: <1477501485-18371-4-git-send-email-marcelo.cerri@canonical.com>
References: <1477501485-18371-1-git-send-email-marcelo.cerri@canonical.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Stephan Mueller <smueller@chronox.de>,
        Marcelo Cerri <marcelo.cerri@canonical.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1477501485-18371-1-git-send-email-marcelo.cerri@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add null tests for the internal algorithm to avoid errors when running
in FIPS mode.

Signed-off-by: Marcelo Cerri <marcelo.cerri@canonical.com>
---
 crypto/testmgr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 58f903d..cfafd24 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2313,6 +2313,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_null,
 		.fips_allowed = 1,
 	}, {
+		.alg = "__intel_sha512-mb",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
 		.alg = "ansi_cprng",
 		.test = alg_test_cprng,
 		.suite = {
@@ -3766,6 +3770,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.test = alg_test_null,
 		.fips_allowed = 1,
 	}, {
+		.alg = "mcryptd(__intel_sha512-mb)",
+		.test = alg_test_null,
+		.fips_allowed = 1,
+	}, {
 		.alg = "md4",
 		.test = alg_test_hash,
 		.suite = {
-- 
2.7.4
