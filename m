From: Phil Sutter <phil.sutter@viprinet.com>
Subject: [PATCH 01/10] mv_cesa: use ablkcipher_request_cast instead of the manual container_of
Date: Thu,  5 May 2011 15:28:57 +0200
Message-ID: <1304602146-5918-1-git-send-email-phil.sutter@viprinet.com>
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.vipri.net ([89.207.250.2]:41403 "EHLO mail.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937Ab1EENjp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 May 2011 09:39:45 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
---
 drivers/crypto/mv_cesa.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index c99305a..c443246 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -603,9 +603,7 @@ static int queue_manag(void *data)
 			if (async_req->tfm->__crt_alg->cra_type !=
 			    &crypto_ahash_type) {
 				struct ablkcipher_request *req =
-				    container_of(async_req,
-						 struct ablkcipher_request,
-						 base);
+				    ablkcipher_request_cast(async_req);
 				mv_start_new_crypt_req(req);
 			} else {
 				struct ahash_request *req =
-- 
1.7.4.1
