Return-Path: <SRS0=mFw2=7S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D915C433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 11:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B08E207D5
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 11:04:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lmCMNiQe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgFELES (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jun 2020 07:04:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56582 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbgFELES (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jun 2020 07:04:18 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 055B2Cep164913;
        Fri, 5 Jun 2020 11:03:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=/CQIFfdEXbHYL9KAyqe41mZw3wOfUdI9/0EmBUD6MHg=;
 b=lmCMNiQe3vTmw1hdPO+S2Y8+q39E5NJG7EcTTN8N/jWM59n0UYxDmUF+TljA/mUxttgJ
 S6kYcrUn/+2EL++awH4ZBVcNhkcMr8oMKoV+5Xz5NlOF+z6+2sj8z4ZWCmR9qGVf0/hD
 FeJHlV29RSffXewc3s8/I7R5ZUPY1c/bb5xCWxxPnYVrYxrRrgAtm+koAL8ZXbTnFPLC
 fXqqNXK8BlmVq2YdQ1ZcZUlx8ePfaoEk5TYWOoZ6puYkd9NHi3LctGC9vXt29LRO9VWe
 JV03NPMyCxl1GgPyDs4Pj1z0I5TvpMKPPMsIIEvvNu+aWiNTDqruy8vpcgzJNHwKnA7V 5A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 31f9262a9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 05 Jun 2020 11:03:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 055B3Qxi029185;
        Fri, 5 Jun 2020 11:03:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 31f92skya6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jun 2020 11:03:55 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 055B3lSa029081;
        Fri, 5 Jun 2020 11:03:47 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Jun 2020 04:03:46 -0700
Date:   Fri, 5 Jun 2020 14:03:39 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Boris Brezillon <bbrezillon@kernel.org>,
        SrujanaChalla <schalla@marvell.com>
Cc:     Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Lukasz Bartosik <lbartosik@marvell.com>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] crypto: marvell/octeontx - Fix a potential NULL dereference
Message-ID: <20200605110339.GE978434@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9642 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006050085
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9642 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 suspectscore=0 cotscore=-2147483648 bulkscore=0 clxscore=1011
 impostorscore=0 priorityscore=1501 malwarescore=0 mlxlogscore=999
 spamscore=0 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006050085
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Smatch reports that:

    drivers/crypto/marvell/octeontx/otx_cptvf_algs.c:132 otx_cpt_aead_callback()
    warn: variable dereferenced before check 'cpt_info' (see line 121)

This function is called from process_pending_queue() as:

drivers/crypto/marvell/octeontx/otx_cptvf_reqmgr.c
   599                  /*
   600                   * Call callback after current pending entry has been
   601                   * processed, we don't do it if the callback pointer is
   602                   * invalid.
   603                   */
   604                  if (callback)
   605                          callback(res_code, areq, cpt_info);

It does appear to me that "cpt_info" can be NULL so this could lead to
a NULL dereference.

Fixes: 10b4f09491bf ("crypto: marvell - add the Virtual Function driver for CPT")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/crypto/marvell/octeontx/otx_cptvf_algs.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c b/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
index 60e744f680d34..1e0a1d70ebd39 100644
--- a/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
+++ b/drivers/crypto/marvell/octeontx/otx_cptvf_algs.c
@@ -118,6 +118,9 @@ static void otx_cpt_aead_callback(int status, void *arg1, void *arg2)
 	struct otx_cpt_req_info *cpt_req;
 	struct pci_dev *pdev;
 
+	if (!cpt_info)
+		goto complete;
+
 	cpt_req = cpt_info->req;
 	if (!status) {
 		/*
@@ -129,10 +132,10 @@ static void otx_cpt_aead_callback(int status, void *arg1, void *arg2)
 		    !cpt_req->is_enc)
 			status = validate_hmac_cipher_null(cpt_req);
 	}
-	if (cpt_info) {
-		pdev = cpt_info->pdev;
-		do_request_cleanup(pdev, cpt_info);
-	}
+	pdev = cpt_info->pdev;
+	do_request_cleanup(pdev, cpt_info);
+
+complete:
 	if (areq)
 		areq->complete(areq, status);
 }
-- 
2.26.2

