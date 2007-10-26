From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [0/2] [CRYPTO] users: Fix up remaining sg issues
Date: Fri, 26 Oct 2007 22:59:05 +0800
Message-ID: <20071026145905.GA13850@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Dave:

Here's a couple of patches to fix up the crypto users with
respect to the scatterlist change.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
