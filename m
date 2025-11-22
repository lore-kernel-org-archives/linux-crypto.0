Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006122EAB6F;
	Sat, 22 Nov 2025 07:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763797772; cv=none; b=ZzSq2Ax/NM/MkrZ9fdrY0J/GXkZsyOgaBhxGQEXW7dEDhb0WytIE6k4RM+ifVg3LfGJIdrjEmt0hmJLWS5OQzLYpnU3R4GbjKMxO1Xm0OZ5F+bKgUz+XMjv3VwiPIGkGsJl1l28oDo3tt+fBGd1bOrIJdEi320wdgw9oil7jxd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763797772; c=relaxed/simple;
	bh=ApDV33S+/zg89XOdXLh8aO65cUqiOOstQAFhRfXjd9M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bGqG/p2BQfajBoj8w6fRTTVlkedsI5nYsZ0oUpdij0NYFw1aSeGfcw9IGvcF9mbzORROw96dAstjV6aAE9WyP57vpsO8C56OmRwyGvK3265I9ggw6kNcY+ZfYmCMbRN/rK7Td7d7ndohnRnI1lFPeIt9eVkeD1GnbSAhs9bm3vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=l0/JZt5B; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="l0/JZt5B"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=lJvBbjVBXZcQn74sG6LQqdM85jl/ycBukkm6sqBngi0=;
	b=l0/JZt5BG1u47YtQFXjKl/xv74vRKMlpTNqg7UOPZDcZpPyk5L87jP4a2H6B5+uXc8vIMtHQs
	+p09wVZXsgPoD+GEis/PX6qETngN/iIyYMaPAIkCtnpg33npDwV27uGq2lXPB338HO5coxXga6/
	IIsJnjocz/WYlqEA0jLury8=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dD4234rvcznTwN;
	Sat, 22 Nov 2025 15:47:55 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 915F7140296;
	Sat, 22 Nov 2025 15:49:21 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 22 Nov 2025 15:49:21 +0800
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
Subject: [PATCH v3 08/11] crypto: hisilicon/qm - optimize device selection priority based on queue ref count and NUMA distance
Date: Sat, 22 Nov 2025 15:49:13 +0800
Message-ID: <20251122074916.2793717-9-huangchenghai2@huawei.com>
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

Add device sorting criteria to prioritize devices with fewer
references and closer NUMA distances. Devices that are fully
occupied will not be prioritized for use.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Weili Qian <qianweili@huawei.com>
---
 drivers/crypto/hisilicon/qm.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 6ff189941300..e4f360172477 100644
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
@@ -3652,11 +3666,12 @@ static int qm_get_and_start_qp(struct hisi_qm *qm, int qp_num, struct hisi_qp **
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
@@ -3671,16 +3686,16 @@ static int hisi_qm_sort_devices(int node, struct list_head *head,
 
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

