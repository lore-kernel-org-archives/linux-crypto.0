Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94492362137
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 23:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779490915; cv=none; b=lrfR9E0d6fzMJ65NIwxRl3rrD69jDRp6mKiEEwl5jeehjwiY4jftjtJ9rf/ZB4LuT53nLDl9/ow4yf+o+nFqcymFkyPyyaRVHFSbu47OWKvjcbuMdnh3opb8p4nnK46wL5Gi/M38HN8/1amhcdKlsspOJxxG0M/K8H7C5lwYrZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779490915; c=relaxed/simple;
	bh=aGTNuggTjsMi8IqadRKQSxAgL+xgnUXNuaYDOu+9S3Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R8Ju1hYY3+YL03XLbaSmQbgq+0DQQ+u7JA1osemmFQtwstncanO/giMo4Jvn2jUM/q62ykAgDUGHg1eKYy6A0vDMNTj7FL3zBPGfjgM42GpfgWl19TumTpGM38a7ACCi2EgOCGFmvC6fVrY3JWheaqX/Mi4SJ5SNmPWC+JWjv2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gEHn/7dg; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gEHn/7dg"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-44c44af71f8so926724f8f.1
        for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 16:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779490910; x=1780095710; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6/v/8SwP1OMGt6X7FpwGNnrj1hJ2WLb5Kzz8Rnl3t28=;
        b=gEHn/7dggFo1CGr6ragbo2NKF02riePaZz+CxT2CFWmkFlqponO+gJqYX06lNDDMNs
         sJIn5bIflj2etpvmwFeDkPvzU8eh6vvWxCFuy1oZHKhQsb03rsBdSBKy5cYJasmfBh3R
         UcLyUispQ/qZTDNTnzEHJgUEGV7jlqIBiGEXx/9xcGjiNBgKJIGQuJ+hV+KVxAf+4xJ7
         t77NFygLqhNDB5h2ZD1n0C/4hq+tXatJH5tP/BUOXsj6qNqqg0nU4OeiJDWgQsdN1RNI
         EYOzwiGdOl0oeYJ8uwrmWeaU24px7HvorIayvwBU1G58xhv1E11fJAjkyYOjuBGwz6h3
         RZTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779490910; x=1780095710;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6/v/8SwP1OMGt6X7FpwGNnrj1hJ2WLb5Kzz8Rnl3t28=;
        b=I/ufxH1j94C0ePseaevUjx6MCvHpfC7l5KwQ0WkwBW0lmCHyd0coGF0KUn0p8SeWcF
         DPMrCAO1aEPhrGQkfcv8RrNAbt2qYvvXCDrRTTgbS9FboR6t5fTeLCkh76OAKdzmKE3I
         QoAj0J0Dk/rQFjmR7jrmgQT5ICuT+5gIGDmQY4TI/SiVGOwUxMB8GURhwSxwEDvprvn8
         GViQEoxMZPJNto4tlHgPND3eOVoKbM87vBCt+AeNoZyGgZTMe8G5e0cRb9b9L8IgEm6+
         hnp0/sGJvj0F/D77XSfaTKNIG7zWzCavFj2B7brf7vDO4bMAoFyjjA6KJuToVo/F1ElG
         LdQQ==
X-Gm-Message-State: AOJu0YxbMvdREfTXUOZNn/au55xfI3GioYPolBXWQvT/+TznVzENVM6e
	PBdFc1cSjH+P7JA9l9ZZWbJAP4O0fgX+QJFAkW1Z0ZEPEMMiWUh7023a
X-Gm-Gg: Acq92OGFTQyNj1YikQtrV1DBDP/DAzr2ZW/ftakNdsdTmYUm3F6YbVcBKEGmz9yNkYs
	uhu/kBl4kiKVz0O3ECuZWGT+p28Vz06PYDgEDSglCAdlNguvTTefKfJilb2GIOtmodmRa2j7j2p
	COuE+oYS6c45Or2eMlZqgYxWqJNiwPdrZq1C/mLc2Jl3QzmCm2xld2zeJi3K1jBzfGnGtcYPc6d
	JdFLqZJF9/M39p3JZNBewcFFpqEgqEXgErgWVl3unHmck4CG+zzk2sVqTCgx/cOVitdiIiUhPlg
	6YF0b+WUXM5HgVUt1iStbvfW2w0AAhkaRHUArSYRZDHHAB94ReUWKmWFRHyLgmqGSZnQsGuKcOT
	U0INjmj8VS8TO9CDugUh+0638U39s+5PsDl+3EdkN9oFu6cltBPARllGXTBrd52Jb3Zi+xKQf5B
	VnCcdrwU1kIO68lm1s6AfEUj6pBIFHS+7C0aQ8cW4kEQDoOOomlbrInfwUsA9fR2s=
