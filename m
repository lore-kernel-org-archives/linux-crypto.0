From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 02/13] dmaengine: Introduce dma_request_slave_channel_compat_reason()
Date: Thu, 25 Jun 2015 13:15:57 +0200
Message-ID: <4970019.av0JOFIyTW@wuerfel>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com> <5587F1F4.1060905@ti.com> <20150624162401.GP19530@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
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
To: Vinod Koul <vinod.koul@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:65363 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbbFYLQL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Jun 2015 07:16:11 -0400
In-Reply-To: <20150624162401.GP19530@localhost>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday 24 June 2015 21:54:01 Vinod Koul wrote:
> > It would be nice to find another name for the
> > dma_request_slave_channel_compat() so with the new name we could have chance
> > to rearrange the parameters: (dev, name, mask, fn, fn_param)
> > 
> > We would end up with the following APIs, all returning with error code on failure:
> > dma_request_slave_channel(dev, name);
> > dma_request_channel_legacy(mask, fn, fn_param);
> > dma_request_slave_channel_compat(mask, fn, fn_param, dev, name);
> > dma_request_any_channel(mask);
> This is good idea but still we end up with 4 APIs. Why not just converge to
> two API, one legacy + memcpy + filer fn and one untimate API for slave?
> 
> Internally we may have 4 APIs for cleaner handling...
> 

Not sure if it's realistic, but I think it would be nice to have
a way for converting the current slave drivers that use the
mask/filter/param API to the dev/name based API. We should
be able to do this by registering a lookup table from platform
code that translates one to the other, like we do with the
clkdev lookup to find a device clock based on a local identifier.

The main downside of this is that it's a lot of work if we want
to completely remove dma_request_channel() for slave drivers,
but it could be done more gradually.

Another upside is that we could come up with a mechanism to
avoid the link-time dependency on the filter-function that
causes problems when that filter is defined in a loadable
module for the dmaengine driver.

	Arnd
