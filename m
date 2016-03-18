From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH 1/3] crypto: marvell/cesa - replace dma_to_phys with
 dma_map_single
Date: Fri, 18 Mar 2016 10:00:54 -0400
Message-ID: <56EC0A16.9040206@codeaurora.org>
References: <1458252137-24497-1-git-send-email-okaya@codeaurora.org>
 <20160317225459.GA19428@n2100.arm.linux.org.uk>
 <80402e2f82651814b1411a25b1740288@codeaurora.org>
 <20160317235020.GB19428@n2100.arm.linux.org.uk>
 <20160318103028.4be15b78@bbrezillon> <56EBE5BC.6000000@arm.com>
 <56EC07E9.1000506@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-arm-kernel@lists.infradead.org,
	Herbert Xu <herbert@gondor.apana.org.au>, timur@codeaurora.org,
	Arnaud Ebalard <arno@natisbad.org>,
	linux-kernel@vger.kernel.org, cov@codeaurora.org,
	"David S. Miller" <davem@davemloft.net>, nwatters@codeaurora.org,
	linux-crypto@vger.kernel.org
To: Robin Murphy <robin.murphy@arm.com>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39291 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbcCROA6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Mar 2016 10:00:58 -0400
In-Reply-To: <56EC07E9.1000506@codeaurora.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 3/18/2016 9:51 AM, Sinan Kaya wrote:
> Another option is I can write
> 
>      engine->sram_dma = swiotlb_dma_to_phys(res->start)

I realized that I made a mistake in the commit message and the code above.

The code is trying to find DMA address from physical address. Not the other
way around. I'll fix it on the next version. 

The correct suggestion above would be 

      engine->sram_dma = swiotlb_phys_to_dmares->start)

-- 
Sinan Kaya
Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
