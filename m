Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C483CA48F
	for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 08:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774945280; cv=none; b=VuJ9IRsrYoVPRSm1sSGyGrrXW7OGCNRbJ/N5xXP90E2fcP69o22UoyLQTXqvnyFo+FhOA5AN+fWFyGlqQE70t8GVwPRStE5sDHly8cyc4Q7soB5a+gL8WyHLCgG3wzsqoqM9eB71Rqt9wT/uHIlM7T0qdcOGDg7sjmmXJZMYp6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774945280; c=relaxed/simple;
	bh=8IgV1on/CYjRoqaNPKrhP/jyDrUspemaCDxzCZHev6c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QbtRvyXrIXVdva58N5HAfxol8JckmlFWUZyC3lTw6Ol66qvWmNe4cGGZXIMyvjXBfxBxk7vJMbONG1mwcLKj19azFqSLMQz91+o8zGr7iGGNIC7NeMI5yUMS5lcP/wvOFw4abt/xTva4d7BQNk4M0KFXDhYQQgEekH1a/ErWElI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OVz/Y51f; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OVz/Y51f"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4853a5ffc05so11516675e9.0
        for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 01:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774945278; x=1775550078; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZlXweF85hjs0Cz7hgZ4Sc8jEj+2x0ePWSuvmjZUgVoc=;
        b=OVz/Y51fQxzM9AEi/DIJuUxGcsOy1/jYZ0tEvclQb+SHqh+e9Xm2Tv2lXecb3OJbbM
         kls+b2Mb/jVPDVIFRlnlcbhtiyIdZkBhSfHCVfzg3NGUMtt4q9JM4q9IdfRwTsUUZFCb
         Yeb+QYaAkM8SI0PIMXThNFlXV+U5mv1VCCpBe4RsqJ0Ad1Y5bsRyjMNjAyZrCIPtlGq6
         OV1gga4jCdKV8r40nFWkgoAfId/6zuzrEBaLDo3aWTuYYuMDsn72X/2IcMrOa0mady/x
         cCRp++jG7MOiUBS+hHB8nN8meMv0YQYtoVeFacV/ySp6ISD1I0KrtNk5vuOFGol2irFe
         7A+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774945278; x=1775550078;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZlXweF85hjs0Cz7hgZ4Sc8jEj+2x0ePWSuvmjZUgVoc=;
        b=WFqlWSD6VpXRTagyUt+WBX3yRxNxtAwpYPgXrR46Os1FJL2evnJX8B4ctvvBaRnP09
         kU9Dc7baL56q7BZFgx4Lt9cAj387FFYIcdlPX65jHWkwR+VQv0V87AffbPJ+Wh5oatvw
         cHb7L7msh8I0rTIVpoa3Fzyg0UmyQW7Vcb5nTtNSrBoMCT6u7Z6LpXa+brjabRN/4R35
         J/kvd+PyldOw4bQOi/EuABL39rxmx87iKAeYY7rJ7bbe60L8HnrOOxTSolcBxEZGsgU3
         emGf0IIR3keCpcwocy6DorTejNfTztjd9vU4IeFrF+kQ0nfUZriZs4c77VDNHYEO+q5s
         uVeQ==
X-Gm-Message-State: AOJu0YyRWHyO5ha6pGhr2n/rDlA3zWtfxfI5NgYL32waMRlyiuuOw7Nf
	b16Cabq0urww6lPY3WVtzqpoC+GrQVphPIZQiPZoDaDZUNZ2k3Oc4fBS
X-Gm-Gg: ATEYQzxR5Yavx31fVeOeqPt84/+D9TFPLK/KA/9yMpx0Ir2SrK2i8O13dHraag4gYcS
	8j5+o43OLzECeceBovyYQCBArlMZgK/LSEfFH7Taum6IxuX4oxwEDNhbtXY8EPDAqCnvgCpQ6hZ
	E6/PWLCZmpWERAYx4B8dracE0HDwxLaRj0i3bfvspdWnnMeS903EAqQFIFFWznRXUKVHKwppJjt
	v5QYSq+U83bHMIx40k0LATE6XSYgglHevpeadUQeCtXiSy764bILI8KvtrPudftwsNM8l18Xpxy
	Ehu2uAYBSQaOS8zNww1ifafh0k6fnMHuV06E604Jql2dkq7qewtIXzxUAzNHM274nLu4eX8J0gq
	0Lm0kII7W2ahmtPcRjao3p9i1ev9sN+emjU6HP3RsZUUDS652OkNSckYpR8yTxx7Q9eq8Y3CSx8
	WGRuS+l0VG+ZmFE8fTQsgJEPmOYz3MaGSOlQsAcFcoxROcytIVbuQMHF6Pa9H4vPw=
