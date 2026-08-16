Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F59397936
	for <linux-crypto@vger.kernel.org>; Sun, 16 Aug 2026 19:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786909318; cv=none; b=hSTBwdJ+ev3U0PDpDcOqrRBp1z/7cN5wFm/PzjATUZCRd0LXvUjvbw3Nyymw6AyDSWRUGnXAxgUBbO8MY3LSK25d+5ammBHdA5GgNxcDtYFe8Mg1LxZ0LxCcMiUO6BNVRQtvVcaNhCgW8QbE8kR0j/k2xUOs2vo3vBAJ+e0nlSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786909318; c=relaxed/simple;
	bh=d3VWBqzpbTjhqXC29tNbRGiXh6LLK3Vg01/8Pq31n0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ksxx9zn1CvWoITD3EmPIn6KP6k6g26Bej156SpyLFfIVYvaKjWJMbecjdx+f6HOese6qOlaQbYMgw0NAVkwoTClZVkoukavmATfHcYjhBSJjs4fnZDmdFhp7yPvwfenDNJB5OBXf4++xbL1kd19HcRbGIoziYpfKYFzxM77xFbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QIO1rGKY; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QIO1rGKY"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4954dff6536so20264855e9.0
        for <linux-crypto@vger.kernel.org>; Sun, 16 Aug 2026 12:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786909315; x=1787514115; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=n3I/yM1LIFc5qnjFwFkWXbpoaLK6muVELlDy7x8BHls=;
        b=QIO1rGKY4Q5M+fXWHUt6APycd7Y+wnFgGecAS8I5B4Swz97AJSKKWS4CVKBL859MM3
         H1MqcjPt1s6yv6cCz5sd2/h1Hx3szaFBJr3dfM/P0GxQaeVaKi1HyieQIz1pMXxl7Jl3
         tKbtX3q4Y3Vrfa/ZdnYQSdowKNQM1a15DyInYIHjv9PIuiuze78lvf3CB1vIrgmziyeT
         ihIq9kH4RicG+f0wAHHQNpkqPUfCDC8q5NeVjoQ7w4NlsH0KjcLAZG7ojWp1qb8J9qy/
         p2OQN1xw2TAw/BPaLRZpKyO6p07JFHy54x3KcOWq1gerRtDNC2NOGBOXhjC54Tq9gY0G
         zvzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786909315; x=1787514115;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n3I/yM1LIFc5qnjFwFkWXbpoaLK6muVELlDy7x8BHls=;
        b=ZvFhJux1fELzY8WYC6QzjKyzL3HTb5vrJgcvgwqc0zqy4K8At2IIB04T0H2cLFxyYI
         GvbZ/LI3J5DndW1dW067GcJkNzSYvp70qRwGYdPZ8xzQnfYZdeiQFKxCzxclgSk3uel8
         yaM6ibopfEGgntfD/FGLAeM/1n5w+70Y3Kur84ramdsmRWncXqYEB0CG6urHO1sVOAkb
         y1F4b3Lj6UBTmwnWtop8OHmpWyPbWx4KxncDsrm0uhXok2xB+jbNjCc8/cXzvOIQcbgP
         FlJabgWvcdyW2o/dDmXWZkTGKTItfbc/MZqTE4ZXgBR9unDjJsLoUYShJDsd0RxFOvf4
         YwKA==
X-Forwarded-Encrypted: i=1; AHgh+RrJnoRFDLK4+ijrlNh7Gja3tBqJoqlFkGNuYM4NYvVFdywtrsrLeZYMqyY1Pd4BD1Oqu9fF94aUsqnMkKY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzg8rNgUm/s/KxkJa3hbHcZAUHpFb1TNhnDQWv0SZmk6caRlGKE
	3Yxy9i3K7VBu98640Zvsjof1lHZlpGW2vVpPqrW6pHYS1QP0/7cUNu5I
