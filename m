From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] crypto: xts,lrw - fix out-of-bounds write after kmalloc failure
Date: Thu, 23 Mar 2017 13:39:46 -0700
Message-ID: <20170323203946.11242-1-ebiggers3@gmail.com>
References: <CACT4Y+ZnQq9x7gXTpaRxnMSh_2Uk461J9CWnoq3i5KQBY-nLGw@mail.gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        syzkaller <syzkaller@googlegroups.com>,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35320 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932209AbdCWUmV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Mar 2017 16:42:21 -0400
In-Reply-To: <CACT4Y+ZnQq9x7gXTpaRxnMSh_2Uk461J9CWnoq3i5KQBY-nLGw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Eric Biggers <ebiggers@google.com>

In the generic XTS and LRW algorithms, for input data > 128 bytes, a
temporary buffer is allocated to hold the values to be XOR'ed with the
data before and after encryption or decryption.  If the allocation
fails, the fixed-size buffer embedded in the request buffer is meant to
be used as a fallback --- resulting in more calls to the ECB algorithm,
but still producing the correct result.  However, we weren't correctly
limiting subreq->cryptlen in this case, resulting in pre_crypt()
overrunning the embedded buffer.  Fix this by setting subreq->cryptlen
correctly.

Fixes: f1c131b45410 ("crypto: xts - Convert to skcipher")
Fixes: 700cb3f5fe75 ("crypto: lrw - Convert to skcipher")
Cc: stable@vger.kernel.org # v4.10+
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/lrw.c | 7 +++++--
 crypto/xts.c | 7 +++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/crypto/lrw.c b/crypto/lrw.c
index ecd8474018e3..3ea095adafd9 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -286,8 +286,11 @@ static int init_crypt(struct skcipher_request *req, crypto_completion_t done)
 
 	subreq->cryptlen = LRW_BUFFER_SIZE;
 	if (req->cryptlen > LRW_BUFFER_SIZE) {
-		subreq->cryptlen = min(req->cryptlen, (unsigned)PAGE_SIZE);
-		rctx->ext = kmalloc(subreq->cryptlen, gfp);
+		unsigned int n = min(req->cryptlen, (unsigned int)PAGE_SIZE);
+
+		rctx->ext = kmalloc(n, gfp);
+		if (rctx->ext)
+			subreq->cryptlen = n;
 	}
 
 	rctx->src = req->src;
diff --git a/crypto/xts.c b/crypto/xts.c
index baeb34dd8582..c976bfac29da 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -230,8 +230,11 @@ static int init_crypt(struct skcipher_request *req, crypto_completion_t done)
 
 	subreq->cryptlen = XTS_BUFFER_SIZE;
 	if (req->cryptlen > XTS_BUFFER_SIZE) {
-		subreq->cryptlen = min(req->cryptlen, (unsigned)PAGE_SIZE);
-		rctx->ext = kmalloc(subreq->cryptlen, gfp);
+		unsigned int n = min(req->cryptlen, (unsigned int)PAGE_SIZE);
+
+		rctx->ext = kmalloc(n, gfp);
+		if (rctx->ext)
+			subreq->cryptlen = n;
 	}
 
 	rctx->src = req->src;
-- 
2.12.1.500.gab5fba24ee-goog
