From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 10/14] staging: ccree: remove custom type ssi_fips_error_t
Date: Tue, 27 Jun 2017 10:27:22 +0300
Message-ID: <1498548449-10803-11-git-send-email-gilad@benyossef.com>
References: <1498548449-10803-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-crypto@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
 devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1498548449-10803-1-git-send-email-gilad@benyossef.com>
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

Replace custom type ssi_fips_error_t with underlying enum.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_fips.c       |  4 ++--
 drivers/staging/ccree/ssi_fips.h       |  6 +++---
 drivers/staging/ccree/ssi_fips_ext.c   |  6 +++---
 drivers/staging/ccree/ssi_fips_ll.c    | 30 +++++++++++++++---------------
 drivers/staging/ccree/ssi_fips_local.c | 28 ++++++++++++++--------------
 drivers/staging/ccree/ssi_fips_local.h |  2 +-
 6 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/ccree/ssi_fips.c b/drivers/staging/ccree/ssi_fips.c
index 2b8a616..948ea49 100644
--- a/drivers/staging/ccree/ssi_fips.c
+++ b/drivers/staging/ccree/ssi_fips.c
@@ -24,7 +24,7 @@
 
 
 extern int ssi_fips_ext_get_state(ssi_fips_state_t *p_state);
-extern int ssi_fips_ext_get_error(ssi_fips_error_t *p_err);
+extern int ssi_fips_ext_get_error(enum cc_fips_error *p_err);
 
 /*
  * This function returns the REE FIPS state.
@@ -48,7 +48,7 @@ EXPORT_SYMBOL(ssi_fips_get_state);
  * This function returns the REE FIPS error.
  * It should be called by kernel module.
  */
