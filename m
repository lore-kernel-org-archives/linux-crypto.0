Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6E437700D
	for <linux-crypto@vger.kernel.org>; Wed, 11 Mar 2026 11:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773229247; cv=none; b=C+wXkzc5Sn7aoYSVZtyc+Q8ZcPTelqvBZnyc2jP2CoXSkO2Oddgd95OWmz4veB0BNvMrd+VImL5LBwgbi+Z+VpXb4aSV5arbHIY1B4SSfywkAnUXqsQolZjlR2Cf/W8GxoCXwfa/WV9an0qbfqjFHKDwta+h7FQKURuMKY0BDjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773229247; c=relaxed/simple;
	bh=0W2qDs9Pda2VTMqqyy80DUZU1WSJA8HR8VKSER3/HQU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LHql4giWqlPvAd0nXkLSZvKJIBsQ72fkRw9gwKcjclgWTlxbdK1F8A7Q+445MZZHoW+T1EDZ6vZbF5Ujnw5V8zx/Wz1nROJrVV/YtnJJKdXCG6+Wf+OW7motJ4Ww1Gm6AqGA1L9hx2742sr4NiMW6RKKasXilcsRQ0vL79Rentk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kRXZfNl1; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kRXZfNl1"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773229243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1zXXtJLw22kU7ibsV83dH9zcIzG6mbgyF5sMgd5go/g=;
	b=kRXZfNl1szwVPMCTGKbs/5CaKEkHTvPoFzmBWlDxaKf7dvja8EpCnYPLVoaj1JQl8l6yU4
	ZlaDy9YhF10wpDdQW35InXYhp3KewVpodh9t6MTayjwpzjIKRasouEtn5qVCIm9oLEsosi
	hWdSFIq6mdCoCECNx1KjRM0j/i7s88A=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: atmel-aes - guard unregister on error in atmel_aes_register_algs
Date: Wed, 11 Mar 2026 12:39:28 +0100
Message-ID: <20260311113927.305633-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1367; i=thorsten.blum@linux.dev; h=from:subject; bh=0W2qDs9Pda2VTMqqyy80DUZU1WSJA8HR8VKSER3/HQU=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJkbQ/JrCwuzvH+HfX+2UEixtn8FP9vv89f2pXZcb0q4a 9o+XeJpRykLgxgXg6yYIsuDWT9m+JbWVG4yidgJM4eVCWQIAxenAEzEVYrhr7jYsz1GvwVYLspc 8z4Q7Sb2U+DqzjOHN97ZPnFhh8X1+SoMv5hEyrS0L5qeK/zp/3tyWdHGjRpmMyZ0r9165J4Ox0y /Yj4A
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Ensure the device supports XTS and GCM with 'has_xts' and 'has_gcm'
before unregistering algorithms when XTS or authenc registration fails,
which would trigger a WARN in crypto_unregister_alg().

Currently, with the capabilities defined in atmel_aes_get_cap(), this
bug cannot happen because all devices that support XTS and authenc also
support GCM, but the error handling should still be correct regardless
of hardware capabilities.

Fixes: d52db5188a87 ("crypto: atmel-aes - add support to the XTS mode")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/atmel-aes.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index bc0c40f10944..64960eeeb17b 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -2270,10 +2270,12 @@ static int atmel_aes_register_algs(struct atmel_aes_dev *dd)
 	/* i = ARRAY_SIZE(aes_authenc_algs); */
 err_aes_authenc_alg:
 	crypto_unregister_aeads(aes_authenc_algs, i);
-	crypto_unregister_skcipher(&aes_xts_alg);
+	if (dd->caps.has_xts)
+		crypto_unregister_skcipher(&aes_xts_alg);
 #endif
 err_aes_xts_alg:
-	crypto_unregister_aead(&aes_gcm_alg);
+	if (dd->caps.has_gcm)
+		crypto_unregister_aead(&aes_gcm_alg);
 err_aes_gcm_alg:
 	i = ARRAY_SIZE(aes_algs);
 err_aes_algs:
