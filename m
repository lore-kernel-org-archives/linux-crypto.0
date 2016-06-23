From: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCHv2 00/27] crypto: fixes for omap family of devices
Date: Wed, 22 Jun 2016 21:49:18 -0700
Message-ID: <20160623044917.GL22406@atomide.com>
References: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-omap@vger.kernel.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	lokeshvutla@ti.com, linux-arm-kernel@lists.infradead.org
To: Tero Kristo <t-kristo@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:57120 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbcFWEtV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Jun 2016 00:49:21 -0400
Content-Disposition: inline
In-Reply-To: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Tero Kristo <t-kristo@ti.com> [160622 06:27]:
> Hi,
> 
> Changes compared to v1 of the series:
> 
> - dropped first patch from the series (crypto: omap-aes: Fix registration of
>   algorithms) as it was queued by Herbert already
> - modified the second (now first) patch of the series to use runtime auto-
>   suspend instead of getting static sync over a cra lifetime
> - re-ordered the DTS / hwmod changes in the series, the merge order of
>   these must be maintained to avoid issues
> 
> Patches #01 .. #14 should be merged via crypto tree, the rest should be
> handled by Tony.

Next time, please post sets like these split into three separate sets
with the cover letter listing possible dependencies. Picking patches
from sets in certain order is a big pain to follow up, and some
maintainers tend to ignore patchsets with dependencies.

> Merging the omap / dts parts can be done safely separately, assuming
> you just use omap2plus_defconfig (enabling crypto features will
> cause some issues without the driver level fixes.)

I've already applied the dts changes I believe.. So reposting already
applied patches further confuses things. Now I have to figure out what
is already applied..

Regards,

Tony
