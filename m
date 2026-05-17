Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7EB3CB8E5
	for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 18:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779041218; cv=none; b=E7WXOX7ty3humdxX8YTzYBKFDjeCSeA8ctTNUUkVndEOnyjqpJ99eJ74mplLCQdaVt4dpR5v5lW7aBepbw59aKi4jrFFIitZ1GBZxGv8uut7p0rDCBU9L6wSmiGR7lp78ACKf/0RkNBBSMvsl94Icld1YPSmCcu9BltOXBAu/mA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779041218; c=relaxed/simple;
	bh=n/UgRI1lC/UK05OuU8ZdstOBY5ZZBQSZhPMu59M1Cbc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XweCuXrZ3122m97fM++tPZflHMA4Lfd+Qg2ymTPqzXbPmVfplUnLG/baxFaCs2DRFGelL0ocrthsO8nsgp7Kx8SQ7Vn1CoApy0e/6vOWcYJt1ue3y7j5cdYIFi9kZRuTkCbP5JeNlg96b1Y1+ut7p/jUhQo4lULaGjWVyD0Gyj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J7MvzwYE; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J7MvzwYE"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4891cd5927dso2085795e9.0
        for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 11:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779041211; x=1779646011; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XWhNCJ8/sNLNjfPa+oqEi9cxsLwe8oIu+0HMTTzZ//Q=;
        b=J7MvzwYEEI089w0tzC8ISc5MlKAMu++j+Pvr4QpNqGv4zuhSv44EH+ZBhCf62r2JXQ
         q7kaGFIh/nLejYFyS0BJQWukU5YX7P/32OO51rMNK6VRBjm0bgsSGnPueqAYec9maujS
         rOn+gTcIPwoFcYjYuTUG/sre1Tfgjohn5DUjMXsnudba7K0vJJRpZTbC9zKK518/smIW
         CkwoopRAcxxB9ZCnEuURNQWqRyzTjhnY8aIJr0U00EGJkV7uHwR8X1d+FhQ6SZHNgWxE
         hp7VXDoUvEVHiUpYhbmSQsuHZ6jV8SBbZj0tfY6Kmt72z4CBdxLwEq9k+1WxknRnI4OI
         5l/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779041211; x=1779646011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XWhNCJ8/sNLNjfPa+oqEi9cxsLwe8oIu+0HMTTzZ//Q=;
        b=rXOWv4uhLcY859DRyvlcBj5M73BTzWkCiLsMdSMoqGejtibnAVlOWSfS/WdJyo/TNa
         Pp3fkXlsh0s4XMk7gl9vg6TuDG5xUln3284q5YiSPf68y4qnGwiQR9nBXAgLnBCdsydM
         L74b7hobGNHTar4E64d9qCtOdovm/TocWGvtyxYIfa9lczfWL207bGOEW3S68DJNVVqD
         TBVGFaCt3mlH+vOq1S73cpqIBlH+99fcRdiUVtrUq17DygyfntU2pgdAK+yMWBPx8bu6
         nWDt4hL8YfRR84aIvGWaqNIfeZoDKSoCyzNwipnWCK2qG7kGsTuW9BwLIY65vB9Pid7T
         awUA==
X-Gm-Message-State: AOJu0Yw1EtOXQneIR+Xx9YPrK1ShoEMWr81u0rwFNnqoM9GiOCLV4PtE
	gK9boSFuFVEAurvzJGVpgp2QZLbfOJ6qYW1Kg/rh9VzARExDnugi5Rgt
X-Gm-Gg: Acq92OFMRE2vAnGdbVtQOwj0aqxMwgtcMSccw5ksF8ApVPGCwTUOzgnyBIJ4OK/rC/i
	gxqAXN9ehO0wWgWzah0mywyGjyNd3VRZf9h0FbEheQmLgVU9B00pJEdoJY/s+ZpR5T20/NEsmtP
	0pXMa5Jg5K2BQ3Hz/18c3H+OjfydpLdsCN5wqxjzWDrJnPLE9QLpo0Eu3Fio/GUC1PDH20142VA
	VYPZU8QMMIggyT/LjYOGKS12Vz6ZTCNOrX3fsQToDa82QqNtEFpUmLlHK3Z/Sp9HldeoMKTivni
	8Yq2Mcf9Ep+LRi/eXZSAuADJe0xvYGI1BtttgteJTmKB0qxiUC89Jtvl4Xg4yqzMIoCIQlzh097
	77sc16n79U+qBoLp7oHyaLxU7mrsVu3C9M5LVK2ku2y0UFvXS1fVJq6V9uYhXQrFeJEkxnopXTj
	9F7uu3Qs+Flk9BiUkE4rxL0r4vo5xy5fUgTkL7rcEsGYIAhLPAn57FYJmHyg6R+Mk=
X-Received: by 2002:a05:600c:1d0d:b0:485:c456:5e4f with SMTP id 5b1f17b1804b1-48fe59b071bmr91127835e9.0.1779041211464;
        Sun, 17 May 2026 11:06:51 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da15a6454sm31766775f8f.34.2026.05.17.11.06.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 11:06:51 -0700 (PDT)
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
Subject: [PATCH 04/12] crypto: atmel-ecc - simplify probe error handling
Date: Sun, 17 May 2026 18:06:31 +0000
Message-Id: <20260517180639.9657-6-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260517180639.9657-1-l.rubusch@gmail.com>
References: <20260517180639.9657-1-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace early return in atmel_ecc_probe() with explicit error handling
using a goto-based cleanup path.

Add comments to clarify client list insertion and algorithm registration
steps.

No functional change intended.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index 76fb1d0cf075..696ab1d51fc6 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -328,17 +328,20 @@ static int atmel_ecc_probe(struct i2c_client *client)
 
 	ret = crypto_register_kpp(&atmel_ecdh_nist_p256);
 	if (ret) {
-		spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
-		list_del(&i2c_priv->i2c_client_list_node);
-		spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
-
 		dev_err(&client->dev, "%s alg registration failed\n",
 			atmel_ecdh_nist_p256.base.cra_driver_name);
+		goto err_list_del;
 	} else {
 		dev_info(&client->dev, "atmel ecc algorithms registered in /proc/crypto\n");
 	}
 
 	return ret;
+
+err_list_del:
+	spin_lock(&atmel_i2c_mgmt.i2c_list_lock);
+	list_del(&i2c_priv->i2c_client_list_node);
+	spin_unlock(&atmel_i2c_mgmt.i2c_list_lock);
+	return ret;
 }
 
 static void atmel_ecc_remove(struct i2c_client *client)
-- 
2.53.0

