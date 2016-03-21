From: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
Subject: RE: [PATCH 10/10] crypto: caam - add support for RSA algorithm
Date: Mon, 21 Mar 2016 11:07:06 +0000
Message-ID: <AM3PR04MB130028052CD2D14B8F67663DB88F0@AM3PR04MB1300.eurprd04.prod.outlook.com>
References: <1458325927-14737-1-git-send-email-tudor-dan.ambarus@nxp.com>
 <1458325927-14737-10-git-send-email-tudor-dan.ambarus@nxp.com>
 <3630222.vHD2IgIHAY@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"tadeusz.struk@intel.com" <tadeusz.struk@intel.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Horia Ioan Geanta Neag" <horia.geanta@nxp.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db3on0060.outbound.protection.outlook.com ([157.55.234.60]:4965
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753865AbcCULHL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Mar 2016 07:07:11 -0400
In-Reply-To: <3630222.vHD2IgIHAY@tauon.atsec.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

> -----Original Message-----
> From: Stephan Mueller [mailto:smueller@chronox.de]
> Sent: Saturday, March 19, 2016 6:59 PM
> To: Tudor-Dan Ambarus
> Cc: herbert@gondor.apana.org.au; tadeusz.struk@intel.com; linux-
> crypto@vger.kernel.org; Horia Ioan Geanta Neag
> Subject: Re: [PATCH 10/10] crypto: caam - add support for RSA algorithm
> 
> > +void rsa_free_key(struct rsa_raw_key *key)
> > +{
> > +	kzfree(key->d);
> > +	key->d = NULL;
> > +
> > +	kfree(key->e);
> > +	key->e = NULL;
> > +
> > +	kfree(key->n);
> > +	key->n = NULL;
> > +
> > +	key->n_sz = 0;
> > +	key->e_sz = 0;
> > +}
> 
> As you implement raw key support for use in other drivers, shouldn't that
> function go into some helper file like free_mpis().
> > +

[ta] I should also add an rsa_free_coherent_key(struct device *dev, struct rsa_raw_key *key), for those implementations that use the DMA-coherent API. 


> > +static int caam_rsa_dec(struct akcipher_request *req)
> > +{
> > +	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> > +	struct rsa_raw_ctx *ctx = akcipher_tfm_ctx(tfm);
> > +	struct rsa_raw_key *key = &ctx->key;
> > +	struct device *jrdev = ctx->dev;
> > +	struct rsa_edesc *edesc = NULL;
> > +	size_t desclen = sizeof(struct rsa_priv_f1_desc);
> > +	int ret;
> > +
> > +	if (unlikely(!key->n || !key->d))
> > +		return -EINVAL;
> > +
> > +	if (req->dst_len < key->n_sz) {
> > +		req->dst_len = key->n_sz;
> > +		return -EOVERFLOW;
> > +	}
> > +
> > +	/* Allocate extended descriptor. */
> > +	edesc = rsa_edesc_alloc(req, desclen);
> > +	if (IS_ERR(edesc))
> > +		return PTR_ERR(edesc);
> > +
> > +	/* Initialize Job Descriptor. */
> > +	ret = init_rsa_priv_f1_desc(req, edesc);
> > +	if (ret)
> > +		return ret;
> 
> Same here, kfree?

[ta] Sure, thanks.

> > +
> > +	ret = caam_jr_enqueue(jrdev, edesc->hw_desc, rsa_priv_f1_done, req);
> > +	if (!ret) {
> > +		ret = -EINPROGRESS;
> 
> dto
>

[ta] resources are freed on rsa_priv_f1_done callback.
 
> > +static struct akcipher_alg rsa = {
> 
> can you please name that something else, like caam_rsa? It is a real hassle
> when searching some symbol and I get such a generic name.

[ta] ok.

Thank you for the review!
ta
