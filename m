Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8293B992E
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 20:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779223694; cv=none; b=oscDn5ABA0BfMj7OFO+HXSSGOFlFCbo4ESSvgO3A3WYEJ0vtvIIdm75dUV7JdMlw6S2Wh8TyT4At0cWgYvGJ/aGGvufrCjNRLaAbM+abdf/Tg/OwZuZjWu+INYcuE7RbwJZsMuZ40LuOVluXAtZL1Not+axkd0BaoGo1HkEQOGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779223694; c=relaxed/simple;
	bh=wI9dECRvBX2VsI/nKiWlz/4reVpcy4qe9tjGwApazoA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Fy0UmoxXk2VSDlvucvcvzkpAUy8tPGo+2Bx+n0e2/gjs7RH/xZ7G4M5Ja9B8xCWEPmUEO1e+qGAJcDi3oVfJZfoi9ECiJKIfjlevJpVCIlYxnNbPIkb3clQojfQR0EtWyK3NINnLm4afarsWQ4xAr0z+wJt4iX9s78LYDKgkSXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k72eRE43; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k72eRE43"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-43d7828221bso225296f8f.3
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 13:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779223691; x=1779828491; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g1DeJFJSEHZep1pJ6wxiVEkdit9Es+ISenMHqnD6wG8=;
        b=k72eRE43dn/oS2DJAy+FGXgPOp8AsPyFNFjlCI4vfeG6S5hly91tuGr3uHi2P89bAz
         IQdbs18xMSL+1sZ1C0Bk3xahg9rnrYFD8JPgMBZoaavlB8lyIPq/FLFszfNHWhG0XmOU
         Gm5xF/SSu/kjL8R05pQdCZDMo8GzYtP9KThD68tX/G5sAmE5SBX9NHEF3OQAIOJ3VUPh
         oN7Duf3SuCnZqlydfLRcJINrU7FUl6P8qAol5CMOnyAaKDIk03JX3fYZWhCAq11MDCOz
         +pbnD2HsZc2c5cdRlE++iF2569z05BP8CeTc3YJecHcUz7STnTZ+DohU/fUV2u+xdAF6
         yCMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779223691; x=1779828491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g1DeJFJSEHZep1pJ6wxiVEkdit9Es+ISenMHqnD6wG8=;
        b=TvP3IuO8mzfPMs19DChSSU/tfADR+FHUDVr9CTr9OUDfLpCBu4s3t01BzCnOE37kuS
         OjS1d19wbhbWE2lORtohWoraAJDrfVShSvYQ6xzlrYaKoAtbwgMifLHEtPlSnbakSjAa
         hjt5oZ2uyboQFtCizbhYQrwntUFjOAhdaQ4Fj9/24s8imuZAyAilnVP9/9IwENe7kdTb
         K3Pt3dDnCJI47d0m8pDKoVwARXqYILWyy13+IWyuREByV06bZgEGuemhlW/9ysk+HYJJ
         JZOIVpwfpFcaSICgYQh4pCbk3Sdb/HYnCVMmUpeP21i/d3v7NeTOxxbHqJYYLgb8KZDO
         ayAQ==
X-Gm-Message-State: AOJu0YyvSAgSSbdI6576gO4z17BuEjNcST6uYy70ZudE39hnErnb2fWj
	yaeWe3TVkDf+xR+5x3JCrYBESPWgRe8A44Yu4ixPbnqAnfbJS/wNa5wG
X-Gm-Gg: Acq92OEPUPwU8aN+BryPTkWD96MOUhY1OccGbVdrnmk5PN70ztmd84wXe3MF/oX+awp
	yThBZmmSB70T+FtxLPZygqVA531a3mYZnyLr6XRzQvBsorQfN8RBG6JVuguHKrHTRw/8zW6NBAK
	n8sY7j10j+QHkXR6TybiUa/D3sup/2QCJq/yzS0eA4BOh0SnYNDcA4Ao31M3gjxwQ/OAJXgOpxz
	TohtFFwFvw9K9x5uQ6wi9CK5Bfaw071LTUSPACTvijIXPy3iXmnpgdK4Y9StFmOabVRO/G5799x
	ylPucYRSfqzjg8mb2y+icGoQiwUVaSNzs7EIqiJOOckjHjNXk6B6By9AAt8Gi7g5H1sw2IGykp5
	Snw0WI0/HIVwnaXgn/kpWfDjKVT6FHnEJVFGycUbdClNBpQoirwi9qBVDF0HVMAduaOLFNWg4JH
	12VLLvTcocitJa1KWBwLxTAtAky6CMFY8TaQ+GslKN0QDH5oFVAPC2ImAAQQcHShBiA1ev47sbM
	w==
X-Received: by 2002:a05:600c:1f8c:b0:488:abe9:86 with SMTP id 5b1f17b1804b1-48fe631817cmr157538085e9.7.1779223691288;
        Tue, 19 May 2026 13:48:11 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe4dac000sm356457755e9.0.2026.05.19.13.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 13:48:10 -0700 (PDT)
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
Subject: [PATCH v2 02/12] crypto: atmel-ecc - fix use after free situation
Date: Tue, 19 May 2026 20:47:53 +0000
Message-Id: <20260519204803.17034-3-l.rubusch@gmail.com>
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

Fixes the very likely race condition, having multiple of such devices
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
 drivers/crypto/atmel-ecc.c | 12 ++++++++++++
 drivers/crypto/atmel-i2c.h |  2 ++
 2 files changed, 14 insertions(+)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index c9f798ebf44f..19d5435aa42b 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -218,6 +218,8 @@ static struct i2c_client *atmel_ecc_i2c_client_alloc(void)
 
 	list_for_each_entry(i2c_priv, &atmel_i2c_mgmt.i2c_client_list,
 			    i2c_client_list_node) {
+		if (!i2c_priv->ready)
+			continue;
 		tfm_cnt = atomic_read(&i2c_priv->tfm_count);
 		if (tfm_cnt < min_tfm_cnt) {
 			min_tfm_cnt = tfm_cnt;
@@ -322,6 +324,7 @@ static int atmel_ecc_probe(struct i2c_client *client)
 		return ret;
 
 	i2c_priv = i2c_get_clientdata(client);
+	i2c_priv->ready = false;
 
 	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
 	list_add_tail(&i2c_priv->i2c_client_list_node,
@@ -336,10 +339,15 @@ static int atmel_ecc_probe(struct i2c_client *client)
 
 		dev_err(&client->dev, "%s alg registration failed\n",
 			atmel_ecdh_nist_p256.base.cra_driver_name);
+		return ret;
 	} else {
 		dev_info(&client->dev, "atmel ecc algorithms registered in /proc/crypto\n");
 	}
 
+	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
+	i2c_priv->ready = true;
+	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
+
 	return ret;
 }
 
@@ -347,6 +355,10 @@ static void atmel_ecc_remove(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
 
+	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
+	i2c_priv->ready = false;
+	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
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

