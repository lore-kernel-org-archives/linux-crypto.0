From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 1/3] crypto: ensure algif_hash does not pass a zero-sized
 state
Date: Fri, 09 Oct 2015 11:29:44 +0100
Message-ID: <E1ZkUvo-0004QO-U8@rmk-PC.arm.linux.org.uk>
References: <20151009102904.GL32532@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:50052 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965448AbbJIK3u (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Oct 2015 06:29:50 -0400
In-Reply-To: <20151009102904.GL32532@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If the algorithm passed a zero statesize, do not pass a valid pointer
into the export/import functions.  Passing a valid pointer covers up
bugs in driver code which then go on to smash the kernel stack.
Instead, pass NULL, which will cause any attempt to write to the
pointer to fail.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 crypto/algif_hash.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 1396ad0787fc..f450584cb940 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -177,12 +177,16 @@ static int hash_accept(struct socket *sock, struct socket *newsock, int flags)
 	struct alg_sock *ask = alg_sk(sk);
 	struct hash_ctx *ctx = ask->private;
 	struct ahash_request *req = &ctx->req;
-	char state[crypto_ahash_statesize(crypto_ahash_reqtfm(req))];
+	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
+	unsigned int state_size = crypto_ahash_statesize(ahash);
+	char state_buf[state_size], *state;
 	struct sock *sk2;
 	struct alg_sock *ask2;
 	struct hash_ctx *ctx2;
 	int err;
 
+	state = state_size ? state_buf : NULL;
+
 	err = crypto_ahash_export(req, state);
 	if (err)
 		return err;
-- 
2.1.0
