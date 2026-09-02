Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F73847208F;
	Wed,  2 Sep 2026 10:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788346433; cv=none; b=HZx8MDPtjqthLLDQr7qXYDCqAYBs7n24G1xOanbM7ONfh+R3GnbK+j7GJXaCm2wGtzTLTBiZOTVu91S1PfDY4EtvJw3rad3rB7TakJkqFxAv9SKDtgOOtLgx4Ej8wpz5Lm+980pCXIyI5qJ+JUNpN/6cd9SBe20pi0wx9fGaN9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788346433; c=relaxed/simple;
	bh=A4aOhSi1XFVZt7IZdETUA0i7eLg+8wvC5W3myX5o/SU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S6ktchB+xEykWASwEdH9bJ70EfI6q8BeoWLZmWhlLFLFgIzxoyb0KMB6wvxSRQKbDn556WqJQqHL/1Lg+Lw9O/K23qvVCSZx17RLE0CinIbP+mWsoE9zi/W59LZV/XyXc/c/z0nI8KZliUDtstEfGXGh+jHZq/5CoWClte1JgO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RZpIK0aD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RZpIK0aD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31511F00AC4;
	Wed,  2 Sep 2026 10:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788346406;
	bh=pBvmiL72fAJ8jJ3Wa5Ngf7lvySzdLWObGSlNEBCm2Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RZpIK0aDEi/GC603PkbYdFX6exJUq+TXNJ0ojoeJiu4Q+dEuvnSSbk6TjJnnKsNrm
	 N6SFVEmvs4k09IOGfysifsajrJ1px5/SQrhjYez9bidBhgSCaEs/xolgAoVeeBhwT1
	 vSJxsEl5eFL7+7IO49Wz0xWtii3nRkx3G16M6trLoZEtDm2XqPVMc17HdaqomxEX3s
	 Z1JzZHccbg2AtqwBMGUttQEKSo5dNZKJlrU8twE0y9fkhYNQU+2BB2wzfHaARv3Q3s
	 RXVKMlDHUsCIkHeb4yHiZHdUrdndkFSJv5WWCTkII5Bn8ANrIvVVhSd7Hr0qX4C7C+
	 i9MdPtc2jRmbg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>,
	Tudor Ambarus <tudor.ambarus@microchip.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Ludovic Desroches <ludovic.desroches@microchip.com>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10.y 2/5] crypto: atmel-ecc - Struct headers need to start with keyword 'struct'
Date: Wed,  2 Sep 2026 06:53:19 -0400
Message-ID: <20260902105322.2048136-2-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260902105322.2048136-1-sashal@kernel.org>
References: <2026083113-premiere-tables-885d@gregkh>
 <20260902105322.2048136-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lee Jones <lee.jones@linaro.org>

[ Upstream commit 71057841feaa6c1b5a80959013e588b2cdf9aef1 ]

Fixes the following W=1 kernel build warning(s):

 drivers/crypto/atmel-ecc.c:41: warning: cannot understand function prototype: 'struct atmel_ecdh_ctx '

Cc: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Ludovic Desroches <ludovic.desroches@microchip.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: f07a0d251db7 ("crypto: atmel-ecc - avoid stale fallback key after set_secret failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/atmel-ecc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 5dd3e37f6715a..004d87cbfa221 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -26,7 +26,7 @@
 static struct atmel_ecc_driver_data driver_data;
 
 /**
- * atmel_ecdh_ctx - transformation context
+ * struct atmel_ecdh_ctx - transformation context
  * @client     : pointer to i2c client device
  * @fallback   : used for unsupported curves or when user wants to use its own
  *               private key.
-- 
2.53.0

