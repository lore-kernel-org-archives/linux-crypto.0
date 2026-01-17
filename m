Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8872AF1D;
	Sat, 17 Jan 2026 10:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768645101; cv=none; b=Bc9XtDrxxq+tUnAyGe/Y7Pi8sALL3jAnFQNUaW9SD4jibZntgEf+1S+Zlx50h7+ugcSsXfkti630vHkBszJZ/3g9Am4xQYaHqNdrnTvN+atIrvQS6CTKKstrs0hXC61r6gY2PuQkTsSa8tUJianp9Y8nYrNckV3K1jXflbqkzb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768645101; c=relaxed/simple;
	bh=F3CQ2i9mOChIGfbAlz+e4RLo3NyiwFFF4GlGfb+Hv3s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a8RDq3bhzNkBMcwKSR2zy5EOleAEr3xICjFGIEPFa9uIVq5WsrW5jslxn7iYphcQ8lJmDU9XA319UpYpEhUfSedaWQa7VhKZBxDZqXFKwjhiZodZX39GQ2VBdCk+FPuyqjel/yxfz0HVxq/F5dsawZFK0XFP2nyQ4EBR1uL8Xow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=SLUqDFDW; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="SLUqDFDW"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=XWirnVW4RmGYF9aGx8Ms/Q30Z3xEEHjfbD9aXL6YKGQ=;
	b=SLUqDFDW7r90NaqS1yfquhHNdau6zNrUrCmWKOp9n25cAOxbsYcZgIJ5tMdriKDiB0YPrGqkU
	c3/heG7awGVAR28YsnkGVV6g555Z6TPfLJ4JoLxoNqo2gvcpQ0Uy3nJXhwqbzjGANb+J+P+RFGW
	Zfgu2iOMNoKxjzA0CdoY0I0=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4dtXdh09X0zLlSk;
	Sat, 17 Jan 2026 18:14:48 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id BE36B40565;
	Sat, 17 Jan 2026 18:18:08 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 17 Jan 2026 18:18:08 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 17 Jan 2026 18:18:08 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>
Subject: [PATCH 3/4] crypto: hisilicon/qm - obtain the mailbox configuration at one time
Date: Sat, 17 Jan 2026 18:18:05 +0800
Message-ID: <20260117101806.2172918-4-huangchenghai2@huawei.com>
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

The malibox needs to be triggered by a 128bit atomic operation.
The reason is that the PF and VFs of the device share the mmio memory
of the mailbox, and the mutex cannot lock mailbox operations in
different functions, especially when passing through VFs to
virtual machines.

Currently, the write operation to the mailbox is already a 128-bit
atomic write. The read operation also needs to be modified to a
128-bit atomic read. Since there is no general 128-bit IO memory
access API in the current ARM64 architecture, and the stp and ldp
instructions do not guarantee atomic access to device memory, they
cannot be extracted as a general API. Therefore, the 128-bit atomic
read and write operations need to be implemented in the driver.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 133 ++++++++++++++++++++++------------
 include/linux/hisi_acc_qm.h   |   1 +
 2 files changed, 87 insertions(+), 47 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 2bb94e8c6a07..94f96b6b38f5 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -31,6 +31,7 @@
 /* mailbox */
 #define QM_MB_PING_ALL_VFS		0xffff
 #define QM_MB_STATUS_MASK		GENMASK(12, 9)
+#define QM_MB_BUSY_MASK			BIT(13)
 
 /* sqc shift */
 #define QM_SQ_HOP_NUM_SHIFT		0
@@ -582,16 +583,30 @@ static void qm_mb_pre_init(struct qm_mailbox *mailbox, u8 cmd,
 	mailbox->rsvd = 0;
 }
 
