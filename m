Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372601DA5F;
	Thu, 30 Jan 2025 16:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738254746; cv=pass; b=bHD4AXTLJNJiJjyla05htedUxqdP63d/NY+0As6QQ2uEYONrMvFntWifD5DIFFhH4kFIgVo4aT2fT7KGUkoXKWOBemor3RrBGtwLjxWa2Ybdos5mwyn/oWUMTjS9lSVHULPFYgcNHOMB6jBJiBDZEPS0HWL3gnhtMG+A+25z088=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738254746; c=relaxed/simple;
	bh=IofK4l5y5xA/k5+MG3Q2H7arU7k46yFxh0juUaEQ76k=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=AUwWePNyF+3m63IjHIDrfnVCmbIXc8fH93z2DFNz1WrrX947VJZzYUkSPLTOFjtGZnLeFHURtxms4Ct0ES8bbeVRYX4qKcO+uH30AovQjsytazW2GrjSpPKvcBJQEorQmJasf4zPlkzq0yzMxuO+moDrKXFZcX32gTqephjhyK0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=Br3QZibM; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="Br3QZibM"
ARC-Seal: i=1; a=rsa-sha256; t=1738254702; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=lravY/6Wl6bFOP4EmaFB4pFXffqm3rogMJLqrBS5x/JGS95L2CmAN2jlNjV0gEXketvyyIBQGH2KucsT01Y6GQBjrkUPgZ5qnQrxP30NRwUgl/d+RK8qdZxwjphqX/FmcXMILZ/TtCJ7+8mjf1LwDLQWBVP1cguj66xFAKUwUGk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1738254702; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=LVPLI6+c3jau3bRD8yp1Q2Hkp9hVE39g34stjXufaqs=; 
	b=kY/vHYB63eY4CZqbBCJG6EwmrYBJ6KjPZZQuZMs1o0kzEEpM/qhlFjg5Ir4rYAcE3ebEXOd0wjprW5DlWjxHiKXFp8j2pNoxvXpHKEOzwRxkRbVKBGUF9St/LMyWiWkS90yEpN8y74lJCZ3LEmPbTkyGJ1Fu6Qns0QF27Hmkbr8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1738254702;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Type:Content-Transfer-Encoding:To:To:Cc:Cc:Reply-To;
	bh=LVPLI6+c3jau3bRD8yp1Q2Hkp9hVE39g34stjXufaqs=;
	b=Br3QZibMOVoXRRji3+2/pdH3aVwjEE7w2baX8S5TdLTzFedExDU9KXTGXWKKQl7i
	u/Q+Q/D/K3D4fmeCZ2A+g+7O3C0ysGnTJ8UrgWyOJO0i/UItnFvN0ThofxakxuSHbJM
	/7Acx630s1y1zvBqNrVbYKuJWbj/H0keXU8nTEHs=
Received: by mx.zohomail.com with SMTPS id 1738254696264631.910358401036;
	Thu, 30 Jan 2025 08:31:36 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Subject: [PATCH 0/7] RK3588 Hardware Random Number Generator Driver
Date: Thu, 30 Jan 2025 17:31:14 +0100
Message-Id: <20250130-rk3588-trng-submission-v1-0-97ff76568e49@collabora.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFKpm2cC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1MDQ2MD3aJsY1MLC92Sorx03eLSpNzMYpAWXQNTUyNT02RLMzMLSyWg5oK
 i1LTMCrDB0bG1tQCIRZyfaAAAAA==
X-Change-ID: 20250130-rk3588-trng-submission-055255c96689
To: Philipp Zabel <p.zabel@pengutronix.de>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Heiko Stuebner <heiko@sntech.de>, 
 Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Daniel Golle <daniel@makrotopia.org>, Aurelien Jarno <aurelien@aurel32.net>
Cc: Sebastian Reichel <sebastian.reichel@collabora.com>, 
 devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, 
 XiaoDong Huang <derrick.huang@rock-chips.com>, 
 Lin Jinhan <troy.lin@rock-chips.com>
X-Mailer: b4 0.14.2

This series adds support for the Rockchip RK3588's standalone hardware
random number generator to the existing mainline rockchip-rng driver.

