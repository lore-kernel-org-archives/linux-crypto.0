Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AB23C0604
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 20:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779223698; cv=none; b=Ij19x9gAiracLSmhgm6FNWUB/6Gv4wGaS4RzmPFbvaT6FGj8yvzq9ft9Dm3csKTh6RsgjHHUNYDzgn1UaiJSmzjrwA2wMvcJsJCQlliGyhOAub6xL6oPuT+dfjjze0G30Lr8uG8wPpmtLgP4FDH3KweR+4n+B9BF0rCh9q40S48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779223698; c=relaxed/simple;
	bh=O3NBvPUeMpkKMsuqGi/aIGTrfqSqyPDWVkpHE4DBwqY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BXcHR2Jh8oZ6AyMeH406sx+GSgURc+UazPFMoYlOqS5hXGs9CHG3o6Hwhq4GcBIQ1B75M8YIRxzdiApQ7RjqambROuaTSlxBtHYFkLCKkWLAfCCxffzI0aUubL+pduFZm18pa2PHyN/Q0+me589DJRMNtaBeEjtTm4LWcSpbncE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c6aoOH3k; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c6aoOH3k"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-44a7c719151so207073f8f.0
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 13:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779223695; x=1779828495; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QtVvthz/7+lTeRk4aPj5gp54GNbJ7oJJBTGPkd/6zCs=;
        b=c6aoOH3kh21sVql4+E1+PXdnUuadNOFbX/oMVU4esAupUtam7FLVOf1TmO/BLAuCtR
         BQKE77VfzeH+EaQtTHPeFCrxFjNrfgNnh6fajIQVttFnkkzeFJyb03U6fUFEZYMRIWjI
         IaqeW61qofvqRsx09/lup7alZ6xIGSJpVZPDCsjpHL4gxbTQ3WEZVUqYxJQ7GhkDiP+3
         s1q/aE573wlSA49TXMYmxOxqZ5RyobH4GWEftUmc6MHOSzpnhQOaC4tDAlbFFmbpe98Q
         51FR23nPHr3BYFTvAbgfsFNRnN5NMVw1mGHRkK4oHBiSV/PP3BJT7m1KRqRXoWT/8n5e
         MyhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779223695; x=1779828495;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QtVvthz/7+lTeRk4aPj5gp54GNbJ7oJJBTGPkd/6zCs=;
        b=qWmeueOKu95Q7JSOWxH54JTKg5t6al3k0r8zqEo59HUPplvy99+EQW1NsXFlHMiLFm
         TNwTr2WA7AFJY1cSEMmJpHcZQcMR5Suej1SZae9IfbIC2P9+CjLVeuCAXBHcViHHakh0
         xw26/nBFhExu2vLzwMmCnIZ/w81UsBd1giSOIzkumNnJV+cvhjDyjPjlXKkj3yMIb+pF
         nN1PcmHKnYw8pnMtis/46BlJ7OgIVXFgXtn9HC4SkOE6SY0ndWuQp/IjTfuF52/f50nS
         odt5Xb6rWtkMPEQpCy8f9xaa8VYkn1HQzcBXnV+p2M5+f1Fmyv8mr4y1sduiFKN/DIkG
         wvhQ==
X-Gm-Message-State: AOJu0Yx80SztqXxWnGKKOemvoK0DCzTPjDIRN8LbCCgS5XP6t0XaOfU4
	zWOVGp7XZdER37uotovZzMR4olwv0SY5u9mFIy6jgHMfUI8YVFF96Kxx
X-Gm-Gg: Acq92OFzRbIbzlrgt7ovFa8LGKUTKmGYX7K+O2TlS/htUZbcTkkgXnvgaVj0t2O8LLm
	3nIa3zEJEkZY7hIQm2EJqgMY8gjERw+OMlyOQ4v8/xkUgR6TSqscgnqtI8/P0Ib9qtkLhii5s9s
	+yjMHMzNB6ZtMPvNnWoguNBVhH8pSpuDlK3Lyph2gbUl7CIZyPuMjXGndWGY0uBl0uJmYXr0GGf
	xVAEHKN/rzREJg6DP/oa6LMvYKpw2Tpj/Y/ej7qQu/5qSb3b2iTNLmv0vDbEGXNJgQo4JEhlT0B
	gvlGWczElF+6ywnAPkhQQaEZcX1T07ViWG6ogSZeRfQaxpb2Qn6cU8avphWWUIs/i+5LYwKY2Ij
	bcppZkxKDmwKq+24RcJOtHfY4U9nyfNRUw10xaaDqnTcz9ddPz1cit/equs4ZrfHo2pzjxVvuzd
	iRr+Bi8hCdP1V6YaCjsEFxzJGs2bHYWpcuLz+YvwEB3D2L3wKelRH0Rm5bhw69H2yK2OheLqhWj
	pxSWD/0XCVX
