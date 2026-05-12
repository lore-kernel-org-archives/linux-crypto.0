Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781E1346AC4;
	Tue, 12 May 2026 14:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778597518; cv=none; b=Vz9oKZcgllI4x9/aJ4UPbKj11ctA+hkPRhXIzPMBCVqRTTS+JOTHsy7UZazSfXg3XdTLpfRIf7ZQVtFrWQGMz8Stbst/cMLbNb5a3arPAZs0DcX6dbyAY9C1/jdpOvGwkK/S7uk1uBjRab3G0C9+OQzBo4xUDHaUhNed5scwad4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778597518; c=relaxed/simple;
	bh=np9d+kDlfRvRjOfinM9OPjVIiZ2MZZJrAAaVMwkIueA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I/cVT3jpQ4RKiGQsnG4f6OW/gvXpIdcAM2O49phV4AGYBevvB4zxELp2ejs84x9wtUqhl9GrzE+z8pTFiY7On6zswu0ulaqsLcXMaa06I8r/OVL0aynRuQkMYArC3jtSOV1CtwGDnG5IGUhVigNIsIJKWpDq8iNry5+FbKrLd2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mOHh3V5p; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mOHh3V5p"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778597513;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=EgJ8cza8obh4F0WjYyrhKNk+tJNJ3STV8lFyU3BHI9A=;
	b=mOHh3V5pHQpT8v5T9Y4zMsa37lQWDGlAP1Sdq1sZsSfe4JeqDfPxtsvY1w0OwgCWh7SBZ1
	HE+aGfiqrXSXzH0CM29/rpaMnY3UAjf5z1xqGDEieeIieJeZtJJMfeYi1A6k8zIcDS2iQW
	NqtJRDCCx+JXuoFLKKCDFDmxzkz0Dw4=
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
Subject: [PATCH] crypto: atmel - use min3 to simplify atmel_sha_append_sg
Date: Tue, 12 May 2026 16:51:24 +0200
Message-ID: <20260512145123.303311-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1239; i=thorsten.blum@linux.dev; h=from:subject; bh=np9d+kDlfRvRjOfinM9OPjVIiZ2MZZJrAAaVMwkIueA=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFnMdtmNV65qhrcuLYqes/q0w9Q/Gd+3hwYks15c98Wud 07O1oNPO0pZGMS4GGTFFFkezPoxw7e0pnKTScROmDmsTCBDGLg4BWAi01cyMlzZ2bdV0X3ui6WX O+PXae2JW1UZLVLh8yhMd9GTn5bVlokM/9Pm3Lt1cOuCUnU/cf6arO7j19idSi0drh+00nFhLfi 7jxEA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace two consecutive min() calls with min3() to simplify the code.

And since count is unsigned and cannot be less than zero, adjust the if
check and update the comment accordingly.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/atmel-sha.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/atmel-sha.c b/drivers/crypto/atmel-sha.c
index 002b62902553..7e7c83a3d8cd 100644
--- a/drivers/crypto/atmel-sha.c
+++ b/drivers/crypto/atmel-sha.c
@@ -305,12 +305,12 @@ static size_t atmel_sha_append_sg(struct atmel_sha_reqctx *ctx)
 	size_t count;
 
 	while ((ctx->bufcnt < ctx->buflen) && ctx->total) {
-		count = min(ctx->sg->length - ctx->offset, ctx->total);
-		count = min(count, ctx->buflen - ctx->bufcnt);
+		count = min3(ctx->sg->length - ctx->offset, ctx->total,
+			     ctx->buflen - ctx->bufcnt);
 
-		if (count <= 0) {
+		if (count == 0) {
 			/*
-			* Check if count <= 0 because the buffer is full or
+			* Check if count == 0 because the buffer is full or
 			* because the sg length is 0. In the latest case,
 			* check if there is another sg in the list, a 0 length
 			* sg doesn't necessarily mean the end of the sg list.
