From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1] crypto: api.c: doc on crypto_alg_lookup,
	crypto_larval_lookup, and crypto_alg_mod_lookup
Date: Sun, 7 Nov 2010 09:10:16 +0800
Message-ID: <20101107011016.GA20564@gondor.apana.org.au>
References: <8A0E4C92AE2D6D40AF99653191DA32316141414460@rrsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: lee.nipper@gmail.com, linux-crypto@vger.kernel.org
To: "Allyn, Mark A" <mark.a.allyn@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:46436 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab0KGBKW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 6 Nov 2010 21:10:22 -0400
Content-Disposition: inline
In-Reply-To: <8A0E4C92AE2D6D40AF99653191DA32316141414460@rrsmsx501.amr.corp.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Allyn, Mark A <mark.a.allyn@intel.com> wrote:
> 
> I was making an assumption that larval is shorthand for large value as there is nothing meaningful in google except for a type of wormlike form.

Larval means not fully grown in this context, i.e., the algorithm
that we've constructed will be filled in later to become a real
algorithm object.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
