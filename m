Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919A71CEAA3
	for <linux-crypto@vger.kernel.org>; Mon, 23 Feb 2026 16:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771865892; cv=none; b=AehD1kdq7u9XNW1pe7Ozbbdpu73qUqnrJvKFp1xGMJZULPyXjlVC/GWPVY6aOEvKyA6KXEZClxuq4Dkxu+/Q6UwJ5B70UVi83ZDy8HlGcqHCW+2T++l7TP+iFTGBH37aFQqSteHgUXFDOAuDkRlUHXA1sQdcHYNm71t1NX1xpgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771865892; c=relaxed/simple;
	bh=BjmrNggJzmi66aQmqPz4UhMsNxJJxa1q16jsQjBMoRg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kXSWjtKV+qzqmv11pOXNExQ4gxzNHken69UjQ6nqtl0hYU0pbEc17S5j7mw3KA9MI6z9/Ugwj4x01giq4LPc822SJjUjT7dTjbHWBZnTsobhY0WAQwjqIdV9dZMONNHOyYWbSrTUzzqgEXjmPIT/C+D+ogdIiOkOBzUTXabl/VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Vb8deNEs; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Vb8deNEs"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771865877;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ACKCF7Sx4cJxzVQ7Qf86A89fhl8f5q32Mam+sZ5AZeU=;
	b=Vb8deNEsJm+92Oqi0KPQJHpOekHoFOL0aPQg4vei7EfRHwqMJR02F+GKBKn1haGgzdmBBK
	Zkr0bkyuT3iJLiIZSMNGfh3sGqDB/gZazrobqOQYzQDWSHU10LMgOUapLRzGrc6Tnm4Bjz
	wDdTt8Tn3sxiTOU4r4Uv4VaC+jiB3mQ=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: atmel-i2c - Replace hard-coded bus clock rate with constant
Date: Mon, 23 Feb 2026 17:57:37 +0100
Message-ID: <20260223165737.342015-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace 1000000L with I2C_MAX_FAST_MODE_PLUS_FREQ.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/atmel-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
index ba9d3f593601..316a0ad53cf6 100644
--- a/drivers/crypto/atmel-i2c.c
+++ b/drivers/crypto/atmel-i2c.c
@@ -370,7 +370,7 @@ int atmel_i2c_probe(struct i2c_client *client)
 		}
 	}
 
-	if (bus_clk_rate > 1000000L) {
+	if (bus_clk_rate > I2C_MAX_FAST_MODE_PLUS_FREQ) {
 		dev_err(dev, "%u exceeds maximum supported clock frequency (1MHz)\n",
 			bus_clk_rate);
 		return -EINVAL;
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

