From: "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
Subject: RE: [PATCH v9 2/3] crypto: kpp - Add DH software implementation
Date: Mon, 20 Jun 2016 11:43:28 +0000
Message-ID: <309B30E91F5E2846B79BD9AA9711D03193586D@IRSMSX102.ger.corp.intel.com>
References: <1466174265-4546-1-git-send-email-salvatore.benedetto@intel.com>
 <1466174265-4546-3-git-send-email-salvatore.benedetto@intel.com>
 <20160620111524.GB10601@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Benedetto, Salvatore" <salvatore.benedetto@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:21160 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913AbcFTLqf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Jun 2016 07:46:35 -0400
In-Reply-To: <20160620111524.GB10601@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



> -----Original Message-----
> From: Herbert Xu [mailto:herbert@gondor.apana.org.au]
> Sent: Monday, June 20, 2016 12:15 PM
> To: Benedetto, Salvatore <salvatore.benedetto@intel.com>
> Cc: linux-crypto@vger.kernel.org
> Subject: Re: [PATCH v9 2/3] crypto: kpp - Add DH software implementation
> 
> On Fri, Jun 17, 2016 at 03:37:44PM +0100, Salvatore Benedetto wrote:
> >  * Implement MPI based Diffie-Hellman under kpp API
> >
> > +struct dh {
> > +	void *key;
> > +	void *p;
> > +	void *g;
> > +	unsigned int key_size;
> > +	unsigned int p_size;
> > +	unsigned int g_size;
> > +};
> > +
> > +int crypto_dh_key_len(const struct dh *params); int
> > +crypto_dh_encode_key(char *buf, unsigned int len, const struct dh
> > +*params); int crypto_dh_decode_key(const char *buf, unsigned int len,
> > +struct dh **params);
> 
> While you're at it, it would be nice if you could make the encoded format
> little-endian, that way we can make test vectors for all kpp algorithms use
> the same format.
> 

The input format is the same for DH and ECDH.
Only the software implementation of ECC requires little-endian format.

Regards,
Salvatore

> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page:
> http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
