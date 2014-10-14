From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH v2 1/2] crypto: qat - Prevent dma mapping zero length assoc
 data
Date: Mon, 13 Oct 2014 18:24:26 -0700
Message-ID: <20141014012426.742.51263.stgit@tstruk-mobl1>
References: <20141014012251.742.5500.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: prarit@redhat.com, bruce.w.allan@intel.com, qat-linux@intel.com,
	naleksan@redhat.com, linux-crypto@vger.kernel.org,
	davem@davemloft.net
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:38033 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbaJNB0a (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Oct 2014 21:26:30 -0400
In-Reply-To: <20141014012251.742.5500.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Do not attempt to dma map associated data if it is zero length.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 3e26fa2..bd4bd27 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -608,6 +608,8 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 		goto err;
 
 	for_each_sg(assoc, sg, assoc_n, i) {
+		if (!sg->length)
+			continue;
 		bufl->bufers[bufs].addr = dma_map_single(dev,
 							 sg_virt(sg),
 							 sg->length,
