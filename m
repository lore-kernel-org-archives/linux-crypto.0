From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] Fix stm32-rng for default state and suspend
Date: Sat, 5 May 2018 15:16:51 +0800
Message-ID: <20180505071651.qmroqj3ys3pve2x7@gondor.apana.org.au>
References: <20180423150426.22198-1-lionel.debieve@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Rob Herring <rob.herring@linaro.org>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@st.com>,
        Ludovic Barre <ludovic.barre@st.com>
To: Lionel Debieve <lionel.debieve@st.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180423150426.22198-1-lionel.debieve@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Apr 23, 2018 at 05:04:24PM +0200, Lionel Debieve wrote:
> This series are fixing the default build state for stm32-rng that
> activate the driver with arm multi_v7_defconfig.
> Second patch is fixing the power suspend/resume behavior which was
> not working.
> 
> Lionel Debieve (2):
>   hwrng: stm32 - define default state for rng driver
>   hwrng: stm32-rng: Fix pm_suspend issue
> 
>  drivers/char/hw_random/Kconfig     | 1 +
>  drivers/char/hw_random/stm32-rng.c | 9 +++++++--
>  2 files changed, 8 insertions(+), 2 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
