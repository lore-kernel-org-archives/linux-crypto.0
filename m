From: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/3] hwrng: stm32 - add support for STM32 HW RNG
Date: Wed, 14 Oct 2015 16:46:26 +0200
Message-ID: <CALszF6Db3mzM6xn2Tf4Bs65mGGY5UZspM3NniEC6eHei0oG1NA@mail.gmail.com>
References: <1443904519-24012-1-git-send-email-daniel.thompson@linaro.org>
	<1444638090-22886-1-git-send-email-daniel.thompson@linaro.org>
	<20151014142822.GF17455@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
	Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
	"devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org"
	<linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org,
	Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>,
	Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>,
	Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>,
	Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151014142822.GF17455-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Herbert,

2015-10-14 16:28 GMT+02:00 Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>:
> On Mon, Oct 12, 2015 at 09:21:27AM +0100, Daniel Thompson wrote:
>> This patchset introduces a driver for the STM32 hardware random number
>> generator.
>>
>> v2:
>>
>>  * Moved binding docs from .../hwrng/ to .../rng/ and renamed to match
>>    convention in new directory (Rob Herring).
>>  * Adopted runtime PM and auto-suspend instead of managing the clocks
>>    from the read function (Linus Walleij). Increased bandwidth by ~30%.
>>  * Simplified error detection in main read loop (Linus Walleij, Maxime
>>    Coquelin).
>>  * Only WARN_ONCE() when hardware failure mechanisms trigger (Maxime
>>    Coquelin).
>>  * Simplify end of probe function after cocci warning (Fengguang Wu).
>>  * Switch to devm_hwrng_register.
>
> All applied.  Thanks!

I see you again have applied the DT patch like for STi three weeks ago.
The DT patch should go through the arm_soc tree to avoid Linus having
to handle conflicts resolution.

Can you please remove these two patches from your tree?
ba25d8b ARM: STi: STiH407: Enable the 2 HW Random Number Generators
for STiH4{07, 10}
b47c9fa ARM: dts: stm32f429: Adopt STM32 RNG driver

Thanks,
Maxime
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
