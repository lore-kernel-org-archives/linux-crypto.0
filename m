Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE48F280309;
	Thu,  8 Jan 2026 11:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767870162; cv=none; b=hmP6oGV7SVwPcO9PWX4zRK/w9wniESh5xBY82i2sLWD0Xy2bV3XTug8NtIFP/VFcuB1FBajqcYUjqiCpUX+v7Akxf7/1PKDG4iN51SR4c/nSDTPdNwrVOkrqJq8HIz4oFoR3RygxtOfCclmBBdLlmrKgmsZ3QBjVO3AyJB/r5Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767870162; c=relaxed/simple;
	bh=SVu3UQUP3zJMwteVTk/VX4i8DbMJ2CCZ0oIXKhXaKOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZMFlLCKPue8ZADhHcAlknANBkeBNBQl5xJ87BFZyTy2ytXZ5VHstm6kdLAozRV7tfY22uHL0dsodXhtSzR8Xrwhpi/V/pujzZ5Ial1QbtLYhM9qL658kdwbD46by83gwP5E5zD4sSKZ47twsJrMRIgkzkt7S9SRqPQVgH8fJQI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=S59zDiu4; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="S59zDiu4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1767870150;
	bh=SVu3UQUP3zJMwteVTk/VX4i8DbMJ2CCZ0oIXKhXaKOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S59zDiu4fIt8gfIdKDLAGYlneok9In+4XOVaEIsqpMY3dPK/eNJpNBq0PvMV8GBdK
	 yXshoeqOuTXxmxwnkbBinjcdsgLjkRxoywT7s2KPe+VyAG0J0b/Gm2h/rmow6nSBD/
	 JStpXc+YuGZKpzNoENX5iRaPLiXr9gwSxDLAF8bNtLoLLUcMyYgntxNzfKLY4CqdUR
	 6G/ldA73AssDIUS/IVh7kVfRkk9PHJ6KPsjvacltMZBfv5kPdPi1iht/qEq9+/zhAK
	 6biR4S/ELH/n3IT9bbpRMIfii4ZYodln6w3Hngnqb1jKx3nit5Au/cFnP9TIw8/39h
	 dm2yagH1bmGGw==
Received: from IcarusMOD.eternityproject.eu (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 8201517E150E;
	Thu,  8 Jan 2026 12:02:29 +0100 (CET)
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
Subject: [PATCH 2/4] dt-bindings: crypto: inside-secure,safexcel: Add SoC compatibles
Date: Thu,  8 Jan 2026 12:02:21 +0100
Message-ID: <20260108110223.20008-3-angelogioacchino.delregno@collabora.com>
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

Add SoC specific compatibles for the SafeXcel crypto engine,
including one for the EIP197B used by Marvell Armada CP110 and
and two for the EIP97IES used by Marvell Armada 3700 and by
MediaTek MT7986.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
---
 .../bindings/crypto/inside-secure,safexcel.yaml           | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
index 22025b23d580..736d675e19ed 100644
--- a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
+++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
@@ -12,6 +12,14 @@ maintainers:
 properties:
   compatible:
     oneOf:
+      - items:
+        - const: marvell,armada-cp110-crypto
+        - const: inside-secure,safexcel-eip197b
+      - items:
+        - enum:
+          - marvell,armada-3700-crypto
+          - mediatek,mt7986-crypto
+        - const: inside-secure,safexcel-eip97ies
       - const: inside-secure,safexcel-eip197b
       - const: inside-secure,safexcel-eip197d
       - const: inside-secure,safexcel-eip97ies
-- 
2.52.0

