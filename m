Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3542BC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Feb 2022 14:56:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243268AbiBJO41 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Feb 2022 09:56:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235162AbiBJO41 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Feb 2022 09:56:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B46D3CFA
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 06:56:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5071061B05
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 14:56:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D7AC004E1;
        Thu, 10 Feb 2022 14:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644504986;
        bh=rG+NXBoAEk1MZXvGL91xDtJeUiS+WD5MxBo/nFkCrIc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OgvzmXvOMZG+bomDVSCd4n+u93YZ5Jo46IRTMmAWk2VaHw93ZV1UoTqO0aJHZ8TEx
         YliCOwurDtNhsFHQjZn/+Efo3ArEIA1Nl05hOY93Kt7D/voRRDRmEbU+jMiTKg9qyX
         vrF6owhIyj+VeM8XDqfji76Y2XvVqaI8Fj7IsjH4=
Date:   Thu, 10 Feb 2022 15:56:23 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sandy Harris <sandyinchina@gmail.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ted Ts'o <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/4] random: Add a pseudorandom generator based on the
 xtea cipher
Message-ID: <YgUnl6vO0H6YI14Y@kroah.com>
References: <CACXcFmnkeFJ2e7A4HOfTJ90ps956xZnoQ=RiZd=7=cZTzxGwMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACXcFmnkeFJ2e7A4HOfTJ90ps956xZnoQ=RiZd=7=cZTzxGwMw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 10, 2022 at 10:38:28PM +0800, Sandy Harris wrote:
> Add a pseudorandom generator based on the xtea cipher
> 
> This will be used only within the kernel, mainly within the driver
> to rekey chacha or dump extra random data into the input pool.
> 
> It needs a 64-bit output to match arch_get_random_long(), and
> the obvious way to get that is a 64-bit block cipher.
> 
> xtea was chosen partly for speed but mainly because, unlike
> most other block ciphers, it does not use a lot of storage
> for round keys or S-boxes. This driver already has 4k bits
> in the input pool and 512 bits each for chacha and hash
> contexts; that is reasonable, but if anything we should
> be looking at ways to reduce storage use rather than
> increasing it.
> 
> ---
>  drivers/char/random.c | 294 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 294 insertions(+)
> 

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


If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
