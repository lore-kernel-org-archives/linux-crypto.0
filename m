Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613FC340281
	for <linux-crypto@vger.kernel.org>; Mon, 25 May 2026 10:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779705338; cv=none; b=lrEQn7uBmu8VIuamAVQDfEQmAvfeRmSEvhEQn4mgObK6z9on3DT6UJIjagIbvwZoVtfY8E3UXOLJp9zYJbr6SiwairoM1ptsr3yAXVAEaZo8CnD9Q1LbMQlxL/L9wPYGVp/S7LCNWbtoEo3lyGVLFHM1McnUvVUFN4G5mhAbxYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779705338; c=relaxed/simple;
	bh=KZ2a3Jn5O4XFlTzbyLYNqvhkfppTqzD1awT6OxYOEu8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=M2ngRKYhzjnvHqF8dEGsuHdaJrf+PGOsixOwiBIKnwipGZJSqJj+yx06VSi7gu4ANvSKY03DBjInc5kP10b6rmtD9JQau8Z+u/nd5nm/AQnyiJC1Fl5c2dYOq/my4sJJLDvSWn/tWV1gXfmO49V5YN3vMNn832DwVSJ5eTYSrAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=J40514aX; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="J40514aX"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779705324;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=LN2XYtaCH98z9s+vllk9Y/IuaTY6tlcDfegF5r8CntM=;
	b=J40514aXVGT2dk9hMua0Pspn/3lDv/qiQosO9X9iT1fCsAfd7ZcuNm/AVMqoUwsT2k/8uv
	Kxgit7T/ZtqTydc79q97ISi8n5K8a7MT9lc8gVs4WTnXajT3z+ZRxLvcDIIW/q/pW1CBS6
	AuA+jjxg4p2sK3frxuM8h9j8rlgncJg=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Weili Qian <qianweili@huawei.com>,
	Zhou Wang <wangzhou1@hisilicon.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	qat-linux@intel.com,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH] crypto: use two-argument strscpy where destination size is known
Date: Mon, 25 May 2026 12:30:41 +0200
Message-ID: <20260525103038.825690-4-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=14514; i=thorsten.blum@linux.dev; h=from:subject; bh=90gVDhciRJ0Wu5DrX+XavJ7pkkbO1YSTPLHAis5/ZYw=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFkiKueKj7rJtjTUT92hvFxlecu75X3z1ZxPSzDPFTXx3 Fl9801MRykLgxgXg6yYIsuDWT9m+JbWVG4yidgJM4eVCWQIAxenAEyE/Qsjw/pInQPpCxXUa6oz ZF3+5k8XmDnvu4iG81J1noffcv5c42BkuDUhft2uZ8c+hGs9aD4/qW6Bdp2povLEyvQfH7v/luy y5AYA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

To simplify the code, drop explicit and hard-coded size arguments from
strscpy() where the destination buffer has a fixed size and strscpy()
can automatically determine it using sizeof().

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 crypto/api.c                                             | 2 +-
 crypto/crypto_user.c                                     | 9 ++++-----
 crypto/hctr2.c                                           | 3 +--
 crypto/lrw.c                                             | 2 +-
 crypto/lskcipher.c                                       | 3 +--
 crypto/xts.c                                             | 3 ++-
 drivers/crypto/cavium/nitrox/nitrox_hal.c                | 3 ++-
 drivers/crypto/ccp/ccp-crypto-sha.c                      | 2 +-
 drivers/crypto/hisilicon/qm.c                            | 5 +----
 drivers/crypto/intel/qat/qat_common/adf_cfg.c            | 7 ++++---
 drivers/crypto/intel/qat/qat_common/adf_cfg_services.c   | 2 +-
 drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c        | 3 ++-
 drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c     | 3 ++-
 .../crypto/intel/qat/qat_common/adf_transport_debug.c    | 3 ++-
 drivers/crypto/intel/qat/qat_common/qat_compression.c    | 3 ++-
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c        | 6 +++---
 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c      | 4 ++--
 17 files changed, 32 insertions(+), 31 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index 74e17d5049c9..040b7a965c2f 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -116,7 +116,7 @@ struct crypto_larval *crypto_larval_alloc(const char *name, u32 type, u32 mask)
 	larval->alg.cra_priority = -1;
 	larval->alg.cra_destroy = crypto_larval_destroy;
 
-	strscpy(larval->alg.cra_name, name, CRYPTO_MAX_ALG_NAME);
+	strscpy(larval->alg.cra_name, name);
 	init_completion(&larval->completion);
 
 	return larval;
