From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH 2/2] crypto: marvell/cesa - initialize hash states
Date: Thu, 17 Mar 2016 10:21:35 +0100
Message-ID: <1458206495-11369-2-git-send-email-boris.brezillon@free-electrons.com>
References: <1458206495-11369-1-git-send-email-boris.brezillon@free-electrons.com>
Cc: Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Romain Perier <romain.perier@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Boris Brezillon <boris.brezillon@free-electrons.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1458206495-11369-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

->export() might be called before we have done an update operation,
and in this case the ->state field is left uninitialized.
Put the correct default value when initializing the request.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/crypto/marvell/hash.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index f07c1fa..7ca2e0f 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -810,9 +810,14 @@ static int mv_cesa_ahash_import(struct ahash_request *req, const void *hash,
 
 static int mv_cesa_md5_init(struct ahash_request *req)
 {
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
 	struct mv_cesa_op_ctx tmpl = { };
 
 	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_MD5);
+	creq->state[0] = MD5_H0;
+	creq->state[1] = MD5_H1;
+	creq->state[2] = MD5_H2;
+	creq->state[3] = MD5_H3;
 
 	mv_cesa_ahash_init(req, &tmpl, true);
 
@@ -873,9 +878,15 @@ struct ahash_alg mv_md5_alg = {
 
 static int mv_cesa_sha1_init(struct ahash_request *req)
 {
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
 	struct mv_cesa_op_ctx tmpl = { };
 
 	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_SHA1);
+	creq->state[0] = SHA1_H0;
+	creq->state[1] = SHA1_H1;
+	creq->state[2] = SHA1_H2;
+	creq->state[3] = SHA1_H3;
+	creq->state[4] = SHA1_H4;
 
 	mv_cesa_ahash_init(req, &tmpl, false);
 
@@ -936,9 +947,18 @@ struct ahash_alg mv_sha1_alg = {
 
 static int mv_cesa_sha256_init(struct ahash_request *req)
 {
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
 	struct mv_cesa_op_ctx tmpl = { };
 
 	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_SHA256);
+	creq->state[0] = SHA256_H0;
+	creq->state[1] = SHA256_H1;
+	creq->state[2] = SHA256_H2;
+	creq->state[3] = SHA256_H3;
+	creq->state[4] = SHA256_H4;
+	creq->state[5] = SHA256_H5;
+	creq->state[6] = SHA256_H6;
+	creq->state[7] = SHA256_H7;
 
 	mv_cesa_ahash_init(req, &tmpl, false);
 
-- 
2.5.0
