From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH] crypto: dh - Consistenly return negative error codes
Date: Tue,  8 Nov 2016 15:48:22 -0800
Message-ID: <20161108234822.29320-1-mathew.j.martineau@linux.intel.com>
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>,
        salvatore.benedetto@intel.com
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:62187 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751597AbcKHXs2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Nov 2016 18:48:28 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix the single instance where a positive EINVAL was returned.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 crypto/dh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/dh.c b/crypto/dh.c
index 9d19360..ddcb528 100644
--- a/crypto/dh.c
+++ b/crypto/dh.c
@@ -118,7 +118,7 @@ static int dh_compute_value(struct kpp_request *req)
 	if (req->src) {
 		base = mpi_read_raw_from_sgl(req->src, req->src_len);
 		if (!base) {
-			ret = EINVAL;
+			ret = -EINVAL;
 			goto err_free_val;
 		}
 	} else {
-- 
2.10.2
