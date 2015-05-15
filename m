From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: re: crypto: nx - add hardware 842 crypto comp alg
Date: Fri, 15 May 2015 15:04:25 +0800
Message-ID: <20150515070424.GA17008@gondor.apana.org.au>
References: <20150514100944.GA19879@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ddstreet@ieee.org, linux-crypto@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52201 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009AbbEOHEe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 May 2015 03:04:34 -0400
Content-Disposition: inline
In-Reply-To: <20150514100944.GA19879@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Hello Dan Streetman,
> 
> This is a semi-automatic email about new static checker warnings.
> 
> The patch ed70b479c2c0: "crypto: nx - add hardware 842 crypto comp
> alg" from May 7, 2015, leads to the following Smatch complaint:
> 
> drivers/crypto/nx/nx-842-crypto.c:301 nx842_crypto_compress()
>         warn: variable dereferenced before check 'tfm' (see line 292)
> 
> drivers/crypto/nx/nx-842-crypto.c
>   288  static int nx842_crypto_compress(struct crypto_tfm *tfm,
>   289                                   const u8 *src, unsigned int slen,
>   290                                   u8 *dst, unsigned int *dlen)
>   291  {
>   292          struct nx842_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
>                                                              ^^^
> Dereference.
> 
>   293          struct nx842_crypto_header *hdr = &ctx->header;
>   294          struct nx842_crypto_param p;
>   295          struct nx842_constraints c;
>   296          unsigned int groups, hdrsize, h;
>   297          int ret, n;
>   298          bool add_header;
>   299          u16 ignore = 0;
>   300  
>   301          if (!tfm || !src || !slen || !dst || !dlen)
>                     ^^^
> Checked for NULL.
> 
>   302                  return -EINVAL;
>   303  

tfm can never be NULL so this should be removed.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
