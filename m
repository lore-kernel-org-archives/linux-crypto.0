From: Marek Vasut <marex@denx.de>
Subject: [PATCH] [RFC] crypto: cesa: Don't use tfm->__crt_alg->cra_type directly
Date: Wed, 14 May 2014 11:42:52 +0200
Message-ID: <1400060572-11692-1-git-send-email-marex@denx.de>
Cc: herbert@gondor.apana.org.au, Marek Vasut <marex@denx.de>,
	Bill Pemberton <wfp5p@virginia.edu>,
	Kent Yoder <key@linux.vnet.ibm.com>,
	Jamie Iles <jamie@jamieiles.com>,
	Phil Sutter <phil.sutter@viprinet.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:43844 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbaENJmx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 May 2014 05:42:53 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The checking for the type of algorithm implementation is pretty
strange here. Use regular flags to check for the type instead.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Bill Pemberton <wfp5p@virginia.edu>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kent Yoder <key@linux.vnet.ibm.com>
Cc: Jamie Iles <jamie@jamieiles.com>
Cc: Phil Sutter <phil.sutter@viprinet.com>
---
 drivers/crypto/mv_cesa.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

NOTE: I am not sure this is correct, please review proper.

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 1549db7..29d0ee5 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -622,8 +622,8 @@ static int queue_manag(void *data)
 		}
 
 		if (async_req) {
-			if (async_req->tfm->__crt_alg->cra_type !=
-			    &crypto_ahash_type) {
+			if (crypto_tfm_alg_type(async_req->tfm) !=
+			    CRYPTO_ALG_TYPE_AHASH) {
 				struct ablkcipher_request *req =
 				    ablkcipher_request_cast(async_req);
 				mv_start_new_crypt_req(req);
-- 
2.0.0.rc0
