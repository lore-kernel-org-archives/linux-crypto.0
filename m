From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 2/6] staging: ccree: kmalloc by sizeof var not type
Date: Sun, 30 Jul 2017 19:15:04 +0300
Message-ID: <1501431309-27705-3-git-send-email-gilad@benyossef.com>
References: <1501431309-27705-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-crypto@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
 devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1501431309-27705-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

Change places where we alloc memory by sizeof type to sizeof var.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_aead.c        | 4 ++--
 drivers/staging/ccree/ssi_cipher.c      | 4 ++--
 drivers/staging/ccree/ssi_driver.c      | 2 +-
 drivers/staging/ccree/ssi_hash.c        | 4 ++--
 drivers/staging/ccree/ssi_ivgen.c       | 2 +-
 drivers/staging/ccree/ssi_request_mgr.c | 2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index d8f2249..a8cb432 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -2658,7 +2658,7 @@ static struct ssi_crypto_alg *ssi_aead_create_alg(struct ssi_alg_template *templ
 	struct ssi_crypto_alg *t_alg;
 	struct aead_alg *alg;
 
-	t_alg = kzalloc(sizeof(struct ssi_crypto_alg), GFP_KERNEL);
+	t_alg = kzalloc(sizeof(*t_alg), GFP_KERNEL);
 	if (!t_alg) {
 		SSI_LOG_ERR("failed to allocate t_alg\n");
 		return ERR_PTR(-ENOMEM);
@@ -2713,7 +2713,7 @@ int ssi_aead_alloc(struct ssi_drvdata *drvdata)
 	int rc = -ENOMEM;
 	int alg;
 
-	aead_handle = kmalloc(sizeof(struct ssi_aead_handle), GFP_KERNEL);
+	aead_handle = kmalloc(sizeof(*aead_handle), GFP_KERNEL);
 	if (!aead_handle) {
 		rc = -ENOMEM;
 		goto fail0;
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 068b10b..d98178d 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -1215,7 +1215,7 @@ struct ssi_crypto_alg *ssi_ablkcipher_create_alg(struct ssi_alg_template *templa
 	struct ssi_crypto_alg *t_alg;
 	struct crypto_alg *alg;
 
-	t_alg = kzalloc(sizeof(struct ssi_crypto_alg), GFP_KERNEL);
+	t_alg = kzalloc(sizeof(*t_alg), GFP_KERNEL);
 	if (!t_alg) {
 		SSI_LOG_ERR("failed to allocate t_alg\n");
 		return ERR_PTR(-ENOMEM);
@@ -1276,7 +1276,7 @@ int ssi_ablkcipher_alloc(struct ssi_drvdata *drvdata)
 	int rc = -ENOMEM;
 	int alg;
 
-	ablkcipher_handle = kmalloc(sizeof(struct ssi_blkcipher_handle),
+	ablkcipher_handle = kmalloc(sizeof(*ablkcipher_handle),
 				    GFP_KERNEL);
 	if (!ablkcipher_handle)
 		return -ENOMEM;
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index d104dbd..1cae2b7 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -223,7 +223,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	struct resource *req_mem_cc_regs = NULL;
 	void __iomem *cc_base = NULL;
 	bool irq_registered = false;
-	struct ssi_drvdata *new_drvdata = kzalloc(sizeof(struct ssi_drvdata), GFP_KERNEL);
+	struct ssi_drvdata *new_drvdata = kzalloc(sizeof(*new_drvdata), GFP_KERNEL);
 	struct device *dev = &plat_dev->dev;
 	struct device_node *np = dev->of_node;
 	u32 signature_val;
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 3a734df..6c08b1d 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -2055,7 +2055,7 @@ ssi_hash_create_alg(struct ssi_hash_template *template, bool keyed)
 	struct crypto_alg *alg;
 	struct ahash_alg *halg;
 
-	t_crypto_alg = kzalloc(sizeof(struct ssi_hash_alg), GFP_KERNEL);
+	t_crypto_alg = kzalloc(sizeof(*t_crypto_alg), GFP_KERNEL);
 	if (!t_crypto_alg) {
 		SSI_LOG_ERR("failed to allocate t_alg\n");
 		return ERR_PTR(-ENOMEM);
@@ -2221,7 +2221,7 @@ int ssi_hash_alloc(struct ssi_drvdata *drvdata)
 	int rc = 0;
 	int alg;
 
-	hash_handle = kzalloc(sizeof(struct ssi_hash_handle), GFP_KERNEL);
+	hash_handle = kzalloc(sizeof(*hash_handle), GFP_KERNEL);
 	if (!hash_handle) {
 		SSI_LOG_ERR("kzalloc failed to allocate %zu B\n",
 			    sizeof(struct ssi_hash_handle));
diff --git a/drivers/staging/ccree/ssi_ivgen.c b/drivers/staging/ccree/ssi_ivgen.c
index bca44af..93a2a94 100644
--- a/drivers/staging/ccree/ssi_ivgen.c
+++ b/drivers/staging/ccree/ssi_ivgen.c
@@ -191,7 +191,7 @@ int ssi_ivgen_init(struct ssi_drvdata *drvdata)
 	int rc;
 
 	/* Allocate "this" context */
-	drvdata->ivgen_handle = kzalloc(sizeof(struct ssi_ivgen_ctx), GFP_KERNEL);
+	drvdata->ivgen_handle = kzalloc(sizeof(*drvdata->ivgen_handle), GFP_KERNEL);
 	if (!drvdata->ivgen_handle) {
 		SSI_LOG_ERR("Not enough memory to allocate IVGEN context (%zu B)\n",
 			    sizeof(struct ssi_ivgen_ctx));
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 9a4bb5c..cae9904 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -100,7 +100,7 @@ int request_mgr_init(struct ssi_drvdata *drvdata)
 	struct ssi_request_mgr_handle *req_mgr_h;
 	int rc = 0;
 
-	req_mgr_h = kzalloc(sizeof(struct ssi_request_mgr_handle), GFP_KERNEL);
+	req_mgr_h = kzalloc(sizeof(*req_mgr_h), GFP_KERNEL);
 	if (!req_mgr_h) {
 		rc = -ENOMEM;
 		goto req_mgr_init_err;
-- 
2.1.4
