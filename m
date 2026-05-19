Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3B23C2772
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 20:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779223703; cv=none; b=e91/22CEEjeLM4s4lWKJVJO8wN+QoS6a9WqljnAgS5HhUSjLIU0UB+3KiMAUSKYM0rMLIUCkCZTYp8Ad7gP2JB7AkWnP76BVALvj+hv9tIChMC8e78BJSqG90lc0uAaF/QQsCNofLvcrm4ptb+3d9HYVL2UgLkBI6i6wWWSD95c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779223703; c=relaxed/simple;
	bh=7md/GO2YbdMxhovqDbwh9Ck8m70e0HbBva2h+wz2M+0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hxFSAKbvBD/jtUlbTxr0vBAV6sTREIYCusBl7UTU0RHFhAtDgOz5tZV7ZtM2buYesbPdT+TZ6o9Cy8jEvATMUJgHzaOoU6L0I+ijnD7Iqe5yaWxaFHd7N5FGlKRcfZXA7CgxiFT5xLdR1UblinMqMoEdGkk/nEZuBLqt/CaXuHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eT48dX9U; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eT48dX9U"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-45e6c2d9c5cso246598f8f.1
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 13:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779223696; x=1779828496; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0iv91Yr/xdaF4aAKWiyJjatlZadYEBC7HnO1idj6/DU=;
        b=eT48dX9U75guiiMZ5iMHlhkZSqF/EQ+zCaMAjNhG8SGztzQOTOipmUxBIjJ8C/kl38
         qnU7R02uhfVVLxFfh/qkhHYDfP4xnEv7Lcw3Zs9MY24oztoOWySgIuoVrtyyjNvoUmmi
         D5ifzjXOyJbdvUQsXKHeG4LgyBCbwHKGsiisWsGAuSP55pNriOJenkqykDGKwI39b9Bw
         IqK//slOe/zBNFNg8Dz+Rwp+n6IKhhMZ6vFsLLg2l8qrFGbkeGDaRkTcAjdpT737barc
         j3+7YsjiL/O+ejdhVuY4+PCfvBBMt9/UYcJPfIavu/QxcSUj9j4kNTEKNVkUs9h6g8xk
         VsZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779223696; x=1779828496;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0iv91Yr/xdaF4aAKWiyJjatlZadYEBC7HnO1idj6/DU=;
        b=hJBK2FIrKuUk+YA7mek0M6D61U4o9T3f7HQoEJcCPYQ4/YLeZ9AegqLx+jpnZdYYAu
         2uSusJqQ/o5qGShOvbSJMhtdd3GSa2iMyMlZz22uNoYTvFlf4+hhiKh5Pq8Np54kK3sq
         C8TVkdtOPBPVFJbZe8akn/Y+5oUmY2CFw/hqw9HNsmXJHSV4oEkvo5XZO7zNYsAWpKNd
         MmrNbW4afaQ/Yz2bP3Aglr8FtXVKOLYCoimNKPvyi1AEUlN5xmGOF7o/sQTR+DNrZH3B
         s5T79bvlA9546tpUTJnpuiqXqjLMX4gom8q3dOy0i4xV2OEHna3aoJkzGdW3L3dwV2uf
         SK8w==
X-Gm-Message-State: AOJu0YyNTUEkkNmVVnmePdlxE4HZVAyb0eEGSOlZS31sh5Yh85Dc0zs2
	uvhpL2XkWyTmq+1pN5j/Dj70xJhGMCdsShwXKDE+hxhukPL3J7FZmU8J
X-Gm-Gg: Acq92OHJ5Ltzz2v4cJRjN2jqxiGNvEjYSfdnHYMwnwy1EPw54XCHSc72s8k3l7TWBDt
	zXG5rE0pOcPbJGJj6d813ZaiTEobRcc8O9cj/ISO/dQ3C7Izrtx54OcfWJXInjfAHpCvX8aW+LQ
	8bJsvEMlLDQl9WHt20Zxefx/X3pKjLlnzE6YtQww9ukOBqejTWy4e9mXsAy0DG+fgWGhwfyUksD
	FSED97H3qTw5FYXrc5TEunyL/9khKuZ1ezLWh0k/71ZxsjJdZIUTeQSoFvCV6fTfI3gkMqf1oEl
	u+htu9tcWa8Doy6NjZDGdCKVWdqosiYRRnd/86sCN1lUs3R03tkzL9QPEAd0zdcYrcHYeqGk2iG
	jEqdnBVG8KHlllwycN6vYIK2SgW9LtA8SNtFYxqN1/Z63MuTnspS2Vu2qgeYTFx7hXdNdw2vqYo
	9YLYXYu2ebbnoZos43uveMe6xgfXPVqWq2xGBln/aWCQM/0d3ho4bBJngJkQfUx+mqjJ0PyGjRT
	g==
X-Received: by 2002:a05:600c:4692:b0:48f:d410:6072 with SMTP id 5b1f17b1804b1-48fe6302a9fmr178240165e9.6.1779223696104;
        Tue, 19 May 2026 13:48:16 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe4dac000sm356457755e9.0.2026.05.19.13.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 13:48:15 -0700 (PDT)
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
Subject: [PATCH v2 07/12] crypto: atmel-ecc - switch to module_i2c_driver
Date: Tue, 19 May 2026 20:47:58 +0000
Message-Id: <20260519204803.17034-8-l.rubusch@gmail.com>
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

Remove custom boilerplate module configuration code and convert the module
init/exit paths to use the modern module_i2c_driver() helper macro.

This shortens and simplifies driver initialization. Custom structure setup
is no longer required here since management tracking context initialization
was already safely moved into the atmel-i2c core library module.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 29706e4bfa04..4f27e1caf106 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -401,18 +401,7 @@ static struct i2c_driver atmel_ecc_driver = {
 	.id_table	= atmel_ecc_id,
 };
 
-static int __init atmel_ecc_init(void)
-{
-	return i2c_add_driver(&atmel_ecc_driver);
-}
-
-static void __exit atmel_ecc_exit(void)
-{
-	i2c_del_driver(&atmel_ecc_driver);
-}
-
-module_init(atmel_ecc_init);
-module_exit(atmel_ecc_exit);
+module_i2c_driver(atmel_ecc_driver);
 
 MODULE_AUTHOR("Tudor Ambarus");
 MODULE_DESCRIPTION("Microchip / Atmel ECC (I2C) driver");
-- 
2.39.5

