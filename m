From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 0/4] Assorted changes for Exynos PRNG driver
Date: Fri, 22 Dec 2017 20:09:57 +1100
Message-ID: <20171222090956.GE32542@gondor.apana.org.au>
References: <20171211140623.7673-1-l.stelmach@samsung.com>
 <CGME20171212163609eucas1p2aaee0a21276b66f4cb492a4502f66756@eucas1p2.samsung.com>
 <20171212163607.2985-1-l.stelmach@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Krzysztof Kozlowski <krzk@kernel.org>, robh+dt@kernel.org,
        Stephan Mueller <smueller@chronox.de>,
        "David S . Miller" <davem@davemloft.net>,
        Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171212163607.2985-1-l.stelmach@samsung.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Dec 12, 2017 at 05:36:03PM +0100, Łukasz Stelmach wrote:
> Hello,
> 
> This is a series of patches for exynos-rng driver I've decided to
> create after adding support for Exynos5250+ chips. They do not
> strictly depend on each other, but I think it is better to send them
> as a single patch-set.
> 
> The driver requires appropriate DT configuration introduced in
> 
>     https://patchwork.kernel.org/patch/10106797/
> 
> Patch #1 Add support for PRNG in Exynos5250+ SoCs
> 
> Patch #2 Improve output performance by using memcpy() rather than a
> custom function to retrieve random bytes from registers. Rearrange
> the loop for polling the hardware.
> 
> Patch #3 Reseed the PRNG after reading 2^16 bytes. Simmilar approach
> is implemented in DRBG. (Thanks Stephan Mueller)
> 
> Patch #4 Introduce locking to prevent simultaneous access to the
> hardware from more than one thread/process.
> 
> Changes since v2:

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
