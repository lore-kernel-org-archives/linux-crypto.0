Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7AF3546EB
	for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 15:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779292642; cv=none; b=mrMuIk6In5NCR7PCpaDtlgP6dCK22b2wjSbkw/AuhGVSs5ADtFk4DX1sB7Y6Ass6Ib9Nw7KGoWgjwVSPouu1Kgp+xglsx7jAiFJTQvpwQr5KMw7YMHM0ieEE1SauqxqAlXLXaKmvuMStl0QLlcn5+xlUGxuhRdD21I0aFwQMlBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779292642; c=relaxed/simple;
	bh=hYYdyCs9GfNqLomMs/oOk/grMGDcxDilMXUzArpoRks=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mSvFvOYvq3j6tYUnHJr/sHDInMxAi2qi3gyWE8dYz/okOkMHnZTB3ideCEyXh3r/Oi+opzNKhinm5Zc3pYP5HUshnUUJnRhv/59YJvmOYiFRCzbt+dv9QStRBagyXDv19aAGtQTGhuI0kaJT2lJM2yuN3WXAyx6xFlwz/2tfX84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kewT0lzK; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kewT0lzK"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-48fde2f2d61so8460175e9.3
        for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 08:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779292636; x=1779897436; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rqqB3wEr5ZYs4DFpxkY8toYweVvRXAfc6YYqHonw/aw=;
        b=kewT0lzKuVTMalD1qaYCXMrL59du9Vpw0inBwiO8S2XP5feKCDEeI4bRJl+olKBuYu
         nz727GJ7gDOhc5E9kv0/TkxqOmgX9vFcPZhskZPsuOaa9Mlsi16TUrxBvBp7Mn5WZ+t3
         4ceep4Q1JC8wMmrL0HSV1E9UjjiWnEh+vUmRT+bCHkE1DUMbWma9RFtlUUs/u31z7lIw
         57lbT0axzSMEJzPsZ23J9gD0tAndtCXvZ+YyytCs0vbAqFomLSavu/cxnzaCu8xoefoB
         n0mTOIheGEZDyIgdEvbr58AHApChrq38v13jdWSbuun/0g5hFY3bz76Lk/CkLNj1MevX
         xNCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779292636; x=1779897436;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rqqB3wEr5ZYs4DFpxkY8toYweVvRXAfc6YYqHonw/aw=;
        b=dPbSAQQhYCw3WzheJ0h9rmVGE5cKQ8y5V37BpC704mb9iACCF2+Xut71o5f1ZvSwUi
         w+J8jsVYkFuL1flmM5j8GE1O4FavlSa9fcBewvH3q6KqwnsFy0idXxt+73Uj3x1l+h54
         XRgyHvU2brq1JUsVkmFTPx9G9LUGQyegWOHWhHOeCLdjC+vsOVhuUr5nO1eOk2P4TTz0
         EPKwlzXXoPX/8b02U2ln82B1Z0uiWkWR+kawF3Vh23Gzw/rziTj9FN13+IChzOri9qhB
         kTdEI809uCaP52zrZYVsNl50KcySIBpVZ96yWx/EgqnDTVHgmOPqL4GqrqNaXKtz/6ft
         u1Dg==
X-Gm-Message-State: AOJu0YyRbzNu6q79OGjksTbYZToyFL3YcOuw9Mc+9CGQnbES/EcUJYxe
	cyoLupXQJd6vaJasw6ucPNWDwlxs9RpNTTnqoJRKm/cBZDrvMxSGiaR9
X-Gm-Gg: Acq92OEEgHjb+4Ue+iL/Q+MpwEOiaWPsutn+qbk9ETC/bkHs/i1Qb8CwP4bBNNr6Fld
	dGP45O6lUAoLyH72MruX+0lbBnV4jpFfKiumVKNzHi4M7GMsdw66APwtaywt/8N4NrbgNtNcc6A
	BGqKinGTW7Fqf7NCXiDZp4CaHguxmBDy6PCzJsWkOxsbfFYg8rcGgVyxCXpCzuWbNRUr4TDOXOW
	bPdDvp5vE9rmNjTSNTP0HZNHIuwB0jKIugVvVm4shaWeYuYHDSPwGQeZoKLYwywQ5otaf/lf+6X
	ogKKwdoYxOnf+3lxKCAcHrozmVIjrASIGOmr1falMAlTi7tCtV33HmO6ovofhKGHqpUI81yPVMI
	qUYVpGZInbJL8taS731wVXYf2tx6yLpCvYDdYw+dUOwce+mvookQ4w4eFJhP2vMPPVb2InZAW53
	5hpzrKB9bUM/n9gzrsSm3egjFJkP5C1v5DIjqSW+lkDo1SuZM1nXpvwxI7hYa1zaI=
X-Received: by 2002:a05:600c:4fc5:b0:48e:65f3:a950 with SMTP id 5b1f17b1804b1-48fe5fd55cfmr179726255e9.1.1779292635532;
        Wed, 20 May 2026 08:57:15 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48febe79ce3sm137216715e9.31.2026.05.20.08.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 08:57:14 -0700 (PDT)
From: Lothar Rubusch <l.rubusch@gmail.com>
To: thorsten.blum@linux.dev,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	tudor.ambarus@linaro.org,
	ardb@kernel.org,
	linusw@kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	l.rubusch@gmail.com
Subject: [PATCH v3 04/12] crypto: atmel - rename atmel_ecc_driver_data to atmel_i2c_client_mgmt
Date: Wed, 20 May 2026 15:56:55 +0000
Message-Id: <20260520155703.23018-5-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260520155703.23018-1-l.rubusch@gmail.com>
References: <20260520155703.23018-1-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rename struct atmel_ecc_driver_data to atmel_i2c_client_mgmt to reflect its
generic role in shared I2C client tracking and locking. A subsequent change
will move the client management infrastructure into the atmel-i2c core
driver.

No functional changes intended.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c | 2 +-
 drivers/crypto/atmel-i2c.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 2f82f529228d..b06d47babd2e 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -26,7 +26,7 @@
 static DEFINE_MUTEX(atmel_ecc_kpp_lock);
 static int atmel_ecc_kpp_refcnt;
 
-static struct atmel_ecc_driver_data atmel_i2c_mgmt;
+static struct atmel_i2c_client_mgmt atmel_i2c_mgmt;
 
 /**
  * struct atmel_ecdh_ctx - transformation context
diff --git a/drivers/crypto/atmel-i2c.h b/drivers/crypto/atmel-i2c.h
index e3b12030f9c4..30ed816814af 100644
--- a/drivers/crypto/atmel-i2c.h
+++ b/drivers/crypto/atmel-i2c.h
@@ -115,7 +115,7 @@ struct atmel_i2c_cmd {
 #define ECDH_PREFIX_MODE		0x00
 
 /* Used for binding tfm objects to i2c clients. */
-struct atmel_ecc_driver_data {
+struct atmel_i2c_client_mgmt {
 	struct list_head i2c_client_list;
 	spinlock_t i2c_list_lock;
 } ____cacheline_aligned;
-- 
2.39.5

