From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 2/6] crypto: caam: avoid needlessly saving and restoring
 caam_hash_ctx
Date: Sun, 18 Oct 2015 17:51:15 +0100
Message-ID: <E1ZnrAx-0005nL-OT@rmk-PC.arm.linux.org.uk>
References: <20151018165046.GA7997@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Victoria Milhoan <vicki.milhoan@freescale.com>,
	horia.geanta@freescale.com, fabio.estevam@freescale.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:45355 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081AbbJRQvY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Oct 2015 12:51:24 -0400
In-Reply-To: <20151018165046.GA7997@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When exporting and importing the hash state, we will only export and
import into hashes which share the same struct crypto_ahash pointer.
(See hash_accept->af_alg_accept->hash_accept_parent.)

This means that saving the caam_hash_ctx structure on export, and
restoring it on import is a waste of resources.  So, remove this code.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/caam/caamhash.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 2faf71ccbd43..3ce6083c2e43 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1575,24 +1575,20 @@ static int ahash_final(struct ahash_request *req)
 static int ahash_export(struct ahash_request *req, void *out)
 {
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
-	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 
-	memcpy(out, ctx, sizeof(struct caam_hash_ctx));
-	memcpy(out + sizeof(struct caam_hash_ctx), state,
-	       sizeof(struct caam_hash_state));
+	memcpy(out, state, sizeof(struct caam_hash_state));
+
 	return 0;
 }
 
 static int ahash_import(struct ahash_request *req, const void *in)
 {
 	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
-	struct caam_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct caam_hash_state *state = ahash_request_ctx(req);
 
-	memcpy(ctx, in, sizeof(struct caam_hash_ctx));
-	memcpy(state, in + sizeof(struct caam_hash_ctx),
-	       sizeof(struct caam_hash_state));
+	memcpy(state, in, sizeof(struct caam_hash_state));
+
 	return 0;
 }
 
-- 
2.1.0
