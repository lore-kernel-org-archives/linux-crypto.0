Return-Path: <SRS0=WdwO=YZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FA4ACA9ECF
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Nov 2019 12:25:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51E8821835
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Nov 2019 12:25:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbfKAMZY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Nov 2019 08:25:24 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5685 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726229AbfKAMZY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Nov 2019 08:25:24 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 9BC88EFD4F62366D4492;
        Fri,  1 Nov 2019 20:25:15 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Fri, 1 Nov 2019 20:25:07 +0800
From:   Zhou Wang <wangzhou1@hisilicon.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, Zhou Wang <wangzhou1@hisilicon.com>
Subject: [PATCH] crypto: hisilicon - replace #ifdef with IS_ENABLED for CONFIG_NUMA
Date:   Fri, 1 Nov 2019 20:21:49 +0800
Message-ID: <1572610909-91857-1-git-send-email-wangzhou1@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace #ifdef CONFIG_NUMA with IS_ENABLED(CONFIG_NUMA) to fix kbuild error.

Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
Reported-by: kbuild test robot <lkp@intel.com>
---
 drivers/crypto/hisilicon/zip/zip_main.c | 51 ++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 255b63c..0605457 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -104,9 +104,8 @@ static void free_list(struct list_head *head)
 
 struct hisi_zip *find_zip_device(int node)
 {
-	struct hisi_zip *ret = NULL;
-#ifdef CONFIG_NUMA
 	struct hisi_zip_resource *res, *tmp;
+	struct hisi_zip *ret = NULL;
 	struct hisi_zip *hisi_zip;
 	struct list_head *n;
 	struct device *dev;
@@ -114,38 +113,38 @@ struct hisi_zip *find_zip_device(int node)
 
 	mutex_lock(&hisi_zip_list_lock);
 
-	list_for_each_entry(hisi_zip, &hisi_zip_list, list) {
-		res = kzalloc(sizeof(*res), GFP_KERNEL);
-		if (!res)
-			goto err;
-
-		dev = &hisi_zip->qm.pdev->dev;
-		res->hzip = hisi_zip;
-		res->distance = node_distance(dev->numa_node, node);
+	if (IS_ENABLED(CONFIG_NUMA)) {
+		list_for_each_entry(hisi_zip, &hisi_zip_list, list) {
+			res = kzalloc(sizeof(*res), GFP_KERNEL);
+			if (!res)
+				goto err;
+
+			dev = &hisi_zip->qm.pdev->dev;
+			res->hzip = hisi_zip;
+			res->distance = node_distance(dev_to_node(dev), node);
+
+			n = &head;
+			list_for_each_entry(tmp, &head, list) {
+				if (res->distance < tmp->distance) {
+					n = &tmp->list;
+					break;
+				}
+			}
+			list_add_tail(&res->list, n);
+		}
 
-		n = &head;
 		list_for_each_entry(tmp, &head, list) {
-			if (res->distance < tmp->distance) {
-				n = &tmp->list;
+			if (hisi_qm_get_free_qp_num(&tmp->hzip->qm)) {
+				ret = tmp->hzip;
 				break;
 			}
 		}
-		list_add_tail(&res->list, n);
-	}
 
-	list_for_each_entry(tmp, &head, list) {
-		if (hisi_qm_get_free_qp_num(&tmp->hzip->qm)) {
-			ret = tmp->hzip;
-			break;
-		}
+		free_list(&head);
+	} else {
+		ret = list_first_entry(&hisi_zip_list, struct hisi_zip, list);
 	}
 
-	free_list(&head);
-#else
-	mutex_lock(&hisi_zip_list_lock);
-
-	ret = list_first_entry(&hisi_zip_list, struct hisi_zip, list);
-#endif
 	mutex_unlock(&hisi_zip_list_lock);
 
 	return ret;
-- 
2.8.1

