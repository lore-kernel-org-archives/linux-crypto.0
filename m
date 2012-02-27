From: Phil Sutter <phil.sutter@viprinet.com>
Subject: [PATCH] crypto: mv_cesa - fix final callback not ignoring input data
Date: Mon, 27 Feb 2012 12:17:04 +0100
Message-ID: <1330341424-27438-1-git-send-email-phil.sutter@viprinet.com>
References: <20120225073806.GA19079@gondor.apana.org.au>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, <stable@kernel.org>,
	#@zimbra.vipri.net, 3.0+@zimbra.vipri.net
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:37150 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886Ab2B0L0z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Feb 2012 06:26:55 -0500
In-Reply-To: <20120225073806.GA19079@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Broken by commit 6ef84509f3d439ed2d43ea40080643efec37f54f for users
passing a request with non-zero 'nbytes' field, like e.g. testmgr.

Cc: <stable@kernel.org> # 3.0+
Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
---
 drivers/crypto/mv_cesa.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 597235a..0d40cf6 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -714,6 +714,7 @@ static int mv_hash_final(struct ahash_request *req)
 {
 	struct mv_req_hash_ctx *ctx = ahash_request_ctx(req);
 
+	ahash_request_set_crypt(req, NULL, req->result, 0);
 	mv_update_hash_req_ctx(ctx, 1, 0);
 	return mv_handle_req(&req->base);
 }
-- 
1.7.3.4
