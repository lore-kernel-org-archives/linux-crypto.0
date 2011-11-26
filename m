From: Jamie Iles <jamie@jamieiles.com>
Subject: Re: [PATCH] crypto: convert drivers/crypto/* to use
 module_platform_driver()
Date: Sat, 26 Nov 2011 14:55:06 +0000
Message-ID: <20111126145506.GD28582@gallagher>
References: <1322313979.6001.5.camel@phoenix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, James Hsiao <jhsiao@amcc.com>,
	Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
	Vladimir Zapolskiy <vzapolskiy@gmail.com>,
	Jamie Iles <jamie@jamieiles.com>,
	Kim Phillips <kim.phillips@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Axel Lin <axel.lin@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60976 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab1KZOzC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 26 Nov 2011 09:55:02 -0500
Content-Disposition: inline
In-Reply-To: <1322313979.6001.5.camel@phoenix>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Nov 26, 2011 at 09:26:19PM +0800, Axel Lin wrote:
> This patch converts the drivers in drivers/crypto/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
> 
> Cc: James Hsiao <jhsiao@amcc.com>
> Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
> Cc: Vladimir Zapolskiy <vzapolskiy@gmail.com>
> Cc: Jamie Iles <jamie@jamieiles.com>

Acked-by: Jamie Iles <jamie@jamieiles.com>

Thanks Axel!
