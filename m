From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto_alg and alignment
Date: Sat, 2 Apr 2011 22:41:45 +0800
Message-ID: <20110402144145.GA6990@gondor.apana.org.au>
References: <AANLkTinXJP27s54yyPtmGBWADSLRZ6YfOFgcciycYGy=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Vladimir Zapolskiy <vzapolskiy@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:51319 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab1DBOls (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 2 Apr 2011 10:41:48 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTinXJP27s54yyPtmGBWADSLRZ6YfOFgcciycYGy=@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Vladimir Zapolskiy <vzapolskiy@gmail.com> wrote:
> 
> I'm trying to implement a driver for one hardware crypto engine, and
> on the current stage I work with AES algorithm, and I have a couple of
> open questions.
> 
> 1) What shall be guaranteed from crypto engine by providing
>   cra_blocksize and cra_alignmask values in crypto_alg definition? If
>   they are provided, can I rely that in ablkcipher request I get
>   aligned source and destination, and size of each chunk in sglist is
>   aligned to cra_blocksize?

The block size is that of the underlying block cipher algorithm,
e.g., 16 for AES.  The alignmask is the required alignment minus 1.

Unlike skcipher which gets preprocessed input data that is always
aligned, ablkcipher gets the raw input (apart from setkey which
will ensure that the key is aligned).

However, the ablkcipher helpers in crypto/ablkcipher.c will help
you to align things where necessary.

> 2) I've taken a look at
> http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg04903.html
>   and I wonder, is someone working with SOCK_STREAM protocol
>   realization for AF_ALG? And is there some planned activities about
>   implementing setsockopt support for ALG_SET_IV, ALG_SET_OP etc. in
>   algif_skcipher?

It's already in the kernel as of 2.6.38.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
