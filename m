Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9479C2343BE
	for <linux-crypto@vger.kernel.org>; Sun, 31 May 2026 19:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780255009; cv=none; b=fM3BvhJd97GXmjyBE1yQSHWrbCS9hkRw/0bgZzE0SZkmqIL9Xis04qqbM3frGCOM76aSzEVkcKvZgs2HJLNMXZLQrOXNTjH5g+rgd9/Uq3wJys3IRza71W4UYTlfDdeLTo7/O1prycb4PsV/H4P+Jvuuf8yGsWhYTAUTZqltTDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780255009; c=relaxed/simple;
	bh=1ORifjudn3n27M0D8NbXKnR5sFl2APv4g3bHEwJ9oyw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=AnHmUWm4LLGK3dfPTyldhm3k61mfOTuPxP39iYJzr6949CRB4WbQ9HQBOqBkLxW1IHZXaS/hfjPCLI8J8oWHjdUWSM3t8Ld8K7iEK0oaFxEiYgGHB0zClhy6G+jxtrXL3s2aTcAS9/Jx7aIGOpkjaDeXciEpippV/8LALTuF9hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k5XrwCir; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k5XrwCir"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-490a767521dso353025e9.1
        for <linux-crypto@vger.kernel.org>; Sun, 31 May 2026 12:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780255007; x=1780859807; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZLcDEufKd/fZiYywVbHN7RhFQw/ohUiqZvEj+O+eN6o=;
        b=k5XrwCirG24qqhw0MvTfH3LOlBNeFWjAFD6cEGnLAg1jSJH4G+/SMZ5wLVe1qDiSoh
         fIRweXGUrN8lPEvfePOQAC0GlePtplSHkwdViYgJsF0u3Hn5EIBpkFVJhppM4m3vbc71
         0fhGKferSQ8ipztu/91X1LHW9raw5Xn9r9cPfU7iGdZJ2GiRtExAm5FzMqQ3bQU8ol+i
         h7JvxJ5K73SNX/DtbwLWpKsulSpGb0WV2bKpM55cMWLhc/wFyrPYCBxZxEkmHj/NGhFk
         DW154UB1j6K3GwzDkDslnYXKkUPPuOFl8NWIZGVDboaQv49D+WziIsd+yo4W8EbcRhgq
         ZaVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780255007; x=1780859807;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZLcDEufKd/fZiYywVbHN7RhFQw/ohUiqZvEj+O+eN6o=;
        b=sO+xRPBMs60VeRdU9Q0W7fwG6aZQ9A1TgPA54EFz39Hj3vVNCan5qfiXVIgujgpL7/
         FYer8N26fKRj+dLSO1uasSFqlU8bHbhGxpGUBBjMMsWASqJj7xQvB6WoHdoC+Z5G78eo
         JWKoyVMlosjakGkML/DxF5AG3bTYFqXuGFUvuQIFoWDa1fsaO8HicvczSgYLLey4qVS5
         MwdNY6LYqc4X5ek1mlWbiDikSLfhuN7yTYZiwNmdlspvf0M3pt0YL0oZ2Tyqx1BNDQsY
         +5Ktwl8m/PjtK3HAor7uS2NgNyqozG092uLlhFU+mJPoQUHJkEw+AAvwYrFTlWDARrGq
         ZBlQ==
X-Gm-Message-State: AOJu0Yxiejo6evQQqERLUj3wWj8epzQk95NChy9gaUVl9dkRZ9j61hMX
	embZrKdkv5pcTyviN71DqKm6VpGmNAdLdKbtMJ0l9ym7+MeMQI/w+yP2
