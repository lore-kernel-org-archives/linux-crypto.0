Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECCF1D5170
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 14:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779199844; cv=none; b=WJCLG5fmHLEngZxhjphjA/0okAGKLuKRD+tWnp0hB90UOxetsShgO9gczPlWeF0Q3XUXKonX7ClMD3ctsxbv0VmleF5tdf7CXnGF+Mcnh4xOb0Jnw8rmEBYhJLc6PRdoIJ/2N0l+x7UYnTGHzRJrfRRNYR6C5WLISqvEWXN+NYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779199844; c=relaxed/simple;
	bh=ElZSFnN/XM5YGAs1Zqnf8SqCzctIA5yODBWQ4Y3lhoU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZtGamRI1VIvsxU4UyNigjWa7pNSV5qn7PRil5TrRihkPy9T+lEUiyRNv1NhAsL+w5l99e0TAbelBP0nV3gmkl+bRc6V/quAg1qUb6yi7LIVHISJ0xkAQhxOaQLqkQZ0ozpsQQceYv9xkk9kKoSfnw04P0sTCj0PRitfebYmg4DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b=bDjRGt6t; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b="bDjRGt6t"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4891b0786beso25190535e9.1
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 07:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1779199842; x=1779804642; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=N9lSel/09AkblmaVWdGZHXaGbI2zsZxvAoh/LlPTdKw=;
        b=bDjRGt6tmr7UtpdPHiC0fBScofQzTPtqwaVxrcwbTrFGidjr1LlnU4AIcM1Gw7J1RS
         h5nJs6a+uF84uK49hS/O/gjVOmVy/EaBdsAllRZtoqqBYmQDpK3G+zuLTMpNGVr7ERPY
         W/hFeoM6JcSRwe5jz3RVqHSWfQgAX9ZFxiA8D63gGMxtfSTioWvrAr0dXASWfW4bd8+Q
         sqRl5xD+rnkrhZFJUBjCQqwrHjzuH+jxdQlqYWEKAKvHVD9cLeJIg+JiedL0DHcuDsMj
         uM7QItx6LaswL+f4yXZDC7fKX1O9Z9xy85FPhkgH1n55eweR0U+LALCk6IpuSA66u/q0
         /OMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779199842; x=1779804642;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N9lSel/09AkblmaVWdGZHXaGbI2zsZxvAoh/LlPTdKw=;
        b=YaaYrQwBTVfsgUD/L97oiFfkqGH9bMRe6zYH7MbElXsV9NiaUk0lWYY0hOOlDaGz3q
         Lm5Ya6o2CHbboj9AeIHtLS2dmacCCtY+FdqzkKL7eNGLnAOoGsKa5W9pWV2Fc1IztN5v
         FMx+6R8ae3Dxooh1/wifZ2RGK0q8X1wHUvvQb+ck++bp5eg4BimW7kaIgxfoZAtLa5tZ
         +35OV7MhWVGtbNwrnAIZJE6CilPVtHfEJEPEdR2qcqdktC83szPzzIXpuOUNyO95rfC6
         CiHStASVgFNDRG8cdg3ZeChrPumqXFqB9tnhWlv8+ErxUyCbHvrsOE8GiyBMqMoHe9Wo
         vUjw==
X-Gm-Message-State: AOJu0YxHJD1k2h0Fll/+8k9zuu762tfsba1dlgLNmwGd13dKIjUNhQUc
	0qJXvQMWCF06C72ae6n4nKgAJIpLawd6/8lWI6DOXzdZzvuzyNC7ye9pXZhIvX8WCfo=
X-Gm-Gg: Acq92OEjKwiUpeoH5l4Obk5wAiaUPnfLgh7MJxRa3beRSJR4rJKv7ZOWAOdW/ft2jv4
	XPNUtPEiAcZgtRkcrGmWinJ6ZwmXBiQwf7ShLkabRVTeFISiPqInEe9zdiaiZZmB0oavsmQHpE1
	67JIdcSItkx0P3VmGGTZLS/2Achcfwifec5rH9IqtK61cflh0PlSKrFBLJzA9mFCNaDkH3yEeY/
	no3J2n8SyhDDTWMeQxrePL8Xok0o2kuUBfxgNl3LYchevmfVsTMmCpO3kyccue4/EHbSh6Oiyig
	fgR09iRrj6gNQh1y57SlWn36xTWuomK2i7RCsJrwmCEMFcJzBQ/OKxRi/qH4ENo1m66XUQZsD2J
	/IN2H9iz9UpWcHIMSm60YVYpeM2Z3zi6EI9UIWycS9hiGIqq8V6KxVZaE5QCw/15YCEu7vKh9RK
	H0Ue2g1PeIvkTNorqo1GtchE36sv2OZM4w1EeM4Mhqyc/06BjoKIyWASO2EnZCYEdrJ7waFlNtC
	ueE6ZyEdfkCkkE=
