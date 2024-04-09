Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B7A80038
	for <linux-crypto@vger.kernel.org>; Tue,  9 Apr 2024 09:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712656577; cv=none; b=Gs7Gb9eEo1GVcnHC8CyMNKO0MAkPeg+k+SNpoYDV5MxfD5fIqXRnsK4Pjsy+/aI30c1nul7gof0S5uAdv8x961cRwTdK0qsRomlI9vdqEsvs8AjQeHGcbDnpn4IigLQGM2NO9IAS/pRomJk7wZkAQTQcp98tqRFM2c8K/dTWuJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712656577; c=relaxed/simple;
	bh=3tudJ8zr0TwEy9GzsXNb7ZK28bJrYL87s3kQv+Iyiog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jk5D3Ak+YkuvmWdznQoDQnBL3S5kwl9aBopUicJ6ykQ0lVtJZVkKi46Na2S26yCwSrRWdMZ3yCkieM0sETdC+Y1w2n9YDfFIt6wSYYwCYEKXq5hH1/UW9LqAS8EbNvp0eQJY5wuTaIiYf3OnfVxXbji5rjmDfidl3tBqnlxOiRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1ru8Cr-00GyEv-JI; Tue, 09 Apr 2024 17:55:58 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 09 Apr 2024 17:56:14 +0800
Date: Tue, 9 Apr 2024 17:56:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Howells <dhowells@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org
Subject: Re: Incorrect use of CRYPTO_ALG_ASYNC in
 crypto_alloc_sync_skcipher()?
Message-ID: <ZhUQvjKGSk0b0O28@gondor.apana.org.au>
References: <1068289.1712656290@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1068289.1712656290@warthog.procyon.org.uk>

On Tue, Apr 09, 2024 at 10:51:30AM +0100, David Howells wrote:
> Hi Herbert,
> 
> Is the following code in crypto_alloc_sync_skcipher() wrong:
> 
> 	/* Only sync algorithms allowed. */
> 	mask |= CRYPTO_ALG_ASYNC | CRYPTO_ALG_SKCIPHER_REQSIZE_LARGE;
> 
> in its specification of CRYPTO_ALG_ASYNC?  Given what the docs say:
> 
>     The mask flag restricts the type of cipher. The only allowed flag is
>     CRYPTO_ALG_ASYNC to restrict the cipher lookup function to
>     asynchronous ciphers. Usually, a caller provides a 0 for the mask flag.
>     ^^^^^^^^^^^^
> 
> or are the docs wrong?

The mask is used together with the type bitfield.  You need to set
CRYPTO_ALG_ASYNC in both bitfields if you want to guarantee getting
an async cipher.

If you set CRYPTO_ALG_ASYNC in the mask but leave it unset in the
type bitfield then you are guaranteed to get an algorithm with this
bit turned off, in other words a synchronous cipher.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
