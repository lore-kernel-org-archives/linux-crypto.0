Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0FE3BAD9B
	for <linux-crypto@vger.kernel.org>; Wed,  8 Jul 2026 17:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783533539; cv=none; b=kDibq5UwU3AWCN0TtcflF7Vj9JwCJyLWtqk+eHRcrRrDWZ2F/LEV9zEXRIWpfmxjahnB7ivDAzba8Y1ewAuwXcxLUNPsnHRes+UHb1+CPmI8VFClcCcDkip8mGKxgSQ9MDdqtQ/2WYeRCe2tfZuSVcBhdOJVSV+3Kmx7xXRwGvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783533539; c=relaxed/simple;
	bh=Dx/U1QTn3apYjRiz0yi9z250wQK129Fy+tAB/HadHMY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qmC8mUtnNpbBGlJXWcpN89AHh3O/BDP0ZnNKX48O4mrzcgCkJ37s4Dkxd6G+9TRF71k3PmMTn1KaGdHF/qqg55QsYW9Z51Fg0XIJHxq5krqIl06krfdCmKPwRZaRNVf/DcgChX1OpvtbVDpZ6Ee20GHZ/v3DTGAwJOmbdi+BsUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zy+f3Yfu; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zy+f3Yfu"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6986578d8c0so51208a12.1
        for <linux-crypto@vger.kernel.org>; Wed, 08 Jul 2026 10:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783533536; x=1784138336; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mQO7OwEt2ayLBwYgGRVhBYGfbjzxMLDxfhpK0SkwD/o=;
        b=Zy+f3Yfu/N/8tVVS/2aEcVR1GVrcbS53CCvzgs1q63rWItqT8wU9J7alx81f6xSTGQ
         GtGMG+0cawyOmWcG8diitYzhCGQYBmTeglh3kt/DyElNScC/S1bw5oXQzjYp59uVEUYq
         v73b+F2ijHYp9/KHfM+iTXJp8h3APA/O4VCbr5cTUm3bsBAQksH2FDRUycRvSD2V9CJ/
         HR633lucUQO8CtFojS48UlEE/Ud4YLF3vGb19tQaUuQ+jjeJIQRYYQk6RcDuLOHujyYr
         fQ/TxujbhbdWK8whc2VHRFEBd3jLYPsAC/0i8yi0C9Z4pqOwxTlK1lpkUAGSoZ8Fy0mG
         HJZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783533536; x=1784138336;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mQO7OwEt2ayLBwYgGRVhBYGfbjzxMLDxfhpK0SkwD/o=;
        b=jWkc8u0LtQy8qYBScv1yCANAtwLbcv1dlBNKWP2QS1rjqCl+2vg6NqGye0VlGDOg5a
         tx7C/doppuhEdE0xyfDAqoNUszbnI3QZZ30DULzdl7CWRiSnpF1Q1aM/RdV7ekmMW/uJ
         tms+CmXNYQA0sRLGIfKrt2+Rn9TGfAA3WJJ1RYU5zVQI81gl5wg7q1BvoA7g5G+GwuzR
         I+5pf9g4+7bBXoydh+XtdDxWt4Qkecpex4yjiG5BoA7vI/h1FfQgEbliNanbYbVIFHkG
         byzw2jwP+gKD7PaJbjoNIjNF/5UTN6vitHz707Llrvm3bttF1nzCml2aBsc+rjUexmcI
         Jajg==
X-Forwarded-Encrypted: i=1; AHgh+RqYjkZCVVf5GG0zJg630nmV0aUwSbaZdNf8tqL5zdNqTPHUkMxZ2BvNkMfliYcLinPH/+rAGgTbHfpNj6g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYSQ+SQeyedN1gEQSQk9JsOrGIabqo7v58Zv8T4LYcjpXMuGu9
	/BdpGOlQn1dbqMzBZw+plGs9jpKAn9FG9T6M/IZPjPbeSdkXqUpx5J7x
