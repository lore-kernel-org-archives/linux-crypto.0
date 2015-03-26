From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch -next] crypto: algif - signedness bug in
 skcipher_recvmsg_async()
Date: Thu, 26 Mar 2015 12:13:12 +0300
Message-ID: <20150326091312.GA21084@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This needs to be signed because af_alg_make_sg() returns negative error
codes.

Fixes: a596999b7ddf ('crypto: algif - change algif_skcipher to be asynchronous')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 506eb5f..142430f 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -537,7 +537,7 @@ static int skcipher_recvmsg_async(struct socket *sock, struct msghdr *msg,
 
 	while (iov_iter_count(&msg->msg_iter)) {
 		struct skcipher_async_rsgl *rsgl;
-		unsigned long used;
+		long used;
 
 		if (!ctx->used) {
 			err = skcipher_wait_for_data(sk, flags);
