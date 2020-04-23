Return-Path: <SRS0=jAnl=6H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C0C0C54FD0
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Apr 2020 20:23:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E75F720776
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Apr 2020 20:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587673432;
	bh=BR2ueSz7ASah2Qj1j+lIsnggO9xKucy4nF+BDyOZFpw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=UyUxaHM6x+LbYf0Qo2OztVmIyw12Cu2Q7F8iE9nWfa6uin8wl5AfUmF1id/aB4XfH
	 reTvzxqP3CuYdccM04og3ywrz822XAaKZrtsAilY8yWEqcXDN6ljvxUFoj33uVMWIw
	 ze+s0nXzmJJRSTrmQQpYXBvPohJMi6h2CzW7Nc+8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbgDWUXv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Apr 2020 16:23:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbgDWUXv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Apr 2020 16:23:51 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53FFA20715;
        Thu, 23 Apr 2020 20:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587673430;
        bh=BR2ueSz7ASah2Qj1j+lIsnggO9xKucy4nF+BDyOZFpw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=w6cnn6F2H3fSqnb/XLyv8+MJAFIunaS9r575x4GMPiUTlGQRKXAf2FAbt+P3fmFre
         c2Kp+j8aO4quCbVhBKeZXN3OEyXz+/CF1EpzBMf+F4/huwGJwXiFAYklm6HTsCY4up
         HGls3nUysoziGvVHP5aUxq+hvvvtD0FqKg8jasFA=
Date:   Thu, 23 Apr 2020 13:23:48 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-rt-users@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH crypto-stable v3 1/2] crypto: arch/lib - limit simd usage
 to 4k chunks
Message-ID: <20200423202348.GA2796@gmail.com>
References: <20200422200344.239462-1-Jason@zx2c4.com>
 <20200422231854.675965-1-Jason@zx2c4.com>
 <CAMj1kXHV=ryaFmj0jhQVGBd31nfHs7q5RtSyu7dY6GdEJJsr7A@mail.gmail.com>
 <20200423184219.GA80650@kroah.com>
 <CAMj1kXF9uLUE3=rX1i_yYoigB7j-nLMZpGc35ve2KV+NxjRhVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXF9uLUE3=rX1i_yYoigB7j-nLMZpGc35ve2KV+NxjRhVQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 23, 2020 at 08:47:00PM +0200, Ard Biesheuvel wrote:
> On Thu, 23 Apr 2020 at 20:42, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Apr 23, 2020 at 09:18:15AM +0200, Ard Biesheuvel wrote:
> > > FYI: you shouldn't cc stable@vger.kernel.org directly on your patches,
> > > or add the cc: line. Only patches that are already in Linus' tree
> > > should be sent there.
> >
> > Not true at all, please read:
> >     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> > for how to do this properly.  Please do not spread incorrect
> > information.
> >
> > And Jason did this properly, he put cc: stable@ in the s-o-b area and
> > all is good, I will pick up this patch once it hits Linus's tree.
> >
> > And there is no problem actually sending the patch to stable@vger while
> > under development like this, as it gives me a heads-up that something is
> > coming, and is trivial to filter out.
> >
> > If you really want to be nice, you can just do:
> >         cc: stable@kernel.org
> > which goes to /dev/null on kernel.org, so no email will be sent to any
> > list, but my scripts still pick it up.  But no real need to do that,
> > it's fine.
> >
> 
> OK, thanks for clearing this up.
> 
> So does this mean you have stopped sending out 'formletter'
> auto-replies for patches that were sent out to stable@vger.kernel.org
> directly, telling people not to do that?
> 

I often leave stable@vger.kernel.org in the email Cc list, and no one has ever
complained.  It's only sending patches directly "To:" stable@vger.kernel.org
that isn't allowed, except when actually sending out backports.

If there were people who had an actual issue with Cc, then I think the rules
would have changed long ago to using some other tag like Backport-to that
doesn't get picked up by git send-email.

- Eric
