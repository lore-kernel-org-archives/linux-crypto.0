Return-Path: <SRS0=+HSe=PS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727558AbfAJUSY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Jan 2019 15:18:24 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 11/11] crypto: af_alg - remove redundant initializations of sk_family
Date: Thu, 10 Jan 2019 12:18:02 -0800
Message-Id: <20190110201802.82442-12-ebiggers@kernel.org>
In-Reply-To: <20190110201802.82442-1-ebiggers@kernel.org>
References: <20190110201802.82442-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

sk_alloc() already sets sock::sk_family to PF_ALG which is passed as the
'family' argument, so there's no need to set it again.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/af_alg.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 1dd573a441279..c5937c8127999 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -302,8 +302,6 @@ int af_alg_accept(struct sock *sk, struct socket *newsock, bool kern)
 	if (err)
 		goto unlock;
 
-	sk2->sk_family = PF_ALG;
-
 	if (nokey || !ask->refcnt++)
 		sock_hold(sk);
 	ask->nokey_refcnt += nokey;
@@ -380,7 +378,6 @@ static int alg_create(struct net *net, struct socket *sock, int protocol,
 	sock->ops = &alg_proto_ops;
 	sock_init_data(sock, sk);
 
-	sk->sk_family = PF_ALG;
 	sk->sk_destruct = alg_sock_destruct;
 
 	return 0;
-- 
2.20.1.97.g81188d93c3-goog
