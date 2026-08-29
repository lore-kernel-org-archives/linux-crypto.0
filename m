Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D94E12CDA5
	for <linux-crypto@vger.kernel.org>; Sat, 29 Aug 2026 04:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787977651; cv=none; b=VJlw4P0a/FdrIiIuAks2yhWbHoOf1jS+384vII5hWxMm74TpftASKrkC1x976YxtakGXBzva/v55MCkaI23/lVM2myTIHZgWG8gNDYBVh4BOHbmbE0Hm2oixoAcokTKFXakpgDG8ttoLYYbVUc9QlZaVOv9L+oS8Ilofb1c0jRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787977651; c=relaxed/simple;
	bh=moAU7WUbeJ7iQyI+ELpwXLBlUGap4t99Byv+JopKJnc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GJlqkvDjeiP7QOxMV3WTybbbAO1Yj2SpvNanWAKRApwENrzA7TXdrrUb+yf1YzmNsQFNrYc+/McG/QyQOgxFVJgh5A0R9lPSUszU+rGEL6+ENaA4KBykk4ehd0sHRCzA4gkxCAOYxFOmK/b727PdycpzvngG9FEGgh//USAB+Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gSNK2d5s; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gSNK2d5s"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-49b0d8bc2aaso14782055e9.0
        for <linux-crypto@vger.kernel.org>; Fri, 28 Aug 2026 21:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787977648; x=1788582448; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=208RQngiBHE21PmHkOlyRcvNYTZaRPWqpBwhjg/rUVM=;
        b=gSNK2d5sdXVwk+ke4z7wDzq8Fhevk9m96+MEGHkwfaumoyogUz4aGsmGZkIO+F1tFh
         x6WyrHz13AsOOUxtsSz5POWEOYlDnUZtsEqslkrRZ+88fZi0g/Av5R+agOsaM/PI0mrw
         QgsbNgTMPbl69Ph8CR/07EIwIhUp89MgQ0k5EA8Qi9RBD5ameFniQtn25vM9zxgKBzUI
         LvE4+tODbdcImX58mz3It5nLasWKDjonGp81cFnXRdLYTXKAmWnciTZUjxgUATVuqMIj
         NRqWCqc94JmJ1g8AM0c/qNA1Vx/Yh4scItfiNtFCMfBhX2q3FpvJMkM30Is0Am+nNmVO
         jhWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787977648; x=1788582448;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=208RQngiBHE21PmHkOlyRcvNYTZaRPWqpBwhjg/rUVM=;
        b=PPKpAw4IKr9MbFGEg0l6Y5JKBUFbwYDRYEuv8JegBmUSpDBv7/N7hkdxY1U7DwPnb5
         L1L4TryeHF+DrNgCCoxujch4pSDewJITVJ0EW9WK7QY0lLfTxotDOlC+fUWwc6+lRo/m
         128w5jdRBkRRLdQeJO/K6ihKSvSthB/RwAFMxOLaacbVmCFBjjzYQJhQTEHVf96nsx2o
         Qt2yQStknbwoA4icg+WzuMXWugBQqT0/boxI8rKL4pJv2+7Nzohca3svzWOmwPnpB7Uy
         sSdjhvG+VQFGEJZ60eTGXuSQxYtoq2m/2rOtGu3C65LeFRAfkGtkwhR23MbJG5nb4ppk
         E2sg==
X-Forwarded-Encrypted: i=1; AHgh+Rruq2sXQgYK+xsJAuRScikGnw0HcrU1I7HZ3bhmf+ddMWtuuFMdfzsN6deYHEFO3u/GymvzyN80TufQ9rY=@vger.kernel.org
X-Gm-Message-State: AFuF++mTw3DzyxWXuEw5gYxD0c+KCAVqhcCqPuJ0zFHAu68NRouZQmWw
	vSU6sgCTJLFIuqtcn1+tEkmwgcXP6f62EB43/8QQTEI35bSKVLRT8Tfn
