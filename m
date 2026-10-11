Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE6B449B11;
	Sun, 11 Oct 2026 13:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791724567; cv=none; b=vGOKstu8VL9LB2K4dFX+WmmmtKv//OpAoWFL/6sKyL+prV22Db8b+ol/m47zh0tNLI30caT0//zu5IESP+A+CIRBLk0Rnh6zrg8w+Er5WFV5Job8c8iJ2ILNBJcHMjJdakexy98PAw2vy4OGo+d3xB8rQbv1eXTfTZ9odC95/K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791724567; c=relaxed/simple;
	bh=i2IEMteghzbOZjEP3K+DE9tgH6sC3YNRIyeoSHGFpFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7xlv/HJGS6mw9acLnNyGOaU8G+uOfcOIkVaGnqIZQcZ0oesuOcvgZPkkvUuhB4HxfQzFY1qpEoNF1/p/exsQk2MOLOcid79uH9pTLG5/suN3OEcrVoAemdMHFQscTEKuOsUI1TdNNlvw1GYI+xh4edlquViMrb7Bzwuza9hcxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nz+4JZpg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nz+4JZpg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16B21F0089C;
	Sun, 11 Oct 2026 13:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791724565;
	bh=cXlzmbaJxn4CnVjR3PmJa42S9oeGWwiIQUYVGfBTiNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nz+4JZpgR7Rxw3diD26ozBvvIAX8rNv2SZ9fNaYvEcJwmd3grNrk4yzs/FVCPptJN
	 gU0hli8SxSwxUMt3nL+66Voapi5ZN/IpN4aLbe8AM9SSSKstQzmQWTL18PFwm0YZ33
	 h/nVctRh1TZw5CryPmuwmibjrPgvpx4hksHji9C5y88c+3yD3eJpONKWU8g0iBQwht
	 mREZnOIZuhLKvxJLk3GfpVzsyNvrBzfIW0SQQqnPHXvFjTemfzxxRg9g5Wuu//JQ3E
	 DfV9Mcme7OmvHsGVDCOXhWXN/sxtTpt1qI2xIwj6q3W8DV2MrZWL2nZKnfF26fRnKs
	 TfrIUtJBrpmGA==
From: Thorsten Blum <blum@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: Thorsten Blum <blum@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] crypto: atmel-tdes - reuse fast in atmel_tdes_crypt_start()
Date: Sun, 11 Oct 2026 15:15:57 +0200
Message-ID: <20261011131556.272382-5-blum@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261011131556.272382-4-blum@kernel.org>
References: <20261011131556.272382-4-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=754; i=blum@kernel.org; h=from:subject; bh=i2IEMteghzbOZjEP3K+DE9tgH6sC3YNRIyeoSHGFpFw=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFmne3jMMiZc5y06s/9nKdfvH68axF5tMv7DY7l1U0Rdl lbWtZ2SHaUsDGJcDLJiiiwPZv2Y4VtaU7nJJGInzBxWJpAhDFycAjCRCBFGhj1WTlYHuOuPMm2/ YH3cam22dN/zxpRVV667eTeEeKn8q2RkuLVI563Z/TX5m9nrzh041PonKOhB/K+ei70TCi7waXu lMQMA
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

Use the existing fast variable instead of testing for TDES_FLAGS_FAST in
dd->flags again.

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/crypto/atmel-tdes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-tdes.c b/drivers/crypto/atmel-tdes.c
index b2fca4baee2f..f92dc2fff50c 100644
--- a/drivers/crypto/atmel-tdes.c
+++ b/drivers/crypto/atmel-tdes.c
@@ -473,7 +473,7 @@ static int atmel_tdes_crypt_start(struct atmel_tdes_dev *dd)
 	else
 		err = atmel_tdes_crypt_pdc(dd, addr_in, addr_out);
 
-	if (err && (dd->flags & TDES_FLAGS_FAST)) {
+	if (err && fast) {
 		dma_unmap_sg(dd->dev, dd->in_sg, 1, DMA_TO_DEVICE);
 		dma_unmap_sg(dd->dev, dd->out_sg, 1, DMA_FROM_DEVICE);
 	}
