Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C2A4C433B4
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Apr 2021 21:11:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00B3E61354
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Apr 2021 21:11:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbhDQVLz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Apr 2021 17:11:55 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10630 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237013AbhDQVLz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Apr 2021 17:11:55 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13HL3RZ4157073;
        Sat, 17 Apr 2021 17:11:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=8VDNbTf7G5vRHHu4gG6mXsNruwZ1y+Folrm8GfKCM/o=;
 b=cely6L47ftrnGZYw32Y8nsgkkTUIVSW1T3NHiOyV6ufXzRU1j1j9hnW8L+z0beG+cOPR
 x3aGXYlVdAwkoh68RZRRZjJ+zwTvQWzdY1qN3E8yegM5qVXW5OXCdGAe+b9ov1YnO7DY
 HzYhqXrg2Bv2oCmgt+K1WornOgZmZ0/4L4GnvO3rXvS4wyMOjP9gb3hlTX39Lq3UAHb6
 FmdzsSjog/BZIZGjOorSAISCHGCbnJp3bShjkXD6Bn+c3gzZSfiDfkJtyepdwJL2oo/u
 uXTKI/M/VrBDxN85zideZ28FoSZlkwQ0DPKwLHI9jk0EZzfN89BBdkYEt6eJQrJ2honb rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37yupr2xp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 17 Apr 2021 17:11:21 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13HL5CML163994;
        Sat, 17 Apr 2021 17:11:20 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37yupr2xp0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 17 Apr 2021 17:11:20 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13HLARWM028289;
        Sat, 17 Apr 2021 21:11:20 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04dal.us.ibm.com with ESMTP id 37yqa8xxhp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 17 Apr 2021 21:11:19 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13HLBIqb23265772
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 17 Apr 2021 21:11:18 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A661C6E056;
        Sat, 17 Apr 2021 21:11:18 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A8986E053;
        Sat, 17 Apr 2021 21:11:17 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.232.48])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat, 17 Apr 2021 21:11:16 +0000 (GMT)
Message-ID: <ead7ef3bc33dac05fbb8b2ef59d5d0110ba318be.camel@linux.ibm.com>
Subject: [V3 PATCH 13/16] crypto/nx: Rename nx-842-pseries file name to
 nx-common-pseries
From:   Haren Myneni <haren@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        mpe@ellerman.id.au, herbert@gondor.apana.org.au, npiggin@gmail.com
Cc:     hbabu@us.ibm.com, haren@us.ibm.com
Date:   Sat, 17 Apr 2021 14:11:15 -0700
In-Reply-To: <a910e5bd3f3398b4bd430b25a856500735b993c3.camel@linux.ibm.com>
References: <a910e5bd3f3398b4bd430b25a856500735b993c3.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1xRLhBBLLzWQ9hxOgJzl0sRY9hlyflbm
X-Proofpoint-ORIG-GUID: jsUhzYhMuMPssL5igzxUm6DWWVoQZDKo
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-17_12:2021-04-16,2021-04-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 bulkscore=0 impostorscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 clxscore=1015 malwarescore=0 lowpriorityscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104170152
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


Rename nx-842-pseries.c to nx-common-pseries.c to add code for new
GZIP compression type. The actual functionality is not changed in
this patch.

Signed-off-by: Haren Myneni <haren@linux.ibm.com>
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


