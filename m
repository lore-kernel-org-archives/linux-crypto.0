From: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH 02/13] dmaengine: Introduce
 dma_request_slave_channel_compat_reason()
Date: Fri, 12 Jun 2015 18:28:37 +0530
Message-ID: <20150612125837.GJ28601@localhost>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
 <1432646768-12532-3-git-send-email-peter.ujfalusi@ti.com>
 <20150529093317.GF3140@localhost>
 <CAMuHMdVJ0h9qXxBWH9L2y4O2KLkEq12KW_6k8rTgi+Lux=C0gw@mail.gmail.com>
 <20150529101846.GG3140@localhost>
 <55687892.7050606@ti.com>
 <20150602125535.GS3140@localhost>
 <5570758E.6030302@ti.com>
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
Received: from mga02.intel.com ([134.134.136.20]:63649 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbbFLM5S (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Jun 2015 08:57:18 -0400
Content-Disposition: inline
In-Reply-To: <5570758E.6030302@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 04, 2015 at 06:58:06PM +0300, Peter Ujfalusi wrote:
> Vinod,
> 
> On 06/02/2015 03:55 PM, Vinod Koul wrote:
> > On Fri, May 29, 2015 at 05:32:50PM +0300, Peter Ujfalusi wrote:
> >> On 05/29/2015 01:18 PM, Vinod Koul wrote:
> >>> On Fri, May 29, 2015 at 11:42:27AM +0200, Geert Uytterhoeven wrote:
> >>>> On Fri, May 29, 2015 at 11:33 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> >>>>> On Tue, May 26, 2015 at 04:25:57PM +0300, Peter Ujfalusi wrote:
> >>>>>> dma_request_slave_channel_compat() 'eats' up the returned error codes which
> >>>>>> prevents drivers using the compat call to be able to do deferred probing.
> >>>>>>
> >>>>>> The new wrapper is identical in functionality but it will return with error
> >>>>>> code in case of failure and will pass the -EPROBE_DEFER to the caller in
> >>>>>> case dma_request_slave_channel_reason() returned with it.
> >>>>> This is okay but am worried about one more warpper, how about fixing
> >>>>> dma_request_slave_channel_compat()
> >>>>
> >>>> Then all callers of dma_request_slave_channel_compat() have to be
> >>>> modified to handle ERR_PTR first.
> >>>>
> >>>> The same is true for (the existing) dma_request_slave_channel_reason()
> >>>> vs. dma_request_slave_channel().
> >>> Good point, looking again, I think we should rather fix
> >>> dma_request_slave_channel_reason() as it was expected to return err code and
> >>> add new users. Anyway users of this API do expect the reason...
> >>
> >> Hrm, they are for different use.dma_request_slave_channel()/_reason() is for
> >> drivers only working via DT or ACPI while
> >> dma_request_slave_channel_compat()/_reason() is for drivers expected to run in
> >> DT/ACPI or legacy mode as well.
> >>
> >> I added the dma_request_slave_channel_compat_reason() because OMAP/daVinci
> >> drivers are using this to request channels - they need to support DT and
> >> legacy mode.
> > I think we should hide these things behind the API and do this behind the
> > hood for ACPI/DT systems.
> > 
> > Also it makes sense to use right API and mark rest as depricated
> 
> So to convert the dma_request_slave_channel_compat() and not to create _reason
> variant?
> 
> Or to have single API to request channel? The problem with that is that we
> need different parameters for legacy and DT for example.
Sorry this slipped thru

Thinking about it again, I think we should coverge to two APIs and mark the
legacy depracuated and look to convert folks and phase that out


-- 
~Vinod