-int ssi_fips_get_error(ssi_fips_error_t *p_err)
+int ssi_fips_get_error(enum cc_fips_error *p_err)
 {
 	int rc = 0;
 
diff --git a/drivers/staging/ccree/ssi_fips.h b/drivers/staging/ccree/ssi_fips.h
index 2fdb1b9..d1cd489 100644
--- a/drivers/staging/ccree/ssi_fips.h
+++ b/drivers/staging/ccree/ssi_fips.h
@@ -30,7 +30,7 @@ typedef enum ssi_fips_state {
 } ssi_fips_state_t;
 
 
-typedef enum ssi_fips_error {
+enum cc_fips_error {
 	CC_REE_FIPS_ERROR_OK = 0,
 	CC_REE_FIPS_ERROR_GENERAL,
 	CC_REE_FIPS_ERROR_FROM_TEE,
@@ -53,12 +53,12 @@ typedef enum ssi_fips_error {
 	CC_REE_FIPS_ERROR_HMAC_SHA512_PUT,
 	CC_REE_FIPS_ERROR_ROM_CHECKSUM,
 	CC_REE_FIPS_ERROR_RESERVE32B = S32_MAX
-} ssi_fips_error_t;
+};
 
 
 
 int ssi_fips_get_state(ssi_fips_state_t *p_state);
-int ssi_fips_get_error(ssi_fips_error_t *p_err);
+int ssi_fips_get_error(enum cc_fips_error *p_err);
 
 #endif  /*__SSI_FIPS_H__*/
 
diff --git a/drivers/staging/ccree/ssi_fips_ext.c b/drivers/staging/ccree/ssi_fips_ext.c
index b897c03..aab2805 100644
--- a/drivers/staging/ccree/ssi_fips_ext.c
+++ b/drivers/staging/ccree/ssi_fips_ext.c
@@ -29,7 +29,7 @@ module_param(tee_error, bool, 0644);
 MODULE_PARM_DESC(tee_error, "Simulate TEE library failure flag: 0 - no error (default), 1 - TEE error occured ");
 
 static ssi_fips_state_t fips_state = CC_FIPS_STATE_NOT_SUPPORTED;
-static ssi_fips_error_t fips_error = CC_REE_FIPS_ERROR_OK;
+static enum cc_fips_error fips_error = CC_REE_FIPS_ERROR_OK;
 
 /*
  * This function returns the FIPS REE state.
@@ -55,7 +55,7 @@ int ssi_fips_ext_get_state(ssi_fips_state_t *p_state)
  * the error value is stored.
  * The reference code uses global variable.
  */
-int ssi_fips_ext_get_error(ssi_fips_error_t *p_err)
+int ssi_fips_ext_get_error(enum cc_fips_error *p_err)
 {
 	int rc = 0;
 
@@ -85,7 +85,7 @@ int ssi_fips_ext_set_state(ssi_fips_state_t state)
  * the error value is stored.
  * The reference code uses global variable.
  */
-int ssi_fips_ext_set_error(ssi_fips_error_t err)
+int ssi_fips_ext_set_error(enum cc_fips_error err)
 {
 	fips_error = err;
 	return 0;
diff --git a/drivers/staging/ccree/ssi_fips_ll.c b/drivers/staging/ccree/ssi_fips_ll.c
index 4a11f15..cbb0fe2 100644
--- a/drivers/staging/ccree/ssi_fips_ll.c
+++ b/drivers/staging/ccree/ssi_fips_ll.c
@@ -271,7 +271,7 @@ static const FipsGcmData FipsGcmDataTable[] = {
 #define FIPS_GCM_NUM_OF_TESTS        (sizeof(FipsGcmDataTable) / sizeof(FipsGcmData))
 
 
-static inline ssi_fips_error_t
+static inline enum cc_fips_error
 FIPS_CipherToFipsError(enum drv_cipher_mode mode, bool is_aes)
 {
 	switch (mode)
@@ -415,10 +415,10 @@ ssi_cipher_fips_run_test(struct ssi_drvdata *drvdata,
 }
 
 
-ssi_fips_error_t
+enum cc_fips_error
 ssi_cipher_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer)
 {
-	ssi_fips_error_t error = CC_REE_FIPS_ERROR_OK;
+	enum cc_fips_error error = CC_REE_FIPS_ERROR_OK;
 	size_t i;
 	struct fips_cipher_ctx *virt_ctx = (struct fips_cipher_ctx *)cpu_addr_buffer;
 
@@ -544,10 +544,10 @@ ssi_cmac_fips_run_test(struct ssi_drvdata *drvdata,
 	return rc;
 }
 
-ssi_fips_error_t
+enum cc_fips_error
 ssi_cmac_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer)
 {
-	ssi_fips_error_t error = CC_REE_FIPS_ERROR_OK;
+	enum cc_fips_error error = CC_REE_FIPS_ERROR_OK;
 	size_t i;
 	struct fips_cmac_ctx *virt_ctx = (struct fips_cmac_ctx *)cpu_addr_buffer;
 
@@ -604,7 +604,7 @@ ssi_cmac_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 }
 
 
-static inline ssi_fips_error_t
+static inline enum cc_fips_error
 FIPS_HashToFipsError(enum drv_hash_mode hash_mode)
 {
 	switch (hash_mode) {
@@ -690,10 +690,10 @@ ssi_hash_fips_run_test(struct ssi_drvdata *drvdata,
 	return rc;
 }
 
-ssi_fips_error_t
+enum cc_fips_error
 ssi_hash_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer)
 {
-	ssi_fips_error_t error = CC_REE_FIPS_ERROR_OK;
+	enum cc_fips_error error = CC_REE_FIPS_ERROR_OK;
 	size_t i;
 	struct fips_hash_ctx *virt_ctx = (struct fips_hash_ctx *)cpu_addr_buffer;
 
@@ -780,7 +780,7 @@ ssi_hash_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer,
 }
 
 
-static inline ssi_fips_error_t
+static inline enum cc_fips_error
 FIPS_HmacToFipsError(enum drv_hash_mode hash_mode)
 {
 	switch (hash_mode) {
@@ -1006,10 +1006,10 @@ ssi_hmac_fips_run_test(struct ssi_drvdata *drvdata,
 	return rc;
 }
 
-ssi_fips_error_t
+enum cc_fips_error
 ssi_hmac_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer)
 {
-	ssi_fips_error_t error = CC_REE_FIPS_ERROR_OK;
+	enum cc_fips_error error = CC_REE_FIPS_ERROR_OK;
 	size_t i;
 	struct fips_hmac_ctx *virt_ctx = (struct fips_hmac_ctx *)cpu_addr_buffer;
 
@@ -1248,10 +1248,10 @@ ssi_ccm_fips_run_test(struct ssi_drvdata *drvdata,
 	return rc;
 }
 
-ssi_fips_error_t
+enum cc_fips_error
 ssi_ccm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer)
 {
-	ssi_fips_error_t error = CC_REE_FIPS_ERROR_OK;
+	enum cc_fips_error error = CC_REE_FIPS_ERROR_OK;
 	size_t i;
 	struct fips_ccm_ctx *virt_ctx = (struct fips_ccm_ctx *)cpu_addr_buffer;
 
@@ -1546,10 +1546,10 @@ ssi_gcm_fips_run_test(struct ssi_drvdata *drvdata,
 	return rc;
 }
 
-ssi_fips_error_t
+enum cc_fips_error
 ssi_gcm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer)
 {
-	ssi_fips_error_t error = CC_REE_FIPS_ERROR_OK;
+	enum cc_fips_error error = CC_REE_FIPS_ERROR_OK;
 	size_t i;
 	struct fips_gcm_ctx *virt_ctx = (struct fips_gcm_ctx *)cpu_addr_buffer;
 
diff --git a/drivers/staging/ccree/ssi_fips_local.c b/drivers/staging/ccree/ssi_fips_local.c
index 50d7189..dfc871d 100644
--- a/drivers/staging/ccree/ssi_fips_local.c
+++ b/drivers/staging/ccree/ssi_fips_local.c
@@ -51,17 +51,17 @@ struct ssi_fips_handle {
 
 
 extern int ssi_fips_get_state(ssi_fips_state_t *p_state);
-extern int ssi_fips_get_error(ssi_fips_error_t *p_err);
+extern int ssi_fips_get_error(enum cc_fips_error *p_err);
 extern int ssi_fips_ext_set_state(ssi_fips_state_t state);
-extern int ssi_fips_ext_set_error(ssi_fips_error_t err);
+extern int ssi_fips_ext_set_error(enum cc_fips_error err);
 
 /* FIPS power-up tests */
-extern ssi_fips_error_t ssi_cipher_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer);
-extern ssi_fips_error_t ssi_cmac_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer);
-extern ssi_fips_error_t ssi_hash_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer);
-extern ssi_fips_error_t ssi_hmac_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer);
-extern ssi_fips_error_t ssi_ccm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer);
-extern ssi_fips_error_t ssi_gcm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer);
+extern enum cc_fips_error ssi_cipher_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer);
+extern enum cc_fips_error ssi_cmac_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer);
+extern enum cc_fips_error ssi_hash_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer);
+extern enum cc_fips_error ssi_hmac_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer);
+extern enum cc_fips_error ssi_ccm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer);
+extern enum cc_fips_error ssi_gcm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer);
 extern size_t ssi_fips_max_mem_alloc_size(void);
 
 
