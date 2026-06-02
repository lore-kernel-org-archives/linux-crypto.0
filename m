Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942FD381AFE
	for <linux-crypto@vger.kernel.org>; Tue,  2 Jun 2026 16:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780419265; cv=none; b=W2W+nCeMEASrXRB6nKQ/rApUosg2c+Ug1jBoOttD75X5OiI0xLpv0igB0wr7UZp9Zv933NZyijQSEnY/zLKd8QvSwjCoO89f7wh0flMwDDMm1ym4dOb/Zo/NeRtglROiNwXxfSiwNXt9P3qrnDmQJ9e21u9aPpuRgo3tX11dzwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780419265; c=relaxed/simple;
	bh=kZbngbyc9gF7nErlK2uWFwjBZCYgFqsy/5bwFGeh140=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PZ6cmRdg/z3WS9W484eqqxXvqHNtkcvCE7E66j22XVCBKSUwblm7hmcSlmhJT+RhtsCk4MXrTYpqStWb+k6czYA3CzyKZjTZ8tcY8ZMtLNdyCIhFlASO+55miy/5uyURGqORcSQ9r2sGxP7Ix+/UvhTKCVC6c+s4xHif7qoKuaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=onr5R3S6; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="onr5R3S6"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780419252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dDHf5/aY9RxOz5FV7uq8q69gY1cP6K45tQ3VpSCmP9o=;
	b=onr5R3S6IV0FVEyP7jQYiW3GLLFdOIKt92yjOqNdejNhuM0lcQTseIKhFM6xDa/X05efY8
	Q3zHyultqO+hb7PRKxp0Iz6C0xvUrtb9gaSZuNjfeAs16tJ28Wq0qOzjdiZYMztwpcBl2n
	Jy7ywEoMvNLIazsvsElLMqucpZAysTE=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: atmel-ecc - remove stale comments in atmel_ecc_remove
Date: Tue,  2 Jun 2026 18:52:49 +0200
Message-ID: <20260602165247.977197-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1341; i=thorsten.blum@linux.dev; h=from:subject; bh=kZbngbyc9gF7nErlK2uWFwjBZCYgFqsy/5bwFGeh140=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFnyXPESsTzBHPwaAu++MbOZJqR67tkSedXOLr3m2wLTA p/ORK6OUhYGMS4GWTFFlgezfszwLa2p3GQSsRNmDisTyBAGLk4BmMg8cUaG3jWbHD0l0jRst8r/ vFXGWx/3O9x/4ql6Jm3lucUVTB1nGP6XBawtip997eIfWyG2G7zS38rZ4r4Kbt+tVD/7faTLgeN cAA==
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

atmel_ecc_remove() no longer returns -EBUSY since commit 7df7563b16aa
("crypto: atmel-ecc - Remove duplicated error reporting in .remove()")
and is a void function since commit ed5c2f5fd10d ("i2c: Make remove
callback return void").

Remove and update the outdated comments.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/atmel-ecc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 9c380351d2f9..e6068dc0a0c1 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -347,13 +347,11 @@ static void atmel_ecc_remove(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
 
-	/* Return EBUSY if i2c client already allocated. */
 	if (atomic_read(&i2c_priv->tfm_count)) {
 		/*
 		 * After we return here, the memory backing the device is freed.
-		 * That happens no matter what the return value of this function
-		 * is because in the Linux device model there is no error
-		 * handling for unbinding a driver.
+		 * That happens because in the Linux device model there is no
+		 * error handling for unbinding a driver.
 		 * If there is still some action pending, it probably involves
 		 * accessing the freed memory.
 		 */
