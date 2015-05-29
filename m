From: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Subject: Re: [PATCH 02/13] dmaengine: Introduce dma_request_slave_channel_compat_reason()
Date: Fri, 29 May 2015 11:42:27 +0200
Message-ID: <CAMuHMdVJ0h9qXxBWH9L2y4O2KLkEq12KW_6k8rTgi+Lux=C0gw@mail.gmail.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
	<1432646768-12532-3-git-send-email-peter.ujfalusi@ti.com>
	<20150529093317.GF3140@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Peter Ujfalusi <peter.ujfalusi-l0cyMroinI0@public.gmane.org>,
	Tony Lindgren <tony-4v6yS6AI5VpBDgjK7y7TUQ@public.gmane.org>,
	"devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Linux MMC List <linux-mmc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-spi <linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	ALSA Development Mailing List <alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org>
To: Vinod Koul <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150529093317.GF3140@localhost>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Fri, May 29, 2015 at 11:33 AM, Vinod Koul <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On Tue, May 26, 2015 at 04:25:57PM +0300, Peter Ujfalusi wrote:
>> dma_request_slave_channel_compat() 'eats' up the returned error codes which
>> prevents drivers using the compat call to be able to do deferred probing.
>>
>> The new wrapper is identical in functionality but it will return with error
>> code in case of failure and will pass the -EPROBE_DEFER to the caller in
>> case dma_request_slave_channel_reason() returned with it.
> This is okay but am worried about one more warpper, how about fixing
> dma_request_slave_channel_compat()

Then all callers of dma_request_slave_channel_compat() have to be
modified to handle ERR_PTR first.

The same is true for (the existing) dma_request_slave_channel_reason()
vs. dma_request_slave_channel().

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
