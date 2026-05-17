Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2376E3C9EE7
	for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 18:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779041211; cv=none; b=MJzvjwPltkQkQ0QE/iWLavjnWI8jgSJLVJKVmH9ku1LOoeAbvB+rhHk7DPTFTfBYFiAW6UknDuOxuCMrT2o7yE5w1BQV5u8+FUE3Uufr0xLyhVQBsCp1HnVqybDh9EMkP8+u8F/F//Y1ty4LNF22EOFLBCSgVaE9alhEz5QJNTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779041211; c=relaxed/simple;
	bh=KFHkz47XpNQ4Y5p4iySWuJ8YA0hxxdon70GiMN4cpBA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W5ygblgMnUtOAJlbwfz49syG86qrCaMInDWcXptib1i2JZzh0zi6pI0G+ntW+CbsIE4kFXVFSEkU8BYkC4qIsKYN/MfiL7ePfa+C87/CbIJjr9u1pwANjjJyf8h88XKPA1Yw81o+0tfAW8sMt5rmPMSuFYzN0bv8qydykJxypMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WaLY5Q/w; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WaLY5Q/w"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-48fde653997so1862725e9.2
        for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 11:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779041208; x=1779646008; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ra5Z4YYE3acYeuXsyJvtNtB0kw45T1bBE4SEjM00MXw=;
        b=WaLY5Q/wAr53cwHzWEgf5/Spzj2Ac58bSKRkBGpPWyvl0d5zYeL3cBOsGKbRqC/Ann
         dEyKmNutmjyBvefYjuoY7BGA514LgpMTY+sL9U6/06nftp4l6mrsTcX+Gvd2ywfBGP9y
         GZmLFbuVMyddpc3rfwjGpPmRKw96yeeVWDmmGIdRRufypwZ42Buv1lEXQ406jwzW3qZQ
         aFJqqCnscHnOSr2/l81DFq79CXMPX3PBi33SHv50sGnBvoeVLEBw+WoPPqBXKQXPQT6h
         DFSNJs/V6vFo1bhkMC3H8bwKmWi4qfgnlr/Eb0CjiqEfy5i4Z4IpIEJkyAF0wPnGS/22
         m7iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779041209; x=1779646009;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ra5Z4YYE3acYeuXsyJvtNtB0kw45T1bBE4SEjM00MXw=;
        b=VoIBLLQhQSQmX+vqNqovGaYKYjaExyPT2r8ErH7N5Nbe3Ao74ulyn0t1XEN1+/UZSO
         GhRDxHWGgRx97xv3/v5mHeZCGTRCC1DSJUrhEH9VqGc2YX9UtMpJlcn+6hUxvLWjoCtD
         Hh7cydVk8ewZ7TpAxb3crOoxU9a221bR9wRIFBmp7iMreV6OzBkpnEC63YpGFgvcipMZ
         xB/FIP0O9E0dDWpUUZB/smt+ECTy4Dx1Sv6Q+Q42vKH0byy38WQsMvyM6WQxj0W+EvCL
         DQsRmHeSvr5XKPL5MFS0yfCr8GG4nhF+V98a1HJ0vcoNpeF0tOfwWOWAAj52yxUmFUbA
         xOJQ==
X-Gm-Message-State: AOJu0Ywz1cWuGYKPpwqF7B4WTc8KTNFg9OE+bY1kOolC8JdxOEf0ZoH7
	mdDNO6X3gSA8hwdRVC5Wx3u50wFDH3IYOlEfhh30bR3fIcENiYLSurJ/
X-Gm-Gg: Acq92OGtVaKhltgJz5HxKDenENnI2JrLANkVAtbxJA8QYD2tbuYeeZUpjCLzURli1eW
	0xbESe0gRCwBe2O6VdsoeX3Xe17cdCK4tDmxLUArmXYDurUA8ufVAXRu6v2SWeU4uqdMfgy3Jmg
	YaWvAK8vXhu4N+n2Xb9OLiGvDylH5NZqhdsyH+jIBkOheuj0b/DkiczyEa9UqoiZNSQLQssCw68
	wLAwsrY9lNpxgczatRdjmKuSSCXWQ3lawXzpGXsbtjXfkfe6fz2+FKSeDggPGpwT0LWk+06EbMY
	lh3bvDVdMRXYgJun0aTL6TQTr6YUoO59G04I87SMdBWMLTfY0Ys+YHOOmFaSZG/NzJuQoZh9XkL
	py9/w1QjuWz0sVW+0NOTyQmZKPwDNk/l6APVLQ7QHNJDTd3baACZGFoRG0/631Y6Z/2KpYXD3BF
	VrSRBL/bjtji9Gf0Qya0O8dun/5yM6MrktNVWhWiCEM9tPjRYMWEJSyEgac8DVaHH8v3mh9Ezmx
	g==
X-Received: by 2002:a05:600c:1d02:b0:48a:5302:8ed9 with SMTP id 5b1f17b1804b1-48fe5ea0842mr106215275e9.0.1779041208400;
        Sun, 17 May 2026 11:06:48 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da15a6454sm31766775f8f.34.2026.05.17.11.06.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 11:06:48 -0700 (PDT)
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
Subject: [PATCH 01/12] crypto: atmel-ecc - rename driver_data before moving it into atmel-i2c
Date: Sun, 17 May 2026 18:06:28 +0000
Message-Id: <20260517180639.9657-3-l.rubusch@gmail.com>
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
2.53.0

