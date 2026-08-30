Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E29F2DF3F2;
	Sun, 30 Aug 2026 22:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788127358; cv=none; b=PFQMkDaxti3Q+Thcem5ABMFa0B+fCcEKzZikWiZ0YhfEmt5gsLbPNr1/BZ+jYYs+4wAUkFs00QAZZdSL7iHGyUuAUfvIRMuYhE29EuQTXh1VjHHBHVNcK0Mp7jiX6N4HS+LcQSs8ZydzTYBIJN98pxBaz9OtslwgvZL6X6kTIeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788127358; c=relaxed/simple;
	bh=H9JL0oG1Fx6GEBDcIjF35MOjUYeFMqxl1kExqMvxKVc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hBJDmrZnjz81I7aIsA3FZfvBRIv/mnGC1tY2qmUfoXh0OklcksZCar/oA8vyWqnu91Icd36wI+6r2Z7QXb/HM9LSHlRZ9WI04Wv3VN8PF8TyuyEPoHvxPdrod2upzCdiSSXt8RSH7ChdBPuaBm83sOecIlqYBHocgrWY30POSek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gzcYflh3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gzcYflh3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FBF01F000E9;
	Sun, 30 Aug 2026 22:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788127356;
	bh=HSntGgCf4S9lwFDve4ZGR74yLsskLgsTZijttiRB7K4=;
	h=From:To:Cc:Subject:Date;
	b=gzcYflh3zEE4+fEsGhBh+lUBVzfQZkR9R25it8EnXRSOr57i7sZA9YfI/nxCqORYn
	 mmcuNyYZCS2PlUcx/oFlGtaeorEvUZqzc4t2ncDiFIg4c/AzuuMRa4e5SlbG0wT/PL
	 mGo655aCWcydVUKvO6RNDprfelH66HjxE7C9nJq0npFD6aAG9/tROWZ2SrQk6jSMmP
	 I3tZivWpTxSZDsQJ7uUb0DmlkiYFLXAT6WdnCXe66F3ikwlALzvTo1VzbqEMPOJQf6
	 0oBtpbQklyGQANnbUegHdJRenRRUv0eM7/Az0PyUgFU8Py2NQTuiHdC5Ll9u7Q9Dpg
	 E7wNx0s7TsiOg==
From: Thorsten Blum <blum@kernel.org>
To: Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Wensheng Wang <wenswang@yeah.net>,
	Frank Li <Frank.Li@nxp.com>,
	Cosmo Chou <chou.cosmo@gmail.com>,
	Colin Huang <u8813345@gmail.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Antoni Pokusinski <apokusinski01@gmail.com>,
	Eddie James <eajames@linux.ibm.com>,
	Dixit Parmar <dixitparmar19@gmail.com>,
	Thorsten Blum <blum@kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH 1/2] dt-bindings: trivial-devices: add atmel,atecc608a
Date: Mon, 31 Aug 2026 00:01:51 +0200
Message-ID: <20260830220151.21469-3-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=883; i=blum@kernel.org; h=from:subject; bh=H9JL0oG1Fx6GEBDcIjF35MOjUYeFMqxl1kExqMvxKVc=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFlTVvhnf7qgsdayo8d0poCZxtH2PW9qf2282cU7YVel7 NmC2vDNHaUsDGJcDLJiiiwPZv2Y4VtaU7nJJGInzBxWJpAhDFycAjAR0ZsM/5TEfNuiuc88WTxZ MqJt1vafu1b/kX+ywubF3F//5s7bzb6UkeFu9J91WRk3Z/fV88jwu5yuEzqqMut+8eOZPfcYD13 SMGYGAA==
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

Add an entry for ATECC608A.

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 Documentation/devicetree/bindings/trivial-devices.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/trivial-devices.yaml b/Documentation/devicetree/bindings/trivial-devices.yaml
index 2de8eb09cb7d..3b7876c5a45d 100644
--- a/Documentation/devicetree/bindings/trivial-devices.yaml
+++ b/Documentation/devicetree/bindings/trivial-devices.yaml
@@ -69,6 +69,8 @@ properties:
           - asteralabs,pt5161l
             # ATECC508A - i2c h/w elliptic curve crypto module
           - atmel,atecc508a
+            # ATECC608A - i2c h/w elliptic curve crypto module
+          - atmel,atecc608a
             # ATECC608B - i2c h/w elliptic curve crypto module
           - atmel,atecc608b
             # ATSHA204 - i2c h/w symmetric crypto module
