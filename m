Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804C9274FC2;
	Mon, 12 Jan 2026 14:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229765; cv=none; b=gsbG62h2k6c4jXb0m2odnG8LoUpsqCdRQ16myA/6Yo1ndShbQJ2EuKlcN5rgfllXpzfu2qDolSsr9gA9BFeeQVDDGB/X2rk0oaKnixguyUG/GCneIxc4VsOZs2yZg3/+iyLWTmqGClUKM2iFSKW1hk44Zmzp0HgXcqFPJkS0xYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229765; c=relaxed/simple;
	bh=vlvXyyMDvUQ3cBZtzqbSzYWVueI3kVASVe8Vv4U//o8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rNcg0YCXWTlxfpAWm0DT0bxirfwrKIhPlbmV1k4UVSJ37sfaeqUeoMKweXwMUdiBmrIypid6zQWjhdLVB7LfrL7LKMzYEC5uzXLLy9m+o6hgPvdvQDzB18mGW7yuLmDXaPEe2k04tcLhKAXOXttp1gz2KGF4CiHT84vmBsgWZS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=pVmFxJFr; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="pVmFxJFr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1768229762;
	bh=vlvXyyMDvUQ3cBZtzqbSzYWVueI3kVASVe8Vv4U//o8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pVmFxJFrLP5MLO84m5NvMAk90DmW4brET7ieoKwWNqZn/RP+f78En/Rj7ZldJ41YI
	 /Z7vh3xRucqO4hZwJrqYGoDIPKv1+/ubo4UJJFqXFOJDs/T0tQcDTyVScuQHQ1rLZz
	 6QaCDiQxFV9f2LBHYFZvjMZYXFnYMjoB/SFEynD6+tImizDnzy596Hjgy/VIeOOlp9
	 jqHTzZX7FkM6LdXOmAHVc4UIcbewUSr5zY6SSujiMCi1mn52pU3WVO6VSkdD1GKh0u
	 mJ7FBdP37b8fe69OR+wSQJAYyhCZCrM96TK76Ez5UAKpFMNsl+Ggv4JRVa3D3eCotN
	 aZcMEocEessXg==
Received: from IcarusMOD.eternityproject.eu (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 5D40517E0456;
	Mon, 12 Jan 2026 15:56:01 +0100 (CET)
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
Subject: [PATCH v2 1/4] dt-bindings: crypto: inside-secure,safexcel: Add SoC compatibles
Date: Mon, 12 Jan 2026 15:55:55 +0100
Message-ID: <20260112145558.54644-2-angelogioacchino.delregno@collabora.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260112145558.54644-1-angelogioacchino.delregno@collabora.com>
References: <20260112145558.54644-1-angelogioacchino.delregno@collabora.com>
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
index 343e2d04c797..1c8bfd6c958d 100644
--- a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
+++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
@@ -12,6 +12,14 @@ maintainers:
 properties:
   compatible:
     oneOf:
+      - items:
+          - const: marvell,armada-cp110-crypto
+          - const: inside-secure,safexcel-eip197b
+      - items:
+          - enum:
+              - marvell,armada-3700-crypto
+              - mediatek,mt7986-crypto
+          - const: inside-secure,safexcel-eip97ies
       - const: inside-secure,safexcel-eip197b
       - const: inside-secure,safexcel-eip197d
       - const: inside-secure,safexcel-eip97ies
-- 
2.52.0

