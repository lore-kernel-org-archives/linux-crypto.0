Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09A52C325E;
	Tue, 24 Jun 2025 13:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750773161; cv=none; b=Y81Y9n1gxQ2Cm+CabfQFu5yAy/Z0lWgyne7lpcovXIuZEME/z4Q8nh2ftST3mHj8H7vXA35PV9GO3zSzG+t8DC8lVPLeQic0tkUIjMCBFEyTKrbsgEBh5adCVvBv78S4Pqli8ejTtdHW8GrEehGvoMCEl/0M9GT4v+NQlTU49IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750773161; c=relaxed/simple;
	bh=u4cSvxrTcB2h+1HClJd3Z+kvuE5C84iKhH+3dNViS3o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=m/hbVOTqZ3NP9A1wp6hFBwdGcdITyoWlZvSdY6NFjrFVkFFQjKb+71wrPY4FJadYQnPm3YZTxdTp2RMognDgrFF6MaQSzjdLhkfQvUJ51cpwjWiYmJRrLeprpV2UHnaA3h6t/EF2WXSxdnoj/LBkAoKRkH0ZRJb57rOSziPrteQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j4HpP3Py; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j4HpP3Py"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5535652f42cso482897e87.2;
        Tue, 24 Jun 2025 06:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750773155; x=1751377955; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+wg9qW4GAB9SxeZP4ZPWnnJ0L3cq/NBnSEznhgizvFM=;
        b=j4HpP3PyFH9pckikVYIfvxTHLmZ1+dWclxxMU0nRGFirN0msJBz7S81PIBZTGVZhUt
         Neuy3uv+uie3TiEP2V+Wl8DnRJ67glOru1+TigOmiy32Y9dKG+ag8xu7UbC2l63swCjs
         XBwxtRqbwgRDBBXG4KcGIugGwWrAzDmsRPVWUJN/r4LZgptNs8btZJT0cKLsW7RaAoxe
         t6zhwiYGjkyK60lXRxyAiQ3zMicH/OukH//uSudoRn7qVTACa3TJN2/t9J7L+yr+aapM
         VYxCR9JnCj4qwKDBJ0vNhqp2+/COMg0XJNJ/dTWZ3jivzuehcJT8SDQeb58kjiZeoq7s
         yFqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750773155; x=1751377955;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+wg9qW4GAB9SxeZP4ZPWnnJ0L3cq/NBnSEznhgizvFM=;
        b=fkkp5LilUWkc8raxzt+/iar0kCFnybEC968ZpvcjcAZsqqCOYVOWQ5QRg7AdMpSNJ3
         yzCwGJUE7IbwkfydyH6LBunwFepVVrv1PdcEhVwT53uwOAzQFrUVW+/8/JLpBEymVHjq
         AVBNJ8e/JqkjpWfnqQszdsK/3u3gGZ2uW5jteqpIlNkd8J0/9RSmdNmFLg6lZ+H1otat
         c1xN53p6/tr3XJpYK+EbBTymtNWGPDvIR6Ckxut1T4BVNLaaHST6zFoj8fHmPUeBtT6C
         g2YR9To68RqfV4/84OYN7o1Z9mf1s2Bna51LZRlMcjIZEN3Ee+EBkO9d9habINAYW8Zb
         8kZA==
X-Forwarded-Encrypted: i=1; AJvYcCUWGtiS70kH75vQrZmZPkVssKs8bfMQon2G/1NdN6eAOqMyjvzTCishvFbPDTPDGY4yEayz3P+VJBCACqoW@vger.kernel.org, AJvYcCW7DJwP6d7ZKe1bFKt2f7BxwIWhN/tAdQWPkt+Oh8zI6oTnLt8P+LtWSqkdgHTnphIvM1zR/CjG7zOR@vger.kernel.org
X-Gm-Message-State: AOJu0YxA5uubokL0X0q0DcXRXAwQesNcezFy+7klBNDAiKDMXL3Zng6f
	+5qzm5B7R71Csbpp40eCaLVfS2PaSuA9srg0ZV5ctaa/ZF+U7Ww7KPhzi29mCw/OieQ=
X-Gm-Gg: ASbGnctbjIOSCjQz7LyRc+UKCJbwp6T7cCY6xSBsSYc6FUOYLBxAN+e8jSq9gd1T6TT
	H4jh/bMDbOBOGGn9ZNJvAg4tcwG5loFE3gledmo9CZ7T7ocSbyK2rGHkMvbn4dyls68gzXf7kYS
	O+9rvkwTjT7c/5cos7YhD/BSCwHxIzg6s7hIvuHCw/LYecfmUzdpaLgEB/WuBEXIZef8mg1KTat
	MCDPE8CTDFbNLj8cjWHwq92Sy/nPQweMwhxN62aLfi3bdOpS2lX9v1GIHVhQmQrs54VWkQV7Tq7
	1NkwgxXt/t17ImeKpnV6ybTkFmte02Wt4RWCvz13CEO/x2Mg2cvp5qIydw6/lOEFJ+ukzQY5/B/
	c7EHfvwMIm+ATwgzAMt4zgAVHYmK+YbvwYWOpCsBZD4pzWb6H1BuBFXTSIOkVmw==
