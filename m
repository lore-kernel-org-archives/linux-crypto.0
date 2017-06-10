From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: rng: Remove unused function __crypto_rng_cast()
Date: Sat, 10 Jun 2017 12:14:59 +0800
Message-ID: <20170610041459.GB14719@gondor.apana.org.au>
References: <20170522224943.176039-1-mka@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Neil Horman <nhorman@tuxdriver.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
To: Matthias Kaehlcke <mka@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170522224943.176039-1-mka@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, May 22, 2017 at 03:49:43PM -0700, Matthias Kaehlcke wrote:
> This fixes the following warning when building with clang:
> 
> crypto/rng.c:35:34: error: unused function '__crypto_rng_cast'
>     [-Werror,-Wunused-function]
> 
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
