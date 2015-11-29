From: Rui Wang <rui.y.wang@intel.com>
Subject: [PATCH 1/2] crypto: ghash-clmulni - Fix load failure
Date: Sun, 29 Nov 2015 22:45:33 +0800
Message-ID: <1448808334-8424-2-git-send-email-rui.y.wang@intel.com>
References: <1448808334-8424-1-git-send-email-rui.y.wang@intel.com>
Cc: ying.huang@intel.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, rui.y.wang@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448808334-8424-1-git-send-email-rui.y.wang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

ghash_clmulni_intel fails to load on Linux 4.3+ with the following message:
"modprobe: ERROR: could not insert 'ghash_clmulni_intel': Invalid argument"

After 8996eafdc ("crypto: ahash - ensure statesize is non-zero") all ahash
drivers are required to implement import()/export(), and must have a non-
zero statesize.

This patch has been tested with the algif_hash interface. The calculated
digest values, after several rounds of import()s and export()s, match those
calculated by tcrypt.

Signed-off-by: Rui Wang <rui.y.wang@intel.com>
---
 arch/x86/crypto/ghash-clmulni-intel_glue.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/x86/crypto/ghash-clmulni-intel_glue.c b/arch/x86/crypto/ghash-clmulni-intel_glue.c
index 440df0c..a69321a 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_glue.c
+++ b/arch/x86/crypto/ghash-clmulni-intel_glue.c
@@ -219,6 +219,29 @@ static int ghash_async_final(struct ahash_request *req)
 	}
 }
 
+static int ghash_async_import(struct ahash_request *req, const void *in)
+{
+	struct ahash_request *cryptd_req = ahash_request_ctx(req);
+	struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
+	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
+
+	ghash_async_init(req);
+	memcpy(dctx, in, sizeof(*dctx));
+	return 0;
+
+}
+
+static int ghash_async_export(struct ahash_request *req, void *out)
+{
+	struct ahash_request *cryptd_req = ahash_request_ctx(req);
+	struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
+	struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
+
+	memcpy(out, dctx, sizeof(*dctx));
+	return 0;
+
+}
+
 static int ghash_async_digest(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
@@ -288,8 +311,11 @@ static struct ahash_alg ghash_async_alg = {
 	.final		= ghash_async_final,
 	.setkey		= ghash_async_setkey,
 	.digest		= ghash_async_digest,
+	.export		= ghash_async_export,
+	.import		= ghash_async_import,
 	.halg = {
 		.digestsize	= GHASH_DIGEST_SIZE,
+		.statesize = sizeof(struct ghash_desc_ctx),
 		.base = {
 			.cra_name		= "ghash",
 			.cra_driver_name	= "ghash-clmulni",
-- 
1.8.5.2
