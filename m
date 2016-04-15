From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 1/3] crypto: rsa - generalize ASN.1 sequences
Date: Fri, 15 Apr 2016 21:52:45 +0800
Message-ID: <20160415135245.GA334@gondor.apana.org.au>
References: <1459949826-11840-1-git-send-email-tudor-dan.ambarus@nxp.com>
 <1459949826-11840-2-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, tadeusz.struk@intel.com,
	smueller@chronox.de, cristian.stoica@nxp.com, horia.geanta@nxp.com
To: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34593 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbcDONwu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Apr 2016 09:52:50 -0400
Content-Disposition: inline
In-Reply-To: <1459949826-11840-2-git-send-email-tudor-dan.ambarus@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 06, 2016 at 04:37:04PM +0300, Tudor Ambarus wrote:
> Use common ASN.1 sequences for all RSA implementations.
> 
> Give hardware RSA implementations the chance to use
> the RSA's software implementation parser even if they
> are likely to want to use raw integers.
> 
> The parser expects a context that contains at the first address
> a pointer to a struct rsa_asn1_action instance that has function
> pointers to specific parser actions (return MPI or raw integer keys),
> followed by a key representation structure (for MPI or raw integers).
> 
> This approach has the advantage that users can select specific
> parser actions by using a general parser with function pointers
> to specific actions.

I don't understand why we need different parsing functions in the
first place.  Can't they just return raw integers always?

You can then trivially convert the raw integers to MPI, no?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
