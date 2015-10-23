From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 11/11] crypto: algif: Change some variable to size_t
Date: Fri, 23 Oct 2015 14:10:36 +0200
Message-ID: <1445602236-24130-12-git-send-email-clabbe.montjoie@gmail.com>
References: <1445602236-24130-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445602236-24130-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Some variable are set as int but store only positive values.
Furthermore there are used in operation/function that wait for unsigned
value.
This patch set them as size_t.

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 crypto/algif_aead.c     |  6 +++---
 crypto/algif_skcipher.c | 10 +++++-----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 0aa6fdf..f70bcf8 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -213,7 +213,7 @@ static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	}
 
 	while (size) {
-		unsigned long len = size;
+		size_t len = size;
 		struct scatterlist *sg = NULL;
 
 		/* use the existing memory in an allocated page */
@@ -247,7 +247,7 @@ static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 		/* allocate a new page */
 		len = min_t(unsigned long, size, aead_sndbuf(sk));
 		while (len) {
-			int plen = 0;
+			size_t plen = 0;
 
 			if (sgl->cur >= ALG_MAX_PAGES) {
 				aead_put_sgl(sk);
@@ -256,7 +256,7 @@ static int aead_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 			}
 
 			sg = sgl->sg + sgl->cur;
-			plen = min_t(int, len, PAGE_SIZE);
+			plen = min_t(size_t, len, PAGE_SIZE);
 
 			sg_assign_page(sg, alloc_page(GFP_KERNEL));
 			err = -ENOMEM;
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index af31a0e..bbb1b66 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -40,7 +40,7 @@ struct skcipher_ctx {
 	struct af_alg_completion completion;
 
 	atomic_t inflight;
-	unsigned used;
+	size_t used;
 
 	unsigned int len;
 	bool more;
@@ -153,7 +153,7 @@ static int skcipher_alloc_sgl(struct sock *sk)
 	return 0;
 }
 
-static void skcipher_pull_sgl(struct sock *sk, int used, int put)
+static void skcipher_pull_sgl(struct sock *sk, size_t used, int put)
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct skcipher_ctx *ctx = ask->private;
@@ -167,7 +167,7 @@ static void skcipher_pull_sgl(struct sock *sk, int used, int put)
 		sg = sgl->sg;
 
 		for (i = 0; i < sgl->cur; i++) {
-			int plen = min_t(int, used, sg[i].length);
+			size_t plen = min_t(size_t, used, sg[i].length);
 
 			if (!sg_page(sg + i))
 				continue;
@@ -348,7 +348,7 @@ static int skcipher_sendmsg(struct socket *sock, struct msghdr *msg,
 	while (size) {
 		struct scatterlist *sg;
 		unsigned long len = size;
-		int plen;
+		size_t plen;
 
 		if (ctx->merge) {
 			sgl = list_entry(ctx->tsgl.prev,
@@ -390,7 +390,7 @@ static int skcipher_sendmsg(struct socket *sock, struct msghdr *msg,
 		sg_unmark_end(sg + sgl->cur);
 		do {
 			i = sgl->cur;
-			plen = min_t(int, len, PAGE_SIZE);
+			plen = min_t(size_t, len, PAGE_SIZE);
 
 			sg_assign_page(sg + i, alloc_page(GFP_KERNEL));
 			err = -ENOMEM;
-- 
2.4.10
