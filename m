From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 02/13] dmaengine: Introduce
	dma_request_slave_channel_compat_reason()
Date: Fri, 20 Nov 2015 11:58:57 +0100
Message-ID: <6118451.vaLZWOZEF5@wuerfel>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
 <4533695.7ZVFN1S94o@wuerfel> <564EF502.6040708@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
 ALSA Development Mailing List <alsa-devel@alsa-project.org>,
 Vinod Koul <vinod.koul@intel.com>, Linux MMC List <linux-mmc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 linux-spi <linux-spi@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
 Geert Uytterhoeven <geert@linux-m68k.org>, linux-crypto@vger.kernel.org,
 "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
 dmaengine@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
 "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
 Linux Media Mailing List <linux-media@vger.kernel.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Return-path: <alsa-devel-bounces@alsa-project.org>
In-Reply-To: <564EF502.6040708@ti.com>
List-Unsubscribe: <http://mailman.alsa-project.org/mailman/options/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=unsubscribe>
List-Archive: <http://mailman.alsa-project.org/pipermail/alsa-devel/>
List-Post: <mailto:alsa-devel@alsa-project.org>
List-Help: <mailto:alsa-devel-request@alsa-project.org?subject=help>
List-Subscribe: <http://mailman.alsa-project.org/mailman/listinfo/alsa-devel>,
 <mailto:alsa-devel-request@alsa-project.org?subject=subscribe>
Errors-To: alsa-devel-bounces@alsa-project.org
Sender: alsa-devel-bounces@alsa-project.org
List-Id: linux-crypto.vger.kernel.org

On Friday 20 November 2015 12:25:06 Peter Ujfalusi wrote:
> On 11/19/2015 01:25 PM, Arnd Bergmann wrote:
> >> dma_request_channel(mask); /* memcpy. etc, non slave mostly */
> >>
> >> Not sure how to name this as reusing existing (good, descriptive) function
> >> names would mean changes all over the kernel to start off this.
> >>
> >> Not used and
> >> request_dma_channel(); /* as _irq/_mem_region/_resource, etc */
> >> request_dma();
> >> dma_channel_request();
> > 
> > dma_request_slavechan();
> > dma_request_slave();
> > dma_request_mask();
> 
> Let me think aloud here a bit...
> 1. To request slave channel which will return you the channel your device is
> bind via DT/ACPI or the platform map table you propose later:
> 
> dma_request_chan(struct device *dev, const char *name);
> 
> 2. To request a channel (any channel) matching with the capabilities the
> driver needs, like memcpy, memset, etc:
> 
> #define dma_request_chan_by_mask(mask) __dma_request_chan_by_mask(&(mask))
> __dma_request_chan_by_mask(const dma_cap_mask_t *mask);
> 
> I think the dma_request_chan() does not need mask to be passed, since via this
> we request a specific channel which has been defined/set by DT/ACPI or the
> lookup map. We could add a mask parameter which could be used to sanity check
> the channel we got against the capabilities the driver needs from the channel.
> We currently do this in the drivers where the author wanted to make sure that
> the channel is capable of what it should be capable.
> 
> So two API to request channel:
> struct dma_chan *dma_request_chan(struct device *dev, const char *name);
> struct dma_chan *dma_request_chan_by_mask(const dma_cap_mask_t *mask);
> 
> Both will return with the valid channel pointer or in case of failure with
> ERR_PTR().
> 
> We need to go through the code in regards to return codes also to have sane
> mapping.

Right.
> > That way the vast majority of drivers can use one of the two nice interfaces
> > and the rest can be converted to use __dma_request_chan().
> > 
> > On a related topic, we had in the past considered providing a way for
> > platform code to register a lookup table of some sort, to associate
> > a device/name pair with a configuration. That would let us use the
> > simplified dma_request_slavechan(dev, name) pair everywhere. We could
> > use the same method that we have for clk_register_clkdevs() or
> > pinctrl_register_map().
> > 
> > Something like either
> > 
> > static struct dma_chan_map myplatform_dma_map[] = {
> > 	{ .devname = "omap-aes0", .slave = "tx", .filter = omap_dma_filter_fn, .arg = (void *)65, },
> > 	{ .devname = "omap-aes0", .slave = "rx", .filter = omap_dma_filter_fn, .arg = (void *)66, },
> > };
> > 
> > or
> > 
> > static struct dma_chan_map myplatform_dma_map[] = {
> > 	{ .devname = "omap-aes0", .slave = "tx", .master = "omap-dma-engine0", .req = 65, },
> > 	{ .devname = "omap-aes0", .slave = "rx", .master = "omap-dma-engine0", .req = 66, },
> 
> sa11x0-dma expects the fn_param as string :o

Some of them do, but the new API requires changes in both the DMA master and
slave drivers, so that could be changed if we wanted to, or we just allow 
both methods indefinitely and let sa11x0-dma pass the filterfn+data rather than
a number.

> > };
> 
> Basically we are deprecating the use of IORESOURCE_DMA?

I thought we already had ;-)

> For legacy the filter function is pretty much needed to handle the differences
> between the platforms as not all of them does the filtering in a same way. So
> the first type of map would be feasible IMHO.

It certainly makes the transition to a map table much easier.

> > we could even allow a combination of the two, so the simple case just specifies
> > master and req number, which requires changes to the dmaengine driver, but we could
> > also do a mass-conversion to the .filter/.arg variant.
> 
> This will get rid of the need for the fn and fn_param parameters when
> requesting dma channel, but it will not get rid of the exported function from
> the dma engine drivers since in arch code we need to have visibility to the
> filter_fn.

Correct. A lot of dmaengine drivers already need to be built-in so the platform
code can put a pointer to the filter function, so it would not be worse for them.

Another idea would be to remove the filter function from struct dma_chan_map
and pass the map through platform data to the dmaengine driver, which then
registers it to the core along with the mask. Something like:

/* platform code */
static struct dma_chan_map oma_dma_map[] = {
 	{ .devname = "omap-aes0", .slave = "tx", .arg = (void *)65, },
 	{ .devname = "omap-aes0", .slave = "rx", .arg = (void *)66, },
	...
	{},
};

static struct omap_system_dma_plat_info dma_plat_info __initdata = {
	.dma_map = &oma_dma_map,
	...
};      

machine_init(void)
{
	...
	platform_device_register_data(NULL, "omap-dma-engine", 0, &dma_plat_info, sizeof(dma_plat_info);
	...
}

/* dmaengine driver */

static int omap_dma_probe(struct platform_device *pdev)
{
	struct omap_system_dma_plat_info *pdata = dev_get_platdata(&pdev->dev);
	...

	dmam_register_platform_map(&pdev->dev, omap_dma_filter_fn, pdata->dma_map);
}

/* dmaengine core */

struct dma_map_list {
	struct list_head node;
	struct device *master;
	dma_filter_fn filter;
	struct dma_chan_map *map;
};

static LIST_HEAD(dma_map_list);
static DEFINE_MUTEX(dma_map_mutex);

int dmam_register_platform_map(struct device *dev, dma_filter_fn filter, struct dma_chan_map *map)
{
	struct dma_map_list *list = kmalloc(sizeof(*list), GFP_KERNEL);

	if (!list)
		return -ENOMEM;

	list->dev = dev;
	list->filter = filter;
	list->map = map;

	mutex_lock(&dma_map_mutex);
	list_add(&dma_map_list, &list->node);
	mutex_unlock(&dma_map_mutex);
}

Now we can completely remove the dependency on the filter function definition
from platform code and slave drivers.

	Arnd
