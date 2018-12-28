Return-Path: <SRS0=sHEo=PF=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:16665 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725929AbeL1Geq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Dec 2018 01:34:46 -0500
From: YueHaibing <yuehaibing@huawei.com>
To: Harsh Jain <harsh@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
CC: YueHaibing <yuehaibing@huawei.com>, <linux-crypto@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] crypto: chelsio - CHECK-remove set but not used variables 'adap'
Date: Fri, 28 Dec 2018 06:41:42 +0000
Message-ID: <1545979302-111921-1-git-send-email-yuehaibing@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/crypto/chelsio/chcr_algo.c: In function 'chcr_device_init':
drivers/crypto/chelsio/chcr_algo.c:1371:18: warning:
 variable 'adap' set but not used [-Wunused-but-set-variable]

It not used since commit a1c6fd4308d3 ("crypto: chelsio - Update ntx queue
received from cxgb4")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/crypto/chelsio/chcr_algo.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index bcef765..c8cd2d3 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -1368,7 +1368,6 @@ static int chcr_aes_decrypt(struct ablkcipher_request *req)
 static int chcr_device_init(struct chcr_context *ctx)
 {
 	struct uld_ctx *u_ctx = NULL;
-	struct adapter *adap;
 	unsigned int id;
 	int txq_perchan, txq_idx, ntxq;
 	int err = 0, rxq_perchan, rxq_idx;
@@ -1382,7 +1381,6 @@ static int chcr_device_init(struct chcr_context *ctx)
 			goto out;
 		}
 		ctx->dev = &u_ctx->dev;
-		adap = padap(ctx->dev);
 		ntxq = u_ctx->lldi.ntxq;
 		rxq_perchan = u_ctx->lldi.nrxq / u_ctx->lldi.nchan;
 		txq_perchan = ntxq / u_ctx->lldi.nchan;