@@ -84,7 +84,7 @@ static enum ssi_fips_error ssi_fips_get_tee_error(struct ssi_drvdata *drvdata)
  * By writing the error state to HOST_GPR0 register. The function is called from
  * driver entry point so no need to protect by mutex.
  */
-static void ssi_fips_update_tee_upon_ree_status(struct ssi_drvdata *drvdata, ssi_fips_error_t err)
+static void ssi_fips_update_tee_upon_ree_status(struct ssi_drvdata *drvdata, enum cc_fips_error err)
 {
 	void __iomem *cc_base = drvdata->cc_base;
 	if (err == CC_REE_FIPS_ERROR_OK)
@@ -162,9 +162,9 @@ static void fips_dsr(unsigned long devarg)
 }
 
 
-ssi_fips_error_t cc_fips_run_power_up_tests(struct ssi_drvdata *drvdata)
+enum cc_fips_error cc_fips_run_power_up_tests(struct ssi_drvdata *drvdata)
 {
-	ssi_fips_error_t fips_error = CC_REE_FIPS_ERROR_OK;
+	enum cc_fips_error fips_error = CC_REE_FIPS_ERROR_OK;
 	void *cpu_addr_buffer = NULL;
 	dma_addr_t dma_handle;
 	size_t alloc_buff_size = ssi_fips_max_mem_alloc_size();
@@ -259,10 +259,10 @@ int ssi_fips_set_state(ssi_fips_state_t state)
 /* The function sets the REE FIPS error, and pushes the error to TEE library. *
  * It should be used when any of the KAT tests fails.
  */
-int ssi_fips_set_error(struct ssi_drvdata *p_drvdata, ssi_fips_error_t err)
+int ssi_fips_set_error(struct ssi_drvdata *p_drvdata, enum cc_fips_error err)
 {
 	int rc = 0;
-	ssi_fips_error_t current_err;
+	enum cc_fips_error current_err;
 
 	FIPS_LOG("ssi_fips_set_error - fips_error = %d \n", err);
 
@@ -297,7 +297,7 @@ int ssi_fips_set_error(struct ssi_drvdata *p_drvdata, ssi_fips_error_t err)
 /* The function called once at driver entry point .*/
 int ssi_fips_init(struct ssi_drvdata *p_drvdata)
 {
-	ssi_fips_error_t rc = CC_REE_FIPS_ERROR_OK;
+	enum cc_fips_error rc = CC_REE_FIPS_ERROR_OK;
 	struct ssi_fips_handle *fips_h;
 
 	FIPS_DBG("CC FIPS code ..  (fips=%d) \n", ssi_fips_support);
diff --git a/drivers/staging/ccree/ssi_fips_local.h b/drivers/staging/ccree/ssi_fips_local.h
index fa09084..0fbb1e0 100644
--- a/drivers/staging/ccree/ssi_fips_local.h
+++ b/drivers/staging/ccree/ssi_fips_local.h
@@ -53,7 +53,7 @@ typedef enum CC_FipsSyncStatus {
 int ssi_fips_init(struct ssi_drvdata *p_drvdata);
 void ssi_fips_fini(struct ssi_drvdata *drvdata);
 int ssi_fips_check_fips_error(void);
-int ssi_fips_set_error(struct ssi_drvdata *p_drvdata, ssi_fips_error_t err);
+int ssi_fips_set_error(struct ssi_drvdata *p_drvdata, enum cc_fips_error err);
 void fips_handler(struct ssi_drvdata *drvdata);
 
 #else  /* CONFIG_CC7XXREE_FIPS_SUPPORT */
-- 
2.1.4
