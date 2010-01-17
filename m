From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: gmac - Add RFC4543 wrapper for GCM
Date: Sun, 17 Jan 2010 21:52:28 +1100
Message-ID: <20100117105228.GA32270@gondor.apana.org.au>
References: <4B154918.7070008@strongswan.org> <20091203035013.GA15252@gondor.apana.org.au> <4B19396F.8040601@strongswan.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Tobias Brunner <tobias@strongswan.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:60179 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750783Ab0AQKwf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 17 Jan 2010 05:52:35 -0500
Content-Disposition: inline
In-Reply-To: <4B19396F.8040601@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 04, 2009 at 05:31:43PM +0100, Tobias Brunner wrote:
> 
> This patch adds the RFC4543 (GMAC) wrapper for GCM similar to the
> existing RFC4106 wrapper. The main differences between GCM and GMAC are
> the contents of the AAD and that the plaintext is empty for the latter.
> 
> Signed-off-by: Tobias Brunner <tobias@strongswan.org>

Applied to cryptodev.  Thanks Tobias!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
