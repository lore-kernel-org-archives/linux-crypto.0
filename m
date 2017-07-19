From: Martin Kaiser <martin@kaiser.cx>
Subject: Re: [PATCH 3/3] hwrng: mxc-fsl - add support for Freescale RNGC
Date: Wed, 19 Jul 2017 23:22:53 +0200
Message-ID: <20170719212253.GA13879@botnar.kaiser.cx>
References: <1457705200-16951-1-git-send-email-s.trumtrar@pengutronix.de>
 <1500326163-4556-1-git-send-email-martin@kaiser.cx>
 <1500326163-4556-3-git-send-email-martin@kaiser.cx>
 <CANc+2y7icNR3hJS0wCFd_-90X6bXkJYMEO6m53HDG8SBM0FZ2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de,
        Fabio Estevam <festevam@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANc+2y7icNR3hJS0wCFd_-90X6bXkJYMEO6m53HDG8SBM0FZ2g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi PrasannaKumar,

thanks for taking the time to review my submission.

Thus wrote PrasannaKumar Muralidharan (prasannatsmkumar@gmail.com):

> Please combine above 2 comments.

ok, I'll do this.

> > +
> > +/*
> > + * Hardware driver for the Intel/AMD/VIA Random Number Generators (RNG)
> > [...]

> I feel this comment is because of copy paste. If that's the case please remove.

A couple of files in drivers/char/hw_random have the same copyright
statement. So it looks like copy&paste. I'll remove it.

> > +
> > +       while (max > sizeof(u32)) {

> Should the condition be max >= sizeof(u32)?

You're right. I'll fix this.

> > +               status = __raw_readl(rngc->base + RNGC_STATUS);

> Is there any specific reason for using __raw_readl? Why not just readl?
> If there is no specific reason for using __raw_readl please use readl
> in all the places.

That looks like mxc-rnga.c was taken as a starting point. I'll change
__raw_read() to readl and __raw_writel to writel.

> > +               /* how many random numbers are in FIFO? [0-16] */
> > +               level = (status & RNGC_STATUS_FIFO_LEVEL_MASK) >>
> > +                       RNGC_STATUS_FIFO_LEVEL_SHIFT;
> > +
> > +               /* is there some error while reading this random number? */
> > +               if (status & RNGC_STATUS_ERROR)
> > +                       break;

> Before calculating level error check can be done.

Ok, I'll move the check right after reading the status register.

> > +               if (__raw_readl(rngc->base + RNGC_ERROR) &
> > +                   RNGC_ERROR_STATUS_BAD_KEY) {
> > +                       dev_err(rngc->dev, "Can't start, Bad Keys.\n");
> > +                       return -EIO;
> > +               }
> > +       }

> What keys? What is the purpose of this check? At this point only clk
> is enabled for RNGC so I am wondering why this check is required?

The "key" is probably the internal state of the PRNG, which uses the
mechanism described in FIPS 186-2.

No idea why Freescale added this check before the self test. I guess
that we can safely run the self test and check for errors afterwards.
I'll remove the check.

Interestingly, this "bad key" error status is one of the few differences
between RNGB and RNGC, both of which should work with this driver...

> > +
> > +       /* mask all interrupts, will be unmasked soon */
> > +       ctrl = __raw_readl(rngc->base + RNGC_CONTROL);
> > +       __raw_writel(ctrl | RNGC_CTRL_MASK_DONE | RNGC_CTRL_MASK_ERROR,
> > +                    rngc->base + RNGC_CONTROL);
> > +
> > +       /* verify if oscillator is working */
> > +       osc = __raw_readl(rngc->base + RNGC_ERROR);
> > +       if (osc & RNGC_ERROR_STATUS_OSC_ERR) {
> > +               dev_err(rngc->dev, "RNGC Oscillator is dead!\n");
> > +               return -EIO;
> > +       }

> Is this check useful? If clock is initialised properly I do not think
> this case will happen. May be I am missing something. Please add a
> comment if this check is valid.

Agreed. Switching the clock on should be sufficient to get the
oscillator to run. And if not, we should see an error after the self
test.

> RNG core can call init every time this rng device is selected as
> current random number provider. Is self test required on every RNG
> init?

I'd say the self test should be run once when the driver is loaded. I'll
try to move the self test to the probe function.

> By default self test need not be run, a module parameter can be added
> for enabling self test.

Ok.

> > +       rngc->rng.name = pdev->name;
> > +       rngc->rng.init = mxc_rngc_init;
> > +       rngc->rng.read = mxc_rngc_read;

> Assiging a quality would be great. That will help in deciding which
> rng device to use if there are mulitple rng devices.

I doubt that I have enough info to set the quality. I'll see what I can
dig up.

I'll try to upload v4 as soon as possible.

Thanks,
Martin
