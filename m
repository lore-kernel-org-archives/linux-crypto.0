From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3/3] staging: ccree: simplify ioread/iowrite
Date: Mon, 6 Nov 2017 16:46:54 +0100
Message-ID: <20171106154654.GA15407@kroah.com>
References: <1509951354-16370-1-git-send-email-gilad@benyossef.com>
 <1509951354-16370-4-git-send-email-gilad@benyossef.com>
 <20171106083736.GJ18478@eros>
 <CAOtvUMcjUJw_hRwf+4pEv9-yXwgjnRrUpWbyASFt6AFjfTyOpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Tobin C. Harding" <me@tobin.cc>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43808 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932155AbdKFPqm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Nov 2017 10:46:42 -0500
Content-Disposition: inline
In-Reply-To: <CAOtvUMcjUJw_hRwf+4pEv9-yXwgjnRrUpWbyASFt6AFjfTyOpg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 06, 2017 at 10:59:47AM +0200, Gilad Ben-Yossef wrote:
> On Mon, Nov 6, 2017 at 10:37 AM, Tobin C. Harding <me@tobin.cc> wrote:
> > On Mon, Nov 06, 2017 at 06:55:52AM +0000, Gilad Ben-Yossef wrote:
> >> Registers ioread/iowrite operations were done via macros,
> >> sometime using a "magical" implicit parameter.
> >>
> >> Replace all register access with simple inline macros.
> >>
> >> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> >
> > Hi,
> >
> > Nice work. I had a little trouble following this one. Perhaps you are
> > doing more than one thing per patch, feel free to ignore me if I am
> > wrong but it seems you are moving the macro definition of CC_REG to a
> > different header, adding the new inline functions and doing some other
> > change that I can't grok (commented on below).
> >
> > Perhaps this patch could be broken up.
> 
> Thank you Tobin.
> 
> The original macro that I am replacing had an assumption of a variable void *
> cc_base being defined in the context of the macro being called, even though
> it was not listed in the explicit parameter list of the macro.
> 
> The inline function that replace it instead takes an explicit
> parameter a pointer to
> struct ssi_drive data * , who has said cc_base as one of the fields.
> 
> As a result several function that took a void * cc_base parameter
> (which is than only
> used implicitly via the macro without ever being visibly referenced), now take
> struct ssi_drive data * parameter instead which is passed explicitly
> to the inline
> function.
> 
> These seems to be the places you are referring to. They are cascading changes
> resulting from the change in API between the macro and the inline
> function that replaces it.
> 
> I imagine I can try to break that change to two patches but at least
> in my mind this is artificial
> and it is a single logical change.
> 
> Having said that, if you think otherwise and consider this
> none-reviewable even after this
> explanation let me know and  I'd be happy to break it down.

Nah, this is fine, I'll take it as-is.  Tobin, thanks for the review.

greg k-h
