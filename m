From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH] crypto: caam - set RDB bit in security configuration
 register
Date: Wed, 6 Feb 2013 19:33:15 -0600
Message-ID: <20130206193315.cb27accf9a7a7f95870fb47f@freescale.com>
References: <1360151266-28428-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Shengzhou Liu <Shengzhou.Liu@freescale.com>,
	Alex Porosanu <alexandru.porosanu@freescale.com>,
	<linux-kernel@vger.kernel.org>
To: Vakul Garg <vakul@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:8115 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751044Ab3BGBf5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 Feb 2013 20:35:57 -0500
In-Reply-To: <1360151266-28428-1-git-send-email-vakul@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 6 Feb 2013 17:17:46 +0530
Vakul Garg <vakul@freescale.com> wrote:

> This change is required for post SEC-5.0 devices which have RNG4. Setting RDB

wrap your commit message text to 75 chars

> in security configuration register allows CAAM to use the "Random Data Buffer"
> to be filled by a single request. The Random Data Buffer is large enough for
> ten packets to get their IVs from a single request. If the Random Data Buffer
> is not enabled, then each IV causes a separate request, and RNG4 hardware
> cannot keep up resulting in lower IPSEC throughput.

Linux kernel IPSec or another IPSEC stack?  how much lower?

> +	if (of_device_is_compatible(nprop, "fsl,sec-v5.0"))
> +		setbits32(&topregs->ctrl.scfgr, SCFGR_RDBENABLE);
> +

this belongs further down - at the end of the RNG4 initialization
section.

Kim
