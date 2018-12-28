Return-Path: <SRS0=sHEo=PF=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:41024 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728615AbeL1Gls (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Dec 2018 01:41:48 -0500
From: YueHaibing <yuehaibing@huawei.com>
To: <harsh@chelsio.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] crypto: chelsio - check set_msg_len overflow in generate_b0
Date: Fri, 28 Dec 2018 14:41:00 +0800
Message-ID: <20181228064100.16876-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

set_msg_len may fails with -EOVERFLOW, It should be propagate
to upstream.

Fixes: 2debd3325e55 ("crypto: chcr - Add AEAD algos.")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/chelsio/chcr_algo.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index bcef765..bdbdce9 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -2762,7 +2762,7 @@ static int set_msg_len(u8 *block, unsigned int msglen, int csize)
 	return 0;
 }
 
-static void generate_b0(struct aead_request *req, u8 *ivptr,
+static int generate_b0(struct aead_request *req, u8 *ivptr,
 			unsigned short op_type)
 {
 	unsigned int l, lp, m;
@@ -2787,6 +2787,8 @@ static void generate_b0(struct aead_request *req, u8 *ivptr,
 	rc = set_msg_len(b0 + 16 - l,
 			 (op_type == CHCR_DECRYPT_OP) ?
 			 req->cryptlen - m : req->cryptlen, l);
+
+	return rc;
 }
 
 static inline int crypto_ccm_check_iv(const u8 *iv)
@@ -2821,7 +2823,7 @@ static int ccm_format_packet(struct aead_request *req,
 		*((unsigned short *)(reqctx->scratch_pad + 16)) =
 				htons(assoclen);
 
-	generate_b0(req, ivptr, op_type);
+	rc = generate_b0(req, ivptr, op_type);
 	/* zero the ctr value */
 	memset(ivptr + 15 - ivptr[0], 0, ivptr[0] + 1);
 	return rc;
-- 
2.7.0
