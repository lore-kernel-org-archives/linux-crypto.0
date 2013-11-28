From: Richard Weinberger <richard@nod.at>
Subject: [PATCH] crypto: AF_ALG: Check for MSG_SENDPAGE_NOTLAST
Date: Thu, 28 Nov 2013 18:30:32 +0100
Message-ID: <1385659832-14911-1-git-send-email-richard@nod.at>
Cc: shawnlandden@gmail.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Richard Weinberger <richard@nod.at>,
	Tom Herbert <therbert@google.com>,
	Eric Dumazet <eric.dumazet@gmail.com>, <stable@vger.kernel.org>
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Commit 35f9c09fe (tcp: tcp_sendpages() should call tcp_push() once)
added an internal flag MSG_SENDPAGE_NOTLAST.
We have to check for MSG_SENDPAGE_NOTLAST too to find out whether more data
is available.

Cc: Tom Herbert <therbert@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: <stable@vger.kernel.org> # 3.2.x
Reported-and-tested-by: Shawn Landden <shawnlandden@gmail.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 crypto/algif_hash.c     | 3 +++
 crypto/algif_skcipher.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index ef5356c..8502462 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -114,6 +114,9 @@ static ssize_t hash_sendpage(struct socket *sock, struct page *page,
 	struct hash_ctx *ctx = ask->private;
 	int err;
 
+	if (flags & MSG_SENDPAGE_NOTLAST)
+		flags |= MSG_MORE;
+
 	lock_sock(sk);
 	sg_init_table(ctx->sgl.sg, 1);
 	sg_set_page(ctx->sgl.sg, page, size, offset);
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 6a6dfc0..a19c027 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -378,6 +378,9 @@ static ssize_t skcipher_sendpage(struct socket *sock, struct page *page,
 	struct skcipher_sg_list *sgl;
 	int err = -EINVAL;
 
+	if (flags & MSG_SENDPAGE_NOTLAST)
+		flags |= MSG_MORE;
+
 	lock_sock(sk);
 	if (!ctx->more && ctx->used)
 		goto unlock;
-- 
1.8.4.2
