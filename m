Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E9C356751
	for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 15:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779292638; cv=none; b=Z2bxW2cj/TArNp+RiKQYM7Dbnkd0MHifcjC94TDW5946nxEakngnSqXun+jWMMYbru9Zd7a477NB2rknF26QGgwxuLTDzXL+2kP1FiXsjzh1k3bCMLB0JxGHh+mEBiTUIgTHRNatFLe/2wQm92FfXtByZQklahVP2xu20YLlQns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779292638; c=relaxed/simple;
	bh=v9CpMoAoewso2fVLJ8cAOaQo1vppibb1dfPFCN/565g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TfNJ2owfcd3JWvLAeFfhMBjFL1Eb4kxE/7CfOSVv1zOYuW4YdqkQ7wT0Tm/XMiwkhTPxLjNN7mJ8p4ik/Vk4SUcplVCzbc6Jm+o9/7Lp3UR3JKZbAmuzaoFdTOZl7Mb73uvz38YsqXY9VDxZvG3KdErhp4fM2VCgYn1UAdwnaRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ftLL/bnK; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ftLL/bnK"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-48fe7a40e51so4129605e9.0
        for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 08:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779292633; x=1779897433; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w87C2HO3mgnApoyvB+dNnB4jQakb6mNAOv8hi/O/IbI=;
        b=ftLL/bnKqPEOhrRorqd+k6ADtKB8mzvdLQizkpPGQo8j8mBwGgJ/h0v7chZEOZahyj
         7pS/DaTNMzTzUNJs5Tkjir2YlJhi2x0rIaT9pE1Gv11O1qcsdQ19vbPAwBZleb3O/jjX
         5pX56bvzYeVnHyrLSfbyAU/2auU1ErODUZextq++Y/R2ZMzacKY++tc33x7NNd+nYFJh
         RlKCU0mmK70LUTW6O3rCs7snao+HyEze4Ms8Ux5PSbg2GZc/xTPoLdKTZ4AsZw8xlwg0
         eIOAnmPzOHvpwApz6ky9Lxt2LRgdkUDCzdWtpjfVe451wtq3AznYap4bROk1SZppcBFR
         rwxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779292633; x=1779897433;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=w87C2HO3mgnApoyvB+dNnB4jQakb6mNAOv8hi/O/IbI=;
        b=K2Y9SwGtTYKoNZ5P5shswXo5lDkR+Kwh7q56jlk0oQd3BiNZ9PdKpMfm9IRHAOHh3E
         hra7gvkjwsBIMS//bZEvUwjzwierh6DVusCR1GY7kINobat7ZkbZqr3pG2WBW++PDX+J
         5dAXnLjgObbPon163HU5A4jZ5r6gwMQ4UWBDFRZ/L+ScgHpQz1RaJbGq0PFMgoz023a+
         eQd3U1UeF84vmxgi01lwgYjoiJPoh+Df3uET2odjq5mmYJk3kRsUo3kIh7wTGZ4O9Uiw
         WeMYUTGIi4N58bYXm0nQO7uOpT5bZOO/Dx3JKB/OCFbWuFQ96uhe/XcB1LkmojdkDogB
         xsqg==
X-Gm-Message-State: AOJu0YxZEcZYjHOce8CHwADcAzR/BG1k5nHIt56AYuTnqlQ0jrFJy+dW
	piMyaqILa6Ngj7vQc0Nk+fjVkSgyfMF/32bvCx7uh0gBSXP1hcaJdiAD
X-Gm-Gg: Acq92OETAw+Jwa8L7iruN6CJcyuJKRHSZGBCAg5V61iHuCMWo7lCYspA4lZpPAlrK1e
	aH9vWCKJhppOQV+gmcs/Xj97QplqK5ybX5PPx5jiCzI3/5dX2kw8DXogqnEsWWHxW1RBID7PtMe
	teSK0H/8PFO1CRJ+azxQjc8llhgElHmHxX2Z7Iji1hI/Tuzg2F8Ii94RK/3LgR6G6NEFIIQay/3
	CEWzu86ZKB2AB8u6R3/WUSPUijb3AbKFwnkS1uv3IYtYcoxtiQXhKYptyAPFKiveAVI3l2eOkGu
	oE6Lrt1/YP6Sd67yjF5exRu1qHjYMX/yJkJOqyrc0K3zSGfqgDmdowS/sEFqs6PbOgE53x9yjF/
	A+3F8AszMINd4OvyBRdnLiPIPB/I+L9yaqTzwlkvrZ5BtWwMsOaR8TZXxDpkvq7lPr6cZ3ytNWP
	AWTDPIrUe/XPAQUOpTw+vVD02zl03uTStO8Hnl7Re2L53H2TaM1Ci3qIIB3AriCYTJvYxsQPe1l
	g==
