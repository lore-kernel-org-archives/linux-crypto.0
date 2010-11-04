From: Mark Allyn <mark.a.allyn@intel.com>
Subject: [PATCH 1/1] crypto: api.c: adding doxygen comments to api
Date: Thu,  4 Nov 2010 09:32:42 -0700
Message-ID: <1288888362-10599-1-git-send-email-mark.a.allyn@intel.com>
Cc: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Signed-off-by: Mark A. Allyn <mark.a.allyn@intel.com>
---
 crypto/api.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index 033a714..a11939f 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -193,6 +193,13 @@ static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg)
 	return alg;
 }
 
+/**
+ * This gets the crypto_alg structure for an algorithm
+ * it return struct crypto_alg
+ * @name: name of the algorithm
+ * @type: crypto type (defined at about line 31 of include/linux/crypto.h)
+ * @mask: mask of allowable crypto types
+ */
 struct crypto_alg *crypto_alg_lookup(const char *name, u32 type, u32 mask)
 {
 	struct crypto_alg *alg;
@@ -205,6 +212,13 @@ struct crypto_alg *crypto_alg_lookup(const char *name, u32 type, u32 mask)
 }
 EXPORT_SYMBOL_GPL(crypto_alg_lookup);
 
+/**
+ * This gets the large value crypto_alg structure for an algorithm
+ * it return struct crypto_alg
+ * @name: name of the algorithm
+ * @type: crypto type (defined at about line 31 of include/linux/crypto.h)
+ * @mask: mask of allowable crypto types
+ */
 struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask)
 {
 	struct crypto_alg *alg;
-- 
1.6.3.3
