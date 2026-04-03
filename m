Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE3B3914E0
	for <linux-crypto@vger.kernel.org>; Fri,  3 Apr 2026 11:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775215366; cv=none; b=rcdI9B3EO/3xZIDhBwhO/55UJpmTR5VRBpyPqzkw1SEKwEWaHSnCnnYgpeRVKKdSiaBPE+vRqP5anFUCqzUK/TkZ9vqujDx5+Pi7MfiLUPibXUAuOEtGH1Vhev7iuY25mrZoCzqwTEmAYfqKcrEbgnp/ws71HzdtA/ODMk4321c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775215366; c=relaxed/simple;
	bh=aRAzUf5gemmdK5F+5MKPd01K/sBf7Mnx4XljF9Dm4sc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nWliEyVvt3jk3jm+1o8Uic/T7ZqDxrBbI4uENtJWIz/A/nK7B5PfLk+TelkyRu2VNMrUUX4HKr0vVGHeramN2GyBvdyFhfAdEW4jfN6ToQhbUEYQlOk1I2xXVxQozal4orHF1zqQAQFOJYGoCHeu7UQhaZyFdPrSD/oDhiRbPt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iRD+eydy; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iRD+eydy"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775215361;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+rPShtDZMIHf5R4iGqfjObtCM/Idw2gV5jz+EjoaDW4=;
	b=iRD+eydya6bC8b8h8sM/FmclSJ4CGjAHcaxJG5lvk3w4C/WtotVjjVTVSRfC7//ldB4eFF
	pF/xn9RmEIheT+obXZt2K9y2kLXuYdz0kHUp4VWxioPuyQ4I/lLyHTxpQmcPnmTZjnwYvE
	D4YrLr7nomj/k5A5P5fsNBHwQsZKWzA=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH 1/2] crypto: atmel-ecc - add Thorsten Blum as maintainer
Date: Fri,  3 Apr 2026 13:21:37 +0200
Message-ID: <20260403112135.903162-5-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=734; i=thorsten.blum@linux.dev; h=from:subject; bh=aRAzUf5gemmdK5F+5MKPd01K/sBf7Mnx4XljF9Dm4sc=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJnnF+3vPLyMWXdqy271Q7O7HjzU+LdVL87ZIzNqwUpfn gWWCm3hHaUsDGJcDLJiiiwPZv2Y4VtaU7nJJGInzBxWJpAhDFycAjCRN/KMDPcXhibFivC7lodG frDUa5wt1/HA1eGbqp5Z/F7VDTfeFzEyPPgUxeu74VGt7/eyg3PzJi2oeNV5Q6j49d8clx3aRmI djAA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add Thorsten Blum as maintainer of the atmel-ecc driver.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 MAINTAINERS | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c3fe46d7c4bc..c23110384b91 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17216,9 +17216,10 @@ F:	Documentation/devicetree/bindings/media/microchip,csi2dc.yaml
 F:	drivers/media/platform/microchip/microchip-csi2dc.c
 
 MICROCHIP ECC DRIVER
+M:	Thorsten Blum <thorsten.blum@linux.dev>
 L:	linux-crypto@vger.kernel.org
-S:	Orphan
-F:	drivers/crypto/atmel-ecc.*
+S:	Maintained
+F:	drivers/crypto/atmel-ecc.c
 
 MICROCHIP EIC DRIVER
 M:	Claudiu Beznea <claudiu.beznea@tuxon.dev>
