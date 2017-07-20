From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] crypto: ixp4xx - Fix error handling path in 'aead_perform()'
Date: Thu, 20 Jul 2017 09:37:10 +0200
Message-ID: <CAK8P3a3RuQmudGRGvpE1i=RwjJ_KVU1S+bDqX6Bp6VLB7G+2cg@mail.gmail.com>
References: <20170719214757.29203-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170719214757.29203-1-christophe.jaillet@wanadoo.fr>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jul 19, 2017 at 11:47 PM, Christophe JAILLET
<christophe.jaillet@wanadoo.fr> wrote:
> In commit 0f987e25cb8a, the source processing has been moved in front of
> the destination processing, but the error handling path has not been
> modified accordingly.
> Free resources in the correct order to avoid some leaks.
>
> Fixes: 0f987e25cb8a ("crypto: ixp4xx - Fix false lastlen uninitialised warning")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Thanks for spotting my mistake!

I've looked at it again and think it's unfortunately still wrong with
your patch,
as there is a 'goto free_buf_src' after dma_pool_alloc(), and that now needs
to jump to free_buf_dst instead. We may also need an extra check to make
sure we don't free an uninitialized pointer again.

Can you have a look at this version below and send whatever you find
to be correct in the end?

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 427cbe012729..08b740dddb20 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -1073,7 +1073,7 @@ static int aead_perform(struct aead_request
*req, int encrypt,
                req_ctx->hmac_virt = dma_pool_alloc(buffer_pool, flags,
                                &crypt->icv_rev_aes);
                if (unlikely(!req_ctx->hmac_virt))
-                       goto free_buf_src;
+                       goto free_buf_dst;
                if (!encrypt) {
                        scatterwalk_map_and_copy(req_ctx->hmac_virt,
                                req->src, cryptlen, authsize, 0);
@@ -1088,10 +1088,11 @@ static int aead_perform(struct aead_request
*req, int encrypt,
        BUG_ON(qmgr_stat_overflow(SEND_QID));
        return -EINPROGRESS;

+free_buf_dst:
+       if (crypt->dst)
+               free_buf_chain(dev, req_ctx->dst, crypt->dst_buf);
 free_buf_src:
        free_buf_chain(dev, req_ctx->src, crypt->src_buf);
-free_buf_dst:
-       free_buf_chain(dev, req_ctx->dst, crypt->dst_buf);
        crypt->ctl_flags = CTL_FLAG_UNUSED;
        return -ENOMEM;
 }
