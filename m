Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A32366566
	for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 15:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779292648; cv=none; b=A1z/LymHTkTbA78Ersgz00yNvJ+SPfBU1UGrJEpx4bqmSzbN/VRhqVX99NmuZORuHLC49vKqRBJR2ioOznuSBLaPg/lQrOiwHUPU0FrkYt+Oj5qjX6+pQFXVJmjCrGSGs13q/syQTY7+uNXlbQ2FUTlEbDDU6YBWgcjd7oIsdxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779292648; c=relaxed/simple;
	bh=XF6myLGOHXFEV6F9jGpi6se203QT+R1jon48xdKDRd8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nZ3Q0pP3DL2XNpoOd90GrM9kSMWcpGrdpMvpL2eJL83zUlx9R7rZqw3VV2/xAokNGpe7QXU1JIBSkrVfOe20dSqhvZ3+cmtD4d034giHAJOPHB599Kgfy4VruRBfaas2mduvc9FwziGMsTORG9C8BoQ3pDnXG/pmpRoWboWIsqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WSL9VekL; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WSL9VekL"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4889d0a9df0so4154395e9.3
        for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 08:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779292640; x=1779897440; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pMbnbZ8Nz1p+R9q/BNLPx2BmIZnFVuHesrx4qEEwkQQ=;
        b=WSL9VekL1I0eRe8QjSTW1ixk79lmHJyXWHDmMxxHJAbtrWonO1WQ+dXr3/mlGswhKd
         3hA+wwv0HHCXMFjMYBZBwZcIsqMk/8ooPYx9R7roRjLulhwGXhfEqtV5O/uOrGY8KuTL
         8uHiYwRvz+EGGn1W2RRJ0bUfMbmwMNC/irHJWRAqLw3S1fzZ/PYrwSOzA0QWK7TRicZ8
         Lyq7gt/YqBRRWP4nKKLbdtF7THU/rr/Ik4rtySffJcQb6wjfLNZIZJlGcehvI9eRXWGO
         rndmuZ3myhM9inPLZxYCEa2fVVbyjr/QSQ9O0hGPdP9Foj8tkp39ND/zyYsY917F/Fy8
         7aOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779292640; x=1779897440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pMbnbZ8Nz1p+R9q/BNLPx2BmIZnFVuHesrx4qEEwkQQ=;
        b=jc+YFql9w4aM2hAIVtQrQF4WoOeOxzMPsk9PiaYtvpXn3vmFtlXs0VJyg38cMnR6GP
         02bv0GafoH9+w4dAoaS0H1+niS0r4mxTGg7twmewuVc4PVVkLkfAyFnUTsxB1qyiZI8m
         RCKaSkuux62bMZoOLnjQeE/OyRDT9k0Yq25Ir1Sg+YMgLH+EAmIQqaVVzfjh4I0IULhJ
         2QML1JmjAc2Nb0RfG5NqaH+yYhhb2RvdGZCML19slWoMAQJgTYM36pHSIoMUKk2T3eCa
         jWKhg8nTlluGkHD/wVT4MTHXBmg6CEqUr2yCAWL2+VXlUvT4qXyb7NUOTukjSWlE8sLo
         FR8g==
X-Gm-Message-State: AOJu0Yz01O0Q1NoTIhJQY3WFHWQKEGIFQYx150jEXL+92d0E7eebdmJV
	/re4kcw77wHWXIKym5QqXjl4ziR+Fe0awRj/HvyCdMzENaKqebiJHn+O
X-Gm-Gg: Acq92OG/yU6dOpTEExO1M5QxdESfVMV0ZAH2cCw0rLNyNbpUxN/S4Od4TOMiJQPuyOY
	szzU5QN2ruqaKZs+VfnW3l+SNtbY7C8LKXJrc68ewyvJZfD4I5zjrx6xcFTLXhA+M+OVrs+oysv
	xbZ9w9TPSpEYGBzreeRbZzaV0jYSfYdX0QZSxb1UsGuciIinAJkJNuNRxkr1WHIkt58R4UljqZu
	qvLCRyRhgoEnF2VHe1wgIkgTgJBGSVGfQyJneQvwfaFfw7scdVQoRut21asZ1IoCv+dIPwT1MTO
	mGvLqJRgzXcZTgzz1yDpl2Dn+453zREFtJUVGihly2pUs/cR5oJgvnzGnYG6qz/LGplv/7vxVJZ
	bSoDLCeTVTJFIP0SmhBPkcKQqs7/yw5xWpaQrYr+iW91k3NsIo0fZt1RDx81smGq9sICZpZExBd
	BFP5pZ64b5NrJoQnfkKln0wuOGlYmnIC6IdNoQvdzQ/5knR7Wroq3y1/lYXeOBnPJXMKaUY0NH4
	g==
