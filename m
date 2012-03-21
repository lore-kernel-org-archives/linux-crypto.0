From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 3/3] mach-ux500: Crypto: core support for CRYP/HASH
 module.
Date: Tue, 20 Mar 2012 19:35:54 -0500
Message-ID: <20120320193554.01cfdde30d4bdcf3663e3e33@freescale.com>
References: <1331714748-25136-1-git-send-email-andreas.westin@stericsson.com>
	<1331714748-25136-4-git-send-email-andreas.westin@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>
To: Andreas Westin <andreas.westin@stericsson.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:9944
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754066Ab2CUAhe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Mar 2012 20:37:34 -0400
In-Reply-To: <1331714748-25136-4-git-send-email-andreas.westin@stericsson.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 14 Mar 2012 09:45:48 +0100
Andreas Westin <andreas.westin@stericsson.com> wrote:

> This adds the required platform data and calls to enable
> the CRYP/HASH driver.
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Andreas Westin <andreas.westin@stericsson.com>
> ---
>  arch/arm/mach-ux500/board-mop500.c         |   48 ++++++++++++++++++++++++++++
>  arch/arm/mach-ux500/board-u5500.c          |   48 ++++++++++++++++++++++++++++
>  arch/arm/mach-ux500/clock.c                |   18 ++++++-----
>  arch/arm/mach-ux500/devices-common.c       |   16 +++++++++
>  arch/arm/mach-ux500/devices-common.h       |   23 +++++++++++++
>  arch/arm/mach-ux500/devices-db5500.h       |    4 ++
>  arch/arm/mach-ux500/devices-db8500.h       |    4 ++
>  arch/arm/mach-ux500/include/mach/devices.h |    3 ++
>  arch/arm/mach-ux500/ste-dma40-db5500.h     |    9 +++--
>  9 files changed, 162 insertions(+), 11 deletions(-)

this - if not the others, too - should also be sent to the
linux-arm-kernel mailing list for review.

Kim
