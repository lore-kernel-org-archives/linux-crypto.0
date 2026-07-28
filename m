Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F39F399361
	for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 20:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785272330; cv=none; b=KiVejinbDi+D4sZjOP425QUS5p1ancWSYjpDsFopy7ylF2EQkkNxLqsLx1XY1C7OriMhPohfmLCZPVxXMbL6wrJ5354dE4p54gyU9iAMQfeTP0wiBVs19TmL4zh3e5LCkZ18Wbmn5236CJ+uz1qDWQgN675h6Ok5Y9Ty8pDphm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785272330; c=relaxed/simple;
	bh=WzP/RvGoPS91Jf8i1xsA0+TMgFvLbMx4vB/VMlUlAfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t2kfCckiL1B4Kr6j6FSuF7TWpgUDiyifGjzpG53ZG2IhZyEq9LDjHJHe7NsHQz+ZbClFZ3IiH4eRETzAz8n+KaC+S4w1lQCxkbbh0+LQtKDIfYSe+gj/brdmxuPqU8h2x5iBu0fyxXQTnwGR4JhNuIsT+WPSd1Ga2rsktuygRSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KIZnDZYl; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KIZnDZYl"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785272326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jqcl2A1/Y/Zoai1qlUZXrlRzPqCbNIULxhuRqzApzxE=;
	b=KIZnDZYloKH0jnQ37cT+8sAqt0k7tIJ9I5+SdYZbg6ogLPIE/6xZe95NEfKzUf3jfTyn/Y
	/80EhR8eGku8lJgd0SmLyFVwuoxiuMiYwv6ZmGhoa7mGS12nhXqhGdKCffNR2zt5R7ta3y
	lJ+l2fU/4JlzqmzpXEAQlgqpQqM6L6w=
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
Subject: [PATCH 2/2] crypto: atmel-ecc - drop redundant return variable
Date: Tue, 28 Jul 2026 22:58:27 +0200
Message-ID: <20260728205825.471233-4-thorsten.blum@linux.dev>
In-Reply-To: <20260728205825.471233-3-thorsten.blum@linux.dev>
References: <20260728205825.471233-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1094; i=thorsten.blum@linux.dev; h=from:subject; bh=WzP/RvGoPS91Jf8i1xsA0+TMgFvLbMx4vB/VMlUlAfg=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFmZ4p/a9VSipk4t4LI5uOpqg94Gz8SOHXv0K7nEPVWFr mgZrzvZUcrCIMbFICumyPJg1o8ZvqU1lZtMInbCzGFlAhnCwMUpABMxP8bwv2ie2s/rNVbnU1dJ LnwTb/bl94tm4Z9hTGm3+AyUP8ifkGb4n1jOwOz9LVmRdebO7o7A2Unxd58oLOvTdjhouazjqv1 fRgA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

In atmel_ecdh_generate_public_key(), drop the redundant return variable
and return -EINVAL and 0 directly.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/atmel-ecc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index f98782f0a2c6..0c6ab5da9299 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -125,7 +125,6 @@ static int atmel_ecdh_generate_public_key(struct kpp_request *req)
 	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
 	struct atmel_ecdh_ctx *ctx = kpp_tfm_ctx(tfm);
 	size_t copied, nbytes;
-	int ret = 0;
 
 	if (ctx->do_fallback) {
 		kpp_request_set_tfm(req, ctx->fallback);
@@ -143,9 +142,9 @@ static int atmel_ecdh_generate_public_key(struct kpp_request *req)
 				     sg_nents_for_len(req->dst, nbytes),
 				     ctx->public_key, nbytes);
 	if (copied != nbytes)
-		ret = -EINVAL;
+		return -EINVAL;
 
-	return ret;
+	return 0;
 }
 
 static int atmel_ecdh_compute_shared_secret(struct kpp_request *req)
