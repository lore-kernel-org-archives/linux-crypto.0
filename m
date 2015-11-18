From: Peter Ujfalusi <peter.ujfalusi-l0cyMroinI0@public.gmane.org>
Subject: Re: [PATCH 02/13] dmaengine: Introduce
 dma_request_slave_channel_compat_reason()
Date: Wed, 18 Nov 2015 16:21:26 +0200
Message-ID: <564C8966.9080406@ti.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
 <1432646768-12532-3-git-send-email-peter.ujfalusi@ti.com>
 <20150529093317.GF3140@localhost>
 <CAMuHMdVJ0h9qXxBWH9L2y4O2KLkEq12KW_6k8rTgi+Lux=C0gw@mail.gmail.com>
 <20150529101846.GG3140@localhost> <55687892.7050606@ti.com>
 <20150602125535.GS3140@localhost> <5570758E.6030302@ti.com>
 <20150612125837.GJ28601@localhost> <5587F1F4.1060905@ti.com>
 <20150624162401.GP19530@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>,
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
To: Vinod Koul <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Return-path: <linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150624162401.GP19530@localhost>
Sender: linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi Vinod,

bringing this old thread back to life as I just started to work on this=
=2E

On 06/24/2015 07:24 PM, Vinod Koul wrote:

>> We would end up with the following APIs, all returning with error co=
de on failure:
>> dma_request_slave_channel(dev, name);
>> dma_request_channel_legacy(mask, fn, fn_param);
>> dma_request_slave_channel_compat(mask, fn, fn_param, dev, name);
>> dma_request_any_channel(mask);
> This is good idea but still we end up with 4 APIs. Why not just conve=
rge to
> two API, one legacy + memcpy + filer fn and one untimate API for slav=
e?

Looked at the current API and it's use and, well, it is a bit confusing=
=2E

What I hoped that we can separate users to two category:
1. Slave channel requests, where we request a specific channel to handl=
e HW
requests/triggers.
=46or this we could have:
dma_request_slave_channel(dev, name, fn, fn_param);

In DT/ACPI only drivers we can NULL out the fn and fn_param, in pure le=
gacy
mode we null out the name, I would keep the dev so we could print dev s=
pecific
error in dmaengine core, but it could be optional, IN case of drivers u=
sed
both DT/ACPI and legacy mode all parameter can be filled and the core w=
ill
decide what to do.
=46or the legacy needs the dmaengine code would provide the mask dows w=
ith
DMA_SLAVE flag set.

2. non slave channel requests, where only the functionality matters, li=
ke
memcpy, interleaved, memset, etc.
We could have a simple:
dma_request_channel(mask);

But looking at the drivers using dmaengine legacy dma_request_channel()=
 API:
Some sets DMA_INTERRUPT or DMA_PRIVATE or DMA_SG along with DMA_SLAVE:
drivers/misc/carma/carma-fpga.c			DMA_INTERRUPT|DMA_SLAVE|DMA_SG
drivers/misc/carma/carma-fpga-program.c		DMA_MEMCPY|DMA_SLAVE|DMA_SG
drivers/media/platform/soc_camera/mx3_camera.c	DMA_SLAVE|DMA_PRIVATE
sound/soc/intel/common/sst-firmware.c		DMA_SLAVE|DMA_MEMCPY

as examples.
Not sure how valid are these...

Some drivers do pass fn and fn_param when requesting channel for DMA_ME=
MCPY
drivers/misc/mic/host/mic_device.h
drivers/mtd/nand/fsmc_nand.c
sound/soc/intel/common/sst-firmware.c (well, this request DMA_SLAVE cap=
ability
at the same time).

Some driver sets the fn_param w/o fn, which means fn_param is ignored.

So the
dma_request_slave_channel(dev, name, fn, fn_param);
dma_request_channel(mask);

almost covers the current users and would be pretty clean ;)

If we add the mask to the slave channel API - which will become univers=
al,
drop in replacement for dma_request_channel, and we might have only one=
 API:

dma_request_channel(dev, name, mask, fn, fn_param);

>=20
> Internally we may have 4 APIs for cleaner handling...
>=20
> Thoughts... ??

Yes, as we need to arrange the code internally to keep things neat.

--=20
P=E9ter
--
To unsubscribe from this list: send the line "unsubscribe linux-spi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