X-Gm-Gg: AR+sD10dgAqb+mLQEpYGjdnrmRuy4azaZ6U9OpHN951X+oGN6ECQSQ4T/mYjldrPRoF
	4HtqpbBUWTy12ozXRy4nt0aIVOwmZYTeR+sfpGhuJtrJtwPsvRD+UQzz7gval+HWAM73x7KS/7P
	VCUNESUH0iK5w6VyACII2x+5wZRFepTWmGIqo1dR9/3I3C833J4q2uyfybf/MowvSw77MuViHjE
	uPIYCwiSJkH9PsIWWIBQvMkb7oQg1URE3mE803hRvU8ruTSLD2EA9XHGZ7+nrt0C554ZjpTXtXQ
	ex9757CmJMoMQhRq3yVXdf1HB2xYcThPpejCTmIccoBk4HCzaeD0y6S0nj3zyijZYVfmA6ATrTj
	eyJLpUPaqoeON2CDHVccVy+TDgHz1DTc66uk6pEjwYsp3HOSUsgGPuj6/FIVOL3/WNA6ZfI5rHI
	+jw0JBD+i82w0B5BwzLJvyUsNxol+5BBwmPCpnbtUNyAygvDBZUukciQ==
X-Received: by 2002:a05:600c:4fc9:b0:499:79c3:4b55 with SMTP id 5b1f17b1804b1-4998797befamr299586395e9.18.1786909314375;
        Sun, 16 Aug 2026 12:41:54 -0700 (PDT)
Received: from olympus.. ([2a0a:ef40:f1b:d401:2e0:4cff:fe68:285])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49996106c6esm100527875e9.5.2026.08.16.12.41.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 12:41:53 -0700 (PDT)
From: Dawid Olesinski <dawidro@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>
Cc: Diederik de Haas <diederik@cknow-tech.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Conor Dooley <conor+dt@kernel.org>,
	Corentin Labbe <clabbe@baylibre.com>,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Dawid Olesinski <dawidro@gmail.com>
Subject: [PATCH v3 0/4] crypto: rockchip: Add RK356x/RK3588 cryptographic offloader
Date: Sun, 16 Aug 2026 20:39:43 +0100
Message-ID: <20260816194112.552100-1-dawidro@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708175837.1718437-1-dawidro@gmail.com>
References: <20260708175837.1718437-1-dawidro@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series adds support for the second-generation (V2) Rockchip
cryptographic hardware accelerator found on RK3568 and RK3588 SoCs.

The IP block provides AES (ECB, CBC, XTS) and hash (SHA-1, SHA-256,
SHA-384, SHA-512, MD5, SM3) offload via an LLI-based DMA engine.

The series is ordered as required: binding first, then driver, then
the two DTS nodes that reference the binding.

A prerequisite patch removing SECURECRU reset definitions from the
non-secure CRU driver is sent separately to the clk/reset tree, as it
touches a different subsystem. That patch is not a hard dependency for
the driver to build or load, but it is needed for correctness on RK3588:
those register offsets map into TrustZone-protected MMIO and must not be
accessed directly by Linux.

This work started from unmerged patches by Corentin Labbe
<clabbe@baylibre.com> posted at:
https://patchew.org/linux/20231107155532.3747113-1-clabbe@baylibre.com/

The implementation has been substantially reworked. Notable changes from
Corentin's original series:
  - DMA descriptor race condition and DMA mapping leak on timeout fixed
  - Per-device algorithm copy replaces global device list, removing a
    locking bottleneck and correctly supporting multiple instances
  - Runtime PM autosuspend added; clocks and reset gated between requests
  - Multi-SG hash requests routed to software fallback (hardware padding
    engine requires total message length upfront and cannot maintain
    state across LLI boundaries)
  - Hardware interrupt enable register write corrected to use the
    HIWORD_UPDATE mask that the hardware requires
  - Software fallback for all registered algorithms; statesize promotion
    for export/import compatibility with ARM Crypto Extensions drivers
  - SCMI reset and clock references in DTS corrected for RK3588

