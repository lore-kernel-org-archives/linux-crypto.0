From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH 4/4] crypto: s5p-sss: Add aes-ctr support
Date: Mon, 17 Sep 2018 15:45:12 +0200
Message-ID: <CAJKOXPfBnS-8odFaY35aBeOWbRWYDCCn40wM6tTAua021xytLg@mail.gmail.com>
References: <CGME20180913075901eucas1p2dfb1900b71d70ee64a9d51eb4c8b61fd@eucas1p2.samsung.com>
 <1536825522-6027-1-git-send-email-c.manszewski@samsung.com> <20180913075901eucas1p2dfb1900b71d70ee64a9d51eb4c8b61fd~T5q-ljNj41220012200eucas1p2N@eucas1p2.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-crypto@vger.kernel.org, vz@mleia.com,
        k.konieczny@partner.samsung.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        "linux-samsung-soc@vger.kernel.org"
        <linux-samsung-soc@vger.kernel.org>, linux-kernel@vger.kernel.org
To: c.manszewski@samsung.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180913075901eucas1p2dfb1900b71d70ee64a9d51eb4c8b61fd~T5q-ljNj41220012200eucas1p2N@eucas1p2.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 13 Sep 2018 at 09:59, Christoph Manszewski
<c.manszewski@samsung.com> wrote:
>
> Add support for aes counter(ctr) block cipher mode of operation for
> Exynos Hardware. In contrast to ecb and cbc modes, aes-ctr allows
> encyption/decryption for request sizes not being a multiple of 16(bytes).
>
> Hardware requires block sizes being a multiple of 16(bytes). In order to
> achieve this, copy request source and destination memory, and align it's size
> to 16. That way hardware processes additional bytes, that are omitted
> when copying the result back to its original destination.
>
> Tested on Odroid-U3 with Exynos 4412 CPU, kernel 4.19-rc2 with crypto
> run-time self test testmgr and with tcrypt module:
> insmod tcrypt.ko sec=1 mode=500.
>
> Signed-off-by: Christoph Manszewski <c.manszewski@samsung.com>
> ---
>  drivers/crypto/s5p-sss.c | 45 ++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 40 insertions(+), 5 deletions(-)
>

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
