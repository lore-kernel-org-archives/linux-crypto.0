From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - add IPsec ESN support
Date: Thu, 6 Sep 2012 13:22:57 -0700
Message-ID: <20120906202257.GK24269@gondor.apana.org.au>
References: <1346775480-15520-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Kim Phillips <kim.phillips@freescale.com>
To: Horia Geanta <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:35079 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759658Ab2IFUW7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Sep 2012 16:22:59 -0400
Content-Disposition: inline
In-Reply-To: <1346775480-15520-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 04, 2012 at 07:18:00PM +0300, Horia Geanta wrote:
> Support for ESNs (extended sequence numbers).
> Tested with strongswan by connecting back-to-back P1010RDB with P2020RDB.
> 
> Signed-off-by: Horia Geanta <horia.geanta@freescale.com>

Patch applied.  Thanks Horia.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
