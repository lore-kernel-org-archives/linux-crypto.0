Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352C83CC7C5
	for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 18:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779041224; cv=none; b=QHbBbQYvSq7oQ1rLnc+cReUvkini1RrDZd3yGkvxmrtTEN8aAT1CBnAjAvSgf9KU6qvOKhBCltEGcvg+jjiupMbZwcGSfWC6dnNNC3qsKA/eHkA5HPKdEu5FA+tikTtg2hPoB6+Rs7OnJy+xfmpSQ3dnunKuhpwOLkv8112PuXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779041224; c=relaxed/simple;
	bh=8E8i2ov3OB5nxCGPsraNbhi7Lp2mIp0fHwCLul3Q9bg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TYDagKYE7TiCOZGvE4OwyLA9xAZlS2FaUWZpDb5qy0hbIAVx2ik+aAw8+1XddSjNfHO4J4VYo+exF54bPTHBLSdvZYZ/0McXcnK8sDOF6ftKvAdMRpf98DuUHoWAohmsVSqO321zytmZDqKGLfwzi4e98GAhDdZp5sP8pp2CfLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GxC3Q42j; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GxC3Q42j"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-488ac04e13dso1863865e9.1
        for <linux-crypto@vger.kernel.org>; Sun, 17 May 2026 11:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779041217; x=1779646017; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UvLRNBQYDT8+Qt2zwMF/yaLEeJC75IH2Ss/ramc0Mks=;
        b=GxC3Q42jaiZxMVkF+JMPIaYZ4JcEjhdXDWW6v4nscAbNFEEeZa8AibaDYur8kxdsXB
         toj7u9c02ChHFak/MAoPkpqJQscPZv5QhL4NQvyXm05GdcMRLcYmiOERSC5ehssF1x+O
         M4x3EmxNAbZmeb33eRn9nnkD/cO3nwWcGml5HWzMkTlTHYHJKwrFlZ5r2fzleYscy5sT
         VJu619dptwYW8n1Z7DSO0rjRpbcVFf4HOOSIhOmMjRCARsk2JJcvxcInZZTwEU0qswKx
         ntGQ+8eItnni4JL6mfJ8QCN+SNCc+cx2rr6XQzveWzJSKNJ4AdeQhgSOpg3+havzcpYS
         TEiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779041217; x=1779646017;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UvLRNBQYDT8+Qt2zwMF/yaLEeJC75IH2Ss/ramc0Mks=;
        b=OMkN/ixiGA7Rfc707TnVesJqcHXAKblQ1XyWLbWLFVhujUZaAInSzgwsTwLlRp+oWh
         ZkQKQWSHON0qqwtxIpfa512Q+Lmr1CJlcli3q7zt/UhkOWWsFbsejlYaDLflY7ML6uSc
         xTzuQ+gEhNrtkalUDcqrO0axXwVz/M3M9Wi3kgA0jhc88wDw9KiINSoDgdEjm0hfzBYr
         W1OKT1PV9rMv6Jrxq5SpPT84gPgZ6SCOtGwgEuZTC+oiw6FQtRoj8Jivrs5/TozYGCEi
         miUoMmTGdDJ07qR7dmpaWdnrCnuThHmyD4prqUjC9wxnmkcRyRi8ZjiHVhC99PzwMArE
         QZ9Q==
X-Gm-Message-State: AOJu0YyFmyG1QlzHslDHtEsCjVp8iEv+38mg3u+kj7X3DkvVAHA+jHYn
	YR5HHEBZJOxbpKz2YHfJ+jA5bwXfBOdyPC7eMfaUBl9YkE/3uxuBuygO
X-Gm-Gg: Acq92OGCLOJSz4bobtopidFtI6u1FoK3oVomZC8CdHpq+RRoCbHJfE0pCotkdWMDKvJ
	AFhjwlXNBysikNU/5HN6AOaAid16JaBMRaKzNFB573/gHjePVpxt3flWySxBAvHyu0YspAAvqoh
	jp61bEaaJpY+Q2Z1cY7DlGKNUFZD7DqICyttR1oYRLs8b2czODKXz/c6szdKOUNZ/TcUXljxH2A
	ykzSmXcnBq6RGOBo/4MQAV3/fDTfYk06J+ZsUjLzX84YQBqaGo6rzdJrOwdm37n+CD7rh0GWrGb
	XRlBJv4yf6J84ez40576E9dXucDOl/PrIxZZWPBoayCmApsYEli64TQEtezwe8bC8FMXOHFUZhe
	+WM0C0kGYVlor6bhhoC4wxHUNETAUuplim1Q1g5IbGzffRHn2z0LQ7BnzwstmTvKe4l3oqpM9hc
	c9VE3Vr37p790tkvTK2qLJUiGH6/icrOPE18HlGdXXzl1xJx75VhODsmbAjFIGA4k=
X-Received: by 2002:a5d:5850:0:b0:453:f281:b4ff with SMTP id ffacd0b85a97d-45e5c59557dmr8853464f8f.2.1779041216533;
        Sun, 17 May 2026 11:06:56 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da15a6454sm31766775f8f.34.2026.05.17.11.06.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 11:06:56 -0700 (PDT)
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
Subject: [PATCH 09/12] crypto: atmel-ecc - simplify remove path and relax busy handling
Date: Sun, 17 May 2026 18:06:36 +0000
Message-Id: <20260517180639.9657-11-l.rubusch@gmail.com>
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

Simplify atmel_ecc_remove() by removing early exit logic and
centralizing client retrieval and validation.

Previously the driver returned early when active transform users
were detected, which could leave partially initialized state
without proper cleanup.

Replace this with a warning when active transforms are present,
but continue with full teardown of crypto registration and
device cleanup.

This ensures consistent removal behaviour even when the device
is still in use.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-ecc.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/atmel-ecc.c b/drivers/crypto/atmel-ecc.c
index dcfc09d24497..ce7a2e750ba8 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -346,21 +346,14 @@ static int atmel_ecc_probe(struct i2c_client *client)
 
 static void atmel_ecc_remove(struct i2c_client *client)
 {
-	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
+	struct atmel_i2c_client_priv *i2c_priv;
 
-	/* Return EBUSY if i2c client already allocated. */
-	if (atomic_read(&i2c_priv->tfm_count)) {
-		/*
-		 * After we return here, the memory backing the device is freed.
-		 * That happens no matter what the return value of this function
-		 * is because in the Linux device model there is no error
-		 * handling for unbinding a driver.
-		 * If there is still some action pending, it probably involves
-		 * accessing the freed memory.
-		 */
-		dev_emerg(&client->dev, "Device is busy, expect memory corruption.\n");
+	i2c_priv = i2c_get_clientdata(client);
+	if (WARN_ON(!i2c_priv))
 		return;
-	}
+
+	if (atomic_read(&i2c_priv->tfm_count))
+		dev_warn(&client->dev, "Device is busy, remove it anyhow\n");
 
 	crypto_unregister_kpp(&atmel_ecdh_nist_p256);
 
-- 
2.53.0

