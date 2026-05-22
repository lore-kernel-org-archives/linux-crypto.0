Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D1F368941
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 23:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779490917; cv=none; b=tFUn1ogTNSab9qByhWdzBA0T26tA64p116t4STraF3C9Aw/SRRj25KQ1bdqNHiZ+sp62Re34Q/qOVPyiuuRm+Amun1gsZ3A6ZY4dyX4dPYdxunyA1T4jYsBeNEIre/ktNlGJPbs3PNsZEKHco/wAo0j+UecWj1BAh7VAktRkKyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779490917; c=relaxed/simple;
	bh=5t9imB8TQUpIuhr2NaXIAgQ086dM4YJDsGiJoMdidVE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L6sw+ObkRyLKMHZ6NkGcuFObmcVbMEsesWv/Lpa7GcXVI5XYAZErV9sY8U58aZatZxdPTuNgKzFV5fGGhfRpA4XhtZjvbgqKHG7spy+JCtA6JNhNNErQOFm9DWLxDHnoEw6WuvM01v/ZIExtrXGvLEYV26wUqjFqRTHnWBdhQJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eFSkcNjs; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eFSkcNjs"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-44ad87a57f6so612377f8f.2
        for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 16:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779490913; x=1780095713; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CYnl6H7JNYvzOK1yTCqArfWOoQ9aVJm0Lozs66ZGulI=;
        b=eFSkcNjsPZS3FJs3s6NrviCofWhwl+DyXZls+h4VK/QK2jdZj9Nn6WBFEVbUDg+MSF
         qPrrXQOiuh1tDYKDkNoQcmmcuErigjPCvlOekFBaFxCifnlK/jT18gxyCZca8rkGkkJC
         tOTDrQH8hUS9RQOjICHKC7oPABZ4lLRyl1oMqBTGfiHoJ2o9sX4fOz1zrjyU/BarJemd
         8lzQV+EjnCgVHmnGhteiMl6vlpP1K+UFHWYC53amMkzRwmWNcA7pd4o5g6MnQIedu4RF
         JoyxrwME8A6fjXjbjaRFSj8xIEsKsIUUWK8lelu65d/d5lrSdCBqDFuK+jbQmfhZUCya
         7Xqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779490913; x=1780095713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CYnl6H7JNYvzOK1yTCqArfWOoQ9aVJm0Lozs66ZGulI=;
        b=IK5xjvETi/nq1kIudjWKsjwNbKwBKKfS8E5Q8xmJYx1DYJtS79N3SfG17Ujxc/58wF
         nefaziFpXG9Zsb8Q0c7h+BP+jW+kc1681JlOs4vA1Tto6ekXQe8Q3IpN56ku6V3xqdoY
         7WhbQUMJzPxmGXpZXKPYeVy+IrfG1HFbEG2YKcBrzRr+ClEA5rrpDVHCN8qcZgMrsWyp
         NRRCuIc6r/jAOvk3EQ0JvJ/GpmeBKGCYnN+zQ2AtQJluWWv2yi07aqRgoexlfmpNGQcW
         5XXIFzL6o09JVWbEMWqMRNtjPixJOmNo1Hl0RP5qe7qGd4UKl1zH8Q422oi33q3ja+5V
         pLyA==
X-Gm-Message-State: AOJu0Yz8N/O1UPoNCEOXpQvpF5P0zaLfoUOUk2PM8PpDkeM4FdR5SZ3G
	7A04cRJpLdx0vVQ8uCRejKiIGihEFqoTBh68qJgyrbJHW3QwX2+59s+T
