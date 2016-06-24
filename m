From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/3] hw_random: bcm2835: Add support for Broadcom BCM5301x
Date: Fri, 24 Jun 2016 21:31:22 +0800
Message-ID: <20160624133122.GC21111@gondor.apana.org.au>
References: <1466641623-3491-1-git-send-email-f.fainelli@gmail.com>
 <1466641623-3491-3-git-send-email-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, yendapally.reddy@broadcom.com,
	eric@anholt.net, bcm-kernel-feedback-list@broadcom.com,
	devicetre@vger.kernel.org, hauke@hauke-m.de, zajec5@gmail.com,
	mpm@selenic.com, linux-arm-kernel@lists.infradead.org
To: Florian Fainelli <f.fainelli@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42445 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbcFXNbl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jun 2016 09:31:41 -0400
Content-Disposition: inline
In-Reply-To: <1466641623-3491-3-git-send-email-f.fainelli@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 22, 2016 at 05:27:02PM -0700, Florian Fainelli wrote:
> The Broadcom BCM5301x SoCs (Northstar) utilize the same random number
> generator peripheral as Northstar Plus and BCM2835, but just like the
> NSP SoC, we need to enable the interrupt.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