Tested-by: Diederik de Haas <diederik@cknow-tech.com>
Quartz64-B (RK3566), NanoPi R5S (RK3568), NanoPC-T6 LTS (RK3588)

Tested on Orange Pi 5 Pro (RK3588S) and Banana Pi R2 Pro (RK3568).

All ten algorithm selftests pass. AES-CBC throughput measured
at ~100 MiB/s with cryptsetup. PM autosuspend/resume verified over 1000
consecutive hash requests with no errors. 20 modprobe/rmmod cycles
produce no DMA coherent memory leaks.

Patch series for the crypto subsystem:
  [1/4] dt-bindings: crypto: rockchip: Add RK356x/RK3588 crypto engine
  binding
  [2/4] crypto: rockchip: Add RK356x/RK3588 cryptographic offloader driver
  [3/4] arm64: dts: rockchip: Add crypto node to rk356x-base
  [4/4] arm64: dts: rockchip: Add crypto node to rk3588-base

Separate patch for clk/reset tree:
  clk: rockchip: rk3588: Remove SECURECRU reset definitions

Changes in v3:
  Device tree binding (Sebastian Reichel, Heiko Stübner, sashiko-bot):
    - Merge the compatibles: rk3588-crypto now falls back to
      rk3568-crypto (oneOf schema). The driver binds only against
      rockchip,rk3568-crypto; the rk3588 string is reserved for future
      quirks.
    - Allow up to three reset lines (core/aclk/hclk) instead of a single
      reset, so a complete node describing the AXI and AHB resets
      validates.
    - Drop "status = disabled" from the crypto nodes in both
      rk356x-base.dtsi and rk3588-base.dtsi; the block needs no
      board-specific resources.

  Driver (sashiko-bot):
    - Add SYSTEM_SLEEP_PM_OPS (pm_runtime_force_suspend /
      pm_runtime_force_resume) so the hardware is suspended correctly
      across system sleep even inside the autosuspend window.
    - Guard the interrupt handler with pm_runtime_get_if_active() and
      balance pm_runtime_put() on all return paths, preventing register
      access to unclocked hardware during the teardown window.
    - Allocate the per-device algorithm array with kmemdup() instead of
      devm_kmemdup() and free it explicitly in remove() after the engine
      is drained and algorithms are unregistered, so the templates
      outlive any in-flight teardown.
    - Drop the explicit crypto_engine_stop() in remove(); rely on
      crypto_engine_exit() to stop and synchronously drain the kworker.
    - On skcipher DMA timeout, assert reset and synchronize_irq() before
      unmapping the scatterlists, so delayed hardware cannot write to
      unmapped memory.
    - Add CRYPTO_ALG_TYPE_AHASH support to rk2_crypto_debugfs_stats_show()
      to print request and fallback counters for hash algorithms.

  Driver - cleanup (Diederik de Haas):
    - Remove the redundant is_xts template field; test
      rk2_mode == RK2_CRYPTO_AES_XTS directly.

  Driver — correctness and robustness (review round 2):
    - Use explicit 32-bit DMA address handling: wrap sg_dma_address()
      and the LLI base in lower_32_bits() for both the skcipher and
      hash descriptor programming, making the hardware's 32-bit
      limitation explicit and silencing sparse on 64-bit builds.
    - Fix AES-XTS IV handling: req->iv is the XTS tweak, not a CBC-style
      chaining IV, so it must not be overwritten with ciphertext. Gate
      the backup_iv save/restore on a single update_iv flag that
      excludes XTS, leaving the tweak untouched across chained requests.
    - Zero ctx->key (memzero_explicit) and reset keylen when the
      fallback setkey fails, for both rk2_aes_setkey() and
      rk2_aes_xts_setkey().
    - Harden the IRQ/PM suspend path: mask and clear DMA interrupts in
      rk2_crypto_pm_suspend() and re-clear/re-enable them in
      rk2_crypto_pm_resume(), so a pending level-triggered interrupt in
      the suspend window cannot storm.
    - Use crypto_skcipher_set_reqsize() / crypto_ahash_set_reqsize()
      instead of assigning tfm->reqsize directly.
    - Align DMA interrupt bit names in rk2_crypto.h (bits 1–6) with the TRM
      v1.0 specification.
    - Update rk2_crypto_irq_handle() inline comment to reference
      DST_ITEM_DONE and SRC_ITEM_DONE.

  Driver — cleanup:
    - Simplify the hash path to a single scatterlist element (multi-SG
      hash already falls back), removing the now-dead LLI loop.
    - Name the AES-192 capability bit (RK2_AES_VER_SUPP_192) and comment
      it, instead of a bare BIT(17) in the debug info dump.

