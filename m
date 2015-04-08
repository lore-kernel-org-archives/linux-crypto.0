From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 01/16] crypto: sha1: implement base layer for SHA-1
Date: Wed, 8 Apr 2015 21:30:50 +0800
Message-ID: <20150408133050.GB29646@gondor.apana.org.au>
References: <1428396724-19962-1-git-send-email-ard.biesheuvel@linaro.org>
 <1428396724-19962-2-git-send-email-ard.biesheuvel@linaro.org>
 <20150408131916.GA29646@gondor.apana.org.au>
 <CAKv+Gu9gQqQEEXgJ=JhVf=7SURx9BfRiaJkakhGv1S9FsqujaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"x86@kernel.org" <x86@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	Markus Stockhausen <stockhausen@collogia.de>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59633 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbbDHNaz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Apr 2015 09:30:55 -0400
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9gQqQEEXgJ=JhVf=7SURx9BfRiaJkakhGv1S9FsqujaQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 08, 2015 at 03:25:14PM +0200, Ard Biesheuvel wrote:
>
> Not having to call the function twice is the whole point. In the arm64
> case, all the SHA-256 round keys can be kept in registers (it has 32
> 16-byte SIMD registers), and that is what motivates this pattern. By
> passing a head block, a pointer to the source and the generic pointer
> (which arm64 uses to finalize the block, we can process all data in a
> single invocation of the block transform)

Does this really make any difference? With IPsec the partial code
path is never even going to get executed.

> Do note that these are only used by static inline functions, so the
> unused arguments are all eliminated from the binary anyway. In fact,
> looking at the generated code, the function calls don't use function
> pointers at all anymore,
> but just call the block transform directly, so the typedef is only
> used as a prototype, really.

It's not just the generated code.  The next guy that comes along
and writes a SHA implementation is going to go WTH is this p
argument.  I'm not going to add crap to the generic layer just
because ARM needs it.  In fact ARM doesn't even need it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
