Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D91C26E6E1
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 23:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779490914; cv=none; b=Ihs1iIyaMrSv/zRGlUUb1EYCa0efZZ7atd60/YpRZ/fCIC21+G/Z3UuqfLOjD7Y+lACh5kJyiTq4tVTJEQSN5sAfBZcqbqa64cAu8tdG14QI2TTy0+j3EsYT/yMvMtiXWENHOW1gVe6q7suG86bA+N0qjIdJBE6NJMKTEzaMhqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779490914; c=relaxed/simple;
	bh=lLAfj7LcfoRlLXCDmBp3fzB+hmnVRfZLW5UuPbQYpsw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aVObE7JOllM0XNaMozhCNUxhtLj+1RhEQcif7q44eS9+V/p/aLuPWe5w9Rnf2NyXfVQf9S/bAr0gP0p+qB3NFCcMi5mlxX5j5h+Crpg7qbQ6Gyymhv3WoRZwmWDG1gLjLVh2naIvDTRBut0iW2dh4aHprBzd3q2rv+qu+9/NSC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EDQTLb1D; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EDQTLb1D"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-490402da691so822325e9.3
        for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 16:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779490909; x=1780095709; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MSCRzF6jccIrpW3KuBs+JWgBL0z6wfFkzmIVCZCEAZo=;
        b=EDQTLb1DX9XO1KCn2z49CzSX7sf0eEy1ZO9Z9WYBkR6jHTqgjHULk/x1y86dfAMFhr
         e0CmSxlktBHveULUtYQmwn4YFKG9jTpY50rLJYxON5KnbtWPNq3O9+KeGF4ezRaZcdOU
         xfwZ2oE6LTXWMjW11jD7NPKkRMvWKRSuMqnwXzfsxukK1tnio/WFEH33rAmhPrQxT/Xj
         yblyLARY1EXF22kGWdQpr5owtmYWq0PQHqwmNCgJmADDthI844k9JMGOg4UQSqhjM8Y8
         olU76I+5xeC8+qz79+zYQl5amjkFrx+OlbHmd/IfvT5rEGs3UuGZR6LkNeWQx8ymTL9V
         VAjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779490909; x=1780095709;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MSCRzF6jccIrpW3KuBs+JWgBL0z6wfFkzmIVCZCEAZo=;
        b=UXMIcQul4ZWGMS19MzuOu0PZvjAdcGC4PgN5LynXG2fwRjAkM0bg4T4aBlYgM7cZ/B
         AFnihd9TG7PYZ10GNZbDRmvPCxJwkotKip7cZxvOf4XGZGfxmDnxRHXwSVedbSHCCsfu
         lbW546RyAgLnoxfnQXZZ6w1fNonLn5grKlzMFPy+QoVG3beZfnI1pAPcFXgv2a5UdaWe
         KFvb0gnamBUHW1EiQ5nMcaIehvT87xN06Bj7B+5Nfc7WF+Ry7qK76NnBh67speYSFqLp
         S4u5FcE7/zugj/VBpnFKsr2fo1IR0fwpZk/TiXYQyBXoxIqCVs7sHHLQaMxWhWTMJ9DQ
         a2ig==
X-Gm-Message-State: AOJu0YzKSpnL0UxFSA/iza0C+jDrKLbqOp7N7HJmtRLbA9iZz3hrMjjq
	ww7+8LDF5XOVB/mESRzngvckY9s58gNHInUGPFtHvIeXLGDOx4JqPHgg
X-Gm-Gg: Acq92OEGvcjKB7vjzofoeQf3kLgLZvAsXbfAOxTToSD6h2GHOnLcJjY1XEvAbp2Yin+
	3DZEUlrQ1cZ8/OETX2aiM3odaetLOMhvym2KtCCgAJLa6mED+nieXKxmxJ9kIepPoZ93FZzF3UW
	RxZTpIKU+Phd2l/g4HLZ6XCY68fM5gQf1cwGJ0/+mYyYSLOyWs+6NqSejDeDNksi4UZHyNzQSO2
	XR63Zw070NCmYv1yzzbz7WlGMlteNIj0RdS1ca/ea0TLgqkOkLjMnjSImC2D95hBci1UpU1dkPT
	Ano9zMmjhD4oGLZAUyBHqBs95AnZP0ViRSSMri3UzV8mTgj1VGfFet1JE61J0DY9Gm85CkjsbNw
	Z01UmQTDigewOuo4kBnOysQcI5KdrJNHwLo75YR2MddnE7ngK8pbf7ljUwbCcAYqP2bg9rC3OwV
	DDrx64dvPxeK5enXLjlzue0r+Z6WyPh5QkPGE1OzgXF9ZWSdBE3e/TjWwi0Xg8Vk0XOP26i4+qL
	A==
X-Received: by 2002:a05:600c:1f8f:b0:490:3cb8:b853 with SMTP id 5b1f17b1804b1-49042cf87abmr35801335e9.7.1779490908611;
        Fri, 22 May 2026 16:01:48 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490456274ebsm67100265e9.15.2026.05.22.16.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 16:01:48 -0700 (PDT)
From: Lothar Rubusch <l.rubusch@gmail.com>
To: thorsten.blum@linux.dev,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	tudor.ambarus@linaro.org,
	ardb@kernel.org,
	linusw@kernel.org,
	krzk+dt@kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	l.rubusch@gmail.com
Subject: [PATCH v4 06/12] crypto: atmel-i2c - move client management instance into core
Date: Fri, 22 May 2026 23:01:28 +0000
Message-Id: <20260522230134.32414-7-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260522230134.32414-1-l.rubusch@gmail.com>
References: <20260522230134.32414-1-l.rubusch@gmail.com>
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
index d6ae113c45df..1ae9c52812df 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -28,8 +28,6 @@ static int atmel_ecc_kpp_refcnt;
 DECLARE_COMPLETION(atmel_ecc_unreg_done);
 static bool atmel_ecc_unreg_active;
 
-static struct atmel_i2c_client_mgmt atmel_i2c_mgmt;
-
 /**
  * struct atmel_ecdh_ctx - transformation context
  * @client     : pointer to i2c client device
@@ -458,8 +456,6 @@ static struct i2c_driver atmel_ecc_driver = {
 
 static int __init atmel_ecc_init(void)
 {
-	spin_lock_init(&atmel_i2c_mgmt.i2c_list_lock);
-	INIT_LIST_HEAD(&atmel_i2c_mgmt.i2c_client_list);
 	return i2c_add_driver(&atmel_ecc_driver);
 }
 
diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
index ff19857894d0..a42b0ea30033 100644
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
index 660ca861b705..82321c35c21f 100644
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

