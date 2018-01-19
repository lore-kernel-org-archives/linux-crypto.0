From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: chelsio - fix code indentation warning
Date: Fri, 19 Jan 2018 15:58:47 +0100
Message-ID: <20180119145853.1221026-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Atul Gupta <atul.gupta@chelsio.com>,
        Ganesh Goudar <ganeshgr@chelsio.com>,
        Colin Ian King <colin.king@canonical.com>,
        Yeshaswi M R Gowda <yeshaswi@chelsio.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Harsh Jain <harsh@chelsio.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

gcc noticed some unusual and confusing indentation:

drivers/crypto/chelsio/chcr_algo.c: In function 'create_authenc_wr':
drivers/crypto/chelsio/chcr_algo.c:2113:2: error: this 'if' clause does not guard... [-Werror=misleading-indentation]
  if (error)
  ^~
drivers/crypto/chelsio/chcr_algo.c:2115:3: note: ...this statement, but the latter is misleadingly indented as if it were guarded by the 'if'
   dnents = sg_nents_xlen(req->dst, assoclen, CHCR_DST_SG_SIZE, 0);

The patch that changed it reindented one function with the same code
but not this one, so let's do the same here.

Fixes: e1a018e607a3 ("crypto: chelsio - Remove dst sg size zero check")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/chelsio/chcr_algo.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
index a9c894bf9c01..4b138c41bdfb 100644
--- a/drivers/crypto/chelsio/chcr_algo.c
+++ b/drivers/crypto/chelsio/chcr_algo.c
@@ -2112,11 +2112,11 @@ static struct sk_buff *create_authenc_wr(struct aead_request *req,
 	error = chcr_aead_common_init(req, op_type);
 	if (error)
 		return ERR_PTR(error);
-		dnents = sg_nents_xlen(req->dst, assoclen, CHCR_DST_SG_SIZE, 0);
-		dnents += sg_nents_xlen(req->dst, req->cryptlen +
+	dnents = sg_nents_xlen(req->dst, assoclen, CHCR_DST_SG_SIZE, 0);
+	dnents += sg_nents_xlen(req->dst, req->cryptlen +
 			(op_type ? -authsize : authsize), CHCR_DST_SG_SIZE,
 			req->assoclen);
-		dnents += MIN_AUTH_SG; // For IV
+	dnents += MIN_AUTH_SG; // For IV
 
 	dst_size = get_space_for_phys_dsgl(dnents);
 	kctx_len = (ntohl(KEY_CONTEXT_CTX_LEN_V(aeadctx->key_ctx_hdr)) << 4)
-- 
2.9.0
