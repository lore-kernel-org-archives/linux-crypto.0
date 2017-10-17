From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH 2/2] Add HASH support for Exynos
Date: Tue, 17 Oct 2017 12:07:31 +0200
Message-ID: <CAJKOXPegcfGUr+kViQKmXNEOVrDpYdfCrDa_ap4pHW6iW1wyRg@mail.gmail.com>
References: <CGME20171016174325eucas1p1d29d8ffe0ec3a3fdebcdb9663ed6c1e6@eucas1p1.samsung.com>
 <20171016174302.17893-1-k.konieczny@partner.samsung.com> <20171016174302.17893-3-k.konieczny@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kamil Konieczny <k.konieczny@partner.samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754094AbdJQKHe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Oct 2017 06:07:34 -0400
In-Reply-To: <20171016174302.17893-3-k.konieczny@partner.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 16, 2017 at 7:43 PM, Kamil Konieczny
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
> - Resize resource end in probe if EXYNOS_HASH is enabled in
>   Kconfig.
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
> - Add new CRYPTO_DEV_EXYNOS_HASH, depend on !EXYNOS_RNG
>   and CRYPTO_DEV_S5P
>
> - Select sw algorithms MD5, SHA1 and SHA256 in EXYNOS_HASH
>   as they are nedded for fallback.
>
> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
> ---
>  drivers/crypto/Kconfig   |   14 +
>  drivers/crypto/s5p-sss.c | 1406 +++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 1410 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index dfae1865c384..b5a7e49f9285 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c

(...)

> @@ -829,6 +2155,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
>         struct samsung_aes_variant *variant;
>         struct s5p_aes_dev *pdata;
>         struct resource *res;
> +       unsigned int hash_i;
>
>         if (s5p_dev)
>                 return -EEXIST;
> @@ -837,12 +2164,33 @@ static int s5p_aes_probe(struct platform_device *pdev)
>         if (!pdata)
>                 return -ENOMEM;
>
> +       variant = find_s5p_sss_version(pdev);
>         res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -       pdata->ioaddr = devm_ioremap_resource(&pdev->dev, res);
> -       if (IS_ERR(pdata->ioaddr))
> -               return PTR_ERR(pdata->ioaddr);
> +       /*
> +        * Note: HASH and PRNG uses the same registers in secss, avoid
> +        * overwrite each other. This will drop HASH when CONFIG_EXYNOS_RNG
> +        * is enabled in config. We need larger size for HASH registers in
> +        * secss, current describe only AES/DES
> +        */
> +#if IS_ENABLED(CONFIG_CRYPTO_DEV_EXYNOS_HASH)

I missed that in v5 because you wrote it is fixed... but it was not.
You still have #ifdef here. Please fix it:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/coding-style.rst#n993

Best regards,
Krzysztof
