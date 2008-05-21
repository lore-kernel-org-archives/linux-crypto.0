From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2] crypto: rmd128: make it work on my prefered
 architecture
Date: Wed, 21 May 2008 00:36:11 -0700 (PDT)
Message-ID: <20080521.003611.48425916.davem@davemloft.net>
References: <20080521070954.GA5290@Chamillionaire.breakpoint.cc>
	<20080521.001142.114608182.davem@davemloft.net>
	<20080521072059.GB5290@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	rueegsegger@swiss-it.ch
To: linux-crypto@ml.breakpoint.cc
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44094
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758418AbYEUHgP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 May 2008 03:36:15 -0400
In-Reply-To: <20080521072059.GB5290@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Date: Wed, 21 May 2008 09:20:59 +0200

> Yes, that could be case. However a "manual" swap has three opcodes here,
> the le load has one. I should not end up with more code in the latter
> cases hould I?

You indeed can, because GCC has less information to work with when
the inline asm powerpc has for byteswapped loads is used.

For example, only limited addressing modes work with those inline
asms, so gcc has to load addresses into registers.

In fact it's even worse, look at the inline asm in asm-powerpc/byteorder.h,
it always loads the final address into a register, so there is zero possiblity
of using indexed addressing modes.

So yes, you should in fact see more code :-)
