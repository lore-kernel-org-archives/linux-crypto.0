From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH v3] crypto: ixp4xx - Fix error handling path in
 'aead_perform()'
Date: Wed, 2 Aug 2017 16:40:47 +0800
Message-ID: <20170802084046.GA6740@gondor.apana.org.au>
References: <20170719214757.29203-1-christophe.jaillet@wanadoo.fr>
 <CAK8P3a3RuQmudGRGvpE1i=RwjJ_KVU1S+bDqX6Bp6VLB7G+2cg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a3RuQmudGRGvpE1i=RwjJ_KVU1S+bDqX6Bp6VLB7G+2cg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jul 20, 2017 at 09:37:10AM +0200, Arnd Bergmann wrote:
>
> Thanks for spotting my mistake!
> 
> I've looked at it again and think it's unfortunately still wrong with
> your patch,
> as there is a 'goto free_buf_src' after dma_pool_alloc(), and that now needs
> to jump to free_buf_dst instead. We may also need an extra check to make
> sure we don't free an uninitialized pointer again.
> 
> Can you have a look at this version below and send whatever you find
> to be correct in the end?
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Oops, looks like I introduced the bug.  Anyway, such is the danger
of fixing compiler warnings in rarely used code.

For some reason your patch is corrupted in patchwork.  Also we don't
need to check crypt->dst as free_buf_chain is a no-op if we didn't do
the allocation at all.  So how about this patch?

---8<---
In commit 0f987e25cb8a, the source processing has been moved in front of
the destination processing, but the error handling path has not been
modified accordingly.
Free resources in the correct order to avoid some leaks.

Fixes: 0f987e25cb8a ("crypto: ixp4xx - Fix false lastlen uninitialised warning")
Reported-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 427cbe0..55dc9c2 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -1073,7 +1073,7 @@ static int aead_perform(struct aead_request *req, int encrypt,
 		req_ctx->hmac_virt = dma_pool_alloc(buffer_pool, flags,
 				&crypt->icv_rev_aes);
 		if (unlikely(!req_ctx->hmac_virt))
-			goto free_buf_src;
+			goto free_buf_dst;
 		if (!encrypt) {
 			scatterwalk_map_and_copy(req_ctx->hmac_virt,
 				req->src, cryptlen, authsize, 0);
@@ -1088,10 +1088,10 @@ static int aead_perform(struct aead_request *req, int encrypt,
 	BUG_ON(qmgr_stat_overflow(SEND_QID));
 	return -EINPROGRESS;
 
-free_buf_src:
-	free_buf_chain(dev, req_ctx->src, crypt->src_buf);
 free_buf_dst:
 	free_buf_chain(dev, req_ctx->dst, crypt->dst_buf);
+free_buf_src:
+	free_buf_chain(dev, req_ctx->src, crypt->src_buf);
 	crypt->ctl_flags = CTL_FLAG_UNUSED;
 	return -ENOMEM;
 }
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
