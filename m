Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2A1471D1C;
	Thu, 24 Sep 2026 11:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790249910; cv=none; b=V+UD9PUZ4Iv2kWuBhUe7wzwU7fQ3uC0YyhxGjmnIhN93gPVrxwEh+l2sohl31HU1EZrUyEv3wGKpSCOfW1oz/s40LW3NPYkx6Bq2pvHLHSEqao9TJ3paNBF6QPAsIoS+ecvmrwdTzEsIIwej2bzewSnXQ6y964ym++rlcfMzYl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790249910; c=relaxed/simple;
	bh=Lzj7v51aTV8EOjbcdsPm2DCbUy2pi3Nb3LH9w4kxtB4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C7pmAaGTkp2AnMVJRPfO0/ORXteAQ4xJC7IJXop7hvNNuU5MfN4gezqqtgqU5qYMUN31xYccY7mMDTi/NPZWt9/nSHu+OqtPx1WBKvriXC3C5EsZoIAREq03BCRDnuzXjT98VRPeEk/J9F1Sfeullw8qF2jPS4tpzKTk8NKk76M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=TI1sDNaA; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="TI1sDNaA"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=mt1j1v4g7N7JQ7mxqlec7bfq19NLiPNHx8QngeNJt94=;
	b=TI1sDNaA8C61Oz8515bHOu6/M1d19RyowFZEh+2kgygpzaMkykoIIn10k2OUG4+OFe9P3OD7m
	QWSa7WceWLYPQBNl+nL0plZEYZgbUeDj1wFJ7hJyKHjzGW++TGn5AxflIylXduMF9mkEhJjsx64
	WuWoJk9/h3+iBVfYth4LEvk=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hrBPN2HqRzcb3G;
	Thu, 24 Sep 2026 19:26:48 +0800 (CST)
Received: from kwepemf200011.china.huawei.com (unknown [7.202.181.237])
	by mail.maildlp.com (Postfix) with ESMTPS id 9646640538;
	Thu, 24 Sep 2026 19:38:14 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemf200011.china.huawei.com (7.202.181.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 19:38:14 +0800
From: Weili Qian <qianweili@huawei.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>
Subject: [PATCH 3/4] crypto: hisilicon/qm - check queue depth read from hardware
Date: Thu, 24 Sep 2026 19:38:11 +0800
Message-ID: <20260924113812.1110302-4-qianweili@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924113812.1110302-1-qianweili@huawei.com>
References: <20260924113812.1110302-1-qianweili@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemf200011.china.huawei.com (7.202.181.237)

When hardware is abnormal, queue depth values read from registers may
be invalid, causing array out of bounds or division by zero.

Add a QM_XQC_MIN_DEPTH check in qm_get_xqc_depth() so all callers are
covered. The check only applies to QM_HW_V3 and later, where depth is
read from registers.

Fixes: 129a9f340172 ("crypto: hisilicon/qm - get qp num and depth from hardware registers")
Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index bde44401ddb6..f310edfc16cf 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -77,6 +77,7 @@
 #define QM_CQ_OVERFLOW			0
 #define QM_EQ_OVERFLOW			1
 #define QM_CQE_ERROR			2
+#define QM_XQC_MIN_DEPTH		1024
 
 #define QM_XQ_DEPTH_SHIFT		16
 #define QM_XQ_DEPTH_MASK		GENMASK(15, 0)
@@ -963,14 +964,24 @@ u32 hisi_qm_get_cap_value(struct hisi_qm *qm,
 }
 EXPORT_SYMBOL_GPL(hisi_qm_get_cap_value);
 
-static void qm_get_xqc_depth(struct hisi_qm *qm, u16 *low_bits,
-			     u16 *high_bits, enum qm_basic_type type)
+static int qm_get_xqc_depth(struct hisi_qm *qm, u16 *low_bits,
+			    u16 *high_bits, enum qm_basic_type type)
 {
 	u32 depth;
 
 	depth = hisi_qm_get_hw_info(qm, qm_basic_info, type, qm->cap_ver);
 	*low_bits = depth & QM_XQ_DEPTH_MASK;
 	*high_bits = (depth >> QM_XQ_DEPTH_SHIFT) & QM_XQ_DEPTH_MASK;
+
+	if (qm->ver >= QM_HW_V3 &&
+	    (*low_bits < QM_XQC_MIN_DEPTH || *high_bits < QM_XQC_MIN_DEPTH)) {
+		dev_err(&qm->pdev->dev,
+			"invalid depth type %d, low %u, high %u, min %u\n",
+			type, *low_bits, *high_bits, QM_XQC_MIN_DEPTH);
+		return -EIO;
+	}
+
+	return 0;
 }
 
 int hisi_qm_set_algs(struct hisi_qm *qm, u64 alg_msk, const struct qm_dev_alg *dev_algs,
@@ -2940,6 +2951,7 @@ static int qm_alloc_uacce(struct hisi_qm *qm)
 	unsigned long mmio_page_nr;
 	unsigned long dus_page_nr;
 	u16 sq_depth, cq_depth;
+	int ret;
 	struct uacce_interface interface = {
 		.flags = UACCE_DEV_SVA,
 		.ops = &uacce_qm_ops,
@@ -2974,7 +2986,12 @@ static int qm_alloc_uacce(struct hisi_qm *qm)
 	else
 		mmio_page_nr = qm->db_interval / PAGE_SIZE;
 
-	qm_get_xqc_depth(qm, &sq_depth, &cq_depth, QM_QP_DEPTH_CAP);
+	ret = qm_get_xqc_depth(qm, &sq_depth, &cq_depth, QM_QP_DEPTH_CAP);
+	if (ret) {
+		uacce_remove(uacce);
+		qm->use_sva = false;
+		return ret;
+	}
 
 	/* Add one more page for device or qp status */
 	dus_page_nr = (PAGE_SIZE - 1 + qm->sqe_size * sq_depth +
@@ -6002,7 +6019,12 @@ static int hisi_qp_alloc_memory(struct hisi_qm *qm)
 		return -ENOMEM;
 	}
 
-	qm_get_xqc_depth(qm, &sq_depth, &cq_depth, QM_QP_DEPTH_CAP);
+	ret = qm_get_xqc_depth(qm, &sq_depth, &cq_depth, QM_QP_DEPTH_CAP);
+	if (ret) {
+		kfree(qm->poll_data);
+		kfree(qm->qp_array);
+		return ret;
+	}
 
 	/* one more page for device or qp statuses */
 	qp_dma_size = qm->sqe_size * sq_depth + sizeof(struct qm_cqe) * cq_depth;
@@ -6076,7 +6098,9 @@ static int hisi_qm_memory_init(struct hisi_qm *qm)
 } while (0)
 
 	idr_init(&qm->qp_idr);
-	qm_get_xqc_depth(qm, &qm->eq_depth, &qm->aeq_depth, QM_XEQ_DEPTH_CAP);
+	ret = qm_get_xqc_depth(qm, &qm->eq_depth, &qm->aeq_depth, QM_XEQ_DEPTH_CAP);
+	if (ret)
+		goto err_destroy_idr;
 	qm->qdma.size = QMC_ALIGN(sizeof(struct qm_eqe) * qm->eq_depth) +
 			QMC_ALIGN(sizeof(struct qm_aeqe) * qm->aeq_depth) +
 			QMC_ALIGN(sizeof(struct qm_sqc) * qm->qp_num) +
-- 
2.43.0

