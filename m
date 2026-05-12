Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7D63A75A2
	for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 22:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778625858; cv=none; b=C/ebhjEiX2opjlLfLNWQqNjF36/Iw4TBjd3zWCr9gN3WirCmGw/GEq+ZOwKs6Q3xS5yAYHf/i4yFluCImbOpvu3IuJGs1Sog65PaxNL4+x3rLg8r7CqXgREExzajC/MrHPUZWGNtz7rdmNs5lNhXDt4Bd1jLzDL50k1fXEeZTDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778625858; c=relaxed/simple;
	bh=QkPnUvjHa1+OtKWGRGtD7MPg6uzHbcQWt5mYvvIiRZI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mSBihHV1nSa49Y1PX2GZYTxuphw0mr/jWf6nWu9kjlK+OOs07uuMft/X7R2IGzU0AsA64mpUwS0PH7WjDFruFj5m3BwQ8QXu1hchk9kTeDf/sqffRz9ac4VN8NSzNwNjggQhVTyhbDBnkw/KiA9Lu1eFY3KAEzUWH1xNOnMjDMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OreJbEIC; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OreJbEIC"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4493cf2f982so373931f8f.2
        for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 15:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778625855; x=1779230655; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xgh7Qwrou5qNvOkoF1+XnxYAOb54Zebpq26aOMB+2tM=;
        b=OreJbEICdABUqThyVYA2XCUTjQMhakLt8klZ6JFCnMmlnIzXOBTTDQYgQhs4IgUq8C
         DE+iQ1WTj9F6F0Eu8NOzKGAAek47859vl3r5fmdufHe+g8bnpaJ3MT2Yx42zilW4eOU9
         lMUJQ0DOJmFpm2f/DphTCpo9WegJUHtOmwtC1NPAhKXm/yS6wiLRlrz9bSz9a9YoVmPO
         9U8F7jV0o6yvJquKbWWkwpbG3LkOeNxtijHmvDUFjDfHDsUNaaFpimhlTKVtBJfj6FiG
         IwSUK5FDF4dBcKIJWZ+4tVl1KPaKeFLNef5nmWxYgcFINpAWzHkheco2VTV1ByznofEx
         IaIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778625855; x=1779230655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Xgh7Qwrou5qNvOkoF1+XnxYAOb54Zebpq26aOMB+2tM=;
        b=W/A5WKth2uQzO8cqBOb2SnZfzrDlmXdiqJFffx0V3QrX/x6KfTyFHaKH959vqN5WqL
         owZnJxjJH3VIGoTLLYftloW5/NigWdL9D/6scO3lVJOqU6wLDEjaz59PjYuNbgKDZtAx
         0dz77DD0ZU0cGeC33+vbnBa6q8mXk6t3mYTtrwLefplISEiUIyC7jZe+uwzuvRC1x4md
         XWSfCIE+avOwq6Xa7RkDhDbAwQuJJAVRN4kouEK6ZyurB7opv01FANwET26QRvG+vnP6
         KaNH2jAxDjRUajeOw7+gm5JWpVlmBq70rAZ58dKOo5Erha7G2CnFOykd2K2yR6jnWr/b
         Ud6Q==
X-Gm-Message-State: AOJu0Yxeh+zXk80hs2eTDRGW1Z8084Cug6BP524zyL6xx1cqM5pCtwX+
	zHMklUdK2TbEFKE4jFBQnRYvua/I7UkF87Jq4a3yIZEpT6NUjq+F5CPf
X-Gm-Gg: Acq92OHlqVgHk4XOYu0ze7VPR7OB3XMMJsFEza4rQ4nH5PZ5qUktjRhE6g1jZwt0v1B
	2oWu2yff/SfDv9RYd7/A8kjd+VgyGQwBTukgxIbkyj29smLn+Wn0trawex/eLymYmf5bh9s0h/P
	CV19Ks8MjibbgGqm6CPLwxovNECuYM4GAViXW3gYtTwcUlacZLioTZcYKqPmFvOk3TJloNnuIld
	I3EwYmvYNblfH9CgmOWpIJpGBKBoZkg+dR+a4L5xL+DhZXsDZ/YG7WiC+0DnFgAKP6ilOU9KMYo
	rngrFEm9Wn0RmIePmJnxXB16vHF7I2V4kyid/qRRSAycC6gvKyIeSlbEokJp6cDOA/Wa9wT/GQr
	qk4Q4u5YWast/s3NRvGLB2JERssPNwdZZn74yO/e78C5qO5dC073eyz2rDvMViA/5XC/LgsV9Xx
	NTL/mXjHiGc59G5Ax/9Tx099MGdv/zwFfQiVFa88VNND653wEdqdpTibeAYVFDW9c=
X-Received: by 2002:a05:600c:1910:b0:487:1fbb:5a28 with SMTP id 5b1f17b1804b1-48fc9a09523mr5008635e9.1.1778625855234;
        Tue, 12 May 2026 15:44:15 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fce385ea5sm3194025e9.14.2026.05.12.15.44.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 15:44:14 -0700 (PDT)
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
Subject: [PATCH 07/12] crypto: atmel - expose CONFIG zone through sysfs
Date: Tue, 12 May 2026 22:43:44 +0000
Message-Id: <20260512224349.64621-8-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260512224349.64621-1-l.rubusch@gmail.com>
References: <20260512224349.64621-1-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Expose the CONFIG EEPROM zone through a read-only sysfs attribute for
Atmel I2C crypto devices.

The CONFIG zone contains device configuration state, including slot
configuration and lock status, which is useful for debugging and
verifying provisioning state.

Reuse the generic EEPROM display helper provided by the Atmel I2C core
driver to expose the CONFIG zone for both SHA204A and ECC devices.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c     | 7 +++++++
 drivers/crypto/atmel-sha204a.c | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index b5f2d44ec74c..f08fdf284b60 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -23,6 +23,12 @@
 #include <crypto/kpp.h>
 #include "atmel-i2c.h"
 
+static ssize_t config_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return atmel_i2c_eeprom_display(dev, attr, buf, ATMEL_EEPROM_CONFIG_ZONE);
+}
+static DEVICE_ATTR_ADMIN_RO(config);
+
 static ssize_t otp_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	return atmel_i2c_eeprom_display(dev, attr, buf, ATMEL_EEPROM_OTP_ZONE);
@@ -30,6 +36,7 @@ static ssize_t otp_show(struct device *dev, struct device_attribute *attr, char
 static DEVICE_ATTR_RO(otp);
 
 static struct attribute *atmel_ecc508a_attrs[] = {
+	&dev_attr_config.attr,
 	&dev_attr_otp.attr,
 	NULL
 };
diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 4f10e826e675..341554b7b7a2 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -19,6 +19,12 @@
 #include <linux/workqueue.h>
 #include "atmel-i2c.h"
 
+static ssize_t config_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return atmel_i2c_eeprom_display(dev, attr, buf, ATMEL_EEPROM_CONFIG_ZONE);
+}
+static DEVICE_ATTR_ADMIN_RO(config);
+
 static ssize_t otp_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
@@ -27,6 +33,7 @@ static ssize_t otp_show(struct device *dev,
 static DEVICE_ATTR_RO(otp);
 
 static struct attribute *atmel_sha204a_attrs[] = {
+	&dev_attr_config.attr,
 	&dev_attr_otp.attr,
 	NULL
 };
-- 
2.53.0

