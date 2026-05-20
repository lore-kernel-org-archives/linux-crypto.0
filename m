Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB543546EB
	for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 15:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779292634; cv=none; b=p28kVNtV6IK4On70zQJE/ipaUB2yuGIMzzVOUR0fVza8t3fli9qsXlsvh8DuFmCj/dOx6w2GOx/hjyE9d/5i8DTYHhFsOpJxeYJsfT7NRbR+ZAaZPbTccVoTYUPja+irf5sBwuK9JoQ5tluPzNZq7cmK1lrSdHENTpYKyKbTJlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779292634; c=relaxed/simple;
	bh=lLAXP5B8iQxWueO/YFGp6YJLOvSNEYcvKWK7YpLnyyw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ocah6EOcinzUgSBTOTxnM2mFkbED1OrXep4UP7Jobc18ul6utOE4Q97j+FfKGiJeXF4cof6hpjEWY3+G1aq5lpUHgvZsbFoh/iKbJWpp4f3a2x7H4DOzB7MM3mgbEjPyYv3dnnTSjrV0C5McC3e8mXwIoSwzlrpWmUW88umBC18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VU/jObnd; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VU/jObnd"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-44a7c719151so315219f8f.0
        for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 08:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779292629; x=1779897429; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0c34ELoPJoazDfI83jDiunrFakmVLtTU4AFI7jrtuhM=;
        b=VU/jObndwx4XVgVxm86lrBkd5lQLZqdHxbu7M8JFFLjcyf4fKBBi1Kqy6EOBzywzCr
         /rb8VFZjfG91s3eRnQv3GScobbmNFRpcsaTEte809zkT05l/CjK+suWmKnNjKt1XxyQq
         t/Wu32gjkVdVxTBY7GmE2VkO8tlxpmXvTWSw7FiJAV9H7TrKs/eQ3Sa2En6ISkl1Ot/y
         8SzzfSFTF8avD5sqUXCUKsGBXyVvY5HzODcMNVpKtaaqRLvwob5ZcFOGsHfV4SodgcSL
         JqEhi+g3zVnZhz7+8TitL5podapOmAFVzHVR9soCRwA6vVlDjuGUmUmP5Ysx6nmMh02P
         4MAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779292629; x=1779897429;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0c34ELoPJoazDfI83jDiunrFakmVLtTU4AFI7jrtuhM=;
        b=XxIHpN0FsM3FPX5INyIuAfV+96gbX39Ubidylvmxq/aySayKFapZYr8/9k93flfEwc
         kP6FxuZl5P2zhViCn4ftU/aUKkoLzZ5L/pMI9MpEoqUycgsVQDv7SoMrOLPewFDXb1h1
         iW7p1zz6ZWw275UxI+RCqx6yI7C7MBYBa7Gl1EmZb5u9rRcch2pWu2BJj+rqailLWAoi
         T9HJaeyIUt0OJul2IaTpZDsRuR6HNzsuliI8yr5VchzvP7VBL2TtFvAlqMTHLbKAs5Rc
         s5XxaiuvhWxWqJAPYV2cahZRsp1plZiZpniBVSJ8G04Pyqvx3AA4xmiW1LCUc4Y5pEHm
         lJlw==
X-Gm-Message-State: AOJu0Yxn6rwBe+VqXqaQkLPU4qhSfyROtb7urdOG6oUaiXuVv981KZvv
	TeJGBF+BUjw0XjRyog+ZspszajwTfDWotMRVOdW8P65aMyrjgS2iYank
X-Gm-Gg: Acq92OFxqK3Bz/b1q0L662TG4lkFae1zXqc0EaJNfOjX4tuc/mySdpfOdnh7iCMV/mX
	UiZiBYDL/Uuv/4xq8sB4upO7XZ8MYhuUj0vimFEdHPNCgkkRfWuZ6e1xLUXjJmvyuwpnaXuwsAB
	hERkqtIpmOOBdXhJznutrwKOKbD1zo9dAND5Bpk7upMwLNCEi4KjJdKGhrwB7Z39JloqGJ2ArQQ
	6t5E5cPQkxBXTvVTj1blMuY5yacTKt7LuOCM5P6v5+OfFKjDbFkHg3jMaGbvStxxI8/PVVqnJL6
	aVzLk+kSWQRPDxkSpZps2dHJ5ofwMbkw7PVI6SUzYL6aNfyq0723fx6IeUuLPiSXL5y9tGVouXq
	QN2f2i12BfJ5EXbL5dZn0z/AX5jxSCl7ACSE04u/S52FD4I1Dy/91g8BRnyczRRieMgNlvcRkAB
	y7GwQdQ9AAd9VN5xk6YBAr0KKSHguk6qQhQJHrkaM99SbvtLYg82/FABe5M+RcQBE=
