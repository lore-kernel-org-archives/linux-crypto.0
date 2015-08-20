From: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH v1 2/4] dmaengine: xgene-dma: Add support for CRC32C
 calculation via DMA engine
Date: Thu, 20 Aug 2015 12:39:57 +0530
Message-ID: <20150820070957.GG13546@localhost>
References: <1438258268-3099-1-git-send-email-rsahu@apm.com>
 <1438258268-3099-3-git-send-email-rsahu@apm.com>
 <20150820054034.GX13546@localhost>
 <CAFd313y3vTCzaGKY7ZVyFGDiSx+KuxQHyBwqKyB+xWfR5dtVSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dan.j.williams@intel.com, Herbert Xu <herbert@gondor.apana.org.au>,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	dmaengine@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, jcm@redhat.com,
	patches@apm.com
To: Rameshwar Sahu <rsahu@apm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33580 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbbHTHHx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Aug 2015 03:07:53 -0400
Content-Disposition: inline
In-Reply-To: <CAFd313y3vTCzaGKY7ZVyFGDiSx+KuxQHyBwqKyB+xWfR5dtVSA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 20, 2015 at 12:23:50PM +0530, Rameshwar Sahu wrote:
> Hi Vinod,
> 
> On Thu, Aug 20, 2015 at 11:10 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> > On Thu, Jul 30, 2015 at 05:41:06PM +0530, Rameshwar Prasad Sahu wrote:
> >> +     /* Invalidate unused source address field */
> >> +     for (; i < 4; i++)
> >> +             xgene_dma_invalidate_buffer(xgene_dma_lookup_ext8(desc2, i));
> >> +
> >> +     /* Check whether requested buffer processed */
> >> +     if (nbytes) {
> >> +             chan_err(chan, "Src count crossed maximum limit\n");
> >> +             return -EINVAL;
> > no cleanup ?
> Here not required, cleanup I am doing in parent function from where
> this function is getting called in case of failure.
> >
> >> +struct dma_async_tx_descriptor *xgene_dma_prep_flyby(
> >> +     struct xgene_dma_chan *chan, struct scatterlist *src_sg,
> >> +     size_t len, u32 seed, u8 *result, unsigned long flags, u8 opcode)
> > please fix style here
> 
> Could you explain me What kind of coding style you would like here ??

See CodingStyle Chapter 2

-- 
~Vinod
