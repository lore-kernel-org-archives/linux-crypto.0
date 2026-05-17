Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F8230566A
	for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 10:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779014222; cv=none; b=U53lXGBmL0fVLT8pP8SdhjYhv8tpaoQKnSinW45FuY8IkCmPDgrwg5XVbfVqFzneQWQ1B5OIRLB20FtqHcIcGqb4iWJG2NhJbEX5BpTrzr+k3ndeDybDy5OYhmpBuc6E8K3SmhIaWCyrUQngGCi49+iXAKCykldpPn8pUgyyIrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779014222; c=relaxed/simple;
	bh=RR3pKKs5i6405VHFg0qrR1gH3mVbsDD3r2zzN4YhuLE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=S59S1NRoxz7cbJJRkouen/BnsLkGvAsnjBOj3iHJwAwbUkzNlIg2LY4PM+uwHo05DfHZH26lJpnhaI6VDIvRbKhIZxv81BwRko28tJmUBVlB+i5DKIM9HzbK4TWH8MneFqq/FMg7U0NHNjNWggv8h6Lpy9Ut4BBRObe7O0gdpao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EPOwp24F; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EPOwp24F"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779014218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nSJ9xtAptjkcB2zmxW3NpS5JvJ9+8y58WftyTcXQhF8=;
	b=EPOwp24FXFutVbt1GUAnk3ad2tI5QBHYSeZrXK4btc+mfG84rOJgQ/KKuObMqfu7RlyqJS
	aeURPcpiI8+N5696JiYkayTvb64/5MXIKWpHqz+8qkx6UvfQeK8FFvaed/nXXYqh6YyfAn
	SfFWIdUrMwSJmpR8IejCqM2izcjQ8/E=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] crypto: omap-des - drop of_match_ptr from OF match table
Date: Sun, 17 May 2026 12:36:52 +0200
Message-ID: <20260517103651.1135679-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=647; i=thorsten.blum@linux.dev; h=from:subject; bh=RR3pKKs5i6405VHFg0qrR1gH3mVbsDD3r2zzN4YhuLE=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFmcs5x57280UeCMjO4s+ttpxskx4YvlRdZ4Fr+fhnZ/2 d7u2L+mo5SFQYyLQVZMkeXBrB8zfEtrKjeZROyEmcPKBDKEgYtTACYi6cHIMHOx0MOXUZYR9aVT j7MzzZ0x66vy4Sbl3H8vZmoadhc7sDP8sz18juWOxqmY/2Gp28+2syxyqt2vxGdy+Df36gWdS7O ZOQA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Drop of_match_ptr() because OF matching is stubbed out when CONFIG_OF=n.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/omap-des.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 4eb45b2988c3..f38ed2d387c6 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -1111,7 +1111,7 @@ static struct platform_driver omap_des_driver = {
 	.driver	= {
 		.name	= "omap-des",
 		.pm	= &omap_des_pm_ops,
-		.of_match_table	= of_match_ptr(omap_des_of_match),
+		.of_match_table	= omap_des_of_match,
 	},
 };
 
