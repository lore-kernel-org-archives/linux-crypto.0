From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH] crypto: AF_ALG - fix memory management of aio with multiple iocbs
Date: Tue, 13 Dec 2016 21:42:45 +0100
Message-ID: <4632372.rm33NXUfDp@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:39258 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965828AbcLMUnn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Dec 2016 15:43:43 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

I am sorry to interrupt your merge window, but may I ask to consider
this patch for the current development cycle as well as for stable
back to v4.1 where the algif_skcipher AIO support was added?
It fixes the two bug reports which I reported back in September
that allow crashing the kernel from user space as an unprivileged
user. I think that this patch now fixes the real issue and not just
papers things over.

The fix can be validated using the following invocation from [1].

test/kcapi -d 2 -x 9 -e -c "cbc(aes)" -k
8d7dd9b0170ce0b5f2f8e1aa768e01e91da8bfc67fd486d081b28254c99eb423 -i
7fbc02ebf5b93322329df9bfccb635af -p 48981da18e4bb9ef7e2e3162d16b1910

Without the patch, the kernel crashes. With the patch, the kernel works.
The test duplicates the plaintext for supplying two IOCBs, expecting the
two identical blocks of ciphertext. When changing the test such that
both input data blocks are different, the resulting cipher text blocks
are different, as expected.

[1] http://www.chronox.de/libkcapi.html

---8<---

When submitting multiple IOCBs to be processed with one AIO invocation,
the initially supplied input data is processed with with each AIO
operation. For example, a simplified AIO operation may look like the
following:

1. sendmsg(32 bytes)
2. io_submit which defines 2 IOCBs (i.e. 2 operations providing
   16 bytes buffer each to invoke an ecb(aes) operation)

The io_submit call is processed by the skcipher_recvmsg_async AF_ALG
handler. io_submit invokes skcipher_recvmsg_async once for each IOCB.
skcipher_recvmsg_async processes the ecb(aes) operation request, taking
the first 16 bytes from the input. When finishing the
skcipher_recvmsg_async operation, the page holding the 32 bytes of input
data from sendmsg cannot be released yet, but the scatter/gather list
pointing into the page needs to be advanced to point to the
second 16 bytes. Only when all data is used up, the page is released.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_skcipher.c | 35 ++++++++++++++++++++++++++++++-----
 1 file changed, 30 insertions(+), 5 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 1e38aaa..68bde92 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -72,7 +72,8 @@ struct skcipher_async_req {
 #define MAX_SGL_ENTS ((4096 - sizeof(struct skcipher_sg_list)) / \
 		      sizeof(struct scatterlist) - 1)
 
-static void skcipher_free_async_sgls(struct skcipher_async_req *sreq)
+static void skcipher_free_async_sgls(struct skcipher_async_req *sreq,
+				     unsigned int len)
 {
 	struct skcipher_async_rsgl *rsgl, *tmp;
 	struct scatterlist *sgl;
@@ -86,8 +87,31 @@ static void skcipher_free_async_sgls(struct skcipher_async_req *sreq)
 	}
 	sgl = sreq->tsg;
 	n = sg_nents(sgl);
-	for_each_sg(sgl, sg, n, i)
-		put_page(sg_page(sg));
+	for_each_sg(sgl, sg, n, i) {
+		struct page *page = sg_page(sg);
+
+		if (!page)
+			continue;
+
+		/*
+		 * The async operation may have processed only a subset of
+		 * the data that was initially received from the caller.
+		 * Thus, we only can release the data that a cipher operation
+		 * processed.
+		 */
+		if (len < sg->length) {
+			/* ensure that empty SGLs are not referenced any more */
+			sreq->tsg = sg;
+
+			/* advance the buffers to the unprocessed data */
+			sg->length -= len;
+			sg->offset += len;
+			return;
+		}
+
+		len -= sg->length;
+		put_page(page);
+	}
 
 	kfree(sreq->tsg);
 }
@@ -95,10 +119,11 @@ static void skcipher_free_async_sgls(struct skcipher_async_req *sreq)
 static void skcipher_async_cb(struct crypto_async_request *req, int err)
 {
 	struct skcipher_async_req *sreq = req->data;
+	struct skcipher_request *sk_req = &sreq->req;
 	struct kiocb *iocb = sreq->iocb;
 
 	atomic_dec(sreq->inflight);
-	skcipher_free_async_sgls(sreq);
+	skcipher_free_async_sgls(sreq, err ? 0 : sk_req->cryptlen);
 	kzfree(sreq);
 	iocb->ki_complete(iocb, err, err);
 }
@@ -623,7 +648,7 @@ static int skcipher_recvmsg_async(struct socket *sock, struct msghdr *msg,
 		goto unlock;
 	}
 free:
-	skcipher_free_async_sgls(sreq);
+	skcipher_free_async_sgls(sreq, err ? 0 : len);
 unlock:
 	skcipher_wmem_wakeup(sk);
 	release_sock(sk);
-- 
2.9.3
