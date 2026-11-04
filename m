Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793779281;
	b=lvwUZCaR75Vu6ltDx941mz4wB6bFE+ZIHlp2TlqX5RH7OwtRG0rFtP6nrNThsDSyRjeB
	 tABsP1PK2wjld2qJIJQXnMDYQb/TzQDEw7tTCHSVtgD91jrtvf4LWlZqiHKnWzeyDFoUh
	 jM5E2leR5VICAmWJ7+i2Kcwe1LuavT+9GAZK3eXfsd88pm/QfRCgsMueg3ep87JkaA1k/
	 9l++/YB7EU2GlMfXrTMLtV+X66wYnb6BvTUse6eHHrTCsJ8iUXaodF2V3E8WdYiF2dkLQ
	 Ci9l8P2eyVBuk0j886WLayxklAp2owqvKpdep9k6Xxy/nxjIZscpk0LHWpYwZlFEG3A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793779281;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=CFW4UEZq8C8dcoEJ8gp9Mlet5nVWqNMu2HwlLBIoyp4=;
	b=bwNhj5F6agJNMS+5MLzgOeJDEwqypBRaZY39wXaLbP31PVGiNr2xOmkwy7PnJV/FzR3h
	 pJFX5VnUFTh6ThDGjfhoa2TTe8kRpgRZvcikpRJdFY9dmNMIs1m7eYBa3wy4PhxputOSY
	 Xtwsydk6oNI9i3iTckJfSLqtrZEkWhCScQFEwbacYz8LW1kJOG7acXtjGiiYGNtDlvnFw
	 TgALRoI7rt7mpCwzmNmIPddY4h/tFjRFVSwe6pJ9zyJNs2HC1h3iwukzyYOGYKr7R73Yr
	 ICy1BNsAOQpMasearkcdpspOb2+DeOxpuVYa1C71KSnM+a+s/Zx5ZGII2i2sYsu6ARg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EhEhcDnN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18ED606A326;
	Wed,  4 Nov 2026 08:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EhEhcDnN
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793779280;
	b=fuSzYbSvkZGQYRUauovwyvPidlxA/6oPf647Reabthak+xyajrXTTJSCq/JdeBEzsgGm
	 1spQO3TfsfqAVwNK+hM2XU4lk28cb1ETFlpzLFjR5HSsRndFnztIJ6vxq2p+Cvcji77WQ
	 YugPW/ycNrZlYKuaRdYiR5XonjErxBPowFLRs5Le4odSPkHjHwKqTgqW+KkIvY9f/E+Zc
	 YofOFuShlLEiYcVlBmYjRGvtfkRUZL7xF/QPkaqxAMPgCQoqb3a4EteeLPH33YBcFQyOG
	 XGev2po4IRG0EsLvCu4MzHpqSfQ4JvcSNnU+m6KFNXfRfYhwY1uW88+ZyS+dnHHEHtg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793779280;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=CFW4UEZq8C8dcoEJ8gp9Mlet5nVWqNMu2HwlLBIoyp4=;
	b=Vs4f8bQzrpl0EC0+XiC3yCzZSLNFkgDV9Ngd4xfIY5jk690b9FkoRO2gvplMjGDb22mi
	 up9ZEEmYpT3QaSwQ/9MwT7rJPVClH+XWB/4zKtzB1caVeTttLsx4ykCL7l6CT5JpZ5qSp
	 B3OxYFF0dZsD8xdbZJ9cul30hXniH20j8Pa9zQqacfMWe53ez1Ht6mCz8zhCi60yhFUlo
	 afwo+/SFikz/mVqwKxZO1DHx68qwcn2lMnN0IWXdcyHgVFHJPEAVsYWwKNQ4wDLgNMnLQ
	 lpTAN9NR0EP5Ir2gBPG855UKuH7FNpnzxPype5K//xubUwBy72uuXHXoo0A+aawAdlQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BF57A1F0093A;
	Wed,  4 Nov 2026 08:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793779280;
	bh=CFW4UEZq8C8dcoEJ8gp9Mlet5nVWqNMu2HwlLBIoyp4=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=EhEhcDnN4zY9yHfi6PKLHdp8REmFYKAY0S3lRcFETDOIVvk9w5eWEngOpkmM0YVib
	 DgCS2slqdzK2ZTqnK7qX3SDvA0xVFXilNZDdHT3Usk4S9yLoplbzqILDQf/MCW3vVo
	 b/Hot6Vi7dB8XbvYAjf/mJzVADlr3OZnLef3xlYCKseKAoS94X/iGtLy/EMUjmyGWR
	 wa3BbBw8E2qj3lWGgKvwNyGMKlpIJbBTNesjvwZ8Kp207qahSo4p0HjRUIWjUpNqRo
	 3ZwPxMdA0F+AiHVxx9ntiZgvyNQ3itGF6SVsbT+7gQgrAvWSua6VvRZfEpm6SCscmS
	 Y3OXCL55oWNXw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 1C5A946D45;
	Wed,  4 Nov 2026 08:01:19 +0000 (UTC)
