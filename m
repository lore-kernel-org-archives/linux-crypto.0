Return-Path: <SRS0=b5bf=R7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E26BC43381
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Mar 2019 14:36:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF6032173C
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Mar 2019 14:36:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WBYGqmuw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbfC1Ogi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Mar 2019 10:36:38 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:43412 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfC1Ogh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Mar 2019 10:36:37 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2SEXqqw061647;
        Thu, 28 Mar 2019 14:36:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=qmeCTfkjNbqol2swBkOzQ2uJGfifd6CyUawoZv3Oj8Q=;
 b=WBYGqmuwg6qMyYcwopQMKRapNZSBaM3XukVdBN1bLiukG5L4Vjc0Qrar2qzW7KiBdtrG
 g0OAeGdISSZN/XF7LB6RVjSAQLeL6MW3LOKZU1vqNF7d+77gUiLlRY/5wsHiJa1HR4ZN
 R1/la5gn41uUK4dvLBYnNG4y7kyQOTaVm4yJBRJ47Vf/vuLxdrKV5c/LUUKq/Iaew5Al
 F3BlTpPsnNJTzHNpMOd1rstVLuGJWHkQzShPhJBbrF+AnVNtdVFCHVXzUAYlJYs09RrN
 D6aksqhTpp5sp63rQVMnzauuylIoPuEbgsdAvX6JYGrxXHXV33p2/fJKDJMlGimv1KMz Kg== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2re6g170q1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Mar 2019 14:36:20 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2SEaEs0000881
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Mar 2019 14:36:14 GMT
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2SEaD0M007855;
        Thu, 28 Mar 2019 14:36:13 GMT
Received: from kadam (/41.202.241.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 Mar 2019 07:36:13 -0700
Date:   Thu, 28 Mar 2019 17:36:01 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] crypto: caam/qi - Change a couple IS_ERR_OR_NULL() checks to
 IS_ERR()
Message-ID: <20190328143601.GQ32590@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9208 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903280099
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

create_caam_req_fq() doesn't return NULL pointers so there is no need to
check.  The NULL checks are problematic because it's hard to say how a
NULL return should be handled, so removing the checks is a nice cleanup.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/crypto/caam/qi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c
index 7cb8b1755e57..9f08f84cca59 100644
--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -318,7 +318,7 @@ int caam_drv_ctx_update(struct caam_drv_ctx *drv_ctx, u32 *sh_desc)
 	/* Create a new req FQ in parked state */
 	new_fq = create_caam_req_fq(drv_ctx->qidev, drv_ctx->rsp_fq,
 				    drv_ctx->context_a, 0);
-	if (IS_ERR_OR_NULL(new_fq)) {
+	if (IS_ERR(new_fq)) {
 		dev_err(qidev, "FQ allocation for shdesc update failed\n");
 		return PTR_ERR(new_fq);
 	}
@@ -431,7 +431,7 @@ struct caam_drv_ctx *caam_drv_ctx_init(struct device *qidev,
 	/* Attach request FQ */
 	drv_ctx->req_fq = create_caam_req_fq(qidev, drv_ctx->rsp_fq, hwdesc,
 					     QMAN_INITFQ_FLAG_SCHED);
-	if (IS_ERR_OR_NULL(drv_ctx->req_fq)) {
+	if (IS_ERR(drv_ctx->req_fq)) {
 		dev_err(qidev, "create_caam_req_fq failed\n");
 		dma_unmap_single(qidev, hwdesc, size, DMA_BIDIRECTIONAL);
 		kfree(drv_ctx);
-- 
2.17.1

