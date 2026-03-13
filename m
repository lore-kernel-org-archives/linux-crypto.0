Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E76F1A681C;
	Fri, 13 Mar 2026 09:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773394901; cv=none; b=hc0Fz1tRVzYBFqKZwmSzoWkTALJJSwbHEX0XLa6Sxl5uaZkF5vFDG4xLgDHrYBSe64UN/yXs/GeT4UfUdsd+l+2d4PmaPsu0v2SqQOJBYsaXDswFzqgb6QvJXZMDFK2WFQ34pQpyO2Nz9CrtNUYr7kTkyYFcT+BI0iWyk5O2A8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773394901; c=relaxed/simple;
	bh=1RBufhyG3lBLpNCUvmo+jrQMYAjCO9A/ClgOzZ+SqlY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KKm7Tpc8IPml8ZMkLU+sxPFV4PIauyCJRG+J84Efj7Qi+7QGxdC+xqPDWEp2Ra9snOEL2QQ0DIBD266v3x6SIDpIuqwdb2p5XsXOuyTxv8CXHsmmHJ8TjzlYJgSl8AUUY9FaPMNvAk0tsTkJ7kH5GQcZR1Z5QnjVWq9DKZ2ESbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=LXKCajaj; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="LXKCajaj"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=DfeESmDtqu7t+0yUbKKfbTdWfljYgVuD+uYyybDydGY=;
	b=LXKCajajLXp3hdkV7RS4jHkLDKZ20W3rqp/NScXQYywg9elYXCU/2iX4en/oQ+dU57ntxO6qT
	X2FLBI+WKKFOOYdoUmH5MHryNUSImLnWc6+bj+r9nsb3qD8TMigp1frD8wQ8hIhy/QnD0oo12iL
	iaNlHw70DwV1KoDQgr1HfQs=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4fXK9X4Lnjz12LJy;
	Fri, 13 Mar 2026 17:36:00 +0800 (CST)
Received: from kwepemr100008.china.huawei.com (unknown [7.202.195.119])
	by mail.maildlp.com (Postfix) with ESMTPS id DE0E420104;
	Fri, 13 Mar 2026 17:41:34 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemr100008.china.huawei.com (7.202.195.119) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Fri, 13 Mar 2026 17:41:34 +0800
From: ZongYu Wu <wuzongyu1@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>
Subject: [PATCH] crypto:hisilicon - add device load query functionality to debugfs
Date: Fri, 13 Mar 2026 17:40:39 +0800
Message-ID: <20260313094039.3390686-1-wuzongyu1@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr100008.china.huawei.com (7.202.195.119)

From: Zongyu Wu <wuzongyu1@huawei.com>

The accelerator device supports usage statistics. This patch enables
obtaining the accelerator's usage through the "dev_usage" file.
The returned number expressed as a percentage as a percentage.

Signed-off-by: Zongyu Wu <wuzongyu1@huawei.com>
---
 Documentation/ABI/testing/debugfs-hisi-hpre |  7 +++
 Documentation/ABI/testing/debugfs-hisi-sec  |  7 +++
 Documentation/ABI/testing/debugfs-hisi-zip  |  7 +++
 drivers/crypto/hisilicon/debugfs.c          | 54 +++++++++++++++++++++
 drivers/crypto/hisilicon/hpre/hpre_main.c   | 18 +++++++
 drivers/crypto/hisilicon/sec2/sec_main.c    | 11 +++++
 drivers/crypto/hisilicon/zip/zip_main.c     | 19 ++++++++
 include/linux/hisi_acc_qm.h                 | 12 +++++
 8 files changed, 135 insertions(+)

diff --git a/Documentation/ABI/testing/debugfs-hisi-hpre b/Documentation/ABI/testing/debugfs-hisi-hpre
index 29fb7d5ffc69..5a137f701eea 100644
--- a/Documentation/ABI/testing/debugfs-hisi-hpre
+++ b/Documentation/ABI/testing/debugfs-hisi-hpre
@@ -50,6 +50,13 @@ Description:	Dump debug registers from the QM.
 		Available for PF and VF in host. VF in guest currently only
 		has one debug register.
 
