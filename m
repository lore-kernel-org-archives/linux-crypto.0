From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] crypto: ccm - Fix handling of zero plaintext when
 computing mac
Date: Thu, 28 Nov 2013 22:26:42 +0800
Message-ID: <20131128142642.GF32124@gondor.apana.org.au>
References: <5282A387.1020200@iki.fi>
 <1385644278-14928-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Horia Geanta <horia.geanta@freescale.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1385644278-14928-1-git-send-email-horia.geanta@freescale.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 28, 2013 at 03:11:15PM +0200, Horia Geanta wrote:
> There are cases when cryptlen can be zero in crypto_ccm_auth():
> -encryptiom: input scatterlist length is zero (no plaintext)
> -decryption: input scatterlist contains only the mac
> plus the condition of having different source and destination buffers
> (or else scatterlist length = max(plaintext_len, ciphertext_len)).

All four patches applied.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
