Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033F63C1413
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 20:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779223697; cv=none; b=ql8jKw88cyj/D7WnNv8cgubrSRfn8GPdSdO0LOSH4efn+ISd2YLMtnf6qC21CkwPmoTfRFPmTOASp1tiHGmaBlPymPprgOFGBYnGwJcMql4t4mYHjaEDvoL85wtq8/crIc3aVCXqHmx4P7wo4MNlAVMN2jiYOpBS0PvSDX3pbw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779223697; c=relaxed/simple;
	bh=n9lDcJ6NRODaUwVmTb44LzgYHr0MCunslO6sOoEdyho=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=njLY3crVBEdfNKSbqM3swTxxfRLYAayhA51mnRGPOhZaZlYQfBL08ojmk6ffxZCozHQYZoC7ntIr1W4ZfOfxJzRJvy7U0Y0mODjCA/6q+ac4knHO1IRKl/G8DwWdHKophg+hgz8fY+kOvU8WCTRF2cRxPtVfHfw/iguiyg2GO60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CNJvfl6h; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CNJvfl6h"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-44b7e8b65faso207714f8f.1
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 13:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779223694; x=1779828494; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dlj4B3tCS1LCg0o2cK8faWQWBMDw4ejqDx0TgeFPOz4=;
        b=CNJvfl6hTHdvhS6aezn3nTjeyRiDOFimElH/2kS6AqFqi/N9+FbFMhG/B7KntW6fNA
         Tt8DW/yez08PyGy6HGZTO7Lb0zAvWP82IPgx97TkMo0dCCv4cuEcEBI/ba//5hnm7l0u
         t4KuJk7Bedw7CAh9tZrPKX8Ktuwmsjdpr5i4sXACFlebt2phaHmGhKVgNqkayIvzy7Zd
         qQLS8B3wNG7RNGOrq9rqripAeon2tPHXGml49j9IZte5q8jh6sIHk0bysvUA4qQBrK/Y
         8kk2Du91GLqA7MGu5dy4UqBA5DRrBEIwPZLipPmwXGl/XXwBfpIV2JbcMz74DxbP6Y3H
         R4tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779223694; x=1779828494;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dlj4B3tCS1LCg0o2cK8faWQWBMDw4ejqDx0TgeFPOz4=;
        b=T7W9PUpBmaWm2BYQqC+ord4f4nTSEzQdKqOgzfaEXE6fv+JC951YhSVCdPGg7n1GEd
         9tZoK5mShBQts6LLVEeKlm/1Fd++zHDeOG5YjJK2WoS+JEjNo6TZE5PSr0jbv1YH1SSL
         ickK/q4Bm553PhV6LOHSVayJRqbY5ieJ4YA9v0C6lFfg8lVS/k4xpJUgqMNJq186AVMF
         /jYDgJH0c+jaRSqKlFPDext3l8WtYapufG2rERXerU1/kitr86i0XBoBPm8nQ9P70lxt
         /VO5ys3rprc+Q1W5LPlBiIi/MhQsKF0IYCJUOl/Ti4VYtMTJ4Rbkh/mbJrYg0sNOQ582
         ck3Q==
X-Gm-Message-State: AOJu0Yy8/gdAF/p5euD4wVN8gxDGZGFtuw7ze3tOtqMTTRPUDug1u8rf
	5v3yZg/AS4+r8twzzRd3eDd6Xy3KqGnJ4C30MnMoCCl1qR/XUAXmG+8U
X-Gm-Gg: Acq92OGZwz4YUZs/2XFuGwBhp8QuthkNJXS3mIF7VUBQAC0vSrvBVDMWctfjGf4BY7u
	sG+zq98DzAcO4GLk5s4aejz5RBve8O+EY01xIkNI8TTHEB5+77GBwDhqgv1NxCM/fz6/UVHH2VR
	Alyt2Nxp+RCoFIsAmSq9sMjCUPjumuzlXgi1OQQqQqXFw82ALZ10GwtrkhmqhxHr7Gs36ha93ep
	1rNeIlj+2mRGZAGaL8GOOfC2Wj8eVT9d2GTOXXkT5GBmyfRbcEeXWF5B+NyFzIYgpb5Lfn4VtZl
	CawSevOs3NzWNeHGzurB4dLX69p2Pnksq0psVwN9dOilp5gZllbySr2nXwbSHEncHs1cGWVfhgc
	ijqjhY7WjkyD2e4Ou6cq/QGO78vTdHleBB6quG5upBNK5uabpuJ/NzBtntKUC5rYRWCKdvrTXr5
	2bRe8T7Whgvr9TjjKRTAFJUqafZ4VAwNWPTSf2E1IfmiYimOpcK5HJX5fNuHbIiw0=
X-Received: by 2002:a05:600c:3ba5:b0:488:7e7b:dbc2 with SMTP id 5b1f17b1804b1-48fe61f7b16mr195362275e9.3.1779223694200;
        Tue, 19 May 2026 13:48:14 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe4dac000sm356457755e9.0.2026.05.19.13.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 13:48:13 -0700 (PDT)
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
Subject: [PATCH v2 05/12] crypto: atmel-i2c - move client management instance into core
Date: Tue, 19 May 2026 20:47:56 +0000
Message-Id: <20260519204803.17034-6-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260519204803.17034-1-l.rubusch@gmail.com>
References: <20260519204803.17034-1-l.rubusch@gmail.com>
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
index aa2dde99b2b1..33b90667c872 100644
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
@@ -411,8 +409,6 @@ static struct i2c_driver atmel_ecc_driver = {
 
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

