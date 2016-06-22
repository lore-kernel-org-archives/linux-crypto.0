From: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 23/28] ARM: dts: DRA7: Add DT node for DES IP
Date: Wed, 22 Jun 2016 00:58:36 -0700
Message-ID: <20160622075834.GC22406@atomide.com>
References: <1464771389-10640-1-git-send-email-t-kristo@ti.com>
 <1464772006-11254-1-git-send-email-t-kristo@ti.com>
 <1464772006-11254-4-git-send-email-t-kristo@ti.com>
 <20160610113836.GF22406@atomide.com>
 <57697FBF.7020709@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-omap@vger.kernel.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-arm-kernel@lists.infradead.org, lokeshvutla@ti.com
To: Tero Kristo <t-kristo@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:57017 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980AbcFVH6k (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 03:58:40 -0400
Content-Disposition: inline
In-Reply-To: <57697FBF.7020709@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Tero Kristo <t-kristo@ti.com> [160621 10:58]:
> 
> Do you want to pick-up the DTS changes from this revision of series as is or
> shall I repost those also? I think the series would require a re-ordering of
> posting the DTS changes before the hwmod data.

I'll pick the dts changes from this series into omap-for-v4.8/dt
thanks. Please split the rest of the patches into separate hwmod
and driver changes and describe if there's a dependency with the
order they should get merged.

Regards,

Tony
