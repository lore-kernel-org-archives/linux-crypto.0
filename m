Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06CE2C433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Jan 2021 05:56:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE61E2070E
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Jan 2021 05:56:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhA0Fzv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Jan 2021 00:55:51 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45204 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234162AbhA0F1U (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Jan 2021 00:27:20 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R5PYKW113719;
        Wed, 27 Jan 2021 05:26:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=fD+gGvKUrCI8keFPMfuW6njiJLLrpkcUGKk1anPewWE=;
 b=UivqKjQjesX1rwU19z2nOcPhv4omol6/J/3KGYEd1DpCfGOwpWn4yRoSD0lAfgodmqXZ
 j46EG0qKnM0UAzQrXHtC4Czmqyw9CShvYO2GH/1jRnwUqIQFgvAu5J/VbDbWTlFANV6w
 1mRsVgL0VgPgiKxZwEjrLGu0ObWG4VYcxIO/GANZldd8sSG6mKxp4LGM8wiSGS2ef1A+
 moMgi7PHx4t7XudVvkr2LEcEd3U9xsd5tALdwonHobnYlABJDGSwfVL5FycsQKQxH/F/
 DoeXMKGXrQ62rl02R7P/PZeR6IZgYfdD4SODIp9C2VcioEDXAMaLggiB0JCEuvat6NGn UA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 368brkn5mu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 05:26:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R5P5Nx086079;
        Wed, 27 Jan 2021 05:26:12 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 368wcntcca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 05:26:12 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10R5Q7gc011660;
        Wed, 27 Jan 2021 05:26:08 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 26 Jan 2021 21:26:07 -0800
Date:   Wed, 27 Jan 2021 08:25:59 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Boris Brezillon <bbrezillon@kernel.org>
Cc:     Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Suheil Chandran <schandran@marvell.com>,
        Lukasz Bartosik <lbartosik@marvell.com>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] crypto: octeontx2 - fix signedness bug in
 cptvf_register_interrupts()
Message-ID: <YBD5Z11GeYlJGuTh@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 mlxlogscore=951 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270031
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=892
 lowpriorityscore=0 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101270031
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The "num_vec" has to be signed for the error handling to work.

Fixes: 19d8e8c7be15 ("crypto: octeontx2 - add virtual function driver support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
index 9663be38ee40..47f378731024 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c
@@ -34,7 +34,7 @@ static void cptvf_disable_pfvf_mbox_intrs(struct otx2_cptvf_dev *cptvf)
 static int cptvf_register_interrupts(struct otx2_cptvf_dev *cptvf)
 {
 	int ret, irq;
-	u32 num_vec;
+	int num_vec;
 
 	num_vec = pci_msix_vec_count(cptvf->pdev);
 	if (num_vec <= 0)
-- 
2.29.2

