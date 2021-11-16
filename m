Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2B67C433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 11:49:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE116611C3
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 11:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235421AbhKPLwm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Nov 2021 06:52:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:42646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235621AbhKPLwQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Nov 2021 06:52:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 362CF61507;
        Tue, 16 Nov 2021 11:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637063359;
        bh=ltnwVkm+/9lPDIu3OTfyYvoXGXjInw+a7bphTvljOYk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0j79+bJyAjRL40BhpORoBUK/QLN7+SUlloYLNgmGgNhPXBsbKNcXBQCvWnDwGrsMp
         NmPh7/OSo30bALWMOsR/9RjxxsuEw1A62QGhiZmjVbXncbTbEWlQQlStIfHWRxCwMK
         Z5xzmf06mykSINjERBZw5atJLYpqz/ycBVulCOgs=
Date:   Tue, 16 Nov 2021 12:49:17 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sandy Harris <sandyinchina@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/8] Replace memset() with memzero_explicit()
Message-ID: <YZOavRak9sxXKZMq@kroah.com>
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
> --

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- Your patch does not have a Signed-off-by: line.  Please read the
  kernel file, Documentation/SubmittingPatches and resend it after
  adding that line.  Note, the line needs to be in the body of the
  email, before the patch, not at the bottom of the patch or in the
  email signature.

- You did not write a descriptive Subject: for the patch, allowing Greg,
  and everyone else, to know what this patch is all about.  Please read
  the section entitled "The canonical patch format" in the kernel file,
  Documentation/SubmittingPatches for what a proper Subject: line should
  look like.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
