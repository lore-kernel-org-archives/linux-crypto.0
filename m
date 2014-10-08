From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 1/2] crypto: qat - Prevent dma mapping zero length assoc data.
Date: Wed, 08 Oct 2014 10:38:47 -0700
Message-ID: <20141008173847.13714.98215.stgit@tstruk-mobl1>
References: <20141008173750.13714.49713.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: prarit@redhat.com, bruce.w.allan@intel.com, qat-linux@intel.com,
	john.griffin@intel.com, linux-crypto@vger.kernel.org,
	naleksan@redhat.com, davem@davemloft.net
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:57810 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbaJHRqn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Oct 2014 13:46:43 -0400
In-Reply-To: <20141008173750.13714.49713.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Do not attempt to dma map associated data if it is zero length.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/qat_algs.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index e03afe9..bffa8bf 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -607,6 +607,8 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 		goto err;
 
 	for_each_sg(assoc, sg, assoc_n, i) {
+		if (!sg->length)
+			continue;
 		bufl->bufers[bufs].addr = dma_map_single(dev,
 							 sg_virt(sg),
 							 sg->length,
