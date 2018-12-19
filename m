Return-Path: <SRS0=cBFQ=O4=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from inva020.nxp.com ([92.121.34.13]:37064 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728013AbeLSOg5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Dec 2018 09:36:57 -0500
From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Christoph Hellwig <hch@lst.de>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-imx@nxp.com
Subject: [PATCH] crypto: caam - fix zero-length buffer DMA mapping
Date: Wed, 19 Dec 2018 16:36:44 +0200
Message-Id: <20181219143644.22089-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Aymen Sghaier <aymen.sghaier@nxp.com>

Recent changes - probably DMA API related (generic and/or arm64-specific) -
exposed a case where driver maps a zero-length buffer:
ahash_init()->ahash_update()->ahash_final() with a zero-length string to
hash

kernel BUG at kernel/dma/swiotlb.c:475!
Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
Modules linked in:
CPU: 2 PID: 1823 Comm: cryptomgr_test Not tainted 4.20.0-rc1-00108-g00c9fe37a7f2 #1
Hardware name: LS1046A RDB Board (DT)
pstate: 80000005 (Nzcv daif -PAN -UAO)
pc : swiotlb_tbl_map_single+0x170/0x2b8
lr : swiotlb_map_page+0x134/0x1f8
sp : ffff00000f79b8f0
x29: ffff00000f79b8f0 x28: 0000000000000000
x27: ffff0000093d0000 x26: 0000000000000000
x25: 00000000001f3ffe x24: 0000000000200000
x23: 0000000000000000 x22: 00000009f2c538c0
x21: ffff800970aeb410 x20: 0000000000000001
x19: ffff800970aeb410 x18: 0000000000000007
x17: 000000000000000e x16: 0000000000000001
x15: 0000000000000019 x14: c32cb8218a167fe8
x13: ffffffff00000000 x12: ffff80097fdae348
x11: 0000800976bca000 x10: 0000000000000010
x9 : 0000000000000000 x8 : ffff0000091fd6c8
x7 : 0000000000000000 x6 : 00000009f2c538bf
x5 : 0000000000000000 x4 : 0000000000000001
x3 : 0000000000000000 x2 : 00000009f2c538c0
x1 : 00000000f9fff000 x0 : 0000000000000000
Process cryptomgr_test (pid: 1823, stack limit = 0x(____ptrval____))
Call trace:
 swiotlb_tbl_map_single+0x170/0x2b8
 swiotlb_map_page+0x134/0x1f8
 ahash_final_no_ctx+0xc4/0x6cc
 ahash_final+0x10/0x18
 crypto_ahash_op+0x30/0x84
 crypto_ahash_final+0x14/0x1c
 __test_hash+0x574/0xe0c
 test_hash+0x28/0x80
 __alg_test_hash+0x84/0xd0
 alg_test_hash+0x78/0x144
 alg_test.part.30+0x12c/0x2b4
 alg_test+0x3c/0x68
 cryptomgr_test+0x44/0x4c
 kthread+0xfc/0x128
 ret_from_fork+0x10/0x18
Code: d34bfc18 2a1a03f7 1a9f8694 35fff89a (d4210000)

Cc: <stable@vger.kernel.org>
Signed-off-by: Aymen Sghaier <aymen.sghaier@nxp.com>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---

A bisect b/w above-mentioned commit 00c9fe37a7f2 (bad) and v4.19 (good)
points to commit
b4ebe6063204 ("dma-direct: implement complete bus_dma_mask handling")

Chronologically:
v4.19 (good) -> b4ebe6063204 (bad) -> 00c9fe37a7f2 (bad) -> v4.20-rc7 (good)

Cc-ing stable to make sure patch will be added in 4.20.y

 drivers/crypto/caam/caamhash.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 81712aa5d0f2..bb1a2cdf1951 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1072,13 +1072,16 @@ static int ahash_final_no_ctx(struct ahash_request *req)
 
 	desc = edesc->hw_desc;
 
-	state->buf_dma = dma_map_single(jrdev, buf, buflen, DMA_TO_DEVICE);
-	if (dma_mapping_error(jrdev, state->buf_dma)) {
-		dev_err(jrdev, "unable to map src\n");
-		goto unmap;
-	}
+	if (buflen) {
+		state->buf_dma = dma_map_single(jrdev, buf, buflen,
+						DMA_TO_DEVICE);
+		if (dma_mapping_error(jrdev, state->buf_dma)) {
+			dev_err(jrdev, "unable to map src\n");
+			goto unmap;
+		}
 
-	append_seq_in_ptr(desc, state->buf_dma, buflen, 0);
+		append_seq_in_ptr(desc, state->buf_dma, buflen, 0);
+	}
 
 	edesc->dst_dma = map_seq_out_ptr_result(desc, jrdev, req->result,
 						digestsize);
-- 
2.16.2
