From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH v7 2/2] crypto: s5p-sss: Add HASH support for Exynos
Date: Thu, 19 Oct 2017 11:48:52 +0200
Message-ID: <CAJKOXPf1aqtzZ2i_xuSC8_-nVNmjYLJ4d6obw=bH8z1WjC1WmQ@mail.gmail.com>
References: <CGME20171017112846eucas1p17185d93eb5f837643c880357b3a8053b@eucas1p1.samsung.com>
 <20171017112824.10231-1-k.konieczny@partner.samsung.com> <20171017112824.10231-3-k.konieczny@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kamil Konieczny <k.konieczny@partner.samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752441AbdJSJsz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Oct 2017 05:48:55 -0400
In-Reply-To: <20171017112824.10231-3-k.konieczny@partner.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Oct 17, 2017 at 1:28 PM, Kamil Konieczny
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
>  drivers/crypto/s5p-sss.c | 1407 +++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 1411 insertions(+), 10 deletions(-)


Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
