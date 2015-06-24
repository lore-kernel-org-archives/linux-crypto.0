From: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH 02/13] dmaengine: Introduce
 dma_request_slave_channel_compat_reason()
Date: Wed, 24 Jun 2015 21:54:01 +0530
Message-ID: <20150624162401.GP19530@localhost>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:15512 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669AbbFXQW4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Jun 2015 12:22:56 -0400
Content-Disposition: inline
In-Reply-To: <5587F1F4.1060905@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 22, 2015 at 02:31:00PM +0300, Peter Ujfalusi wrote:
> On 06/12/2015 03:58 PM, Vinod Koul wrote:
> > Sorry this slipped thru
> 
> I was away for a week anyways ;)
> 
> > Thinking about it again, I think we should coverge to two APIs and mark the
> > legacy depracuated and look to convert folks and phase that out
> 
> Currently, w/o this series we have these APIs:
> /* to be used with DT/ACPI */
> dma_request_slave_channel(dev, name)		/* NULL on failure */
> dma_request_slave_channel_reason(dev, name)	/* error code on failure */
> 
> /* Legacy mode only - no DT/ACPI lookup */
> dma_request_channel(mask, fn, fn_param) /* NULL on failure */
> 
> /* to be used with DT/ACPI or legacy boot */
> dma_request_slave_channel_compat(mask, fn, fn_param, dev, name)	/* NULL on
> failure */
> 
> To request _any_ channel to be used for memcpy one has to use
> dma_request_channel(mask, NULL, NULL);
> 
> If I did not missed something.
I dont think so :)

> As we need different types of parameters for DT/ACPI and legacy (non DT/ACPI
> lookup) and the good API names are already taken, we might need to settle:
> 
> /* to be used with DT/ACPI */
> dma_request_slave_channel(dev, name) /* error code on failure */
> - Convert users to check IS_ERR_OR_NULL() instead against NULL
> - Mark dma_request_slave_channel_reason() deprecated and convert the current users
> 
> /* to be used with DT/ACPI or legacy boot */
> dma_request_slave_channel_compat(mask, fn, fn_param, dev, name) /* error code
> on failure */
> - Convert users to check IS_ERR_OR_NULL() instead against NULL
> - Do not try legacy mode if either OF or ACPI failed because of real error
Should we keep the filter fn and an API for this, I am still not too sure
about that part. Anyway users should be on DT/ACPI. if someone wants filter
then let them use dma_request_channel()

> 
> /* Legacy mode only - no DT/ACPI lookup */
> dma_request_channel_legacy(mask, fn, fn_param) /* error code on failure */
> - convert users of dma_request_channel()
> - mark dma_request_channel() deprecated
Why should we create a new API, how about marking dma_request_channel() as
legacy and generic memcpy API and let other users be migrated?
> 
> /* to be used to get a channel for memcpy for example */
> dma_request_any_channel(mask) /* error code on failure */
> - Convert current dma_request_channel(mask, NULL, NULL) users
> I know, any of the other function could be prepared to handle this when
> parameters are missing, but it is a bit cleaner to have separate API for this.
Though it has merits but adds another API. We cna have internal
_dma_request_xxx API where parameters are missing and clean but to users
single API might be a better idea
> 
> It would be nice to find another name for the
> dma_request_slave_channel_compat() so with the new name we could have chance
> to rearrange the parameters: (dev, name, mask, fn, fn_param)
> 
> We would end up with the following APIs, all returning with error code on failure:
> dma_request_slave_channel(dev, name);
> dma_request_channel_legacy(mask, fn, fn_param);
> dma_request_slave_channel_compat(mask, fn, fn_param, dev, name);
> dma_request_any_channel(mask);
This is good idea but still we end up with 4 APIs. Why not just converge to
two API, one legacy + memcpy + filer fn and one untimate API for slave?

Internally we may have 4 APIs for cleaner handling...

Thoughts... ??

-- 
~Vinod
