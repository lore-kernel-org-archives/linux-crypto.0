From: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH 02/13] dmaengine: Introduce
 dma_request_slave_channel_compat_reason()
Date: Fri, 29 May 2015 15:48:46 +0530
Message-ID: <20150529101846.GG3140@localhost>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
 <1432646768-12532-3-git-send-email-peter.ujfalusi@ti.com>
 <20150529093317.GF3140@localhost>
 <CAMuHMdVJ0h9qXxBWH9L2y4O2KLkEq12KW_6k8rTgi+Lux=C0gw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>,
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
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:23086 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754278AbbE2KSC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 May 2015 06:18:02 -0400
Content-Disposition: inline
In-Reply-To: <CAMuHMdVJ0h9qXxBWH9L2y4O2KLkEq12KW_6k8rTgi+Lux=C0gw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 29, 2015 at 11:42:27AM +0200, Geert Uytterhoeven wrote:
> On Fri, May 29, 2015 at 11:33 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> > On Tue, May 26, 2015 at 04:25:57PM +0300, Peter Ujfalusi wrote:
> >> dma_request_slave_channel_compat() 'eats' up the returned error codes which
> >> prevents drivers using the compat call to be able to do deferred probing.
> >>
> >> The new wrapper is identical in functionality but it will return with error
> >> code in case of failure and will pass the -EPROBE_DEFER to the caller in
> >> case dma_request_slave_channel_reason() returned with it.
> > This is okay but am worried about one more warpper, how about fixing
> > dma_request_slave_channel_compat()
> 
> Then all callers of dma_request_slave_channel_compat() have to be
> modified to handle ERR_PTR first.
> 
> The same is true for (the existing) dma_request_slave_channel_reason()
> vs. dma_request_slave_channel().
Good point, looking again, I think we should rather fix
dma_request_slave_channel_reason() as it was expected to return err code and
add new users. Anyway users of this API do expect the reason...

-- 
~Vinod
