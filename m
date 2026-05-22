Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AAE30FC12
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 23:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779490904; cv=none; b=oeH3QazsPMq9e5fCCqKYUWpk5II7gKHVF+gsoLfkgQFm5owAaVQ9/14KrW9nWe4FVYi1vfVbKNyczxMzoqgPIhMfMxIIB9zbAnQG/6vlopKIkEC003F3oDAQZYu0l+LB6/yGTFTF232NenxLOs/L/xn/vnp77KdpCri30mtPWKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779490904; c=relaxed/simple;
	bh=+GkEvCmZvKvSSf0kbXSJbp3bZrMZ4EaeOXstOxgGbmM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pIO9f/G143G9t6aXfDsiLMqIjN4xPQ7xGpudSBuGXkE7IDO36yGDBWQl08zoJKozgCcjZ+oP0o4arIo1UEW1b4ohqIpULGSayLGLhR/zZko+EEkuOWrtI02hnGkSGKUbYWeEU4Ey/Wsf8OGNNWY8tbMVcof2hd2mvLTBLCDCKr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BPDjivtM; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BPDjivtM"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-44ad87a57f6so612339f8f.2
        for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 16:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779490901; x=1780095701; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yLhglCCko+VFtBnuII+zHndGNGz8atU/cZ6T50d3HYU=;
        b=BPDjivtMTNk2lNkHwUDJIWSwEndYX5f+C8cUq1k8vRR/oXcc6UalT/kbwqdzdOjSgt
         qsYePMNiGv6UCf97x/5tTW8XVRqeN2InAoTeUVKRbUuN1eHUuFfwBeHomBpWNWBkC84O
         iofNlNgxQXEEQY/esV/IPRT22COVOzuNkIJHcZqwztlqfttBE1f2OxvELpoNfmSt9k5a
         1DHO8oql55sZtHvFPKuX1GGfyI+Cc/TmXFk3Epl0EC1eNeukq5PFvx89ojyuq/27yROb
         OD+j3uXwQ3vcadL174FegwVYnzIw4UsFhNoSnxwLhwP2/oqLp7jge2/bPkJqFdsvzN/9
         nTUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779490901; x=1780095701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yLhglCCko+VFtBnuII+zHndGNGz8atU/cZ6T50d3HYU=;
        b=CqjD3b3JWE2/+beU3JLNnB6Qn7kVVCMU7l+LNkWYKspaVnC56gSlPnMMFLn0E0eJn0
         +bqWlg2QxhIh3aDEMn51BdDhAcO2r2j1CqzXQVgg1AiIlWSsgapbkaCIrPbWn6pZRyIj
         xl6FrT4ubtUKYMmG3iHv5fdFYyosLnRnfPi6CzzY8SL/TqCDmrc92FUUArYGArcOxp9l
         psD7tnXsKeJNvI4IDjpJP4W7pIO7I8K6aTlF+ChkKbN+RkzLxdIRYYm6t8vIOYZ9olpC
         +BK2Gp0mllKokbYh++r5U4BW0mGtF66y2TO3fRHAhAUWfy46qgky+/uflOBk/7+5odgX
         U0Ag==
X-Gm-Message-State: AOJu0YwpzPyNwuACLTt8lIeaiCazl/cDj70ol4Z4qpob3pcUZBKQbuA9
	XUn16R9LIUpgdMuq4vcLHXHWHgpSvScOAIbqAzchVo6YxV3nUjcHoRJy
X-Gm-Gg: Acq92OG8Amkgh0TI1JwpcN7D8I8q8RucfQkhLME48NENn35daQL2htYVJ1e5sZPPFcp
	w6Sa/umevhboFepVJxhIW1wyOEO93ZuK1rtnl++B72xcAJqw1N1a4YahpnLFtHxs53Qb9KPisIs
	awWYeJB9TJGbfUJDJLX9WxAdeoO/eCmZFRjcn69y5paVqYB15eEMu5YdNXeIThV0fSiF6MCuqmC
	Dt3us52sw7jWw7Dv6KEFAo+ahk4bNYC5PUNR3h9kuj4hb4cJCEMsxFW7RkSSN4XkAFgohOWqjKx
	1ZkuNVljBUWxva/524cv6+MHjXdG4fmSCjaWFsh2FhF41XJsatNoBIr8EFErYSRDoGoGXLvNHrU
	hyjObPPqz9rJUk3fuYqk6n8fcqQAReERx/MJdrjZGuAimIO9X3rwZPIr0flYURbj1U2x7nmN8JN
	qSTGCwWrZp1UWOOLaNKecMtaPIOh8Z0JWmfqDfy9g9pXfNDWU6dwRB0FqDpcQJx3y5yz1fabMuW
	g==
