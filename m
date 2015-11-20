From: Peter Ujfalusi <peter.ujfalusi-l0cyMroinI0@public.gmane.org>
Subject: Re: [PATCH 02/13] dmaengine: Introduce
 dma_request_slave_channel_compat_reason()
Date: Fri, 20 Nov 2015 14:52:03 +0200
Message-ID: <564F1773.9030006@ti.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
 <4533695.7ZVFN1S94o@wuerfel> <564EF502.6040708@ti.com>
 <6118451.vaLZWOZEF5@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Vinod Koul <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>,
	Tony Lindgren <tony-4v6yS6AI5VpBDgjK7y7TUQ@public.gmane.org>,
	"devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	<dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-omap-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Linux MMC List <linux-mmc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-spi <linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	ALSA Development Mailing List <alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org>
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Return-path: <linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6118451.vaLZWOZEF5@wuerfel>
Sender: linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On 11/20/2015 12:58 PM, Arnd Bergmann wrote:
>>> That way the vast majority of drivers can use one of the two nice i=
nterfaces
>>> and the rest can be converted to use __dma_request_chan().
>>>
>>> On a related topic, we had in the past considered providing a way f=
or
>>> platform code to register a lookup table of some sort, to associate
>>> a device/name pair with a configuration. That would let us use the
>>> simplified dma_request_slavechan(dev, name) pair everywhere. We cou=
ld
>>> use the same method that we have for clk_register_clkdevs() or
>>> pinctrl_register_map().
>>>
>>> Something like either
>>>
>>> static struct dma_chan_map myplatform_dma_map[] =3D {
>>> 	{ .devname =3D "omap-aes0", .slave =3D "tx", .filter =3D omap_dma_=
filter_fn, .arg =3D (void *)65, },
>>> 	{ .devname =3D "omap-aes0", .slave =3D "rx", .filter =3D omap_dma_=
filter_fn, .arg =3D (void *)66, },
>>> };
>>>
>>> or
>>>
>>> static struct dma_chan_map myplatform_dma_map[] =3D {
>>> 	{ .devname =3D "omap-aes0", .slave =3D "tx", .master =3D "omap-dma=
-engine0", .req =3D 65, },
>>> 	{ .devname =3D "omap-aes0", .slave =3D "rx", .master =3D "omap-dma=
-engine0", .req =3D 66, },
>>
>> sa11x0-dma expects the fn_param as string :o
>=20
> Some of them do, but the new API requires changes in both the DMA mas=
ter and
> slave drivers, so that could be changed if we wanted to, or we just a=
llow=20
> both methods indefinitely and let sa11x0-dma pass the filterfn+data r=
ather than
> a number.

Hrm, I would say that we need to push everyone to use the new API. sa11=
x0
should not be a big deal to fix IMHO and other users should be reasonab=
ly
simple to convert.

>>> };
>>
>> Basically we are deprecating the use of IORESOURCE_DMA?
>=20
> I thought we already had ;-)

=46or DT boot, yes. Not for the legacy boot.

>> For legacy the filter function is pretty much needed to handle the d=
ifferences
>> between the platforms as not all of them does the filtering in a sam=
e way. So
>> the first type of map would be feasible IMHO.
>=20
> It certainly makes the transition to a map table much easier.

And the aim anyway is to convert everything to DT, right?

>>> we could even allow a combination of the two, so the simple case ju=
st specifies
>>> master and req number, which requires changes to the dmaengine driv=
er, but we could
>>> also do a mass-conversion to the .filter/.arg variant.
>>
>> This will get rid of the need for the fn and fn_param parameters whe=
n
>> requesting dma channel, but it will not get rid of the exported func=
tion from
>> the dma engine drivers since in arch code we need to have visibility=
 to the
>> filter_fn.
>=20
> Correct. A lot of dmaengine drivers already need to be built-in so th=
e platform
> code can put a pointer to the filter function, so it would not be wor=
se for them.
>=20
> Another idea would be to remove the filter function from struct dma_c=
han_map
> and pass the map through platform data to the dmaengine driver, which=
 then
> registers it to the core along with the mask. Something like:
>=20
> /* platform code */
> static struct dma_chan_map oma_dma_map[] =3D {
>  	{ .devname =3D "omap-aes0", .slave =3D "tx", .arg =3D (void *)65, }=
,
>  	{ .devname =3D "omap-aes0", .slave =3D "rx", .arg =3D (void *)66, }=
,
> 	...
> 	{},
> };
>=20
> static struct omap_system_dma_plat_info dma_plat_info __initdata =3D =
{
> 	.dma_map =3D &oma_dma_map,
> 	...
> };     =20
>=20
> machine_init(void)
> {
> 	...
> 	platform_device_register_data(NULL, "omap-dma-engine", 0, &dma_plat_=
info, sizeof(dma_plat_info);
> 	...
> }
>=20
> /* dmaengine driver */
>=20
> static int omap_dma_probe(struct platform_device *pdev)
> {
> 	struct omap_system_dma_plat_info *pdata =3D dev_get_platdata(&pdev->=
dev);
> 	...
>=20
> 	dmam_register_platform_map(&pdev->dev, omap_dma_filter_fn, pdata->dm=
a_map);
> }
>=20
> /* dmaengine core */
>=20
> struct dma_map_list {
> 	struct list_head node;
> 	struct device *master;
> 	dma_filter_fn filter;
> 	struct dma_chan_map *map;
> };
>=20
> static LIST_HEAD(dma_map_list);
> static DEFINE_MUTEX(dma_map_mutex);
>=20
> int dmam_register_platform_map(struct device *dev, dma_filter_fn filt=
er, struct dma_chan_map *map)
> {
> 	struct dma_map_list *list =3D kmalloc(sizeof(*list), GFP_KERNEL);
>=20
> 	if (!list)
> 		return -ENOMEM;
>=20
> 	list->dev =3D dev;
> 	list->filter =3D filter;
> 	list->map =3D map;
>=20
> 	mutex_lock(&dma_map_mutex);
> 	list_add(&dma_map_list, &list->node);
> 	mutex_unlock(&dma_map_mutex);
> }
>=20
> Now we can completely remove the dependency on the filter function de=
finition
> from platform code and slave drivers.

Sounds feasible for OMAP and daVinci and for others as well. I think ;)
I would go with this if someone asks my opinion :D

The core change to add the new API + the dma_map support should be pret=
ty
straight forward. It can live alongside with the old API and we can pha=
se out
the users of the old one.
The legacy support would need more time since we need to modify the arc=
h codes
and the corresponding DMA drivers to get the map registered, but after =
that
the remaining drivers can be converted to use the new API.

--=20
P=E9ter
--
To unsubscribe from this list: send the line "unsubscribe linux-spi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
