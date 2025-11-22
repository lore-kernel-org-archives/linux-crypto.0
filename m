Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6701B85F8;
	Sat, 22 Nov 2025 07:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763797766; cv=none; b=IWH/Ep2jtdgd0sNpH9jVunghwgPlkVZopeQUeFAwidWbyHalN9bj9xyZDBPiRzk1w9PAjj1fQUtRNYjBqXJVLEfLLDspbw7QSxmL/nZ60FUwI57NimyEA9k2+Qs4Jxg6tvC3UttdR+b0dZJIz6abj43oH1LWA3YMTlTRip9g9xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763797766; c=relaxed/simple;
	bh=6176ZIZ5IiSfussiKGbTQdM3mXFCSDfrmxc/eiNztH0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=laKgJtU92Oei3wUSneLughNdEd/APMRqjj2OQqGr4jqnaO1ZGeQB590RbtOBD9ETJ39Atd3P44PzwB/rOj+/tOENglq5hdnXkeq2S1PE4GI5A+YHjyN7BWHRhkLn3R+K38/yVR6o+9s/c9QrxTH36MIA6tAHx26JReK4TIbmUmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=UNmmFbWn; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="UNmmFbWn"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Vm6uXFXxydiiwKIsx7W8VRO5SKwRPFOKZPatyoA1SlY=;
	b=UNmmFbWnCsAvG2KynOxi/4GuqtIO1h1V82DJv6RsybcPSnX23Q+VQmJQ74sYjKDCbgervB/5X
	QUakOVguUMd4j54qZgMT57AubIZ+tGb5XKY8Y8NeuxnmxnzClbmzCf1DdnDQQuEvwe/BmHbDYg+
	mUOTTtNQjGOqILeAI4uUGUk=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dD41F32rNzcZyP;
	Sat, 22 Nov 2025 15:47:13 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 143521401F2;
	Sat, 22 Nov 2025 15:49:21 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 22 Nov 2025 15:49:20 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 22 Nov 2025 15:49:20 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>, <lizhi206@huawei.com>,
	<taoqi10@huawei.com>
Subject: [PATCH v3 07/11] crypto: hisilicon/qm - add reference counting to queues for tfm kernel reuse
Date: Sat, 22 Nov 2025 15:49:12 +0800
Message-ID: <20251122074916.2793717-8-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20251122074916.2793717-1-huangchenghai2@huawei.com>
References: <20251122074916.2793717-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq200001.china.huawei.com (7.202.195.16)

Add reference counting to queues. When all queues are occupied, tfm
will reuse queues with the same algorithm type that have already
been allocated in the kernel. The corresponding queue will be
released when the reference count reaches 1.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 81 +++++++++++++++++++++++++++--------
 include/linux/hisi_acc_qm.h   |  1 +
 2 files changed, 65 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 28256f64aa3c..6ff189941300 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -2002,7 +2002,38 @@ static void hisi_qm_unset_hw_reset(struct hisi_qp *qp)
 	*addr = 0;
 }
 
-static struct hisi_qp *qm_create_qp_nolock(struct hisi_qm *qm, u8 alg_type)
+static struct hisi_qp *find_shareable_qp(struct hisi_qm *qm, u8 alg_type, bool is_in_kernel)
+{
+	struct device *dev = &qm->pdev->dev;
+	struct hisi_qp *share_qp = NULL;
+	struct hisi_qp *qp;
+	u32 ref_count = ~0;
+	int i;
+
+	if (!is_in_kernel)
+		goto queues_busy;
+
+	for (i = 0; i < qm->qp_num; i++) {
+		qp = &qm->qp_array[i];
+		if (qp->is_in_kernel && qp->alg_type == alg_type && qp->ref_count < ref_count) {
+			ref_count = qp->ref_count;
+			share_qp = qp;
+		}
+	}
+
+	if (share_qp) {
+		share_qp->ref_count++;
+		return share_qp;
+	}
+
+queues_busy:
+	dev_info_ratelimited(dev, "All %u queues of QM are busy and no shareable queue\n",
+			     qm->qp_num);
+	atomic64_inc(&qm->debug.dfx.create_qp_err_cnt);
+	return ERR_PTR(-EBUSY);
+}
+
+static struct hisi_qp *qm_create_qp_nolock(struct hisi_qm *qm, u8 alg_type, bool is_in_kernel)
 {
 	struct device *dev = &qm->pdev->dev;
 	struct hisi_qp *qp;
@@ -2013,17 +2044,14 @@ static struct hisi_qp *qm_create_qp_nolock(struct hisi_qm *qm, u8 alg_type)
 		return ERR_PTR(-EPERM);
 	}
 
