From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: sahara - Fix misuse of IS_ENABLED
Date: Mon, 10 Aug 2015 15:32:34 +0800
Message-ID: <20150810073234.GC16990@gondor.apana.org.au>
References: <1439191116.22743.1.camel@ingics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	linux-crypto@vger.kernel.org
To: Axel Lin <axel.lin@ingics.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40508 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbbHJHct (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Aug 2015 03:32:49 -0400
Content-Disposition: inline
In-Reply-To: <1439191116.22743.1.camel@ingics.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 10, 2015 at 03:18:36PM +0800, Axel Lin wrote:
> IS_ENABLED should only be used for CONFIG_* symbols.
> So use #ifdef DEBUG instead.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Nack.  While the abuse is certainly wrong you're removing compiler
coverage over code which is worse.

PLease find a way to remove the IS_ENABLED abuse without causing
the code in question to lose compiler coverage.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
