From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH 4/4]     crypto: algif_skcipher - Fix race condition in skcipher_check_key
Date: Fri, 26 Feb 2016 12:44:11 +0100
Message-ID: <1456487051-14652-4-git-send-email-gmazyland@gmail.com>
References: <56D0361B.8040301@gmail.com>
 <1456487051-14652-1-git-send-email-gmazyland@gmail.com>
Cc: stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1456487051-14652-1-git-send-email-gmazyland@gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

    commit 1822793a523e5d5730b19cc21160ff1717421bc8 upstream.

    We need to lock the child socket in skcipher_check_key as otherwise
    two simultaneous calls can cause the parent socket to be freed.

    Cc: stable@vger.kernel.org
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/algif_skcipher.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 83bcf75..c0f0356 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -757,22 +757,23 @@ static struct proto_ops algif_skcipher_ops = {
 
 static int skcipher_check_key(struct socket *sock)
 {
-	int err;
+	int err = 0;
 	struct sock *psk;
 	struct alg_sock *pask;
 	struct skcipher_tfm *tfm;
 	struct sock *sk = sock->sk;
 	struct alg_sock *ask = alg_sk(sk);
 
+	lock_sock(sk);
 	if (ask->refcnt)
-		return 0;
+		goto unlock_child;
 
 	psk = ask->parent;
 	pask = alg_sk(ask->parent);
 	tfm = pask->private;
 
 	err = -ENOKEY;
-	lock_sock(psk);
+	lock_sock_nested(psk, SINGLE_DEPTH_NESTING);
 	if (!tfm->has_key)
 		goto unlock;
 
@@ -786,6 +787,8 @@ static int skcipher_check_key(struct socket *sock)
 
 unlock:
 	release_sock(psk);
+unlock_child:
+	release_sock(sk);
 
 	return err;
 }
-- 
2.7.0
