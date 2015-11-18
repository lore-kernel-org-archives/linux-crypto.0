From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 02/13] dmaengine: Introduce dma_request_slave_channel_compat_reason()
Date: Wed, 18 Nov 2015 15:29:15 +0100
Message-ID: <6347063.Gd6coh6hX8@wuerfel>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com> <20150624162401.GP19530@localhost> <564C8966.9080406@ti.com>
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
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <564C8966.9080406@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wednesday 18 November 2015 16:21:26 Peter Ujfalusi wrote:
> 2. non slave channel requests, where only the functionality matters, like
> memcpy, interleaved, memset, etc.
> We could have a simple:
> dma_request_channel(mask);
> 
> But looking at the drivers using dmaengine legacy dma_request_channel() API:
> Some sets DMA_INTERRUPT or DMA_PRIVATE or DMA_SG along with DMA_SLAVE:
> drivers/misc/carma/carma-fpga.c                 DMA_INTERRUPT|DMA_SLAVE|DMA_SG
> drivers/misc/carma/carma-fpga-program.c         DMA_MEMCPY|DMA_SLAVE|DMA_SG
> drivers/media/platform/soc_camera/mx3_camera.c  DMA_SLAVE|DMA_PRIVATE
> sound/soc/intel/common/sst-firmware.c           DMA_SLAVE|DMA_MEMCPY
> 
> as examples.
> Not sure how valid are these...

It's usually not much harder to separate out the legacy case from
the normal dma_request_slave_channel_reason(), so those drivers don't
really need to use the unified compat API.

	Arnd
