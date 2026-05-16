Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A54931E841
	for <linux-crypto@vger.kernel.org>; Sat, 16 May 2026 23:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778974964; cv=none; b=Xvvynn7ejiY089vvXwGBNs8uVzcraKNwqBiMZzXPlbcyE9r0GHlYkBAMWytaFHWz1xOs2fttF2+fgoRuZr3gGP7hoS44CGoIcTOuvmnAxoD5yvayakYifcq+XeS4aOQ0buwUbbKwz/QLMbCsV8HvRaInC+miV9AAHORQ5Nd3xfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778974964; c=relaxed/simple;
	bh=HWgEXqdF6aYXWTxdFkGRqPYwNVxZP11iFJK7joXrAao=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PbugLmhKb4/0foaOLO5HIU8Q0dkUjNHlkLKoe/Q+fbZqCm0A1Dnw5JS8bd1EqrMdLgW6CotlhnL6obd6IkK6C0DRK0t70/bRlXQC4Zia+t2N1281wg3AInppgQZLDh7ht2QYNkU7oPUo9yCgObrZVjv5Rclmv4pP6BniA6gDPEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EhiIEw+6; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EhiIEw+6"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778974960;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uWVGWR9P+fisLqZv1EK+PltibUkbLcactFYAeNMlwf4=;
	b=EhiIEw+6YRlo7L/FrKufECtfndt7JZ73ZWWheOiWzMQDt/MMVPdJgyJK5i3l8wldIdMRvo
	tGqseuTVwdxny+BUkFO6eTxYWyYr5LC2GT6fqkO7sKqd09SKHfAWGzCe7sczgRnKpxkmgq
	ga2GQCXrGftFZrgr7JAiXfmXwhgso6c=
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
Subject: [PATCH] crypto: atmel-sha - use memcpy_and_pad to simplify hmac_setup
Date: Sun, 17 May 2026 01:42:12 +0200
Message-ID: <20260516234211.1131137-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=795; i=thorsten.blum@linux.dev; h=from:subject; bh=HWgEXqdF6aYXWTxdFkGRqPYwNVxZP11iFJK7joXrAao=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFmcDJcTo4/NWVN/RV3jSrvmzvcnT9af4jjTKzM3V/MLn 0Ftg0NVRykLgxgXg6yYIsuDWT9m+JbWVG4yidgJM4eVCWQIAxenAEwk6zUjw5NXMzu8F/G1vFHq 3H2l9rRfWIEUS0RSVsoleyZl2/pL9xj+J1lZH2n5EFZSsvif0aTay05bTllFrdddrCJW4l1Qtbq eFwA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use memcpy_and_pad() instead of memcpy() followed by memset() to
simplify atmel_sha_hmac_setup().

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/atmel-sha.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 1f1341a16c42..f60c7c8cf912 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -1731,8 +1731,7 @@ static int atmel_sha_hmac_setup(struct atmel_sha_dev *dd,
 		return atmel_sha_hmac_prehash_key(dd, key, keylen);
 
 	/* Prepare ipad. */
-	memcpy((u8 *)hmac->ipad, key, keylen);
-	memset((u8 *)hmac->ipad + keylen, 0, bs - keylen);
+	memcpy_and_pad(hmac->ipad, bs, key, keylen, 0);
 	return atmel_sha_hmac_compute_ipad_hash(dd);
 }
 
