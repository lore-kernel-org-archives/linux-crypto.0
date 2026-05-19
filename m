Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5613B38BB
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 20:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779223695; cv=none; b=U9D1LW0mzhIfoQQtlPgCX3TBw1y8pmYWXoh9SOhmKO4h+fNzMMF0IDIqDCBMu4PdTu7uHFwoDQGK3lzNDIOtlwexXytnP6/WFGPWKsn/7NSs8hRL+9OgiD8/pbquf/umugXDgz6lkou/dnQw1QI5UwxlTOukzQhbMl9e8hlVUJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779223695; c=relaxed/simple;
	bh=qB+N5sBAU4+OEoQbOXMEFHFAdXvpKcGGTLPscoURS9w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kSq2FJ2oRTW4EETu3sD/RudEpvfJqmuCfT4kt7WIPmqMHTBx1g22M37TNKOUPoeuBT1DUtdFVMJMrcaNH1DibQlG3QE5v36TfP045LZChSYpo2MtSaOOl2XHSrlHXhMNSC5mBGDlG46narXJpL19Sfg/IpsRj92o1bjOns/BtZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wfb6pC+G; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wfb6pC+G"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-490227b682cso736345e9.3
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 13:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779223692; x=1779828492; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=46bxzW7AWDk4uXlyHvKMVMwj/OyP1y7/MWcuxerPlBc=;
        b=Wfb6pC+GGEpo96iCWR7/A6fRITHK92G27tcZ4w6/eqxj2e4EfGSbg9GVhdvywCrtCv
         iPs/ICt3xXPSNfPNGuHXktejgtBRwYBByOCloS/vMmAbfLMygzDXMvSsvueU63TYa5zl
         rM1TxsyLzTFntSfYLBSpGyTJFqUTX8vl6Xg0CKuVR/JzUon5swW2ZFMzzrfKJqvabNO0
         T+z+rX1Artvmc2cUSjqPR7PZ5UoXbrf00mdKqBUGzNc7q/4QtIfMYVC1vn6jVmWf6Zc9
         JF5sBEZ/+UYz8q9H8TmkAUVp/wBqtZaUQ1W0CfCHZlAxsiqGfppIPsEtP4QzjyNB4ZAr
         UntA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779223692; x=1779828492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=46bxzW7AWDk4uXlyHvKMVMwj/OyP1y7/MWcuxerPlBc=;
        b=TryGkBHtWcdTGuIy0IxjchOgIjxbauI2ww4vUFUTsDpqiFymCtehqyQxJhvk7tpc2T
         2Yv1UW73NdIGHGsFcE1811+rRDXoH9Nbi3aAHUV+rMxCgicHs2PdJgr7IAtcvxEJE5w7
         wA9Bg747Icsqvy3i9F5nYhL1UZDvu3jeXTm2Icl27V1lPfSOOJ6WT03ZpLWl8ZY6mw0l
         uPOJzO4a+Lo0ZXskUhKlRy0ZaWX4v84dHz9Rvt+1kdfrYomv7CAGWM5YnWK8W6PK3AX6
         9EaWlOy8oIYGvnBACWm0LUtl2xKDr2mgWygJaVBeG8oOSAH3Dy4ckbBPoxzxJW4vE76O
         BayA==
X-Gm-Message-State: AOJu0YzTOc8SIK1eZ8HeOxJA71wfXJsSKDvNARFguzi+RCIDFuhDGIRS
	xW1b7EaxWHI23zbziaSk08R5IGkbA2qpyP4Ng/g7UfBxkUhoAvP9KkcH
X-Gm-Gg: Acq92OG1DSVa054beZi6pJakv5BUK3CufFQDLgD8TUOhF00Z4w8sPHS01zlzlO4wYOF
	mQgKO+ERGs1ihiIAoeSUvJotLenWsF0NLULMfoqTb6b9oLWyZTyYZdxukpL5l/QMRwmNbXUysn0
	Pm32sIBDod42dd9aK7aBFst65727tyhgliUI0LCriwzjSjxpKVfWIdd91E0ULvjwPUdRZIiheXt
	zncdcCMOdcwsPJftuAdq8B0XXIHRXPK05mQSceLJ/qoBqGVQbXt/5d5qSey8myMtJQH6o9B5NFa
	/hywEqJz19zNfG6eclpocNtjMPPmhXHxjN412VT9MWy/T5b9HcNjx6eUa9numPWAuhoYbskLZaG
	GjXPK6pyRkyUiNRTzmYNmuzBV5oNKFqdDW8WCb2ZjtF/oyBpZOWpiJ0koTPZR+ggExurP1MOp21
	pSy9PkHS2QZRPNclkOjrBk5b8sVNYhi/IcPkcIAnKkCJ8U4AUNUOiwZlL0Q7rjBlo=
X-Received: by 2002:a05:600c:8b25:b0:490:6ab:406a with SMTP id 5b1f17b1804b1-49006ab40f1mr111033255e9.8.1779223692230;
        Tue, 19 May 2026 13:48:12 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe4dac000sm356457755e9.0.2026.05.19.13.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 13:48:11 -0700 (PDT)
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
Subject: [PATCH v2 03/12] crypto: atmel-ecc - fix multi-device kpp registration
Date: Tue, 19 May 2026 20:47:54 +0000
Message-Id: <20260519204803.17034-4-l.rubusch@gmail.com>
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
 drivers/crypto/atmel-ecc.c | 55 +++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 19d5435aa42b..e5dd166fd785 100644
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
@@ -331,23 +334,30 @@ static int atmel_ecc_probe(struct i2c_client *client)
 		      &atmel_i2c_mgmt.i2c_client_list);
 	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
 
-	ret = crypto_register_kpp(&atmel_ecdh_nist_p256);
-	if (ret) {
-		spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
-		list_del(&i2c_priv->i2c_client_list_node);
-		spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
+	mutex_lock(&atmel_ecc_kpp_lock);
+	if (atmel_ecc_kpp_refcnt == 0) {
+		ret = crypto_register_kpp(&atmel_ecdh_nist_p256);
+		if (ret) {
+			spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
+			list_del(&i2c_priv->i2c_client_list_node);
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
 
 	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
 	i2c_priv->ready = true;
 	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
 
+	dev_info(&client->dev, "atmel ecc algorithms registered in /proc/crypto\n");
+
 	return ret;
 }
 
@@ -359,21 +369,16 @@ static void atmel_ecc_remove(struct i2c_client *client)
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