X-Google-Smtp-Source: AGHT+IFOuf5bAzhEktFTfPKfMooaN6q3rqHW9Fgh4cH2Pb5c/Dt3frRC792c/mKVwGvTIdymva9mgw==
X-Received: by 2002:a05:6512:1390:b0:553:aa32:4105 with SMTP id 2adb3069b0e04-553e3bb55cfmr5482884e87.24.1750773154423;
        Tue, 24 Jun 2025 06:52:34 -0700 (PDT)
Received: from user-A520M-DS3H.sberdevices.ru (broadband-188-32-30-96.ip.moscow.rt.ru. [188.32.30.96])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-554e6dc186esm1282905e87.114.2025.06.24.06.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 06:52:33 -0700 (PDT)
From: Alexey Romanov <romanov.alexey2000@gmail.com>
To: neil.armstrong@linaro.org,
	clabbe@baylibre.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	khilman@baylibre.com,
	jbrunet@baylibre.com,
	martin.blumenstingl@googlemail.com
Cc: linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Alexey Romanov <romanov.alexey2000@gmail.com>
Subject: [PATCH v12 00/22] Support more Amlogic SoC families in crypto driver
Date: Tue, 24 Jun 2025 16:51:52 +0300
Message-Id: <20250624135214.1355051-1-romanov.alexey2000@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

Changes V9 -> V10 [14]:

- Rebased over linux-next (20241106).
- Remove patches with AES-CTR support. This was a dishonest implementation of CTR algo.
- Update commit headers in accordance with the accepted rules in each
  of the subsystems.
- Moved adding power-domains (dt-bindings) in desired commit.

Changes V10 -> V11 [15]:

- Rebased over linux-next (20241213).
- Fix unused variable warnings reported by kernel test robot [16].
- Fix dts warnings reported by kernel test robot. [17].
- Add Rob Herring RvB tags for dt-bindings patches.
- Remove ____cacheline_aligned macro. Use crypto_ahash/tfm_ctx_dma(),
  crypto_ahash_set_reqsize_dma() and crypto_dma_align() instead.

Changes V11 -> V12 [18]:

- Rebased over linux-next (20250624).
- Remove digest() method for hasher.
- Add ____cacheline_aligned for meson_hasher_req_ctx structure. Hardware requires
  that these buffers be located in different cache lines.

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
  - [14] https://lore.kernel.org/all/20240820145623.3500864-1-avromanov@salutedevices.com/
  - [15] https://lore.kernel.org/all/20241108102907.1788584-1-avromanov@salutedevices.com/
  - [16] https://lore.kernel.org/all/202411090235.a7vEgZQo-lkp@intel.com/
  - [17] https://lore.kernel.org/all/202411090619.fQTDHg7w-lkp@intel.com/
  - [18] https://lore.kernel.org/all/20241213140755.1298323-1-avromanov@salutedevices.com/#t

Alexey Romanov (22):
  crypto: amlogic - Don't hardcode IRQ count
  crypto: amlogic - Add platform data
  crypto: amlogic - Remove clock input
  crypto: amlogic - Add MMIO helpers
  crypto: amlogic - Move get_engine_number()
  crypto: amlogic - Drop status field from meson_flow
  crypto: amlogic - Move algs definition and cipher API to cipher.c
  crypto: amlogic - Cleanup defines
  crypto: amlogic - Process more than MAXDESCS descriptors
  crypto: amlogic - Avoid kzalloc in engine thread
  crypto: amlogic - Introduce hasher
  crypto: amlogic - Use fallback for 192-bit keys
  crypto: amlogic - Add support for G12-series
  crypto: amlogic - Add support for AXG-series
  crypto: amlogic - Add support for A1-series
  dt-bindings: crypto: amlogic,gxl-crypto: correct clk and interrupt
    lines
  dt-bindings: crypto: amlogic,gxl-crypto: support new SoC's
  arm64: dts: amlogic: gxl: correct crypto node definition
  arm64: dts: amlogic: a1: add crypto node
  arm64: dts: amlogic: s4: add crypto node
  arm64: dts: amlogic: g12: add crypto node
  arm64: dts: amlogic: axg: add crypto node

 .../bindings/crypto/amlogic,gxl-crypto.yaml   |  32 +-
 arch/arm64/boot/dts/amlogic/meson-a1.dtsi     |  14 +
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi    |   7 +
 .../boot/dts/amlogic/meson-g12-common.dtsi    |   7 +
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi    |   6 +-
 arch/arm64/boot/dts/amlogic/meson-s4.dtsi     |  13 +
 drivers/crypto/amlogic/Makefile               |   2 +-
 drivers/crypto/amlogic/amlogic-gxl-cipher.c   | 587 ++++++++++++------
 drivers/crypto/amlogic/amlogic-gxl-core.c     | 289 +++++----
 drivers/crypto/amlogic/amlogic-gxl-hasher.c   | 485 +++++++++++++++
 drivers/crypto/amlogic/amlogic-gxl.h          | 111 +++-
 11 files changed, 1191 insertions(+), 362 deletions(-)
 create mode 100644 drivers/crypto/amlogic/amlogic-gxl-hasher.c

-- 
2.34.1

