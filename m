From: Phil Sutter <phil.sutter@viprinet.com>
Subject: [PATCH 03/10] mv_cesa: drop this call to mv_hash_final from mv_hash_finup
Date: Thu,  5 May 2011 15:28:59 +0200
Message-ID: <1304602146-5918-3-git-send-email-phil.sutter@viprinet.com>
References: <1304602146-5918-1-git-send-email-phil.sutter@viprinet.com>
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.vipri.net ([89.207.250.2]:51741 "EHLO mail.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009Ab1EENjp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 May 2011 09:39:45 -0400
In-Reply-To: <1304602146-5918-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The code in mv_hash_final is actually a superset of mv_hash_finup's
body. Since the driver works fine without, drop it.

Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
---
 drivers/crypto/mv_cesa.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 889c098..4aac294 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -728,9 +728,6 @@ static int mv_hash_final(struct ahash_request *req)
 
 static int mv_hash_finup(struct ahash_request *req)
 {
-	if (!req->nbytes)
-		return mv_hash_final(req);
-
 	mv_update_hash_req_ctx(ahash_request_ctx(req), 1, req->nbytes);
 	return mv_handle_req(&req->base);
 }
-- 
1.7.4.1
