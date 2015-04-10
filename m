From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 00/16] crypto: SHA glue code consolidation
Date: Fri, 10 Apr 2015 21:42:51 +0800
Message-ID: <20150410134251.GB21873@gondor.apana.org.au>
References: <1428576948-23863-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	x86@kernel.org, samitolvanen@google.com, jussi.kivilinna@iki.fi,
	stockhausen@collogia.de
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56270 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964851AbbDJNnE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Apr 2015 09:43:04 -0400
Content-Disposition: inline
In-Reply-To: <1428576948-23863-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 09, 2015 at 12:55:32PM +0200, Ard Biesheuvel wrote:
> Hello all,
> 
> This is v4 of what is now a complete glue code consolidation series
> for generic, x86, arm and arm64 implementations of SHA-1, SHA-224/256
> and SHA-384/512.
> 
> The purpose is to have a single, canonical implementation of the core
> logic that gets reused by all versions of the algorithm. Note that this
> is not about saving space in the binary, but about ensuring that the same
> code is used everywhere, reducing the maintenance burden.
> 
> The base layer implements all the update and finalization logic around
> the block transforms, where the prototypes of the latter look something
> like this:
> 
> typedef void (shaXXX_block_fn)(struct sha###_state *, u8 const *src, int blocks)
> 
> Note that the definitions of sha1_state, sha256_state and sha512_state are
> updated to put the state[] member first: this allows us to easily cast
> existing asm implementation that take a state[] member as first argument
> to the above prototype.
> 
> Note that the base functions prototypes are all 'returning int' but
> they all return 0. They should be invoked as tail calls where possible
> to eliminate some of the function call overhead. If that is not possible,
> the return values can be safely ignored.

All applied.  Thanks Ard!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