X-Received: by 2002:a05:600c:1f8d:b0:47a:94fc:d063 with SMTP id 5b1f17b1804b1-48727d6fc1cmr150113965e9.1.1774945277374;
        Tue, 31 Mar 2026 01:21:17 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4887ad8d28bsm14542485e9.10.2026.03.31.01.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 01:21:17 -0700 (PDT)
From: Lothar Rubusch <l.rubusch@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	ardb@kernel.org,
	linusw@kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	l.rubusch@gmail.com
Subject: [PATCH v2 1/3] crypto: atmel-sha204a - fix memory leak at non-blocking RNG work_data
Date: Tue, 31 Mar 2026 08:21:03 +0000
Message-Id: <20260331082105.697468-2-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260331082105.697468-1-l.rubusch@gmail.com>
References: <20260331082105.697468-1-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The driver allocated memory for work_data in the non-blocking read
path but never free'd it again. After first read-out the memory pointer
seemed to be recycled and never was allocated again, due to some errors
in the logic, so that the leak was not growing.

Add kfree(work_data) in the completion callback on error. then add
kfree(work_data) after the data is consumed in the subsequent read
call. Finally ensure atomic_dec() is called only after the data has
been consumed or an error occurred to prevent race conditions.

Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A random number generator")
Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-sha204a.c | 44 +++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 98d1023007e3..1baf4750d311 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -24,15 +24,20 @@ static void atmel_sha204a_rng_done(struct atmel_i2c_work_data *work_data,
 	struct atmel_i2c_client_priv *i2c_priv = work_data->ctx;
 	struct hwrng *rng = areq;
 
-	if (status)
+	if (status) {
 		dev_warn_ratelimited(&i2c_priv->client->dev,
 				     "i2c transaction failed (%d)\n",
 				     status);
+		kfree(work_data);
+		rng->priv = 0;
+		atomic_dec(&i2c_priv->tfm_count);
+		return;
+	}
 
 	rng->priv = (unsigned long)work_data;
-	atomic_dec(&i2c_priv->tfm_count);
 }
 
+
 static int atmel_sha204a_rng_read_nonblocking(struct hwrng *rng, void *data,
 					      size_t max)
 {
@@ -41,31 +46,36 @@ static int atmel_sha204a_rng_read_nonblocking(struct hwrng *rng, void *data,
 
 	i2c_priv = container_of(rng, struct atmel_i2c_client_priv, hwrng);
 
-	/* keep maximum 1 asynchronous read in flight at any time */
-	if (!atomic_add_unless(&i2c_priv->tfm_count, 1, 1))
-		return 0;
-
+	/* Verify if data available from last run */
 	if (rng->priv) {
 		work_data = (struct atmel_i2c_work_data *)rng->priv;
 		max = min(sizeof(work_data->cmd.data), max);
 		memcpy(data, &work_data->cmd.data, max);
-		rng->priv = 0;
-	} else {
-		work_data = kmalloc_obj(*work_data, GFP_ATOMIC);
-		if (!work_data) {
-			atomic_dec(&i2c_priv->tfm_count);
-			return -ENOMEM;
-		}
-		work_data->ctx = i2c_priv;
-		work_data->client = i2c_priv->client;
 
-		max = 0;
+		/* Now, free memory */
+		kfree(work_data);
+		rng->priv = 0;
+		atomic_dec(&i2c_priv->tfm_count);
+		return max;
 	}
 
+	/* When a request is still in-flight but not processed */
+	if (atomic_read(&i2c_priv->tfm_count) > 0)
+		return 0;
+
+	/* Start a new request */
+	work_data = kmalloc_obj(*work_data, GFP_ATOMIC);
+	if (!work_data)
+		return -ENOMEM;
+
+	atomic_inc(&i2c_priv->tfm_count);
+	work_data->ctx = i2c_priv;
+	work_data->client = i2c_priv->client;
+
 	atmel_i2c_init_random_cmd(&work_data->cmd);
 	atmel_i2c_enqueue(work_data, atmel_sha204a_rng_done, rng);
 
-	return max;
+	return 0;
 }
 
 static int atmel_sha204a_rng_read(struct hwrng *rng, void *data, size_t max,
-- 
2.39.5

