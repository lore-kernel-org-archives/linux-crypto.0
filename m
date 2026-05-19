Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC2A3C4562
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 20:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779223705; cv=none; b=YhuZ0d1Rt34D8M7rwQxb2rMMfH0e9m7D1IpE6QwlCx1VlPhWmPu5N21gPK+GhG5pwxJ8hd34B4Roa/9/4ZwLLaVujE2i7AyPEW9Fet1ewcJxoNGwDWSNa4Z3c0ta9WNM3GOokQfPQZ2cgfqF7Q1ncPV/eBcehcWZFlV3OSmxsb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779223705; c=relaxed/simple;
	bh=80omTZr6vSQIfE2wXBax3bJRpWFBu5cr245L8v7TjXI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YyRpfs1AFBbF3I0RcW2F0VCuAzt6hOAr8NGzb9tJmQfNJMPS/lEISyc2J94eEUtIpS/o/vaTNNQycJ1KWv7kvcb+ftG5pp4hsb887xUVI1Ekfs80wAecsSnl1nzBKNn5k+8gSAOx46ER+V8K4jgjXVwzCtr358FXrhj1IjLvTOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AfGybPnv; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AfGybPnv"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48fe6629235so4116525e9.1
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 13:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779223698; x=1779828498; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LjpnSe9r8g1EhPpSrGAgVKmBUmEd4FiP3tGuvmdsN18=;
        b=AfGybPnvlQv13Ixk7QW/u3YIyaHJZ6eGEDV2e91mTuux7Fon6nHtLlFYAMjaJVoT5V
         /oXCSQ6e8xJCqkKV1XxgenxO83RvUz7F6GpYK0KaVQpsWXrnHylVPnhKr7EGsDoH1jiN
         klt3VOI+KEa1xkbUBIzJVxBanPeoQvGh2Qaa1egoUxDu0vFXmszIFzprMD7eXk/4nXAK
         GOZiBxSVtdKAG9V2jKOrlo0zK/nEORQET2t6DkNi8ppMNIcA4jjn6hDpJzfetedDdrTc
         wp3iwhaSCmdouwm2UT66PeEvxIxNRoxmk4Dksay/yqKJVn3HJRECpqQfngMylzICz7iP
         gvpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779223698; x=1779828498;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LjpnSe9r8g1EhPpSrGAgVKmBUmEd4FiP3tGuvmdsN18=;
        b=Ta03yZ67YchSA4/VgwadW+794sM7V0kZZUfet6hQMf3VjZQCz0/b7NaFbwYuLAKXUn
         3j7prSqwKqRMrYKL5nSbjiLn/e3dC2wXgNXcsci+rUH1tvGdJceqT9xAuza1pjtLWLFB
         17wnbSuyV0MNDKWQpETGf6U26ciaQWtbJnPvrpx0pysJZDMuu3IPhuFjhPpkY21Tl1PG
         uHjJRxwBIuXsh121zQT490zUfJe5H0EdxLxitQEALWyWHseicXgu8GbWOftAtN1XTRzn
         NU7U6v9wcwUFgVurv13eUxtyxtKt33QIFW1mHimmkAgmf7wz2NBi+ivsRxWo3fKVlvJs
         +OCQ==
X-Gm-Message-State: AOJu0YwJs1gv655ueabUOPuPzlD9RfXc7mTZ0VQV3VZNmHB/BLGEUFxC
	Y3EgH6splDpnkTv+v0+7ok4q2i+NMR6ntfzAVov4ILmtt5yvLrRlVRa4
X-Gm-Gg: Acq92OHPEQBhRR5+7MQzjP4wHIsKEgZ0fiJWxnx40SZupGMU60+osXnItdrnzMH8zhd
	Og+83Iey8qReaAb/n2TYG95pAoTUnkc/VqeOpiyY7Cwd4neUuuqdF7GAz5thJk0Z3vMyACBIrM1
	V8zjsOQt2ZxrSGmuA0jfMUj8BjuHa6iSTkuhnw7dpbHLMTtyvVbVUo7oy7wDPI+JN2oY9/YgrXn
	emzpP0bDMESZS2tTYIy4uk8XaJbzpgKZ0cBn1OTVjeEUujqfBIMs6TY80lm8vEgTJD6WRM3FclD
	jYCgnPBD8YSjMO4J3nF5Dp7c2w/EJkFfNiGxi/msJha462DhP6IF608PjTDazuvGaZYuIBIdBSU
	rQUcwVyo9J5U+zt4exEmMrCHlMhCznhlytedecH0tgbRqW93Tcj02Gxwx47cwo2vB2SxgKukzIf
	etSMjlcDQprdsW7uDZkXnOQ/UAIn820tGy6lSHKIdnUM5j2O/2BY4hc8xlK47DFoU=
X-Received: by 2002:a05:600c:1914:b0:487:1fbb:5a28 with SMTP id 5b1f17b1804b1-48fe5fcb651mr173127925e9.1.1779223698112;
        Tue, 19 May 2026 13:48:18 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe4dac000sm356457755e9.0.2026.05.19.13.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 13:48:17 -0700 (PDT)
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
Subject: [PATCH v2 09/12] crypto: atmel-i2c - implement capability-based client selection
Date: Tue, 19 May 2026 20:48:00 +0000
Message-Id: <20260519204803.17034-10-l.rubusch@gmail.com>
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

Extend the shared I2C client allocation interface to support feature-aware
hardware selection by introducing capability filtering.

