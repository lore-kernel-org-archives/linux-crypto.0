From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: drbg: performance improvements
Date: Wed, 4 Mar 2015 22:18:13 +1300
Message-ID: <20150304091812.GD9195@gondor.apana.org.au>
References: <50904620.OAA2OAojed@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <50904620.OAA2OAojed@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Mar 01, 2015 at 08:38:12PM +0100, Stephan Mueller wrote:
> Hi,
> 
> The following patches increase the performance of the CTR DRBG and Hash
> DRBG.
> 
> The updates successfully pass the CAVS testing. for Hash DRBG and CTR
> DRBG.
> 
> Stephan Mueller (2):
>   crypto: drbg: use single block cipher API
>   crypto: drbg: remove superflowous memsets

All applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
