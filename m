From: Romain Perier <romain.perier@free-electrons.com>
Subject: [PATCH 6/7] crypto: marvell - Don't overwrite default creq->state during initialization
Date: Tue,  9 Aug 2016 11:03:19 +0200
Message-ID: <1470733400-23621-7-git-send-email-romain.perier@free-electrons.com>
References: <1470733400-23621-1-git-send-email-romain.perier@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	"David S. Miller" <davem@davemloft.net>,
	Russell King <linux@arm.linux.org.uk>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:39688 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752214AbcHIJDj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 05:03:39 -0400
In-Reply-To: <1470733400-23621-1-git-send-email-romain.perier@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently, in mv_cesa_{md5,sha1,sha256}_init creq->state is initialized
before the call to mv_cesa_ahash_init. This is wrong because this
function fills creq with zero by using memset, so its 'state' that
contains the default DIGEST is overwritten. This commit fixes the issue
by initializing creq->state just after the call to mv_cesa_ahash_init.

Fixes: commit b0ef51067cb4 ("crypto: marvell/cesa - initialize hash...")
Signed-off-by: Romain Perier <romain.perier@free-electrons.com>
---
 drivers/crypto/marvell/hash.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index cf8063d..44a8abe 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -800,13 +800,14 @@ static int mv_cesa_md5_init(struct ahash_request *req)
 	struct mv_cesa_op_ctx tmpl = { };
 
 	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_MD5);
+
+	mv_cesa_ahash_init(req, &tmpl, true);
+
 	creq->state[0] = MD5_H0;
 	creq->state[1] = MD5_H1;
 	creq->state[2] = MD5_H2;
 	creq->state[3] = MD5_H3;
 
-	mv_cesa_ahash_init(req, &tmpl, true);
-
 	return 0;
 }
 
@@ -868,14 +869,15 @@ static int mv_cesa_sha1_init(struct ahash_request *req)
 	struct mv_cesa_op_ctx tmpl = { };
 
 	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_SHA1);
+
+	mv_cesa_ahash_init(req, &tmpl, false);
+
 	creq->state[0] = SHA1_H0;
 	creq->state[1] = SHA1_H1;
 	creq->state[2] = SHA1_H2;
 	creq->state[3] = SHA1_H3;
 	creq->state[4] = SHA1_H4;
 
-	mv_cesa_ahash_init(req, &tmpl, false);
-
 	return 0;
 }
 
@@ -937,6 +939,9 @@ static int mv_cesa_sha256_init(struct ahash_request *req)
 	struct mv_cesa_op_ctx tmpl = { };
 
 	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_SHA256);
+
+	mv_cesa_ahash_init(req, &tmpl, false);
+
 	creq->state[0] = SHA256_H0;
 	creq->state[1] = SHA256_H1;
 	creq->state[2] = SHA256_H2;
@@ -946,8 +951,6 @@ static int mv_cesa_sha256_init(struct ahash_request *req)
 	creq->state[6] = SHA256_H6;
 	creq->state[7] = SHA256_H7;
 
-	mv_cesa_ahash_init(req, &tmpl, false);
-
 	return 0;
 }
 
-- 
2.8.1