X-Received: by 2002:a05:600c:3547:b0:490:3d3c:22f1 with SMTP id 5b1f17b1804b1-490428e6d5dmr38350275e9.7.1779490909725;
        Fri, 22 May 2026 16:01:49 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490456274ebsm67100265e9.15.2026.05.22.16.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 16:01:49 -0700 (PDT)
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
Subject: [PATCH v4 07/12] crypto: atmel-i2c - introduce shared teardown helpers and fix queue flush
Date: Fri, 22 May 2026 23:01:29 +0000
Message-Id: <20260522230134.32414-8-l.rubusch@gmail.com>
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
 drivers/crypto/atmel-ecc.c | 25 ++++++-------------------
 drivers/crypto/atmel-i2c.c | 20 ++++++++++++++++++++
 drivers/crypto/atmel-i2c.h |  3 +++
 3 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 1ae9c52812df..e6d3e6574251 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -351,12 +351,8 @@ static int atmel_ecc_probe(struct i2c_client *client)
 						      msecs_to_jiffies(2000));
 		mutex_lock(&atmel_ecc_kpp_lock);
 		if (timeout == 0) {
-			spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
-			i2c_priv->ready = false;
-			list_del(&i2c_priv->i2c_client_list_node);
-			spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
-			mutex_unlock(&atmel_ecc_kpp_lock);
-
+			atmel_i2c_deactivate_client(i2c_priv);
+			atmel_i2c_unregister_client(i2c_priv);
 			dev_err(&client->dev, "probe timed out, former driver instance not fully deregistered\n");
 			return -ETIMEDOUT;
 		}
@@ -365,12 +361,8 @@ static int atmel_ecc_probe(struct i2c_client *client)
 	if (atmel_ecc_kpp_refcnt == 0) {
 		ret = crypto_register_kpp(&atmel_ecdh_nist_p256);
 		if (ret) {
-			spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
-			i2c_priv->ready = false;
-			list_del(&i2c_priv->i2c_client_list_node);
-			spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
-			mutex_unlock(&atmel_ecc_kpp_lock);
-
+			atmel_i2c_deactivate_client(i2c_priv);
+			atmel_i2c_unregister_client(i2c_priv);
 			dev_err(&client->dev, "%s alg registration failed\n",
 				atmel_ecdh_nist_p256.base.cra_driver_name);
 			return ret;
@@ -388,9 +380,7 @@ static void atmel_ecc_remove(struct i2c_client *client)
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
 	bool trigger_unreg = false;
 
-	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
-	i2c_priv->ready = false;
-	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
+	atmel_i2c_deactivate_client(i2c_priv);
 
 	/*
 	 * The Linux crypto core automatically blocks until all active
@@ -410,9 +400,7 @@ static void atmel_ecc_remove(struct i2c_client *client)
 	if (atomic_read(&i2c_priv->tfm_count))
 		wait_for_completion(&i2c_priv->remove_done);
 
-	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
-	list_del(&i2c_priv->i2c_client_list_node);
-	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
+	atmel_i2c_unregister_client(i2c_priv);
 
 	/*
 	 * The driver registers once an algorithm, but maintains a list of
@@ -461,7 +449,6 @@ static int __init atmel_ecc_init(void)
 
 static void __exit atmel_ecc_exit(void)
 {
-	atmel_i2c_flush_queue();
 	i2c_del_driver(&atmel_ecc_driver);
 }
 
diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
index a42b0ea30033..db818ce55033 100644
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
index 82321c35c21f..07fd2248e20b 100644
--- a/drivers/crypto/atmel-i2c.h
+++ b/drivers/crypto/atmel-i2c.h
@@ -193,4 +193,7 @@ void atmel_i2c_init_genkey_cmd(struct atmel_i2c_cmd *cmd, u16 keyid);
 int atmel_i2c_init_ecdh_cmd(struct atmel_i2c_cmd *cmd,
 			    struct scatterlist *pubkey);
 
+void atmel_i2c_deactivate_client(struct atmel_i2c_client_priv *i2c_priv);
+void atmel_i2c_unregister_client(struct atmel_i2c_client_priv *i2c_priv);
+
 #endif /* __ATMEL_I2C_H__ */
-- 
2.39.5

