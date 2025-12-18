Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA1E313532;
	Thu, 18 Dec 2025 13:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766065502; cv=none; b=BqPg3YjNNmRiXj9XKjxNXiSzPEkZ9frb7XYszOSKFCWrWKViLMAYlDjSaLCpsprixTx5p3F3qUhSObqHv+f//NUD6ktulply8EZvuLj6RL2oZKHd2St/nvXaNTjMSjvsKW21e2PC1s5G/I17r9OMHcaUEsWMP3T48SAKSUMzQQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766065502; c=relaxed/simple;
	bh=V18kuphHSHzn2zX8MMTtK/qAaqWWCRgnickhv3tFHOQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cFdZAQY4SR6PtwTbzdWNQUDwdh9DKPUiBDPK3Akgfxzrfhp/jPnRcG4EV8BVEzzzh5IFz6/R54lRHAPF/RsiBem0knHJ5BDskahOzQKbc8z8hXPkt++FzH7VXEGONws7YA7Y0+DsGEfwIqKWDgYxgw47H55nAbValcEsJpsoSwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=d/WhTcWP; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="d/WhTcWP"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=6W7GIh3IV/ccDQPpHaulZvlBfuw92uwjW8mqbE1A7JE=;
	b=d/WhTcWPM8Mwb/Sg10B+mRQAAtTC8VfHxueR2j3o5z2QxfXfZWlbrCDWId4merTt3AwhGtK8w
	NbrEjVqCYvlWa6Vyw86kz1/IPCSPYmjwTBGCAen+4vypJzqes+jhjn7+1uyBg2yHZN7LR9YBjj5
	4cfaAAO7Q5dZX18aZunojt0=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4dXBfV3z9vz1cyPb;
	Thu, 18 Dec 2025 21:41:54 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 6EAA914010D;
	Thu, 18 Dec 2025 21:44:57 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Dec 2025 21:44:57 +0800
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
Subject: [PATCH v4 08/11] crypto: hisilicon/qm - optimize device selection priority based on queue ref count and NUMA distance
Date: Thu, 18 Dec 2025 21:44:49 +0800
Message-ID: <20251218134452.1125469-9-huangchenghai2@huawei.com>
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

Add device sorting criteria to prioritize devices with fewer
references and closer NUMA distances. Devices that are fully
occupied will not be prioritized for use.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 3883b6176213..7b9ef40ee5c9 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3592,6 +3592,20 @@ void hisi_qm_free_qps(struct hisi_qp **qps, int qp_num)
 }
 EXPORT_SYMBOL_GPL(hisi_qm_free_qps);
 
+static void qm_insert_sorted(struct list_head *head, struct hisi_qm_resource *res)
+{
+	struct hisi_qm_resource *tmp;
+	struct list_head *n = head;
+
+	list_for_each_entry(tmp, head, list) {
+		if (res->distance < tmp->distance) {
+			n = &tmp->list;
+			break;
+		}
+	}
+	list_add_tail(&res->list, n);
+}
+
 static void free_list(struct list_head *head)
 {
 	struct hisi_qm_resource *res, *tmp;
@@ -3647,11 +3661,12 @@ static int qm_get_and_start_qp(struct hisi_qm *qm, int qp_num, struct hisi_qp **
 static int hisi_qm_sort_devices(int node, struct list_head *head,
 				struct hisi_qm_list *qm_list)
 {
-	struct hisi_qm_resource *res, *tmp;
+	struct hisi_qm_resource *res;
 	struct hisi_qm *qm;
-	struct list_head *n;
 	struct device *dev;
 	int dev_node;
+	LIST_HEAD(non_full_list);
+	LIST_HEAD(full_list);
 
 	list_for_each_entry(qm, &qm_list->list, list) {
 		dev = &qm->pdev->dev;
@@ -3666,16 +3681,16 @@ static int hisi_qm_sort_devices(int node, struct list_head *head,
 
 		res->qm = qm;
 		res->distance = node_distance(dev_node, node);
-		n = head;
-		list_for_each_entry(tmp, head, list) {
-			if (res->distance < tmp->distance) {
-				n = &tmp->list;
-				break;
-			}
-		}
-		list_add_tail(&res->list, n);
+
+		if (qm->qp_in_used == qm->qp_num)
+			qm_insert_sorted(&full_list, res);
+		else
+			qm_insert_sorted(&non_full_list, res);
 	}
 
+	list_splice_tail(&non_full_list, head);
+	list_splice_tail(&full_list, head);
+
 	return 0;
 }
 
-- 
2.33.0

