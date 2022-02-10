Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71124C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Feb 2022 14:55:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242942AbiBJOzg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Feb 2022 09:55:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243236AbiBJOzg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Feb 2022 09:55:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3BB996
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 06:55:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F5FB61B00
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 14:55:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11696C004E1;
        Thu, 10 Feb 2022 14:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644504935;
        bh=2hfUD5mT5w8B7JV3mXkL6xja4Lew5b3nlh+7KfU5WAY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fpNzvFc8JJAZ2NOAYquAorf42qX9wMli/0WlWPe6jpQkNIIz69Lbms3/syLl4XGxc
         I/QSiUmXi6IL2OlBdIcyRxp5DwGrGjfdlBvneqhba2Lx7lKewubAwFKRMMadrRTF/h
         6fM5R0j8Z0+WPJOEoB7nKsUIsMhwN2RKnXnU/X9U=
Date:   Thu, 10 Feb 2022 15:55:32 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sandy Harris <sandyinchina@gmail.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ted Ts'o <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3/4] random: get_source_long() function
Message-ID: <YgUnZBJBIFRWS5LD@kroah.com>
References: <CACXcFm=whnpd3v5gJAoTJ-pL27NOOkMKvD3W_RQXy1kj2B6p=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACXcFm=whnpd3v5gJAoTJ-pL27NOOkMKvD3W_RQXy1kj2B6p=g@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 10, 2022 at 10:41:53PM +0800, Sandy Harris wrote:
> This function gets random data from the best available source
> 
> The current code has a sequence in several places that calls one or
> more of arch_get_random_long() or related functions, checks the
> return value(s) and on failure falls back to random_get_entropy().
> get_source long() is intended to replace all such sequences.
> 
> This is better in several ways. In the fallback case it gives
> much more random output than random_get_entropy(). It never
> wastes effort by calling arch_get_random_long() et al. when
> the relevant config variables are not set. When it does use
> arch_get_random_long(), it does not deliver raw output from
> that function but masks it by mixing with stored random data.
> 
> Signed-off-by: Sandy Harris <sandyinchina@gmail.com>
> ---
>  drivers/char/random.c | 74 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 74 insertions(+)
> 
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index 9edf65ad4259..6c77fd056f66 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -1031,6 +1031,80 @@ static void xtea_rekey(void)
>      xtea_iterations = 0 ;
>  }
> 
> +/**************************************************************************
> + * Load a 64-bit word with data from whatever source we have
> + *
> + *       arch_get_random_long()
> + *       hardware RNG
> + *       emulated HWRNG in a VM
> + *
> + * When there are two sources, alternate.
> + * If you have no better source, or if one fails,
> + * fall back to get_xtea_long()
> + *
> + * This function always succeeds, which allows some
> + * simplifications elsewhere in the code.
> + *
> + * This is intended only for use inside the kernel.
> + * Any data sent to user space should come from the
> + * chacha-based crng construction.
> + ***************************************************************************/
> +
> +static int load_count = 0;
> +#define COUNT_RESTART 128
> +
> +/*
> + * Add a mask variable so we can avoid using data
> + * from any source directly as output.
> + */
> +static unsigned long source_mask ;
> +
> +/*
> + * Use xtea sometimes even if we have a good source
> + * Avoids trusting the source completely
> + */
> +#define MIX_MASK 15
> +
> +static void get_source_long(unsigned long *x)
> +{
> +    int a, b ;
> +    int ret = 0 ;
> +

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

- Your patch contains warnings and/or errors noticed by the
  scripts/checkpatch.pl tool.

- Your patch is malformed (tabs converted to spaces, linewrapped, etc.)
  and can not be applied.  Please read the file,
  Documentation/email-clients.txt in order to fix this.


If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
