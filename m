From: Fabio Estevam <festevam-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] hwrng: mxc-fsl - add support for Freescale RNGC
Date: Mon, 29 Feb 2016 20:54:19 -0300
Message-ID: <CAOMZO5BLYumOrBuoB5-RgzLAJ=o4zp9ocv4jcZRy=p6Pky1SyQ@mail.gmail.com>
References: <1456761156-27664-1-git-send-email-s.trumtrar@pengutronix.de>
	<1456761156-27664-3-git-send-email-s.trumtrar@pengutronix.de>
	<CAOMZO5BN-1U6vX0HAHWX30t+23NnqEpOw6AttSgvqaZnq=cN6Q@mail.gmail.com>
	<20160229213850.GS2613@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steffen Trumtrar <s.trumtrar-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>,
	Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	"devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>,
	Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>,
	Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>,
	Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Sascha Hauer <kernel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>,
	Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
	Shawn Guo <shawnguo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	"linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org"
	<linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?=
	<u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160229213850.GS2613-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Feb 29, 2016 at 6:38 PM, Uwe Kleine-K=C3=B6nig
<u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org> wrote:
> On Mon, Feb 29, 2016 at 06:16:50PM -0300, Fabio Estevam wrote:
>> On Mon, Feb 29, 2016 at 12:52 PM, Steffen Trumtrar
>> <s.trumtrar-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org> wrote:
>>
>> > +       ret =3D clk_prepare_enable(rngc->clk);
>> > +       if (ret)
>> > +               return ret;
>> > +
>> > +       rngc->irq =3D platform_get_irq(pdev, 0);
>> > +       if (!rngc->irq) {
>> > +               dev_err(&pdev->dev, "FSL RNGC couldn't get irq\n")=
;
>> > +               clk_disable_unprepare(rngc->clk);
>> > +
>> > +               return ret;
>>
>> You are returning the wrong error code here:
>>
>> Better do like this:
>>
>>        rngc->irq =3D platform_get_irq(pdev, 0);
>>        if (rngc->irq < 0) {
>
> rngc->irq is unsigned, so this is never true.
>
>>                dev_err(&pdev->dev, "FSL RNGC couldn't get irq\n");
>>                clk_disable_unprepare(rngc->clk);
>>                return rngc->irq;
>>        }
>
> So here comes my better approach:

As irq is only used inside probe it can be removed from struct mxc_rngc=
=2E

Or maybe like this:

         ret =3D platform_get_irq(pdev, 0);
         if (ret < 0) {
                 dev_err(&pdev->dev, "FSL RNGC couldn't get irq\n");
                 clk_disable_unprepare(rngc->clk);
                 return ret;
         }
--
To unsubscribe from this list: send the line "unsubscribe devicetree" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
