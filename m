Return-Path: <SRS0=QWZk=Y5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA902C010A2
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 14:56:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0AF8217F5
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 14:56:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BfcBZ2ZL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388976AbfKEO4o (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Nov 2019 09:56:44 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:37470 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbfKEO4o (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Nov 2019 09:56:44 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA5EsrJb013317;
        Tue, 5 Nov 2019 14:56:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=U2XpltzPsohKEesiIoKecnv74molLoZ2j+lblcZhv1k=;
 b=BfcBZ2ZLB4g80O07ky8PtGzjc3Ycwu1rFDTxuigdVOlL9XMD/ckaCgyvqiYfjoLibrEu
 lGaUsb7X0a4xKYIn/3WIa2k02LUnQpsBW0n3rxtfXmzBwvz4uw8fC/v2fnjI5Rv8QpvJ
 J9R5HwOfuR1e9gN8MWP72QFPuLJnJYwZIRY48q2tbkAN/5JyKtQXxnFytlKQm0jCUV5s
 AJyuG5GRFK+KDKyG584x6LIanZcKNd+LdcZOShE6ZdKBMQNt3ON6K5SN75gwrtR37OQ+
 weMRtAZxYi55mMbrLp3CctexpYQlW4PS+Ac6/MxW3aFmzHRxPuOfIDUSYYy34skkTghh Bg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2w117ty0ch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 14:56:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA5EsTgO008488;
        Tue, 5 Nov 2019 14:56:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2w333vb7xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 14:56:12 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA5EuAFc028587;
        Tue, 5 Nov 2019 14:56:10 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Nov 2019 06:56:09 -0800
Date:   Tue, 5 Nov 2019 17:56:02 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Mao Wenan <maowenan@huawei.com>
Cc:     wangzhou1@hisilicon.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, tanshukun1@huawei.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH -next] crypto: hisilicon: move label err to #ifdef
 CONFIG_NUMA
Message-ID: <20191105145602.GH10409@kadam>
References: <20191105143340.32950-1-maowenan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105143340.32950-1-maowenan@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911050124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911050125
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The ifdefs in this function were pretty ugly before but this makes it
super extra ugly...  :/  There are bunch of ways to fix this nicely
but my favourite is this:

Feel free to give me a Suggested-by tag.

diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index 255b63cfbe1d..1b22f0ead56e 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -105,20 +105,27 @@ static void free_list(struct list_head *head)
 struct hisi_zip *find_zip_device(int node)
 {
 	struct hisi_zip *ret = NULL;
-#ifdef CONFIG_NUMA
 	struct hisi_zip_resource *res, *tmp;
 	struct hisi_zip *hisi_zip;
 	struct list_head *n;
 	struct device *dev;
 	LIST_HEAD(head);
 
+	if (!IS_ENABLED(CONFIG_NUMA)) {
+		mutex_lock(&hisi_zip_list_lock);
+		ret = list_first_entry(&hisi_zip_list, struct hisi_zip, list);
+		mutex_unlock(&hisi_zip_list_lock);
+		return ret;
+	}
+
 	mutex_lock(&hisi_zip_list_lock);
 
 	list_for_each_entry(hisi_zip, &hisi_zip_list, list) {
 		res = kzalloc(sizeof(*res), GFP_KERNEL);
-		if (!res)
-			goto err;
-
+		if (!res) {
+			ret = NULL;
+			goto done;
+		}
 		dev = &hisi_zip->qm.pdev->dev;
 		res->hzip = hisi_zip;
 		res->distance = node_distance(dev->numa_node, node);
@@ -140,20 +147,10 @@ struct hisi_zip *find_zip_device(int node)
 		}
 	}
 
+done:
 	free_list(&head);
-#else
-	mutex_lock(&hisi_zip_list_lock);
-
-	ret = list_first_entry(&hisi_zip_list, struct hisi_zip, list);
-#endif
 	mutex_unlock(&hisi_zip_list_lock);
-
 	return ret;
-
-err:
-	free_list(&head);
-	mutex_unlock(&hisi_zip_list_lock);
-	return NULL;
 }
 
 struct hisi_zip_hw_error {

