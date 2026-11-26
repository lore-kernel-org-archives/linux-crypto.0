Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795721580;
	b=U4842spcE+IN/0C4NeAAM53DHQSvZMqSN+e3uaMUfB6Uu+PNLThsKC+JNnLIYa/RuhGU
	 fXbjFzDXGRoFdJ5feuhJKqGhjgw6irplDooLYUKDoN/8kNDi0kcxBlkfndif1wtPyuAkS
	 leFZa6QyQ3ZxoI+U9ByhEXi9TfKe1gb4KuFVogrhtSz9Gib0m/Wku2Rw0VuvP2A9AQpJ0
	 p+HllNJBAk9gVaNd4F6iSdeyyUdc1+ee1zqRddH71iEb9QGK+phcoosoh7GMol0CugsiI
	 Qj8QL1IOX6xy+x9EKC8CzuaDWAnCzEWTlnUpyqZtxH7ZZll/muykWB5q9YA67SMm/Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795721580;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=OuaUxwS6JtTJWMd+hXXNq/iTmPJxIas+/RtLlIzqUXM=;
	b=3zHXi+L1vUjsPxffbMbimZB/o9sO7TYtyVdWkQCGnTxHNO4zRgVDWD+cOfMS1GG26Zk6
	 jd7ZN/ZPsojwCwLoeSEwnHac8QTJNexa+8sen/vVMe06mMvUKTgzv+SqKMc4FZcuy5/hO
	 3IwlsEq6L3kNWk3UxAA3qgB1adEPZXD+hSFpTVWPt8GA3I9QX9CflAjv0LSn9xb/HvR9k
	 8ITJNWgLtfRE7uxtCs0pE8Xz2IJiN9E3CpGQAEFMv+gSaoleV3rBNFHiR7glIyPdfn7IV
	 TiwdTM6zdJOdJCmQ/cr2SUwbD8J30TIhkEWgMyKE7+Ve8SJ/6l2ixtu9iLdDzK4E69g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BHAw41k1;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC79606A31E
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 19:33:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3FC79606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BHAw41k1
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4bb6ba3b244so75633365e9.3
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 11:33:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795721578; x=1796326378; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OuaUxwS6JtTJWMd+hXXNq/iTmPJxIas+/RtLlIzqUXM=;
        b=BHAw41k1O5L/8d1yA4euhH7KmKjak06vXEdW1+yNf8OaJW2NTGuviUxpzbpkqseAmC
         1MM9Lt2VLfKa4FhI5X0Ba4nsRTvcjsHp/pPO8zoVTzpfk/EJ0plxaEaCQrECkDR+F4+V
         Vm/cekink0updJA5rRWMkDC07iLiMDwagbhijxuzCZ4gAcF6xGD2AGltl+id5Mh/RbQV
         QV2kjXgbjIZ2upC0e+gdDgK5jaAEBIrfGwu0crmZucAs2rmubtJ62clU4J2XzodGjNGJ
         zUpodQeHb6R8BP3PuJ8jgcZEUUVdju9ijzzUS8cAJBn8i3sGNTDk8eyit66OT2bwj0Z9
         3ZOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795721578; x=1796326378;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OuaUxwS6JtTJWMd+hXXNq/iTmPJxIas+/RtLlIzqUXM=;
        b=DpMsPI5zablIlN2WwbTut7G9EfXHlbSaZJX8cZlWzg/jdpHqRquNp1J9GIoaTFVcKf
         r2fGqUnjqoBbz6bjY5YmsgijGe2SKqP3KgIbIjH5u2jpmlAPi5+sPWkrqm4c/aERJvK9
         iYG9IbTColFULQQ3dAYHfAYUQN9F0iEY7PgMjmesSXrfoosFcEmSfELCk3nXQX1H6EVH
         Ji+3sFBhqpfd1aRJ1JmBlGbhJ7JFPhiMU5CSzyNe5ejPZDHwWLS3hyFeS/G9Itu6WfUq
         ADER5y83sm1vRIb0ruM6usQIFHfiqxbgRsoorNOv180t0ltM+Bn0Er4iO/ENekq4SC9h
         J30A==
X-Gm-Message-State: APuU4Z+i9ov8xLpJvokLTiWetyoL9vHj/l07WDwtCRFc4kAu2GXWyYO+
	yJNaTugjyUw+S0iIa7cZYl6y6M92U+gfQ53QHdGrXEzl4+B5B2E1TMX3
