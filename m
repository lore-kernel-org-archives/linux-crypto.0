From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [RFC][PATCH 2/4] key: add tpm_send command
Date: Tue, 28 Sep 2010 14:36:31 -0400
Message-ID: <1285698993-16927-3-git-send-email-zohar@linux.vnet.ibm.com>
References: <1285698993-16927-1-git-send-email-zohar@linux.vnet.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, keyrings@linux-nfs.org,
	linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	David Safford <safford@watson.ibm.com>,
	Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1285698993-16927-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add internal kernel tpm_send() command used to seal/unseal keys.

Signed-off-by: David Safford <safford@watson.ibm.com>
Reviewd-by: Mimi Zohar <zohar@watson.ibm.com>
---
 drivers/char/tpm/tpm.c |   17 +++++++++++++++++
 include/linux/tpm.h    |    3 +++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index 05ad4a1..37c16a8 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -770,6 +770,23 @@ int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash)
 }
 EXPORT_SYMBOL_GPL(tpm_pcr_extend);
 
+int tpm_send(u32 chip_num, char *cmd, int buflen)
+{
+	struct tpm_chip *chip;
+	int rc;
+
+	chip = tpm_chip_find_get(chip_num);
+	if (chip == NULL)
+		return -ENODEV;
+
+	rc = transmit_cmd(chip, (struct tpm_cmd_t *)cmd, buflen,
+			  "attempting tpm_cmd");
+
+	module_put(chip->dev->driver->owner);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(tpm_send);
+
 ssize_t tpm_show_pcrs(struct device *dev, struct device_attribute *attr,
 		      char *buf)
 {
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index ac5d1c1..a0ecaa9 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -31,6 +31,7 @@
 
 extern int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf);
 extern int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash);
+extern int tpm_send(u32 chip_num, char *cmd, int buflen);
 #else
 static inline int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf) {
 	return -ENODEV;
@@ -38,5 +39,7 @@ static inline int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf) {
 static inline int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash) {
 	return -ENODEV;
 }
+static inline int tpm_send(u32 chip_num, char *cmd, int buflen) {
+	return -ENODEV;
 #endif
 #endif
-- 
1.7.2.2