X-Received: by 2002:a05:600c:b96:b0:490:4923:aa3e with SMTP id 5b1f17b1804b1-4904923ab35mr20036195e9.7.1779490900958;
        Fri, 22 May 2026 16:01:40 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490456274ebsm67100265e9.15.2026.05.22.16.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 16:01:40 -0700 (PDT)
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
Subject: [PATCH v4 01/12] crypto: atmel-ecc - fix use after free situation
Date: Fri, 22 May 2026 23:01:23 +0000
Message-Id: <20260522230134.32414-2-l.rubusch@gmail.com>
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

Fixes a possible race condition, when having multiple of such devices
attached (identified by sashiko feedback).

The Scenario:
    Thread A (Device 1 Probe): Successfully adds i2c_priv to the global
             list (Line 324). The lock is released.
    Thread B (An active crypto request): Concurrently calls
              atmel_ecc_i2c_client_alloc(). It scans the global list, sees
              Device 1, and assigns a crypto job to it.
    Thread A: Moves to line 332. crypto_register_kpp() fails (e.g., out of
              memory or name clash).
    Thread A: Enters the error path. It removes Device 1 from the list and
              frees the i2c_priv memory.
    Thread B: Is still actively trying to talk to the I2C hardware using
              the i2c_priv pointer it grabbed in Step 2. The memory is now
              gone. Result: Kernel crash (Use-After-Free).

Fixes: 11105693fa05 ("crypto: atmel-ecc - introduce Microchip / Atmel ECC driver")
Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c | 10 ++++++++++
 drivers/crypto/atmel-i2c.h |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 9660f6426a84..94360d29f9f9 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -218,6 +218,8 @@ static struct i2c_client *atmel_ecc_i2c_client_alloc(void)
 
 	list_for_each_entry(i2c_priv, &driver_data.i2c_client_list,
 			    i2c_client_list_node) {
+		if (!i2c_priv->ready)
+			continue;
 		tfm_cnt = atomic_read(&i2c_priv->tfm_count);
 		if (tfm_cnt < min_tfm_cnt) {
 			min_tfm_cnt = tfm_cnt;
@@ -322,20 +324,24 @@ static int atmel_ecc_probe(struct i2c_client *client)
 		return ret;
 
 	i2c_priv = i2c_get_clientdata(client);
+	i2c_priv->ready = false;
 
 	spin_lock(&driver_data.i2c_list_lock);
 	list_add_tail(&i2c_priv->i2c_client_list_node,
 		      &driver_data.i2c_client_list);
+	i2c_priv->ready = true;
 	spin_unlock(&driver_data.i2c_list_lock);
 
 	ret = crypto_register_kpp(&atmel_ecdh_nist_p256);
 	if (ret) {
 		spin_lock(&driver_data.i2c_list_lock);
+		i2c_priv->ready = false;
 		list_del(&i2c_priv->i2c_client_list_node);
 		spin_unlock(&driver_data.i2c_list_lock);
 
 		dev_err(&client->dev, "%s alg registration failed\n",
 			atmel_ecdh_nist_p256.base.cra_driver_name);
+		return ret;
 	} else {
 		dev_info(&client->dev, "atmel ecc algorithms registered in /proc/crypto\n");
 	}
@@ -347,6 +353,10 @@ static void atmel_ecc_remove(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
 
+	spin_lock(&driver_data.i2c_list_lock);
+	i2c_priv->ready = false;
+	spin_unlock(&driver_data.i2c_list_lock);
+
 	/* Return EBUSY if i2c client already allocated. */
 	if (atomic_read(&i2c_priv->tfm_count)) {
 		/*
diff --git a/drivers/crypto/atmel-i2c.h b/drivers/crypto/atmel-i2c.h
index 72f04c15682f..e3b12030f9c4 100644
--- a/drivers/crypto/atmel-i2c.h
+++ b/drivers/crypto/atmel-i2c.h
@@ -129,6 +129,7 @@ struct atmel_ecc_driver_data {
  * @wake_token_sz       : size in bytes of the wake_token
  * @tfm_count           : number of active crypto transformations on i2c client
  * @hwrng               : hold the hardware generated rng
+ * @ready               : hw client is ready to use
  *
  * Reads and writes from/to the i2c client are sequential. The first byte
  * transmitted to the device is treated as the byte size. Any attempt to send
@@ -145,6 +146,7 @@ struct atmel_i2c_client_priv {
 	size_t wake_token_sz;
 	atomic_t tfm_count ____cacheline_aligned;
 	struct hwrng hwrng;
+	bool ready;
 };
 
 /**
-- 
2.39.5

