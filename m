Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA76355F5C
	for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 15:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779292642; cv=none; b=KVekuNqdttWxzpC+13E2lg0UAWEVA2W6TGxgbLWqqyn63bVyn+KwbQXX6XvPspCUzXD6VZNNTe/Ywj4VUtg4OHcSwj8OJUXxH81RICBygDjN8xrOUOE7RunE2NkQM2QtPR6jM8e9gETpAaiQuIDz5JDnTgQz882nQHwiYcumI4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779292642; c=relaxed/simple;
	bh=pB3QjDyEEv7fGjXAktmlBZ6uAXjw+PIbYSUsDa3H3ds=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lr0nXs+doTQQE23eMinhfWBMffqYHXgsFKpr9KRvGy8uGYD+0cneooxJSP6Zpc9yz4WLIc/KJ/s0/h/lBNGVcIulN4B+WZSAAvABMfuwmD+V/UaT4DLPGeFCfa0dzuXxAnQ2xqT6ajwxwuUV0BPfORvjN/ctJ59yARO0QwaY/e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g9QgoLzl; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g9QgoLzl"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-4493cf2f982so362483f8f.2
        for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 08:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779292638; x=1779897438; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QwQ7nKFRuRlu0LJRik1dF7YG3UyIAH7qsByZKNSFesc=;
        b=g9QgoLzlnHyQXsC9iz2bUsV5Sa1GYyUd+WRR8GDWntF1zl4a7cyHI/H3Mc1pd6arfS
         CoCI7PIHawfy7e4krO4s8yJ2tuKiyh6vtlTOGapbEucC5oswNa3Eyu6JPab3h+wGfw56
         CSd+eXPCaHNPWgVpS2yLoCK0t7LDbEPYlnN3B9qE9x2QCYEIfvKNrHVZYYNtVd20NHhW
         K+wpxjSrB7KLnhuuUZqVJ6ytwnlBF2RJxmZPWnGBTdii7NvhSh9GDMJAaD/4mZSc2qQE
         WSx5glea22zSuUhm3CBhaleEVjZHbsWHW0dhtn31ruyVoy1qcusaGxC0SkC/v72Vi5aP
         WAYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779292638; x=1779897438;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QwQ7nKFRuRlu0LJRik1dF7YG3UyIAH7qsByZKNSFesc=;
        b=rkxDRVc8RIlTI2l7iBduF3PNzYMnQagtJWhOUl+KJp3rAoiH5ssGSUryVf8ysspAMe
         WDcOMS27bQL5Iya4iC4FqxhLgRcNtPaN3ehiKX4Xni16t1pbJo5ZJ8cw3hTxTMZ79GBn
         TSni1xC2OTUADVAnz5WEBpumDn4CuKwpzB2opxPc0QrekA7Co40K1GwmI3QwxNkDRTaF
         QEHk8QX6hkRo1T68mMgwqY/uWyC4OV410uLMafEmYnMnxFtWRhZhwaVhUg4wGsrWdMzl
         sL98TjbNlVNXsmOuDhsIgRw4rqKztXUme9ZkaivcDmLuPC4L5rhhLkmLd2TjrB/h5hsX
         +aBA==
X-Gm-Message-State: AOJu0YxrXU/cJmlyH4lCcGLW6qHQAqT9jgP2suPRrDyhTzXUMjlAU7T3
	sfRFrMovjvIuI63otQ2uoWVtjaexmuCfvVo74eIsdpE6kpv5RV0loNH4
X-Gm-Gg: Acq92OE1gRGkn0koVZgawTbJFSuwc8e++02Rd9NjYYUZrqS3VFvYwJCOW6CvDeTPAhE
	XMenG7AA/BUF8jQbdTDWuCJnwXHe0vpY9xNr89sRi+VutRMq7ilD81CsSOMrhzLYIaSmuT59JdW
	NWry3d4xmZT5kprIUAfKe3XgizEcA+Z+XWvne9Mzobo8V7oTulnJjdKrq9unjLfERuwGdqa3OiR
	ZnZUWn1dJ43zJblJKUK4/7tDbk2lK7V/PRcj3u4aRibpCrEqIkAaO/dREfCNlb45zPRMhZlr5ko
	REDR93GJwq85EeW8qZ17yjxT67eMe2DD53E2ySe8IXQMecJlU6wVWkmfp9L4D33r5j0ynRQRX4S
	vUGyVabCVxi9Cseof0eE8MWqemudM2FJzeB3sRYV6oblYmLDwShz5c0cfIgmCpwzB6MAe4Jjv6B
	ZUVQySwRGbWPh5ofEixVRBx2VAcYfxXyK5nrPGaxb3+gXRV57DXQjfRMvuCNBLm9U=
X-Received: by 2002:a05:600c:1f8c:b0:488:abe9:86 with SMTP id 5b1f17b1804b1-48fe631817cmr186005145e9.7.1779292637515;
        Wed, 20 May 2026 08:57:17 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48febe79ce3sm137216715e9.31.2026.05.20.08.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 08:57:17 -0700 (PDT)
From: Lothar Rubusch <l.rubusch@gmail.com>
To: thorsten.blum@linux.dev,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	tudor.ambarus@linaro.org,
	ardb@kernel.org,
	linusw@kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	l.rubusch@gmail.com
Subject: [PATCH v3 05/12] crypto: atmel-i2c - move client management instance into core
Date: Wed, 20 May 2026 15:56:56 +0000
Message-Id: <20260520155703.23018-6-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260520155703.23018-1-l.rubusch@gmail.com>
References: <20260520155703.23018-1-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the global 'atmel_i2c_mgmt' tracking instance out of the ECC driver
and into the atmel-i2c core library.

This change consolidates the shared I2C client infrastructure into a
central core driver. This centralization allows both the ECC and
upcoming SHA204A driver modules to access and reference a unified,
common device-management context.

As part of this relocation, replace the explicit runtime initialization
calls inside the module init block with static, compile-time macros
(__SPIN_LOCK_UNLOCKED and LIST_HEAD_INIT). Export the tracking structure
via EXPORT_SYMBOL_GPL() to make it available to dependent sub-modules.

No functional change intended.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c | 4 ----
 drivers/crypto/atmel-i2c.c | 6 ++++++
 drivers/crypto/atmel-i2c.h | 1 +
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index b06d47babd2e..cf6abc94d6c9 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -26,8 +26,6 @@
 static DEFINE_MUTEX(atmel_ecc_kpp_lock);
 static int atmel_ecc_kpp_refcnt;
 
-static struct atmel_i2c_client_mgmt atmel_i2c_mgmt;
-
 /**
  * struct atmel_ecdh_ctx - transformation context
  * @client     : pointer to i2c client device
@@ -408,8 +406,6 @@ static struct i2c_driver atmel_ecc_driver = {
 
 static int __init atmel_ecc_init(void)
 {
-	spin_lock_init(&atmel_i2c_mgmt.i2c_list_lock);
-	INIT_LIST_HEAD(&atmel_i2c_mgmt.i2c_client_list);
 	return i2c_add_driver(&atmel_ecc_driver);
 }
 
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
index 30ed816814af..d54bd836e0f5 100644
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
2.39.5

