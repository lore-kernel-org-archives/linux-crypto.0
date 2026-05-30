Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270BB324B33
	for <linux-crypto@vger.kernel.org>; Sat, 30 May 2026 16:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780157231; cv=none; b=W7eO/0mV4vGtg7QCzq7+ctvHpyzcqc4koQQ2TyQuuJO0ROlJsNwXyL7DD6O5rDRwJ5wqVdx9kom2g38JUB+NZ2gwTGrZDp4i/RC54f8NdRLb8UhR7Snc5QgLTZz0wj7ageMA1ZWdKmiqlO2b3Zj6LZFiCejWLBJXB9y9xfhcSrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780157231; c=relaxed/simple;
	bh=x95keSA+x7HJlV22Sb0gnrcSAqr9debon9ffntCuf5w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sGKbU9Tg/59D6wr4JMZt17MWH38jHI0c3PchTtBXXczZDVbQgQu/Rfco0e23TH6OUEGyBGY8wDaJsKO6X95loCR/4xM0F9qQaGY1PPL+EzZvpWUnJnRtzyKKMAmoeQ4b9qW0YNNLRv0PsKkMtZ3CSM1d3v461yzjbYA8y1nB4TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dBqTV5GK; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dBqTV5GK"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-45ee5cdbd28so1720752f8f.1
        for <linux-crypto@vger.kernel.org>; Sat, 30 May 2026 09:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780157228; x=1780762028; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IwV4RZD2OlQ4qAGdKt6fe7VA4/9Ek4QzezWocwQhwBg=;
        b=dBqTV5GKCv6n6r/B2HTvRTIsdmDxf8YJOiSPVxh8H5bIAyhktfTx1A1dH2OO3f+2+t
         wFoAQxSMjqw/R6JiPrAYryHyHSXfHS07EDHAwpL/nW53AEhzLJtyQo5JDLitMErgJP/x
         b50hRioFlEAsV+Uy9aNlTV4l2y1Fuyql3/eUir3vRSUIS20ZA+q/M4ctCy+uEGjhEySD
         vc7NgsFuGnrryjGsH//NfHlfu1qI4ZVnGJqC5dh+iuNMVA6rUN836QoopyLaDcbO4x1d
         GBvr80ZtC+l4vmhTVg+W0JXDqMjk6BAdhhrcECMgRdOj/dCL448P/pkubIXUuhZkmUkS
         ONIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780157228; x=1780762028;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IwV4RZD2OlQ4qAGdKt6fe7VA4/9Ek4QzezWocwQhwBg=;
        b=YGl1pTVYC0ViNEs8uFfFYdaGtlBvvV3t+YLStPFt/ZufIGvGq60vAP+49n/4p060Rl
         swNgXDQSM1li9NFB4SQB7EfxpQwLdSbYEgU73wsj00JjhNf7/tmDKbyvhYpy17Yob7Jc
         u2MHxJLu7UUmzhQRbJx9V8mhupy/IkPlY99GGhBN5V4TBZ7QzgfDSMr1Hiflrqvvc2gY
         ojKoSQvpucHaK3Gn6pEviKCN4TC17b+GAxGTXVDXdtmulhzTY6GnMUVJbYYMWT0uEXK7
         BQS3mWJcOiKdX8ntvC/349Ka9fP4W8OpymxrZLzNLZIJ0IVcVscyNWk6sbpYTKFp/DWj
         /X+w==
X-Gm-Message-State: AOJu0YzodZeeQ7RGBqPQLPaLM61A7dH66uXQHWBes2FB90Tljwzi+BA/
	bRS437FgGgxKVMTM/pbmRzS62XXzRc2DL2dAUDzaATkj0S4CQbnJUu84
X-Gm-Gg: Acq92OHKYQ+e6TR35vzRdHDczar96HGSNH86QAcHAqULA09QKgCc3399AljAhid+onp
	Tb+8x/7LVHcSNcmRJ5DDgLw2xnUjWQjAadvsE8O9kZyBaJh2+uu/heHGusMfcg/q2oGVsMA+EiF
	hYsgsUF6eNwAdWlXxJKZEZXJGxbr3Vp1ZKZglpcLJlBJSM+RDlkolff4vXRSISaAptLTIsUsNvo
	5278mzZGUEUsyR1Ojp40UILFQGyQgOD3f5DJAI/7SZ8f1f7CvxHsaaWFW7hQMzQp30TAZ7LDmtS
	lp9/AHVenZqcaf4ktpTAZv9QFJxwHxzTfzyKs6KUyynGN2gAufgaDjn2pnz0yAPDqkgXsEtPyQM
	O6tofVuZbDEwjPRctxCvjeA3A0FC+fMExjHTSIS6KcPlqySiAoUmp11sPw7KwpFakiH6AD/n4Y0
	KE40VzZzeLeUfi7gV6J9xr2OB/aNU=
X-Received: by 2002:a05:6000:2213:b0:45e:f3b2:1228 with SMTP id ffacd0b85a97d-45ef3b21526mr9317645f8f.3.1780157228260;
        Sat, 30 May 2026 09:07:08 -0700 (PDT)
Received: from olympus.. ([2a0a:ef40:ea3:3f01:2e0:4cff:fe68:285])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef32fabcasm11667339f8f.0.2026.05.30.09.07.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2026 09:07:07 -0700 (PDT)
From: Dawid Olesinski <dawidro@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	heiko@sntech.de
Cc: linux-crypto@vger.kernel.org,
	linux-rockchip@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	clabbe@baylibre.com,
	robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	linux-kernel@vger.kernel.org,
	Dawid Olesinski <dawidro@gmail.com>
Subject: [PATCH 0/4] crypto: rockchip: Add RK356x/RK3588 cryptographic
Date: Sat, 30 May 2026 17:06:41 +0100
Message-ID: <20260530160704.3453555-1-dawidro@gmail.com>
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

Signed-off-by: Dawid Olesinski <dawidro@gmail.com>

Dawid Olesinski (4):
  dt-bindings: crypto: rockchip: Add RK356x/RK3588 crypto engine binding
  crypto: rockchip: Add RK356x/RK3588 cryptographic offloader driver
  arm64: dts: rockchip: Add crypto node to rk356x-base
  arm64: dts: rockchip: Add crypto node to rk3588-base

 .../crypto/rockchip,rk3588-crypto.yaml        |  69 ++
 arch/arm64/boot/dts/rockchip/rk356x-base.dtsi |  12 +
 arch/arm64/boot/dts/rockchip/rk3588-base.dtsi |  12 +
 drivers/crypto/Kconfig                        |  33 +
 drivers/crypto/Makefile                       |   1 +
 drivers/crypto/rockchip/Makefile              |   5 +
 drivers/crypto/rockchip/rk2_crypto.c          | 740 ++++++++++++++++++
 drivers/crypto/rockchip/rk2_crypto.h          | 243 ++++++
 drivers/crypto/rockchip/rk2_crypto_ahash.c    | 547 +++++++++++++
 drivers/crypto/rockchip/rk2_crypto_skcipher.c | 724 +++++++++++++++++
 10 files changed, 2386 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/rockchip,rk3588-crypto.yaml
 create mode 100644 drivers/crypto/rockchip/rk2_crypto.c
 create mode 100644 drivers/crypto/rockchip/rk2_crypto.h
 create mode 100644 drivers/crypto/rockchip/rk2_crypto_ahash.c
 create mode 100644 drivers/crypto/rockchip/rk2_crypto_skcipher.c

-- 
2.47.3

