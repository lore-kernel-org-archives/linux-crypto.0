From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [BUG] SLOB breaks Crypto
Date: Wed, 19 May 2010 13:48:53 +0100
Message-ID: <1274273333.6930.10025.camel@macbook.infradead.org>
References: <1274269236.6930.9930.camel@macbook.infradead.org>
	 <20100519210506U.fujita.tomonori@lab.ntt.co.jp>
	 <1274271585.6930.9983.camel@macbook.infradead.org>
	 <20100519212904N.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: geert@linux-m68k.org, herbert@gondor.hengli.com.au,
	davem@davemloft.net, penberg@cs.helsinki.fi, mpm@selenic.com,
	ken@codelabs.ch, michael-dev@fami-braun.de,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	anemo@mba.ocn.ne.jp
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:48224 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757338Ab0ESMtJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 May 2010 08:49:09 -0400
In-Reply-To: <20100519212904N.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2010-05-19 at 21:26 +0900, FUJITA Tomonori wrote:
> 
> > Surely those architectures that have alignment constraints for DMA
> but
> > which don't set ARCH_KMALLOC_MINALIGN are just buggy -- it _does_
> mean
> > that.
> 
> Well, I thought so but seems that there isn't such agreement:
> 
> http://kerneltrap.org/mailarchive/linux-kernel/2010/5/12/4568960 

How strange. That thread has a fair amount of misinformation from people
who should know better.

-- 
dwmw2
