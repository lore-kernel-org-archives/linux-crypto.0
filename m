From: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 02/13] dmaengine: Introduce dma_request_slave_channel_compat_reason()
Date: Fri, 20 Nov 2015 16:08:47 +0200
Message-ID: <CAHp75VcEb1OP=mTQEAuQ6G_RswPCfvG4UzcFG+NBfJxABZVBcA@mail.gmail.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
	<4533695.7ZVFN1S94o@wuerfel>
	<564EF502.6040708@ti.com>
	<6118451.vaLZWOZEF5@wuerfel>
	<CAHp75VdoHqPMNGFfz4mPhX+Lw+vxgiyqFS8j5+kQ9Z9CHt=OTA@mail.gmail.com>
	<564F1253.4000800@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Vinod Koul <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>,
	Tony Lindgren <tony-4v6yS6AI5VpBDgjK7y7TUQ@public.gmane.org>,
	"devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	dmaengine <dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Linux MMC List <linux-mmc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-crypto <linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-spi <linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	ALSA Development Mailing List <alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org>
To: Peter Ujfalusi <peter.ujfalusi-l0cyMroinI0@public.gmane.org>
Return-path: <linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <564F1253.4000800-l0cyMroinI0@public.gmane.org>
Sender: linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Nov 20, 2015 at 2:30 PM, Peter Ujfalusi <peter.ujfalusi-l0cyMroinI0@public.gmane.org> wrote:
> On 11/20/2015 02:24 PM, Andy Shevchenko wrote:
>> On Fri, Nov 20, 2015 at 12:58 PM, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:
>>> On Friday 20 November 2015 12:25:06 Peter Ujfalusi wrote:
>>>> On 11/19/2015 01:25 PM, Arnd Bergmann wrote:
>>
>>> Another idea would be to remove the filter function from struct dma_chan_map
>>> and pass the map through platform data
>>
>> Why not unified device properties?
>
> Is this some Windows/ACPI feature?

Nope.

Check drivers/base/property.c

> Quick search gives mostly MSDN and
> Windows10 related links.
>
> We only need dma_chan_map for platforms which has not been converted to DT and
> still using legacy boot. Or platforms which can still boot in legacy mode. In
> DT/ACPI mode we do not need this map at all.


-- 
With Best Regards,
Andy Shevchenko
--
To unsubscribe from this list: send the line "unsubscribe linux-spi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
