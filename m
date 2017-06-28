From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 0/2] staging: ccree: Fix coding style and remove warnings
Date: Wed, 28 Jun 2017 12:45:18 +0300
Message-ID: <CAOtvUMdpwFaMDh2qCnB=keZQAc6ssXM+u39GPaf0ASGr002OJA@mail.gmail.com>
References: <1498642633-3260-1-git-send-email-karthik@techveda.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        sunil.m@techveda.org
To: karthik@techveda.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:36310 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751557AbdF1JpT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Jun 2017 05:45:19 -0400
Received: by mail-yw0-f194.google.com with SMTP id l21so1837051ywb.3
        for <linux-crypto@vger.kernel.org>; Wed, 28 Jun 2017 02:45:19 -0700 (PDT)
In-Reply-To: <1498642633-3260-1-git-send-email-karthik@techveda.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Thank you Karthik,

On Wed, Jun 28, 2017 at 12:37 PM,  <karthik@techveda.org> wrote:
> From: Karthik Tummala <karthik@techveda.org>
>
> This patch series fixes coding style and removes the following
> checkpatch.pl warnings:
>
> Prefer using '"%s...", __func__' to using the function's name,
> in a string.

This one is good.
>
> Braces {} are not necessary for single statement blocks.

I have already sent a patch addressing this and some other things
yesterday/

>
> Rebased on top of next-20170627.
> Patches were tested and built on next-20170627

Can you please check patch 1 still applies after yesterdays patch series?

>
> Karthik Tummala (2):
>   staging: ccree: Use __func__ instead of function name
>   staging: ccree: Remove braces {} for single statement blocks
>
>  drivers/staging/ccree/ssi_aead.c | 48 ++++++++++++++++------------------------
>  1 file changed, 19 insertions(+), 29 deletions(-)
>
> --
> 1.9.1
>

Thanks,
Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
