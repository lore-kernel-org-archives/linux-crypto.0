From: "Mark A. Greer" <mgreer@animalcreek.com>
Subject: Re: [PATCH v3 1/7] ARM: OMAP2xxx: hwmod: Convert SHAM crypto
 device data to hwmod
Date: Fri, 9 Nov 2012 10:07:03 -0700
Message-ID: <20121109170703.GA13898@animalcreek.com>
References: <1352257033-32495-1-git-send-email-mgreer@animalcreek.com>
 <1352257033-32495-2-git-send-email-mgreer@animalcreek.com>
 <CALLzPKY7TCFe0yvpwJFNf8U2=h4k1Jcb8g9Q0UpGM8qv2FcSwg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, rmk+kernel@arm.linux.org.uk, paul@pwsan.com,
	khilman@deeprootsystems.com
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail20.dotsterhost.com ([66.11.232.73]:50912 "EHLO
	mail20.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab2KIRHF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Nov 2012 12:07:05 -0500
Content-Disposition: inline
In-Reply-To: <CALLzPKY7TCFe0yvpwJFNf8U2=h4k1Jcb8g9Q0UpGM8qv2FcSwg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 09, 2012 at 06:10:20PM +0200, Kasatkin, Dmitry wrote:
> Hello,

Thanks for your comments, Dmitry.

> On Wed, Nov 7, 2012 at 4:57 AM, Mark A. Greer <mgreer@animalcreek.com> wrote:
> > From: "Mark A. Greer" <mgreer@animalcreek.com>
> >
> > Convert the device data for the OMAP2 SHAM crypto IP from
> > explicit platform_data to hwmod.
> >
> > CC: Paul Walmsley <paul@pwsan.com>
> > Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
> > ---

> > diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
> > index cba60e0..f18fa50 100644
> > --- a/arch/arm/mach-omap2/devices.c
> > +++ b/arch/arm/mach-omap2/devices.c

> > @@ -501,16 +485,24 @@ static struct platform_device sham_device = {
> >  static void omap_init_sham(void)
> >  {
> >         if (cpu_is_omap24xx()) {
> > -               sham_device.resource = omap2_sham_resources;
> > -               sham_device.num_resources = omap2_sham_resources_sz;
> > +               struct omap_hwmod *oh;
> > +               struct platform_device *pdev;
> > +
> > +               oh = omap_hwmod_lookup("sham");
> > +               if (!oh)
> > +                       return;
> > +
> > +               pdev = omap_device_build("omap-sham", -1, oh, NULL, 0, NULL,
> > +                                        0, 0);
> > +               WARN(IS_ERR(pdev), "Can't build omap_device for omap-sham\n");
> >         } else if (cpu_is_omap34xx()) {
> >                 sham_device.resource = omap3_sham_resources;
> >                 sham_device.num_resources = omap3_sham_resources_sz;
> > +               platform_device_register(&sham_device);
> 
> Why changes are only for OMAP2?
> OMAP3 is also the same class.

This patch is specifically for omap2.
A following patch does the same for omap3.

> > diff --git a/arch/arm/mach-omap2/omap_hwmod_2xxx_interconnect_data.c b/arch/arm/mach-omap2/omap_hwmod_2xxx_interconnect_data.c
> > index 1a1287d..bb314c5 100644
> > --- a/arch/arm/mach-omap2/omap_hwmod_2xxx_interconnect_data.c
> > +++ b/arch/arm/mach-omap2/omap_hwmod_2xxx_interconnect_data.c
> > @@ -138,6 +138,15 @@ static struct omap_hwmod_addr_space omap2_rng_addr_space[] = {
> >         { }
> >  };
> >
> > +struct omap_hwmod_addr_space omap2xxx_sham_addrs[] = {
> > +       {
> > +               .pa_start       = 0x480a4000,
> > +               .pa_end         = 0x480a4000 + 0x64 - 1,
> > +               .flags          = ADDR_TYPE_RT
> > +       },
> > +       { }
> > +};
> 
> Why not using macros as it was before?
> 
> OMAP24XX_SEC_SHA1MD5_BASE

I am following the precedent set in the existing code of that file
which uses the actual address instead of a macro (except for uart).

I have no preference but I believe that is how Paul prefers it.

Paul?
