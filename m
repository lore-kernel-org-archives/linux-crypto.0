From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: question about crypto module dependency
Date: Wed, 18 Jan 2012 16:39:33 +1100
Message-ID: <20120118053933.GA23562@gondor.apana.org.au>
References: <CAC9WiBj0oK+mWqnGVPEPAOTKMKeedsD4Wwwv_a0YbmOm2ejyfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:46852 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab2ARFjg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Jan 2012 00:39:36 -0500
Content-Disposition: inline
In-Reply-To: <CAC9WiBj0oK+mWqnGVPEPAOTKMKeedsD4Wwwv_a0YbmOm2ejyfg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Francis Moreau <francis.moro@gmail.com> wrote:
> Hello,
> 
> I'm wondering how this scenario is supposed to work: let's say a
> module A uses 'crc32c' function in lib/libcrc32c.c. In its turn this
> function calls crypto_shash_update() which is exported by
> crypto/shash.c. But now no module implementing "crc32c" has still been
> loaded although crc32c.ko is available. Therefore the initial load of
> module A fails although all required modules by the system are
> present.
> 
> If the above is correct, how should it be handled ?

We'd need to adjust the init priority of libcrc32c and whatever
it depends on.

What is the user in question?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
