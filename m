From: Peter Ujfalusi <peter.ujfalusi-l0cyMroinI0@public.gmane.org>
Subject: Re: [PATCH 02/13] dmaengine: Introduce
 dma_request_slave_channel_compat_reason()
Date: Wed, 18 Nov 2015 16:41:35 +0200
Message-ID: <564C8E1F.8010501@ti.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
 <20150624162401.GP19530@localhost> <564C8966.9080406@ti.com>
 <6347063.Gd6coh6hX8@wuerfel>
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
In-Reply-To: <6347063.Gd6coh6hX8@wuerfel>
Sender: linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On 11/18/2015 04:29 PM, Arnd Bergmann wrote:
> On Wednesday 18 November 2015 16:21:26 Peter Ujfalusi wrote:
>> 2. non slave channel requests, where only the functionality matters,=
 like
>> memcpy, interleaved, memset, etc.
>> We could have a simple:
>> dma_request_channel(mask);
>>
>> But looking at the drivers using dmaengine legacy dma_request_channe=
l() API:
>> Some sets DMA_INTERRUPT or DMA_PRIVATE or DMA_SG along with DMA_SLAV=
E:
>> drivers/misc/carma/carma-fpga.c                 DMA_INTERRUPT|DMA_SL=
AVE|DMA_SG
>> drivers/misc/carma/carma-fpga-program.c         DMA_MEMCPY|DMA_SLAVE=
|DMA_SG
>> drivers/media/platform/soc_camera/mx3_camera.c  DMA_SLAVE|DMA_PRIVAT=
E
>> sound/soc/intel/common/sst-firmware.c           DMA_SLAVE|DMA_MEMCPY
>>
>> as examples.
>> Not sure how valid are these...
>=20
> It's usually not much harder to separate out the legacy case from
> the normal dma_request_slave_channel_reason(), so those drivers don't
> really need to use the unified compat API.

The current dma_request_slave_channel()/_reason() is not the 'legacy' A=
PI.
Currently there is no way to get the reason why the dma channel request=
 fails
when using the _compat() version of the API, which is used by drivers w=
hich
can be used in DT or in legacy mode as well. Sure, they all could have =
local
if(){}else{} for handling this, but it is not a nice thing.

As it was discussed instead of adding the _reason() version for the _co=
mpat
call, we should simplify the dmaengine API for getting the channel and =
at the
same time we will have ERR_PTR returned instead of NULL.

--=20
P=E9ter
--
To unsubscribe from this list: send the line "unsubscribe linux-spi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
