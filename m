From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 01/16] crypto: sha1: implement base layer for SHA-1
Date: Wed, 8 Apr 2015 22:06:34 +0800
Message-ID: <20150408140633.GA30047@gondor.apana.org.au>
References: <1428396724-19962-1-git-send-email-ard.biesheuvel@linaro.org>
 <1428396724-19962-2-git-send-email-ard.biesheuvel@linaro.org>
 <20150408131916.GA29646@gondor.apana.org.au>
 <CAKv+Gu9gQqQEEXgJ=JhVf=7SURx9BfRiaJkakhGv1S9FsqujaQ@mail.gmail.com>
 <20150408133050.GB29646@gondor.apana.org.au>
 <CAKv+Gu-=obTKmviwH9B2wBi==LQa_-aAXVU9QPh1gUeYyopmVw@mail.gmail.com>
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
Received: from helcar.hengli.com.au ([209.40.204.226]:47857 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834AbbDHOGl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Apr 2015 10:06:41 -0400
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-=obTKmviwH9B2wBi==LQa_-aAXVU9QPh1gUeYyopmVw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 08, 2015 at 03:40:56PM +0200, Ard Biesheuvel wrote:
>
> This is not the partial code path, it is the .finup path, in fact.
> Anything that hashes data that is often a multiple of the block size
> (which is more likely for block based applications than for IPsec, I
> think) should benefit from this. But even if it is not, using a head
> block and a pointer to the src eliminates one call of the block
> transform.

This would only ever happen if you call update on a partial block
which should be the slow path anyway.

IPsec only calls digest so it can never do a partial block update
unless you have a badly fragmented skb.

Incidentally if you did want to deal with such cases in light
of the high overhead that you have you may want to switch over
to ahash which would allow you to do the saving and restoring
once per operation rather than once per SG entry.

> OK, so there are 2 pieces of crap [sic] in this proposed generic layer:
> - the head block
> - the generic pointer

Yes your patches look great otherwise.  I just want to keep things
simple because you're creating a template for all future SHA authors.

> The generic pointer is used in the arm64 case to convey the
> information that the current invocation of the block transform is the
> final one, and the core code can apply the padding and finalize /and/
> pass back whether it has done so or not. (the latter can easily be
> done in the C code as well)  I used a generic pointer to allow other
> uses, but if you have a better idea for this particular use case, I'd
> be happy to hear it.

As I said in the original email, this appears to be equivalent to

	(sctx->count + len) % SHA1_BLOCK_SIZE != 0

So why not just do that check in C? It'll get compiled into a
simple mask so it should be no slower than a branch on finalize.

In fact if your assembly function always updates sctx->count
then you could simplify that to

	sctx->count % SHA1_BLOCK_SIZE != 0

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
