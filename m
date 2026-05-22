Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D12364047
	for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 23:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779490921; cv=none; b=FbQ8yHaDh0X8pA29Rds/udPO7awxK7YxzKUyywwiq3WGoc48vOarUnoIFYAg2pbTL1OSJn9dmW0m3i860ajN9UUHHI3kM/t807BVVzBC38T1+Yv6OtKP8CuCqBkcmerYF7DGdb707uzUdEfVnYjYDfgeaGxp4hTCNWKaAIdiX3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779490921; c=relaxed/simple;
	bh=DR3UsQTK+NNUD6IDUcIq7ubGv0mDBUfxKOqc2gCxbaM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QZJHlljyuh/NB0qJTKHQNQcpXMhqAj6UXnfuF1hn6OJzvP4DLSFx/XoZtTCCEBGqE5FeHYuVlPTlnZQQAm1MI3H/pDb+M1Ex/jp/0LIL6WfJRoTWfVs39OlQOvXilUnktpSBHpOGkdOJ+LnDSVKoU5ToMvClKN/s7vvVQcg0GO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ld2kjpY/; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ld2kjpY/"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-44ad87a57f6so612354f8f.2
        for <linux-crypto@vger.kernel.org>; Fri, 22 May 2026 16:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779490907; x=1780095707; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sb5MNahpjnP/vNHphvg5+I/zYJ16o/85c7lKSptPrvw=;
        b=ld2kjpY/j6ANda6f55zLNjiMf+Es3knUpF2KnqR5kUQuiSJyBBLtxrWrqtOwt1Tdoj
         0bBBvrV4oJ9v1MXuxivn1/EZSEeUyIDnxEWEdPkf3m1eiNHcYQLGR87r3AfhUwXRHlO2
         oQJq/QcIlurqjr50OtrWXTIudpGFNpc2CiHZfbSvKwqY3MZSdmDbtjrYB+iGVSQC97mh
         m9ZCLIu+8sYwDnzO4MB6RgY42nqDAIY24bF1HKSagS+ljxLoFhUp1ZJORSpQjnMigkbg
         JKiwUahHUkhliGyx2i+8vzgpuW+ipkAfefaO0HnMC71lhbynF1dkVagV0R7hKE9JkpSu
         ADKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779490907; x=1780095707;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Sb5MNahpjnP/vNHphvg5+I/zYJ16o/85c7lKSptPrvw=;
        b=HFHg51viIFq9aHLF8cSyzOyBu6QIrv1ihZwxWmnmsKcR5GXPUfBhJ0uCSSJfLcn8IG
         yjhpv7Os648XWTLJTIyobiPoYY7i1nE3UiaVZhSzgsg3xUQAF8H4LyUpFwEJLNacQxxh
         Ux/QRNghddzheYhCSlHd6z9cLvbI/ahGQlUqdN2KCDiNtH1hZCVMpC3SH9TJROt+dmWt
         d68ExbZ0CjbNP/G3ytWNVZnoRKr15GWWxG8P8Gw7B1oaZZEcbZtmGBLNL+M0HkrUaS0D
         +UTZYmXZqdkrOk3hZgboonB5kh+KXIx7bpSwPM6mqNV5xOD0eIRqtwpqFfbu0HO2MPX8
         s0Zw==
X-Gm-Message-State: AOJu0YzB4ZAPF9Ca6PpQJyrA860P+8jQ7tPjwwh5dAJHD/qjDDp4oo0e
	VDqmWbSJxkKbBZZOfFBfPndsAAJOCj5oOYchJt5HeNoyyGW+dbjWbtrK
X-Gm-Gg: Acq92OED1p6Ip3jaNnGkSR34HxfNSN535XFpqptpB2BE9Hi/OcNZlHnyshJpS4OL4nX
	GUmTPYBV4iBYh6sjQjHmFw13dtPRXKIjF9LKUrDwXQ8AjCX5Ng58EQm0MfBszUe4ngIXDFksvkC
	yJ/2E3V62sHgkIDyiGMGoEdkR5F+XXy+pMrHsRnPnX0toDZmzNILHWxtxkDbZbt6xuNhLBj0KlJ
	ut+eICbUsP0HJ8fPKBjkY6duYyGJmQUsvwxOtGxqkNRGXM5/zpsZrfp5FGrTlaYDERnTU9aPylj
	WFWUGUZD6fHwqXNIU4ZxQwWKacdZShb5NaLwbfD++ng4I3LmJuGGnk321WlQbOIQqudRWhBq5bw
	OFRJhKomuhaRqTNiq726PrH6wRaD8lzHO1gigue/gouRGSnq4f3dabeNqGr79uOS6EjIyBVbZbw
	lspAAEbuTBRz8lGui/mnYxrQh+WWNMjNKgOAOTDqiSNjSzvMmuMwen0TlmdMcAfaIdZQnhpczuc
	g==
X-Received: by 2002:a05:600c:a09:b0:48e:65f3:a950 with SMTP id 5b1f17b1804b1-4904248ad8cmr37124745e9.1.1779490906790;
        Fri, 22 May 2026 16:01:46 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490456274ebsm67100265e9.15.2026.05.22.16.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 16:01:46 -0700 (PDT)
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
Subject: [PATCH v4 05/12] crypto: atmel - rename atmel_ecc_driver_data to atmel_i2c_client_mgmt
Date: Fri, 22 May 2026 23:01:27 +0000
Message-Id: <20260522230134.32414-6-l.rubusch@gmail.com>
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
index d12a9dbe45a7..d6ae113c45df 100644
--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -28,7 +28,7 @@ static int atmel_ecc_kpp_refcnt;
 DECLARE_COMPLETION(atmel_ecc_unreg_done);
 static bool atmel_ecc_unreg_active;
 
-static struct atmel_ecc_driver_data atmel_i2c_mgmt;
+static struct atmel_i2c_client_mgmt atmel_i2c_mgmt;
 
 /**
  * struct atmel_ecdh_ctx - transformation context
diff --git a/drivers/crypto/atmel-i2c.h b/drivers/crypto/atmel-i2c.h
index b320559e50eb..660ca861b705 100644
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