diff --git a/crypto/crypto_user.c b/crypto/crypto_user.c
index e8b6ae75f31f..d3ccb507153b 100644
--- a/crypto/crypto_user.c
+++ b/crypto/crypto_user.c
@@ -11,6 +11,7 @@
 #include <linux/cryptouser.h>
 #include <linux/sched.h>
 #include <linux/security.h>
+#include <linux/string.h>
 #include <net/netlink.h>
 #include <net/net_namespace.h>
 #include <net/sock.h>
@@ -87,11 +88,9 @@ static int crypto_report_one(struct crypto_alg *alg,
 {
 	memset(ualg, 0, sizeof(*ualg));
 
-	strscpy(ualg->cru_name, alg->cra_name, sizeof(ualg->cru_name));
-	strscpy(ualg->cru_driver_name, alg->cra_driver_name,
-		sizeof(ualg->cru_driver_name));
-	strscpy(ualg->cru_module_name, module_name(alg->cra_module),
-		sizeof(ualg->cru_module_name));
+	strscpy(ualg->cru_name, alg->cra_name);
+	strscpy(ualg->cru_driver_name, alg->cra_driver_name);
+	strscpy(ualg->cru_module_name, module_name(alg->cra_module));
 
 	ualg->cru_type = 0;
 	ualg->cru_mask = 0;
diff --git a/crypto/hctr2.c b/crypto/hctr2.c
index ad5edf9366ac..cfc2343bcc1c 100644
--- a/crypto/hctr2.c
+++ b/crypto/hctr2.c
@@ -354,8 +354,7 @@ static int hctr2_create_common(struct crypto_template *tmpl, struct rtattr **tb,
 	err = -EINVAL;
 	if (strncmp(xctr_alg->base.cra_name, "xctr(", 5))
 		goto err_free_inst;
-	len = strscpy(blockcipher_name, xctr_alg->base.cra_name + 5,
-		      sizeof(blockcipher_name));
+	len = strscpy(blockcipher_name, xctr_alg->base.cra_name + 5);
 	if (len < 1)
 		goto err_free_inst;
 	if (blockcipher_name[len - 1] != ')')
diff --git a/crypto/lrw.c b/crypto/lrw.c
index aa31ab03a597..e306e85d7ced 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -359,7 +359,7 @@ static int lrw_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (!memcmp(cipher_name, "ecb(", 4)) {
 		int len;
 
-		len = strscpy(ecb_name, cipher_name + 4, sizeof(ecb_name));
+		len = strscpy(ecb_name, cipher_name + 4);
 		if (len < 2)
 			goto err_free_inst;
 
diff --git a/crypto/lskcipher.c b/crypto/lskcipher.c
index e4328df6e26c..d7ec215e2b3a 100644
--- a/crypto/lskcipher.c
+++ b/crypto/lskcipher.c
@@ -528,8 +528,7 @@ struct lskcipher_instance *lskcipher_alloc_instance_simple(
 		int len;
 
 		err = -EINVAL;
-		len = strscpy(ecb_name, &cipher_alg->co.base.cra_name[4],
-			      sizeof(ecb_name));
+		len = strscpy(ecb_name, &cipher_alg->co.base.cra_name[4]);
 		if (len < 2)
 			goto err_free_inst;
 
diff --git a/crypto/xts.c b/crypto/xts.c
index ad97c8091582..1dc948745444 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 
 #include <crypto/xts.h>
 #include <crypto/b128ops.h>
@@ -400,7 +401,7 @@ static int xts_create(struct crypto_template *tmpl, struct rtattr **tb)
 	if (!memcmp(cipher_name, "ecb(", 4)) {
 		int len;
 
-		len = strscpy(name, cipher_name + 4, sizeof(name));
+		len = strscpy(name, cipher_name + 4);
 		if (len < 2)
 			goto err_free_inst;
 
diff --git a/drivers/crypto/cavium/nitrox/nitrox_hal.c b/drivers/crypto/cavium/nitrox/nitrox_hal.c
index 1b5abdb6cc5e..e36c1741bb78 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_hal.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_hal.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/delay.h>
+#include <linux/string.h>
 
 #include "nitrox_dev.h"
 #include "nitrox_csr.h"
@@ -647,7 +648,7 @@ void nitrox_get_hwinfo(struct nitrox_device *ndev)
 		 ndev->hw.revision_id);
 
 	/* copy partname */
-	strscpy(ndev->hw.partname, name, sizeof(ndev->hw.partname));
+	strscpy(ndev->hw.partname, name);
 }
 
 void enable_pf2vf_mbox_interrupts(struct nitrox_device *ndev)
diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
index 85058a89f35b..ff9bb253dbb2 100644
--- a/drivers/crypto/ccp/ccp-crypto-sha.c
+++ b/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -426,7 +426,7 @@ static int ccp_register_hmac_alg(struct list_head *head,
 	*ccp_alg = *base_alg;
 	INIT_LIST_HEAD(&ccp_alg->entry);
 
-	strscpy(ccp_alg->child_alg, def->name, CRYPTO_MAX_ALG_NAME);
+	strscpy(ccp_alg->child_alg, def->name);
 
 	alg = &ccp_alg->alg;
 	alg->setkey = ccp_sha_setkey;
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 3ca47e2a9719..0c8cc0d7a82a 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -2870,11 +2870,8 @@ static int qm_alloc_uacce(struct hisi_qm *qm)
 		.flags = UACCE_DEV_SVA,
 		.ops = &uacce_qm_ops,
 	};
-	int ret;
 
-	ret = strscpy(interface.name, dev_driver_string(&pdev->dev),
-		      sizeof(interface.name));
-	if (ret < 0)
+	if (strscpy(interface.name, dev_driver_string(&pdev->dev)) < 0)
 		return -ENAMETOOLONG;
 
 	uacce = uacce_alloc(&pdev->dev, &interface);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg.c b/drivers/crypto/intel/qat/qat_common/adf_cfg.c
index c202209f17d5..24c2618af68d 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2014 - 2020 Intel Corporation */
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/list.h>
 #include <linux/seq_file.h>
 #include "adf_accel_devices.h"
@@ -294,13 +295,13 @@ int adf_cfg_add_key_value_param(struct adf_accel_dev *accel_dev,
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&key_val->list);
-	strscpy(key_val->key, key, sizeof(key_val->key));
+	strscpy(key_val->key, key);
 
 	if (type == ADF_DEC) {
 		snprintf(key_val->val, ADF_CFG_MAX_VAL_LEN_IN_BYTES,
 			 "%ld", (*((long *)val)));
 	} else if (type == ADF_STR) {
-		strscpy(key_val->val, (char *)val, sizeof(key_val->val));
+		strscpy(key_val->val, (char *)val);
 	} else if (type == ADF_HEX) {
 		snprintf(key_val->val, ADF_CFG_MAX_VAL_LEN_IN_BYTES,
 			 "0x%lx", (unsigned long)val);
@@ -360,7 +361,7 @@ int adf_cfg_section_add(struct adf_accel_dev *accel_dev, const char *name)
 	if (!sec)
 		return -ENOMEM;
 
-	strscpy(sec->name, name, sizeof(sec->name));
+	strscpy(sec->name, name);
 	INIT_LIST_HEAD(&sec->param_head);
 	down_write(&cfg->lock);
 	list_add_tail(&sec->list, &cfg->sec_list);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
index 7d00bcb41ce7..11cba347d12d 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg_services.c
@@ -60,7 +60,7 @@ static int adf_service_string_to_mask(struct adf_accel_dev *accel_dev, const cha
 	if (len > ADF_CFG_MAX_VAL_LEN_IN_BYTES - 1)
 		return -EINVAL;
 
-	strscpy(services, buf, ADF_CFG_MAX_VAL_LEN_IN_BYTES);
+	strscpy(services, buf);
 	substr = services;
 
 	while ((token = strsep(&substr, ADF_SERVICES_DELIMITER))) {
diff --git a/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
index c2e6f0cb7480..ae10b91da5ba 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c
@@ -5,6 +5,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/fs.h>
 #include <linux/bitops.h>
 #include <linux/pci.h>
@@ -350,7 +351,7 @@ static int adf_ctl_ioctl_get_status(struct file *fp, unsigned int cmd,
 	dev_info.num_logical_accel = hw_data->num_logical_accel;
 	dev_info.banks_per_accel = hw_data->num_banks
 					/ hw_data->num_logical_accel;
-	strscpy(dev_info.name, hw_data->dev_class->name, sizeof(dev_info.name));
+	strscpy(dev_info.name, hw_data->dev_class->name);
 	dev_info.instance_id = hw_data->instance_id;
 	dev_info.type = hw_data->dev_class->type;
 	dev_info.bus = accel_to_pci_dev(accel_dev)->bus->number;
diff --git a/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c b/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c
index f9017e03ec0f..32aeb795cc03 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_mstate_mgr.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2024 Intel Corporation */
 
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/types.h>
 #include "adf_mstate_mgr.h"
 
@@ -158,7 +159,7 @@ static struct adf_mstate_sect_h *adf_mstate_sect_add_header(struct adf_mstate_mg
 		return NULL;
 	}
 
-	strscpy(sect->id, id, sizeof(sect->id));
+	strscpy(sect->id, id);
 	sect->size = 0;
 	sect->sub_sects = 0;
 	mgr->state += sizeof(*sect);
diff --git a/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c b/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c
index a8f853516a3f..fc5d88a2bb17 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_transport_debug.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2014 - 2020 Intel Corporation */
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/seq_file.h>
 #include "adf_accel_devices.h"
 #include "adf_transport_internal.h"
@@ -103,7 +104,7 @@ int adf_ring_debugfs_add(struct adf_etr_ring_data *ring, const char *name)
 	if (!ring_debug)
 		return -ENOMEM;
 
-	strscpy(ring_debug->ring_name, name, sizeof(ring_debug->ring_name));
+	strscpy(ring_debug->ring_name, name);
 	snprintf(entry_name, sizeof(entry_name), "ring_%02d",
 		 ring->ring_number);
 
diff --git a/drivers/crypto/intel/qat/qat_common/qat_compression.c b/drivers/crypto/intel/qat/qat_common/qat_compression.c
index 1424d7a9bcd3..8129ad0c32d8 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_compression.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_compression.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2022 Intel Corporation */
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include "adf_accel_devices.h"
 #include "adf_common_drv.h"
 #include "adf_transport.h"
@@ -144,7 +145,7 @@ static int qat_compression_create_instances(struct adf_accel_dev *accel_dev)
 	int i;
 
 	INIT_LIST_HEAD(&accel_dev->compression_list);
-	strscpy(key, ADF_NUM_DC, sizeof(key));
+	strscpy(key, ADF_NUM_DC);
 	ret = adf_cfg_get_param_value(accel_dev, SEC, key, val);
 	if (ret)
 		return ret;
diff --git a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
index e0f38d32bc93..5c3636080757 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c
@@ -99,7 +99,7 @@ static int dev_supports_eng_type(struct otx_cpt_eng_grps *eng_grps,
 static void set_ucode_filename(struct otx_cpt_ucode *ucode,
 			       const char *filename)
 {
-	strscpy(ucode->filename, filename, OTX_CPT_UCODE_NAME_LENGTH);
+	strscpy(ucode->filename, filename);
 }
 
 static char *get_eng_type_str(int eng_type)
@@ -140,7 +140,7 @@ static int get_ucode_type(struct otx_cpt_ucode_hdr *ucode_hdr, int *ucode_type)
 	u32 i, val = 0;
 	u8 nn;
 
-	strscpy(tmp_ver_str, ucode_hdr->ver_str, OTX_CPT_UCODE_VER_STR_SZ);
+	strscpy(tmp_ver_str, ucode_hdr->ver_str);
 	for (i = 0; i < strlen(tmp_ver_str); i++)
 		tmp_ver_str[i] = tolower(tmp_ver_str[i]);
 
@@ -1331,7 +1331,7 @@ static ssize_t ucode_load_store(struct device *dev,
 
 	eng_grps = container_of(attr, struct otx_cpt_eng_grps, ucode_load_attr);
 	err_msg = "Invalid engine group format";
-	strscpy(tmp_buf, buf, OTX_CPT_UCODE_NAME_LENGTH);
+	strscpy(tmp_buf, buf);
 	start = tmp_buf;
 
 	has_se = has_ie = has_ae = false;
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index 9b0887d7e62c..465f00e74623 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -74,7 +74,7 @@ static int is_2nd_ucode_used(struct otx2_cpt_eng_grp_info *eng_grp)
 static void set_ucode_filename(struct otx2_cpt_ucode *ucode,
 			       const char *filename)
 {
-	strscpy(ucode->filename, filename, OTX2_CPT_NAME_LENGTH);
+	strscpy(ucode->filename, filename);
 }
 
 static char *get_eng_type_str(int eng_type)
@@ -130,7 +130,7 @@ static int get_ucode_type(struct device *dev,
 	int i, val = 0;
 	u8 nn;
 
-	strscpy(tmp_ver_str, ucode_hdr->ver_str, OTX2_CPT_UCODE_VER_STR_SZ);
+	strscpy(tmp_ver_str, ucode_hdr->ver_str);
 	for (i = 0; i < strlen(tmp_ver_str); i++)
 		tmp_ver_str[i] = tolower(tmp_ver_str[i]);
 
