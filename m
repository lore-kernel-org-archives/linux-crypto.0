Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D73337BB5;
	Thu, 18 Dec 2025 13:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766065510; cv=none; b=uhquxPQcO2G4nSQEC6wtFiNk8y/Ni3jhqEPwwzQuQJAfsoy9R+NK1ffjXBG7R2b1WQ6Rf/8ncOIcSrlv9B7zJrbPlaT5x0f4vZ4TCIdBf1SlgA2THIvd4eKbwsTbBcXRdnNeVxbe9P2Zd0uBgXWUYib/cPbwoTFm9QZJgP4Lkhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766065510; c=relaxed/simple;
	bh=k3PYUYldUkanueYrxhEs6PniLYm1z8jMAYgNS2K3c0s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OAO6wirfiCDlOCMwJxJo47x0uURPxbdlY6UqnhoibOjlSUJCBU40qnheFs/4BRtO41iqtDRpioPqY59fAiGlsSd52nvV1rGeAiR94/UW2Dms1tH3O4LyPibwUeKOYexxEyKNVnluawuuVFgIyduADnkn6vhyJOZArGJk56IMbDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=0bwocHr9; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="0bwocHr9"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=EVgLOcV4IdojDzzGUqNKzPkGJA5NdIs2RtJoshkEBuc=;
	b=0bwocHr9qLh0iZfJcUdXGA4rMo93F5EP7hILnwje6kcR/F0saF+2KEzCC/1ST6e/dPNOVuIXh
	aTqThLWspby+MeiS3e+pEPGv35V7x3ZFKal573HtrR0vJhxzGv0Qh2KdacyUgKWos7/mG8MEdGT
	2B/g2e8IORshKUDRBVJ9wdA=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4dXBfS6zpGzmV69;
	Thu, 18 Dec 2025 21:41:52 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 042711400F4;
	Thu, 18 Dec 2025 21:44:57 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Dec 2025 21:44:56 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Dec 2025 21:44:56 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>, <lizhi206@huawei.com>,
	<taoqi10@huawei.com>
Subject: [PATCH v4 07/11] crypto: hisilicon/qm - add reference counting to queues for tfm kernel reuse
Date: Thu, 18 Dec 2025 21:44:48 +0800
Message-ID: <20251218134452.1125469-8-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20251218134452.1125469-1-huangchenghai2@huawei.com>
References: <20251218134452.1125469-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq200001.china.huawei.com (7.202.195.16)

Add reference counting to queues. When all queues are occupied, tfm
will reuse queues with the same algorithm type that have already
been allocated in the kernel. The corresponding queue will be
released when the reference count reaches 1.

Reviewed-by: Longfang Liu <liulongfang@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 65 +++++++++++++++++++++++++++--------
 include/linux/hisi_acc_qm.h   |  1 +
 2 files changed, 52 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 4cdb443e2889..3883b6176213 100644
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
@@ -2013,12 +2044,9 @@ static struct hisi_qp *qm_create_qp_nolock(struct hisi_qm *qm, u8 alg_type)
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
@@ -3551,7 +3581,9 @@ void hisi_qm_free_qps(struct hisi_qp **qps, int qp_num)
 	down_write(&qps[0]->qm->qps_lock);
 
 	for (i = qp_num - 1; i >= 0; i--) {
-		qm_stop_qp_nolock(qps[i]);
+		if (qps[i]->ref_count == 1)
+			qm_stop_qp_nolock(qps[i]);
+
 		qm_release_qp_nolock(qps[i]);
 	}
 
@@ -3580,12 +3612,15 @@ static int qm_get_and_start_qp(struct hisi_qm *qm, int qp_num, struct hisi_qp **
 
 	down_write(&qm->qps_lock);
 	for (i = 0; i < qp_num; i++) {
-		qps[i] = qm_create_qp_nolock(qm, alg_type[i]);
+		qps[i] = qm_create_qp_nolock(qm, alg_type[i], true);
 		if (IS_ERR(qps[i])) {
 			ret = -ENODEV;
 			goto stop_and_free;
 		}
 
+		if (qps[i]->ref_count != 1)
+			continue;
+
 		ret = qm_start_qp_nolock(qps[i], 0);
 		if (ret) {
 			qm_release_qp_nolock(qps[i]);
@@ -3598,7 +3633,9 @@ static int qm_get_and_start_qp(struct hisi_qm *qm, int qp_num, struct hisi_qp **
 
 stop_and_free:
 	for (i--; i >= 0; i--) {
-		qm_stop_qp_nolock(qps[i]);
+		if (qps[i]->ref_count == 1)
+			qm_stop_qp_nolock(qps[i]);
+
 		qm_release_qp_nolock(qps[i]);
 	}
 	up_write(&qm->qps_lock);
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