X-Gm-Gg: AfdE7cmZKhRsM2pgKGHnQcFDKLaUh+uIrvUd3+2wRKzitbuEdVZuDUw0cz+ZZMVhvpr
	CTskDDYE9Czp7DKFOeI0aQN2gf8xXYsuXb/nLQj52aMrzrhErKY6WrZAYRo6eLyRswSnIekFo1K
	G6c/1IWBtNdDNrHA8woumdvq0WKZTqBIciPcaG3I/7F36sSbalc1OSCHyemtGQy9IYTpx0OvWML
	k2JFyUD2E3MjhpPxnRmLWptZly2d+sQVttsq5Ff+tAEL0BDF18F/eT+/jy5K1rSg44QLKxT5pDs
	7ZdP8s5peXmKu/RHgWhK2p84o2rg17qLNlj3PpuClHR0bQb+Hkdax4LW41GXGfYe5M/EcWFVpST
	Fkpl+pH7BMp6h1+3AmLuBddN1xJfwOJZLDe3VQWCQk6g7BZ8MvxJDIi2fhvknmL/lMY34ryt4Xd
	UWor41UQ==
X-Received: by 2002:a17:906:4fce:b0:c12:5e26:da50 with SMTP id a640c23a62f3a-c15ce14c65bmr157380766b.65.1783533535639;
        Wed, 08 Jul 2026 10:58:55 -0700 (PDT)
Received: from olympus.. ([2a0a:ef40:ea3:3f01:2e0:4cff:fe68:285])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15ad9bcc26sm357653666b.34.2026.07.08.10.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 10:58:55 -0700 (PDT)
From: Dawid Olesinski <dawidro@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>
Cc: Conor Dooley <conor+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Corentin Labbe <clabbe@baylibre.com>,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Dawid Olesinski <dawidro@gmail.com>
Subject: [PATCH v2 0/4] crypto: rockchip: Add RK356x/RK3588 cryptographic offloader
Date: Wed,  8 Jul 2026 18:58:21 +0100
Message-ID: <20260708175837.1718437-1-dawidro@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
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

Tested on Orange Pi 5 Pro (RK3588S). All nine algorithm selftests pass.
AES-CBC throughput measured at ~100 MiB/s with cryptsetup. PM
autosuspend/resume verified over 1000 consecutive hash requests with no
errors. 20 modprobe/rmmod cycles produce no DMA coherent memory leaks.

Patch series for the crypto subsystem:
  [1/4] dt-bindings: crypto: rockchip: Add RK356x/RK3588 crypto engine
  binding
  [2/4] crypto: rockchip: Add RK356x/RK3588 cryptographic offloader driver
  [3/4] arm64: dts: rockchip: Add crypto node to rk356x-base
  [4/4] arm64: dts: rockchip: Add crypto node to rk3588-base

Separate patch for clk/reset tree:
  clk: rockchip: rk3588: Remove SECURECRU reset definitions

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

v1: https://patchwork.kernel.org/project/devicetree/cover/20260530160704.3453555-1-dawidro@gmail.com/

Build/rebase fixes (not from review):
 - crypto: use sizeof(struct sm3_ctx) for the SM3 statesize, as
   struct sm3_state was removed by the lib/crypto SM3 conversion.
 - crypto: add the missing SHA-224 zero-message case.

Dawid Olesinski (4):
  dt-bindings: crypto: rockchip: Add RK356x/RK3588 crypto engine binding
  crypto: rockchip: Add RK356x/RK3588 cryptographic offloader driver
  arm64: dts: rockchip: Add crypto node to rk356x-base
  arm64: dts: rockchip: Add crypto node to rk3588-base

 .../crypto/rockchip,rk3588-crypto.yaml        |  75 ++
 arch/arm64/boot/dts/rockchip/rk356x-base.dtsi |  12 +
 arch/arm64/boot/dts/rockchip/rk3588-base.dtsi |  12 +
 drivers/crypto/Kconfig                        |  32 +
 drivers/crypto/Makefile                       |   1 +
 drivers/crypto/rockchip/Makefile              |   5 +
 drivers/crypto/rockchip/rk2_crypto.c          | 746 ++++++++++++++++++
 drivers/crypto/rockchip/rk2_crypto.h          | 249 ++++++
 drivers/crypto/rockchip/rk2_crypto_ahash.c    | 565 +++++++++++++
 drivers/crypto/rockchip/rk2_crypto_skcipher.c | 728 +++++++++++++++++
 10 files changed, 2425 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.yaml
 create mode 100644 drivers/crypto/rockchip/rk2_crypto.c
 create mode 100644 drivers/crypto/rockchip/rk2_crypto.h
 create mode 100644 drivers/crypto/rockchip/rk2_crypto_ahash.c
 create mode 100644 drivers/crypto/rockchip/rk2_crypto_skcipher.c

-- 
2.47.3

