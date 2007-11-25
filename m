From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] Add GCM/GMAC support to cryptoapi
Date: Sun, 25 Nov 2007 22:39:12 +0800
Message-ID: <20071125143912.GA12996@gondor.apana.org.au>
References: <Pine.LNX.4.64.0711251601100.3663@antarct> <Pine.LNX.4.64.0711251624530.3663@antarct>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Mikko Herranen <mikko.herranen@cs.helsinki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2483 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752031AbXKYOjO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 25 Nov 2007 09:39:14 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711251624530.3663@antarct>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Nov 25, 2007 at 04:25:45PM +0200, Mikko Herranen wrote:
> Add AEAD support to tcrypt, needed by GCM.
> 
> Signed-off-by: Mikko Herranen <mh1@iki.fi>
> Reviewed-by: Mika Kukkonen <mika.kukkonen@nsn.com>

Nice work guys! CCM was meant to be the first real AEAD algorithm
but you guys beat me to it :)

I'll apply this once I finish the CTR/geniv bug fix.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
