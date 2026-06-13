Received: from mail-dl1-f68.google.com (mail-dl1-f68.google.com [74.125.82.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA6E26E71E
	for <linux-crypto@vger.kernel.org>; Sat, 13 Jun 2026 22:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781390216; cv=none; b=HLSBX3ugirM6ZWmH248DA6zwo/BEQg5ok2r17hXFhKjRMYYuxcMdL+Ulcq7s0DZxv46XyKqP9fJjsb804yFTAP/hgF8ho/q3OEUaD6zlXgQY5b26s+lD9zTAA3B9tHHiHJMhxJwXkfxGaJKZVH2VogJErTYVRNcayxRBnFLnZKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781390216; c=relaxed/simple;
	bh=h+tI3stwiGTxgkfAJhfASTTw8PeWJ3Lj02d/Ek3YFYE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BX79T4zomi3AjOD97oCmhvYtPAKl/FDKowPB+rpBCcUKn3Nj/u7u5j3ANN1ukryPNjSgy8UwsOunSu0xWOs70ui9mo5ROlsWzI/RlAG04LUV4wD3CbuxGQXtio24SLD4yNrqrfTAUq/SI0IJe1SRBG0F5gQxwJNGdx1hU0qaxwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bcjYPqMx; arc=none smtp.client-ip=74.125.82.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bcjYPqMx"
Received: by mail-dl1-f68.google.com with SMTP id a92af1059eb24-13810b63a1aso5078142c88.1
        for <linux-crypto@vger.kernel.org>; Sat, 13 Jun 2026 15:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781390215; x=1781995015; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XiDlOMwIBEzJgDCkrbGsmaIjHNUQPh0ynYvlELyCcHQ=;
        b=bcjYPqMxhp+FV/Htkto+EIASNLl02zQ3r1rMX6J6zcs/Y5MEZqwaUI0SWzwLSgWPfv
         jFtHPxCBP1e8ZxUgeEz2NySE6KigpuYQFqMzMxJyHcXhtTjqDxHrjIvOJLzTxV2afKF+
         qr1naiJCz+M4lbRwKcTrgU2d02RM+qww0ie4J35kRN3WhDeHL/c11snwF+MH7ta6HCxC
         nMJuHPADwjAQ0U4wlDvMif1reitbuMvcgUugXXkJBfqQ3NQ36uHtAuqEFFzK5Dp70Hgr
         ZB87j72loFPDEtoVXv7zIOHHMaQsngJjvcTLJpVvBCA29/qachtJSaCHPqzCIzpaE06J
         wqAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781390215; x=1781995015;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XiDlOMwIBEzJgDCkrbGsmaIjHNUQPh0ynYvlELyCcHQ=;
        b=F1d1SDqcQBL25Ym7GONvk1rP8OR9U45mTcKcFaaFvpb7VuXxIMyIymRnB5coz9ni5X
         p7dJhdrKLHnjURKno97cLZYPCxFwuQ58j3UtNPhbRbCTGUEv5X4eZnX31/NzC6uP4kZ1
         EmvjprCwcl+FDqBo9xyW2TauAIU1U2btnom1Zqne6oc6mflvMvmJyyHf7EdKyPd+Nguw
         61vlJJwyO0IXG6tVLAS/UjCFUzYhUTqTCxoq3rVqrZT8YdUpq8FX2rmZwSKbOGTImQAR
         mvIMf/iTy8W6SiulV8xAjGkfBDRYkjOm3rq4ZDhZBCtgeM1IwT8E6h9oIPmAuF12aViA
         ZSQw==
X-Gm-Message-State: AOJu0YwGl+JzzXlxtuKsWMhp3bcU02DtkYpEZbjwvCVn2tpLSI+nbjF0
	LatOsCrz53fhWWrU3vYU39YTG5JMbGNWHKlgUvz2X1uBD0Oq222CcptkJKNbTCiF
X-Gm-Gg: Acq92OEdKf3jLWDUrskrgc+Y1MXy3nBQmq3Ky/fPoJpJFf67V3q1adxP6vDN0fGKyV0
	R5DSf3m3lvqju0/Jan2V9k4orQ7gQy/mx+hbknBvDkWsJsCv9/1uAtamGYkgy8n4kIE9Tz5TY+5
	wdHd0Gx40hPfdQ7VZ58XxilrfhQsvUtCNV9wzw8en9GNmaXszpsnUg0UbRJMA7htT0te+tQj8wg
	2fudgoDIFkkVWPD5btBF8afP0FyqOm47EFm2OfErC2zXlY/bSv6ekgR3Tz8esi4z+vI628VjWvi
	eRK62nfRuo3TbD16eqDBDtbV50Y8jO4lAt+o1s3JE/rxIm0zbOJdEdWLySYhP/l94r2XwV+ofvN
	SsDXMs0gLhYehM4wvZhoAUBR7ZAOW2VbJVCSvjTEM7A58vllLn8U2oXHTPaMPeVHDrYFOugnJuQ
	F1xD4dYsf3vy0TkCP9eQzOUr5ok4lvoXpxji2AQHh1KiwIRRGyQ5/roA/rPaA1i4gpMXL/3/Wg4
	2gYn2IR2OGr+F1LfJYrVy3cq3Gr1+kbk/BUNs5VY9msrHKR+qMhatSBD7ae+FSku1RWGyAriXfg
	nIRzWgU8dAAKzMNhpnWmxzYR02Zx
X-Received: by 2002:a05:7300:6d22:b0:304:e2a5:689e with SMTP id 5a478bee46e88-3081ff40814mr4819684eec.2.1781390214752;
        Sat, 13 Jun 2026 15:36:54 -0700 (PDT)
Received: from ethan-latitude5420.. (host-127-24.cafrjco.fresno.ca.us.clients.pavlovmedia.net. [68.180.127.24])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3081eb95450sm11091739eec.28.2026.06.13.15.36.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 15:36:54 -0700 (PDT)
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
To: linux-crypto@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Vladimir Zapolskiy <vz@mleia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH] crypto: s5p-sss - correct CONFIG_CRYPTO_DEV_EXYNOS_RNG macro name in comment
Date: Sat, 13 Jun 2026 15:36:47 -0700
Message-ID: <20260613223648.119694-1-enelsonmoore@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A comment in drivers/crypto/s5p-sss.c incorrectly refers to
CONFIG_EXYNOS_RNG instead of CONFIG_CRYPTO_DEV_EXYNOS_RNG. Correct it.

Discovered while searching for CONFIG_* symbols referenced in code but
not defined in any Kconfig file.

Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
---
 drivers/crypto/s5p-sss.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index bdda7b39af85..9bb1b1661174 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -2151,8 +2151,8 @@ static int s5p_aes_probe(struct platform_device *pdev)
 
 	/*
 	 * Note: HASH and PRNG uses the same registers in secss, avoid
-	 * overwrite each other. This will drop HASH when CONFIG_EXYNOS_RNG
-	 * is enabled in config. We need larger size for HASH registers in
+	 * overwrite each other. This will drop HASH when CONFIG_CRYPTO_DEV_EXYNOS_RNG
+	 * is enabled. We need larger size for HASH registers in
 	 * secss, current describe only AES/DES
 	 */
 	if (IS_ENABLED(CONFIG_CRYPTO_DEV_EXYNOS_HASH)) {
-- 
2.43.0

