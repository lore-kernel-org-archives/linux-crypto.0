From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: KEYS: convert public key to the akcipher API
Date: Fri, 14 Aug 2015 09:09:16 +0800
Message-ID: <20150814010916.GA333@gondor.apana.org.au>
References: <20150813035439.25108.62457.stgit@tstruk-mobl1>
 <20150813035433.25108.3065.stgit@tstruk-mobl1>
 <10795.1439475796@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tadeusz Struk <tadeusz.struk@intel.com>, keescook@chromium.org,
	jwboyer@redhat.com, smueller@chronox.de, richard@nod.at,
	steved@redhat.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55823 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbbHNBJi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Aug 2015 21:09:38 -0400
Content-Disposition: inline
In-Reply-To: <10795.1439475796@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 13, 2015 at 03:23:16PM +0100, David Howells wrote:
> 
> > -	/* Decode the public key */
> > -	ret = asn1_ber_decoder(&x509_rsakey_decoder, ctx,
> > -			       ctx->key, ctx->key_size);
> > -	if (ret < 0)
> > +	cert->pub->key = kmemdup(ctx->key, ctx->key_size, GFP_KERNEL);
> > +	if (!cert->pub->key)
> >  		goto error_decode;
> 
> The generic public key code should *not* see the container wrappings (ASN.1
> from an X.509 cert in this case).  The public key could be supplied by OpenPGP
> instead, for example, or directly by a driver.

No in this case it's fine because the format of our key input
specification just happens to coincide with the input here.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
