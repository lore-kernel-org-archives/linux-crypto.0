Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD0B29E114;
	Sat, 17 Jan 2026 10:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768645100; cv=none; b=iOpBL/RsOjQlck370W8VP2d8h+HAzQWxQbNYBm3Oe/GiZnqAo9gUkpivhhn9XXedaBPJO2ix/tshIietwzypvMLySr1wQHqa4tm6gO6cqy7muvIfgV0XWreevGy7ls6hgBnNUxBdpD94AHFphBVPkIp3ZQaOnz733v285n4pnqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768645100; c=relaxed/simple;
	bh=vokO3ThQiKtAmitCP4Nsh5p5nuooF51ycL/p79gsJBI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SFjlcnlgDIv36nkbpEUZ6ieW6XOVufA3rPyUrB+V8A94QgLpDJluBe8Xeq6KUUVcFwNfR504JzNfi0Pr8l4BJ0icXshbuFYyCZuaYgAef7mIwUttNyoJLAcHb+SeGK3CFtb3NzAH1LQij/mEXTf5aZbie52Ja62xmYRi+Plgz28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=Ca8N6+gM; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="Ca8N6+gM"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Wsf0aw+znWIDBvfY25V6O6OSyEr12WK2QJfElgX+wVA=;
	b=Ca8N6+gMvto1kExhsKKDyucI11U6z0Qtfxp/jybXs9vtAx4xvEoo2Prl9JMdN5ZREdhI0fS2j
	9Fw3e8qfYAa6xB+Gd/St8Li+ZyZ81cd9VN07yARpWcgX6xjevUGrPcorucULIrzAzhKfU5k1LuF
	JNQJOndiWNddzLXMF7ktHCg=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4dtXdj6gX6z1K97h;
	Sat, 17 Jan 2026 18:14:49 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 4A40940563;
	Sat, 17 Jan 2026 18:18:09 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 17 Jan 2026 18:18:09 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 17 Jan 2026 18:18:08 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>
Subject: [PATCH 4/4] crypto: hisilicon/qm - increase wait time for mailbox
Date: Sat, 17 Jan 2026 18:18:06 +0800
Message-ID: <20260117101806.2172918-5-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260117101806.2172918-1-huangchenghai2@huawei.com>
References: <20260117101806.2172918-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq200001.china.huawei.com (7.202.195.16)

From: Weili Qian <qianweili@huawei.com>

The device requires more time to process queue stop and function stop
mailbox commands compared to other mailbox commands . In the current
driver, the mailbox processing wait time for queue stop and function
stop is less than the device timeout, which may cause the driver to
incorrectly assume that the mailbox processing has failed. Therefore,
the driver wait time for queue stop and function stop should be set to
be greater than the device timeout.  And PF and VF communication
relies on mailbox, the communication wait time should also be modified.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 94f96b6b38f5..571d0d250242 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -32,6 +32,8 @@
 #define QM_MB_PING_ALL_VFS		0xffff
 #define QM_MB_STATUS_MASK		GENMASK(12, 9)
 #define QM_MB_BUSY_MASK			BIT(13)
+#define QM_MB_MAX_WAIT_TIMEOUT		USEC_PER_SEC
+#define QM_MB_MAX_STOP_TIMEOUT		(5 * USEC_PER_SEC)
 
 /* sqc shift */
 #define QM_SQ_HOP_NUM_SHIFT		0
@@ -189,8 +191,8 @@
 #define QM_IFC_INT_DISABLE		BIT(0)
 #define QM_IFC_INT_STATUS_MASK		BIT(0)
 #define QM_IFC_INT_SET_MASK		BIT(0)
-#define QM_WAIT_DST_ACK			10
-#define QM_MAX_PF_WAIT_COUNT		10
+#define QM_WAIT_DST_ACK			1000
+#define QM_MAX_PF_WAIT_COUNT		20
 #define QM_MAX_VF_WAIT_COUNT		40
 #define QM_VF_RESET_WAIT_US		20000
 #define QM_VF_RESET_WAIT_CNT		3000
@@ -645,14 +647,14 @@ int hisi_qm_wait_mb_ready(struct hisi_qm *qm)
 }
 EXPORT_SYMBOL_GPL(hisi_qm_wait_mb_ready);
 
