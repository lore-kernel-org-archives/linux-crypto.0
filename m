Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2839E3CC306
	for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 18:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779041215; cv=none; b=hl9Ozxj28Wk8Y/KvLs/W9nTkaV7GSEbynh9+g5pKE5MoPOiUbHCnGoAzVsD4AddaG4gIbiFXSCfNTAB0kWqd8u689AuasLj80OW6r0l8sCQpRviZKONJVWlrt1EqKKxamwbyOFp9AUOfcWr17kAluDcXrlnzJKr4su0pRevfvKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779041215; c=relaxed/simple;
	bh=TGB108/3SRJaFYr6xW5ZjsAyrgQw0VX100S2Wtzubu0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YEd+TghafSaiX8yEiroKUzstnpfwY7xh8E6pQi+2kVLpbsalS5HCTQVTUeFLsUJy1USwz/flAttKE7IraKSaLXWyAsz3ZrVkEzMGuUwukHRDvUh/UyY6aTdzcJR7BgpNeN4ZunfqAlw1uosZFQ9kGlmMlEw/aUlQV+7DJd6BHuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eQ2aw88l; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eQ2aw88l"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-488a8f97f6bso3337705e9.2
        for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 11:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779041212; x=1779646012; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LXDGFqKG+aLieN/ARyZ/nrrCa3/quxxq3chmprkLuVc=;
        b=eQ2aw88lfi1Ad/6mor3e5UgpeUfFmYtX3z2VAcFWb9VzAU45xHBp7RIv48wPzCrTqs
         mTJMHsYzRNoK0qodfYWBj1IEg8kEi9JgbOB0dmL+vtwqKel7FSHVj7haGauEVLDOpVE9
         FiIpCfRbV6ZF2C+0QVATqWbYypvMvVd9pioKw5ItvYH8gSkeb5UJiYbDpeeswFaECU9+
         yQINTMF/4sVNI9ZCaCyaJjLjJMlTfARJqI83VIaHZTtvr3fgiti3OOpv/Wc4M49NmxK4
         7fhH1F9rYFzgMjcLJvi8cQrHn8/G9S8PWaTBw/qTcIoFJbrf9Lu3iSE/0S9okHw+p1fi
         p/Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779041212; x=1779646012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LXDGFqKG+aLieN/ARyZ/nrrCa3/quxxq3chmprkLuVc=;
        b=kNekpNgRTyu/9N85S2YEDyxoKk/CvpvIPfLjCqqvPuVzbzESqWyAoPi8MS8NkM16Ws
         yyNZXZ90al6cMMfkMXFNxf+2UHoIweB3Hy9HrkYDCmoHCaH2WJVT1YckjxuBFsAUEr78
         HH0BfI71YAkWi+WSOWR82lIgAgWj+sqhWUoR2VV/3TYIPgadxSQMzhi020u95ZuL1mBp
         QTrHtpKsonKtYdQM+0FEMCmcy/317kXICZv5nGMm0AkqyvEBJcjmwTMrAJfRbhoWAGwO
         d/CbZIuzhh4FOwplnNH/WP3wNgUN8UNockxkT16hMFxKbqnxWN7DBm7BT1D6T6FIi7vP
         zGzw==
X-Gm-Message-State: AOJu0Yy/kOp7OHVe/Gg8wWgUaHLSzMPFDOcq//Gm9PZNtvuGEZH3viE0
	3FTucdygQ/ECbiRqqT6yHecs4cXpUD/hwuUwsXEYSv0WCGYmZwCwYVzN
