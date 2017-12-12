From: =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH v3 0/4] Assorted changes for Exynos PRNG driver
Date: Tue, 12 Dec 2017 17:36:03 +0100
Message-ID: <20171212163607.2985-1-l.stelmach@samsung.com>
References: <20171211140623.7673-1-l.stelmach@samsung.com>
        <CGME20171212163609eucas1p2aaee0a21276b66f4cb492a4502f66756@eucas1p2.samsung.com>
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
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-reply-to: <20171211140623.7673-1-l.stelmach@samsung.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello,

This is a series of patches for exynos-rng driver I've decided to
create after adding support for Exynos5250+ chips. They do not
strictly depend on each other, but I think it is better to send them
as a single patch-set.

The driver requires appropriate DT configuration introduced in

    https://patchwork.kernel.org/patch/10106797/

Patch #1 Add support for PRNG in Exynos5250+ SoCs

Patch #2 Improve output performance by using memcpy() rather than a
custom function to retrieve random bytes from registers. Rearrange
the loop for polling the hardware.

Patch #3 Reseed the PRNG after reading 2^16 bytes. Simmilar approach
is implemented in DRBG. (Thanks Stephan Mueller)

Patch #4 Introduce locking to prevent simultaneous access to the
hardware from more than one thread/process.

Changes since v2:

- Remove changes in the loop polling the status register in
  exynos_rng_get_random(). Thanks Krzysztof Kozłowski.
- Remove the check for valid values of rng->type from
  exynos_rng_probe(). The function wouldn't be called with values other
  than mentioned in exynos_rng_dt_match array.
- Applied changes to the commit message of patch #3 requested by Stephan
  Mueller.

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

 .../bindings/crypto/samsung,exynos-rng4.txt        |  4 +-
 drivers/crypto/exynos-rng.c                        | 94 ++++++++++++++--------
 2 files changed, 62 insertions(+), 36 deletions(-)

-- 
2.11.0