X-Received: by 2002:a05:600c:310f:b0:48e:7a10:1f5e with SMTP id 5b1f17b1804b1-48fe5fd5b3amr150010695e9.2.1779223695175;
        Tue, 19 May 2026 13:48:15 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe4dac000sm356457755e9.0.2026.05.19.13.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 13:48:14 -0700 (PDT)
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
Subject: [PATCH v2 06/12] crypto: atmel-i2c - introduce shared teardown helpers and fix queue flush
Date: Tue, 19 May 2026 20:47:57 +0000
Message-Id: <20260519204803.17034-7-l.rubusch@gmail.com>
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

Introduce atmel_i2c_deactivate_client() and atmel_i2c_unregister_client()
helpers in the atmel-i2c core library to modularize client teardown. This
encapsulates common client state tracking and list manipulation operations.

Convert the ECC driver's error recovery and device removal paths to utilize
these new helpers, ensuring consistent execution ordering when modifying
device-readiness states and deleting linked-list nodes.

Inside the unregistration helper, use list_empty_careful() to safely
validate the membership state of the individual node before triggering
list_del_init().

Additionally, migrate the atmel_i2c_flush_queue() call out of the module
exit path. It now runs inside the core unregistration helper under the
protection of the management spinlock. This configuration ensures the
shared workqueue is only flushed when the global client list becomes
completely empty, enabling proper scaling for multi-driver setups.

Export both new tracking symbols via EXPORT_SYMBOL_GPL() to match the
existing core driver licensing standard.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c | 13 +++----------
 drivers/crypto/atmel-i2c.c | 22 ++++++++++++++++++++++
 drivers/crypto/atmel-i2c.h |  3 +++
 3 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 33b90667c872..29706e4bfa04 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -336,9 +336,7 @@ static int atmel_ecc_probe(struct i2c_client *client)
 	if (atmel_ecc_kpp_refcnt == 0) {
 		ret = crypto_register_kpp(&atmel_ecdh_nist_p256);
 		if (ret) {
-			spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
-			list_del(&i2c_priv->i2c_client_list_node);
-			spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
+			atmel_i2c_unregister_client(i2c_priv);
 
 			dev_err(&client->dev, "%s alg registration failed\n",
 				atmel_ecdh_nist_p256.base.cra_driver_name);
@@ -363,9 +361,7 @@ static void atmel_ecc_remove(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
 
-	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
-	i2c_priv->ready = false;
-	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
+	atmel_i2c_deactivate_client(i2c_priv);
 
 	/*
 	 * Note, the Linux Crypto Core automatically blocks until all active
@@ -378,9 +374,7 @@ static void atmel_ecc_remove(struct i2c_client *client)
 		crypto_unregister_kpp(&atmel_ecdh_nist_p256);
 	mutex_unlock(&atmel_ecc_kpp_lock);
 
-	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
-	list_del(&i2c_priv->i2c_client_list_node);
-	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
+	atmel_i2c_unregister_client(i2c_priv);
 }
 
 static const struct of_device_id atmel_ecc_dt_ids[] = {
@@ -414,7 +408,6 @@ static int __init atmel_ecc_init(void)
 
 static void __exit atmel_ecc_exit(void)
 {
-	atmel_i2c_flush_queue();
 	i2c_del_driver(&atmel_ecc_driver);
 }
 
diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
index db24f65ae90e..c73ef3cadf0e 100644
--- a/drivers/crypto/atmel-i2c.c
+++ b/drivers/crypto/atmel-i2c.c
@@ -354,6 +354,28 @@ static int device_sanity_check(struct i2c_client *client)
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
+
+	if (!list_empty_careful(&i2c_priv->i2c_client_list_node))
+		list_del_init(&i2c_priv->i2c_client_list_node);
+
+	if (list_empty(&atmel_i2c_mgmt.i2c_client_list))
+		atmel_i2c_flush_queue();
+
+	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
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

