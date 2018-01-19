From: Harsh Jain <harsh@chelsio.com>
Subject: [PATCH 1/1] crypto: chelsio - Fix indentation warning
Date: Fri, 19 Jan 2018 11:09:58 +0530
Message-ID: <a78e3da6475cd66a42d2fe8763daa22d2da8200f.1516339759.git.harsh@chelsio.com>
References: <cover.1516339759.git.harsh@chelsio.com>
Cc: Harsh Jain <harsh@chelsio.com>
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        sfr@canb.auug.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:10193 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750722AbeASFkQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jan 2018 00:40:16 -0500
In-Reply-To: <cover.1516339759.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix Warning introduced in changeset

e1a018e607a3 ("crypto: chelsio - Remove dst sg size zero check")

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Harsh Jain <harsh@chelsio.com>
---
 drivers/crypto/chelsio/chcr_algo.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index a9c894b..34a02d6 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -2112,11 +2112,11 @@ static struct sk_buff *create_authenc_wr(struct aead_request *req,
 	error = chcr_aead_common_init(req, op_type);
 	if (error)
 		return ERR_PTR(error);
-		dnents = sg_nents_xlen(req->dst, assoclen, CHCR_DST_SG_SIZE, 0);
-		dnents += sg_nents_xlen(req->dst, req->cryptlen +
-			(op_type ? -authsize : authsize), CHCR_DST_SG_SIZE,
-			req->assoclen);
-		dnents += MIN_AUTH_SG; // For IV
+	dnents = sg_nents_xlen(req->dst, assoclen, CHCR_DST_SG_SIZE, 0);
+	dnents += sg_nents_xlen(req->dst, req->cryptlen +
+		(op_type ? -authsize : authsize), CHCR_DST_SG_SIZE,
+		req->assoclen);
+	dnents += MIN_AUTH_SG; // For IV
 
 	dst_size = get_space_for_phys_dsgl(dnents);
 	kctx_len = (ntohl(KEY_CONTEXT_CTX_LEN_V(aeadctx->key_ctx_hdr)) << 4)
-- 
2.1.4
