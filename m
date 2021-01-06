Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BCCDC433DB
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Jan 2021 09:28:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2098323102
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Jan 2021 09:28:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbhAFJ2I (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Jan 2021 04:28:08 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:40104 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbhAFJ2H (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Jan 2021 04:28:07 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10698lHC006845;
        Wed, 6 Jan 2021 09:27:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=tasVWPVUrp4SJFLddlqIVMFe6AQVqT3bFOPJTpvyKoI=;
 b=u8PD1avKZt4IvaRlfoDiB20/wemTPzzMruBzg6JVvatd9y6MBk3hFu1b+mNge+QsLJT8
 V+qoyH6Fb4bwMf7Z/IpdgQumMqHiD6OgMkX2C9PvoQbyTN0szMruXjJfUyQXKQCIL2yS
 gO3y5dlgsTZxJIzdCad01jRa4N5NC2KWYU/Ma34F5r9UCIDYz0jgTIVXbVeUpn6slTtp
 //mELuGg9TJ0cLuT3mQf0/trJOQoYt+pR6uIWWF7jIZ5Whubu/acHY6GZDj5MjzQqwVX
 mLXto42tRQ2sJFmZhO1vZMwHml3aJVQ/KuHPQ90la7MA2K+SkZXPg/hPdWTuUF7oCMCc UA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 35w7p0gj88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 09:27:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1069Fpk3107740;
        Wed, 6 Jan 2021 09:25:18 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 35w3qrqjd7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 09:25:18 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 1069PHu7002390;
        Wed, 6 Jan 2021 09:25:17 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Jan 2021 01:25:16 -0800
Date:   Wed, 6 Jan 2021 12:25:08 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Cc:     Declan Murphy <declan.murphy@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] crypto: keembay-ocs-hcu - Fix a WARN() message
Message-ID: <X/WB9IlpyIi+5p5s@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060056
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 impostorscore=0 mlxscore=0
 priorityscore=1501 malwarescore=0 clxscore=1011 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060056
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The first argument to WARN() is a condition and the messages is the
second argument is the string, so this WARN() will only display the
__func__ part of the message.

Fixes: ae832e329a8d ("crypto: keembay-ocs-hcu - Add HMAC support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/crypto/keembay/keembay-ocs-hcu-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/keembay/keembay-ocs-hcu-core.c b/drivers/crypto/keembay/keembay-ocs-hcu-core.c
index d547af047131..c4b97b4160e9 100644
--- a/drivers/crypto/keembay/keembay-ocs-hcu-core.c
+++ b/drivers/crypto/keembay/keembay-ocs-hcu-core.c
@@ -388,7 +388,7 @@ static int prepare_ipad(struct ahash_request *req)
 	 * longer keys are hashed by kmb_ocs_hcu_setkey()).
 	 */
 	if (ctx->key_len > rctx->blk_sz) {
-		WARN("%s: Invalid key length in tfm context\n", __func__);
+		WARN(1, "%s: Invalid key length in tfm context\n", __func__);
 		return -EINVAL;
 	}
 	memzero_explicit(&ctx->key[ctx->key_len],
-- 
2.29.2

