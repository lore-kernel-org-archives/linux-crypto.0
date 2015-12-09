From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - ring returning retry even though ring has BW
Date: Wed, 09 Dec 2015 11:59:45 -0800
Message-ID: <20151209195945.17552.86742.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: harvijayx.saini@intel.com, linux-crypto@vger.kernel.org,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:40133 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbbLIUC7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Dec 2015 15:02:59 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Harvijay Saini <harvijayx.saini@intel.com>

When many threads submit multiple requests they get blocked until all
responses are processed, which prevents them from submitting more requests
even though there is space on the rings.
To fix this we need to decrement the inflight counter early to in the callback.

Signed-off-by: Harvijay Saini <harvijayx.saini@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_transport.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_transport.c b/drivers/crypto/qat/qat_common/adf_transport.c
index eff00cd..a6f3766 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.c
+++ b/drivers/crypto/qat/qat_common/adf_transport.c
@@ -141,6 +141,7 @@ static int adf_handle_response(struct adf_etr_ring_data *ring)
 
 	while (*msg != ADF_RING_EMPTY_SIG) {
 		ring->callback((uint32_t *)msg);
+		atomic_dec(ring->inflights);
 		*msg = ADF_RING_EMPTY_SIG;
 		ring->head = adf_modulo(ring->head +
 					ADF_MSG_SIZE_TO_BYTES(ring->msg_size),
@@ -148,12 +149,10 @@ static int adf_handle_response(struct adf_etr_ring_data *ring)
 		msg_counter++;
 		msg = (uint32_t *)((uintptr_t)ring->base_addr + ring->head);
 	}
-	if (msg_counter > 0) {
+	if (msg_counter > 0)
 		WRITE_CSR_RING_HEAD(ring->bank->csr_addr,
 				    ring->bank->bank_number,
 				    ring->ring_number, ring->head);
-		atomic_sub(msg_counter, ring->inflights);
-	}
 	return 0;
 }
 
