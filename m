From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat Fix typo othewise->otherwise
Date: Fri, 24 Jul 2015 13:18:26 -0700
Message-ID: <20150724201826.27657.63335.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, Ahsan Atta <ahsan.atta@intel.com>,
	qat-linux@intel.com, tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:17192 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461AbbGXUTG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jul 2015 16:19:06 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Ahsan Atta <ahsan.atta@intel.com>

Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_aer.c       |    2 +-
 drivers/crypto/qat/qat_common/adf_cfg.c       |    6 +++---
 drivers/crypto/qat/qat_common/adf_dev_mgr.c   |    2 +-
 drivers/crypto/qat/qat_common/adf_init.c      |   10 +++++-----
 drivers/crypto/qat/qat_common/adf_transport.c |    2 +-
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_aer.c b/drivers/crypto/qat/qat_common/adf_aer.c
index 2dbc733..8f34a5f 100644
--- a/drivers/crypto/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/qat/qat_common/adf_aer.c
@@ -206,7 +206,7 @@ static struct pci_error_handlers adf_err_handler = {
  * QAT acceleration device accel_dev.
  * To be used by QAT device specific drivers.
  *
- * Return: 0 on success, error code othewise.
+ * Return: 0 on success, error code otherwise.
  */
 int adf_enable_aer(struct adf_accel_dev *accel_dev, struct pci_driver *adf)
 {
diff --git a/drivers/crypto/qat/qat_common/adf_cfg.c b/drivers/crypto/qat/qat_common/adf_cfg.c
index ab65bc2..76eccb8 100644
--- a/drivers/crypto/qat/qat_common/adf_cfg.c
+++ b/drivers/crypto/qat/qat_common/adf_cfg.c
@@ -123,7 +123,7 @@ static const struct file_operations qat_dev_cfg_fops = {
  * The table stores device specific config values.
  * To be used by QAT device specific drivers.
  *
- * Return: 0 on success, error code othewise.
+ * Return: 0 on success, error code otherwise.
  */
 int adf_cfg_dev_add(struct adf_accel_dev *accel_dev)
 {
@@ -276,7 +276,7 @@ static int adf_cfg_key_val_get(struct adf_accel_dev *accel_dev,
  * in the given acceleration device
  * To be used by QAT device specific drivers.
  *
- * Return: 0 on success, error code othewise.
+ * Return: 0 on success, error code otherwise.
  */
 int adf_cfg_add_key_value_param(struct adf_accel_dev *accel_dev,
 				const char *section_name,
@@ -327,7 +327,7 @@ EXPORT_SYMBOL_GPL(adf_cfg_add_key_value_param);
  * will be stored.
  * To be used by QAT device specific drivers.
  *
- * Return: 0 on success, error code othewise.
+ * Return: 0 on success, error code otherwise.
  */
 int adf_cfg_section_add(struct adf_accel_dev *accel_dev, const char *name)
 {
diff --git a/drivers/crypto/qat/qat_common/adf_dev_mgr.c b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
index 46cfa7f..b574a82 100644
--- a/drivers/crypto/qat/qat_common/adf_dev_mgr.c
+++ b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
@@ -60,7 +60,7 @@ static uint32_t num_devices;
  * Function adds acceleration device to the acceleration framework.
  * To be used by QAT device specific drivers.
  *
- * Return: 0 on success, error code othewise.
+ * Return: 0 on success, error code otherwise.
  */
 int adf_devmgr_add_dev(struct adf_accel_dev *accel_dev)
 {
diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index 7f9dffa..9a90b28 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -69,7 +69,7 @@ static void adf_service_add(struct service_hndl *service)
  * Function adds the acceleration service to the acceleration framework.
  * To be used by QAT device specific drivers.
  *
- * Return: 0 on success, error code othewise.
+ * Return: 0 on success, error code otherwise.
  */
 int adf_service_register(struct service_hndl *service)
 {
@@ -94,7 +94,7 @@ static void adf_service_remove(struct service_hndl *service)
  * Function remove the acceleration service from the acceleration framework.
  * To be used by QAT device specific drivers.
  *
- * Return: 0 on success, error code othewise.
+ * Return: 0 on success, error code otherwise.
  */
 int adf_service_unregister(struct service_hndl *service)
 {
@@ -114,7 +114,7 @@ EXPORT_SYMBOL_GPL(adf_service_unregister);
  * Initialize the ring data structures and the admin comms and arbitration
  * services.
  *
- * Return: 0 on success, error code othewise.
+ * Return: 0 on success, error code otherwise.
  */
 int adf_dev_init(struct adf_accel_dev *accel_dev)
 {
@@ -214,7 +214,7 @@ EXPORT_SYMBOL_GPL(adf_dev_init);
  * is ready to be used.
  * To be used by QAT device specific drivers.
  *
- * Return: 0 on success, error code othewise.
+ * Return: 0 on success, error code otherwise.
  */
 int adf_dev_start(struct adf_accel_dev *accel_dev)
 {
@@ -276,7 +276,7 @@ EXPORT_SYMBOL_GPL(adf_dev_start);
  * is shuting down.
  * To be used by QAT device specific drivers.
  *
- * Return: 0 on success, error code othewise.
+ * Return: 0 on success, error code otherwise.
  */
 int adf_dev_stop(struct adf_accel_dev *accel_dev)
 {
diff --git a/drivers/crypto/qat/qat_common/adf_transport.c b/drivers/crypto/qat/qat_common/adf_transport.c
index db2926b..df0331d 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.c
+++ b/drivers/crypto/qat/qat_common/adf_transport.c
@@ -463,7 +463,7 @@ err:
  * acceleration device accel_dev.
  * To be used by QAT device specific drivers.
  *
- * Return: 0 on success, error code othewise.
+ * Return: 0 on success, error code otherwise.
  */
 int adf_init_etr_data(struct adf_accel_dev *accel_dev)
 {
