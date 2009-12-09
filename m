From: Martin Willi <martin@strongswan.org>
Subject: [PATCH] xfrm: Fix truncation length of authentication algorithms installed via PF_KEY
Date: Wed,  9 Dec 2009 17:11:15 +0100
Message-ID: <1260375075-16187-1-git-send-email-martin@strongswan.org>
Cc: netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zaes.ch ([213.133.111.41]:59257 "EHLO zaes.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756117AbZLIQLW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Dec 2009 11:11:22 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Commit 4447bb33f09444920a8f1d89e1540137429351b6 breaks installation of
authentication algorithms via PF_KEY, as the state specific truncation
length is not installed with the algorithms default truncation length.
This patch initializes state properly to the default if installed via
PF_KEY.

Signed-off-by: Martin Willi <martin@strongswan.org>
---
 net/key/af_key.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 84209fb..76fa6fe 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1193,6 +1193,7 @@ static struct xfrm_state * pfkey_msg2xfrm_state(struct net *net,
 			x->aalg->alg_key_len = key->sadb_key_bits;
 			memcpy(x->aalg->alg_key, key+1, keysize);
 		}
+		x->aalg->alg_trunc_len = a->uinfo.auth.icv_truncbits;
 		x->props.aalgo = sa->sadb_sa_auth;
 		/* x->algo.flags = sa->sadb_sa_flags; */
 	}
-- 
1.6.3.3

