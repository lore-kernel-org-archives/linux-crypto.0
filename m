Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2272C433ED
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 09:30:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9CE86100A
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 09:30:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234472AbhEUJcT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 May 2021 05:32:19 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42812 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233790AbhEUJcT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 May 2021 05:32:19 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14L95xLo104904;
        Fri, 21 May 2021 05:30:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=5tiuRB0/J/BdSlunOFJ2VMSGhyuudWLtAml336U8Gkk=;
 b=SwFZ5r7V2oUiqvg4EaWlIg54W5x+MKaqG8dGDYMNZnjSEkEPheiD3cZg1jlT9XqHNJd9
 jtxLff9NPGrfselkT/uVXrrCZXP4RpsggQ6uClsVoAkE6UP5om/cglRd3hc2vWpY+/of
 xmg75c8yy/L54Xz4IJJhmbbbjBkyCTfpwyFg96A6/g4EOue2WKm0Pc2c9OMx36xLY6Cb
 2vgFIEZhO7Plkh8fPa+OowGNVyybtQxP00h3gkOCxr1rIykFn/xuuvXYxfZSCZojrenp
 wkEPRRJdDQIFwNIBwDfkmLlnone9iDIuK1N1CBRkg17Rd3PMk1HMvvBv8s0Yy5Iqi0oV Cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38p7pkvgsa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 May 2021 05:30:50 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14L96fPf108462;
        Fri, 21 May 2021 05:30:50 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38p7pkvgs1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 May 2021 05:30:50 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14L9DA89029915;
        Fri, 21 May 2021 09:29:49 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma02dal.us.ibm.com with ESMTP id 38j5xaa4h3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 May 2021 09:29:49 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14L9Tm2N11207288
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 09:29:48 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8531C136053;
        Fri, 21 May 2021 09:29:48 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D838513604F;
        Fri, 21 May 2021 09:29:46 +0000 (GMT)
Received: from sig-9-65-94-165.ibm.com (unknown [9.65.94.165])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 21 May 2021 09:29:46 +0000 (GMT)
Message-ID: <186bc668e217a1bcf1e1521999662a2044567aa5.camel@linux.ibm.com>
Subject: [PATCH v4 02/16] powerpc/powernv/vas: Rename register/unregister
 functions
From:   Haren Myneni <haren@linux.ibm.com>
To:     linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        mpe@ellerman.id.au, herbert@gondor.apana.org.au, npiggin@gmail.com
Cc:     hbabu@us.ibm.com, haren@us.ibm.com
Date:   Fri, 21 May 2021 02:29:44 -0700
In-Reply-To: <8d219c0816133a8643d650709066cf04c9c77322.camel@linux.ibm.com>
References: <8d219c0816133a8643d650709066cf04c9c77322.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rBp0AnmJ99vGmHcn7BLPqdemMQbfY6o-
X-Proofpoint-ORIG-GUID: eHOEAM--tKcNc-JvJQqzdMx3UBhueVz8
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-21_03:2021-05-20,2021-05-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 phishscore=0 impostorscore=0 bulkscore=0 clxscore=1015 suspectscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210059
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


powerNV and pseries drivers register / unregister to the corresponding
platform specific VAS separately. Then these VAS functions call the
common API with the specific window operations. So rename powerNV VAS
API register/unregister functions.

Signed-off-by: Haren Myneni <haren@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
---
 arch/powerpc/include/asm/vas.h              |  3 +++
 arch/powerpc/platforms/book3s/vas-api.c     |  2 --
 arch/powerpc/platforms/powernv/vas-window.c | 18 ++++++++++++++++++
 drivers/crypto/nx/nx-common-powernv.c       |  6 +++---
 4 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/vas.h b/arch/powerpc/include/asm/vas.h
index 3be76e813e2d..6076adf9ab4f 100644
--- a/arch/powerpc/include/asm/vas.h
+++ b/arch/powerpc/include/asm/vas.h
@@ -164,6 +164,9 @@ int vas_paste_crb(struct vas_window *win, int offset, bool re);
 
 void vas_win_paste_addr(struct vas_window *window, u64 *addr,
 			int *len);
+int vas_register_api_powernv(struct module *mod, enum vas_cop_type cop_type,
+			     const char *name);
+void vas_unregister_api_powernv(void);
 
 /*
  * Register / unregister coprocessor type to VAS API which will be exported
diff --git a/arch/powerpc/platforms/book3s/vas-api.c b/arch/powerpc/platforms/book3s/vas-api.c
index cfc9d7dd65ab..72c126d87216 100644
--- a/arch/powerpc/platforms/book3s/vas-api.c
+++ b/arch/powerpc/platforms/book3s/vas-api.c
@@ -262,7 +262,6 @@ int vas_register_coproc_api(struct module *mod, enum vas_cop_type cop_type,
 	unregister_chrdev_region(coproc_device.devt, 1);
 	return rc;
 }
-EXPORT_SYMBOL_GPL(vas_register_coproc_api);
 
 void vas_unregister_coproc_api(void)
 {
@@ -275,4 +274,3 @@ void vas_unregister_coproc_api(void)
 	class_destroy(coproc_device.class);
 	unregister_chrdev_region(coproc_device.devt, 1);
 }
-EXPORT_SYMBOL_GPL(vas_unregister_coproc_api);
diff --git a/arch/powerpc/platforms/powernv/vas-window.c b/arch/powerpc/platforms/powernv/vas-window.c
index 5f5fe63a3d1c..2fc0fbc4a3d1 100644
--- a/arch/powerpc/platforms/powernv/vas-window.c
+++ b/arch/powerpc/platforms/powernv/vas-window.c
@@ -1441,3 +1441,21 @@ struct vas_window *vas_pswid_to_window(struct vas_instance *vinst,
 
 	return window;
 }
+
+/*
+ * Supporting only nx-gzip coprocessor type now, but this API code
+ * extended to other coprocessor types later.
+ */
+int vas_register_api_powernv(struct module *mod, enum vas_cop_type cop_type,
+			     const char *name)
+{
+
+	return vas_register_coproc_api(mod, cop_type, name);
+}
+EXPORT_SYMBOL_GPL(vas_register_api_powernv);
+
+void vas_unregister_api_powernv(void)
+{
+	vas_unregister_coproc_api();
+}
+EXPORT_SYMBOL_GPL(vas_unregister_api_powernv);
diff --git a/drivers/crypto/nx/nx-common-powernv.c b/drivers/crypto/nx/nx-common-powernv.c
index 446f611726df..3b159f2fae17 100644
--- a/drivers/crypto/nx/nx-common-powernv.c
+++ b/drivers/crypto/nx/nx-common-powernv.c
@@ -1092,8 +1092,8 @@ static __init int nx_compress_powernv_init(void)
 		 * normal FIFO priority is assigned for userspace.
 		 * 842 compression is supported only in kernel.
 		 */
-		ret = vas_register_coproc_api(THIS_MODULE, VAS_COP_TYPE_GZIP,
-						"nx-gzip");
+		ret = vas_register_api_powernv(THIS_MODULE, VAS_COP_TYPE_GZIP,
+					       "nx-gzip");
 
 		/*
 		 * GZIP is not supported in kernel right now.
@@ -1129,7 +1129,7 @@ static void __exit nx_compress_powernv_exit(void)
 	 * use. So delete this API use for GZIP engine.
 	 */
 	if (!nx842_ct)
-		vas_unregister_coproc_api();
+		vas_unregister_api_powernv();
 
 	crypto_unregister_alg(&nx842_powernv_alg);
 
-- 
2.18.2


