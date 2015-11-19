From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 02/13] dmaengine: Introduce dma_request_slave_channel_compat_reason()
Date: Thu, 19 Nov 2015 12:25:13 +0100
Message-ID: <4533695.7ZVFN1S94o@wuerfel>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com> <6358656.jIv3GGCCXu@wuerfel> <564DA5AE.3060608@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Vinod Koul <vinod.koul@intel.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Tony Lindgren <tony@atomide.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	dmaengine@vger.kernel.org,
	"linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Linux MMC List <linux-mmc@vger.kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-spi <linux-spi@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	ALSA Development Mailing List <alsa-devel@alsa-project.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <564DA5AE.3060608@ti.com>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thursday 19 November 2015 12:34:22 Peter Ujfalusi wrote:
> 
> I think we can go with a single API, but I don't really like that:
> dma_request_channel(dev, name, *mask, fn, fn_param);
> 
> This would cover all current uses being legacy, DT/ACPI, compat, etc:
> dma_request_channel(NULL, NULL, &mask, fn, fn_param); /* Legacy slave */
> dma_request_channel(NULL, NULL, &mask, NULL, NULL); /* memcpy. etc */
> dma_request_channel(dev, name, NULL, NULL, NULL); /* DT/ACPI, current slave */
> dma_request_channel(dev, name, &mask, fn, fn_param); /* current compat */
> 
> Note, that we need "const dma_cap_mask_t *mask" to be able to make the mask
> optional.

Right, that would work, but I also don't really like it.

> If we have two main APIs, one to request slave channels and one to get any
> channel with given capability
> dma_request_slave_channel(NULL, NULL, &mask, fn, fn_param); /* Legacy slave */
> dma_request_slave_channel(dev, name, NULL, NULL, NULL); /* DT/ACPI, current
>                                                            slave */
> dma_request_slave_channel(dev, name, &mask, fn, fn_param); /* current compat*/
> 
> This way we can omit the mask also in cases when the client only want to get
> DMA_SLAVE, we can just build up the mask within the function. If the mask is
> provided we would copy the bits from the provided mask, so for example if you
> want to have DMA_SLAVE+DMA_CYCLIC, the driver only needs to pass DMA_CYCLIC,
> the DMA_SLAVE is going to be set anyways.

I think it's more logical here to have mask=NULL mean that we want DMA_SLAVE,
but otherwise pass the full mask as DMA_SLAVE|DMA_CYCLIC etc.

> dma_request_channel(mask); /* memcpy. etc, non slave mostly */
> 
> Not sure how to name this as reusing existing (good, descriptive) function
> names would mean changes all over the kernel to start off this.
> 
> Not used and
> request_dma_channel(); /* as _irq/_mem_region/_resource, etc */
> request_dma();
> dma_channel_request();

dma_request_slavechan();
dma_request_slave();
dma_request_mask();

> All in all, not sure which way would be better...

I think I would prefer the simplest API to have only the dev+name
arguments, as we tend to move that way for all platforms anyway, and it
seems silly to have all drivers pass three NULL arguments all the time.
At the moment, there are 139 references to dma_request_slave_channel_*
in the kernel, and only 46 of them are dma_request_slave_channel_compat.
Out of those 46, a couple can already be converted back to use
dma_request_slave_channel() because the platform now only supports
devicetree based boots and will not go back to platform data.

How about something like

extern struct dma_chan *
__dma_request_chan(struct device *dev, const char *name,
		    const dma_cap_mask_t *mask, dma_filter_fn fn, void *fn_param);

static inline struct dma_chan *
dma_request_slavechan(struct device *dev, const char *name)
{
	return __dma_request_chan(dev, name, NULL, NULL, NULL);
}

static inline struct dma_chan *
dma_request_chan(const dma_cap_mask_t *mask)
{
	return __dma_request_chan(NULL, NULL, mask, NULL, NULL);
}

That way the vast majority of drivers can use one of the two nice interfaces
and the rest can be converted to use __dma_request_chan().

On a related topic, we had in the past considered providing a way for
platform code to register a lookup table of some sort, to associate
a device/name pair with a configuration. That would let us use the
simplified dma_request_slavechan(dev, name) pair everywhere. We could
use the same method that we have for clk_register_clkdevs() or
pinctrl_register_map().

Something like either

static struct dma_chan_map myplatform_dma_map[] = {
	{ .devname = "omap-aes0", .slave = "tx", .filter = omap_dma_filter_fn, .arg = (void *)65, },
	{ .devname = "omap-aes0", .slave = "rx", .filter = omap_dma_filter_fn, .arg = (void *)66, },
};

or

static struct dma_chan_map myplatform_dma_map[] = {
	{ .devname = "omap-aes0", .slave = "tx", .master = "omap-dma-engine0", .req = 65, },
	{ .devname = "omap-aes0", .slave = "rx", .master = "omap-dma-engine0", .req = 66, },
};

we could even allow a combination of the two, so the simple case just specifies
master and req number, which requires changes to the dmaengine driver, but we could
also do a mass-conversion to the .filter/.arg variant.

	Arnd
