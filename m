From: Rui Wang <rui.y.wang@intel.com>
Subject: [PATCH v2 3/4] crypto: algif_hash - wait for crypto_ahash_init() to complete
Date: Wed, 27 Jan 2016 17:08:37 +0800
Message-ID: <1453885718-24599-4-git-send-email-rui.y.wang@intel.com>
References: <1453885718-24599-1-git-send-email-rui.y.wang@intel.com>
Cc: tim.c.chen@linux.intel.com, rui.y.wang@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453885718-24599-1-git-send-email-rui.y.wang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

hash_sendmsg/sendpage() need to wait for the completion
of crypto_ahash_init() otherwise it can cause panic.

Signed-off-by: Rui Wang <rui.y.wang@intel.com>
---
 crypto/algif_hash.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index b4c24fe..83dc095 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -49,7 +49,8 @@ static int hash_sendmsg(struct socket *sock, struct msghdr *msg,
 
 	lock_sock(sk);
 	if (!ctx->more) {
-		err = crypto_ahash_init(&ctx->req);
+		err = af_alg_wait_for_completion(crypto_ahash_init(&ctx->req),
+						&ctx->completion);
 		if (err)
 			goto unlock;
 	}
@@ -120,6 +121,7 @@ static ssize_t hash_sendpage(struct socket *sock, struct page *page,
 	} else {
 		if (!ctx->more) {
 			err = crypto_ahash_init(&ctx->req);
+			err = af_alg_wait_for_completion(err, &ctx->completion);
 			if (err)
 				goto unlock;
 		}
-- 
1.8.3.1
