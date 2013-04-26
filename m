From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 6/9] crypto: ux500/cryp - Set DMA configuration though dma_slave_config()
Date: Fri, 26 Apr 2013 11:39:20 +0200
Message-ID: <1457204.tIrKjcEogd@wuerfel>
References: <1366280825-31136-1-git-send-email-lee.jones@linaro.org> <CACRpkdaBf++gy3sghC-t33uio2+eHp1MrQ2FM0XXBazZTtm3kA@mail.gmail.com> <20130426081646.GD24632@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Vinod Koul <vinod.koul@intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Linus WALLEIJ <linus.walleij@stericsson.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	magnus.p.persson@stericsson.com,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Andreas Westin <andreas.westin@stericsson.com>,
	Lee Jones <lee.jones@linaro.org>,
	"David S. Miller" <davem@davemloft.net>
To: linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:51462 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758214Ab3DZJjR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Apr 2013 05:39:17 -0400
In-Reply-To: <20130426081646.GD24632@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Friday 26 April 2013 13:46:46 Vinod Koul wrote:
> 
> The mapping & unmapping of dma buffer (memcpy and memory buffer in this txn) is
> required to be performed by the client driver. The dmanegine or dmaengine driver
> will not do that for you...

I've been wondering about this part: since we need to pass the 'struct device' of
the dma engine (rather than the slave) into dma_map_single, what is the official
way to do that? Should the slave driver just rely on dma_chan->device->dev to
work correctly for the purpose of dma-mapping.h interfaces?

	Arnd
