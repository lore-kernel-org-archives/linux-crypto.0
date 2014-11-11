From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Asynchronous usage of PCOMPRESS
Date: Tue, 11 Nov 2014 23:02:37 +0800
Message-ID: <20141111150237.GA18710@gondor.apana.org.au>
References: <54610113.3040200@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:33619 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaKKPCm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Nov 2014 10:02:42 -0500
Content-Disposition: inline
In-Reply-To: <54610113.3040200@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 10, 2014 at 12:16:51PM -0600, Tom Lendacky wrote:
> Hi Herbert,
> 
> Is the PCOMPRESS algorithm supposed to support asynchronous
> implementations? In other words, are callers expected to handle the
> -EINPROGRESS or -EAGAIN return codes that can be returned by an
> asynchronous implementation?
> 
> Or is it assumed that if the CRYPTO_ALG_ASYNC flag is not set then the
> code path must be synchronous?  If that's the case, should the pcompress
> support be updated to look for synchronous implementations if the
> CRYPTO_ALG_ASYNC flag isn't set or should asynchronous implementations
> provide a synchronous fallback?

The pcomp interface is entirely synchronous so for async support
you'll have to create a new interface.  pcomp is simply meant to
replace the existing compress interface but unfortunately that job
has not been completed as yet.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
