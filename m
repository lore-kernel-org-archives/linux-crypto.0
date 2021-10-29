Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0208C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 13:07:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94D7B60724
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Oct 2021 13:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhJ2NKL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Oct 2021 09:10:11 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:56390 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231401AbhJ2NKK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Oct 2021 09:10:10 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mgRbg-0002jJ-UI; Fri, 29 Oct 2021 21:07:40 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mgRbf-0001wH-Fs; Fri, 29 Oct 2021 21:07:39 +0800
Date:   Fri, 29 Oct 2021 21:07:39 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Sunil Goutham <sgoutham@marvell.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: cavium: Check health status while reading random
 data
Message-ID: <20211029130739.GA7431@gondor.apana.org.au>
References: <1634929505-16205-1-git-send-email-sgoutham@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1634929505-16205-1-git-send-email-sgoutham@marvell.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Oct 23, 2021 at 12:35:05AM +0530, Sunil Goutham wrote:
>
> diff --git a/drivers/char/hw_random/cavium-rng-vf.c b/drivers/char/hw_random/cavium-rng-vf.c
> index 3de4a6a..6f66919 100644
> --- a/drivers/char/hw_random/cavium-rng-vf.c
> +++ b/drivers/char/hw_random/cavium-rng-vf.c
>
> @@ -15,16 +12,146 @@
>  #include <linux/pci.h>
>  #include <linux/pci_ids.h>
>  
> +#include <asm/arch_timer.h>

This breaks compile testing.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