-	if (qm->qp_in_used == qm->qp_num) {
-		dev_info_ratelimited(dev, "All %u queues of QM are busy!\n",
-				     qm->qp_num);
-		atomic64_inc(&qm->debug.dfx.create_qp_err_cnt);
-		return ERR_PTR(-EBUSY);
-	}
+	/* Try to find a shareable queue when all queues are busy */
+	if (qm->qp_in_used == qm->qp_num)
+		return find_shareable_qp(qm, alg_type, is_in_kernel);
 
 	qp_id = idr_alloc_cyclic(&qm->qp_idr, NULL, 0, qm->qp_num, GFP_ATOMIC);
 	if (qp_id < 0) {
-		dev_info_ratelimited(dev, "All %u queues of QM are busy!\n",
-				    qm->qp_num);
+		dev_info_ratelimited(dev, "All %u queues of QM are busy, in_used = %u!\n",
+				    qm->qp_num, qm->qp_in_used);
 		atomic64_inc(&qm->debug.dfx.create_qp_err_cnt);
 		return ERR_PTR(-EBUSY);
 	}
@@ -2034,10 +2062,10 @@ static struct hisi_qp *qm_create_qp_nolock(struct hisi_qm *qm, u8 alg_type)
 
 	qp->event_cb = NULL;
 	qp->req_cb = NULL;
-	qp->qp_id = qp_id;
 	qp->alg_type = alg_type;
-	qp->is_in_kernel = true;
+	qp->is_in_kernel = is_in_kernel;
 	qm->qp_in_used++;
+	qp->ref_count = 1;
 
 	return qp;
 }
@@ -2059,7 +2087,7 @@ static struct hisi_qp *hisi_qm_create_qp(struct hisi_qm *qm, u8 alg_type)
 		return ERR_PTR(ret);
 
 	down_write(&qm->qps_lock);
-	qp = qm_create_qp_nolock(qm, alg_type);
+	qp = qm_create_qp_nolock(qm, alg_type, false);
 	up_write(&qm->qps_lock);
 
 	if (IS_ERR(qp))
@@ -2458,7 +2486,6 @@ static int hisi_qm_uacce_get_queue(struct uacce_device *uacce,
 	qp->uacce_q = q;
 	qp->event_cb = qm_qp_event_notifier;
 	qp->pasid = arg;
-	qp->is_in_kernel = false;
 
 	return 0;
 }
@@ -3532,6 +3559,9 @@ static void qm_release_qp_nolock(struct hisi_qp *qp)
 {
 	struct hisi_qm *qm = qp->qm;
 
+	if (--qp->ref_count)
+		return;
+
 	qm->qp_in_used--;
 	idr_remove(&qm->qp_idr, qp->qp_id);
 }
@@ -3551,7 +3581,10 @@ void hisi_qm_free_qps(struct hisi_qp **qps, int qp_num)
 	down_write(&qps[0]->qm->qps_lock);
 
 	for (i = qp_num - 1; i >= 0; i--) {
-		qm_stop_qp_nolock(qps[i]);
+		if (qps[i]->ref_count == 1) {
+			qm_stop_qp_nolock(qps[i]);
+			qm_pm_put_sync(qps[i]->qm);
+		}
 		qm_release_qp_nolock(qps[i]);
 	}
 
@@ -3576,16 +3609,27 @@ static int qm_get_and_start_qp(struct hisi_qm *qm, int qp_num, struct hisi_qp **
 
 	down_write(&qm->qps_lock);
 	for (i = 0; i < qp_num; i++) {
-		qps[i] = qm_create_qp_nolock(qm, alg_type[i]);
+		qps[i] = qm_create_qp_nolock(qm, alg_type[i], true);
 		if (IS_ERR(qps[i])) {
 			goto free_qp;
 		}
 	}
 
 	for (j = 0; j < qp_num; j++) {
+		if (qps[j]->ref_count != 1)
+			continue;
+
+		ret = qm_pm_get_sync(qm);
+		if (ret) {
+			ret = -EINVAL;
+			goto stop_qp;
+		}
+
 		ret = qm_start_qp_nolock(qps[j], 0);
-		if (ret)
+		if (ret) {
+			qm_pm_put_sync(qm);
 			goto stop_qp;
+		}
 	}
 	up_write(&qm->qps_lock);
 
@@ -3593,7 +3637,10 @@ static int qm_get_and_start_qp(struct hisi_qm *qm, int qp_num, struct hisi_qp **
 
 stop_qp:
 	for (j--; j >= 0; j--)
-		qm_stop_qp_nolock(qps[j]);
+		if (qps[j]->ref_count == 1) {
+			qm_stop_qp_nolock(qps[j]);
+			qm_pm_put_sync(qm);
+		}
 free_qp:
 	for (i--; i >= 0; i--)
 		qm_release_qp_nolock(qps[i]);
diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index 4cf418a41fe4..26032d98e9bd 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -472,6 +472,7 @@ struct hisi_qp {
 	u16 pasid;
 	struct uacce_queue *uacce_q;
 
+	u32 ref_count;
 	spinlock_t qp_lock;
 	struct instance_backlog backlog;
 	const void **msg;
-- 
2.33.0