v2: https://lore.kernel.org/r/20260708175837.1718437-1-dawidro@gmail.com

Changes in v2:
 - dt-bindings: wrap example in a bus node with #address/#size-cells = 2
   and add the SCMI clock/reset dt-binding includes so dt_binding_check
   passes (Rob Herring / Krzysztof Kozlowski review).
 - crypto: fix Kconfig to select CRYPTO_SM3 instead of the non-existent
   CRYPTO_SM3_GENERIC.
 - crypto: drop IRQF_SHARED (the line is dedicated) and request the IRQ
   only after clocks are enabled and the completion is initialised;
   reorder probe accordingly.
 - crypto: set a 32-bit DMA mask before allocating the descriptor table.
 - crypto: suspend the device explicitly on removal before disabling
   runtime PM to avoid leaking clocks.
 - crypto: call synchronize_irq() on the DMA timeout paths to close a
   race with delayed interrupts.
 - crypto: convert fallback statistics to atomic_long_t.
 - crypto: use cpu_to_le32() for all LLI descriptor fields (big-endian
   correctness).
 - crypto: read key/IV with get_unaligned_be32() to fix an alignment
   fault and a big-endian double-swap.
 - crypto: fix the CBC/XTS IV backup offset to use the processed length
   instead of the scatterlist capacity.
 - arm64: dts: rk356x: move the crypto node into unit-address order.

v1: https://lore.kernel.org/r/20260530160704.3453555-1-dawidro@gmail.com/

Build/rebase fixes (not from review):
 - crypto: use sizeof(struct sm3_ctx) for the SM3 statesize, as
   struct sm3_state was removed by the lib/crypto SM3 conversion.
 - crypto: add the missing SHA-224 zero-message case.

Dawid Olesinski (4):
  dt-bindings: crypto: rockchip: Add RK356x/RK3588 crypto engine binding
  crypto: rockchip: Add RK356x/RK3588 cryptographic offloader driver
  arm64: dts: rockchip: Add crypto node to rk356x-base
  arm64: dts: rockchip: Add crypto node to rk3588-base

 .../crypto/rockchip,rk3588-crypto.yaml        |  83 ++
 MAINTAINERS                                   |   2 +
 arch/arm64/boot/dts/rockchip/rk356x-base.dtsi |  11 +
 arch/arm64/boot/dts/rockchip/rk3588-base.dtsi |  11 +
 drivers/crypto/Kconfig                        |  32 +
 drivers/crypto/Makefile                       |   1 +
 drivers/crypto/rockchip/Makefile              |   5 +
 drivers/crypto/rockchip/rk2_crypto.c          | 783 ++++++++++++++++++
 drivers/crypto/rockchip/rk2_crypto.h          | 254 ++++++
 drivers/crypto/rockchip/rk2_crypto_ahash.c    | 541 ++++++++++++
 drivers/crypto/rockchip/rk2_crypto_skcipher.c | 740 +++++++++++++++++
 11 files changed, 2463 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.yaml
 create mode 100644 drivers/crypto/rockchip/rk2_crypto.c
 create mode 100644 drivers/crypto/rockchip/rk2_crypto.h
 create mode 100644 drivers/crypto/rockchip/rk2_crypto_ahash.c
 create mode 100644 drivers/crypto/rockchip/rk2_crypto_skcipher.c

-- 
2.47.3

