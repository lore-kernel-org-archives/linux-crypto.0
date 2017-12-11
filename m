From: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH v2 0/4] Assorted changes for Exynos PRNG driver
Date: Mon, 11 Dec 2017 15:06:19 +0100
Message-ID: <20171211140623.7673-1-l.stelmach@samsung.com>
References: <20171205123558.31087-1-l.stelmach@samsung.com>
        <CGME20171211140635eucas1p22ab5dac69623926c583779a6b93872ce@eucas1p2.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Krzysztof Kozlowski <krzk@kernel.org>, robh+dt@kernel.org,
        Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:33116 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751688AbdLKOGj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Dec 2017 09:06:39 -0500
In-reply-to: <20171205123558.31087-1-l.stelmach@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

This is a series of patches for exynos-rng driver I've decided to
create after adding support for Exynos5250+ chips. They do not
strictly depend on each other, but I think it is better to send them
as a single patch-set.

The driver requires appropriate DT configuration introduced in

    https://patchwork.kernel.org/patch/10104445/

Patch #1 Add support for PRNG in Exynos5250+ SoCs

Patch #2 Improve output performance by using memcpy() rather than a
custom function to retrieve random bytes from registers. Rearrange
the loop for polling the hardware.

Patch #3 Reseed the PRNG after reading 2^16 bytes. Simmilar approach
is implemented in DRBG. (Thanks Stephan Mueller)

Patch #4 Introduce locking to prevent simultaneous access to the
hardware from more than one thread/process.

Changes since v1:

- Added Patch #4.
- Extended commit message for patch #3.
- Changed exynos_prng_type enum and a define according to Krzysztof Kozłowski's
  recommendations.
- Brought back cpu_relax() in a rearranged loop in
  exynos_rng_get_random().
- Moved an assignment of the read valuea away from an error path.
- Removed dev_info() reporting hardware presence from
  exynos_rng_probe().

Łukasz Stelmach (4):
  crypto: exynos - Support Exynos5250+ SoCs
  crypto: exynos - Improve performance of PRNG
  crypto: exynos - Reseed PRNG after generating 2^16 random bytes
  crypto: exynos - Introduce mutex to prevent concurrent access to
    hardware

 .../bindings/crypto/samsung,exynos-rng4.txt        |   4 +-
 drivers/crypto/exynos-rng.c                        | 104 +++++++++++++--------
 2 files changed, 70 insertions(+), 38 deletions(-)

-- 
2.11.0
