Return-Path: <SRS0=ESNp=7Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2937BC433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jun 2020 12:15:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69C4F20801
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jun 2020 12:15:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="ey2lKl9R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgFLMP4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Jun 2020 08:15:56 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:18177 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbgFLMPz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Jun 2020 08:15:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1591964153;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=AIUmlt5CcSDtuZQQlFcPMDfEa0sx9vaOrg4dJGzkhog=;
        b=ey2lKl9RPMSn6YFkvWsvPqhOC2tahDfpgTerUTGGPPBgecMG7SccE9d7gEr7vCF+el
        R2Ist2mL2JoQ+RFG2jKOVFEDouPjdgFhyPK+SW2gm+0tJTXqX35YodGYjGcQaFZsCTWe
        6bkNtabjxYrNI/P8TwfPFbdK5clA30t+mcwJOYdYCa6xaVP8Vw7y8204rQFacaUnaE8H
        su4XuCbBxeIXVvM1tz5fNs6dL08AYxaGv4Vzm6CEtmwpMP/2c8sOaKSVhiT05PSjKH9R
        frph9qvKTcYYPSCcx3rTR9ArE2ANSBhfxKy8TOSrear3D+WcgP0Ez6h7ILjR/ut5goBA
        i/pw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaL/SXH98="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.10.4 DYNA|AUTH)
        with ESMTPSA id U03fedw5CCFq306
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 12 Jun 2020 14:15:52 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 1/3] crypto: skcipher - Add final chunk size field for chaining
Date:   Fri, 12 Jun 2020 14:15:52 +0200
Message-ID: <1688262.LSb4nGpegl@tauon.chronox.de>
In-Reply-To: <E1jjiTA-0005BO-9n@fornost.hmeau.com>
References: <20200612120643.GA15724@gondor.apana.org.au> <E1jjiTA-0005BO-9n@fornost.hmeau.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 12. Juni 2020, 14:07:36 CEST schrieb Herbert Xu:

Hi Herbert,

> Crypto skcipher algorithms in general allow chaining to break
> large operations into smaller ones based on multiples of the chunk
> size.  However, some algorithms don't support chaining while others
> (such as cts) only support chaining for the leading blocks.
> 
> This patch adds the necessary API support for these algorithms.  In
> particular, a new request flag CRYPTO_TFM_REQ_MORE is added to allow
> chaining for algorithms such as cts that cannot otherwise be chained.
> 
> A new algorithm attribute fcsize has also been added to indicate
> how many blocks at the end of a request that cannot be chained and
> therefore must be withheld if chaining is attempted.
> 
> This attribute can also be used to indicate that no chaining is
> allowed.  Its value should be set to -1 in that case.

Thanks for the patch set.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
> 
>  include/crypto/skcipher.h |   24 ++++++++++++++++++++++++
>  include/linux/crypto.h    |    1 +
>  2 files changed, 25 insertions(+)
> 
> diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
> index 141e7690f9c31..8b864222e6ce4 100644
> --- a/include/crypto/skcipher.h
> +++ b/include/crypto/skcipher.h
> @@ -97,6 +97,8 @@ struct crypto_sync_skcipher {
>   * @walksize: Equal to the chunk size except in cases where the algorithm
> is * 	      considerably more efficient if it can operate on multiple
> chunks * 	      in parallel. Should be a multiple of chunksize.
> + * @fcsize: Number of bytes that must be processed together at the end.
> + *	     If set to -1 then chaining is not possible.
>   * @base: Definition of a generic crypto algorithm.
>   *
>   * All fields except @ivsize are mandatory and must be filled.
> @@ -114,6 +116,7 @@ struct skcipher_alg {
>  	unsigned int ivsize;
>  	unsigned int chunksize;
>  	unsigned int walksize;
> +	int fcsize;
> 
>  	struct crypto_alg base;
>  };
> @@ -279,6 +282,11 @@ static inline unsigned int
> crypto_skcipher_alg_chunksize( return alg->chunksize;
>  }
> 
> +static inline int crypto_skcipher_alg_fcsize(struct skcipher_alg *alg)
> +{
> +	return alg->fcsize;
> +}
> +
>  /**
>   * crypto_skcipher_chunksize() - obtain chunk size
>   * @tfm: cipher handle
> @@ -296,6 +304,22 @@ static inline unsigned int crypto_skcipher_chunksize(
>  	return crypto_skcipher_alg_chunksize(crypto_skcipher_alg(tfm));
>  }
> 
> +/**
> + * crypto_skcipher_fcsize() - obtain number of final bytes
> + * @tfm: cipher handle
> + *
> + * For algorithms such as CTS the final chunks cannot be chained.
> + * This returns the number of final bytes that must be withheld
> + * when chaining.
> + *
> + * Return: number of final bytes
> + */
> +static inline unsigned int crypto_skcipher_fcsize(
> +	struct crypto_skcipher *tfm)
> +{
> +	return crypto_skcipher_alg_fcsize(crypto_skcipher_alg(tfm));

Don't we have an implicit signedness conversion here? int -> unsigned int?
> +}
> +
>  static inline unsigned int crypto_sync_skcipher_blocksize(
>  	struct crypto_sync_skcipher *tfm)
>  {
> diff --git a/include/linux/crypto.h b/include/linux/crypto.h
> index 763863dbc079a..d80dccf472595 100644
> --- a/include/linux/crypto.h
> +++ b/include/linux/crypto.h
> @@ -110,6 +110,7 @@
>  #define CRYPTO_TFM_REQ_FORBID_WEAK_KEYS	0x00000100
>  #define CRYPTO_TFM_REQ_MAY_SLEEP	0x00000200
>  #define CRYPTO_TFM_REQ_MAY_BACKLOG	0x00000400
> +#define CRYPTO_TFM_REQ_MORE		0x00000800
> 
>  /*
>   * Miscellaneous stuff.


Ciao
Stephan


