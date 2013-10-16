From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/5] Authenc key parsing consolidation
Date: Wed, 16 Oct 2013 20:58:14 +0800
Message-ID: <20131016125814.GC10906@gondor.apana.org.au>
References: <cover.1381831574.git.mathias.krause@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Christian Hohnstaedt <chohnstaedt@innominate.com>,
	Kim Phillips <kim.phillips@freescale.com>,
	Jamie Iles <jamie@jamieiles.com>
To: Mathias Krause <mathias.krause@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:55304 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934287Ab3JPM6T (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Oct 2013 08:58:19 -0400
Content-Disposition: inline
In-Reply-To: <cover.1381831574.git.mathias.krause@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 15, 2013 at 01:49:29PM +0200, Mathias Krause wrote:
> This series removes the code duplication of authenc key parsing by
> introducing a common helper function crypto_authenc_extractkeys() in
> patch 1. Patches 2 to 5 change all remaining places to use the new
> helper. Patches 3 and 4 also fix potential memory corruptions by
> ensuring the supplied keys won't overflow there respective buffers.
> 
> I was unable to test patches 3 to 5 as I don't have the needed hardware
> for these devices -- not even a cross compiler for those architectures.
> 
> In case patches 3 and 4 are enqueued for stable, patch 1 needs to be as
> well, as it's a prerequisite for those.
> 
> Please apply!

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
