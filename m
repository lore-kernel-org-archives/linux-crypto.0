From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH 2/2] crypto: bfin_crc: avoid get physical address of coherence memory by dma_map_single
Date: Thu, 10 Apr 2014 11:02:51 +0200
Message-ID: <201404101102.51947.marex@denx.de>
References: <1397119259-20638-1-git-send-email-sonic.adi@gmail.com> <1397119259-20638-2-git-send-email-sonic.adi@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	adi-buildroot-devel@lists.sourceforge.net,
	Sonic Zhang <sonic.zhang@analog.com>
To: Sonic Zhang <sonic.adi@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:53677 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934889AbaDJJCy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Apr 2014 05:02:54 -0400
In-Reply-To: <1397119259-20638-2-git-send-email-sonic.adi@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday, April 10, 2014 at 10:40:59 AM, Sonic Zhang wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
> 
> - The 4-byte sg_mid_buf is located in the middle of the coherence memory
> sg_cpu. Don't call dma_map_single to get its physical address. Get the its
> base physical address from the physical address of sg_cpu instead.
> - Should set up the dma descriptor data after the 4-byte sg_mid_buf is
> filled in completely from next sg buffer.
> - memory copy from sg buffer should be done via virtual address.
> - Remove unused reference to blackfin header
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>

I don't see any obvious problems,

Reviewed-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
