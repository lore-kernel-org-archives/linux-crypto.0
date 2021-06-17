Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 685CBC49361
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 20:38:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FB38610A7
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 20:38:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbhFQUkS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Jun 2021 16:40:18 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3354 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231656AbhFQUkR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jun 2021 16:40:17 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15HKXA4H113591;
        Thu, 17 Jun 2021 16:38:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=+sST6kFmoJ9El7GVS3xU27/3A7h3K0uk71wyoGGtIXA=;
 b=H0y/5AlPwXNB5vlnps9hYQWFEeohsmxttywzsyuuweO4UYSXblOjxg5ZptaB7UIRRn9i
 pR2F9HMr9AbGy7SjroDQHtXeL9xjFauC+M5o8fj1UkQuERRpBkyGPhfwdayNVvzA663W
 7vD0XdqORZct7nJbfc3yqiTtw2eoL1cCJfsvTpM6eJ46GETFIhAnCB+JNjpsZ0755JcU
 upAaTEwtxJ7gQt01VKrdChiw7jCsWyasV1IwxXSUgDxn0E22uZGg69o1KxmqmtMjOPLu
 HZgvY5SdQVgUAuH6uMP7fnsAzglTKAW5tN6TrM5NH05GZarcPfkv3QUtgoqYMkIqGYL3 Yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 398cvj12as-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Jun 2021 16:38:03 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15HKYdgk118541;
        Thu, 17 Jun 2021 16:38:02 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 398cvj1294-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Jun 2021 16:38:02 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15HKIG3c004130;
        Thu, 17 Jun 2021 20:37:59 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03wdc.us.ibm.com with ESMTP id 394mja3wtd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Jun 2021 20:37:59 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15HKbw0h17301962
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Jun 2021 20:37:58 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B0F946E04C;
        Thu, 17 Jun 2021 20:37:58 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B71C6E04E;
        Thu, 17 Jun 2021 20:37:55 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.160.180.39])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 17 Jun 2021 20:37:54 +0000 (GMT)
Message-ID: <1fcf672209a14ea8944bd3e49c8a7381c8f450f8.camel@linux.ibm.com>
Subject: [PATCH v6 14/17] crypto/nx: Rename nx-842-pseries file name to
 nx-common-pseries
From:   Haren Myneni <haren@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        mpe@ellerman.id.au, herbert@gondor.apana.org.au, npiggin@gmail.com
Cc:     hbabu@us.ibm.com, haren@us.ibm.com
Date:   Thu, 17 Jun 2021 13:37:42 -0700
In-Reply-To: <827bf56dce09620ebecd8a00a5f97105187a6205.camel@linux.ibm.com>
References: <827bf56dce09620ebecd8a00a5f97105187a6205.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: seVC0Zwbu0Id04fWaaOznFy_xEfFPwh2
X-Proofpoint-ORIG-GUID: gxv2A5Nez5OWPhFLHNPCtWozlrl_6d0Z
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-17_16:2021-06-15,2021-06-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 mlxlogscore=999 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106170123
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


Rename nx-842-pseries.c to nx-common-pseries.c to add code for new
GZIP compression type. The actual functionality is not changed in
this patch.

Signed-off-by: Haren Myneni <haren@linux.ibm.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Nicholas Piggin <npiggin@gmail.com>
---
 drivers/crypto/nx/Makefile                                  | 2 +-
 drivers/crypto/nx/{nx-842-pseries.c => nx-common-pseries.c} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename drivers/crypto/nx/{nx-842-pseries.c => nx-common-pseries.c} (100%)

diff --git a/drivers/crypto/nx/Makefile b/drivers/crypto/nx/Makefile
index bc89a20e5d9d..d00181a26dd6 100644
--- a/drivers/crypto/nx/Makefile
+++ b/drivers/crypto/nx/Makefile
@@ -14,5 +14,5 @@ nx-crypto-objs := nx.o \
 obj-$(CONFIG_CRYPTO_DEV_NX_COMPRESS_PSERIES) += nx-compress-pseries.o nx-compress.o
 obj-$(CONFIG_CRYPTO_DEV_NX_COMPRESS_POWERNV) += nx-compress-powernv.o nx-compress.o
 nx-compress-objs := nx-842.o
-nx-compress-pseries-objs := nx-842-pseries.o
+nx-compress-pseries-objs := nx-common-pseries.o
 nx-compress-powernv-objs := nx-common-powernv.o
diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-common-pseries.c
similarity index 100%
rename from drivers/crypto/nx/nx-842-pseries.c
rename to drivers/crypto/nx/nx-common-pseries.c
-- 
2.18.2


