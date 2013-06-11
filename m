From: Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 06/39] ARM: ux500: Move SDI (MMC) and UART devices under
 more descriptive heading
Date: Tue, 11 Jun 2013 11:40:44 +0200
Message-ID: <CACRpkdbdH1No7RJbpFSgdmCkaLOD6irbo3mC9EfaLoT_Q+JedQ@mail.gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-7-git-send-email-lee.jones@linaro.org>
	<CACRpkdZ=NJR3VRNJE2pSTJ8t1VCMq+wjH_s0NOi4AHko3no_KA@mail.gmail.com>
	<20130610091724.GG20297@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org"
	<linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Felipe Balbi <balbi-l0cyMroinI0@public.gmane.org>,
	"linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	Vinod Koul <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>,
	Linus WALLEIJ <linus.walleij-0IS4wlFg1OjSUeElwK9/Pw@public.gmane.org>,
	Srinidhi KASAGAR <srinidhi.kasagar-0IS4wlFg1OjSUeElwK9/Pw@public.gmane.org>
To: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130610091724.GG20297-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jun 10, 2013 at 11:17 AM, Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On Wed, 15 May 2013, Linus Walleij wrote:
>
>> On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>>
>> > Now DMA DT bindings exist and are in use by he MMC and UART drivers, it
>> > should be possible to remove them from the auxdata structure. However,
>> > after doing so the drivers fail. Common clk is still reliant on the
>> > dev_name() call to do device name matching, which will fail due to the
>> > fact that Device Tree naming differs somewhat do the more traditional
>> > conventions.
>> >
>> > Reviewed-by: Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> > Signed-off-by: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>
>> Cannot be applied due to dependency on 5/39.
>
> I think this can be applied now (if it hasn't already).

I really need a clean mergebase for this to merge ...
This patch requires both the dma40 and devicetree
branches to land in a common place before it can be
applied.

I want the DMA40 branch to be closed down now as I
have sent all pull requests on it, so pls ping me again on
this when we have something in the ARM SoC tree we
can work on.

Yours,
Linus Walleij
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