-/* return 0 mailbox ready, -ETIMEDOUT hardware timeout */
-int hisi_qm_wait_mb_ready(struct hisi_qm *qm)
+/*
+ * The mailbox is 128 bits and requires a single read/write operation.
+ * Since there is no general 128-bit IO memory access API in the current
+ * ARM64 architecture, this needs to be implemented in the driver.
+ */
+static struct qm_mailbox qm_mb_read(struct hisi_qm *qm)
 {
-	u32 val;
+	struct qm_mailbox mailbox = {0};
+
+#if IS_ENABLED(CONFIG_ARM64)
+	const void __iomem *fun_base = qm->io_base + QM_MB_CMD_SEND_BASE;
+	unsigned long tmp0, tmp1;
 
-	return readl_relaxed_poll_timeout(qm->io_base + QM_MB_CMD_SEND_BASE,
-					  val, !((val >> QM_MB_BUSY_SHIFT) &
-					  0x1), POLL_PERIOD, POLL_TIMEOUT);
+	asm volatile("ldp %0, %1, %3\n"
+		     "stp %0, %1, %2\n"
+		     : "=&r" (tmp0),
+		       "=&r" (tmp1),
+		       "+Q" (mailbox)
+		     : "Q" (*((char __iomem *)fun_base))
+		     : "memory");
+#endif
+
+	return mailbox;
 }
-EXPORT_SYMBOL_GPL(hisi_qm_wait_mb_ready);
 
 /* 128 bit should be written to hardware at one time to trigger a mailbox */
 static void qm_mb_write(struct hisi_qm *qm, const void *src)
@@ -614,35 +629,61 @@ static void qm_mb_write(struct hisi_qm *qm, const void *src)
 #endif
 }
 
