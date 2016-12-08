From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto regression?
Date: Thu, 8 Dec 2016 18:44:23 +0800
Message-ID: <20161208104423.GA24619@gondor.apana.org.au>
References: <10260816-d835-746e-d69e-da4cd7b6b88e@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        nicolas.ferre@microchip.com
To: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <10260816-d835-746e-d69e-da4cd7b6b88e@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Dec 08, 2016 at 11:41:55AM +0100, Cyrille Pitchen wrote:
> Hi Herbert,
> 
> Let me report a potential regression I've noticed this morning when testing
> linux-next.
> 
> I've set CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=n when compiling both kernel
> images.
> 
> 
> On 4.9.0-rc2-next-20161028, /proc/crypto displays:
> driver       : atmel-xts-aes

Thanks for the report.  This should be fixed once I push this out

https://patchwork.kernel.org/patch/9465979/

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
