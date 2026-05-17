Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165963CAE73
	for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 18:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779041216; cv=none; b=DGextEWaYL/CX54fLITChmm1NdS5pcymToubMU2+JrLp1OS6l1n18DWzot5f+rdaQTIWX1h0WQq5my769GB0yQbu1V7DMtzrsAckzOgNVi5vPBrCFZR7yACT6E3o58nDHa/IZyP/4Rg+SjpVtjwP3ZwqOsAMjeVCh6QibCfXtPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779041216; c=relaxed/simple;
	bh=tOlpY7+pgix8ajT4l6fawfigNBi08GuxJz9tAv22Jz4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CBN05RkqbHU+dORcy0+lazCK8lwcDFl95m4qDFuq0psM1FY2gB+Tm5jhogzfsoTzw3EX86KsSgbuNAEAQrIq/6PvDH046Ebr74eW6JEO9O8L3y4njM8YsMfzbG6PtQ+H4L79mjcqj8arI9ukX4yrgcz3Y0s1lerwtEX1AbfUtxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jHyENnX2; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jHyENnX2"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-488a8f97f6bso3337675e9.2
        for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 11:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779041210; x=1779646010; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lfAxUEr/rxn6pVQC4AetRpAM4gvdUnHJSPOgS01+IHE=;
        b=jHyENnX2SjVaDcg37C8bTx8Rsba7LinfZ8p+40/x04FHjmJ3GUwQS8qLKkD2wSQ6xX
         Mtj+rnqgcB9RB1KBhCAti/r5VUNYzEmRruttC5/YZs3M9ueBHCB2uEgpcOQW8arkUcKR
         x0wiHCQS+hRc1MKVTstmGSSKy1FQuBKuAYo9QEktG9BBE1cF7Q4uq8BAJTES+A4SZdUr
         Q0oqw3lTFskrdh8Y1iLJLofZBJp6uinT51S3aqylrObMaEgkIn4ZcZ09XMbPibRY2k1Y
         affBW5EU3EYtBQo02oA6c+XLGiQNVMjpiKbssO2dkqe1f/lHwQdSuW+he6q6zauczXIY
         1pOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779041210; x=1779646010;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lfAxUEr/rxn6pVQC4AetRpAM4gvdUnHJSPOgS01+IHE=;
        b=htCtZcjAxAYioe6AlZCByt0dNq40Svz7BDn1arxGTsX4Nbnf0X6n8aI7RT/jAM6Wet
         ErkPRSrWau2EuX6pDQ6LWWJ4T8XL3hB45QvBAVZdc8Kx7EvzvR0ifgdCrZNek4H1L94i
         Wm6E5T6c665yXYqwmW+RCbJTXindI3pqFgvNuGWYXD6GsLIXxGg6QjgpHxKGAh0KAN0N
         4sUQYiVR3OCUlo3fTaBNCJ9hdN7BCkb0JLKsnTquI2Y6b2DtVq3Dg3FXMyyIvuupdXDE
         CdQ/1sSU11udACAXrEa6nLrppMFe0g66yU4ee+wc2JvIUud+OPQXqynmW/WsVYwiUkah
         OUdA==
X-Gm-Message-State: AOJu0YzO1Pz4sVQRTzOit5oZBhXntytA6/UVJxClD5GwWNAjZC0mn+BY
	K1Lh7pic20gA6JDrw3Kv63Dbl2KyvNE2vabk1BfGq3+pw6h6al7QOwlV
