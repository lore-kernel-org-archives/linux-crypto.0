From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [PATCH 1/4] crypto: testmgr - check that entries in alg_test_descs
 are in correct order
Date: Thu, 13 Jun 2013 17:37:40 +0300
Message-ID: <20130613143740.31765.66518.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:45003 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab3FMOjW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Jun 2013 10:39:22 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Patch adds check for alg_test_descs list order, so that accidentically
misplaced entries are found quicker. Duplicate entries are also checked for.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 crypto/testmgr.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index b2bc533..a81c154 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3054,6 +3054,35 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}
 };
 
+static bool alg_test_descs_checked;
+
+static void alg_test_descs_check_order(void)
+{
+	int i;
+
+	/* only check once */
+	if (alg_test_descs_checked)
+		return;
+
+	alg_test_descs_checked = true;
+
+	for (i = 1; i < ARRAY_SIZE(alg_test_descs); i++) {
+		int diff = strcmp(alg_test_descs[i - 1].alg,
+				  alg_test_descs[i].alg);
+
+		if (WARN_ON(diff > 0)) {
+			pr_warn("testmgr: alg_test_descs entries in wrong order: '%s' before '%s'\n",
+				alg_test_descs[i - 1].alg,
+				alg_test_descs[i].alg);
+		}
+
+		if (WARN_ON(diff == 0)) {
+			pr_warn("testmgr: duplicate alg_test_descs entry: '%s'\n",
+				alg_test_descs[i].alg);
+		}
+	}
+}
+
 static int alg_find_test(const char *alg)
 {
 	int start = 0;
@@ -3085,6 +3114,8 @@ int alg_test(const char *driver, const char *alg, u32 type, u32 mask)
 	int j;
 	int rc;
 
+	alg_test_descs_check_order();
+
 	if ((type & CRYPTO_ALG_TYPE_MASK) == CRYPTO_ALG_TYPE_CIPHER) {
 		char nalg[CRYPTO_MAX_ALG_NAME];
 
