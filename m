Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E852144BF;
	Tue,  4 Feb 2025 15:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738683443; cv=pass; b=sJSyoV+3Kc9u1wNNTSzD+yvurJ8Gxh0jtCXxIG2BG0mOCAzdY4tkdNYt0/3osTtJeQm2YVfkHwYHxd2Plqf39k0jJN88Hgi4jhph8055FKptR/7sU4R7GjKvZuJFmD6ioJ4SQewO+03LjgaMWQ9+nmw9r5pZvxJ/22Rvkkea4i4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738683443; c=relaxed/simple;
	bh=VvA9T/6/1ouApmi0pVoVzoVvdkTJ5i4k2HhcQaBOuKE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=XtM56uo8Xy55yFoLTgy87x6IevzP92/oGW2dOaEh36m5cOG17CQ+rQQgocLuAgzU0reIqMQ52in8IyxwZK1OwteRffk8O+QkrXpxidX+9kkEWPztMWj52KH8DpHilQfHsaHd8OWlrxWR40Na4tcVmmM/PSC+WUPbeF5E4qCdouc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=fYrbbgsj; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="fYrbbgsj"
ARC-Seal: i=1; a=rsa-sha256; t=1738683388; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=k0lgcf1dvRGVLSzSiPJVLuQRIu+lEHgND/pww59nuxqUd0/lQn+LsTsRPZjQCfo5jHJLo7gLOo/zjoqWUVqnW/eVOJ5f3N/xTEk2WRM2JDTkZ0rstqXZtxgSZiinbFIHY3QNiYCs00P5Zp7kT4Z+Vdcjr5+/g7ft+cYUvR4w0Hc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1738683388; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=8ujLKurGvDlQE7460495fVpBsgx7EB711zNkKXoYjcI=; 
	b=H2HkuFYUt57HAPyC5c9ZYxe9rw0ZohIGkiA6SgqJ/xE4QHfSoRp7BVR8jx/5kqUA8gi+hKZ/BvpVaINmVhlGQKCwyr3PFyFjvnvIf80vAGgy2wPLA8ftzk1B+tlx7XsJPzVFJM0/4qW9PyUOogX0L9+7IkrPuKUI+byx2iNo/Gw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1738683388;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Type:Content-Transfer-Encoding:To:To:Cc:Cc:Reply-To;
	bh=8ujLKurGvDlQE7460495fVpBsgx7EB711zNkKXoYjcI=;
	b=fYrbbgsj+lEyEKT5sYIq9OsndC4T4I9xa4kcOd2en8mHuqe3IdM6uQT8DwXwuuUW
	dSrdojQi2q6hA0kEEE/mLC7+xpXfi2YblxwHv2AwB29Pd7PpeK4pbZdfub3++Xvn/Fe
	dAlfLHY+w8jt+IKvbFgqFZjstUJMSVt0uCVTF1LA=
Received: by mx.zohomail.com with SMTPS id 17386833845484.547279568763543;
	Tue, 4 Feb 2025 07:36:24 -0800 (PST)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Subject: [PATCH v2 0/7] RK3588 Hardware Random Number Generator Driver
Date: Tue, 04 Feb 2025 16:35:45 +0100
Message-Id: <20250204-rk3588-trng-submission-v2-0-608172b6fd91@collabora.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANEzomcC/4WNQQ6CMBBFr0K6dkwpTmldeQ/DAmqBiUDNFImGc
 HcLF3D5fvLeX0X0TD6Ka7YK9gtFClMCdcqE6+up80CPxEJJhTIvJPCzQGNg5qmD+G5GirsCElE
 hOqu1sSLJL/YtfY7wvUrcU5wDf4+fJd/Xv8klBwm2bNtSozb+Ym8uDEPdBK7PLoyi2rbtBzI5c
 OrAAAAA
X-Change-ID: 20250130-rk3588-trng-submission-055255c96689
To: Philipp Zabel <p.zabel@pengutronix.de>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Heiko Stuebner <heiko@sntech.de>, 
 Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 Daniel Golle <daniel@makrotopia.org>, Aurelien Jarno <aurelien@aurel32.net>
Cc: Sebastian Reichel <sebastian.reichel@collabora.com>, 
 kernel@collabora.com, devicetree@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org, 
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, 
 XiaoDong Huang <derrick.huang@rock-chips.com>, 
 Conor Dooley <conor.dooley@microchip.com>, 
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

The penultimate patch adds the node to the rk3588-base.dtsi, and
enables it.

The final patch adds myself to the MAINTAINERS of this driver and these
bindings.

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
Changes in v2:
- Drop mailmap patch
- driver: restore the OF matching to how it was, and change soc_data to
  const
- dts: get rid of the board specific DTS enablement and instead enable
  it in rk3588-base
- bindings: drop the change of adding myself to maintainers from the
  bindings patch, make it a separate patch
- bindings: get rid of the comments
- bindings: set status = "okay" in the example
- bindings: make interrupts property required
- Add a patch to add me to the MAINTAINERS for this driver/binding
- Link to v1: https://lore.kernel.org/r/20250130-rk3588-trng-submission-v1-0-97ff76568e49@collabora.com

---
Nicolas Frattaroli (7):
      dt-bindings: reset: Add SCMI reset IDs for RK3588
      dt-bindings: rng: add binding for Rockchip RK3588 RNG
      hwrng: rockchip: store dev pointer in driver struct
      hwrng: rockchip: eliminate some unnecessary dereferences
      hwrng: rockchip: add support for rk3588's standalone TRNG
      arm64: dts: rockchip: Add rng node to RK3588
      MAINTAINERS: add Nicolas Frattaroli to rockchip-rng maintainers

 .../bindings/rng/rockchip,rk3588-rng.yaml          |  60 +++++
 MAINTAINERS                                        |   2 +
 arch/arm64/boot/dts/rockchip/rk3588-base.dtsi      |   9 +
 drivers/char/hw_random/Kconfig                     |   3 +-
 drivers/char/hw_random/rockchip-rng.c              | 250 ++++++++++++++++++---
 include/dt-bindings/reset/rockchip,rk3588-cru.h    |  41 +++-
 6 files changed, 335 insertions(+), 30 deletions(-)
---
base-commit: 72deda0abee6e705ae71a93f69f55e33be5bca5c
change-id: 20250130-rk3588-trng-submission-055255c96689

Best regards,
-- 
Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

