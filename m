From: Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 05/39] ARM: ux500: Stop passing MMC's platform data for
 Device Tree boots
Date: Wed, 15 May 2013 18:50:47 +0200
Message-ID: <CACRpkdbOxzhgR=ugXLrSBJ_Y1rw=0mcrvtuRi=-c5v039xsPWA@mail.gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-6-git-send-email-lee.jones@linaro.org>
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
	Linus WALLEIJ <linus.walleij-0IS4wlFg1OjSUeElwK9/Pw@public.gmane.org>,
	Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>,
	Srinidhi KASAGAR <srinidhi.kasagar-0IS4wlFg1OjSUeElwK9/Pw@public.gmane.org>
To: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1368611522-9984-6-git-send-email-lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:

> It was required to pass DMA channel configuration information to the
> MMC driver before the new DMA API was in place. Now that it is, and
> is fully compatible with Device Tree we can stop doing that.
>
> Reviewed-by: Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Signed-off-by: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

So since the use of dma_request_slave_channel() is not upstream,
I guess this will break DMA use (i.e slow down transfers!) on all
device tree boots?

I'd be happy to apply it once the MMCI patch is in linux-next
indicating there may just be a window in the merge period
where it falls back to IRQ mode, but I don't want to disable
DMA on DT boots for an entire kernel cycle just like that.

Not applied as of yet.

Yours,
Linus Walleij
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