-static int qm_wait_mb_finish(struct hisi_qm *qm, struct qm_mailbox *mailbox)
+static int qm_wait_mb_finish(struct hisi_qm *qm, struct qm_mailbox *mailbox, u32 wait_timeout)
 {
 	struct device *dev = &qm->pdev->dev;
 	int ret;
 
 	ret = read_poll_timeout(qm_mb_read, *mailbox,
 				!(le16_to_cpu(mailbox->w0) & QM_MB_BUSY_MASK),
-				POLL_PERIOD, POLL_TIMEOUT,
+				POLL_PERIOD, wait_timeout,
 				true, qm);
 	if (ret) {
 		dev_err(dev, "QM mailbox operation timeout!\n");
@@ -667,7 +669,7 @@ static int qm_wait_mb_finish(struct hisi_qm *qm, struct qm_mailbox *mailbox)
 	return 0;
 }
 
-static int qm_mb_nolock(struct hisi_qm *qm, struct qm_mailbox *mailbox)
+static int qm_mb_nolock(struct hisi_qm *qm, struct qm_mailbox *mailbox, u32 wait_timeout)
 {
 	int ret;
 
@@ -677,7 +679,7 @@ static int qm_mb_nolock(struct hisi_qm *qm, struct qm_mailbox *mailbox)
 
 	qm_mb_write(qm, mailbox);
 
-	ret = qm_wait_mb_finish(qm, mailbox);
+	ret = qm_wait_mb_finish(qm, mailbox, wait_timeout);
 	if (ret)
 		goto mb_err_cnt_increase;
 
@@ -692,12 +694,24 @@ int hisi_qm_mb(struct hisi_qm *qm, u8 cmd, dma_addr_t dma_addr, u16 queue,
 	       bool op)
 {
 	struct qm_mailbox mailbox;
+	u32 wait_timeout;
 	int ret;
 
+	if (cmd == QM_MB_CMD_STOP_QP || cmd == QM_MB_CMD_FLUSH_QM)
+		wait_timeout = QM_MB_MAX_STOP_TIMEOUT;
+	else
+		wait_timeout = QM_MB_MAX_WAIT_TIMEOUT;
+
+	/* No need to judge if master OOO is blocked. */
+	if (qm_check_dev_error(qm)) {
+		dev_err(&qm->pdev->dev, "QM mailbox operation failed since qm is stop!\n");
+		return -EIO;
+	}
+
 	qm_mb_pre_init(&mailbox, cmd, dma_addr, queue, op);
 
 	mutex_lock(&qm->mailbox_lock);
-	ret = qm_mb_nolock(qm, &mailbox);
+	ret = qm_mb_nolock(qm, &mailbox, wait_timeout);
 	mutex_unlock(&qm->mailbox_lock);
 
 	return ret;
@@ -711,7 +725,7 @@ int hisi_qm_mb_read(struct hisi_qm *qm, u64 *base, u8 cmd, u16 queue)
 
 	qm_mb_pre_init(&mailbox, cmd, 0, queue, 1);
 	mutex_lock(&qm->mailbox_lock);
-	ret = qm_mb_nolock(qm, &mailbox);
+	ret = qm_mb_nolock(qm, &mailbox, QM_MB_MAX_WAIT_TIMEOUT);
 	mutex_unlock(&qm->mailbox_lock);
 	if (ret)
 		return ret;
@@ -769,7 +783,7 @@ int qm_set_and_get_xqc(struct hisi_qm *qm, u8 cmd, void *xqc, u32 qp_id, bool op
 		memcpy(tmp_xqc, xqc, size);
 
 	qm_mb_pre_init(&mailbox, cmd, xqc_dma, qp_id, op);
-	ret = qm_mb_nolock(qm, &mailbox);
+	ret = qm_mb_nolock(qm, &mailbox, QM_MB_MAX_WAIT_TIMEOUT);
 	if (!ret && op)
 		memcpy(xqc, tmp_xqc, size);
 
@@ -1897,7 +1911,7 @@ static int qm_set_ifc_begin_v3(struct hisi_qm *qm, enum qm_ifc_cmd cmd, u32 data
 
 	qm_mb_pre_init(&mailbox, QM_MB_CMD_SRC, msg, fun_num, 0);
 	mutex_lock(&qm->mailbox_lock);
-	return qm_mb_nolock(qm, &mailbox);
+	return qm_mb_nolock(qm, &mailbox, QM_MB_MAX_WAIT_TIMEOUT);
 }
 
 static void qm_set_ifc_end_v3(struct hisi_qm *qm)
-- 
2.33.0