X-Gm-Gg: AZFdTZef1dcvNp+7rgZ//eIshQiyJwXUxhMCvcaUbqbUtmbypFaj7zSoz6ra2QRc0ft
	TmxMSDUFEaRS1Iib+RfykHPoerunSbGmABdJQut9jsKSmLkLuGJ+CSV4OLlrEmsCuYMY8uKWdKE
	4sMMI/3qhZkFP1P8UrdaM2eeadGNV8voKMz9QREpBMi7TPDrWzxJypM2OtbEkqqspsfUj/HCAcZ
	jzibaObDHS6RXSbrEkeQvMbfOnwgbHPQWcvJ51CxTeqVcgNS3m0xoQJejOzD+LrZW4Fs9E5/K6t
	+POQPCGkhYDMXcYLz1yUoiMRB7dNyAoxv8atk5/XSZVb7KtFosyvDW5bRBLMtDjoJk+Y22kFC2C
	OHSl3R5U6FKebnDcpFzvMqv91VbsEvnV2QFxDdXYmcO1fYd8NbA4ubsqmVvCY2f7+QJxVBXt9Rg
	GuU/rdBmMg5rquwlFfuXXr4HebLyuQx0ehMulwKMiOJivDo+MWRSkHdoVg8eF8v+pCKCxNVyxk2
	/RxRhAt1SqAToBSAmvuhGfWah0VNo8hIR4aWbKDH3Ya1S7MEM5fK+4v3HyZZ5K+pU4/6bVUd2KL
	i2HYFtV3j8m1bY+KSfQLPh65u95TWedet1g4PateOCvxmw==
X-Received: by 2002:a05:600c:a0d:b0:4a1:825a:56fd with SMTP id 5b1f17b1804b1-4bb88826c1fmr424233425e9.32.1795721578321;
        Thu, 26 Nov 2026 11:32:58 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm368287675e9.2.2026.11.26.11.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 11:32:56 -0800 (PST)
From: Jose Nieto <jnieto.alaber@gmail.com>
To: Corentin Labbe <clabbe@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	devicetree@vger.kernel.org,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jose Nieto <jnieto.alaber@gmail.com>
Subject: [PATCH v13 00/25] crypto: amlogic: add support for G12/AXG/A1/S4 and misc fixes
Date: Thu, 26 Nov 2026 20:32:16 +0100
Message-ID: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is v13 of the Amlogic crypto driver series originally posted by
Alexey Romanov.  It rebases the series onto linux-next (next-20261123) and
adds the fixes required for the current tree.

The series keeps Alexey's original implementation and commit split:
platform data, IRQ handling, MMIO helpers, multi-descriptor processing,
G12/AXG/A1 support, hasher, and the per-SoC DT bindings/DTS.  While
rebasing, the fixes that landed in the driver since v12 are preserved
(IRQ handler return value and fallthrough, devm clock management, DMA SG
unmap on the cipher error path, probe cleanup and devm_kmalloc_obj
conversion).

On top of the rebased series, three patches add what is needed for the
current code:

  - drop CRYPTO_ALG_ALLOCATES_MEMORY so dm-crypt can select the hardware
    engine instead of silently falling back to software;
  - add the ahash ->digest one-shot path and fix trailing-block handling
    for digest requests;
  - minor cleanup (unused fields/includes, stale kernel-doc).

Testing on Khadas VIM3 (A311D / G12B), booted with a linux-next kernel
built from this series:
  - the crypto self-tests (known-answer tests) pass for ecb/cbc(aes) and
    sha1/224/256;
  - dm-crypt with aes-cbc-plain runs on top of cbc-aes-gxl and the driver's
    request counter accounts for the I/O.

Attribution is preserved: the original 22 patches keep Alexey Romanov as
author and carry his Signed-off-by; the three additional patches are
authored by me.

Thanks,
Jose

Alexey Romanov (22):
  dt-bindings: crypto: amlogic,gxl-crypto: correct clk and interrupt
    lines
  dt-bindings: crypto: amlogic,gxl-crypto: support new SoC's
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
  arm64: dts: amlogic: gxl: correct crypto node definition
  arm64: dts: amlogic: a1: add crypto node
  arm64: dts: amlogic: s4: add crypto node
  arm64: dts: amlogic: g12: add crypto node
  arm64: dts: amlogic: axg: add crypto node

Jose Nieto (3):
  crypto: amlogic: g12: drop CRYPTO_ALG_ALLOCATES_MEMORY
  crypto: amlogic: hasher: add one-shot digest path
  crypto: amlogic: drop unused field and stale includes

 .../bindings/crypto/amlogic,gxl-crypto.yaml   |  32 +-
 arch/arm64/boot/dts/amlogic/meson-a1.dtsi     |  14 +
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi    |   7 +
 .../boot/dts/amlogic/meson-g12-common.dtsi    |   7 +
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi    |   6 +-
 arch/arm64/boot/dts/amlogic/meson-s4.dtsi     |  13 +
 drivers/crypto/amlogic/Makefile               |   2 +-
 drivers/crypto/amlogic/amlogic-gxl-cipher.c   | 605 ++++++++++++------
 drivers/crypto/amlogic/amlogic-gxl-core.c     | 281 ++++----
 drivers/crypto/amlogic/amlogic-gxl-hasher.c   | 510 +++++++++++++++
 drivers/crypto/amlogic/amlogic-gxl.h          | 120 +++-
 11 files changed, 1219 insertions(+), 378 deletions(-)
 create mode 100644 drivers/crypto/amlogic/amlogic-gxl-hasher.c


base-commit: 3191063649dbf7c0d0b768e1f3655e4c5fc6edb5
-- 
2.47.3

