From: Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] crypto: algif_hash - correctly handle algos without state
Date: Tue, 23 Feb 2016 12:01:56 -0500
Message-ID: <1456246916-16130-1-git-send-email-sasha.levin@oracle.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Sasha Levin <sasha.levin@oracle.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17144 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbcBWRCJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Feb 2016 12:02:09 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Algorithms without state will cause the creation of a 0 sized array, which
is undefined outside of structs.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 crypto/algif_hash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 68a5cea..a9f923f 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -184,7 +184,7 @@ static int hash_accept(struct socket *sock, struct socket *newsock, int flags)
 	struct alg_sock *ask = alg_sk(sk);
 	struct hash_ctx *ctx = ask->private;
 	struct ahash_request *req = &ctx->req;
-	char state[crypto_ahash_statesize(crypto_ahash_reqtfm(req))];
+	char state[crypto_ahash_statesize(crypto_ahash_reqtfm(req))?:1];
 	struct sock *sk2;
 	struct alg_sock *ask2;
 	struct hash_ctx *ctx2;
-- 
1.7.10.4
