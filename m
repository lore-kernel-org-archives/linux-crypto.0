From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 02/13] dmaengine: Introduce dma_request_slave_channel_compat_reason()
Date: Fri, 20 Nov 2015 14:48:20 +0100
Message-ID: <5158930.I1IPZa4jtW@wuerfel>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com> <6118451.vaLZWOZEF5@wuerfel> <564F1773.9030006@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Vinod Koul <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>,
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
To: Peter Ujfalusi <peter.ujfalusi-l0cyMroinI0@public.gmane.org>
Return-path: <linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <564F1773.9030006-l0cyMroinI0@public.gmane.org>
Sender: linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Friday 20 November 2015 14:52:03 Peter Ujfalusi wrote:
> 
> >> For legacy the filter function is pretty much needed to handle the differences
> >> between the platforms as not all of them does the filtering in a same way. So
> >> the first type of map would be feasible IMHO.
> > 
> > It certainly makes the transition to a map table much easier.
> 
> And the aim anyway is to convert everything to DT, right?

We won't be able to do that. Some architectures (avr32 and sh for instance)
use the dmaengine API but will likely never support DT. On ARM, at
least sa1100 is in the same category, probably also ep93xx and portions
of pxa, omap1 and davinci.

> > int dmam_register_platform_map(struct device *dev, dma_filter_fn filter, struct dma_chan_map *map)
> > {
> >       struct dma_map_list *list = kmalloc(sizeof(*list), GFP_KERNEL);
> > 
> >       if (!list)
> >               return -ENOMEM;
> > 
> >       list->dev = dev;
> >       list->filter = filter;
> >       list->map = map;
> > 
> >       mutex_lock(&dma_map_mutex);
> >       list_add(&dma_map_list, &list->node);
> >       mutex_unlock(&dma_map_mutex);
> > }
> > 
> > Now we can completely remove the dependency on the filter function definition
> > from platform code and slave drivers.
> 
> Sounds feasible for OMAP and daVinci and for others as well. I think 
> I would go with this if someone asks my opinion 

Ok.

> The core change to add the new API + the dma_map support should be pretty
> straight forward. It can live alongside with the old API and we can phase out
> the users of the old one.
> The legacy support would need more time since we need to modify the arch codes
> and the corresponding DMA drivers to get the map registered, but after that
> the remaining drivers can be converted to use the new API.

Right. It's not urgent and as long as we agree on the overall approach, we can
always do the platform support first and wait for the following merge window
before moving over the slave drivers.

	Arnd
--
To unsubscribe from this list: send the line "unsubscribe linux-spi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
