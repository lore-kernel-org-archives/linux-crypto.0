Return-Path: <SRS0=/HXT=5R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEE82C43331
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Apr 2020 22:05:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89A1A20719
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Apr 2020 22:05:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732537AbgDAWFV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Apr 2020 18:05:21 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32140 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732527AbgDAWFU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Apr 2020 18:05:20 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 031M4C30043231;
        Wed, 1 Apr 2020 18:05:05 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 304mcbsjhm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Apr 2020 18:05:05 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 031M4m7x044917;
        Wed, 1 Apr 2020 18:05:02 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 304mcbsjfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Apr 2020 18:05:02 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 031M0Kti002037;
        Wed, 1 Apr 2020 22:04:58 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02dal.us.ibm.com with ESMTP id 301x77d75y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Apr 2020 22:04:58 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 031M4vw553215700
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Apr 2020 22:04:57 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CFC8124080;
        Wed,  1 Apr 2020 22:04:57 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D160A124085;
        Wed,  1 Apr 2020 22:04:56 +0000 (GMT)
Received: from [9.70.82.143] (unknown [9.70.82.143])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  1 Apr 2020 22:04:56 +0000 (GMT)
Subject: [PATCH v5 4/9] crypto/nx: Initialize coproc entry with kzalloc
From:   Haren Myneni <haren@linux.ibm.com>
To:     mpe@ellerman.id.au
Cc:     herbert@gondor.apana.org.au, mikey@neuling.org, npiggin@gmail.com,
        linux-crypto@vger.kernel.org, sukadev@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org, dja@axtens.net
In-Reply-To: <1585777592.10664.462.camel@hbabu-laptop>
References: <1585777592.10664.462.camel@hbabu-laptop>
Content-Type: text/plain; charset="UTF-8"
Date:   Wed, 01 Apr 2020 15:04:55 -0700
Message-ID: <1585778695.2275.0.camel@hbabu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-01_04:2020-03-31,2020-04-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=1 bulkscore=0 mlxscore=0 adultscore=0 priorityscore=1501
 clxscore=1015 lowpriorityscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004010179
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


coproc entry is initialized during NX probe on power9, but not on P8.
nx842_delete_coprocs() is used for both and frees receive window if it
is allocated. Getting crash for rmmod on P8 since coproc->vas.rxwin
is not initialized.

This patch replaces kmalloc with kzalloc in nx842_powernv_probe()

Signed-off-by: Haren Myneni <haren@linux.ibm.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/nx/nx-842-powernv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
index c037a24..8e63326 100644
--- a/drivers/crypto/nx/nx-842-powernv.c
+++ b/drivers/crypto/nx/nx-842-powernv.c
@@ -922,7 +922,7 @@ static int __init nx842_powernv_probe(struct device_node *dn)
 		return -EINVAL;
 	}
 
-	coproc = kmalloc(sizeof(*coproc), GFP_KERNEL);
+	coproc = kzalloc(sizeof(*coproc), GFP_KERNEL);
 	if (!coproc)
 		return -ENOMEM;
 
-- 
1.8.3.1



