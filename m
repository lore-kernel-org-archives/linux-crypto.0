From: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: [PATCH 02/13] dmaengine: Introduce
 dma_request_slave_channel_compat_reason()
Date: Fri, 20 Nov 2015 12:25:06 +0200
Message-ID: <564EF502.6040708@ti.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
 <6358656.jIv3GGCCXu@wuerfel> <564DA5AE.3060608@ti.com>
 <4533695.7ZVFN1S94o@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
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
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <alsa-devel-bounces@alsa-project.org>
In-Reply-To: <4533695.7ZVFN1S94o@wuerfel>
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

On 11/19/2015 01:25 PM, Arnd Bergmann wrote:
>> If we have two main APIs, one to request slave channels and one to get a=
ny
>> channel with given capability
>> dma_request_slave_channel(NULL, NULL, &mask, fn, fn_param); /* Legacy sl=
ave */
>> dma_request_slave_channel(dev, name, NULL, NULL, NULL); /* DT/ACPI, curr=
ent
>>                                                            slave */
>> dma_request_slave_channel(dev, name, &mask, fn, fn_param); /* current co=
mpat*/
>>
>> This way we can omit the mask also in cases when the client only want to=
 get
>> DMA_SLAVE, we can just build up the mask within the function. If the mas=
k is
>> provided we would copy the bits from the provided mask, so for example i=
f you
>> want to have DMA_SLAVE+DMA_CYCLIC, the driver only needs to pass DMA_CYC=
LIC,
>> the DMA_SLAVE is going to be set anyways.
> =

> I think it's more logical here to have mask=3DNULL mean that we want DMA_=
SLAVE,
> but otherwise pass the full mask as DMA_SLAVE|DMA_CYCLIC etc.

Yep, could be, while I would write the core part to set the DMA_SLAVE
unconditionally anyways. If the API say it is dma_request_slavechan() it is
expected to get channel which is capable of DMA_SLAVE.

>> dma_request_channel(mask); /* memcpy. etc, non slave mostly */
>>
>> Not sure how to name this as reusing existing (good, descriptive) functi=
on
>> names would mean changes all over the kernel to start off this.
>>
>> Not used and
>> request_dma_channel(); /* as _irq/_mem_region/_resource, etc */
>> request_dma();
>> dma_channel_request();
> =

> dma_request_slavechan();
> dma_request_slave();
> dma_request_mask();

Let me think aloud here a bit...
1. To request slave channel which will return you the channel your device is
bind via DT/ACPI or the platform map table you propose later:

dma_request_chan(struct device *dev, const char *name);

2. To request a channel (any channel) matching with the capabilities the
driver needs, like memcpy, memset, etc:

#define dma_request_chan_by_mask(mask) __dma_request_chan_by_mask(&(mask))
__dma_request_chan_by_mask(const dma_cap_mask_t *mask);

I think the dma_request_chan() does not need mask to be passed, since via t=
his
we request a specific channel which has been defined/set by DT/ACPI or the
lookup map. We could add a mask parameter which could be used to sanity che=
ck
the channel we got against the capabilities the driver needs from the chann=
el.
We currently do this in the drivers where the author wanted to make sure th=
at
the channel is capable of what it should be capable.

So two API to request channel:
struct dma_chan *dma_request_chan(struct device *dev, const char *name);
struct dma_chan *dma_request_chan_by_mask(const dma_cap_mask_t *mask);

Both will return with the valid channel pointer or in case of failure with
ERR_PTR().

We need to go through the code in regards to return codes also to have sane
mapping.

> =

>> All in all, not sure which way would be better...
> =

> I think I would prefer the simplest API to have only the dev+name
> arguments, as we tend to move that way for all platforms anyway, and it
> seems silly to have all drivers pass three NULL arguments all the time.
> At the moment, there are 139 references to dma_request_slave_channel_*
> in the kernel, and only 46 of them are dma_request_slave_channel_compat.
> Out of those 46, a couple can already be converted back to use
> dma_request_slave_channel() because the platform now only supports
> devicetree based boots and will not go back to platform data.
> =

> How about something like
> =

> extern struct dma_chan *
> __dma_request_chan(struct device *dev, const char *name,
> 		    const dma_cap_mask_t *mask, dma_filter_fn fn, void *fn_param);
> =

> static inline struct dma_chan *
> dma_request_slavechan(struct device *dev, const char *name)
> {
> 	return __dma_request_chan(dev, name, NULL, NULL, NULL);
> }
> =

> static inline struct dma_chan *
> dma_request_chan(const dma_cap_mask_t *mask)
> {
> 	return __dma_request_chan(NULL, NULL, mask, NULL, NULL);
> }
> =

> That way the vast majority of drivers can use one of the two nice interfa=
ces
> and the rest can be converted to use __dma_request_chan().
> =

> On a related topic, we had in the past considered providing a way for
> platform code to register a lookup table of some sort, to associate
> a device/name pair with a configuration. That would let us use the
> simplified dma_request_slavechan(dev, name) pair everywhere. We could
> use the same method that we have for clk_register_clkdevs() or
> pinctrl_register_map().
> =

> Something like either
> =

> static struct dma_chan_map myplatform_dma_map[] =3D {
> 	{ .devname =3D "omap-aes0", .slave =3D "tx", .filter =3D omap_dma_filter=
_fn, .arg =3D (void *)65, },
> 	{ .devname =3D "omap-aes0", .slave =3D "rx", .filter =3D omap_dma_filter=
_fn, .arg =3D (void *)66, },
> };
> =

> or
> =

> static struct dma_chan_map myplatform_dma_map[] =3D {
> 	{ .devname =3D "omap-aes0", .slave =3D "tx", .master =3D "omap-dma-engin=
e0", .req =3D 65, },
> 	{ .devname =3D "omap-aes0", .slave =3D "rx", .master =3D "omap-dma-engin=
e0", .req =3D 66, },

sa11x0-dma expects the fn_param as string :o

> };

Basically we are deprecating the use of IORESOURCE_DMA?

For legacy the filter function is pretty much needed to handle the differen=
ces
between the platforms as not all of them does the filtering in a same way. =
So
the first type of map would be feasible IMHO.

> we could even allow a combination of the two, so the simple case just spe=
cifies
> master and req number, which requires changes to the dmaengine driver, bu=
t we could
> also do a mass-conversion to the .filter/.arg variant.

This will get rid of the need for the fn and fn_param parameters when
requesting dma channel, but it will not get rid of the exported function fr=
om
the dma engine drivers since in arch code we need to have visibility to the
filter_fn.

-- =

P=E9ter