X-Gm-Gg: Acq92OGxlXhfGGfVKa84TYWYGx9OadcNfWteIhDWXj5YS+2RGgJJPCMENoU0ytfJL4K
	T4W4pB220dH3FZ3rWPxcfG4mApPNvWqGLNr6zMrqCb7CIMbjVZnKhFkw+i23iZLWwjdqm5H4fOq
	IAqcE1rsJlv34e5IUV+F5roIVzaATUWBUPw8AAEYndpjnF/6a5aqo7bbQtNlcRDHTcHkEdC1YEy
	VklbIKd/JxcuLCO2weekSTXIg+7OZdcmM0iIEIwCrI9BfyTPLhAfkpw7gMpxjWG9+xe+e2tokG1
	JiCpiDsl7jTugi9w4HhvEK1gtULhpVZtZMt4W+L0onE+vasu/cMgwEWaFmS76HiRaVoxyE6jo1S
	1NORkCFc1osmY5P9HOPE+8+uP1xaukP6ramVBzFyx/OAEJrSLgynRB6BhS6hmSr5v3GTpQfd8+V
	DJTRWMGEve1wkqX/OZKkje3LdpsIW1jokGgbb2r82sRwzhrqBeHArsaF2bB29KmZOMTsa7WP9FY
	Q==
X-Received: by 2002:a5d:5f45:0:b0:458:3bdb:7eb0 with SMTP id ffacd0b85a97d-45e5c5dd4bemr8843390f8f.4.1779041212405;
        Sun, 17 May 2026 11:06:52 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da15a6454sm31766775f8f.34.2026.05.17.11.06.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 11:06:52 -0700 (PDT)
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
Subject: [PATCH 05/12] crypto: atmel - factor out i2c client unregistration helper
Date: Sun, 17 May 2026 18:06:32 +0000
Message-Id: <20260517180639.9657-7-l.rubusch@gmail.com>
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

Move the i2c client removal logic into a dedicated helper
atmel_i2c_unregister_client() in the atmel-i2c core.

Convert ECC driver remove path to use the new helper and
ensure queue flushing is performed after removing the device
from the shared client list.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c | 5 ++---
 drivers/crypto/atmel-i2c.c | 9 +++++++++
 drivers/crypto/atmel-i2c.h | 2 ++
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 696ab1d51fc6..e5dd77008b97 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -364,9 +364,8 @@ static void atmel_ecc_remove(struct i2c_client *client)
 
 	crypto_unregister_kpp(&atmel_ecdh_nist_p256);
 
-	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
-	list_del(&i2c_priv->i2c_client_list_node);
-	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
+	atmel_i2c_flush_queue();
+	atmel_i2c_unregister_client(i2c_priv);
 }
 
 static const struct of_device_id atmel_ecc_dt_ids[] = {
diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
index db24f65ae90e..861af52d7a88 100644
--- a/drivers/crypto/atmel-i2c.c
+++ b/drivers/crypto/atmel-i2c.c
@@ -354,6 +354,15 @@ static int device_sanity_check(struct i2c_client *client)
 	return ret;
 }
 
+void atmel_i2c_unregister_client(struct atmel_i2c_client_priv *i2c_priv)
+{
+	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
+	if (!list_empty(&i2c_priv->i2c_client_list_node))
+		list_del_init(&i2c_priv->i2c_client_list_node);
+	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
+}
+EXPORT_SYMBOL(atmel_i2c_unregister_client);
+
 int atmel_i2c_probe(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv;
diff --git a/drivers/crypto/atmel-i2c.h b/drivers/crypto/atmel-i2c.h
index a3385e8f0dc9..43a0c1cfcd94 100644
--- a/drivers/crypto/atmel-i2c.h
+++ b/drivers/crypto/atmel-i2c.h
@@ -190,4 +190,6 @@ void atmel_i2c_init_genkey_cmd(struct atmel_i2c_cmd *cmd, u16 keyid);
 int atmel_i2c_init_ecdh_cmd(struct atmel_i2c_cmd *cmd,
 			    struct scatterlist *pubkey);
 
+void atmel_i2c_unregister_client(struct atmel_i2c_client_priv *i2c_priv);
+
 #endif /* __ATMEL_I2C_H__ */
-- 
2.53.0

