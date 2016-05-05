From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/7] asm-generic/io.h: add io{read,write}64 accessors
Date: Thu, 05 May 2016 12:56:48 +0200
Message-ID: <4560398.4eHNWD6mu5@wuerfel>
References: <1462382179-11889-1-git-send-email-horia.geanta@nxp.com> <16429831.u9JK7qO1GE@wuerfel> <C2D7FE5348E1B147BCA15975FBA23075F4EA07DD@us01wembx1.internal.synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Horia =?utf-8?B?R2VhbnTEgw==?= <horia.geanta@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Scott Wood <scott.wood@nxp.com>,
	Alexandru Porosanu <alexandru.porosanu@nxp.com>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Cristian Stoica <cristian.stoica@nxp.com>,
	arcml <linux-snps-arc@lists.infradead.org>,
	Noam Camus <noamc@ezchip.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:54701 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756675AbcEEK5j (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 May 2016 06:57:39 -0400
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA23075F4EA07DD@us01wembx1.internal.synopsys.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday 05 May 2016 08:16:47 Vineet Gupta wrote:
> Thx for noticing this Arnd and the heads up. Does the patch below look ok to you ?
> 
> ----------->
> rom b7e719831c389ab4fa338b2e2e7c0d1ff90dabb0 Mon Sep 17 00:00:00 2001
> From: Vineet Gupta <vgupta@synopsys.com>
> Date: Thu, 5 May 2016 13:32:34 +0530
> Subject: [PATCH] ARC: Add missing io barriers to io{read,write}{16,32}be()
> 
> While reviewing a different change to asm-generic/io.h Arnd spotted that
> ARC ioread32 and ioread32be both of which come from asm-generic versions
> are not symmetrical in terms of calling the io barriers.
> 
> generic ioread32   -> ARC readl()                  [ has barriers]
> generic ioread32be -> __be32_to_cpu(__raw_readl()) [ lacks barriers]
> 
> While generic ioread32be is being remediated to call readl(), that involves
> a swab32(), causing double swaps on ioread32be() on Big Endian systems.
> 
> So provide our versions of big endian IO accessors to ensure io barrier
> calls while also keeping them optimal
> 
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Cc: stable@vger.kernel.org  [4.2+]
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>

Yes, that looks correct. We probably want this regardless of the change
I proposed for the generic file, to avoid the double swap.

Acked-by: Arnd Bergmann <arnd@arndb.de>