From: Andrew Gigena via B4 Relay <devnull+mail.andrewgigena.dev@kernel.org>
Subject: [PATCH 0/2] arm64: dts: qcom: sm8150: Add standalone ICE node for
 UFS
Date: Wed, 04 Nov 2026 08:00:35 +0000
Message-Id: <20261104-sm8150-ice-rfc-v1-0-5737b6c2ecc0@andrewgigena.dev>
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
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMTQqDQAxA4atI1gYyoxbxKuKik0ZNwR8mWgTx7
 h3b5bd47wSTqGLQZCdE+ajpMie4PAMen/MgqK9k8OQfzlGJNtWuIlQWjD0jhTJ4pqKSmiBFa5R
 ej9+w7f62PbyFt/sC1/UFAWPPRHIAAAA=
X-Change-ID: 20261104-sm8150-ice-rfc-0b4b2c035e80
To: Abel Vesa <abelvesa@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Andrew Gigena <mail@andrewgigena.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793779278; l=2116;
 i=mail@andrewgigena.dev; s=20261104; h=from:subject:message-id;
 bh=CG4hBCZDt6NMDb6T/GIIXkxNx2nWNouLk8UK8MwH370=;
 b=8JRR2i0YPt0NbVNbojLUBVDdePC4/V5tgYtK9H/b/gTU6h9PLJFsf69/uXGhsHfkxBT5GGrhc
 fsiviVuRAKnD8B43S4aqE6KQ7f5KX1z7Xh8IoETU8zxmeJ87Eb2Ub+c
X-Developer-Key: i=mail@andrewgigena.dev; a=ed25519;
 pk=OMhlYIBaOEC8g4mJ4JCKy7kbg+lrwRxuujieZF8Ne6U=
X-Endpoint-Received: by B4 Relay for mail@andrewgigena.dev/20261104 with
 auth_id=1402
X-Original-From: Andrew Gigena <mail@andrewgigena.dev>
Reply-To: mail@andrewgigena.dev

Hi everyone,

This small series brings the Qualcomm Inline Crypto Engine (ICE) to the
SM8150 (Snapdragon 855) platform, following the same standalone-node style
already used on SM8250 and newer SoCs.

The first patch documents the new compatible in the binding, and the second
converts the UFS node to reference a dedicated ICE node instead of embedding
the registers directly.

I've tested this on a Google Pixel 4 (google-flame) and everything works:
/sys/block/sda/queue/crypto now advertises AES-256-XTS and ext4 reports
encryption as "supported". The ICE self-test completes cleanly during boot.

Happy to adjust anything or add more details if needed. Thanks for reviewing!

Andrew Gigena (2):

dt-bindings: crypto: ice: Document sm8150 inline crypto engine
arm64: dts: qcom: sm8150: Use standalone ICE node for UFS
---
 .../devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml |  1 +
 arch/arm64/boot/dts/qcom/sm8150.dtsi                         | 21 ++++++++++++---------
 2 files changed, 13 insertions(+), 9 deletions(-)

To: Abel Vesa <abelvesa@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
To: "David S. Miller" <davem@davemloft.net>
To: Rob Herring <robh@kernel.org>
To: Krzysztof Kozlowski <krzk+dt@kernel.org>
To: Conor Dooley <conor+dt@kernel.org>
To: Bjorn Andersson <andersson@kernel.org>
To: Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Andrew Gigena <mail@andrewgigena.dev>

---
Andrew Gigena (2):
      dt-bindings: crypto: ice: Document sm8150 inline crypto engine
      arm64: dts: qcom: sm8150: Use standalone ICE node for UFS

 .../bindings/crypto/qcom,inline-crypto-engine.yaml |  1 +
 arch/arm64/boot/dts/qcom/sm8150.dtsi               | 25 ++++++++++++++--------
 2 files changed, 17 insertions(+), 9 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261104-sm8150-ice-rfc-0b4b2c035e80

Best regards,
--  
Andrew Gigena <mail@andrewgigena.dev>


