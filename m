From: Janani Sankara Babu <jananis37@gmail.com>
Subject: [PATCH] staging:ccree Fix avoid externs in .c files
Date: Thu, 21 Sep 2017 12:13:17 +0530
Message-ID: <1505976197-28467-1-git-send-email-jananis37@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
 linux-kernel@vger.kernel.org, Janani Sankara Babu <jananis37@gmail.com>,
 linux-crypto@vger.kernel.org
To: gregkh@linuxfoundation.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
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

This patch solves the warning shown by the checkpatch script
WARNING: externs should be avoided in .c files

Signed-off-by: Janani Sankara Babu <jananis37@gmail.com>
---
 drivers/staging/ccree/ssi_fips_local.c | 14 --------------
 drivers/staging/ccree/ssi_fips_local.h | 13 +++++++++++++
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/ccree/ssi_fips_local.c b/drivers/staging/ccree/ssi_fips_local.c
index aefb71d..f019041 100644
--- a/drivers/staging/ccree/ssi_fips_local.c
+++ b/drivers/staging/ccree/ssi_fips_local.c
@@ -48,20 +48,6 @@ struct ssi_fips_handle {
 #endif
 };
 
-extern int ssi_fips_get_state(enum cc_fips_state_t *p_state);
-extern int ssi_fips_get_error(enum cc_fips_error *p_err);
-extern int ssi_fips_ext_set_state(enum cc_fips_state_t state);
-extern int ssi_fips_ext_set_error(enum cc_fips_error err);
-
-/* FIPS power-up tests */
-extern enum cc_fips_error ssi_cipher_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer);
-extern enum cc_fips_error ssi_cmac_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer);
-extern enum cc_fips_error ssi_hash_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer);
-extern enum cc_fips_error ssi_hmac_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer);
-extern enum cc_fips_error ssi_ccm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer);
-extern enum cc_fips_error ssi_gcm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer);
-extern size_t ssi_fips_max_mem_alloc_size(void);
-
 /* The function called once at driver entry point to check whether TEE FIPS error occured.*/
 static enum ssi_fips_error ssi_fips_get_tee_error(struct ssi_drvdata *drvdata)
 {
diff --git a/drivers/staging/ccree/ssi_fips_local.h b/drivers/staging/ccree/ssi_fips_local.h
index 8c7994f..b906190 100644
--- a/drivers/staging/ccree/ssi_fips_local.h
+++ b/drivers/staging/ccree/ssi_fips_local.h
@@ -65,3 +65,16 @@ static inline void ssi_fips_fini(struct ssi_drvdata *drvdata) {}
 
 #endif  /*__SSI_FIPS_LOCAL_H__*/
 
+extern int ssi_fips_get_state(enum cc_fips_state_t *p_state);
+extern int ssi_fips_get_error(enum cc_fips_error *p_err);
+extern int ssi_fips_ext_set_state(enum cc_fips_state_t state);
+extern int ssi_fips_ext_set_error(enum cc_fips_error err);
+
+/* FIPS power-up tests */
+extern enum cc_fips_error ssi_cipher_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer);
+extern enum cc_fips_error ssi_cmac_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer);
+extern enum cc_fips_error ssi_hash_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer);
+extern enum cc_fips_error ssi_hmac_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer);
+extern enum cc_fips_error ssi_ccm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer);
+extern enum cc_fips_error ssi_gcm_fips_power_up_tests(struct ssi_drvdata *drvdata, void *cpu_addr_buffer, dma_addr_t dma_coherent_buffer);
+extern size_t ssi_fips_max_mem_alloc_size(void);
-- 
1.9.1