-static int qm_mb_nolock(struct hisi_qm *qm, struct qm_mailbox *mailbox)
+int hisi_qm_wait_mb_ready(struct hisi_qm *qm)
 {
+	struct qm_mailbox mailbox = {0};
 	int ret;
-	u32 val;
 
-	if (unlikely(hisi_qm_wait_mb_ready(qm))) {
+	ret = read_poll_timeout(qm_mb_read, mailbox,
+				!(le16_to_cpu(mailbox.w0) & QM_MB_BUSY_MASK),
+				POLL_PERIOD, POLL_TIMEOUT,
+				true, qm);
+	if (ret)
 		dev_err(&qm->pdev->dev, "QM mailbox is busy to start!\n");
-		ret = -EBUSY;
-		goto mb_busy;
-	}
 
-	qm_mb_write(qm, mailbox);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(hisi_qm_wait_mb_ready);
+
+static int qm_wait_mb_finish(struct hisi_qm *qm, struct qm_mailbox *mailbox)
+{
+	struct device *dev = &qm->pdev->dev;
+	int ret;
 
-	if (unlikely(hisi_qm_wait_mb_ready(qm))) {
-		dev_err(&qm->pdev->dev, "QM mailbox operation timeout!\n");
-		ret = -ETIMEDOUT;
-		goto mb_busy;
+	ret = read_poll_timeout(qm_mb_read, *mailbox,
+				!(le16_to_cpu(mailbox->w0) & QM_MB_BUSY_MASK),
+				POLL_PERIOD, POLL_TIMEOUT,
+				true, qm);
+	if (ret) {
+		dev_err(dev, "QM mailbox operation timeout!\n");
+		return ret;
 	}
 
-	val = readl(qm->io_base + QM_MB_CMD_SEND_BASE);
-	if (val & QM_MB_STATUS_MASK) {
-		dev_err(&qm->pdev->dev, "QM mailbox operation failed!\n");
-		ret = -EIO;
-		goto mb_busy;
+	if (le16_to_cpu(mailbox->w0) & QM_MB_STATUS_MASK) {
+		dev_err(dev, "QM mailbox operation failed!\n");
+		return -EIO;
 	}
 
 	return 0;
+}
+
+static int qm_mb_nolock(struct hisi_qm *qm, struct qm_mailbox *mailbox)
+{
+	int ret;
+
+	ret = hisi_qm_wait_mb_ready(qm);
+	if (ret)
+		goto mb_err_cnt_increase;
+
+	qm_mb_write(qm, mailbox);
+
+	ret = qm_wait_mb_finish(qm, mailbox);
+	if (ret)
+		goto mb_err_cnt_increase;
+
+	return 0;
 
-mb_busy:
+mb_err_cnt_increase:
 	atomic64_inc(&qm->debug.dfx.mb_err_cnt);
 	return ret;
 }
@@ -663,6 +704,25 @@ int hisi_qm_mb(struct hisi_qm *qm, u8 cmd, dma_addr_t dma_addr, u16 queue,
 }
 EXPORT_SYMBOL_GPL(hisi_qm_mb);
 
+int hisi_qm_mb_read(struct hisi_qm *qm, u64 *base, u8 cmd, u16 queue)
+{
+	struct qm_mailbox mailbox;
+	int ret;
+
+	qm_mb_pre_init(&mailbox, cmd, 0, queue, 1);
+	mutex_lock(&qm->mailbox_lock);
+	ret = qm_mb_nolock(qm, &mailbox);
+	mutex_unlock(&qm->mailbox_lock);
+	if (ret)
+		return ret;
+
+	*base = le32_to_cpu(mailbox.base_l) |
+		((u64)le32_to_cpu(mailbox.base_h) << 32);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(hisi_qm_mb_read);
+
 /* op 0: set xqc information to hardware, 1: get xqc information from hardware. */
 int qm_set_and_get_xqc(struct hisi_qm *qm, u8 cmd, void *xqc, u32 qp_id, bool op)
 {
@@ -1379,12 +1439,10 @@ static int qm_get_vft_v2(struct hisi_qm *qm, u32 *base, u32 *number)
 	u64 sqc_vft;
 	int ret;
 
-	ret = hisi_qm_mb(qm, QM_MB_CMD_SQC_VFT_V2, 0, 0, 1);
+	ret = hisi_qm_mb_read(qm, &sqc_vft, QM_MB_CMD_SQC_VFT_V2, 0);
 	if (ret)
 		return ret;
 
-	sqc_vft = readl(qm->io_base + QM_MB_CMD_DATA_ADDR_L) |
-		  ((u64)readl(qm->io_base + QM_MB_CMD_DATA_ADDR_H) << 32);
 	*base = QM_SQC_VFT_BASE_MASK_V2 & (sqc_vft >> QM_SQC_VFT_BASE_SHIFT_V2);
 	*number = (QM_SQC_VFT_NUM_MASK_V2 &
 		   (sqc_vft >> QM_SQC_VFT_NUM_SHIFT_V2)) + 1;
@@ -1524,25 +1582,6 @@ static enum acc_err_result qm_hw_error_handle_v2(struct hisi_qm *qm)
 	return ACC_ERR_RECOVERED;
 }
 
-static int qm_get_mb_cmd(struct hisi_qm *qm, u64 *msg, u16 fun_num)
-{
-	struct qm_mailbox mailbox;
-	int ret;
-
-	qm_mb_pre_init(&mailbox, QM_MB_CMD_DST, 0, fun_num, 0);
-	mutex_lock(&qm->mailbox_lock);
-	ret = qm_mb_nolock(qm, &mailbox);
-	if (ret)
-		goto err_unlock;
-
-	*msg = readl(qm->io_base + QM_MB_CMD_DATA_ADDR_L) |
-		  ((u64)readl(qm->io_base + QM_MB_CMD_DATA_ADDR_H) << 32);
-
-err_unlock:
-	mutex_unlock(&qm->mailbox_lock);
-	return ret;
-}
-
 static void qm_clear_cmd_interrupt(struct hisi_qm *qm, u64 vf_mask)
 {
 	u32 val;
@@ -1871,7 +1910,7 @@ static int qm_get_ifc_v3(struct hisi_qm *qm, enum qm_ifc_cmd *cmd, u32 *data, u3
 	u64 msg;
 	int ret;
 
-	ret = qm_get_mb_cmd(qm, &msg, fun_num);
+	ret = hisi_qm_mb_read(qm, &msg, QM_MB_CMD_DST, fun_num);
 	if (ret)
 		return ret;
 
diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index f517b9db8392..51a6dc2b97e9 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -571,6 +571,7 @@ void hisi_qm_reset_done(struct pci_dev *pdev);
 int hisi_qm_wait_mb_ready(struct hisi_qm *qm);
 int hisi_qm_mb(struct hisi_qm *qm, u8 cmd, dma_addr_t dma_addr, u16 queue,
 	       bool op);
+int hisi_qm_mb_read(struct hisi_qm *qm, u64 *base, u8 cmd, u16 queue);
 
 struct hisi_acc_sgl_pool;
 struct hisi_acc_hw_sgl *hisi_acc_sg_buf_map_to_hw_sgl(struct device *dev,
-- 
2.33.0

