Return-Path: <SRS0=USLa=UP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 460B4C31E49
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Jun 2019 07:19:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 118FA216F4
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Jun 2019 07:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560669594;
	bh=QbE/HsEOK6jT654m3mc71eeldrw0Z2q8RBbUl0Uf9aU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=1sSuR4pKBj4XOYtH4lrFFH77BnK6XTq7E8KVywOYyTFX9Gh9MJ2B0WYrrzeM7AbvD
	 5wIbJqO1fxvDObfxaHmhsjWsUm4QAGyvW01XeeEhsLDZRMUUZvUVQY6pGapyHdVuR2
	 9dW2ugHvXp1sU70h8SNEwXhVid36IOT81e/LVHwI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbfFPHTx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 16 Jun 2019 03:19:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbfFPHTx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 16 Jun 2019 03:19:53 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEC93216C8;
        Sun, 16 Jun 2019 07:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560669592;
        bh=QbE/HsEOK6jT654m3mc71eeldrw0Z2q8RBbUl0Uf9aU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r/Tl1lG2dhQCDmM3itqPCuRPFY5nJY4/vfbvDMyqEYHMOfbuA8tJ2F+npHRBQ3aDa
         wVjQYIrq1WQBtSMHd2pWgjxqOPJL8CSpFT0VFy+5G475RCv1d49yJ5xc79faqs7tNc
         e4L10++S1av+Jw5xXq8uDcQ3mb2dsi8cwtVD9vPI=
Date:   Sun, 16 Jun 2019 00:19:51 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-usb <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3] wusb: switch to cbcmac transform
Message-ID: <20190616071951.GC698@sol.localdomain>
References: <20190615091745.3100-1-ard.biesheuvel@linaro.org>
 <20190616012056.GA698@sol.localdomain>
 <CAKv+Gu_j_y3oSPy8JbTdNYVjzsSw72gM+UcC6+u_WBtw6opX2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_j_y3oSPy8JbTdNYVjzsSw72gM+UcC6+u_WBtw6opX2Q@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Jun 16, 2019 at 08:52:32AM +0200, Ard Biesheuvel wrote:
> On Sun, 16 Jun 2019 at 03:20, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Sat, Jun 15, 2019 at 11:17:45AM +0200, Ard Biesheuvel wrote:
> > > The wusb code takes a very peculiar approach at implementing CBC-MAC,
> > > by using plain CBC into a scratch buffer, and taking the output IV
> > > as the MAC.
> > >
> > > We can clean up this code substantially by switching to the cbcmac
> > > shash, as exposed by the CCM template. To ensure that the module is
> > > loaded on demand, add the cbcmac template name as a module alias.
> > >
> > > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > > ---
> > > v3: - add missing #include to fix build error spotted by kbuild test robot
> > > v2: - use finup()/digest() where possible, and process b0+b1 using a single
> > >       call to update()
> > >     - make 'stv_hsmic_hs' static const and remove comment regarding GCC 4.1
> > >
> > > NOTE: I don't have any hardware to test this, but the built-in selftest
> > >       still passes.
> > >
> > >  crypto/ccm.c                  |   1 +
> > >  drivers/usb/wusbcore/crypto.c | 169 +++++---------------
> > >  2 files changed, 45 insertions(+), 125 deletions(-)
> > >
> >
> > drivers/usb/wusbcore/Kconfig also needs to be updated:
> >
> > diff --git a/drivers/usb/wusbcore/Kconfig b/drivers/usb/wusbcore/Kconfig
> > index 12e89189ca7d..2ec17d6af1f8 100644
> > --- a/drivers/usb/wusbcore/Kconfig
> > +++ b/drivers/usb/wusbcore/Kconfig
> > @@ -6,9 +6,7 @@ config USB_WUSB
> >         tristate "Enable Wireless USB extensions"
> >         depends on UWB
> >          select CRYPTO
> > -        select CRYPTO_BLKCIPHER
> > -        select CRYPTO_CBC
> > -        select CRYPTO_MANAGER
> 
> We'll need this one, as it isn't implied by any of the other ones, and
> cbcmac(aes) will be composed of the ccm template and the aes cipher on
> all architectures except arm64.
> 
> > +        select CRYPTO_CCM

Are you talking about CRYPTO_MANAGER?  One of my recent patches added
'select CRYPTO_MANAGER' to the templates that didn't already select it,
including CCM.  See in cryptodev.git:

	commit c8a3315a5f691cc4be16421aeb0608495c9a33ba
	Author: Eric Biggers <ebiggers@google.com>
	Date:   Mon May 20 09:49:46 2019 -0700

	    crypto: make all templates select CRYPTO_MANAGER

So it shouldn't need to be selected here.

- Eric
