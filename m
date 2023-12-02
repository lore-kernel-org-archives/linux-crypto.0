Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D2F1A6;
	Sat,  2 Dec 2023 01:20:58 -0800 (PST)
Received: from dggpeml500005.china.huawei.com (unknown [172.30.72.53])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Sj47t2nPfzsRbK;
	Sat,  2 Dec 2023 17:17:14 +0800 (CST)
Received: from localhost.localdomain (10.67.165.2) by
 dggpeml500005.china.huawei.com (7.185.36.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sat, 2 Dec 2023 17:20:56 +0800
From: Zhiqi Song <songzhiqi1@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<wangzhou1@hisilicon.com>, <fanghao11@huawei.com>, <liulongfang@huawei.com>,
	<qianweili@huawei.com>, <shenyang39@huawei.com>
Subject: [PATCH 5/5] crypto: hisilicon/zip - save capability registers in probe process
Date: Sat, 2 Dec 2023 17:17:22 +0800
Message-ID: <20231202091722.1974582-6-songzhiqi1@huawei.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20231202091722.1974582-1-songzhiqi1@huawei.com>
References: <20231202091722.1974582-1-songzhiqi1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500005.china.huawei.com (7.185.36.59)
X-CFilter-Loop: Reflected

Pre-store the valid value of the zip alg support related capability
register in hisi_zip_qm_init(), which will be called by hisi_zip_probe().
It can reduce the number of capability register queries and avoid
obtaining incorrect values in abnormal scenarios, such as reset failed
and the memory space disabled.

Fixes: db700974b69d ("crypto: hisilicon/zip - support zip capability")
Signed-off-by: Zhiqi Song <songzhiqi1@huawei.com>
---
 drivers/crypto/hisilicon/zip/zip_main.c | 73 ++++++++++++++++++++-----
 1 file changed, 60 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 2934de25efa4..479ba8a1d6b5 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -249,6 +249,26 @@ static struct hisi_qm_cap_info zip_basic_cap_info[] = {
 	{ZIP_CAP_MAX, 0x317c, 0, GENMASK(0, 0), 0x0, 0x0, 0x0}
 };
 
+enum zip_pre_store_cap_idx {
+	ZIP_CORE_NUM_CAP_IDX = 0x0,
+	ZIP_CLUSTER_COMP_NUM_CAP_IDX,
+	ZIP_CLUSTER_DECOMP_NUM_CAP_IDX,
+	ZIP_DECOMP_ENABLE_BITMAP_IDX,
+	ZIP_COMP_ENABLE_BITMAP_IDX,
+	ZIP_DRV_ALG_BITMAP_IDX,
+	ZIP_DEV_ALG_BITMAP_IDX,
+};
+
+static const u32 zip_pre_store_caps[] = {
+	ZIP_CORE_NUM_CAP,
+	ZIP_CLUSTER_COMP_NUM_CAP,
+	ZIP_CLUSTER_DECOMP_NUM_CAP,
+	ZIP_DECOMP_ENABLE_BITMAP,
+	ZIP_COMP_ENABLE_BITMAP,
+	ZIP_DRV_ALG_BITMAP,
+	ZIP_DEV_ALG_BITMAP,
+};
+
 enum {
 	HZIP_COMP_CORE0,
 	HZIP_COMP_CORE1,
@@ -443,7 +463,7 @@ bool hisi_zip_alg_support(struct hisi_qm *qm, u32 alg)
 {
 	u32 cap_val;
 
-	cap_val = hisi_qm_get_hw_info(qm, zip_basic_cap_info, ZIP_DRV_ALG_BITMAP, qm->cap_ver);
+	cap_val = qm->cap_tables.dev_cap_table[ZIP_DRV_ALG_BITMAP_IDX].cap_val;
 	if ((alg & cap_val) == alg)
 		return true;
 
@@ -568,10 +588,8 @@ static int hisi_zip_set_user_domain_and_cache(struct hisi_qm *qm)
 	}
 
 	/* let's open all compression/decompression cores */
-	dcomp_bm = hisi_qm_get_hw_info(qm, zip_basic_cap_info,
-				       ZIP_DECOMP_ENABLE_BITMAP, qm->cap_ver);
-	comp_bm = hisi_qm_get_hw_info(qm, zip_basic_cap_info,
-				      ZIP_COMP_ENABLE_BITMAP, qm->cap_ver);
+	dcomp_bm = qm->cap_tables.dev_cap_table[ZIP_DECOMP_ENABLE_BITMAP_IDX].cap_val;
+	comp_bm = qm->cap_tables.dev_cap_table[ZIP_COMP_ENABLE_BITMAP_IDX].cap_val;
 	writel(HZIP_DECOMP_CHECK_ENABLE | dcomp_bm | comp_bm, base + HZIP_CLOCK_GATE_CTRL);
 
 	/* enable sqc,cqc writeback */
@@ -798,9 +816,8 @@ static int hisi_zip_core_debug_init(struct hisi_qm *qm)
 	char buf[HZIP_BUF_SIZE];
 	int i;
 
-	zip_core_num = hisi_qm_get_hw_info(qm, zip_basic_cap_info, ZIP_CORE_NUM_CAP, qm->cap_ver);
-	zip_comp_core_num = hisi_qm_get_hw_info(qm, zip_basic_cap_info, ZIP_CLUSTER_COMP_NUM_CAP,
-						qm->cap_ver);
+	zip_core_num = qm->cap_tables.dev_cap_table[ZIP_CORE_NUM_CAP_IDX].cap_val;
+	zip_comp_core_num = qm->cap_tables.dev_cap_table[ZIP_CLUSTER_COMP_NUM_CAP_IDX].cap_val;
 
 	for (i = 0; i < zip_core_num; i++) {
 		if (i < zip_comp_core_num)
@@ -942,7 +959,7 @@ static int hisi_zip_show_last_regs_init(struct hisi_qm *qm)
 	u32 zip_core_num;
 	int i, j, idx;
 
-	zip_core_num = hisi_qm_get_hw_info(qm, zip_basic_cap_info, ZIP_CORE_NUM_CAP, qm->cap_ver);
+	zip_core_num = qm->cap_tables.dev_cap_table[ZIP_CORE_NUM_CAP_IDX].cap_val;
 
 	debug->last_words = kcalloc(core_dfx_regs_num * zip_core_num + com_dfx_regs_num,
 				    sizeof(unsigned int), GFP_KERNEL);
@@ -998,9 +1015,9 @@ static void hisi_zip_show_last_dfx_regs(struct hisi_qm *qm)
 				 hzip_com_dfx_regs[i].name, debug->last_words[i], val);
 	}
 
-	zip_core_num = hisi_qm_get_hw_info(qm, zip_basic_cap_info, ZIP_CORE_NUM_CAP, qm->cap_ver);
-	zip_comp_core_num = hisi_qm_get_hw_info(qm, zip_basic_cap_info, ZIP_CLUSTER_COMP_NUM_CAP,
-						qm->cap_ver);
+	zip_core_num = qm->cap_tables.dev_cap_table[ZIP_CORE_NUM_CAP_IDX].cap_val;
+	zip_comp_core_num = qm->cap_tables.dev_cap_table[ZIP_CLUSTER_COMP_NUM_CAP_IDX].cap_val;
+
 	for (i = 0; i < zip_core_num; i++) {
 		if (i < zip_comp_core_num)
 			scnprintf(buf, sizeof(buf), "Comp_core-%d", i);
@@ -1156,6 +1173,28 @@ static int hisi_zip_pf_probe_init(struct hisi_zip *hisi_zip)
 	return ret;
 }
 
+static int zip_pre_store_cap_reg(struct hisi_qm *qm)
+{
+	struct hisi_qm_cap_record *zip_cap;
+	struct pci_dev *pdev = qm->pdev;
+	size_t i, size;
+
+	size = ARRAY_SIZE(zip_pre_store_caps);
+	zip_cap = devm_kzalloc(&pdev->dev, sizeof(*zip_cap) * size, GFP_KERNEL);
+	if (!zip_cap)
+		return -ENOMEM;
+
+	for (i = 0; i < size; i++) {
+		zip_cap[i].type = zip_pre_store_caps[i];
+		zip_cap[i].cap_val = hisi_qm_get_hw_info(qm, zip_basic_cap_info,
+				     zip_pre_store_caps[i], qm->cap_ver);
+	}
+
+	qm->cap_tables.dev_cap_table = zip_cap;
+
+	return 0;
+}
+
 static int hisi_zip_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 {
 	u64 alg_msk;
@@ -1194,7 +1233,15 @@ static int hisi_zip_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
 		return ret;
 	}
 
-	alg_msk = hisi_qm_get_hw_info(qm, zip_basic_cap_info, ZIP_DEV_ALG_BITMAP, qm->cap_ver);
+	/* Fetch and save the value of capability registers */
+	ret = zip_pre_store_cap_reg(qm);
+	if (ret) {
+		pci_err(qm->pdev, "Failed to pre-store capability registers!\n");
+		hisi_qm_uninit(qm);
+		return ret;
+	}
+
+	alg_msk = qm->cap_tables.dev_cap_table[ZIP_DEV_ALG_BITMAP_IDX].cap_val;
 	ret = hisi_qm_set_algs(qm, alg_msk, zip_dev_algs, ARRAY_SIZE(zip_dev_algs));
 	if (ret) {
 		pci_err(qm->pdev, "Failed to set zip algs!\n");
-- 
2.30.0

