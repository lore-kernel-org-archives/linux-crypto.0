Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C852D2EA724;
	Sat, 25 Oct 2025 10:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761387185; cv=none; b=AopjV6VsLP6KwGLm47CvWYRaUcn3xQZVCWNAdnr363d+wNXPaUWgnXUAm4S6WHg0o9OwoCCnDOuORGGgyypiaOvzcdzKrwOvV0sIV60+dxdfrT7qOPFGKgeen/HkbG2PKLIBhU+UemPg/jV/lm1KCOEum2Jvgx5nrg7JCEIYvX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761387185; c=relaxed/simple;
	bh=kcA8YEqHImNn0MbJy1QtUH1Ue8bic05+uzxAxwZVvXg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CFh7h8WMlkIQPPF/1cdzIs0mBRvu8HTr8bLS4CXSJ83vQUJP/7BuMqHikUws3H7iDRkualo6YSiXwItkXzX0v6c/9xY5yumjGobkoVRFMY+iFbtPpQ71GbxciD/YG1asOXj3MgwqNXw7tmQJYYasmrpIJPbp6BLX45ZS2J4dhD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=r1v2Bt55; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="r1v2Bt55"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=mdASmNNiofJ4T+tv6nJdiPRoAlyXw68u2bmmWiaXYAg=;
	b=r1v2Bt55ize23V/6QAu29ofj/cL8CH7lvnqJs2ElJ0aZxtZ+kkktTjcZS/luxJq7HGneyEZOB
	U6N0+k5dwxc/NWDG19f4O38bwQ4M/PRu5jMjQWqr8QqsVOUi0/x5voz8WgwydXpEie6y7GC2cEz
	dEtblcD6xZqJYF3Lso+SpX8=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4ctwYt1B8zzmV8F;
	Sat, 25 Oct 2025 18:12:34 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 8BC4F140276;
	Sat, 25 Oct 2025 18:13:00 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 25 Oct 2025 18:13:00 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 25 Oct 2025 18:12:59 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<wangzhou1@hisilicon.com>, <fanghao11@huawei.com>, <nieweiqiang@huawei.com>
Subject: [PATCH 1/4] crypto: hisilicon/qm - add the save operation of eqe and aeqe
Date: Sat, 25 Oct 2025 18:12:55 +0800
Message-ID: <20251025101258.2793179-2-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20251025101258.2793179-1-huangchenghai2@huawei.com>
References: <20251025101258.2793179-1-huangchenghai2@huawei.com>
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

From: nieweiqiang <nieweiqiang@huawei.com>

The eqe and aeqe are device updated values that include the
valid bit and queue number. In the current process, there is no
memory barrier added, so it cannot be guaranteed that the valid
bit is read before other processes are executed. Since eqe and aeqe
are only 4 bytes and the device writes them to memory in a single
operation, saving the values of eqe and aeqe ensures that the valid
bit and queue number read by the CPU were written by the device
simultaneously.

Signed-off-by: nieweiqiang <nieweiqiang@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 30e44cfb57ee..8274da8b37ca 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -64,10 +64,10 @@
 #define QM_EQE_AEQE_SIZE		(2UL << 12)
 #define QM_EQC_PHASE_SHIFT		16
 
-#define QM_EQE_PHASE(eqe)		((le32_to_cpu((eqe)->dw0) >> 16) & 0x1)
+#define QM_EQE_PHASE(dw0)		(((dw0) >> 16) & 0x1)
 #define QM_EQE_CQN_MASK			GENMASK(15, 0)
 
-#define QM_AEQE_PHASE(aeqe)		((le32_to_cpu((aeqe)->dw0) >> 16) & 0x1)
+#define QM_AEQE_PHASE(dw0)		(((dw0) >> 16) & 0x1)
 #define QM_AEQE_TYPE_SHIFT		17
 #define QM_AEQE_TYPE_MASK		0xf
 #define QM_AEQE_CQN_MASK		GENMASK(15, 0)
@@ -976,23 +976,23 @@ static void qm_get_complete_eqe_num(struct hisi_qm *qm)
 {
 	struct qm_eqe *eqe = qm->eqe + qm->status.eq_head;
 	struct hisi_qm_poll_data *poll_data = NULL;
+	u32 dw0 = le32_to_cpu(eqe->dw0);
 	u16 eq_depth = qm->eq_depth;
 	u16 cqn, eqe_num = 0;
 
-	if (QM_EQE_PHASE(eqe) != qm->status.eqc_phase) {
+	if (QM_EQE_PHASE(dw0) != qm->status.eqc_phase) {
 		atomic64_inc(&qm->debug.dfx.err_irq_cnt);
 		qm_db(qm, 0, QM_DOORBELL_CMD_EQ, qm->status.eq_head, 0);
 		return;
 	}
 
-	cqn = le32_to_cpu(eqe->dw0) & QM_EQE_CQN_MASK;
+	cqn = dw0 & QM_EQE_CQN_MASK;
 	if (unlikely(cqn >= qm->qp_num))
 		return;
 	poll_data = &qm->poll_data[cqn];
 
-	while (QM_EQE_PHASE(eqe) == qm->status.eqc_phase) {
-		cqn = le32_to_cpu(eqe->dw0) & QM_EQE_CQN_MASK;
-		poll_data->qp_finish_id[eqe_num] = cqn;
+	while (QM_EQE_PHASE(dw0) != qm->status.eqc_phase) {
+		poll_data->qp_finish_id[eqe_num] = dw0 & QM_EQE_CQN_MASK;
 		eqe_num++;
 
 		if (qm->status.eq_head == eq_depth - 1) {
@@ -1006,6 +1006,8 @@ static void qm_get_complete_eqe_num(struct hisi_qm *qm)
 
 		if (eqe_num == (eq_depth >> 1) - 1)
 			break;
+
+		dw0 = le32_to_cpu(eqe->dw0);
 	}
 
 	poll_data->eqe_num = eqe_num;
@@ -1098,15 +1100,15 @@ static irqreturn_t qm_aeq_thread(int irq, void *data)
 {
 	struct hisi_qm *qm = data;
 	struct qm_aeqe *aeqe = qm->aeqe + qm->status.aeq_head;
+	u32 dw0 = le32_to_cpu(aeqe->dw0);
 	u16 aeq_depth = qm->aeq_depth;
 	u32 type, qp_id;
 
 	atomic64_inc(&qm->debug.dfx.aeq_irq_cnt);
 
-	while (QM_AEQE_PHASE(aeqe) == qm->status.aeqc_phase) {
-		type = (le32_to_cpu(aeqe->dw0) >> QM_AEQE_TYPE_SHIFT) &
-			QM_AEQE_TYPE_MASK;
-		qp_id = le32_to_cpu(aeqe->dw0) & QM_AEQE_CQN_MASK;
+	while (QM_AEQE_PHASE(dw0) == qm->status.aeqc_phase) {
+		type = (dw0 >> QM_AEQE_TYPE_SHIFT) & QM_AEQE_TYPE_MASK;
+		qp_id = dw0 & QM_AEQE_CQN_MASK;
 
 		switch (type) {
 		case QM_EQ_OVERFLOW:
@@ -1134,6 +1136,7 @@ static irqreturn_t qm_aeq_thread(int irq, void *data)
 			aeqe++;
 			qm->status.aeq_head++;
 		}
+		dw0 = le32_to_cpu(aeqe->dw0);
 	}
 
 	qm_db(qm, 0, QM_DOORBELL_CMD_AEQ, qm->status.aeq_head, 0);
-- 
2.33.0

