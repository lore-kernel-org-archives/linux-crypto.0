Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B646F1DE4E0;
	Sat, 13 Sep 2025 10:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757761082; cv=none; b=sXZIXMxywORRB8XCrngayxZPR0UgP9K5OQrSPhZGncDbc968vxu9nJ5ugxZCUYobZuWhR5ofc3TkJzbCLqWV8OOwzKsfM4Ykk5QOJcyTsuCjCfvaYMBW1kdaoFmbrsPGNO8bxX5c99IyAXLhihavUpBgrK4ckU4bpb6sdUQGOaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757761082; c=relaxed/simple;
	bh=9UpELKsRac94IM84RGRh1/MVvBMKYkAnSugTutWHriA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HoEQkGPVG11ig9ADcWc5X4fI9Ebrg246fQeNzB6rRAjgDCdbLVGokgRKhRKUHnDk8Epxazk+elwoQCELIqV9HVjsA0mlwKDz+kikrlJKTR+Xpg6fLKbbkQzNp0Z5uXsVhZg08BA8FfkQLX7CXEtZEq9l5/LfdZqLaj8kWD2hhk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cP7Tn5c6Fz2VR51;
	Sat, 13 Sep 2025 18:54:37 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 981DB1A0188;
	Sat, 13 Sep 2025 18:57:57 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 13 Sep 2025 18:57:57 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 13 Sep 2025 18:57:56 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linuxarm@openeuler.org>, <fanghao11@huawei.com>, <liulongfang@huawei.com>,
	<qianweili@huawei.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 3/5] crypto: hisilicon - enable error reporting again
Date: Sat, 13 Sep 2025 18:57:52 +0800
Message-ID: <20250913105754.3862444-4-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250913105754.3862444-1-huangchenghai2@huawei.com>
References: <20250913105754.3862444-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq200001.china.huawei.com (7.202.195.16)

From: Weili Qian <qianweili@huawei.com>

When an error occurs on the device, an interrupt is reported.
When the firmware forwards the interrupt to the driver and masks the
error. If the driver does not enable error reporting when an error does
not need to be reset, the device does not report the error to the driver
when the error occurs again. Therefore, after the driver obtains the
information, the error reporting needs to be enabled again.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c | 11 +++++++++++
 drivers/crypto/hisilicon/sec2/sec_main.c  | 11 +++++++++++
 drivers/crypto/hisilicon/zip/dae_main.c   |  8 ++++++++
 drivers/crypto/hisilicon/zip/zip_main.c   | 11 +++++++++++
 4 files changed, 41 insertions(+)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 718abe3fa5fe..b94fecd765ee 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -1399,6 +1399,15 @@ static void hpre_disable_error_report(struct hisi_qm *qm, u32 err_type)
 	writel(nfe_mask & (~err_type), qm->io_base + HPRE_RAS_NFE_ENB);
 }
 
+static void hpre_enable_error_report(struct hisi_qm *qm)
+{
+	u32 nfe_mask = qm->err_info.dev_err.nfe;
+	u32 ce_mask = qm->err_info.dev_err.ce;
+
+	writel(nfe_mask, qm->io_base + HPRE_RAS_NFE_ENB);
+	writel(ce_mask, qm->io_base + HPRE_RAS_CE_ENB);
+}
+
 static void hpre_open_axi_master_ooo(struct hisi_qm *qm)
 {
 	u32 value;
@@ -1426,6 +1435,8 @@ static enum acc_err_result hpre_get_err_result(struct hisi_qm *qm)
 			return ACC_ERR_NEED_RESET;
 		}
 		hpre_clear_hw_err_status(qm, err_status);
+		/* Avoid firmware disable error report, re-enable. */
+		hpre_enable_error_report(qm);
 	}
 
 	return ACC_ERR_RECOVERED;
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 19fda486fefb..5eb2d6820742 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -1112,6 +1112,15 @@ static void sec_disable_error_report(struct hisi_qm *qm, u32 err_type)
 	writel(nfe_mask & (~err_type), qm->io_base + SEC_RAS_NFE_REG);
 }
 
