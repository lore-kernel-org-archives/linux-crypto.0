From: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
Subject: RE: [PATCH 02/10] crypto: rsa_helper - add raw integer parser actions
Date: Mon, 21 Mar 2016 15:17:20 +0000
Message-ID: <AM3PR04MB13004732D24525234255CB72B88F0@AM3PR04MB1300.eurprd04.prod.outlook.com>
References: <1458325927-14737-1-git-send-email-tudor-dan.ambarus@nxp.com>
 <1458325927-14737-2-git-send-email-tudor-dan.ambarus@nxp.com>
 <3040533.U92nQRUNV9@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"tadeusz.struk@intel.com" <tadeusz.struk@intel.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Horia Ioan Geanta Neag" <horia.geanta@nxp.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db3on0094.outbound.protection.outlook.com ([157.55.234.94]:8096
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756429AbcCUPRZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Mar 2016 11:17:25 -0400
In-Reply-To: <3040533.U92nQRUNV9@tauon.atsec.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,


> -----Original Message-----
> From: Stephan Mueller [mailto:smueller@chronox.de]
> Sent: Friday, March 18, 2016 9:47 PM
> To: Tudor-Dan Ambarus
> Cc: herbert@gondor.apana.org.au; tadeusz.struk@intel.com; linux-
> crypto@vger.kernel.org; Horia Ioan Geanta Neag
> Subject: Re: [PATCH 02/10] crypto: rsa_helper - add raw integer parser
> actions
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
> 
> I know that you copied the code to a new location that was there already.
> But
> based on the discussion we had for DH, does it make sense that the kernel
> adds
> such (artificial) limits?

[ta] This is not within the scope of this patch set, but we can remove the restrictions in a subsequent patch. Marcel has suggested to not impose limits on the minimum length of the key. What about the maximum?

> > +
> > +	return -EINVAL;
> > +}
> > +EXPORT_SYMBOL_GPL(rsa_check_key_length);
> > +
> > +int raw_rsa_get_n(void *context, size_t hdrlen, unsigned char tag,
> > +		  const void *value, size_t vlen)
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
> > +	if (fips_enabled && (key->n_sz != 256 && key->n_sz != 384)) {
> 
> Again, you copied that code that used to be there . But very very recently,
> NIST allowed 4k keys too. May I ask to allow it here?
> 

I suggest to do this in a separate patch. Can you send us a pointer to the NIST specification?

Thank you,
ta