X-Received: by 2002:a05:600c:4692:b0:48a:52ce:a4d3 with SMTP id 5b1f17b1804b1-48fe63262famr211663295e9.8.1779292629254;
        Wed, 20 May 2026 08:57:09 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48febe79ce3sm137216715e9.31.2026.05.20.08.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 08:57:08 -0700 (PDT)
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
Subject: [PATCH v3 01/12] crypto: atmel-ecc - rename driver_data before moving it into atmel-i2c
Date: Wed, 20 May 2026 15:56:52 +0000
Message-Id: <20260520155703.23018-2-l.rubusch@gmail.com>
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

Rename the local driver_data instance to atmel_i2c_mgmt in
preparation for moving the shared I2C client management
infrastructure into the atmel-i2c core driver in a subsequent
change.

No functional changes intended.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 9660f6426a84..c9f798ebf44f 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -23,7 +23,7 @@
 #include <crypto/kpp.h>
 #include "atmel-i2c.h"
 
-static struct atmel_ecc_driver_data driver_data;
+static struct atmel_ecc_driver_data atmel_i2c_mgmt;
 
 /**
  * struct atmel_ecdh_ctx - transformation context
@@ -209,14 +209,14 @@ static struct i2c_client *atmel_ecc_i2c_client_alloc(void)
 	int min_tfm_cnt = INT_MAX;
 	int tfm_cnt;
 
-	spin_lock(&driver_data.i2c_list_lock);
+	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
 
-	if (list_empty(&driver_data.i2c_client_list)) {
-		spin_unlock(&driver_data.i2c_list_lock);
+	if (list_empty(&atmel_i2c_mgmt.i2c_client_list)) {
+		spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
 		return ERR_PTR(-ENODEV);
 	}
 
-	list_for_each_entry(i2c_priv, &driver_data.i2c_client_list,
+	list_for_each_entry(i2c_priv, &atmel_i2c_mgmt.i2c_client_list,
 			    i2c_client_list_node) {
 		tfm_cnt = atomic_read(&i2c_priv->tfm_count);
 		if (tfm_cnt < min_tfm_cnt) {
@@ -232,7 +232,7 @@ static struct i2c_client *atmel_ecc_i2c_client_alloc(void)
 		client = min_i2c_priv->client;
 	}
 
-	spin_unlock(&driver_data.i2c_list_lock);
+	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
 
 	return client;
 }
@@ -323,16 +323,16 @@ static int atmel_ecc_probe(struct i2c_client *client)
 
 	i2c_priv = i2c_get_clientdata(client);
 
-	spin_lock(&driver_data.i2c_list_lock);
+	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
 	list_add_tail(&i2c_priv->i2c_client_list_node,
-		      &driver_data.i2c_client_list);
-	spin_unlock(&driver_data.i2c_list_lock);
+		      &atmel_i2c_mgmt.i2c_client_list);
+	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
 
 	ret = crypto_register_kpp(&atmel_ecdh_nist_p256);
 	if (ret) {
-		spin_lock(&driver_data.i2c_list_lock);
+		spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
 		list_del(&i2c_priv->i2c_client_list_node);
-		spin_unlock(&driver_data.i2c_list_lock);
+		spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
 
 		dev_err(&client->dev, "%s alg registration failed\n",
 			atmel_ecdh_nist_p256.base.cra_driver_name);
@@ -363,9 +363,9 @@ static void atmel_ecc_remove(struct i2c_client *client)
 
 	crypto_unregister_kpp(&atmel_ecdh_nist_p256);
 
-	spin_lock(&driver_data.i2c_list_lock);
+	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
 	list_del(&i2c_priv->i2c_client_list_node);
-	spin_unlock(&driver_data.i2c_list_lock);
+	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
 }
 
 static const struct of_device_id atmel_ecc_dt_ids[] = {
@@ -394,8 +394,8 @@ static struct i2c_driver atmel_ecc_driver = {
 
 static int __init atmel_ecc_init(void)
 {
-	spin_lock_init(&driver_data.i2c_list_lock);
-	INIT_LIST_HEAD(&driver_data.i2c_client_list);
+	spin_lock_init(&atmel_i2c_mgmt.i2c_list_lock);
+	INIT_LIST_HEAD(&atmel_i2c_mgmt.i2c_client_list);
 	return i2c_add_driver(&atmel_ecc_driver);
 }
 
-- 
2.39.5

