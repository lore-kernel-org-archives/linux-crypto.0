From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH/RFC] crypto: Add platform dependencies for CRYPTO_DEV_CCREE
Date: Tue, 17 Apr 2018 21:53:49 +0200
Message-ID: <CAK8P3a0fRZmumK5zLRgqT1iPtn2HgEjg6qyv-PMEaM1Z1W6aDw@mail.gmail.com>
References: <1523988865-26848-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1523988865-26848-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Apr 17, 2018 at 8:14 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> The ARM TrustZone CryptoCell is found on ARM SoCs only.  Hence make it
> depend on ARM or ARM64, unless compile-testing.
>
> Drop the dependency on HAS_DMA, as DMA is always available on ARM and
> ARM64 platforms, and doing so will increase compile coverage.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> Is ARM || ARM64 OK?
> Or should this be limited to either ARM or ARM64? Or something else?

ARM || ARM64 seems fine, but don't you need '|| (HAS_DMA && COMPILE_TEST)'?

I assume the HAS_DMA dependency was added to prevent compile
testing to run into a build error.

        Arnd