Add a 'caps' mask to 'struct atmel_i2c_client_priv' alongside an
'atmel_i2c_capability' enum. The allocator now explicitly filters hardware
nodes by a requested capability bit while retaining the least-loaded device
load-balancing scheme.

Update the ECC driver to advertise ATMEL_CAP_ECDH configuration capability
during probe, and adapt the tfm context setup execution path to request
this specific capability variant. Initialize the bitmask field to zero
inside the SHA204A driver context for now.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c     | 4 +++-
 drivers/crypto/atmel-i2c.c     | 6 +++++-
 drivers/crypto/atmel-i2c.h     | 8 +++++++-
 drivers/crypto/atmel-sha204a.c | 2 ++
 4 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 7d090c557330..11ee8ef71b94 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -210,7 +210,7 @@ static int atmel_ecdh_init_tfm(struct crypto_kpp *tfm)
 	struct atmel_ecdh_ctx *ctx = kpp_tfm_ctx(tfm);
 
 	ctx->curve_id = ECC_CURVE_NIST_P256;
-	ctx->client = atmel_i2c_client_alloc();
+	ctx->client = atmel_i2c_client_alloc(ATMEL_CAP_ECDH);
 	if (IS_ERR(ctx->client)) {
 		pr_err("tfm - i2c_client binding failed\n");
 		return PTR_ERR(ctx->client);
@@ -283,6 +283,8 @@ static int atmel_ecc_probe(struct i2c_client *client)
 	i2c_priv = i2c_get_clientdata(client);
 	i2c_priv->ready = false;
 
+	i2c_priv->caps = BIT(ATMEL_CAP_ECDH);
+
 	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
 	list_add_tail(&i2c_priv->i2c_client_list_node,
 		      &atmel_i2c_mgmt.i2c_client_list);
diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
index 4621aa57833f..e6eeba1f6554 100644
--- a/drivers/crypto/atmel-i2c.c
+++ b/drivers/crypto/atmel-i2c.c
@@ -57,7 +57,7 @@ static void atmel_i2c_checksum(struct atmel_i2c_cmd *cmd)
 	*__crc16 = cpu_to_le16(bitrev16(crc16(0, data, len)));
 }
 
-struct i2c_client *atmel_i2c_client_alloc(void)
+struct i2c_client *atmel_i2c_client_alloc(enum atmel_i2c_capability cap)
 {
 	struct atmel_i2c_client_priv *i2c_priv, *min_i2c_priv = NULL;
 	struct i2c_client *client = ERR_PTR(-ENODEV);
@@ -75,6 +75,10 @@ struct i2c_client *atmel_i2c_client_alloc(void)
 			    i2c_client_list_node) {
 		if (!i2c_priv->ready)
 			continue;
+
+		if (!(i2c_priv->caps & BIT(cap)))
+			continue;
+
 		tfm_cnt = atomic_read(&i2c_priv->tfm_count);
 		if (tfm_cnt < min_tfm_cnt) {
 			min_tfm_cnt = tfm_cnt;
diff --git a/drivers/crypto/atmel-i2c.h b/drivers/crypto/atmel-i2c.h
index 6c2d86fd9068..636d21bd1348 100644
--- a/drivers/crypto/atmel-i2c.h
+++ b/drivers/crypto/atmel-i2c.h
@@ -115,6 +115,10 @@ struct atmel_i2c_cmd {
 #define ECDH_PREFIX_MODE		0x00
 
 /* Used for binding tfm objects to i2c clients. */
+enum atmel_i2c_capability {
+	ATMEL_CAP_ECDH = 0,
+};
+
 struct atmel_i2c_client_mgmt {
 	struct list_head i2c_client_list;
 	spinlock_t i2c_list_lock;
@@ -131,6 +135,7 @@ extern struct atmel_i2c_client_mgmt atmel_i2c_mgmt;
  * @tfm_count           : number of active crypto transformations on i2c client
  * @hwrng               : hold the hardware generated rng
  * @ready               : hw client is ready to use
+ * @caps                : feature capability of the particular driver
  *
  * Reads and writes from/to the i2c client are sequential. The first byte
  * transmitted to the device is treated as the byte size. Any attempt to send
@@ -148,6 +153,7 @@ struct atmel_i2c_client_priv {
 	atomic_t tfm_count ____cacheline_aligned;
 	struct hwrng hwrng;
 	bool ready;
+	u32 caps;
 };
 
 /**
@@ -192,7 +198,7 @@ void atmel_i2c_init_genkey_cmd(struct atmel_i2c_cmd *cmd, u16 keyid);
 int atmel_i2c_init_ecdh_cmd(struct atmel_i2c_cmd *cmd,
 			    struct scatterlist *pubkey);
 
-struct i2c_client *atmel_i2c_client_alloc(void);
+struct i2c_client *atmel_i2c_client_alloc(enum atmel_i2c_capability cap);
 void atmel_i2c_client_free(struct i2c_client *client);
 
 void atmel_i2c_deactivate_client(struct atmel_i2c_client_priv *i2c_priv);
diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 6e6ac4770416..3853d2b95449 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -173,6 +173,8 @@ static int atmel_sha204a_probe(struct i2c_client *client)
 
 	i2c_priv = i2c_get_clientdata(client);
 
+	i2c_priv->caps = 0;
+
 	memset(&i2c_priv->hwrng, 0, sizeof(i2c_priv->hwrng));
 
 	i2c_priv->hwrng.name = dev_name(&client->dev);
-- 
2.39.5