+What:		/sys/kernel/debug/hisi_hpre/<bdf>/dev_usage
+Date:		Mar 2026
+Contact:	linux-crypto@vger.kernel.org
+Description:	Query the real-time bandwidth usage of device.
+		Returns the bandwidth usage of each channel on the device.
+		The returned number is in percentage.
+
 What:		/sys/kernel/debug/hisi_hpre/<bdf>/qm/current_q
 Date:		Sep 2019
 Contact:	linux-crypto@vger.kernel.org
diff --git a/Documentation/ABI/testing/debugfs-hisi-sec b/Documentation/ABI/testing/debugfs-hisi-sec
index 82bf4a0dc7f7..676e2dc2de8d 100644
--- a/Documentation/ABI/testing/debugfs-hisi-sec
+++ b/Documentation/ABI/testing/debugfs-hisi-sec
@@ -24,6 +24,13 @@ Description:	The <bdf> is related the function for PF and VF.
 		1/1000~1000/1000 of total QoS. The driver reading alg_qos to
 		get related QoS in the host and VM, Such as "cat alg_qos".
 
+What:		/sys/kernel/debug/hisi_sec2/<bdf>/dev_usage
+Date:		Mar 2026
+Contact:	linux-crypto@vger.kernel.org
+Description:	Query the real-time bandwidth usage of device.
+		Returns the bandwidth usage of each channel on the device.
+		The returned number is in percentage.
+
 What:		/sys/kernel/debug/hisi_sec2/<bdf>/qm/qm_regs
 Date:		Oct 2019
 Contact:	linux-crypto@vger.kernel.org
diff --git a/Documentation/ABI/testing/debugfs-hisi-zip b/Documentation/ABI/testing/debugfs-hisi-zip
index 0abd65d27e9b..46bf47bf6b42 100644
--- a/Documentation/ABI/testing/debugfs-hisi-zip
+++ b/Documentation/ABI/testing/debugfs-hisi-zip
@@ -36,6 +36,13 @@ Description:	The <bdf> is related the function for PF and VF.
 		1/1000~1000/1000 of total QoS. The driver reading alg_qos to
 		get related QoS in the host and VM, Such as "cat alg_qos".
 
+What:		/sys/kernel/debug/hisi_zip/<bdf>/dev_usage
+Date:		Mar 2026
+Contact:	linux-crypto@vger.kernel.org
+Description:	Query the real-time bandwidth usage of device.
+		Returns the bandwidth usage of each channel on the device.
+		The returned number is in percentage.
+
 What:		/sys/kernel/debug/hisi_zip/<bdf>/qm/regs
 Date:		Nov 2018
 Contact:	linux-crypto@vger.kernel.org
diff --git a/drivers/crypto/hisilicon/debugfs.c b/drivers/crypto/hisilicon/debugfs.c
index 32e9f8350289..5d8b4112c543 100644
--- a/drivers/crypto/hisilicon/debugfs.c
+++ b/drivers/crypto/hisilicon/debugfs.c
@@ -1040,6 +1040,57 @@ void hisi_qm_show_last_dfx_regs(struct hisi_qm *qm)
 	}
 }
 
