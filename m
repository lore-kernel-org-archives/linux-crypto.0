From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH] crypto: s5p-sss.c: Fix kernel Oops in AES-ECB mode
Date: Tue, 6 Feb 2018 13:11:35 +0100
Message-ID: <CAJKOXPcugCtU8OdK+vvT3SP49HFLCPuND2vLSomkENrOyVvYzQ@mail.gmail.com>
References: <CGME20180205174022eucas1p101e8339284c1f0ac8f40f70c24de1c1f@eucas1p1.samsung.com>
 <224788c7-426b-d3a9-d0a6-412d2b8afb75@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Vladimir Zapolskiy <vz@mleia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Anand Moon <linux.amoon@gmail.com>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
To: Kamil Konieczny <k.konieczny@partner.samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752324AbeBFMLi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Feb 2018 07:11:38 -0500
In-Reply-To: <224788c7-426b-d3a9-d0a6-412d2b8afb75@partner.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 5, 2018 at 6:40 PM, Kamil Konieczny
<k.konieczny@partner.samsung.com> wrote:
>
> In AES-ECB mode crypt is done with key only, so any use of IV
> can cause kernel Oops, as reported by Anand Moon.
> Fixed it by using IV only in AES-CBC and AES-CTR.
>
> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
> Reported-by: Anand Moon <linux.amoon@gmail.com>
> ---
> Tested on Odroid XU4/HC1, kernel 4.15 with following command:
>
> fallocate -l 128MiB /tmp/test.bin
> dd if=/dev/urandom of=/tmp/testkey.key bs=128 count=1
> sync
> cryptsetup luksFormat --debug -q -d /tmp/testkey.key \
>   --cipher aes-cbc-essiv:sha256 -h sha256 -s 128 /tmp/test.bin
>
> The original report by Anand Moon:
> https://www.spinics.net/lists/linux-crypto/msg31180.html
>
> Oops reproduced with cryptsetup 2.0.0, kernel 4.15,
> in .config in crypto API ECB support was turned off, and s5p-sss AES driver on.
>
> cryptsetup is using aes-ecb and has req->info in aes_ctx set to 0x10,
> which caused Oops:
>
> [ 2078.683779] Internal error: Oops: 17 [#1] PREEMPT SMP ARM
> [ 2078.689148] Modules linked in: algif_skcipher af_alg sd_mod sg
> evdev uas usb_storage scsi_mod gpio_keys fbtft(C) spidev spi_s3c64xx
> ipv6
> [ 2078.701377] CPU: 1 PID: 15 Comm: ksoftirqd/1 Tainted: G         C
>     4.15.0-rc9-xu4krck #1
> [ 2078.709861] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
> [ 2078.715932] PC is at memcpy+0x80/0x330
> [ 2078.719652] LR is at s5p_tasklet_cb+0x19c/0x328
>
>  drivers/crypto/s5p-sss.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)

Fixes and cc-stable?

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