X-Gm-Gg: Acq92OGN/2t5pyK0vOf97/X24U9d9rBCbuJmBSwiQqmM5exXBoBzv+McH+j0aFj+nrp
	0N6vG5inkOR7qB1qRtO0Oeejqw03Jfm6Bvc+QceZa+8VY7mb0EW2q5/UoVvoZjHJ1ctJGmoXXgC
	xOp0W2JgzZXOiFg4HYxGbPX9qda4tWoHVOAp31pAwpkOAMTUPJg35rHmRkVrdihedKimr2m6Oq7
	OOOHGtiW89S7fyi1/6Vn+SCgB5nw1eBudpTRCx5KhIWnDFHrFYAvqUr1SSqUESfRYyutJbHGSbl
	U/XEDanZI/lIgIINEZ6iSaMzFFpdWNtOPe7AWuCvqVPVsZh6U4uDHJOBD6SnKirRbio256ls3/E
	QiSAtngRKI6Kb5AWw81WpzrlySt6BqIsJFKSrXX/KcQoDIUT3chk+HJg2I4kFmhWPJZ2frG2vlu
	Sr3s5UJa7kEI/dNYEqRCbVvaERpjy9e8u7fV3TCVqDA8PHsLv9i0bK+U3Bpm2Uw/8=
X-Received: by 2002:a05:600c:444e:b0:48e:7a10:1f5e with SMTP id 5b1f17b1804b1-4904248ab61mr37470595e9.2.1779490913007;
        Fri, 22 May 2026 16:01:53 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490456274ebsm67100265e9.15.2026.05.22.16.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 16:01:52 -0700 (PDT)
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
Subject: [PATCH v4 10/12] crypto: atmel-i2c - implement capability-based client selection
Date: Fri, 22 May 2026 23:01:32 +0000
Message-Id: <20260522230134.32414-11-l.rubusch@gmail.com>
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
index 16e607cd06c4..76b8f9e7c2e1 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -212,7 +212,7 @@ static int atmel_ecdh_init_tfm(struct crypto_kpp *tfm)
 	struct atmel_ecdh_ctx *ctx = kpp_tfm_ctx(tfm);
 
 	ctx->curve_id = ECC_CURVE_NIST_P256;
-	ctx->client = atmel_i2c_client_alloc();
+	ctx->client = atmel_i2c_client_alloc(ATMEL_CAP_ECDH);
 	if (IS_ERR(ctx->client)) {
 		pr_err("tfm - i2c_client binding failed\n");
 		return PTR_ERR(ctx->client);
@@ -287,6 +287,8 @@ static int atmel_ecc_probe(struct i2c_client *client)
 	i2c_priv = i2c_get_clientdata(client);
 	i2c_priv->ready = false;
 
+	i2c_priv->caps = BIT(ATMEL_CAP_ECDH);
+
 	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
 	list_add_tail(&i2c_priv->i2c_client_list_node,
 		      &atmel_i2c_mgmt.i2c_client_list);
diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
index 92d3e28f9d9a..4953b8fcb02d 100644
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
index ddab80bc1a72..af2e49332ab6 100644
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
@@ -149,6 +154,7 @@ struct atmel_i2c_client_priv {
 	struct hwrng hwrng;
 	struct completion remove_done;
 	bool ready;
+	u32 caps;
 };
 
 /**
@@ -193,7 +199,7 @@ void atmel_i2c_init_genkey_cmd(struct atmel_i2c_cmd *cmd, u16 keyid);
 int atmel_i2c_init_ecdh_cmd(struct atmel_i2c_cmd *cmd,
 			    struct scatterlist *pubkey);
 
-struct i2c_client *atmel_i2c_client_alloc(void);
+struct i2c_client *atmel_i2c_client_alloc(enum atmel_i2c_capability cap);
 void atmel_i2c_client_free(struct i2c_client *client);
 
 void atmel_i2c_deactivate_client(struct atmel_i2c_client_priv *i2c_priv);
diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 33e5a66b843c..0c5b5cdbfcbc 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -178,6 +178,8 @@ static int atmel_sha204a_probe(struct i2c_client *client)
 
 	i2c_priv = i2c_get_clientdata(client);
 
+	i2c_priv->caps = 0;
+
 	memset(&i2c_priv->hwrng, 0, sizeof(i2c_priv->hwrng));
 
 	i2c_priv->hwrng.name = dev_name(&client->dev);
-- 
2.39.5

