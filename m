Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795780874;
	b=sRUtl2YFeGiaIVk/7W31GQg8p/BfdXRRFJHnxF0LDzmjifGFiP8BVsme0yJsGVfl922T
	 BPv0QWBqIBd93425PtAuG/IOmxVjnUB8bvS1szDrsNPUqn+oaGmugmpM/f3JeiO+iRxRk
	 YeSIoBA8PWI02PNbN8AnFV+f2D6Eok0pRR5fxmuImnWrS1WtlG0RAmAV+9g+lc4g4nmEx
	 LZr49ckpLydcDcsYAlI3feKkHxlFXk5RElg7T0JAzlBB3vt12FKdfsYl1nLiu+ELQeslb
	 XLMebXZPSbYnpzTTvAy6gPJafv8vRF/g3d033WbSNeGG5ieUAA1jmVDVBg5S/jwpWfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795780874;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=qdrFFlZr1wr6XK2UP+CUx9GD+axY9UPnNDp3yG1ITws=;
	b=fStXQXn9OmuTYhYcePSPT7Ac6M116QJFXcOyzBMnwCui7WoKf13/KMFPJIe5RWu/u9Qq
	 QkSoMzJIzPwbPJp1B0htzqxZbM6DkGkoko0sH1+XUFx1fLHaqrcxpSZ4VySGQhXGMNZOF
	 SldbI39p8LpClcuJJWFuoOxMcOy9i/6uFJiZ5uWq1AaA2FCuoCAsvYG74ptbzpGSm7aG2
	 FqFOk6/XgSjimh+Tw0DTl17fM940auDpf2t4m2b99Ff+b/dcCdMm9lDDeFPqQQUJ6ORi+
	 cycs453TNbiiVyO57cQD/fhsRjhZoYk56Zyu9qdKKkulrpF/S6/+quh3DquiRaGt6Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZrhBSsxA;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F545606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 12:01:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1F545606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZrhBSsxA
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4bb5b8ef642so69866105e9.1
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:01:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795780871; x=1796385671; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qdrFFlZr1wr6XK2UP+CUx9GD+axY9UPnNDp3yG1ITws=;
        b=ZrhBSsxA9TmxODqx2oG3o8BLWXL0DUBgbiWp0ohzIyWE3mVyt8801pQNfp0epUwm82
         wTJuYbitpgqsODU651dqu/97lnZ8c7zwCdp4XYm5IGprlzeeKhM90MIXeEpLAlp6VFUh
         IiK6HcPstuAqz0hXgy6mzMOHsSGKyuHEmZiUqz7hFvlCRUXxGQb/xJVXfKU2Qb6nUtL0
         CSCSR7ICkJQiFzJ8YMPWAlnLJLngsXDEEZGVKbiZG8ahIFPClPVIMXpao4fZ2dEul3gL
         MfqrdSgzSQGfBAMkb+zhEZEHKudU9bT2qT8P3pb3zErEbvY1GShjn88saaP9qHVD2rM7
         Rx4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795780871; x=1796385671;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qdrFFlZr1wr6XK2UP+CUx9GD+axY9UPnNDp3yG1ITws=;
        b=RUN6Ru876lKoaH3rsvPWOHusao7FH0w1/0HYsRQVy/8MPJYrAnyaN1CFt45rszqExH
         z4E3HNXLJhSBH+4TTpFuDzKao7mlHSkJC0/KAbtx5wFL9f/A4/vV072TAaRMT+JWnKoo
         eCm/V3bnkOVFaBjCWpv6LJEqhOa2UFckp5eq4f6mTk5xFu+byPyXeUGpWVNQPzyboQgo
         kNceJIx8eoAk4V0U4e5LKindM3EXkYzitafKF2PdMwipjh2nSrVjiW+kq97Yqf+AQSOl
         Wc2BJlsv1dwZDMFNUUFz/dT01Yc5GpPNqqBM3RVpbfCCN8aduGRX7clyLfGXFLPsdwCD
         Zmiw==
X-Gm-Message-State: APuU4Z9HoMBQ1H1UJ3IvX8k9m0TcSKjQdTi2sQLo7QMiEH5yTcjo0MRp
	c2pIb2WuHPbT3sYDEmWJ0Y2k20/rOc+bWI/Dfz0cd760dawojMRLHs8R
