From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] crypto: ccree: fix iv copying for small buffers
Date: Thu, 7 Jun 2018 12:02:04 +0300
Message-ID: <CAOtvUMcJfJDjnMoithRQ4ife09VC+G-w+__jV-JLwh7M=s7JNQ@mail.gmail.com>
References: <1528361927-4172-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ofir Drang <ofir.drang@arm.com>, stable@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, hadar.gat@arm.com
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1528361927-4172-1-git-send-email-gilad@benyossef.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

On Thu, Jun 7, 2018 at 11:58 AM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> We are copying our last cipher block into the request for use as IV as
> required by the Crypto API but we failed to handle correctly the case the
> buffer we are working on is smaller than a block. Fix it by calculating
> how much we need to copy based on buffer size.
>

I'd be really happy to get a review on this patch - not so much what
it is doing but
rather the rational behind it - how is a tfm provider supposed to
handle copying the
last block of ciphertext into the request structure if the ciphertext
size is less than a
block?

I opted for simply copying whatever ciphertext was available and
zeroing the rest
but frankly I'm not sure this is the right thing.

Any feedback is apreciated.

Thanks!
Gilad


> CC: stable@vger.kernel.org
> Fixes: 63ee04c8b491 ("crypto: ccree - add skcipher support")
> Reported by: Hadar Gat <hadar.gat@arm.com>
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> ---
>  drivers/crypto/ccree/cc_cipher.c | 30 ++++++++++++++++++++++++------
>  1 file changed, 24 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
> index d2810c1..a07547f 100644
> --- a/drivers/crypto/ccree/cc_cipher.c
> +++ b/drivers/crypto/ccree/cc_cipher.c
> @@ -616,9 +616,18 @@ static void cc_cipher_complete(struct device *dev, void *cc_req, int err)
>                 memcpy(req->iv, req_ctx->backup_info, ivsize);
>                 kzfree(req_ctx->backup_info);
>         } else if (!err) {
> -               scatterwalk_map_and_copy(req->iv, req->dst,
> -                                        (req->cryptlen - ivsize),
> -                                        ivsize, 0);
> +               unsigned int len;
> +
> +               if (req->cryptlen > ivsize) {
> +                       len = req->cryptlen - ivsize;
> +               } else {
> +                       memset(req->iv, 0, ivsize);
> +                       len = 0;
> +                       ivsize = req->cryptlen;
> +
> +               }
> +
> +               scatterwalk_map_and_copy(req->iv, req->dst, len, ivsize, 0);
>         }
>
>         skcipher_request_complete(req, err);
> @@ -755,17 +764,26 @@ static int cc_cipher_decrypt(struct skcipher_request *req)
>         struct cipher_req_ctx *req_ctx = skcipher_request_ctx(req);
>         unsigned int ivsize = crypto_skcipher_ivsize(sk_tfm);
>         gfp_t flags = cc_gfp_flags(&req->base);
> +       unsigned int len;
>
>         /*
>          * Allocate and save the last IV sized bytes of the source, which will
>          * be lost in case of in-place decryption and might be needed for CTS.
>          */
> -       req_ctx->backup_info = kmalloc(ivsize, flags);
> +       req_ctx->backup_info = kzalloc(ivsize, flags);
>         if (!req_ctx->backup_info)
>                 return -ENOMEM;
>
> -       scatterwalk_map_and_copy(req_ctx->backup_info, req->src,
> -                                (req->cryptlen - ivsize), ivsize, 0);
> +
> +       if (req->cryptlen > ivsize) {
> +               len = req->cryptlen - ivsize;
> +       } else {
> +               len = 0;
> +               ivsize = req->cryptlen;
> +       }
> +
> +       scatterwalk_map_and_copy(req_ctx->backup_info, req->src, len, ivsize,
> +                                0);
>         req_ctx->is_giv = false;
>
>         return cc_cipher_process(req, DRV_CRYPTO_DIRECTION_DECRYPT);
> --
> 2.7.4
>



-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
