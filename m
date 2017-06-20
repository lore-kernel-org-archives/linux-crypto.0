From: Sean Wang <sean.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 0/3] add support of hardware random generator on
 MediaTek MT7622
Date: Tue, 20 Jun 2017 22:21:17 +0800
Message-ID: <1497968477.27946.5.camel@mtkswgap22>
References: <cover.1497280813.git.sean.wang@mediatek.com>
         <20170620034009.GD17764@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>, <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        <romain.perier-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, <shannon.nelson-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
        <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        <linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
        <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
        <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <keyhaede-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        Torsten Duwe <duwe-l3A5Bk7waGM@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170620034009.GD17764-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

thanks for effort reviewing on those patches.

By the way, also loop in Torsten

Could you kindly guide me how to determine appropriate 
rng->ops.quality value used by the driver?

There is less clues since the value is not being set in
most drivers. But good value decided would allow feeding
fresh entropy data with the hwrng so i would like add it
in the next patch.

I have tested with rngtest on mtk-cir and the result is got as
the below log shown.  If the rngtest always gives the result for
success rate over 99.8%, can I set the rng->ops.quality 998?

rngtest: starting FIPS tests...
rngtest: bits received from input: 20000032
rngtest: FIPS 140-2 successes: 998
rngtest: FIPS 140-2 failures: 2
rngtest: FIPS 140-2(2001-10-10) Monobit: 1
rngtest: FIPS 140-2(2001-10-10) Poker: 0
rngtest: FIPS 140-2(2001-10-10) Runs: 1
rngtest: FIPS 140-2(2001-10-10) Long run: 0
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=715.902; avg=3846.234;
max=3906250.000)Kibits/s
rngtest: FIPS tests speed: (min=35.453; avg=37.862; max=38.300)Mibits/s
rngtest: Program run time: 5591758 microseconds

rngtest: starting FIPS tests...
rngtest: bits received from input: 20000032
rngtest: FIPS 140-2 successes: 1000
rngtest: FIPS 140-2 failures: 0
rngtest: FIPS 140-2(2001-10-10) Monobit: 0
rngtest: FIPS 140-2(2001-10-10) Poker: 0
rngtest: FIPS 140-2(2001-10-10) Runs: 0
rngtest: FIPS 140-2(2001-10-10) Long run: 0
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=715.588; avg=4424.787;
max=4882812.500)Kibits/s
rngtest: FIPS tests speed: (min=35.785; avg=37.859; max=38.223)Mibits/s
rngtest: Program run time: 4947950 microseconds



On Tue, 2017-06-20 at 11:40 +0800, Herbert Xu wrote:
> On Mon, Jun 12, 2017 at 11:56:53PM +0800, sean.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org wrote:
> > From: Sean Wang <sean.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
> > 
> > Changes since v1:
> > - update the bindings with the specific "mediatek,mt7622-rng"
> >   instead of the generic one as "mediatek,generic-rng"
> > 
> > The series add support of hardware RNG on MediaTek MT7622 and
> > , runtime PM support and add me as the maintainer for the existing
> > and following chipset.
> > 
> > Sean Wang (3):
> >   dt-bindings: rng: add MediaTek MT7622 Hardware Random Generator
> >     bindings
> >   hwrng: mtk - add runtime PM support
> >   MAINTAINERS: add entry for MediaTek Random Number Generator
> 
> All applied.  Thanks.


--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
