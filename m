Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612C8313E10
	for <linux-crypto@vger.kernel.org>; Sun, 12 Apr 2026 09:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775987850; cv=none; b=eNE4O8y4C6K10urf62tO36gPQennjE+cKr530Tgb9dMzzf0QvBT25yMElax2CRk7UezWDv64/+Tf9YUflrH7oBihs1Hcb1X1O+FPjS9PtEbL05zTfCRyZ7nk+Ne4j59W6lFJRITd50mOP2uDTTBZdVbGgWyRf2DK0Gduyeap08Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775987850; c=relaxed/simple;
	bh=zoDd1QHdWIkWTAMvkbCZWpltX43/8K0RTpSDGqtElwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k84UuUWivDfcLNPLCBCQqyexSNgHTuPxX2CXE5KobNRaOUHvR2J5zmHosOaEXUoRhLFTQai78dMb9SlGvIwU8B9Jc5Fi+zwukfp7q51pXKrCqix87+sEbj761M61yUpR/ce2Qn/uy7XbaiREsaSOa0jXhCYTDNwtmksqz6mSqRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Rgsoc23W; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Rgsoc23W"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775987847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ezz95oUxGgZG6+iQtidhoQMvjKyho+6KgNm0eRVJPOw=;
	b=Rgsoc23WWFaKZmJ3tw3yQ9SgpY2eRfg8nZk8oYFp9siMyJimx+nyLNnA7SpuYKtfLXANam
	6SxNCo/MBlXwNxU0IXM3Pf/HWtLwvhg0BR4/je7x7ii61/qtCG6gQv1QyWB8laMaRLez+P
	rlDZmuQwUDQVl1Pcb7he4bmputFpFSM=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Frank Li <Frank.Li@nxp.com>,
	Cosmo Chou <chou.cosmo@gmail.com>,
	Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>,
	Wensheng Wang <wenswang@yeah.net>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Antoni Pokusinski <apokusinski01@gmail.com>,
	Eddie James <eajames@linux.ibm.com>,
	Dixit Parmar <dixitparmar19@gmail.com>,
	Pawel Dembicki <paweldembicki@gmail.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 2/2] dt-bindings: trivial-devices: add atmel,atecc608b
Date: Sun, 12 Apr 2026 11:56:45 +0200
Message-ID: <20260412095642.120815-5-thorsten.blum@linux.dev>
In-Reply-To: <20260412095642.120815-3-thorsten.blum@linux.dev>
References: <20260412095642.120815-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1260; i=thorsten.blum@linux.dev; h=from:subject; bh=zoDd1QHdWIkWTAMvkbCZWpltX43/8K0RTpSDGqtElwQ=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJm3c2IaJ0q3rHAt4Uoo2F/CwTmrYrP39/uyRlHzFC5cE DJafnh6RykLgxgXg6yYIsuDWT9m+JbWVG4yidgJM4eVCWQIAxenAEzEPoHhf2bTtd4Z/XFnzBdk bDl3wEPpzZNXE5NLdoomK9581xQZmc3w3++mhv+cmYzWTNPP3eC2t1hh9Xrdwqd8G/JlGrWFLN2 i2QA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add entry for ATECC608B.  Update the ATECC508A comment for consistency.

Acked-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
Resending to include
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
---
 Documentation/devicetree/bindings/trivial-devices.yaml | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/trivial-devices.yaml b/Documentation/devicetree/bindings/trivial-devices.yaml
index a482aeadcd44..9da4c73b23cf 100644
--- a/Documentation/devicetree/bindings/trivial-devices.yaml
+++ b/Documentation/devicetree/bindings/trivial-devices.yaml
@@ -63,8 +63,10 @@ properties:
           - arduino,unoq-mcu
             # Temperature monitoring of Astera Labs PT5161L PCIe retimer
           - asteralabs,pt5161l
-            # i2c h/w elliptic curve crypto module
+            # ATECC508A - i2c h/w elliptic curve crypto module
           - atmel,atecc508a
+            # ATECC608B - i2c h/w elliptic curve crypto module
+          - atmel,atecc608b
             # ATSHA204 - i2c h/w symmetric crypto module
           - atmel,atsha204
             # ATSHA204A - i2c h/w symmetric crypto module
