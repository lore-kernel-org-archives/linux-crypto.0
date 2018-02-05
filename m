From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [RFC PATCH 2/3] crypto: hisilicon hacv1 driver
Date: Mon, 5 Feb 2018 14:02:03 +0000
Message-ID: <20180205140203.00007e46@huawei.com>
References: <20180130152953.14068-1-jonathan.cameron@huawei.com>
        <20180130152953.14068-3-jonathan.cameron@huawei.com>
        <7706135.m10557lhAe@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>,
        <xuzaibo@huawei.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        <devicetree@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
        Xiongfeng Wang <xiongfeng.wang@linaro.org>
To: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:57851 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753128AbeBEOCj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Feb 2018 09:02:39 -0500
In-Reply-To: <7706135.m10557lhAe@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, 3 Feb 2018 12:16:18 +0100
Stephan Müller <smueller@chronox.de> wrote:

> Am Dienstag, 30. Januar 2018, 16:29:52 CET schrieb Jonathan Cameron:
> 
> Hi Jonathan,
> 
> > +	/* Special path for single element SGLs with small packets. */
> > +	if (sg_is_last(sgl) && sgl->length <= SEC_SMALL_PACKET_SIZE) {  
> 
> This looks strangely familiar. Is this code affected by a similar issue fixed 
> in https://patchwork.kernel.org/patch/10173981?

Not as far as I know - this section is about optimizing the setup of
the IOMMU. It's purely a performance optimization.

It is really costly to do the translation setup for lots of small regions.
These small regions are often contiguous anyway making the cost even more
ridiculous.  The use of a dma pool allows us to keep the iommu setup
constant(ish). It is cheaper to copy into an element of this, already
mapped, pool than it is to set up the iommu mappings for a new region.

I could drop this for the initial submission and bring it in as an
optimization with supporting numbers as a follow up patch.

> 
> > +static int sec_alg_skcipher_setkey(struct crypto_skcipher *tfm,
> > +                                  const u8 *key, unsigned int keylen,
> > +                                  enum sec_cipher_alg alg)
> > +{
> > +       struct sec_alg_skcipher_ctx *ctx = crypto_skcipher_ctx(tfm);
> > +       struct device *dev;
> > +
> > +       spin_lock(&ctx->lock);
> > +       if (ctx->enc_key) {
> > +               /* rekeying */
> > +               dev = SEC_Q_DEV(ctx->queue);
> > +               memset(ctx->enc_key, 0, SEC_MAX_CIPHER_KEY);
> > +               memset(ctx->dec_key, 0, SEC_MAX_CIPHER_KEY);
> > +               memset(&ctx->enc_req, 0, sizeof(ctx->enc_req));
> > +               memset(&ctx->dec_req, 0, sizeof(ctx->dec_req));
> > +       } else {
> > +               /* new key */
> > +               dev = SEC_Q_DEV(ctx->queue);
> > +               ctx->enc_key = dma_zalloc_coherent(dev, SEC_MAX_CIPHER_KEY,
> > +                                                  &ctx->enc_pkey,
> > GFP_ATOMIC); +               if (!ctx->enc_key) {
> > +                       spin_unlock(&ctx->lock);
> > +                       return -ENOMEM;
> > +               }
> > +               ctx->dec_key = dma_zalloc_coherent(dev, SEC_MAX_CIPHER_KEY,
> > +                                                  &ctx->dec_pkey,
> > GFP_ATOMIC); +               if (!ctx->dec_key) {
> > +                       spin_unlock(&ctx->lock);
> > +                       goto out_free_enc;
> > +               }
> > +       }
> > +       spin_unlock(&ctx->lock);
> > +       if (sec_alg_skcipher_init_context(tfm, key, keylen, alg))
> > +               goto out_free_all;
> > +
> > +       return 0;
> > +
> > +out_free_all:
> > +       memset(ctx->dec_key, 0, SEC_MAX_CIPHER_KEY);
> > +       dma_free_coherent(dev, SEC_MAX_CIPHER_KEY,
> > +                         ctx->dec_key, ctx->dec_pkey);
> > +       ctx->dec_key = NULL;
> > +out_free_enc:
> > +       memset(ctx->enc_key, 0, SEC_MAX_CIPHER_KEY);
> > +       dma_free_coherent(dev, SEC_MAX_CIPHER_KEY,
> > +                         ctx->enc_key, ctx->enc_pkey);
> > +       ctx->enc_key = NULL;  
> 
> Please use memzero_explicit.

Will do - thanks!

Jonathan
> > +
> > +       return -ENOMEM;
> > +  
