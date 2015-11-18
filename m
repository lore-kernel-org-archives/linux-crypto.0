From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH 02/13] dmaengine: Introduce dma_request_slave_channel_compat_reason()
Date: Wed, 18 Nov 2015 17:46:47 +0200
Message-ID: <CAHp75VdhKmTVjRQp9q_4CXBuqjKvkBjDvgXYRDGmhdHzCW9ADA@mail.gmail.com>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
	<1432646768-12532-3-git-send-email-peter.ujfalusi@ti.com>
	<20150529093317.GF3140@localhost>
	<CAMuHMdVJ0h9qXxBWH9L2y4O2KLkEq12KW_6k8rTgi+Lux=C0gw@mail.gmail.com>
	<20150529101846.GG3140@localhost>
	<55687892.7050606@ti.com>
	<20150602125535.GS3140@localhost>
	<5570758E.6030302@ti.com>
	<20150612125837.GJ28601@localhost>
	<5587F1F4.1060905@ti.com>
	<20150624162401.GP19530@localhost>
	<564C8966.9080406@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Vinod Koul <vinod.koul@intel.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Tony Lindgren <tony@atomide.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	dmaengine <dmaengine@vger.kernel.org>,
	"linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Linux MMC List <linux-mmc@vger.kernel.org>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	linux-spi <linux-spi@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	ALSA Development Mailing List <alsa-devel@alsa-project.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <564C8966.9080406@ti.com>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 18, 2015 at 4:21 PM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> Hi Vinod,
>
> bringing this old thread back to life as I just started to work on this.

What I remember we need to convert drivers to use new API meanwhile it
is good to keep old one to avoid patch storm which does nothing useful
(IIRC Russel's opinion).

On the other hand there are a lot of drivers that are used on the set
of platforms starting from legacy and abandoned ones (like AVR32) to
relatively new and newest.

And I'm not a fan of those thousands of API calls either.

-- 
With Best Regards,
Andy Shevchenko
