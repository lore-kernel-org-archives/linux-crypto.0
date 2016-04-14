From: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
Subject: RE: [PATCH v3 2/3] crypto: rsa_helper - add raw integer parser
 actions
Date: Thu, 14 Apr 2016 15:25:17 +0000
Message-ID: <AM3PR04MB1300D3E01F404CA61D833C3DB8970@AM3PR04MB1300.eurprd04.prod.outlook.com>
References: <1459949826-11840-1-git-send-email-tudor-dan.ambarus@nxp.com>
 <1459949826-11840-3-git-send-email-tudor-dan.ambarus@nxp.com>
 <50351949.oWvfu4SbDk@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"tadeusz.struk@intel.com" <tadeusz.struk@intel.com>,
	Cristian Stoica <cristian.stoica@nxp.com>,
	Horia Ioan Geanta Neag <horia.geanta@nxp.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db3on0071.outbound.protection.outlook.com ([157.55.234.71]:9536
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755671AbcDNPZW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Apr 2016 11:25:22 -0400
In-Reply-To: <50351949.oWvfu4SbDk@tauon.atsec.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

I was out of office, sorry for the delay.

> Am Mittwoch, 6. April 2016, 16:37:05 schrieb Tudor Ambarus:
> 
> > +int rsa_check_key_length(unsigned int len)
> > +{
> > +	switch (len) {
> > +	case 512:
> > +	case 1024:
> > +	case 1536:
> > +	case 2048:
> > +	case 3072:
> > +	case 4096:
> > +		return 0;
> > +	}
> > +
> > +	return -EINVAL;
> > +}
> > +EXPORT_SYMBOL_GPL(rsa_check_key_length);
> 
> I assume we can remove that length check in the future and you just ported
> it
> to be en-par with the feature set of the current implementation?

Yes, this is how we agreed. Removing this limitation is a fix for the current implementation and should be treated in an explicit patch. It's not in the scope of this patch set, we will do it later.

> > +void raw_rsa_free_coherent_key(struct device *dev, struct rsa_raw_key
> *key)
> > +{
> > +	if (key->d) {
> > +		memset(key->d, '\0', key->n_sz);
> 
> memzero_explicit, please

I don't think this is really needed. memzero_explicit is used only on stack variables that get cleared just before they go out of scope.

> 
> > +		dma_free_coherent(dev, key->n_sz, key->d, key->dma_d);
> > +		key->d = NULL;
> > +	}
> > +
> > +	if (key->e) {
> > +		dma_free_coherent(dev, key->n_sz, key->e, key->dma_e);
> > +		key->e = NULL;
> > +	}
> > +
> > +	if (key->n) {
> > +		dma_free_coherent(dev, key->n_sz, key->n, key->dma_n);
> > +		key->n = NULL;
> > +	}
> > +
> > +	key->n_sz = 0;
> > +	key->e_sz = 0;
> > +}
> > +EXPORT_SYMBOL_GPL(raw_rsa_free_coherent_key);
> > +
> > +int raw_rsa_get_n(void *context, const void *value, size_t vlen)
> > +{
> > +	struct rsa_raw_ctx *ctx = context;
> > +	struct rsa_raw_key *key = &ctx->key;
> > +	const char *ptr = value;
> > +	int ret = -EINVAL;
> > +
> > +	while (!*ptr && vlen) {
> > +		ptr++;
> > +		vlen--;
> > +	}
> > +
> > +	key->n_sz = vlen;
> > +	/* In FIPS mode only allow key size 2K & 3K */
> 
> Again, this only excludes 4k as this should be done in a subsequent patch,
> right?

Yes, this will be addressed in an explicit patch. It's an update that is not in the scope of this patch set.

Stephan, thank you for the review!

ta