X-Gm-Gg: AR+sD11OZUuESiuyEdULmH0s7SxDcanv1CZqQHiXET81kobyPokiF7Qab1EedXpaxFN
	fnkAKE2QBlvoO649D8J1zqGboQeRx8aLW70cdBvDmXPFpyK1MT3plKb0VDWFs1AltI2sxHGxLxM
	82ushV9iutPa4+iqOAkPXuO7ThmgKhIxJTO5LKAk22xk4K/sVdF6sCf+tWgUBd12WSgHqMN2DZ9
	RYJWi6t7DJHsyLNgycqIw3H8fzfuy7toF7XXVrwASj9oWbx7CpoHY2dJ4IBJHcBD775WY4XYRIm
	FWHx/42aqmFJQYv/p7MeccqPbk+jGB7HPhVCJDQ04BpnZ8UDHt/XvyYVr4e5zC5XW1OZJaIFgPS
	8ILB44VpFuI5EmGYKkJgrMyYYtPliqU8kqV7qa+fTXKnUJINUlmtjd/uNfIgqF3cveazUTSLLWK
	b+bbFuid3PddpWRaNyAffmLC0mtgPdXrTu1iQboa+h+H2PZHShlGYatk1lnqgp8AcVqKBF27GAW
	zQ5/z8L+CEljVH3ym6GSQC94Sneu2Y/Ko60gBQ4FC5PMl8GH/YcTPIDVhLj8ZBYITUH89TqXNpr
	qoodeREgC8J+OGwRDJEE
X-Received: by 2002:a05:600c:3145:b0:499:79b9:e220 with SMTP id 5b1f17b1804b1-49b91c44f6cmr167217795e9.10.1787977647580;
        Fri, 28 Aug 2026 21:27:27 -0700 (PDT)
Received: from localhost.localdomain (dynamic-077-007-015-136.77.7.pool.telefonica.de. [77.7.15.136])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b94dc0f57sm116792405e9.2.2026.08.28.21.27.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 28 Aug 2026 21:27:26 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: atmel-aes - fix AADLENR for standalone GHASH
Date: Sat, 29 Aug 2026 06:26:04 +0200
Message-Id: <20260829042604.82719-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

atmel_aes_gcm_ghash_init() writes dd->total, the request's text length,
to AES_AADLENR.  But the GHASH it runs hashes the dd->datalen bytes passed
in: the 16-byte length block, or the padded IV when the IV is not 96 bits.
The data sheet requires AES_AADLENR to hold the length of that input.

With empty plaintext and empty AAD, dd->total is 0 and the tag comes out
wrong.  Later requests only pass because dd->total still holds the
previous request's length.

This is testmgr's first gcm(aes) vector, so CONFIG_CRYPTO_SELFTESTS=y
fails at boot:

  alg: aead: atmel-gcm-aes encryption test failed (wrong result) on test
  vector 0, cfg="in-place (one sglist)"

Without selftests the broken atmel-gcm-aes is preferred at priority 300.
Seen on a SAM9X75 Curiosity with 6.18 and current mainline.

Write dd->datalen instead.

Fixes: d4419548dba9 ("crypto: atmel-aes - add support to GCM mode")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 drivers/crypto/atmel-aes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 50d97cef75b8..8e4de859cadc 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -1267,7 +1267,7 @@ static int atmel_aes_gcm_ghash_init(struct atmel_aes_dev *dd)
 	struct atmel_aes_gcm_ctx *ctx = atmel_aes_gcm_ctx_cast(dd->ctx);
 
 	/* Set the data length. */
-	atmel_aes_write(dd, AES_AADLENR, dd->total);
+	atmel_aes_write(dd, AES_AADLENR, dd->datalen);
 	atmel_aes_write(dd, AES_CLENR, 0);
 
 	/* If needed, overwrite the GCM Intermediate Hash Word Registers */
-- 
2.39.5 (Apple Git-154)

