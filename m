From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4 v2] crypto: sha512 - Remove W (message schedule)
	from struct sha512_ctx
Date: Thu, 4 Dec 2008 18:05:43 +0800
Message-ID: <20081204100543.GA19425@gondor.apana.org.au>
References: <12283831302697-git-send-email-ken@codelabs.ch> <12283831303264-git-send-email-ken@codelabs.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com
To: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:55666 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751342AbYLDKFq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Dec 2008 05:05:46 -0500
Content-Disposition: inline
In-Reply-To: <12283831303264-git-send-email-ken@codelabs.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 04, 2008 at 10:32:07AM +0100, Adrian-Ken Rueegsegger wrote:
>
>  static void
> -sha512_transform(u64 *state, u64 *W, const u8 *input)
> +sha512_transform(u64 *state, const u8 *input)
>  {
>  	u64 a, b, c, d, e, f, g, h, t1, t2;
> -
> +	u64 W[80];

This is too big for the stack.  So we need to put it somewhere
else.  A static per-cpu area is one choice.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