X-Received: by 2002:a05:600c:4513:b0:48a:5501:799a with SMTP id 5b1f17b1804b1-48fe664c27cmr188890905e9.5.1779292639549;
        Wed, 20 May 2026 08:57:19 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48febe79ce3sm137216715e9.31.2026.05.20.08.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 08:57:19 -0700 (PDT)
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
Subject: [PATCH v3 06/12] crypto: atmel-i2c - introduce shared teardown helpers and fix queue flush
Date: Wed, 20 May 2026 15:56:57 +0000
Message-Id: <20260520155703.23018-7-l.rubusch@gmail.com>
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

Introduce atmel_i2c_deactivate_client() and atmel_i2c_unregister_client()
helpers in the atmel-i2c core library to modularize client teardown. This
encapsulates common client state tracking and list manipulation operations.

Convert the ECC driver's error recovery and device removal paths to utilize
these new helpers, ensuring consistent execution ordering when modifying
device-readiness states and deleting linked-list nodes.

Additionally, migrate the atmel_i2c_flush_queue() call out of the module
exit path. It now runs inside the core unregistration helper. Export both
new tracking symbols via EXPORT_SYMBOL_GPL() to match the existing core
driver licensing standard.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c | 16 ++++------------
 drivers/crypto/atmel-i2c.c | 20 ++++++++++++++++++++
 drivers/crypto/atmel-i2c.h |  3 +++
 3 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index cf6abc94d6c9..433f40224be2 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -337,11 +337,8 @@ static int atmel_ecc_probe(struct i2c_client *client)
 	if (atmel_ecc_kpp_refcnt == 0) {
 		ret = crypto_register_kpp(&atmel_ecdh_nist_p256);
 		if (ret) {
-			spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
-			list_del(&i2c_priv->i2c_client_list_node);
-			i2c_priv->ready = false;
-			spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
-
+			atmel_i2c_deactivate_client(i2c_priv);
+			atmel_i2c_unregister_client(i2c_priv);
 			dev_err(&client->dev, "%s alg registration failed\n",
 				atmel_ecdh_nist_p256.base.cra_driver_name);
 
@@ -360,9 +357,7 @@ static void atmel_ecc_remove(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
 
-	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
-	i2c_priv->ready = false;
-	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
+	atmel_i2c_deactivate_client(i2c_priv);
 
 	/*
 	 * Note, the Linux Crypto Core automatically blocks until all active
@@ -375,9 +370,7 @@ static void atmel_ecc_remove(struct i2c_client *client)
 		crypto_unregister_kpp(&atmel_ecdh_nist_p256);
 	mutex_unlock(&atmel_ecc_kpp_lock);
 
-	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
-	list_del(&i2c_priv->i2c_client_list_node);
-	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
+	atmel_i2c_unregister_client(i2c_priv);
 }
 
 static const struct of_device_id atmel_ecc_dt_ids[] = {
@@ -411,7 +404,6 @@ static int __init atmel_ecc_init(void)
 
 static void __exit atmel_ecc_exit(void)
 {
-	atmel_i2c_flush_queue();
 	i2c_del_driver(&atmel_ecc_driver);
 }
 
diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
index db24f65ae90e..cf3c57745414 100644
--- a/drivers/crypto/atmel-i2c.c
+++ b/drivers/crypto/atmel-i2c.c
@@ -354,6 +354,26 @@ static int device_sanity_check(struct i2c_client *client)
 	return ret;
 }
 
+void atmel_i2c_deactivate_client(struct atmel_i2c_client_priv *i2c_priv)
+{
+	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
+	i2c_priv->ready = false;
+	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
+}
+EXPORT_SYMBOL_GPL(atmel_i2c_deactivate_client);
+
+void atmel_i2c_unregister_client(struct atmel_i2c_client_priv *i2c_priv)
+{
+	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
+	if (!list_empty(&i2c_priv->i2c_client_list_node))
+		list_del_init(&i2c_priv->i2c_client_list_node);
+	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
+
+	/* don't sleep inside spin locks */
+	atmel_i2c_flush_queue();
+}
+EXPORT_SYMBOL_GPL(atmel_i2c_unregister_client);
+
 int atmel_i2c_probe(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv;
diff --git a/drivers/crypto/atmel-i2c.h b/drivers/crypto/atmel-i2c.h
index d54bd836e0f5..351306c426aa 100644
--- a/drivers/crypto/atmel-i2c.h
+++ b/drivers/crypto/atmel-i2c.h
@@ -192,4 +192,7 @@ void atmel_i2c_init_genkey_cmd(struct atmel_i2c_cmd *cmd, u16 keyid);
 int atmel_i2c_init_ecdh_cmd(struct atmel_i2c_cmd *cmd,
 			    struct scatterlist *pubkey);
 
+void atmel_i2c_deactivate_client(struct atmel_i2c_client_priv *i2c_priv);
+void atmel_i2c_unregister_client(struct atmel_i2c_client_priv *i2c_priv);
+
 #endif /* __ATMEL_I2C_H__ */
-- 
2.39.5

