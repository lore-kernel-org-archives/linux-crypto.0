From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH] crypto: s5p-sss: Add HASH support for Exynos
Date: Wed, 13 Sep 2017 15:18:32 +0200
Message-ID: <CAJKOXPcQhn9gq2cm_1nc8N6MEbJ0ntZqfwmY9XDYwc5VEERvdA@mail.gmail.com>
References: <CGME20170913124433eucas1p11ac46af1676151477000f8952b0ca654@eucas1p1.samsung.com>
 <51b3b386-22c0-7663-6f54-d166ebebd332@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Vladimir Zapolskiy <vz@mleia.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kamil Konieczny <k.konieczny@partner.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <51b3b386-22c0-7663-6f54-d166ebebd332@partner.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Sep 13, 2017 at 2:44 PM, Kamil Konieczny
<k.konieczny@partner.samsung.com> wrote:
> Add support for MD5, SHA1, SHA256 hash algorithms for Exynos HW.
> It uses the crypto framework asynchronous hash api.
> It is based on omap-sham.c driver.
> S5P has some HW differencies and is not implemented.
>
> Modifications in s5p-sss:
>
> - Add hash supporting structures and functions.
>
> - Modify irq handler to handle both aes and hash signals.
>
> - Disable HASH in probe if Exynos PRNG is enabled.
>
> - Add new copyright line and new author.
>
> - Tested on Odroid-U3 with Exynos 4412 CPU, kernel 4.13-rc6
>   with crypto run-time self test testmgr
>   and with tcrypt module with: modprobe tcrypt sec=1 mode=N
>   where N=402, 403, 404 (MD5, SHA1, SHA256).
>
> Modifications in drivers/crypto/Kconfig:
>
> - Select sw algorithms MD5, SHA1 and SHA256 in S5P
>   as they are nedded for fallback.
>
> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
> ---
>  drivers/crypto/Kconfig   |    6 +
>  drivers/crypto/s5p-sss.c | 2062 +++++++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 1939 insertions(+), 129 deletions(-)
>

Nice work, thanks!

You need to split the patch, it is just too huge making it very
difficult to review. Please split it per logically sensible
improvements. I see some cleanups mixed with new features - this
definitely must be split out.

This looks more or less like an early work or RFC... because I see
things like "#if 0", "HACK" or "CONFIG_....". If so, ask the question
about your problems directly. Do not force readers to find them out...

Best regards,
Krzysztof
