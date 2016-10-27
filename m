From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: [PATCH stable 3.10.y 12/18] crypto: af_alg - Forbid bind(2) when nokey child sockets are present
Date: Thu, 27 Oct 2016 17:29:45 +0300
Message-ID: <1477578591-28924-13-git-send-email-aryabinin@virtuozzo.com>
References: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        <linux-crypto@vger.kernel.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>
To: Willy Tarreau <w@1wt.eu>, <stable@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1477578591-28924-1-git-send-email-aryabinin@virtuozzo.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

commit a6a48c565f6f112c6983e2a02b1602189ed6e26e upstream.

This patch forbids the calling of bind(2) when there are child
sockets created by accept(2) in existence, even if they are created
on the nokey path.

This is needed as those child sockets have references to the tfm
object which bind(2) will destroy.

Cc: stable@vger.kernel.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
---
 crypto/af_alg.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 2f8fd84..68ec1ac 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -130,19 +130,16 @@ EXPORT_SYMBOL_GPL(af_alg_release);
 void af_alg_release_parent(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
-	bool last;
+	unsigned int nokey = ask->nokey_refcnt;
+	bool last = nokey && !ask->refcnt;
 
 	sk = ask->parent;
-
-	if (ask->nokey_refcnt && !ask->refcnt) {
-		sock_put(sk);
-		return;
-	}
-
 	ask = alg_sk(sk);
 
 	lock_sock(sk);
-	last = !--ask->refcnt;
+	ask->nokey_refcnt -= nokey;
+	if (!last)
+		last = !--ask->refcnt;
 	release_sock(sk);
 
 	if (last)
@@ -185,7 +182,7 @@ static int alg_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 
 	err = -EBUSY;
 	lock_sock(sk);
-	if (ask->refcnt)
+	if (ask->refcnt | ask->nokey_refcnt)
 		goto unlock;
 
 	swap(ask->type, type);
@@ -296,6 +293,7 @@ int af_alg_accept(struct sock *sk, struct socket *newsock)
 
 	if (nokey || !ask->refcnt++)
 		sock_hold(sk);
+	ask->nokey_refcnt += nokey;
 	alg_sk(sk2)->parent = sk;
 	alg_sk(sk2)->type = type;
 	alg_sk(sk2)->nokey_refcnt = nokey;
-- 
2.7.3
