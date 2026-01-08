Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D661277CB8;
	Thu,  8 Jan 2026 11:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767870162; cv=none; b=cfEaHwx8Fgph93v4iARUvJBVnylTB19z8UrqmXGdG5VkwHvR6R9Rqb9HquTmTj//FXJLi9fxrcVqdEexw7zzLJuGSsIK6sm/IY4W7QEznpR1LjoDpfZ7blXUgLRXHSpCcwyrvwW7nmee528YKtgELKotsZzrjED9oNGrbwKH024=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767870162; c=relaxed/simple;
	bh=FjTO4MwoD/ainIr75jhsXy0/Wn1Tk9zoVoEa2EpUej8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QM+L7Np9PTKK3sOcZhr0awfNa8NgGqXY0K3yHQsRbFMmYDpEWrsxaI1E7dwV55gJEGR5DDUuULBITOrZKIqq374Hu0benVoKIp4ZFLUezhmV6389KFOy3Nq2pLWDeT3aBvuOFPAdFZDucumhGdISLy6PWuLOAQ+K3x7DoUKjems=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=KN/Svax+; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="KN/Svax+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1767870148;
	bh=FjTO4MwoD/ainIr75jhsXy0/Wn1Tk9zoVoEa2EpUej8=;
	h=From:To:Cc:Subject:Date:From;
	b=KN/Svax+wbp5OAhy33jOr0ElKtk984BLo1gNmR4cKF54gXx5Eak697Hu74mPys1W9
	 5QudsZ/7M2ybsYjyRSBsNUNbnIInSUQ4x3pBdyEAawiL/InXMYu7aQdTpsQZTLKeyJ
	 KtDYsaPWRh3SY5QSnmoYLEi3+X8tChbg0Rs9R6C0H9D3xaLQRazeBBa+4nePYG1o+3
	 U8lcxtrA91Zws9x00bSx3fyIU/7NI0nvCcSqiP8NlKuAn+VUxTOrwVIGx+153t82bo
	 Xtl65Ay47nPNPGOMM6ZLT9J2zvnpfwP4ozTG8rT/mmLmnEYg0SRS+PNPxcvHu2nRar
	 XzZFzOOboUipQ==
Received: from IcarusMOD.eternityproject.eu (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id EDDC317E0DC0;
	Thu,  8 Jan 2026 12:02:27 +0100 (CET)
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
Subject: [PATCH 0/4] Fixes for EIP97/EIP197 binding and devicetrees
Date: Thu,  8 Jan 2026 12:02:19 +0100
Message-ID: <20260108110223.20008-1-angelogioacchino.delregno@collabora.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds SoC compatibles to the EIP97/EIP197 binding, and also
fixes all of the devicetrees to actually declare those in their nodes.

The only platforms using this binding are Marvell and MediaTek.

AngeloGioacchino Del Regno (4):
  dt-bindings: crypto: inside-secure,safexcel: Mandate only ring IRQs
  dt-bindings: crypto: inside-secure,safexcel: Add SoC compatibles
  arm64: dts: marvell: Add SoC specific compatibles to SafeXcel crypto
  arm64: dts: mediatek: mt7986a: Change compatible for SafeXcel crypto

 .../bindings/crypto/inside-secure,safexcel.yaml        | 10 ++++++++++
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi           |  3 ++-
 arch/arm64/boot/dts/marvell/armada-cp11x.dtsi          |  3 ++-
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi              |  2 +-
 4 files changed, 15 insertions(+), 3 deletions(-)

-- 
2.52.0