+static void sec_enable_error_report(struct hisi_qm *qm)
+{
+	u32 nfe_mask = qm->err_info.dev_err.nfe;
+	u32 ce_mask = qm->err_info.dev_err.ce;
+
+	writel(nfe_mask, qm->io_base + SEC_RAS_NFE_REG);
+	writel(ce_mask, qm->io_base + SEC_RAS_CE_REG);
+}
+
 static void sec_open_axi_master_ooo(struct hisi_qm *qm)
 {
 	u32 val;
@@ -1137,6 +1146,8 @@ static enum acc_err_result sec_get_err_result(struct hisi_qm *qm)
 			return ACC_ERR_NEED_RESET;
 		}
 		sec_clear_hw_err_status(qm, err_status);
+		/* Avoid firmware disable error report, re-enable. */
+		sec_enable_error_report(qm);
 	}
 
 	return ACC_ERR_RECOVERED;
diff --git a/drivers/crypto/hisilicon/zip/dae_main.c b/drivers/crypto/hisilicon/zip/dae_main.c
index 6f22e4c36e49..3507d26c7823 100644
--- a/drivers/crypto/hisilicon/zip/dae_main.c
+++ b/drivers/crypto/hisilicon/zip/dae_main.c
@@ -168,6 +168,12 @@ static void hisi_dae_disable_error_report(struct hisi_qm *qm, u32 err_type)
 	writel(DAE_ERR_NFE_MASK & (~err_type), qm->io_base + DAE_ERR_NFE_OFFSET);
 }
 
+static void hisi_dae_enable_error_report(struct hisi_qm *qm)
+{
+	writel(DAE_ERR_CE_MASK, qm->io_base + DAE_ERR_CE_OFFSET);
+	writel(DAE_ERR_NFE_MASK, qm->io_base + DAE_ERR_NFE_OFFSET);
+}
+
 static void hisi_dae_log_hw_error(struct hisi_qm *qm, u32 err_type)
 {
 	const struct hisi_dae_hw_error *err = dae_hw_error;
@@ -209,6 +215,8 @@ enum acc_err_result hisi_dae_get_err_result(struct hisi_qm *qm)
 		return ACC_ERR_NEED_RESET;
 	}
 	hisi_dae_clear_hw_err_status(qm, err_status);
+	/* Avoid firmware disable error report, re-enable. */
+	hisi_dae_enable_error_report(qm);
 
 	return ACC_ERR_RECOVERED;
 }
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index e206443ac8ef..e57dfe2b9fd9 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -1181,6 +1181,15 @@ static void hisi_zip_disable_error_report(struct hisi_qm *qm, u32 err_type)
 	writel(nfe_mask & (~err_type), qm->io_base + HZIP_CORE_INT_RAS_NFE_ENB);
 }
 
+static void hisi_zip_enable_error_report(struct hisi_qm *qm)
+{
+	u32 nfe_mask = qm->err_info.dev_err.nfe;
+	u32 ce_mask = qm->err_info.dev_err.ce;
+
+	writel(nfe_mask, qm->io_base + HZIP_CORE_INT_RAS_NFE_ENB);
+	writel(ce_mask, qm->io_base + HZIP_CORE_INT_RAS_CE_ENB);
+}
+
 static void hisi_zip_open_axi_master_ooo(struct hisi_qm *qm)
 {
 	u32 val;
@@ -1229,6 +1238,8 @@ static enum acc_err_result hisi_zip_get_err_result(struct hisi_qm *qm)
 			zip_result = ACC_ERR_NEED_RESET;
 		} else {
 			hisi_zip_clear_hw_err_status(qm, err_status);
+			/* Avoid firmware disable error report, re-enable. */
+			hisi_zip_enable_error_report(qm);
 		}
 	}
 
-- 
2.43.0

