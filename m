Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB9FD6C;
	Thu, 23 Nov 2023 21:52:56 -0800 (PST)
Received: from dggpemd200003.china.huawei.com (unknown [172.30.72.54])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Sc3zJ32g9zvR7Q;
	Fri, 24 Nov 2023 13:52:28 +0800 (CST)
Received: from localhost.localdomain (10.67.165.2) by
 dggpemd200003.china.huawei.com (7.185.36.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1258.28; Fri, 24 Nov 2023 13:52:54 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<shenyang39@huawei.com>
Subject: [PATCH v2] crypto: hisilicon/zip - add zip comp high perf mode configuration
Date: Fri, 24 Nov 2023 13:49:24 +0800
Message-ID: <20231124054924.3964946-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.30.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemd200003.china.huawei.com (7.185.36.122)
X-CFilter-Loop: Reflected

To meet specific application scenarios, the function of switching between
the high performance mode and the high compression mode is added.

Use the perf_mode=0/1 configuration to set the compression high perf mode,
0(default, high compression mode), 1(high performance mode). These two
modes only apply to the compression direction and are compatible with
software algorithm in both directions.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/zip/zip_main.c | 65 +++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index d6672b777efc..07ab61c113ab 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -107,6 +107,14 @@
 #define HZIP_CLOCK_GATED_EN		(HZIP_CORE_GATED_EN | \
 					 HZIP_CORE_GATED_OOO_EN)
 
+/* zip comp high performance */
+#define HZIP_HIGH_PERF_OFFSET		0x301208
+
+enum {
+	HZIP_HIGH_COMP_RATE,
+	HZIP_HIGH_COMP_PERF,
+};
+
 static const char hisi_zip_name[] = "hisi_zip";
 static struct dentry *hzip_debugfs_root;
 
@@ -352,6 +360,37 @@ static int hzip_diff_regs_show(struct seq_file *s, void *unused)
 	return 0;
 }
 DEFINE_SHOW_ATTRIBUTE(hzip_diff_regs);
+
+static int perf_mode_set(const char *val, const struct kernel_param *kp)
+{
+	int ret;
+	u32 n;
+
+	if (!val)
+		return -EINVAL;
+
+	ret = kstrtou32(val, 10, &n);
+	if (ret != 0 || (n != HZIP_HIGH_COMP_PERF &&
+			 n != HZIP_HIGH_COMP_RATE))
+		return -EINVAL;
+
+	return param_set_int(val, kp);
+}
+
+static const struct kernel_param_ops zip_com_perf_ops = {
+	.set = perf_mode_set,
+	.get = param_get_int,
+};
+
+/*
+ * perf_mode = 0 means enable high compression rate mode,
+ * perf_mode = 1 means enable high compression performance mode.
+ * These two modes only apply to the compression direction.
+ */
+static u32 perf_mode = HZIP_HIGH_COMP_RATE;
+module_param_cb(perf_mode, &zip_com_perf_ops, &perf_mode, 0444);
+MODULE_PARM_DESC(perf_mode, "ZIP high perf mode 0(default), 1(enable)");
+
 static const struct kernel_param_ops zip_uacce_mode_ops = {
 	.set = uacce_mode_set,
 	.get = param_get_int,
@@ -417,6 +456,28 @@ bool hisi_zip_alg_support(struct hisi_qm *qm, u32 alg)
 	return false;
 }
 
+static int hisi_zip_set_high_perf(struct hisi_qm *qm)
+{
+	u32 val;
+	int ret;
+
+	val = readl_relaxed(qm->io_base + HZIP_HIGH_PERF_OFFSET);
+	if (perf_mode == HZIP_HIGH_COMP_PERF)
+		val |= HZIP_HIGH_COMP_PERF;
+	else
+		val &= ~HZIP_HIGH_COMP_PERF;
+
+	/* Set perf mode */
+	writel(val, qm->io_base + HZIP_HIGH_PERF_OFFSET);
+	ret = readl_relaxed_poll_timeout(qm->io_base + HZIP_HIGH_PERF_OFFSET,
+					 val, val == perf_mode, HZIP_DELAY_1_US,
+					 HZIP_POLL_TIMEOUT_US);
+	if (ret)
+		pci_err(qm->pdev, "failed to set perf mode\n");
+
+	return ret;
+}
+
 static int hisi_zip_set_qm_algs(struct hisi_qm *qm)
 {
 	struct device *dev = &qm->pdev->dev;
@@ -1115,6 +1176,10 @@ static int hisi_zip_pf_probe_init(struct hisi_zip *hisi_zip)
 	if (ret)
 		return ret;
 
+	ret = hisi_zip_set_high_perf(qm);
+	if (ret)
+		return ret;
+
 	hisi_zip_open_sva_prefetch(qm);
 	hisi_qm_dev_err_init(qm);
 	hisi_zip_debug_regs_clear(qm);
-- 
2.30.0

