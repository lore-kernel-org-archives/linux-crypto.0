From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch 1/2] crypto: mxc-scc - signedness bugs in
 mxc_scc_ablkcipher_req_init()
Date: Fri, 22 Apr 2016 12:56:31 +0300
Message-ID: <20160422095631.GC11398@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

->src_nents and ->dst_nents are unsigned so they can't be less than
zero.  I fixed this by introducing a temporary "nents" variable.

Fixes: d293b640ebd5 ('crypto: mxc-scc - add basic driver for the MXC SCC')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/crypto/mxc-scc.c b/drivers/crypto/mxc-scc.c
index 38b01bf..9b348a7 100644
--- a/drivers/crypto/mxc-scc.c
+++ b/drivers/crypto/mxc-scc.c
@@ -210,18 +210,21 @@ static int mxc_scc_ablkcipher_req_init(struct ablkcipher_request *req,
 				       struct mxc_scc_ctx *ctx)
 {
 	struct mxc_scc *scc = ctx->scc;
+	int nents;
 
-	ctx->src_nents = sg_nents_for_len(req->src, req->nbytes);
-	if (ctx->src_nents < 0) {
+	nents = sg_nents_for_len(req->src, req->nbytes);
+	if (nents < 0) {
 		dev_err(scc->dev, "Invalid number of src SC");
-		return ctx->src_nents;
+		return nents;
 	}
+	ctx->src_nents = nents;
 
-	ctx->dst_nents = sg_nents_for_len(req->dst, req->nbytes);
-	if (ctx->dst_nents < 0) {
+	nents = sg_nents_for_len(req->dst, req->nbytes);
+	if (nents < 0) {
 		dev_err(scc->dev, "Invalid number of dst SC");
-		return ctx->dst_nents;
+		return nents;
 	}
+	ctx->dst_nents = nents;
 
 	ctx->size = 0;
 	ctx->offset = 0;