X-Gm-Gg: AZFdTZeB+iHDoxBDd4yJgxZyf+HN8S6us+ijTL/sZ1xVyr0UMT11qMKr8goArywvgtL
	QmgfsBfAm0f+MwijYGsAZrW84VitZpcT57N3wRt4yYKtlw1xDaqTGfIYytteE5JucfWFb4Z9bHb
	AEMwd6Q9O1kZS6Kn8HAmlHMaJKQtCR0K0Cgo0yCr7Nnw+PwhVWsPDIC0utMlwXmyfsW+3v+NLzx
	Zm3majINAiONOLiiPE+mgo/EDwVHCxKN139HqsVCS4wNOMsJnl+kMa4EY4SX8QksUvMiKm5T2Ab
	298G2sxZ5yUnwJz24wZi6Rr46WS7zDwzyNTkn60pf7p6lWE3NZjbStbN5t/op2kWHfrWMXYNMay
	sfK6WXkukX/V63h/7E/dMNGlLR2e5HWHGTYx1bs8nU9e4ppRQDMGFs+bo/teuMk8mTth010G57B
	oNTtC1giObSoZV3nwicS1c4hfokMfwwF7yNwdQ7mK+uUzCKwEyX/YAicCjNnluDvteEtNn4gsaK
	y8lIZvp9HmgnH3EL7N1CPmYXiLy0bOHzBJp10W0jlJNagRJJ+6+vBpZI/v8FWMZ0l4V5LMmB5Mb
	CTdpeNEF9tSwC5Rl9u9tKdJ0cdCUeZtEWK4AJz8rMyKpCDw2
X-Received: by 2002:a05:600c:3e1a:b0:4bb:6814:7391 with SMTP id 5b1f17b1804b1-4bb8881921cmr485415525e9.25.1795780871097;
        Fri, 27 Nov 2026 04:01:11 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906640a2sm393684565e9.0.2026.11.27.04.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 04:01:10 -0800 (PST)
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
Subject: [PATCH v14 00/30] crypto: amlogic: add support for G12/AXG/A1/S4 and misc fixes
Date: Fri, 27 Nov 2026 13:00:33 +0100
Message-ID: <20261127120103.1532882-1-jnieto.alaber@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
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

This is v14 of the Amlogic crypto driver series originally posted by
Alexey Romanov.  It rebases the series onto linux-next (next-20261123) and
adds, on top of the original patches, the fixes required for the current
tree and a few corrections raised during review.

The original 22 patches by Alexey Romanov are kept untouched (authorship
and Signed-off-by preserved).  On top of them:

  - the fixes that landed in the driver since v12 are preserved (IRQ
    handler return value and fallthrough, devm clock management, DMA SG
    unmap on the cipher error path, probe cleanup, devm_kmalloc_obj
    conversion);
  - three patches add what is needed for the current code (drop
    CRYPTO_ALG_ALLOCATES_MEMORY so dm-crypt can select the hardware engine,
    the ahash ->digest one-shot path, and a small cleanup);
  - five patches fix issues found in review: probe/registration error
    paths, key/IV and SHA setup descriptor lengths (plus a duplicated CBC
    IV copy), the redundant A1 platform data, the A1/S4 crypto clock, and
    the binding property order.

Testing on Khadas VIM3 (A311D / G12B), booted with a linux-next kernel
built from this series:
  - the crypto self-tests (known-answer tests) pass for ecb/cbc(aes) and
    sha1/224/256;
  - dm-crypt with aes-cbc-plain runs on top of cbc-aes-gxl and the
    driver's request counter accounts for the I/O.

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

Jose Nieto (8):
  crypto: amlogic: g12: drop CRYPTO_ALG_ALLOCATES_MEMORY
  crypto: amlogic: hasher: add one-shot digest path
  crypto: amlogic: drop unused field and stale includes
  dt-bindings: crypto: amlogic,gxl-crypto: keep standard property order
  crypto: amlogic: fix probe and algorithm registration error paths
  crypto: amlogic: fix setup descriptor lengths and CBC IV copy
  crypto: amlogic: drop redundant A1 platform data
  arm64: dts: amlogic: use the system clock for A1/S4 crypto

 .../bindings/crypto/amlogic,gxl-crypto.yaml   |  38 +-
 arch/arm64/boot/dts/amlogic/meson-a1.dtsi     |   8 +
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi    |   7 +
 .../boot/dts/amlogic/meson-g12-common.dtsi    |   7 +
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi    |   6 +-
 arch/arm64/boot/dts/amlogic/meson-s4.dtsi     |   7 +
 drivers/crypto/amlogic/Makefile               |   2 +-
 drivers/crypto/amlogic/amlogic-gxl-cipher.c   | 596 ++++++++++++------
 drivers/crypto/amlogic/amlogic-gxl-core.c     | 279 ++++----
 drivers/crypto/amlogic/amlogic-gxl-hasher.c   | 511 +++++++++++++++
 drivers/crypto/amlogic/amlogic-gxl.h          | 120 +++-
 11 files changed, 1201 insertions(+), 380 deletions(-)
 create mode 100644 drivers/crypto/amlogic/amlogic-gxl-hasher.c


base-commit: 3191063649dbf7c0d0b768e1f3655e4c5fc6edb5
-- 
2.47.3

