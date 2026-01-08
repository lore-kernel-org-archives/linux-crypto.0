Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE3C38B99E;
	Thu,  8 Jan 2026 11:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767870161; cv=none; b=rR1X3JMBw4vJoJeH7QW6Zk8n7aqNYDiUC2k9Uz/Oe29ISmFdre6A2LdPWRfl3907MCg3PLZd5QqPSGkGJ93lt5Qk83kXr0hh9TFqVGcmQxDCrnXzbjQOEAhwvuyFD1e41+/AcV8Y3/r+Kqkv5XVWCkpdr/ninEb1j+SH1qcLy8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767870161; c=relaxed/simple;
	bh=FgDwPYPu4XP815gYCnlu4ei2ijDYZBkFZkwZ1M4VH5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lIn0bEHvZX/qUAJ3enc9k7B3/NjKFN5V/r1zQ8nOj1xXeovgLTHiW4E4FwuI4E71N03gZyaR9A3e6rI73P0kwgbwp1xd6uiqTA3LrJIWNZOd2nOhewr3MCCUFMceVLw0UlDwcN3+VojHqQYGyub0UEettk3Yi/7+EFYn+KoofYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=LK6J9AAB; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="LK6J9AAB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1767870149;
	bh=FgDwPYPu4XP815gYCnlu4ei2ijDYZBkFZkwZ1M4VH5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LK6J9AAB5I5iOpJhNKmrWMzuhnPsw0Obn1cRP55CpWrjQidssTCKwrD+Q7SFzHQex
	 3hU90X/52QdOZIAH0eGE1sjm5C1zXveD6jlaWSfzFgiWz02vmMSuLhmqQfeBR0SVaS
	 +5qEI58uUZA79OsvXqGIFcxC4dEkuGF0u6L+CN5g97AUf/k5L+9an7NmUfUYQe4l2c
	 tSgVIoysVsGMVJF9aKFPmEPJdYdBm3B2cd63CJVUHwMYteZ7YvdHG0gLDmtyPV5H+f
	 N8JvnmX9M2LzrLNLto3iJrU42FSyi6KGTsLY5YTZefituntFor+qvJj8EW6Ld+uAC7
	 uoYL8f7o3xB+g==
Received: from IcarusMOD.eternityproject.eu (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id BDCC917E11FB;
	Thu,  8 Jan 2026 12:02:28 +0100 (CET)
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
Subject: [PATCH 1/4] dt-bindings: crypto: inside-secure,safexcel: Mandate only ring IRQs
Date: Thu,  8 Jan 2026 12:02:20 +0100
Message-ID: <20260108110223.20008-2-angelogioacchino.delregno@collabora.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260108110223.20008-1-angelogioacchino.delregno@collabora.com>
References: <20260108110223.20008-1-angelogioacchino.delregno@collabora.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Not all IP implementations of EIP97 and EIP197 have the EIP and
MEM interrupts hooked up to the SoC, and those are not required
for functionality as status for both can be polled (and anyway
there's even no real need to poll, but that's another story).

As an example of this, the MediaTek MT7968A and MT7986B SoCs do
not have those two interrupts hooked up to their irq controlller.

For this reason, make the EIP and MEM interrupt optional.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
---
 .../devicetree/bindings/crypto/inside-secure,safexcel.yaml      | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
index 343e2d04c797..22025b23d580 100644
--- a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
+++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
@@ -26,9 +26,11 @@ properties:
     maxItems: 1
 
   interrupts:
+    minItems: 4
     maxItems: 6
 
   interrupt-names:
+    minItems: 4
     items:
       - const: ring0
       - const: ring1
-- 
2.52.0

