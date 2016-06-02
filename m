From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 3/4] crypto: kdf - SP800-108 Key Derivation Function
Date: Thu, 2 Jun 2016 16:55:26 +0800
Message-ID: <20160602085526.GA15919@gondor.apana.org.au>
References: <17649236.piPdUxUzaM@positron.chronox.de>
 <4593825.q48Y9K9RSZ@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	keyrings@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47695 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbcFBIzg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jun 2016 04:55:36 -0400
Content-Disposition: inline
In-Reply-To: <4593825.q48Y9K9RSZ@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 31, 2016 at 01:52:32PM +0200, Stephan Mueller wrote:
>
> + * NOTE: Technically you can use one buffer for holding the label_context and
> + *	 the outbuf in the example above. Howerver, multiple rounds of the
> + *	 KDF are to be expected with the input must always be the same.
> + *	 The first round would replace the input in case of one buffer, and the
> + *	 KDF would calculate a cryptographically strong result which, however,
> + *	 is not portable to other KDF implementations! Thus, always use
> + *	 different buffers for the label_context and the outbuf. A safe
> + *	 in-place operation can only be done when only one round of the KDF
> + *	 is executed (i.e. the size of the requested buffer is equal to the
> + *	 digestsize of the used MAC).

Why don't you put the result in a temporary buffer and then copy
it? These things are tiny, right?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
