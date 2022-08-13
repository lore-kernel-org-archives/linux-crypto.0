Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EACDC19F2D
	for <linux-crypto@archiver.kernel.org>; Sat, 13 Aug 2022 23:06:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239646AbiHMXGv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 13 Aug 2022 19:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238439AbiHMXGu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 13 Aug 2022 19:06:50 -0400
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407A78284F
        for <linux-crypto@vger.kernel.org>; Sat, 13 Aug 2022 16:06:49 -0700 (PDT)
Received: from pps.filterd (m0134421.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27DMvvbM014112;
        Sat, 13 Aug 2022 23:05:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pps0720;
 bh=2y/+QjsbwZnDSI3U6kv+3YmFpybKucr3hBm4+M8u7aw=;
 b=Na+K7Oq7hJ5zGFVg8xzw33lbYZZVXcnKf69/q8Y3KcxwlZsKdFd3zMljfJA3nCLuXfZy
 KfvAI35VZgkXn4oal2yug3zwPO/XX96oMhu5510VxeLv8W0y68/jqlKlejI4g3fKcou9
 NaMiJW9S3IgdSu0YahGrorvj2QK6NHU0FIAFB8bdmQ/6aY4WapqdW2Xgtb4Yx0IoUhcp
 9a5zhPjsnIpBFyRwwXTcdAH6Yn5vZ/kD2QFEvHm9Dbk6jzFJ0JUiS+UB1oBNRqiDqG7X
 BKyZR7pjStkTup0uG3lHgqeTLjuDd0tWSSXnRSIYXnnXCARnXIewLH5uKTGBv/DlC1lI /w== 
Received: from p1lg14879.it.hpe.com (p1lg14879.it.hpe.com [16.230.97.200])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3hx3vfmd9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 13 Aug 2022 23:05:20 +0000
Received: from p1lg14885.dc01.its.hpecorp.net (unknown [10.119.18.236])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by p1lg14879.it.hpe.com (Postfix) with ESMTPS id D31C9132DE;
        Sat, 13 Aug 2022 23:05:19 +0000 (UTC)
Received: from adevxp033-sys.us.rdlabs.hpecorp.net (unknown [16.231.227.36])
        by p1lg14885.dc01.its.hpecorp.net (Postfix) with ESMTP id 1D6C38041D1;
        Sat, 13 Aug 2022 23:05:17 +0000 (UTC)
From:   Robert Elliott <elliott@hpe.com>
To:     tim.c.chen@linux.intel.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, toshi.kani@hpe.com, rwright@hpe.com
Cc:     Robert Elliott <elliott@hpe.com>
Subject: [PATCH] crypto: x86/sha512 - load based on CPU features
Date:   Sat, 13 Aug 2022 18:04:31 -0500
Message-Id: <20220813230431.2666-1-elliott@hpe.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: phYctUuUBvkym5Ne6LbuRZoJbIH4t842
X-Proofpoint-ORIG-GUID: phYctUuUBvkym5Ne6LbuRZoJbIH4t842
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-13_11,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999
 spamscore=0 clxscore=1011 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208130095
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

x86 optimized crypto modules built as modules rather than built-in
to the kernel end up as .ko files in the filesystem, e.g., in
/usr/lib/modules. If the filesystem itself is a module, these might
not be available when the crypto API is initialized, resulting in
the generic implementation being used (e.g., sha512_transform rather
than sha512_transform_avx2).

In one test case, CPU utilization in the sha512 function dropped
from 15.34% to 7.18% after forcing loading of the optimized module.

Add module aliases for this x86 optimized crypto module based on CPU
feature bits so udev gets a chance to load them later in the boot
process when the filesystems are all running.

Signed-off-by: Robert Elliott <elliott@hpe.com>
---
 arch/x86/crypto/sha512_ssse3_glue.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/crypto/sha512_ssse3_glue.c b/arch/x86/crypto/sha512_ssse3_glue.c
index 30e70f4fe2f7..6d3b85e53d0e 100644
--- a/arch/x86/crypto/sha512_ssse3_glue.c
+++ b/arch/x86/crypto/sha512_ssse3_glue.c
@@ -36,6 +36,7 @@
 #include <linux/types.h>
 #include <crypto/sha2.h>
 #include <crypto/sha512_base.h>
+#include <asm/cpu_device_id.h>
 #include <asm/simd.h>
 
 asmlinkage void sha512_transform_ssse3(struct sha512_state *state,
@@ -284,6 +285,13 @@ static int register_sha512_avx2(void)
 			ARRAY_SIZE(sha512_avx2_algs));
 	return 0;
 }
+static const struct x86_cpu_id module_cpu_ids[] = {
+	X86_MATCH_FEATURE(X86_FEATURE_AVX2, NULL),
+	X86_MATCH_FEATURE(X86_FEATURE_AVX, NULL),
+	X86_MATCH_FEATURE(X86_FEATURE_SSSE3, NULL),
+	{}
+};
+MODULE_DEVICE_TABLE(x86cpu, module_cpu_ids);
 
 static void unregister_sha512_avx2(void)
 {
@@ -294,6 +302,8 @@ static void unregister_sha512_avx2(void)
 
 static int __init sha512_ssse3_mod_init(void)
 {
+	if (!x86_match_cpu(module_cpu_ids))
+		return -ENODEV;
 
 	if (register_sha512_ssse3())
 		goto fail;
-- 
2.37.1