X-Received: by 2002:a05:600c:4692:b0:48f:d410:6072 with SMTP id 5b1f17b1804b1-48fe6302a9fmr208044465e9.6.1779292632702;
        Wed, 20 May 2026 08:57:12 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48febe79ce3sm137216715e9.31.2026.05.20.08.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 08:57:11 -0700 (PDT)
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
Subject: [PATCH v3 03/12] crypto: atmel-ecc - fix multi-device kpp registration
Date: Wed, 20 May 2026 15:56:54 +0000
Message-Id: <20260520155703.23018-4-l.rubusch@gmail.com>
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

In a scenario where multiple such devices are attached, the following
situation may arise (finding by sashiko):

Device 1 Probes:
Calls crypto_register_kpp(&atmel_ecdh_nist_p256). The Crypto Core modifies
fields inside this global structure to link it into the system-wide
algorithm list. Registration succeeds.

Device 2 Probes (Minutes later, on a system with two of these I2C chips):
It executes the exact same line of code. It passes the exact same global
&atmel_ecdh_nist_p256 memory address to crypto_register_kpp().

The Disaster:
The Crypto Core tries to register it again. It overwrites the internal
fields that Device 1 was already using. This corrupts the Linux crypto
subsystem's internal linked lists, usually leading to an immediate kernel
panic or silent memory corruption.

Introduce a global mutex and reference counter to ensure that the static
kpp algorithm is registered only once by the first probing device, and
unregistered only when the last matching device is removed.

Fixes: 11105693fa05 ("crypto: atmel-ecc - introduce Microchip / Atmel ECC driver")
Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c | 56 ++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 4c6860fc3dd9..2f82f529228d 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -23,6 +23,9 @@
 #include <crypto/kpp.h>
 #include "atmel-i2c.h"
 
+static DEFINE_MUTEX(atmel_ecc_kpp_lock);
+static int atmel_ecc_kpp_refcnt;
+
 static struct atmel_ecc_driver_data atmel_i2c_mgmt;
 
 /**
@@ -332,20 +335,26 @@ static int atmel_ecc_probe(struct i2c_client *client)
 	i2c_priv->ready = true;
 	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
 
-	ret = crypto_register_kpp(&atmel_ecdh_nist_p256);
-	if (ret) {
-		spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
-		list_del(&i2c_priv->i2c_client_list_node);
-		i2c_priv->ready = false;
-		spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
+	mutex_lock(&atmel_ecc_kpp_lock);
+	if (atmel_ecc_kpp_refcnt == 0) {
+		ret = crypto_register_kpp(&atmel_ecdh_nist_p256);
+		if (ret) {
+			spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
+			list_del(&i2c_priv->i2c_client_list_node);
+			i2c_priv->ready = false;
+			spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
 
-		dev_err(&client->dev, "%s alg registration failed\n",
-			atmel_ecdh_nist_p256.base.cra_driver_name);
-		return ret;
-	} else {
-		dev_info(&client->dev, "atmel ecc algorithms registered in /proc/crypto\n");
+			dev_err(&client->dev, "%s alg registration failed\n",
+				atmel_ecdh_nist_p256.base.cra_driver_name);
+
+			mutex_unlock(&atmel_ecc_kpp_lock);
+			return ret;
+		}
 	}
+	atmel_ecc_kpp_refcnt++;
+	mutex_unlock(&atmel_ecc_kpp_lock);
 
+	dev_info(&client->dev, "atmel ecc algorithms registered in /proc/crypto\n");
 	return ret;
 }
 
@@ -357,21 +366,16 @@ static void atmel_ecc_remove(struct i2c_client *client)
 	i2c_priv->ready = false;
 	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
 
-	/* Return EBUSY if i2c client already allocated. */
-	if (atomic_read(&i2c_priv->tfm_count)) {
-		/*
-		 * After we return here, the memory backing the device is freed.
-		 * That happens no matter what the return value of this function
-		 * is because in the Linux device model there is no error
-		 * handling for unbinding a driver.
-		 * If there is still some action pending, it probably involves
-		 * accessing the freed memory.
-		 */
-		dev_emerg(&client->dev, "Device is busy, expect memory corruption.\n");
-		return;
-	}
-
-	crypto_unregister_kpp(&atmel_ecdh_nist_p256);
+	/*
+	 * Note, the Linux Crypto Core automatically blocks until all active
+	 * transformations utilizing that specific algorithm structure
+	 * are fully freed and closed.
+	 */
+	mutex_lock(&atmel_ecc_kpp_lock);
+	atmel_ecc_kpp_refcnt--;
+	if (atmel_ecc_kpp_refcnt == 0)
+		crypto_unregister_kpp(&atmel_ecdh_nist_p256);
+	mutex_unlock(&atmel_ecc_kpp_lock);
 
 	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
 	list_del(&i2c_priv->i2c_client_list_node);
-- 
2.39.5

