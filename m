Return-Path: <SRS0=6qCq=6B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DDF4C2BB55
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Apr 2020 09:03:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4062F221E9
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Apr 2020 09:03:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729867AbgDQJDb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Apr 2020 05:03:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16802 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728419AbgDQJDb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Apr 2020 05:03:31 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03H91rvs023619;
        Fri, 17 Apr 2020 05:03:14 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30f8hnhtb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Apr 2020 05:03:13 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03H91rto023694;
        Fri, 17 Apr 2020 05:03:13 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30f8hnhtav-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Apr 2020 05:03:13 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03H91MY9013855;
        Fri, 17 Apr 2020 09:03:12 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01wdc.us.ibm.com with ESMTP id 30b5h716pa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Apr 2020 09:03:12 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03H93Be064291182
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 09:03:11 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 077B0BE056;
        Fri, 17 Apr 2020 09:03:11 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CFFCBE053;
        Fri, 17 Apr 2020 09:03:10 +0000 (GMT)
Received: from [9.70.82.143] (unknown [9.70.82.143])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 17 Apr 2020 09:03:10 +0000 (GMT)
Subject: [PATCH v6 4/9] crypto/nx: Initialize coproc entry with kzalloc
From:   Haren Myneni <haren@linux.ibm.com>
To:     mpe@ellerman.id.au
Cc:     herbert@gondor.apana.org.au, mikey@neuling.org, npiggin@gmail.com,
        linux-crypto@vger.kernel.org, sukadev@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org, dja@axtens.net
In-Reply-To: <1587113732.2275.1096.camel@hbabu-laptop>
References: <1587113732.2275.1096.camel@hbabu-laptop>
Content-Type: text/plain; charset="UTF-8"
Date:   Fri, 17 Apr 2020 02:02:43 -0700
Message-ID: <1587114163.2275.1110.camel@hbabu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-17_03:2020-04-14,2020-04-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 adultscore=0 malwarescore=0
 clxscore=1015 spamscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 suspectscore=1 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004170067
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



