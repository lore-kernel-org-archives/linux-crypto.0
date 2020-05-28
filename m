Return-Path: <SRS0=ep2G=7K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84295C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 28 May 2020 12:39:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52357206F1
	for <linux-crypto@archiver.kernel.org>; Thu, 28 May 2020 12:39:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SztyNKVZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389792AbgE1Mja (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 May 2020 08:39:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51020 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389746AbgE1Mj3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 May 2020 08:39:29 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04SCbnF5188151;
        Thu, 28 May 2020 12:39:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=IIP/iRFuFJXn63SSiQWJJZ5VnKvJC0mGleXmKDbIZIo=;
 b=SztyNKVZhx7riaDGqRWBbBcLIrwKlv4g8RVPs9g4b7YC8d0L48Tp00q1hizFUuGHRc89
 jzZt+/9dTODJ3p5UIoUofTS4Ct6/IIy99OYSQP0IRzOsnDtnqsjtXTmiaFT58C3ePtf5
 Eh1XdZI2phQRxIBeHvJYlJTxyRgMGc1DDACFGrRtzmt1tukhPKTLcqleS8j4FPiI4KPy
 W5uFws+h1g8bkinIyf9PznGBTkWMZ9FM2OW4XFkR5m62csyMSvk5bR1rUe1UNY+NgfA5
 1VWxO96iG+p+oKcPowVW89IePaMEOm3VD6Q/jOETdBEU6b5vQeGLqRv3kwZHH0g9cKwS Og== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 318xbk4rwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 28 May 2020 12:39:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04SCHdZ7115474;
        Thu, 28 May 2020 12:37:11 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 317j5v696y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 May 2020 12:37:11 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04SCb9Iw014640;
        Thu, 28 May 2020 12:37:09 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 May 2020 05:37:08 -0700
Date:   Thu, 28 May 2020 15:37:03 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Zhou Wang <wangzhou1@hisilicon.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] crypto: hisilicon/qm - allow smaller reads in debugfs
Message-ID: <20200528123703.GA1219412@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9634 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005280086
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9634 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 cotscore=-2147483648
 suspectscore=0 bulkscore=0 clxscore=1011 impostorscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005280087
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Originally this code rejected any read less than 256 bytes.  There
is no need for this artificial limit.

Also I have changed the snprintf() functions to scnprintf().  The
difference is that snprintf() returns the number of bytes which would
have been copied if there were enough space and scnprintf() returns the
number of bytes which were actually copied.  It doesn't matter here
because the strings are very short so they can't go over 256 bytes.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/crypto/hisilicon/qm.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index a781c02251980..9c0c9f500d91d 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -1076,16 +1076,15 @@ static ssize_t qm_cmd_read(struct file *filp, char __user *buffer,
 	if (*pos)
 		return 0;
 
-	if (count < QM_DBG_READ_LEN)
-		return -ENOSPC;
-
-	len = snprintf(buf, QM_DBG_READ_LEN, "%s\n",
+	len = scnprintf(buf, QM_DBG_READ_LEN, "%s\n",
 		       "Please echo help to cmd to get help information");
 
+	len = min_t(size_t, len, count);
 	if (copy_to_user(buffer, buf, len))
 		return -EFAULT;
 
-	return (*pos = len);
+	*pos = len;
+	return len;
 }
 
 static void *qm_ctx_alloc(struct hisi_qm *qm, size_t ctx_size,
@@ -2710,19 +2709,18 @@ static ssize_t qm_status_read(struct file *filp, char __user *buffer,
 	if (*pos)
 		return 0;
 
-	if (count < QM_DBG_READ_LEN)
-		return -ENOSPC;
-
 	val = atomic_read(&qm->status.flags);
-	len = snprintf(buf, QM_DBG_READ_LEN, "%s\n", qm_s[val]);
+	len = scnprintf(buf, QM_DBG_READ_LEN, "%s\n", qm_s[val]);
 	if (!len)
 		return -EFAULT;
 
+	len = min_t(size_t, len, count);
 	cp_len = copy_to_user(buffer, buf, len);
 	if (cp_len)
 		return -EFAULT;
 
-	return (*pos = len);
+	*pos = len;
+	return len;
 }
 
 static const struct file_operations qm_status_fops = {
-- 
2.26.2

