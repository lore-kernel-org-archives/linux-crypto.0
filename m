From: Stephan Mueller <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default
Date: Wed, 10 Aug 2016 07:29:26 +0200
Message-ID: <1543667.vXsZDTRgbm@positron.chronox.de>
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org> <1645997.7cVzaEi3NG@tauon.atsec.com> <1470796501856.53342@qti.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
	"miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org" <miaoqing-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>,
	"Valo, Kalle" <kvalo-A+ZNKFmMK5xy9aJCnZT0Uw@public.gmane.org>,
	"linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	ath9k-devel <ath9k-devel-A+ZNKFmMK5xy9aJCnZT0Uw@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org" <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>,
	"Sepehrdad, Pouyan" <pouyans-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org>
To: "Pan, Miaoqing" <miaoqing-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1470796501856.53342-Rm6X0d1/PG5y9aJCnZT0Uw@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Am Mittwoch, 10. August 2016, 02:35:04 CEST schrieb Pan, Miaoqing:

Hi Miaoqing,

> Hi Stephan,
> 
> For those less perfect noise source, can't pass the FIPS test.
> 
> static int update_kernel_random(int random_step,
>         unsigned char *buf, fips_ctx_t *fipsctx_in)
> {
>         unsigned char *p;
>         int fips;
> 
>         fips = fips_run_rng_test(fipsctx_in, buf);
>         if (fips)
>                 return 1;
> 
>         for (p = buf; p + random_step <= &buf[FIPS_RNG_BUFFER_SIZE];
>                  p += random_step) {
>                 random_add_entropy(p, random_step);
>                 random_sleep();
>         }
>         return 0;
> }

Not even the poor cheap AIS20 statistical tests from rngd pass?

I guess the only sensible solution is what Ted suggested to use 
add_device_randomness.

Ciao
Stephan
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
