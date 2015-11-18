From: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 02/13] dmaengine: Introduce dma_request_slave_channel_compat_reason()
Date: Wed, 18 Nov 2015 17:43:04 +0200
Message-ID: <CAHp75VeZFXp9i_zz7CBkVQVPGQxuzYk9AbWbbbn33r8YX3LCdw@mail.gmail.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
	<6347063.Gd6coh6hX8@wuerfel>
	<564C8E1F.8010501@ti.com>
	<6358656.jIv3GGCCXu@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Peter Ujfalusi <peter.ujfalusi-l0cyMroinI0@public.gmane.org>,
	Vinod Koul <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
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
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Return-path: <linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6358656.jIv3GGCCXu@wuerfel>
Sender: linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 18, 2015 at 5:07 PM, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:
> On Wednesday 18 November 2015 16:41:35 Peter Ujfalusi wrote:
>> On 11/18/2015 04:29 PM, Arnd Bergmann wrote:
>> > On Wednesday 18 November 2015 16:21:26 Peter Ujfalusi wrote:
>> >> 2. non slave channel requests, where only the functionality matters, like
>> >> memcpy, interleaved, memset, etc.
>> >> We could have a simple:
>> >> dma_request_channel(mask);
>> >>
>> >> But looking at the drivers using dmaengine legacy dma_request_channel() API:
>> >> Some sets DMA_INTERRUPT or DMA_PRIVATE or DMA_SG along with DMA_SLAVE:
>> >> drivers/misc/carma/carma-fpga.c                 DMA_INTERRUPT|DMA_SLAVE|DMA_SG
>> >> drivers/misc/carma/carma-fpga-program.c         DMA_MEMCPY|DMA_SLAVE|DMA_SG
>> >> drivers/media/platform/soc_camera/mx3_camera.c  DMA_SLAVE|DMA_PRIVATE
>> >> sound/soc/intel/common/sst-firmware.c           DMA_SLAVE|DMA_MEMCPY
>> >>
>> >> as examples.
>> >> Not sure how valid are these...
>
> I just had a look myself. carma has been removed fortunately in linux-next,
> so we don't have to worry about that any more.
>
> I assume that the sst-firmware.c case is a mistake, it should just use a
> plain DMA_SLAVE and not DMA_MEMCPY.

Other way around.

-- 
With Best Regards,
Andy Shevchenko
--
To unsubscribe from this list: send the line "unsubscribe linux-spi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
