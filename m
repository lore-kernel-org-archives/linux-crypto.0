From: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH 0/3] Assorted changes for Exynos PRNG driver
Date: Tue, 05 Dec 2017 13:35:55 +0100
Message-ID: <20171205123558.31087-1-l.stelmach@samsung.com>
References: <CGME20171205123601eucas1p2ef1a2fdce84dce8dc4b54c419ce566a7@eucas1p2.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        m.szyprowski@samsung.com, b.zolnierkie@samsung.com
To: Krzysztof Kozlowski <krzk@kernel.org>,
        Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39893 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752693AbdLEMgF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Dec 2017 07:36:05 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

This is a series of patches for exynos-rng driver I've decided to
create after adding support for Exynos5250+ chips. They do not
strictly depend on each other, but I think it is better to send them
as a single patch-set.

Patch #1 Add support for PRNG in Exynos5250+ SoCs

Patch #2 Improve output performance by using memcpy() rather than a
custom function to retriev random bytes from registers.

Patch #3 Reseed the PRNG after reading 2^16 bytes. Simmilar approach
is implemented in DRBG. (Thanks Stephan Mueller)

Łukasz Stelmach (3):
  crypto: exynos - Support Exynos5250+ SoCs
  crypto: exynos - Improve performance of PRNG
  crypto: exynos - Reseed PRNG after generating 2^16 random bytes

 .../bindings/crypto/samsung,exynos-rng4.txt        |  4 +-
 drivers/crypto/exynos-rng.c                        | 90 +++++++++++++---------
 2 files changed, 55 insertions(+), 39 deletions(-)

-- 
2.11.0
