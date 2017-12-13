From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH v3 3/4] crypto: exynos - Reseed PRNG after generating 2^16
 random bytes
Date: Wed, 13 Dec 2017 09:12:35 +0100
Message-ID: <CAJKOXPe7M-J7uwm=7n=RvHacqroyHfqjQmVYLRGUBWKcdDmgzw@mail.gmail.com>
References: <CGME20171212163612eucas1p2a16e3bb7cb36a50ec2c5c88a185c529a@eucas1p2.samsung.com>
 <20171212163607.2985-1-l.stelmach@samsung.com> <20171212163607.2985-4-l.stelmach@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: robh+dt@kernel.org, Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: =?UTF-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <20171212163607.2985-4-l.stelmach@samsung.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Dec 12, 2017 at 5:36 PM, Łukasz Stelmach <l.stelmach@samsung.com> wrote:
> Reseed PRNG after reading 65 kB of randomness. Although this may reduce
> performance, in most cases the loss is not noticeable. Also the time
> based threshold for reseeding is changed to one second. Reseeding is
> performed whenever either limit is exceeded.
>
> Reseeding of a PRNG does not increase entropy, but it helps preventing
> backtracking the internal state of the device from its output sequence,
> and hence, prevents potential attacker from predicting numbers to be
> generated.
>
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
> Reviewed-by: Stephan Mueller <smueller@chronox.de>
> ---
>  drivers/crypto/exynos-rng.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
>

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
