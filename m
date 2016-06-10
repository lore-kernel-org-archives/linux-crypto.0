From: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 23/28] ARM: dts: DRA7: Add DT node for DES IP
Date: Fri, 10 Jun 2016 04:38:37 -0700
Message-ID: <20160610113836.GF22406@atomide.com>
References: <1464771389-10640-1-git-send-email-t-kristo@ti.com>
 <1464772006-11254-1-git-send-email-t-kristo@ti.com>
 <1464772006-11254-4-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-omap@vger.kernel.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-arm-kernel@lists.infradead.org, lokeshvutla@ti.com
To: Tero Kristo <t-kristo@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:55994 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbcFJLik (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Jun 2016 07:38:40 -0400
Content-Disposition: inline
In-Reply-To: <1464772006-11254-4-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Tero Kristo <t-kristo@ti.com> [160601 02:09]:
> From: Joel Fernandes <joelf@ti.com>
> 
> DRA7xx SoCs have a DES3DES IP. Add DT data for the same.

Are these dts changes safe to apply separately or do they
cause issues like extra warnings during boot?

Regards,

Tony
