Return-Path: <SRS0=QLPS=3J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68359C33CA1
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jan 2020 14:40:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FBD422464
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jan 2020 14:40:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Nu47qN7N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729174AbgATOkG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Jan 2020 09:40:06 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:56072 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729096AbgATOkG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Jan 2020 09:40:06 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KEcswI078723;
        Mon, 20 Jan 2020 14:38:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=COabEgS7nv8mvxYtXmQSOiXcQQ/pf6rP7R9idxnk148=;
 b=Nu47qN7NwoMBHcWf5+qTZo5Oz1ZihZ2XyKD13cDRQoIvGzYtVTAwBNKNMi/tOaZRF0WM
 urHH5PSiXlo/Mw6nFTuEmAPAa8Cb5v8H/PJnqLymKNB3sIt9Kq62WxYgpP/RMhVgdKEC
 t40igjxcQaEmUa4kf1bkazxQeWhzDDItigIf0i5GdGZWXv5MNJiNdSRhzj3jlZeghRsp
 9/rjcqQLuwaz32xdyrtpuAIMBl44QNSjzNOVuYn3jRQ3bi88tHsElsgd0qoKu42m5jka
 aVHQwrj2IkhvEE9IbFG7EN1XMRTsIqbDnkN/1TPVy60iJy+9vOM8MtuPIt4J+sJi2yUc pA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2xktnqypps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 14:38:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00KEcrsl043047;
        Mon, 20 Jan 2020 14:38:54 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2xmc5kqq58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jan 2020 14:38:54 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00KEcCCZ020099;
        Mon, 20 Jan 2020 14:38:14 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Jan 2020 06:38:11 -0800
Date:   Mon, 20 Jan 2020 17:38:04 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Neil Horman <nhorman@tuxdriver.com>,
        Corentin Labbe <clabbe@baylibre.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] crypto: rng - Fix a refcounting bug in crypto_rng_reset()
Message-ID: <20200120143804.pbmnrh72v2gogx43@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9505 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001200125
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9505 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001200125
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

We need to decrement this refcounter on these error paths.

Fixes: f7d76e05d058 ("crypto: user - fix use_after_free of struct xxx_request")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 crypto/rng.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/crypto/rng.c b/crypto/rng.c
index 1e21231f71c9..1490d210f1a1 100644
--- a/crypto/rng.c
+++ b/crypto/rng.c
@@ -37,12 +37,16 @@ int crypto_rng_reset(struct crypto_rng *tfm, const u8 *seed, unsigned int slen)
 	crypto_stats_get(alg);
 	if (!seed && slen) {
 		buf = kmalloc(slen, GFP_KERNEL);
-		if (!buf)
+		if (!buf) {
+			crypto_alg_put(alg);
 			return -ENOMEM;
+		}
 
 		err = get_random_bytes_wait(buf, slen);
-		if (err)
+		if (err) {
+			crypto_alg_put(alg);
 			goto out;
+		}
 		seed = buf;
 	}
 
-- 
2.11.0

