Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A822D4B68;
	Mon, 12 Jan 2026 14:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229764; cv=none; b=Eas/WVgt0TrzTW/P3v31rV07JhX1A64VSs06sgZdxflUHKs+ZGy2MIKhp2jRzhrxRmao5jnViWfXTCLxZqOrNpkIFwiVZmomg5tbwjK5qeeEJvtw6JcQx7CEfi4GW6nNbketEZNmqPy6tI826cTyCKlEftLnl5k1BG/G+WB+OXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229764; c=relaxed/simple;
	bh=tCoHB+9VbDLSgUJNKgtCaz1rSx1hAZupwzWxkTySq3w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L9RbyS0EL3qxf9fM0cGBQpWH/7g5q0xjlhc94OIQTNxsTOfvi9s76jJBWyEpdn4wVBOcRc+uV4vfv/bPuLPGlV8FOdy3eiZQS2XCzGl6r1A4M537x5h5BqcAfE4siq6BCYUxg+98jb9G4sGLPN5lBa3QL7Df4mj2oee0qlPzRx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=mfM7M73s; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="mfM7M73s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1768229761;
	bh=tCoHB+9VbDLSgUJNKgtCaz1rSx1hAZupwzWxkTySq3w=;
	h=From:To:Cc:Subject:Date:From;
	b=mfM7M73s6rzWwjFv4SPWhwSA7Cq3+Wfcd+DcGC3yyHIZWvo1mKOmxGucpe9M/K1+8
	 Qcnu6Q6uALbI6wIB1GP1gHNvmwB2ljpv6BCPlbI54ZvyRKTHns1608Eht4cVCnrTzB
	 3osoub6Ljl8+HR6nCVNZGZrNwUOEA+LaMiXscdnxMkiirmefM7iy6jp6pFyFnUAqxZ
	 eVXw5YErKOQ4GUI7uxlg4iidRNSiiG5Vssa6V/LxMG9wM58deyv0MHdOeFA7NcXseX
	 1SgvgTzgUF+C7IvzcG1weTRzr3yapMGHFkgb+6DwL+KC3/yCB9KhC5ySeYuYRtlbEb
	 SfJi6L0BoXfog==
Received: from IcarusMOD.eternityproject.eu (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 9791317E0333;
	Mon, 12 Jan 2026 15:56:00 +0100 (CET)
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
To: krzk+dt@kernel.org
Cc: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	robh@kernel.org,
	conor+dt@kernel.org,
	andrew@lunn.ch,
	gregory.clement@bootlin.com,
	sebastian.hesselbarth@gmail.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	atenart@kernel.org,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	kernel@collabora.com
Subject: [PATCH v2 0/4] Fixes for EIP97/EIP197 binding and devicetrees
Date: Mon, 12 Jan 2026 15:55:54 +0100
Message-ID: <20260112145558.54644-1-angelogioacchino.delregno@collabora.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Changes in v2:
 - Reorder commits
 - Change to restrict interrupts/interrupt-names minItems to MediaTek only

This series adds SoC compatibles to the EIP97/EIP197 binding, and also
fixes all of the devicetrees to actually declare those in their nodes.

The only platforms using this binding are Marvell and MediaTek.

AngeloGioacchino Del Regno (4):
  dt-bindings: crypto: inside-secure,safexcel: Add SoC compatibles
  dt-bindings: crypto: inside-secure,safexcel: Mandate only ring IRQs
  arm64: dts: marvell: Add SoC specific compatibles to SafeXcel crypto
  arm64: dts: mediatek: mt7986a: Change compatible for SafeXcel crypto

 .../crypto/inside-secure,safexcel.yaml        | 22 +++++++++++++++++++
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi  |  3 ++-
 arch/arm64/boot/dts/marvell/armada-cp11x.dtsi |  3 ++-
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi     |  2 +-
 4 files changed, 27 insertions(+), 3 deletions(-)

-- 
2.52.0

