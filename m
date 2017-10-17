From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: [PATCH 2/2] Add HASH support for Exynos
Date: Tue, 17 Oct 2017 12:32:05 +0200
Message-ID: <26963b1f-9489-28e5-cd86-a1b145b2fb62@partner.samsung.com>
References: <CGME20171016174325eucas1p1d29d8ffe0ec3a3fdebcdb9663ed6c1e6@eucas1p1.samsung.com>
        <20171016174302.17893-1-k.konieczny@partner.samsung.com>
        <20171016174302.17893-3-k.konieczny@partner.samsung.com>
        <CAJKOXPegcfGUr+kViQKmXNEOVrDpYdfCrDa_ap4pHW6iW1wyRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34483 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932461AbdJQKcL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Oct 2017 06:32:11 -0400
In-reply-to: <CAJKOXPegcfGUr+kViQKmXNEOVrDpYdfCrDa_ap4pHW6iW1wyRg@mail.gmail.com>
Content-language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 17.10.2017 12:07, Krzysztof Kozlowski wrote:
> On Mon, Oct 16, 2017 at 7:43 PM, Kamil Konieczny
> <k.konieczny@partner.samsung.com> wrote:
>> Add support for MD5, SHA1, SHA256 hash algorithms for Exynos HW.
>>[...]
>> +#if IS_ENABLED(CONFIG_CRYPTO_DEV_EXYNOS_HASH)
> 
> I missed that in v5 because you wrote it is fixed... but it was not.
> You still have #ifdef here. Please fix it:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/coding-style.rst#n993

Thank you for link, I didn't get it then, now it is clear,
I will rewrite and send v7 of patch.

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland
