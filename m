From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH 2/8] dmaengine: mv_xor: add support for a38x command in
 descriptor mode
Date: Tue, 12 May 2015 17:54:31 +0200
Message-ID: <20150512175431.378c346e@free-electrons.com>
References: <1431445063-20226-1-git-send-email-maxime.ripard@free-electrons.com>
	<1431445063-20226-3-git-send-email-maxime.ripard@free-electrons.com>
	<4862159.g8Sk9nOiS2@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-arm-kernel@lists.infradead.org,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Vinod Koul <vinod.koul@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Gregory Clement <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Lior Amsalem <alior@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Petazzoni <thomas@free-electrons.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	dmaengine@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:58159 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932892AbbELPyf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 May 2015 11:54:35 -0400
In-Reply-To: <4862159.g8Sk9nOiS2@wuerfel>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dear Arnd Bergmann,

On Tue, 12 May 2015 17:49:08 +0200, Arnd Bergmann wrote:

> Using 
> 
> 	if (IS_ENABLED(__BIG_ENDIAN))
> 
> here would make it more readable by avoiding the #if. Alternatively,
> you could leave the XOR_DESCRIPTOR_SWAP flag disabled and just swap
> the descriptors manually like a lot of other drivers do. You have
> to swap the mmio accesses anywya.

Agreed on IS_ENABLED(). However, I don't understand the comment about
the need to swap mmio accesses? We're using readl_relaxed() /
writel_relaxed(), and they do the swapping already. Am I missing
something?

Best regards,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
