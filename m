Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795508427;
	b=mO1Amdvx6Rzv90iRAXvm9ZI5hVPP1YXRt+jT1A6w+wXyVn+JO8x8zZscNRPEtmrbt5R4
	 9iMSiWLaC7Cg49mnTvUI7Wl/vfn51BPYnWTpC8urIefP/UGgMcTmKqZM9d7/i+Xk9QryX
	 qBEkmkn/62lBkgxyNWjaHBdHF6UJ6zpcC/AmbWZjFxYvWXDKtDIJyhVFzTL9jVs4Ky2zp
	 f9TI3UqtiUMj4OIcJSbY33XRNiT6uomwAQUMTcCJUIJ9+l9YQNnAP9a13VCka0GE0G72q
	 m2dB9jRZuGLMLRgU0cjhAT7CIUbQ/J0GTIGjyOU0rG5xFkdmJAdXCQNjZwRmn35sPHA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795508427;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=vHAwwH0nrw1kWkp/3uuQPolxLVo5Vn3FF3b+N7bJNoo=;
	b=chcFvWnxVNkowBYdGN5zmKBcuIVn0441WeA7u2Q0bx1y5Z2qMQTplaIfE/P+hzlj011X
	 TJXu4rNtiRbxHGEqAbLf7FUlFq2aJltdRSrv6ksJ+8Dw5eXhVedVjtNxp+csqo1bWzTIG
	 NfYVsUgTC7FYBVmp9tKgpZhh3qz4FfHNobuwV4+IqNu2XxISXG6B1SaWHiXLS93oKnx1v
	 NqFmSeBI3KiP0PBBWzEQlKbKPVapK1gh5lffA5k/ODigVBofj1ReUUv5cfmPYiJ9D/Tsm
	 zS5a84I7WvFv5xH2/adbVUjQCr+9PQAYUJ28vcXce4siL9Kj1VEzA2WeN6nQ1xQ6kdw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oem4yEc1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3642606A31E;
	Tue, 24 Nov 2026 08:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oem4yEc1
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795508427;
	b=nYuT1h+wPIovyujRPxP3EWJ/4IDwiRWTCh6dJvnp6hQ+OICyCyqHN1O9jzhjczd5hORN
	 9Ghda3m5TBeA4gD3yPFB1jSXe4oeJLLZ3yvNuzZHiqKExvNCz4ZkM1rHH/L+ZvMkRdxIO
	 BvlFus+/1xdXIFST9y+122TMruFbDSqUv3lq/WVnRe8AW747nInTysdnYCxpOq38D6Ma/
	 olhnUDDEj4EmBJOWMwZIZNxmAb7OWfzSFlIWzuUCY+590wh6aqon1jqtQtaS2G8bzmzdO
	 Va7k+jtz4rq6jgD+jAPeN2vLTICWRzoKFVR4tgAYqHcNEx2nueOnaTNgq8z6mqOL8FQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795508427;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=vHAwwH0nrw1kWkp/3uuQPolxLVo5Vn3FF3b+N7bJNoo=;
	b=hQIJ9tUXsRDME+jZFnHbhbw+oFLkfRB/2IgWzb9TJH3zCB1O8EA5lBbCgIaNE0Ysw1rT
	 GId3fTql8C8aNQwRru6bIrOfr3mrCp4B0fapr1l8lukLdOczUYopc2WLFEx43AMokuLwM
	 qNstODrF8jkscIh1s5U4q7Sy+VkdmyZmcmSr04yNOC+LeUQWMiJmZvEWr8FPda5HJds7d
	 3iqxq+0gwzDKVXZt92LXemKqTULGHWrFN16TWz6W9UJvJpQkEZHgUgrKNNo8QmKgdESOa
	 w7bea+zXuES6to+ArWgNNGWMiUSZ8VeNvR+12MGQKvgz3sUH+swb1akrJvbHY8CUWqA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 6A0641F000CA;
	Tue, 24 Nov 2026 08:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795508426;
	bh=vHAwwH0nrw1kWkp/3uuQPolxLVo5Vn3FF3b+N7bJNoo=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=oem4yEc17cD03osCxkd03IdOaJl52/AFXRqwpi8QHEFGSrHFHuObc5ExsFnGREACS
	 c3Hbif08Jhnke8u7NOa6Jo+cBvZlG/zMPzWFT0dUUMlYW9e84AicGee01Eg5ijUpRC
	 njygloo0XXOD8g367mWyubwA85UjlSfZ3/+QoY/+fW5f8wmjqifx9SpkzpH06LiVTh
	 mCeFzY77J+hfDj9rA055xTQop/rWwizziBvPB938jCudid9dCINkki8ick5z2WjvQ2
	 x0FxnyyHB1t5bm9xJFWEE6tWGP/VXEs1qbUIZeHWNYHOFl14IlBwZiE/lnGvuDrA7K
	 DiJz3li5z99Vg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id C27F44C936;
	Tue, 24 Nov 2026 08:20:20 +0000 (UTC)