X-Gm-Gg: Acq92OFPVT945MmkS66nLaS8yXKi1eDnp4LetY43Vd5gKEcxkz+yQoOPyf1T9em+/Ra
	dPM2R0JuGg8GZNE3dLux3X2u8J63lvuh/GNdjracLEy01Ab2V+juZQU3A4e9SWVn7+5ZTBQbHVb
	IBH4OyOkxeJnUFxKigXJecH4EpNYIihWo40gTItPm5fPCS5ZNbKT7xGD0COwB1FEk+IRZyh4Ndh
	APPLtFTNUJPd6BilhK9dLkLkSxyKb8xwWOne4I4SICPfYQNfqe6A+rhalvOfI4ObYhORKZmNsU2
	O0576Unvucw9Qb+Ng9DIKPu8Ce/hSuM0vOcNx89hWGWgAJiCVu0/37lMlSxasvjo11clJxPo+8/
	A4uL+FYfI+CMvCrRLYyOV+YItT3Aj0LrAUNg1vaIQW1FLYm3BzQIQwixYTcg+EfDmmji2OrV420
	scy/XeB7670qe1+i+ZSQXhPTw0KM1zwCw62ukry6CN4PRY13QEi1ZcEEpCGVY9GgGBZSat5Rcn9
	w==
X-Received: by 2002:a05:600c:3106:b0:48a:58e1:6cf7 with SMTP id 5b1f17b1804b1-48fe61f2bdamr81852815e9.4.1779041210437;
        Sun, 17 May 2026 11:06:50 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da15a6454sm31766775f8f.34.2026.05.17.11.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 11:06:50 -0700 (PDT)
From: Lothar Rubusch <l.rubusch@gmail.com>
To: thorsten.blum@linux.dev,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	l.rubusch@gmail.com
Subject: [PATCH 03/12] crypto: atmel - move i2c client management instance into core driver
Date: Sun, 17 May 2026 18:06:30 +0000
Message-Id: <20260517180639.9657-5-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260517180639.9657-1-l.rubusch@gmail.com>
References: <20260517180639.9657-1-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the atmel_i2c client management instance from the ECC driver into the
atmel-i2c core driver.

This is a preparatory step for consolidating shared I2C client tracking
infrastructure in the core, allowing ECC and SHA204A drivers to operate on
a common management instance.

The symbol is exported via EXPORT_SYMBOL_GPL() and declared extern in the
shared header.

No functional change intended.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c | 2 --
 drivers/crypto/atmel-i2c.c | 6 ++++++
 drivers/crypto/atmel-i2c.h | 1 +
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 9feae468b7ff..76fb1d0cf075 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -23,8 +23,6 @@
 #include <crypto/kpp.h>
 #include "atmel-i2c.h"
 
-static struct atmel_i2c_client_mgmt atmel_i2c_mgmt;
-
 /**
  * struct atmel_ecdh_ctx - transformation context
  * @client     : pointer to i2c client device
diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
index 0e275dbdc8c5..db24f65ae90e 100644
--- a/drivers/crypto/atmel-i2c.c
+++ b/drivers/crypto/atmel-i2c.c
@@ -21,6 +21,12 @@
 #include <linux/workqueue.h>
 #include "atmel-i2c.h"
 
+struct atmel_i2c_client_mgmt atmel_i2c_mgmt = {
+	.i2c_list_lock = __SPIN_LOCK_UNLOCKED(atmel_i2c_mgmt.i2c_list_lock),
+	.i2c_client_list = LIST_HEAD_INIT(atmel_i2c_mgmt.i2c_client_list),
+};
+EXPORT_SYMBOL_GPL(atmel_i2c_mgmt);
+
 static const struct {
 	u8 value;
 	const char *error_text;
diff --git a/drivers/crypto/atmel-i2c.h b/drivers/crypto/atmel-i2c.h
index 98a79dcae2b6..a3385e8f0dc9 100644
--- a/drivers/crypto/atmel-i2c.h
+++ b/drivers/crypto/atmel-i2c.h
@@ -119,6 +119,7 @@ struct atmel_i2c_client_mgmt {
 	struct list_head i2c_client_list;
 	spinlock_t i2c_list_lock;
 } ____cacheline_aligned;
+extern struct atmel_i2c_client_mgmt atmel_i2c_mgmt;
 
 /**
  * atmel_i2c_client_priv - i2c_client private data
-- 
2.53.0