+static int qm_usage_percent(struct hisi_qm *qm, int chan_num)
+{
+	u32 val, used_bw, total_bw;
+
+	val = readl(qm->io_base + QM_CHANNEL_USAGE_OFFSET +
+				chan_num * QM_CHANNEL_ADDR_INTRVL);
+	used_bw = lower_16_bits(val);
+	total_bw = upper_16_bits(val);
+	if (!total_bw)
+		return -EIO;
+
+	if (total_bw <= used_bw)
+		return QM_MAX_DEV_USAGE;
+
+	return (used_bw * QM_DEV_USAGE_RATE) / total_bw;
+}
+
+static int qm_usage_show(struct seq_file *s, void *unused)
+{
+	struct hisi_qm *qm = s->private;
+	bool dev_is_active = true;
+	int i, ret;
+
+	/* If device is in suspended, usage is 0. */
+	ret = hisi_qm_get_dfx_access(qm);
+	if (ret == -EAGAIN) {
+		dev_is_active = false;
+	} else if (ret) {
+		dev_err(&qm->pdev->dev, "failed to get dfx access for usage_show!\n");
+		return ret;
+	}
+
+	ret = 0;
+	for (i = 0; i < qm->channel_data.channel_num; i++) {
+		if (dev_is_active) {
+			ret = qm_usage_percent(qm, i);
+			if (ret < 0) {
+				hisi_qm_put_dfx_access(qm);
+				return ret;
+			}
+		}
+		seq_printf(s, "%s: %d\n", qm->channel_data.channel_name[i], ret);
+	}
+
+	if (dev_is_active)
+		hisi_qm_put_dfx_access(qm);
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(qm_usage);
+
 static int qm_diff_regs_show(struct seq_file *s, void *unused)
 {
 	struct hisi_qm *qm = s->private;
@@ -1159,6 +1210,9 @@ void hisi_qm_debug_init(struct hisi_qm *qm)
 		debugfs_create_file("diff_regs", 0444, qm->debug.qm_d,
 					qm, &qm_diff_regs_fops);
 
+	if (qm->ver >= QM_HW_V5)
+		debugfs_create_file("dev_usage", 0444, qm->debug.debug_root, qm, &qm_usage_fops);
+
 	debugfs_create_file("regs", 0444, qm->debug.qm_d, qm, &qm_regs_fops);
 
 	debugfs_create_file("cmd", 0600, qm->debug.qm_d, qm, &qm_cmd_fops);
diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 884d5d0afaf4..357ab5e5887e 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -121,6 +121,8 @@
 #define HPRE_DFX_COMMON2_LEN		0xE
 #define HPRE_DFX_CORE_LEN		0x43
 
+#define HPRE_MAX_CHANNEL_NUM		2
+
 static const char hpre_name[] = "hisi_hpre";
 static struct dentry *hpre_debugfs_root;
 static const struct pci_device_id hpre_dev_ids[] = {
@@ -370,6 +372,11 @@ static struct dfx_diff_registers hpre_diff_regs[] = {
 	},
 };
 
+static const char *hpre_channel_name[HPRE_MAX_CHANNEL_NUM] = {
+	"RSA",
+	"ECC",
+};
+
 static const struct hisi_qm_err_ini hpre_err_ini;
 
 bool hpre_check_alg_support(struct hisi_qm *qm, u32 alg)
@@ -1234,6 +1241,16 @@ static int hpre_pre_store_cap_reg(struct hisi_qm *qm)
 	return 0;
 }
 
+static void hpre_set_channels(struct hisi_qm *qm)
+{
+	struct qm_channel *channel_data = &qm->channel_data;
+	int i;
+
+	channel_data->channel_num = HPRE_MAX_CHANNEL_NUM;
+	for (i = 0; i < HPRE_MAX_CHANNEL_NUM; i++)
+		channel_data->channel_name[i] = hpre_channel_name[i];
+}
+
 static int hpre_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 {
 	u64 alg_msk;
@@ -1267,6 +1284,7 @@ static int hpre_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 		return ret;
 	}
 
+	hpre_set_channels(qm);
 	/* Fetch and save the value of capability registers */
 	ret = hpre_pre_store_cap_reg(qm);
 	if (ret) {
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index efda8646fc60..6647b7340827 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -133,6 +133,8 @@
 #define SEC_AEAD_BITMAP			(GENMASK_ULL(7, 6) | GENMASK_ULL(18, 17) | \
 					GENMASK_ULL(45, 43))
 
+#define SEC_MAX_CHANNEL_NUM		1
+
 struct sec_hw_error {
 	u32 int_msk;
 	const char *msg;
@@ -1288,6 +1290,14 @@ static int sec_pre_store_cap_reg(struct hisi_qm *qm)
 	return 0;
 }
 
+static void sec_set_channels(struct hisi_qm *qm)
+{
+	struct qm_channel *channel_data = &qm->channel_data;
+
+	channel_data->channel_num = SEC_MAX_CHANNEL_NUM;
+	channel_data->channel_name[0] = "SEC";
+}
+
 static int sec_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 {
 	u64 alg_msk;
@@ -1325,6 +1335,7 @@ static int sec_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 		return ret;
 	}
 
+	sec_set_channels(qm);
 	/* Fetch and save the value of capability registers */
 	ret = sec_pre_store_cap_reg(qm);
 	if (ret) {
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 85b26ef17548..44df9c859bd8 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -122,6 +122,8 @@
 #define HZIP_LIT_LEN_EN_OFFSET		0x301204
 #define HZIP_LIT_LEN_EN_EN		BIT(4)
 
+#define HZIP_MAX_CHANNEL_NUM		3
+
 enum {
 	HZIP_HIGH_COMP_RATE,
 	HZIP_HIGH_COMP_PERF,
@@ -359,6 +361,12 @@ static struct dfx_diff_registers hzip_diff_regs[] = {
 	},
 };
 
+static const char *zip_channel_name[HZIP_MAX_CHANNEL_NUM] = {
+	"COMPRESS",
+	"DECOMPRESS",
+	"DAE"
+};
+
 static int hzip_diff_regs_show(struct seq_file *s, void *unused)
 {
 	struct hisi_qm *qm = s->private;
@@ -1400,6 +1408,16 @@ static int zip_pre_store_cap_reg(struct hisi_qm *qm)
 	return 0;
 }
 
+static void zip_set_channels(struct hisi_qm *qm)
+{
+	struct qm_channel *channel_data = &qm->channel_data;
+	int i;
+
+	channel_data->channel_num = HZIP_MAX_CHANNEL_NUM;
+	for (i = 0; i < HZIP_MAX_CHANNEL_NUM; i++)
+		channel_data->channel_name[i] = zip_channel_name[i];
+}
+
 static int hisi_zip_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 {
 	u64 alg_msk;
@@ -1438,6 +1456,7 @@ static int hisi_zip_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 		return ret;
 	}
 
+	zip_set_channels(qm);
 	/* Fetch and save the value of capability registers */
 	ret = zip_pre_store_cap_reg(qm);
 	if (ret) {
diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index 51a6dc2b97e9..8a581b5bbbcd 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -102,6 +102,12 @@
 #define QM_MIG_REGION_SEL		0x100198
 #define QM_MIG_REGION_EN		BIT(0)
 
+#define QM_MAX_CHANNEL_NUM		8
+#define QM_CHANNEL_USAGE_OFFSET		0x1100
+#define QM_MAX_DEV_USAGE		100
+#define QM_DEV_USAGE_RATE		100
+#define QM_CHANNEL_ADDR_INTRVL		0x4
+
 /* uacce mode of the driver */
 #define UACCE_MODE_NOUACCE		0 /* don't use uacce */
 #define UACCE_MODE_SVA			1 /* use uacce sva mode */
@@ -359,6 +365,11 @@ struct qm_rsv_buf {
 	struct qm_dma qcdma;
 };
 
+struct qm_channel {
+	int channel_num;
+	const char *channel_name[QM_MAX_CHANNEL_NUM];
+};
+
 struct hisi_qm {
 	enum qm_hw_ver ver;
 	enum qm_fun_type fun_type;
@@ -433,6 +444,7 @@ struct hisi_qm {
 	struct qm_err_isolate isolate_data;
 
 	struct hisi_qm_cap_tables cap_tables;
+	struct qm_channel channel_data;
 };
 
 struct hisi_qp_status {
-- 
2.33.0