X-Gm-Gg: Acq92OHP1uf61hc17qQjLxCtkxNhmqYCjD7iwRkBwBdKh0XTSD6lwR3avzDkglqNl6b
	ElFypEBQeCgKhbeDrCRVeaAt4c2emqXyJlvKMXZ/m5wltTKgAN6s4/Od1iitKkCywQi8PiRQIGq
	Soh0ke6BTpoK8FPfSvk6DggwjHE94DTCMIU4IFDgJgcOADug906SWXNCBnNMeMTTd0PO9+BsXeS
	UuRc74zehX1r4NUlayDWgZS9x87VfcXFQ7HEFJGI2LNM4AKMKz5OlRlMdFzV4mRLBAKswPMkFcS
	XZyI41bYcPb2YY/PFb8SL+E9jbXTd6acpMLuO7xEOKj6g9TAqems1EeH1A6gnrQxEjRkVETinES
	BAzv6dd4BQdEc9nhzMwa6XaE4xsPyPCPXahxsBLStFSzQl2m0CmHsWDGJ2Z3w9CuBxAFEgjMPWr
	JxLat3Wier6SJtVTw298CjlqrQxRB8USL/wAsWo5I8RxP3dJr6EqbC8mQZ5U5dFEqdn5Zz3Phlx
	w==
X-Received: by 2002:a05:6000:4b1e:b0:45e:9520:d73d with SMTP id ffacd0b85a97d-45ef6bd3cfbmr5328250f8f.6.1780255006822;
        Sun, 31 May 2026 12:16:46 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef34a0674sm18142189f8f.8.2026.05.31.12.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2026 12:16:46 -0700 (PDT)
From: Lothar Rubusch <l.rubusch@gmail.com>
To: thorsten.blum@linux.dev,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	ardb@kernel.org,
	krzk+dt@kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	l.rubusch@gmail.com
Subject: [PATCH v2 1/1] crypto: atmel-sha204a - fix heap info leak on I2C transfer failure
Date: Sun, 31 May 2026 19:16:42 +0000
Message-Id: <20260531191642.33827-1-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The nonblocking RNG path allocates a work_data structure to track the
state of an in-flight asynchronous I2C request. This pointer is stored
in rng->priv and later consumed by the read path once the transaction
completes.

If the underlying I2C transfer fails, the completion callback is invoked
with a non-zero status. In this case, the allocated work_data is not
usable for producing RNG output and must not remain associated with the
hwrng state.

Previously, the failure path only logged a warning but left the pointer
state uncleared, which can result in subsequent read attempts observing
stale state and interpreting it as valid completion data.

Fix this by freeing the pending work_data and clearing rng->priv when
the I2C transaction reports an error. This ensures that failed requests
do not leave residual state behind that could be interpreted as valid
RNG data on later reads.

The explicit clearing of rng->priv in the error path is retained as a
defensive measure. While it may overlap with existing state handling in the
read path, the ownership and lifecycle across asynchronous completion,
read, and teardown paths is not fully localised. Clearing the pointer
ensures no stale state remains after a failed transaction.

Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A random number generator")
Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
Reviewed-by: Thorsten Blum <thorsten.blum@linux.dev>
---
v1 -> v2:
- Reword commit message for clarity and precision
- Keep existing error-path cleanup behavior unchanged, update commit msg

 drivers/crypto/atmel-sha204a.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 4c9af737b33a..20cd915ea8a3 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -31,10 +31,15 @@ static void atmel_sha204a_rng_done(struct atmel_i2c_work_data *work_data,
 	struct atmel_i2c_client_priv *i2c_priv = work_data->ctx;
 	struct hwrng *rng = areq;
 
-	if (status)
+	if (status) {
 		dev_warn_ratelimited(&i2c_priv->client->dev,
 				     "i2c transaction failed (%d)\n",
 				     status);
+		kfree(work_data);
+		rng->priv = 0;
+		atomic_dec(&i2c_priv->tfm_count);
+		return;
+	}
 
 	rng->priv = (unsigned long)work_data;
 	atomic_dec(&i2c_priv->tfm_count);

base-commit: 5624ea54f3ba5c83d2e5503411a31a8be0278c1e
-- 
2.53.0

