Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0C63C10F1D
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Dec 2022 22:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232693AbiLSWDi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Dec 2022 17:03:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232853AbiLSWDU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Dec 2022 17:03:20 -0500
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com [148.163.147.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A87140C9;
        Mon, 19 Dec 2022 14:03:19 -0800 (PST)
Received: from pps.filterd (m0134422.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJL1wCX003253;
        Mon, 19 Dec 2022 22:02:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pps0720;
 bh=v7bR1szvHVL/RPr0ZNg3zP1MrZYuBcDYIV4Z7L2T914=;
 b=ONkH+4LS7SXoAXohpr8SBsVPGhgEtOKMi2uiTZ/y20e/Do1S5koY8UmDXOn3lCXox5Gn
 so3QBUWBG47i6BhCiN1h9GBDOunOEmqQBNWLC4fVDMmZXYbsS4f75dGWSMnEYgyh7vzQ
 NlR9wRg+i+GW4T+IoGPEXc94OdVPr4bbNuEabW8S6Y6ggDc42r+GRaCCARK0+v67mXCv
 qygtL8Ok8JtwYw2oFH+YXQdb/ClYASd/ORpDCqkqSSBgxLRPGV23lOu384M0WACUnMbN
 jB/1ECLjBKvuYhLZ+1EsHtqIWonj1zY4LmsHc4WdNSXYQdhmGOC6XnpXIuA0XRNLaQRt cg== 
Received: from p1lg14878.it.hpe.com (p1lg14878.it.hpe.com [16.230.97.204])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3mjyd9rcn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Dec 2022 22:02:55 +0000
Received: from p1lg14885.dc01.its.hpecorp.net (unknown [10.119.18.236])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by p1lg14878.it.hpe.com (Postfix) with ESMTPS id AF7183DE2E;
        Mon, 19 Dec 2022 22:02:54 +0000 (UTC)
Received: from adevxp033-sys.us.rdlabs.hpecorp.net (unknown [16.231.227.36])
        by p1lg14885.dc01.its.hpecorp.net (Postfix) with ESMTP id E37DB80649A;
        Mon, 19 Dec 2022 22:02:53 +0000 (UTC)
From:   Robert Elliott <elliott@hpe.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net, Jason@zx2c4.com,
        ardb@kernel.org, ap420073@gmail.com, David.Laight@ACULAB.COM,
        ebiggers@kernel.org, tim.c.chen@linux.intel.com, peter@n8pjl.ca,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
Cc:     linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Elliott <elliott@hpe.com>
Subject: [PATCH 07/13] crypto: x86/ghash - restructure FPU context saving
Date:   Mon, 19 Dec 2022 16:02:17 -0600
Message-Id: <20221219220223.3982176-8-elliott@hpe.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221219220223.3982176-1-elliott@hpe.com>
References: <20221219220223.3982176-1-elliott@hpe.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: wEAm2iiXTf33vjlVf3B3bGIxapDJMGAh
X-Proofpoint-GUID: wEAm2iiXTf33vjlVf3B3bGIxapDJMGAh
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-19_01,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 clxscore=1015 bulkscore=0 adultscore=0 malwarescore=0
 spamscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212190193
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
index beac4b2eddf6..1bfde099de0f 100644
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
2.38.1

