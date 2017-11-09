From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 6/8] staging: ccree: simplify pm manager using local var
Date: Thu, 9 Nov 2017 15:54:57 +0300
Message-ID: <20171109113659.76ide6wvqaxcjx5a@mwanda>
References: <1510047606-5589-1-git-send-email-gilad@benyossef.com>
 <1510047606-5589-7-git-send-email-gilad@benyossef.com>
 <20171107104310.xhdxl3q3bnh7uciw@mwanda>
 <CAOtvUMfeMrrpZ2TRHkyL0i1JueczSkCHFxui6z1mPXjaAv2-1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25818 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753050AbdKIMzR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Nov 2017 07:55:17 -0500
Content-Disposition: inline
In-Reply-To: <CAOtvUMfeMrrpZ2TRHkyL0i1JueczSkCHFxui6z1mPXjaAv2-1w@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 09, 2017 at 08:27:28AM +0200, Gilad Ben-Yossef wrote:
> On Tue, Nov 7, 2017 at 12:43 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > On Tue, Nov 07, 2017 at 09:40:02AM +0000, Gilad Ben-Yossef wrote:
> >> --- a/drivers/staging/ccree/ssi_pm.c
> >> +++ b/drivers/staging/ccree/ssi_pm.c
> >> @@ -90,20 +90,24 @@ int cc_pm_resume(struct device *dev)
> >>  int cc_pm_get(struct device *dev)
> >>  {
> >>       int rc = 0;
> >> +     struct ssi_drvdata *drvdata =
> >> +             (struct ssi_drvdata *)dev_get_drvdata(dev);
> >
> > No need to cast:
> >
> >         struct ssi_drvdata *drvdata = dev_get_drvdata(dev);
> >
> 
> The same unneeded cast appears at other places in the file, so I opted
> to add a patch addressing all these location rather then change this one.
> 
> I hope it's OK.

I don't care about this one patch, it's fine.  But generally and for
future reference, we don't try very hard to use a consistent style
within a driver.  The preference is almost always kernel style over
driver style so new code should always be "kernel style" where
we avoid casting from kmalloc() or other functions that return void
pointers.

regards,
dan carpenter
