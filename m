Received: from mail-24417.protonmail.ch (mail-24417.protonmail.ch [109.224.244.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4098326B75B;
	Mon,  6 Apr 2026 02:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775441407; cv=none; b=mQDm8EV4yZ+qYn7VPXfECc8JGAYNk1vpH8Ilf04ODY4tiaj4wwWFVOQR7xqjSr9YNWmfpqfVKbBbiWJq6K20/0vUDQyqJ8GnzmkVv2cxTL5vjjjaviLakT5cLiPOvFBLvq5HUtIdFnnU2OjxP+1L7v9pBGmkKBW3iPTOZyHg8eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775441407; c=relaxed/simple;
	bh=c9VHzmVSX3AObCFh92puFfvEMEn1CtIOC2zRnHZfUF8=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=pV2Wl4vD5nPOp5TSXldkwlnqDvTBKoQhcWNJbdWLLzCPUxsOLRiNS/H9M0qlJ566VtA07quihE+2rcyqiaXvXezye+ILjL3mb50AQMlMvG2iW4qqUGXdhfRMlCOb03j2i7SGvTEmy3OzpmxvpTBEROX+2ThSTsJaIlfY3Mx+4lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me; spf=pass smtp.mailfrom=pm.me; dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b=dz/01M8E; arc=none smtp.client-ip=109.224.244.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pm.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pm.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b="dz/01M8E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1775441403; x=1775700603;
	bh=B1Jv8NDBwJ7tq4D1+SxXstNTEVauQf7DZfeiRjDzIQc=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=dz/01M8Et8V+ht4mjt6zni1DRFNPLWuNvgG9JxQjGduLBf4/X9EvNygQDs2pclUz4
	 b7Fcf7pW6YijLaiq9Wi77FzStWWAmP0ZDTyiM9qHfKkiaIwo+ShXWOIthiJieiPjOd
	 KgJ3zTbGTcDM401M6pWSBWCDI/l/BRrvi1W5wr0LFq3IElXJ4eZ4546GNIx1LohQBA
	 ExhluPuIAE4Q0UHHq7+OcgJFDKyKyGbrjGsYoo33Au72mF8gLEtGgipG17H2Q3X8J4
	 Hk2FCDlT2ogMbogKug7VdfR/nko3ZUKaw3nmqxTJNKDhF4xkt2mHAN0Exob8YF7jUo
	 5yIzkthMWc4nQ==
Date: Mon, 06 Apr 2026 02:09:59 +0000
To: Thara Gopinath <thara.gopinath@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>
From: Alexander Koskovich <akoskovich@pm.me>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, Alexander Koskovich <akoskovich@pm.me>
Subject: [PATCH 0/2] arm64: dts: qcom: milos: Add QCrypto support
Message-ID: <20260405-milos-qce-v1-0-6996fb0b8a9c@pm.me>
Feedback-ID: 37836894:user:proton
X-Pm-Message-ID: ef8bcfc47c5dae631baa5202d5e953705423b8fb
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Add the dt-bindings and device tree nodes for the Qualcomm Crypto
Engine (QCE) and its associated BAM DMA controller on the Milos
platform.

Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
---
Alexander Koskovich (2):
      dt-bindings: crypto: qcom-qce: Document the Milos crypto engine
      arm64: dts: qcom: milos: Add QCrypto nodes

 .../devicetree/bindings/crypto/qcom-qce.yaml       |  1 +
 arch/arm64/boot/dts/qcom/milos.dtsi                | 32 ++++++++++++++++++=
++++
 2 files changed, 33 insertions(+)
---
base-commit: 591cd656a1bf5ea94a222af5ef2ee76df029c1d2
change-id: 20260405-milos-qce-a90710570bcf

Best regards,
--=20
Alexander Koskovich <akoskovich@pm.me>