From: Fil Dunsky via B4 Relay <devnull+filipp.dunsky.gmail.com@kernel.org>
Subject: [PATCH v2 0/3] hwrng: Add Cortina Systems CS7542 random number
 generator
Date: Tue, 24 Nov 2026 11:20:18 +0300
Message-Id: <20261124-b4-cs7542-trng-v2-0-0192937b44be@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3WNQQ6CQAxFr0K6toYW0Iwr72FYwNCBGmHMDBIN4
 e4Crl2+5P33Z4gSVCJckhmCTBrVDyvwIQHbVUMrqM3KwCmfiDjDOkcbz0XOOIahRaqoNo5skxm
 GdfQM4vS9B2/lj+Orvosdt8pmdBpHHz7740Sb9zc+EaZouDHOWZEio2vbV/o4Wt9DuSzLF42tz
 Ue+AAAA
X-Change-ID: 20261123-b4-cs7542-trng-1a1b9f1cd392
To: Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>
Cc: =?utf-8?q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>, 
 linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795508418; l=3072;
 i=filipp.dunsky@gmail.com; s=20260930; h=from:subject:message-id;
 bh=cxbkSaTDthKEwcdkWgVbloUCaiiY0AcMv8pFTjp9QIY=;
 b=53TlVVtccxEE5Rny7rrzitIWySScAbfYdvVN7aGSCRuTe/5xfYgQIYtLG3Y1kv4pLedC+Kun+
 xn2+1/utxFuCpHLs4nFGqyItpLVt+eLQie7bqurJ7vgqJXOInDPxtSY
X-Developer-Key: i=filipp.dunsky@gmail.com; a=ed25519;
 pk=JAYP8e2rJ54DHOmhNtXud8rl1igAaAXoOHxtJmVXI1g=
X-Endpoint-Received: by B4 Relay for filipp.dunsky@gmail.com/20260930 with
 auth_id=1085
X-Original-From: Fil Dunsky <filipp.dunsky@gmail.com>
Reply-To: filipp.dunsky@gmail.com

Add the Elliptic random number generator integrated in the CS7542,
based on the GPL vendor and OpenWrt implementations. Use a syscon
regmap for its shared global scratch bit and provide bounded polling,
nonblocking pending requests and partial output through the hwrng core.

Hardware ring reseeding is limited to the documented CS7542 A1 path.
The vendor driver avoids it on A0 for erratum 28891 and substitutes a
RTC/timer-derived nonce. Reject unsupported revisions using the global
syscon identification register instead of adopting that workaround.
The saved Almond+ capture identifies the tested board as CS7542 A1.

The binding, driver and MAINTAINERS entry apply to Linux v7.4-rc4
without the pending CS75xx platform or clock/pinctrl series.

The existing OpenWrt entropy quality setting of 512 is retained for
review. The output smoke tests do not establish an entropy estimate.

The v1 sources passed binding/example checks, ARM built-in and module
builds and RAM hardware smoke tests on Almond+. The hardware test
returned EAGAIN for the first nonblocking read, then provided 4096
bytes without all-zero or repeated-block output.

No additional hardware run is claimed for v2. The generating path on
A1 is unchanged; revision checks and their error paths were tested
with the actual C code and mocked resource/regmap/hwrng interfaces.
Full ARM W=1 built-in and module builds were repeated for v2.

---
Changes in v2:
- Drop the redundant linux/mod_devicetable.h include as suggested by
  Uwe Kleine-König. The existing linux/of.h provides the OF device ID.
- Restrict hardware reseeding to CS7542 A1 after inspecting the vendor
  erratum 28891 workaround. Propagate revision-read failures and reject
  unsupported silicon before registering the hwrng.
- Describe the hardware revision restriction and identification register
  in the binding.
- Link to v1: https://lore.kernel.org/all/20261123-b4-cs7542-trng-v1-0-92d9ffcee531@gmail.com/

To: Fil Dunsky <filipp.dunsky@gmail.com>
To: Olivia Mackall <olivia@selenic.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
To: Rob Herring <robh@kernel.org>
To: Krzysztof Kozlowski <krzk+dt@kernel.org>
To: Conor Dooley <conor+dt@kernel.org>
Cc: linux-crypto@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

---
Fil Dunsky (3):
      dt-bindings: rng: Add Cortina Systems CS7542 TRNG
      hwrng: Add Cortina Systems CS7542 TRNG driver
      MAINTAINERS: Add Cortina Systems CS7542 TRNG support

 .../bindings/rng/cortina,cs7542-trng.yaml          |  43 +++++
 MAINTAINERS                                        |   7 +
 drivers/char/hw_random/Kconfig                     |  11 ++
 drivers/char/hw_random/Makefile                    |   1 +
 drivers/char/hw_random/cs75xx-trng.c               | 187 +++++++++++++++++++++
 5 files changed, 249 insertions(+)
---
base-commit: b6a9fa34ce4187cb69d3c588a4bbffc31ce5db8f
change-id: 20261123-b4-cs7542-trng-1a1b9f1cd392

Best regards,
--  
Fil Dunsky <filipp.dunsky@gmail.com>


