Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A5D5C48BCF
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Jun 2021 11:03:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 273DD61205
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Jun 2021 11:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbhFMLFk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Jun 2021 07:05:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:57062 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231176AbhFMLFj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Jun 2021 07:05:39 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15DB3VIC027709;
        Sun, 13 Jun 2021 07:03:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=KFn/PAdMlE8AdkyS7MbXtuxQ9+Ij8Lu+nX3TyJKJH/M=;
 b=j4A4knDLKgzVDD5nPOUFpFpn0eAdEHJey6dRfkPlvWK5dBcwBqv2Ictg/v2KoXlae7QN
 GO4gJTVhsnJPGhNm5en50ya315wDI7niPaira1TlLb75K0nHb8Vmoh5uRoOonu0FpraH
 +7pejNyh7d0pS2k6026UHmTWhlCXOPazWhk5waqARLFJAgnXMZXaHdugFB393vlimRzN
 xdNffxqS0jxxp+sqvLCg/PLGpTCjfKFfRRbgcbFbTQqvzEjA13trie6o8GcmZuAePGhR
 JWG05NKLQldS2uX8wfmPetjAx6uCRlu9FtO7CsoWGwE93jodJheG+4mzSnGpq+uEvjtV qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 395fwn8pfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 13 Jun 2021 07:03:33 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15DB3W7n027874;
        Sun, 13 Jun 2021 07:03:32 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 395fwn8pfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 13 Jun 2021 07:03:32 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15DAvdQa028792;
        Sun, 13 Jun 2021 11:03:31 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma01dal.us.ibm.com with ESMTP id 394mj9jbqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 13 Jun 2021 11:03:31 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15DB3V1R28508664
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 13 Jun 2021 11:03:31 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 16400AE063;
        Sun, 13 Jun 2021 11:03:31 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C576EAE060;
        Sun, 13 Jun 2021 11:03:29 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.160.180.39])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Sun, 13 Jun 2021 11:03:29 +0000 (GMT)
Message-ID: <03731a80b5af5f8cea95579215c6d2241c291b70.camel@linux.ibm.com>
Subject: [PATCH v5 14/17] crypto/nx: Rename nx-842-pseries file name to
 nx-common-pseries
From:   Haren Myneni <haren@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        mpe@ellerman.id.au, herbert@gondor.apana.org.au, npiggin@gmail.com
Cc:     hbabu@us.ibm.com, haren@us.ibm.com
Date:   Sun, 13 Jun 2021 04:03:28 -0700
In-Reply-To: <ed7a09822cf3a2e463f942e5a37309a2365c9d79.camel@linux.ibm.com>
References: <ed7a09822cf3a2e463f942e5a37309a2365c9d79.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WW0JsZzR0xryyHTCrTfT50yORDyJIaEk
X-Proofpoint-GUID: IXtx1q__urWvSewYJ-oRDCUjlieARomI
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-13_04:2021-06-11,2021-06-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxscore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0 phishscore=0
 spamscore=0 suspectscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106130082
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


Rename nx-842-pseries.c to nx-common-pseries.c to add code for new
GZIP compression type. The actual functionality is not changed in
this patch.

Signed-off-by: Haren Myneni <haren@linux.ibm.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
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


