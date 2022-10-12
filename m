Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2460C43219
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Oct 2022 22:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiJLWAP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Oct 2022 18:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiJLWAI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Oct 2022 18:00:08 -0400
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3589E205E6;
        Wed, 12 Oct 2022 15:00:04 -0700 (PDT)
Received: from pps.filterd (m0134424.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29CJxoEv014051;
        Wed, 12 Oct 2022 21:59:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pps0720;
 bh=YlzDIESEfgTHM3UWOTC3N8erZlt5QA9vPO1xjBSnLF0=;
 b=D7WmPvZh2tewYv0m43vvUEFLRXK17NSFGmmHwTe7OsTULsEOStWj9m6E9EysrJ6vHDHg
 i6uY73vFKpCCqor2m6SJNd9tzXdVf5fB0O54yPor+ETQqTUay4uyt6kqEKxNkuvhYgHo
 dDZKGCVqWs+7zLT3gEWbgbTrPAKdxcfAvU5vAsWpie2/doWuit373EQB+3tbZmJWiFCE
 W80/+09eVfBA+HDMDSsaP9bXa6WQNPcCKa75Zn92TBj7V4+gqVTm7UMjfuKQ/ZrG9r2I
 hmBSJs/FexNgs2Fq2yz6csFdwbq3siGM0bylVguz+mv3hqIwEv+yEWIM713PGc5+0VEr Hw== 
Received: from p1lg14881.it.hpe.com (p1lg14881.it.hpe.com [16.230.97.202])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3k6471rtp0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Oct 2022 21:59:56 +0000
Received: from p1lg14885.dc01.its.hpecorp.net (unknown [10.119.18.236])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by p1lg14881.it.hpe.com (Postfix) with ESMTPS id 9A72B804719;
        Wed, 12 Oct 2022 21:59:55 +0000 (UTC)
Received: from adevxp033-sys.us.rdlabs.hpecorp.net (unknown [16.231.227.36])
        by p1lg14885.dc01.its.hpecorp.net (Postfix) with ESMTP id 39899808EDA;
        Wed, 12 Oct 2022 21:59:55 +0000 (UTC)
From:   Robert Elliott <elliott@hpe.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        tim.c.chen@linux.intel.com, ap420073@gmail.com, ardb@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Robert Elliott <elliott@hpe.com>
Subject: [PATCH v2 07/19] crypto: x86/ghash - restructure FPU context saving
Date:   Wed, 12 Oct 2022 16:59:19 -0500
Message-Id: <20221012215931.3896-8-elliott@hpe.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221012215931.3896-1-elliott@hpe.com>
References: <20221006223151.22159-1-elliott@hpe.com>
 <20221012215931.3896-1-elliott@hpe.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 77A3sNrJXj1Vd87FM5GRaq59qsi5gdvl
X-Proofpoint-ORIG-GUID: 77A3sNrJXj1Vd87FM5GRaq59qsi5gdvl
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-12_11,2022-10-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 clxscore=1015 spamscore=0
 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210120138
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Wrap each of the calls to clmul_hash_update and clmul_ghash__mul
in its own set of kernel_fpu_begin and kernel_fpu_end calls, preparing
to limit the amount of data processed by each _update call to avoid
RCU stalls.

This is more like how polyval-clmulni_glue is structured.

Fixes: 0e1227d356e9 ("crypto: ghash - Add PCLMULQDQ accelerated implementation")
Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Robert Elliott <elliott@hpe.com>
---
 arch/x86/crypto/ghash-clmulni-intel_glue.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/ghash-clmulni-intel_glue.c b/arch/x86/crypto/ghash-clmulni-intel_glue.c
index 1f1a95f3dd0c..53aa286ec27f 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_glue.c
+++ b/arch/x86/crypto/ghash-clmulni-intel_glue.c
@@ -80,7 +80,6 @@ static int ghash_update(struct shash_desc *desc,
 	struct ghash_ctx *ctx = crypto_shash_ctx(desc->tfm);
 	u8 *dst = dctx->buffer;
 
-	kernel_fpu_begin();
 	if (dctx->bytes) {
 		int n = min(srclen, dctx->bytes);
 		u8 *pos = dst + (GHASH_BLOCK_SIZE - dctx->bytes);
@@ -91,10 +90,14 @@ static int ghash_update(struct shash_desc *desc,
 		while (n--)
 			*pos++ ^= *src++;
 
-		if (!dctx->bytes)
+		if (!dctx->bytes) {
+			kernel_fpu_begin();
 			clmul_ghash_mul(dst, &ctx->shash);
+			kernel_fpu_end();
+		}
 	}
 
+	kernel_fpu_begin();
 	clmul_ghash_update(dst, src, srclen, &ctx->shash);
 	kernel_fpu_end();
 
-- 
2.37.3