X-Received: by 2002:a05:600c:34d3:b0:48e:6db3:ff3a with SMTP id 5b1f17b1804b1-48fe63270fdmr286980175e9.16.1779199841653;
        Tue, 19 May 2026 07:10:41 -0700 (PDT)
Received: from localhost (p200300f65f47db048a8dfcf61053817f.dip0.t-ipconnect.de. [2003:f6:5f47:db04:8a8d:fcf6:1053:817f])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-48feb029180sm162671535e9.4.2026.05.19.07.10.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 07:10:41 -0700 (PDT)
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20=28The=20Capable=20Hub=29?= <u.kleine-koenig@baylibre.com>
To: Thorsten Blum <thorsten.blum@linux.dev>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1] crypto: Use named initializers for struct i2c_device_id
Date: Tue, 19 May 2026 16:10:33 +0200
Message-ID: <20260519141033.1586036-2-u.kleine-koenig@baylibre.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2163; i=u.kleine-koenig@baylibre.com; h=from:subject; bh=ElZSFnN/XM5YGAs1Zqnf8SqCzctIA5yODBWQ4Y3lhoU=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBqDG9aX5GbUFVaEdcDLwiZcVrqdY0sNsGs+se1b CDirz8BN/CJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCagxvWgAKCRCPgPtYfRL+ TnHEB/sGsKnjrOQJ/f7IYTwCz+SmY4MBiiGushJDD2o4i41S/5LBbxncRtM6MeL1WnlJk29j1Qx smEi0rHK4EZQYLhTYr8vVdsmhkT0z5gR+DKhuG/en59JQgwkvBJYmg827Nxs5AjZks4mm7GqXOZ tlqXT+Q9H5mkHCFPO3JMN9Q1GyHoV7NG2XpAgu5cqy0bdFbBGwQShyutRmU1AR4HKcJYcri0O+M OCN76C6JdlPPA7xLwTqbPuwqwvqj2d0BroGr9VuX6fL4AxZbIu46fZ40Au6Xb/7Y096ePaFP6yi hORAnaXuigGSzvjU9ABYw4Uf8AcdxWpwu683hsNkxgo8EZq4
X-Developer-Key: i=u.kleine-koenig@baylibre.com; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit

While being less compact, using named initializers allows to more easily
see which members of the structs are assigned which value without having
to lookup the declaration of the struct. And it's also more robust
against changes to the struct definition.

This patch doesn't modify the compiled arrays, only their representation
in source form benefits. The former was confirmed with x86 and arm64
builds.

Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
---
Hello,

this patch is part of a bigger quest to use named initializers for
mainly struct i2c_device_id::driver_data to be able to modify
i2c_device_id. See e.g.
https://lore.kernel.org/all/20260518111203.639603-2-u.kleine-koenig@baylibre.com/
for the details.

This patch here isn't critical for this quest, as no driver makes use of
.driver_data, so apart from the better readability this is only about
consistency with other subsystems.

Best regards
Uwe

 drivers/crypto/atmel-ecc.c     | 2 +-
 drivers/crypto/atmel-sha204a.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 9c380351d2f9..56350454ac29 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -380,7 +380,7 @@ MODULE_DEVICE_TABLE(of, atmel_ecc_dt_ids);
 #endif
 
 static const struct i2c_device_id atmel_ecc_id[] = {
-	{ "atecc508a" },
+	{ .name = "atecc508a" },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, atmel_ecc_id);
diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index dbb39ed0cea1..0fcb4692494f 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -210,8 +210,8 @@ static const struct of_device_id atmel_sha204a_dt_ids[] __maybe_unused = {
 MODULE_DEVICE_TABLE(of, atmel_sha204a_dt_ids);
 
 static const struct i2c_device_id atmel_sha204a_id[] = {
-	{ "atsha204" },
-	{ "atsha204a" },
+	{ .name = "atsha204" },
+	{ .name = "atsha204a" },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(i2c, atmel_sha204a_id);

base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
-- 
2.47.3

