From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH 7/7] crypto: marvell - Don't hardcode block size in mv_cesa_ahash_cache_req
Date: Tue,  9 Aug 2016 11:03:20 +0200
Message-ID: <1470733400-23621-8-git-send-email-romain.perier@free-electrons.com>
References: <1470733400-23621-1-git-send-email-romain.perier@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	Russell King <linux@arm.linux.org.uk>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:39693 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751914AbcHIJDk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 05:03:40 -0400
In-Reply-To: <1470733400-23621-1-git-send-email-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Don't use 64 'as is', as max block size in mv_cesa_ahash_cache_req. Use
CESA_MAX_HASH_BLOCK_SIZE instead, this is better for readability.

Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
---
 drivers/crypto/marvell/hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index 44a8abe..9f28468 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -408,7 +408,7 @@ static bool mv_cesa_ahash_cache_req(struct ahash_request *req)
 	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
 	bool cached = false;
 
-	if (creq->cache_ptr + req->nbytes < 64 && !creq->last_req) {
+	if (creq->cache_ptr + req->nbytes < CESA_MAX_HASH_BLOCK_SIZE && !creq->last_req) {
 		cached = true;
 
 		if (!req->nbytes)
-- 
2.8.1
