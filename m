Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8944E36A022;
	Thu, 11 Jun 2026 21:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781213801; cv=none; b=MaJtsRTeXlkdFv8RlmBxwmcelOUW9oUJKJYYGs08aeH3ts+X9jnJGMYS30OQUEYHvd+w/xamq6Z+vmrR1SPyTqSLzKotMuIN5NPtChDmVErm2eXvX0/e+niw58EArlGWCHbAr8f7dkw1kHIJqf/bQ764NElEwVncgMLtPqVjc4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781213801; c=relaxed/simple;
	bh=t3+XshRL09d6biiCDeS6+8HgJOqrtebPzUOHS7SPm6k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WyvbtYXWfXoA2r3NX2QDsAbA3uubCBd5cnNVygA+twO0Pb6lgxVggOwO9Wy6dFQG6qSsZSVnSCGI+WyYGTsfwe1/nIYkAW57irBBPkTqBxsta3TuGX/rD8cXHcSPa9ExRaWfmZtz+6bhKbm+EScd+DEVsSeMgUWKwrk0P4KkG38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CnfkFdcz; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CnfkFdcz"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781213796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4IEYPeJLO0t9DaZJvm8UdXCFj3OVpL5b6N7+5vqSmAM=;
	b=CnfkFdczXxEtBWpFsK09nkHE+qs7/SNLcVWSFr7Qyk68N+85DMXki4safyWUeTckt7e5eY
	QuNVPLYSv1SxSWhWRl8dpJEzWNb3yIqNL+JfN3uD1sBvVWbb2Ua7IQxsrFDA9isR0NoxIq
	fJ9cxPql9SHb/zQkl026p23CWsnnVBk=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Tudor Ambarus <tudor.ambarus@linaro.org>
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: atmel-ecc - reject hardware ECDH without a public key
Date: Thu, 11 Jun 2026 23:36:17 +0200
Message-ID: <20260611213617.463552-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1198; i=thorsten.blum@linux.dev; h=from:subject; bh=t3+XshRL09d6biiCDeS6+8HgJOqrtebPzUOHS7SPm6k=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFnaWoFBFQuVMq/xcyz+nMKspOjcrf85xeLnmvo3/ktv8 pYs93vbUcrCIMbFICumyPJg1o8ZvqU1lZtMInbCzGFlAhnCwMUpABP5L8jwT/fdO3/5j8vut/Xa /b88/dvMVQxVZp1LH7e8UTu3JXri/qmMDL9t9Ld3C6TUrLuiJy8ttMm5cf52Bs6F2+ZvNhVZtsd cnhkA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The hardware ECDH path in atmel_ecdh_compute_shared_secret() uses the
private key stored in the device. However, the public key is cached only
after atmel_ecdh_set_secret() successfully generated that private key
for the current tfm.

atmel_ecdh_generate_public_key() already rejects requests when no public
key is cached. Add the same check to atmel_ecdh_compute_shared_secret()
to prevent the device from using a private key that was not generated
for the current tfm.

Fixes: 11105693fa05 ("crypto: atmel-ecc - introduce Microchip / Atmel ECC driver")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/atmel-ecc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 93f219558c2f..542c8cc13a0f 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -173,6 +173,9 @@ static int atmel_ecdh_compute_shared_secret(struct kpp_request *req)
 		return crypto_kpp_compute_shared_secret(req);
 	}
 
+	if (!ctx->public_key)
+		return -EINVAL;
+
 	/* must have exactly two points to be on the curve */
 	if (req->src_len != ATMEL_ECC_PUBKEY_SIZE)
 		return -EINVAL;
