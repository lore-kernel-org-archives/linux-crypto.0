From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Questions about ahash
Date: Mon, 25 Oct 2010 19:42:06 -0400
Message-ID: <20101025234206.GA6046@gondor.apana.org.au>
References: <8A0E4C92AE2D6D40AF99653191DA32316140FE940B@rrsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: "Allyn, Mark A" <mark.a.allyn@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:39832 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758305Ab0JYXmJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Oct 2010 19:42:09 -0400
Content-Disposition: inline
In-Reply-To: <8A0E4C92AE2D6D40AF99653191DA32316140FE940B@rrsmsx501.amr.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Allyn, Mark A <mark.a.allyn@intel.com> wrote:
> Folks:
> 
> I am attempting to implement an ahash instance for a hardware crypto device.
> 
> I see that there is a sha1 generic in the soruces a crypto/sha1_generic.c which uses the shash interface. I was hoping to use that, but there is some stuff in the headers that is confusing.

You should use shash only if your hardware is synchronous, e.g.,
the AESNI instruction is a good example where a synchronous
interface is appropriate.

The reason crypto_ahash is so different is because it should be
used where you need an asynchronous interface, where state has
to be stored indefinitely.

> There is a function shash_desc_ctx, but there is no function ahash_des_ctx. In the crys_sha1_init() function of sha1_generic, you call shash_desc_ctx. If I want to use the ahash instead of shash for sha1, then do I use shash_desc_ctx, or do I have to come up with my own ahash_desc_ctx?

The counterpart to shash_desc_ctx is ahash_request_ctx.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
