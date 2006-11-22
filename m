From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [2.6 patch] crypto/: remove unused functions
Date: Wed, 22 Nov 2006 17:55:17 +1100
Message-ID: <20061122065517.GA16985@gondor.apana.org.au>
References: <20061121194324.GK5200@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:10505 "EHLO
	arnor.apana.org.au") by vger.kernel.org with ESMTP id S1756927AbWKVGzU
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Nov 2006 01:55:20 -0500
To: Adrian Bunk <bunk@stusta.de>
Content-Disposition: inline
In-Reply-To: <20061121194324.GK5200@stusta.de>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Nov 21, 2006 at 08:43:24PM +0100, Adrian Bunk wrote:
> This patch removes the following no longer used functions:
> - api.c: crypto_alg_available()
> - digest.c: crypto_digest_init()
> - digest.c: crypto_digest_update()
> - digest.c: crypto_digest_final()
> - digest.c: crypto_digest_digest()
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

Patch applied.  Thanks Adrian.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
