Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AE92C433B4
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Apr 2021 21:00:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02901610CD
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Apr 2021 21:00:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237067AbhDQVBY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Apr 2021 17:01:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41228 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237056AbhDQVBX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Apr 2021 17:01:23 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13HKYUO1103064;
        Sat, 17 Apr 2021 17:00:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=BpUOCiXkn3Lnaz7oK7kSbg4xQWKMOF02ZZA9A0eflHg=;
 b=EP7OK6B1BM90m0B7M05r185iwF4jhzezNaS646g4hVK4LDLBlmr9ZfFP5lsTwhSmwYya
 JwvYPKsu2nlY/SWnx+wvJr98v7bTk+RnMTsykR4zxjnalD+QAxf6VzfDfizDjaP/ZDz2
 Ctc8dIcunWUbVNuxmx9sKccXsDA/GNoUz+WkbuKHrVd/Z9U7ujDtGkuPwJTd3RcI+1wY
 CFUd+nkukcRNnTNm9huv3oGNDWvHJv8S5NBjArsRiNTIfBfwANb9qvZ0BR7v/sDDAkCW
 QBZc5xjAqe3rNOZ2hY5eVz2dRNGVLg5Ler0VMvTfPnzyWfxI9f9dkyzNEMs8+8SAhu7c xQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37yv742avw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 17 Apr 2021 17:00:50 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13HKwd4i017146;
        Sat, 17 Apr 2021 17:00:49 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37yv742ava-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 17 Apr 2021 17:00:49 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13HKuklS021961;
        Sat, 17 Apr 2021 21:00:48 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02wdc.us.ibm.com with ESMTP id 37yqa95fpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 17 Apr 2021 21:00:48 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13HL0lui18153746
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 17 Apr 2021 21:00:47 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF462124055;
        Sat, 17 Apr 2021 21:00:47 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8BE2124053;
        Sat, 17 Apr 2021 21:00:46 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.80.232.48])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Sat, 17 Apr 2021 21:00:46 +0000 (GMT)
Message-ID: <86bae80a92b8465d663f72e7fadc1fa3671e8a4f.camel@linux.ibm.com>
Subject: [V3 PATCH 01/16] powerpc/powernv/vas: Rename register/unregister
 functions
From:   Haren Myneni <haren@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        mpe@ellerman.id.au, herbert@gondor.apana.org.au, npiggin@gmail.com
Cc:     hbabu@us.ibm.com, haren@us.ibm.com
Date:   Sat, 17 Apr 2021 14:00:45 -0700
In-Reply-To: <a910e5bd3f3398b4bd430b25a856500735b993c3.camel@linux.ibm.com>
References: <a910e5bd3f3398b4bd430b25a856500735b993c3.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: be08aZDcMwGK1T6AMAtp_J4glXh0eFo-
X-Proofpoint-GUID: 7Sm5M5w6CsDoWLZZZigaGyTh293HprrX
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-17_12:2021-04-16,2021-04-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 suspectscore=0 impostorscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 mlxscore=0 adultscore=0 clxscore=1015
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104170148
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


powerNV and pseries drivers register / unregister to the corresponding
VAS code separately. So rename powerNV VAS API register/unregister
functions.

Signed-off-by: Haren Myneni <haren@linux.ibm.com>
---
 arch/powerpc/include/asm/vas.h           |  6 +++---
 arch/powerpc/platforms/powernv/vas-api.c | 10 +++++-----
 drivers/crypto/nx/nx-common-powernv.c    |  6 +++---
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/include/asm/vas.h b/arch/powerpc/include/asm/vas.h
index e33f80b0ea81..41f73fae7ab8 100644
--- a/arch/powerpc/include/asm/vas.h
+++ b/arch/powerpc/include/asm/vas.h
@@ -170,8 +170,8 @@ int vas_paste_crb(struct vas_window *win, int offset, bool re);
  * Only NX GZIP coprocessor type is supported now, but this API can be
  * used for others in future.
  */
-int vas_register_coproc_api(struct module *mod, enum vas_cop_type cop_type,
-				const char *name);
-void vas_unregister_coproc_api(void);
+int vas_register_api_powernv(struct module *mod, enum vas_cop_type cop_type,
+			     const char *name);
+void vas_unregister_api_powernv(void);
 
 #endif /* __ASM_POWERPC_VAS_H */
diff --git a/arch/powerpc/platforms/powernv/vas-api.c b/arch/powerpc/platforms/powernv/vas-api.c
index 98ed5d8c5441..72d8ce39e56c 100644
--- a/arch/powerpc/platforms/powernv/vas-api.c
+++ b/arch/powerpc/platforms/powernv/vas-api.c
@@ -207,8 +207,8 @@ static struct file_operations coproc_fops = {
  * Supporting only nx-gzip coprocessor type now, but this API code
  * extended to other coprocessor types later.
  */
-int vas_register_coproc_api(struct module *mod, enum vas_cop_type cop_type,
-				const char *name)
+int vas_register_api_powernv(struct module *mod, enum vas_cop_type cop_type,
+			     const char *name)
 {
 	int rc = -EINVAL;
 	dev_t devno;
@@ -262,9 +262,9 @@ int vas_register_coproc_api(struct module *mod, enum vas_cop_type cop_type,
 	unregister_chrdev_region(coproc_device.devt, 1);
 	return rc;
 }
-EXPORT_SYMBOL_GPL(vas_register_coproc_api);
+EXPORT_SYMBOL_GPL(vas_register_api_powernv);
 
-void vas_unregister_coproc_api(void)
+void vas_unregister_api_powernv(void)
 {
 	dev_t devno;
 
@@ -275,4 +275,4 @@ void vas_unregister_coproc_api(void)
 	class_destroy(coproc_device.class);
 	unregister_chrdev_region(coproc_device.devt, 1);
 }
-EXPORT_SYMBOL_GPL(vas_unregister_coproc_api);
+EXPORT_SYMBOL_GPL(vas_unregister_api_powernv);
diff --git a/drivers/crypto/nx/nx-common-powernv.c b/drivers/crypto/nx/nx-common-powernv.c
index 13c65deda8e9..88d728415bb2 100644
--- a/drivers/crypto/nx/nx-common-powernv.c
+++ b/drivers/crypto/nx/nx-common-powernv.c
@@ -1090,8 +1090,8 @@ static __init int nx_compress_powernv_init(void)
 		 * normal FIFO priority is assigned for userspace.
 		 * 842 compression is supported only in kernel.
 		 */
-		ret = vas_register_coproc_api(THIS_MODULE, VAS_COP_TYPE_GZIP,
-						"nx-gzip");
+		ret = vas_register_api_powernv(THIS_MODULE, VAS_COP_TYPE_GZIP,
+					       "nx-gzip");
 
 		/*
 		 * GZIP is not supported in kernel right now.
@@ -1127,7 +1127,7 @@ static void __exit nx_compress_powernv_exit(void)
 	 * use. So delete this API use for GZIP engine.
 	 */
 	if (!nx842_ct)
-		vas_unregister_coproc_api();
+		vas_unregister_api_powernv();
 
 	crypto_unregister_alg(&nx842_powernv_alg);
 
-- 
2.18.2


