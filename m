From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH v2 3/4] crypto: exynos - Reseed PRNG after generating 2^16
 random bytes
Date: Mon, 11 Dec 2017 15:57:17 +0100
Message-ID: <CAJKOXPeCoks3jx6GCLiCj4OwmeT362rz8k+Yt_Mk516N4rrRHQ@mail.gmail.com>
References: <CGME20171211140638eucas1p239085a27ce0501beb8b42be94ed61b34@eucas1p2.samsung.com>
 <20171211140623.7673-1-l.stelmach@samsung.com> <20171211140623.7673-4-l.stelmach@samsung.com>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751729AbdLKO5U (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Dec 2017 09:57:20 -0500
In-Reply-To: <20171211140623.7673-4-l.stelmach@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 11, 2017 at 3:06 PM, Łukasz Stelmach <l.stelmach@samsung.com> wrote:
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Same as in 1/4 and 2/4.

>
> Reseed PRNG after reading 65 kB of randomness. Although this may reduce
> performance, in most cases the loss is not noticeable.

You missed the comment about mentioning the change in time. Both from
me and Stephan.

Best regards,
Krzysztof
