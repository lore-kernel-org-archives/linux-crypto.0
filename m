From: LABBE Corentin <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Add Ingenic JZ4780 hardware RNG driver
Date: Thu, 18 Aug 2016 13:53:00 +0200
Message-ID: <20160818115300.GA6621@Red>
References: <1471448151-20850-1-git-send-email-prasannatsmkumar@gmail.com>
 <92a00062-9a87-0053-2c99-17bd1a304a4a@gmail.com>
 <CANc+2y55ZCkauwKNtuuCxLx-WOtm8z+A_EBKsYSjEUdc+ZbZTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org, Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org,
	Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>,
	boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org, harvey.hunt-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org,
	alex.smith-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org,
	Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
	Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
	Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	kieran-7hKh/agyDeatmTQ+vhA3Yw@public.gmane.org, Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	joshua.henderson-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org, yendapally.reddy-dY08KVG/lbpWk0Htik3J/w@public.gmane.org,
	narmstrong-rdvid1DuHRBWk0Htik3J/w@public.gmane.org, wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org,
	Christian Lamparter <chunkeey-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>,
	=?iso-8859-1?Q?=C1lvaro_Fern=E1ndez?= Rojas <noltari-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, pankaj.dev-qxv4g6HH51o@public.gmane.org,
	Mathie
To: PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANc+2y55ZCkauwKNtuuCxLx-WOtm8z+A_EBKsYSjEUdc+ZbZTQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 18, 2016 at 10:44:18AM +0530, PrasannaKumar Muralidharan wrote:
> >> +static int jz4780_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
> >> +{
> >> +     struct jz4780_rng *jz4780_rng = container_of(rng, struct jz4780_rng,
> >> +                                                     rng);
> >> +     u32 *data = buf;
> >> +     *data = jz4780_rng_readl(jz4780_rng, REG_RNG_DATA);
> >> +     return 4;
> >> +}
> >
> > If max is less than 4, its bad
> 
> Data will be 4 bytes.
> 

No, according to comment in include/linux/hw_random.h "drivers can fill up to max bytes of data"
So you cannot write more than max bytes without risking buffer overflow.

And if max > 4, hwrng client need to recall your read function.
The better example I found is tpm_get_random() in drivers/char/tpm/tpm-interface.c for handling both problem.

Regards

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
