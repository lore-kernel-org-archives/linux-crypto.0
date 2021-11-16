Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15A95C4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 11:51:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 033B7619E8
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 11:51:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235590AbhKPLyY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Nov 2021 06:54:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:43234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235600AbhKPLyB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Nov 2021 06:54:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28E3E617E4;
        Tue, 16 Nov 2021 11:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637063460;
        bh=XA/nVyuSqCQwJvSumwNtOCvTk0XF+pHit+xMMiZ+vQg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vgJu23Q58AmUmvYJ8mHf+XYkmjR/I9kKpqZDVAz2zehyFTUQVJQzzQnQ/ka3v9ZKh
         RC+L+WWWLKPBcGsbXhRcwXr1s3+Fd+XUBpc7zc14HbAGOUEGpM4P7EKfV0ifbE35Fy
         DPHUKXT+pdyFD0jiKS5SFNrvb8USCRwuzKf9BRls=
Date:   Tue, 16 Nov 2021 12:50:58 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sandy Harris <sandyinchina@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/8] Replace memset() with memzero_explicit()
Message-ID: <YZObImtJITs1ZfUc@kroah.com>
References: <CACXcFm=kwziZ5Etdevu0uq_t5qy0NbGY753WfLvnwkMqtU9Tvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACXcFm=kwziZ5Etdevu0uq_t5qy0NbGY753WfLvnwkMqtU9Tvg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 16, 2021 at 07:25:22PM +0800, Sandy Harris wrote:
> Replace memset(address,0,bytes) which may be optimised away
> with memzero_explicit(address,bytes) which resists
> such optimisation
> 
> ---
>  crypto/des_generic.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/crypto/des_generic.c b/crypto/des_generic.c
> index c85354a5e94c..105a32e7afea 100644
> --- a/crypto/des_generic.c
> +++ b/crypto/des_generic.c
> @@ -30,7 +30,7 @@ static int des_setkey(struct crypto_tfm *tfm, const u8 *key,
>              err = 0;
>      }
>      if (err)
> -        memset(dctx, 0, sizeof(*dctx));
> +        memzero_explicit(dctx, sizeof(*dctx));
>      return err;
>  }
> 
> @@ -62,7 +62,7 @@ static int des3_ede_setkey(struct crypto_tfm *tfm,
> const u8 *key,
>              err = 0;
>      }
>      if (err)
> -        memset(dctx, 0, sizeof(*dctx));
> +        memzero_explicit(dctx, sizeof(*dctx));
>      return err;
>  }
> 

Have you looked at the output of the compiler to see if this really is
needed or not?

And what exactly are you zeroing out that could be read afterward
somehow?

thanks,

greg k-h
