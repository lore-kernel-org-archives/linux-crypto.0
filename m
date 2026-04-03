Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4A93859F8
	for <linux-crypto@vger.kernel.org>; Fri,  3 Apr 2026 11:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775215393; cv=none; b=UfP20lC4iPp/FQKScdW4neNdBgRJwp/aNyNPQwU+U+lc4mvJzC7oG2wM9jteX3M8S9UN7Mx/0OMqHb/ApuIE9sPfDExghwpm8h5GuUZjWzVm+FqZI4Ojn/C61DnO/8QMrB3qzB8Zgg/mYPsendCkrl1AXJOLNTp4bxbiYz2jq2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775215393; c=relaxed/simple;
	bh=cSJ3Ql1kXpO/gB5LFObrJvyNWLgO2lBRtMbPwrgRPyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DiNS/EhFIUwt69TdXwnGJS6t3oknDCyr8Qu14BWBzNQGVO7XqrA5/mJQKFIXLGUUixa4SSFb0KBlId69Ahhc3YqW97/rjlTBQj56l5XFOej09JfCOR2XxWZ0wI6EP4cLZoKEsSMhyilOXN+OO83oeHrb86964aQx+ya4iPFDzJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Z/Zf9lqt; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Z/Zf9lqt"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775215388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s3JuxB+/G6y3udfdt5Fiil7AyJojWZfgqeS6B/HYrYI=;
	b=Z/Zf9lqt4f9XlMRl66ZxF6HW9wVwId5eNYruIMuBtIRIktZ8pw6HSCNlf6K2xgIRvsyjFe
	LH9BksYZFquQXmNzGdLykHauuq+ZVokFLhhFZxAU89/WEh4z3B/hdjYetequPQr7/Ol/2i
	THWI0H9JPM1amPfRF9QsxNgV6WhjIeE=
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
Subject: [PATCH 2/2] crypto: atmel-sha204a - add Thorsten Blum as maintainer
Date: Fri,  3 Apr 2026 13:21:39 +0200
Message-ID: <20260403112135.903162-7-thorsten.blum@linux.dev>
In-Reply-To: <20260403112135.903162-5-thorsten.blum@linux.dev>
References: <20260403112135.903162-5-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=765; i=thorsten.blum@linux.dev; h=from:subject; bh=cSJ3Ql1kXpO/gB5LFObrJvyNWLgO2lBRtMbPwrgRPyU=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJnnF+03VW9nzgu9+23C1HV+GisO2NpcaN279YNB/Y3d/ 2YXHDHq6ChlYRDjYpAVU2R5MOvHDN/SmspNJhE7YeawMoEMYeDiFICJzM9k+MV0dN/um0vj106R mfj0/zaLCzcmRF4PkN91a3p/yJ4d6x6wMfzharYVm/b7flHs4dqMh7u0T/cWXWX8eD/95uT6n5d X+xzkBgA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add a MAINTAINERS entry for the atmel-sha204a driver and Thorsten Blum
as maintainer.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c23110384b91..7317d80592cf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17197,6 +17197,12 @@ S:	Supported
 F:	Documentation/devicetree/bindings/serial/atmel,at91-usart.yaml
 F:	drivers/spi/spi-at91-usart.c
 
+MICROCHIP ATSHA204A DRIVER
+M:	Thorsten Blum <thorsten.blum@linux.dev>
+L:	linux-crypto@vger.kernel.org
+S:	Maintained
+F:	drivers/crypto/atmel-sha204a.c
+
 MICROCHIP AUDIO ASOC DRIVERS
 M:	Claudiu Beznea <claudiu.beznea@tuxon.dev>
 M:	Andrei Simion <andrei.simion@microchip.com>