The RK3588 has several hardware random number generators, one in each
the secure-world and non-secure-world crypto accelerator, and one
standalone one in each the secure-world and non-secure-world, so 4
hwrngs in total. This series adds support for the standalone hwrng,
which is an entirely new IP on this SoC and distinct from the one in the
Crypto IP.

The decision to integrate this into the existing rockchip-rng driver was
made based on a few factors:

1. The driver is fairly small.
2. While not much code is shared, some code is, specifically relating to
   power management, the hwrng interface and the probe function.
3. I don't want users to figure out why "CONFIG_HW_RANDOM_ROCKCHIP"
   doesn't enable the RK3588 one, and I really don't see a reason to
   build without both of them considering the other RK3588 TRNG (for
   which there is not yet a driver iirc) *does* share code with the
   existing rockchip-rng driver.

Here are the rngtest5 results from this new driver on my board:

  user@debian-rockchip-rock5b-rk3588:~$ cat /sys/class/misc/hw_random/rng_current 
  rockchip-rng
  user@debian-rockchip-rock5b-rk3588:~$ sudo cat /dev/hwrng | rngtest -c 10000 
  [...]
  rngtest: bits received from input: 200000032
  rngtest: FIPS 140-2 successes: 9990
  rngtest: FIPS 140-2 failures: 10
  rngtest: FIPS 140-2(2001-10-10) Monobit: 1
  rngtest: FIPS 140-2(2001-10-10) Poker: 0
  rngtest: FIPS 140-2(2001-10-10) Runs: 5
  rngtest: FIPS 140-2(2001-10-10) Long run: 4
  rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
  rngtest: input channel speed: (min=212.255; avg=29089.272; max=19531250.000)Kibits/s
  rngtest: FIPS tests speed: (min=64.005; avg=102.494; max=153.818)Mibits/s
  rngtest: Program run time: 11292340 microseconds

As you can see, the quality of the entropy is quite good, and the
throughput is an acceptable 29 Mibit/s.

The series starts out with two patches for the bindings. The bindings
are separate from the rockchip,rk3568-rng bindings, as the required
properties differ. The SCMI reset ID numbers are needed because mainline
uses a different reset numbering scheme, but TF-A uses the downstream
numbering scheme as far as I know. The TRNG must be reset through SCMI.

Next up are two cleanup patches for the existing driver. Even if a
decision is made to split the drivers for whatever reason, these two
patches should be used in the rk3568-rng driver as they get rid of small
peculiarities in the code without meaningfully changing how the driver
works.

Next up is the main driver patch that adds support for the new TRNG. As
the driver was developed by reading the downstream vendor code for this
particular device and reworking it, I've included the downstream vendor
developer who wrote the driver as a Co-developed-by tag with their
existing downstream sign-off.

The penultimate patch adds the node to the rk3588-base.dtsi, and enables
it in the one device I've been testing it on (RADXA Rock 5B). Other
devices may wish to enable it as well after verifying that the TRNG
produces randomness of the expected quality on their particular flavour
of the RK3588.* family.

Last but not least, I'm adding myself to the mailmap, because I now work
for Collabora.

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
Nicolas Frattaroli (7):
      dt-bindings: reset: Add SCMI reset IDs for RK3588
      dt-bindings: rng: add binding for Rockchip RK3588 RNG
      hwrng: rockchip: store dev pointer in driver struct
      hwrng: rockchip: eliminate some unnecessary dereferences
      hwrng: rockchip: add support for rk3588's standalone TRNG
      arm64: dts: rockchip: Add rng node to RK3588
      mailmap: add entry for Nicolas Frattaroli

 .mailmap                                           |   1 +
 .../bindings/rng/rockchip,rk3588-rng.yaml          |  61 +++++
 MAINTAINERS                                        |   2 +
 arch/arm64/boot/dts/rockchip/rk3588-base.dtsi      |   9 +
 arch/arm64/boot/dts/rockchip/rk3588-rock-5b.dts    |   4 +
 drivers/char/hw_random/Kconfig                     |   3 +-
 drivers/char/hw_random/rockchip-rng.c              | 264 ++++++++++++++++++---
 include/dt-bindings/reset/rockchip,rk3588-cru.h    |  41 +++-
 8 files changed, 349 insertions(+), 36 deletions(-)
---
base-commit: 72deda0abee6e705ae71a93f69f55e33be5bca5c
change-id: 20250130-rk3588-trng-submission-055255c96689

Best regards,
-- 
Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

