Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D39191F60;
	Tue, 20 Aug 2024 15:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.89.224.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724166150; cv=none; b=FiiFU4ZAQB0FM/xAcRREGgOWz9OYz6Y+OQ757jFYH5iJcvXd7ahWZbGur4rqRzNjkybkpTRXfVd0Off+4gnvZTgAklMERqI7f1tDVTIjP3B6yGsWjOK+iIPFpx9JqqzRugpjOjCXNy10T7dnDee42yRa02jlqkkUTpFbLfr7L5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724166150; c=relaxed/simple;
	bh=Pn5Be2dh0+czNJ0r2kXuL6VCoqseYLZz15AvC634pGY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gPEloUCZ6m5cO5faiLdPR5U+Ex5ksdPPvUYhTvM3Z8RFk+0OmEfjhJi6CrypGMH2wEj8WrXTg8UmbwJzl/a6ryQfGDzdDZ22GBPT5Ka2jShSyAiqTuwFZHF5Xd1gUTHV5JRbQL5tzM6RtkhECNa7EX3joInALN/NPRlhwrtho5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=s2b.tech; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=MD/4Gnrv; arc=none smtp.client-ip=45.89.224.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=s2b.tech
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="MD/4Gnrv"
Received: from p-infra-ksmg-sc-msk02.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id E4D3E120013;
	Tue, 20 Aug 2024 17:56:48 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru E4D3E120013
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1724165808;
	bh=MrVtz0e/hcb5PS4asT0CJG1SO1SVV/nNa9m/pnKuUpU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=MD/4GnrvAamoZR3TkwORfL5p2owAfIhFf/wQ/Z1/hP2LHcTP67awyEXx6v8NCnWpW
	 Gbd74JTRYL7trfSfHpOmaO2NOluAURy4uWmukpNnaN7mQlyVPotn03smq7TmsSA4Cx
	 qnyEZLjmLGQoRI8vpjfj66WC0rEB8vALu2nclKKFW+/otu31UdH89KdXJA5n2EUzWe
	 3c/TGcE40xarTKFDauz8QkNHrXRuu/fccwzWftQ0DFthwhA1QtajCtGYlF6eE0XnIO
	 pP419djA87fuLzchSX8RTGKy4h8uuPUt0ZX8CDoQDic7moZawmYBSxQw6GCZfVoIWE
	 ettpPiSO2D4Dg==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m02.sberdevices.ru [172.16.192.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Tue, 20 Aug 2024 17:56:48 +0300 (MSK)
From: Alexey Romanov <avromanov@salutedevices.com>
To: <neil.armstrong@linaro.org>, <clabbe@baylibre.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <robh+dt@kernel.org>,
	<krzysztof.kozlowski+dt@linaro.org>, <conor+dt@kernel.org>,
	<khilman@baylibre.com>, <jbrunet@baylibre.com>,
	<martin.blumenstingl@googlemail.com>, <vadim.fedorenko@linux.dev>
CC: <linux-crypto@vger.kernel.org>, <linux-amlogic@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <kernel@salutedevices.com>, Alexey
 Romanov <avromanov@salutedevices.com>
Subject: [PATCH v9 00/23] Support more Amlogic SoC families in crypto driver
Date: Tue, 20 Aug 2024 17:56:00 +0300
Message-ID: <20240820145623.3500864-1-avromanov@salutedevices.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: p-i-exch-a-m1.sberdevices.ru (172.24.196.116) To
 p-i-exch-sc-m02.sberdevices.ru (172.16.192.103)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 187181 [Aug 20 2024]
X-KSMG-AntiSpam-Version: 6.1.0.4
X-KSMG-AntiSpam-Envelope-From: avromanov@s2b.tech
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 27 0.3.27 71302da218a62dcd84ac43314e19b5cc6b38e0b6, {Tracking_smtp_not_equal_from}, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;s2b.tech:7.1.1;gist.github.com:7.1.1;smtp.sberdevices.ru:7.1.1,5.0.1;salutedevices.com:7.1.1;lore.kernel.org:7.1.1, {Tracking_smtp_domain_mismatch}, {Tracking_smtp_domain_2level_mismatch}, FromAlignment: n
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean, bases: 2024/08/20 14:24:00
X-KSMG-LinksScanning: Clean, bases: 2024/08/20 14:24:00
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/08/20 03:45:00 #26365304
X-KSMG-AntiVirus-Status: Clean, skipped

Hello!

This patchset expand the funcionality of the Amlogic
crypto driver by adding support for more SoC families:
AXG, G12A, G12B, SM1, A1, S4.

Also specify and enable crypto node in device tree
for reference Amlogic devices.

Tested on GXL, AXG, G12A/B, SM1, A1 and S4 devices via
custom tests [1] and tcrypt module.

---

Changes V1 -> V2 [2]:

- Rebased over linux-next.
- Adjusted device tree bindings description.
- A1 and S4 dts use their own compatible, which is a G12 fallback.

Changes V2 -> V3 [3]:

- Fix errors in dt-bindings and device tree.
- Add new field in platform data, which determines
whether clock controller should be used for crypto IP.
- Place back MODULE_DEVICE_TABLE.
- Correct commit messages.

Changes V3 -> V4 [4]:

- Update dt-bindings as per Krzysztof Kozlowski comments.
- Fix bisection: get rid of compiler errors in some patches.

Changes V4 -> V5 [5]:

- Tested on GXL board:
  1. Fix panic detected by Corentin Labbe [6].
  2. Disable hasher backend for GXL: in its current realization
     is doesn't work. And there are no examples or docs in the
     vendor SDK.
- Fix AES-CTR realization: legacy boards (gxl, g12, axg) requires
  inversion of the keyiv at keys setup stage.
- A1 now uses its own compatible string.
- S4 uses A1 compatible as fallback.
- Code fixes based on comments Neil Atrmstrong and Rob Herring.
- Style fixes (set correct indentations)

Changes V5 -> V6 [7]:

- Fix DMA sync warning reported by Corentin Labbe [8].
- Remove CLK input from driver. Remove clk definition
  and second interrput line from crypto node inside GXL dtsi.

Changes V6 -> V7 [9]:

- Fix dt-schema: power domain now required only for A1.
- Use crypto_skcipher_ctx_dma() helper for cipher instead of
  ____cacheline_aligned.
- Add import/export functions for hasher.
- Fix commit message for patch 17, acorrding to discussion [10].

Changes V7 -> V8 [11]:

- Test patchset with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS: fix some bugs
  in hasher logic.
- Use crypto crypto_ahash_ctx_dma in hasher code.
- Correct clock definition: clk81 is required for all SoC's.
- Add fixed-clock (clk81) definition for A1/S4.
- Add information (in commit messages) why different compatibles are used.

Changes V8 -> V9 [12]:

- Remove required field clk-names from dt-schema according to Rob Herring
recommendation [13].
- Fix commit order: all dt-bindings schema commits now located earlier
than any changes in device tree.
- Fix typos and add more clarifications in dt-schema patches.

Links:
  - [1] https://gist.github.com/mRrvz/3fb8943a7487ab7b943ec140706995e7
  - [2] https://lore.kernel.org/all/20240110201216.18016-1-avromanov@salutedevices.com/
  - [3] https://lore.kernel.org/all/20240123165831.970023-1-avromanov@salutedevices.com/
  - [4] https://lore.kernel.org/all/20240205155521.1795552-1-avromanov@salutedevices.com/
  - [5] https://lore.kernel.org/all/20240212135108.549755-1-avromanov@salutedevices.com/
  - [6] https://lore.kernel.org/all/ZcsYaPIUrBSg8iXu@Red/
  - [7] https://lore.kernel.org/all/20240301132936.621238-1-avromanov@salutedevices.com/
  - [8] https://lore.kernel.org/all/Zf1BAlYtiwPOG-Os@Red/
  - [9] https://lore.kernel.org/all/20240326153219.2915080-1-avromanov@salutedevices.com/
  - [10] https://lore.kernel.org/all/20240329-dotted-illusive-9f0593805a05@wendy/
  - [11] https://lore.kernel.org/all/20240411133832.2896463-1-avromanov@salutedevices.com/
  - [12] https://lore.kernel.org/all/20240607141242.2616580-1-avromanov@salutedevices.com/
  - [13] https://lore.kernel.org/all/20240610222827.GA3166929-robh@kernel.org/

Alexey Romanov (23):
  drivers: crypto: meson: don't hardcode IRQ count
  drviers: crypto: meson: add platform data
  drivers: crypto: meson: remove clock input
  drivers: crypto: meson: add MMIO helpers
  drivers: crypto: meson: move get_engine_number()
  drivers: crypto: meson: drop status field from meson_flow
  drivers: crypto: meson: move algs definition and cipher API to
    cipher.c
  drivers: crypto: meson: cleanup defines
  drivers: crypto: meson: process more than MAXDESCS descriptors
  drivers: crypto: meson: avoid kzalloc in engine thread
  drivers: crypto: meson: introduce hasher
  drivers: crypto: meson: add support for AES-CTR
  drivers: crypto: meson: use fallback for 192-bit keys
  drivers: crypto: meson: add support for G12-series
  drivers: crypto: meson: add support for AXG-series
  drivers: crypto: meson: add support for A1-series
  dt-bindings: crypto: meson: correct clk and remove second interrupt
    line
  dt-bindings: crypto: meson: support new SoC's
  arch: arm64: dts: meson: gxl: correct crypto node definition
  arch: arm64: dts: meson: a1: add crypto node
  arch: arm64: dts: meson: s4: add crypto node
  arch: arm64: dts: meson: g12: add crypto node
  arch: arm64: dts: meson: axg: add crypto node

 .../bindings/crypto/amlogic,gxl-crypto.yaml   |  32 +-
 arch/arm64/boot/dts/amlogic/meson-a1.dtsi     |  14 +
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi    |   7 +
 .../boot/dts/amlogic/meson-g12-common.dtsi    |   7 +
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi    |   6 +-
 arch/arm64/boot/dts/amlogic/meson-s4.dtsi     |  13 +
 drivers/crypto/amlogic/Makefile               |   2 +-
 drivers/crypto/amlogic/amlogic-gxl-cipher.c   | 632 ++++++++++++------
 drivers/crypto/amlogic/amlogic-gxl-core.c     | 292 ++++----
 drivers/crypto/amlogic/amlogic-gxl-hasher.c   | 507 ++++++++++++++
 drivers/crypto/amlogic/amlogic-gxl.h          | 118 +++-
 11 files changed, 1269 insertions(+), 361 deletions(-)
 create mode 100644 drivers/crypto/amlogic/amlogic-gxl-hasher.c

-- 
2.34.1

