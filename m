From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 12/12] drivers: PMC MSP71xx security engine driver
Date: Fri, 15 Jun 2007 10:38:52 +0400
Message-ID: <20070615063852.GC12796@2ka.mipt.ru>
References: <200706142212.l5EMCrc7024809@pasqua.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, linux-mips@linux-mips.org
To: Marc St-Jean <stjeanma@pmc-sierra.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:58886 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996AbXFOGjj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Jun 2007 02:39:39 -0400
Content-Disposition: inline
In-Reply-To: <200706142212.l5EMCrc7024809@pasqua.pmc-sierra.bc.ca>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Marc.

On Thu, Jun 14, 2007 at 04:12:53PM -0600, Marc St-Jean (stjeanma@pmc-sierra.com) wrote:
> [PATCH 12/12] drivers: PMC MSP71xx security engine driver
> 
> Patch to add an security engien driver for the PMC-Sierra MSP71xx devices.

Does this board have SMP config or can this adapter be found in SMP
systems, since you only protect against interrupts, but not 
simultaneous SMP access to the engine.

And as a minor nit: there is no check for dma_alloc_coherent() return value.

-- 
	Evgeniy Polyakov
