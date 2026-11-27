Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795780933;
	b=m0EJ8PVj6fel0VwweRQvyp/cuIcZK/2B92I+2r70H8RGaDTsrNzTkfG6KbcPqH8xDPtx
	 7ZN8Ot65ZwzqaFYdqZb9evF6uojvVkTUHypmMzSrIOD8KQyLxxFxPzlu9wIBXPfKnoPTc
	 VOiCtBVJP0+bH/MHSd/HhjyASj0vhisrE8B98V22Y80m9T80YuzgWguMLAorVvUTV9of8
	 0Fx9MHibhWdru9VRdz15psFuusW6ioOw9AthxK8kLk3OqOH3IREXS4TGArP30XuyCj8Nd
	 ZcD4mtudodgB19fxGHZHsfVfFsJrgWszGTEqJoNxeQkeeDRnKT+zY9POz1xEDZNXQog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795780933;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=XZeii/VW214rh0vsKwtrU2Ok4yszGoZRil5bEJfNkjY=;
	b=sgZQPJAdKAemVagQM+ugtzx8jwI2dNJrSZBPSXgoe9WNiz8TcjgWDMwcw6tM7LJ0S4Bp
	 JIbxB2FX+/RtdRIaQ2HhWwdKUNBPoHHESvRXOGY1/Bwkd5AE7FoOGwL1FtkTg/NKetE9f
	 w7XU/kbljHa1JfYPNEnjFtlnv+N4ymE+rEYIh7XLEWNRZo0Kw9fqcp72HSpuzKGoH0Ao0
	 Yl39Ab0YwyRW+ezM/mC1Tk+1TGypYCLsOzAGSOOUxY9JjphxRFJR+KIcFBbgLntgMAc+e
	 Jwih8h2E4Xj434Xp2Cx5qI3aRuJo68rbvTryagQp8ITleKhG9r2jJ3HrUNZ9jcWJYSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RRDTRz16;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8E3606A323
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 12:02:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D8E3606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RRDTRz16
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4bb69f5b161so52403095e9.0
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:02:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795780931; x=1796385731; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XZeii/VW214rh0vsKwtrU2Ok4yszGoZRil5bEJfNkjY=;
        b=RRDTRz16Zt0/O4FKZhopLTpqiMOk6RPUugJugCum8m7+uN9oY8xFO1ZNReL6uPo22j
         UyGWZhlb3taWYNOtadLD36mEseSOZBzrGSQCfU7qMgmRGmuRoWzRs0yjiqENeBrbnBcr
         dzLe4irNhqx7GC9xFxMxN3K0ViOF7kubJ6qoxXrNhU+aU1fAvr9NAQ/ZMfXEz8pMjS9s
         OaWemYsBiI6Arkrf+Ti51oy0ZNRIwnDJG9RFDbNGtbuByUiQEq7tH3aKFjiJcaWea75n
         rfMXEZD2IdrGEQAphhj1ThdIqLtVOYu5VisOhSuIPniuoV/otVtVj1o7mAwh8fR4gxYM
         aJbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795780932; x=1796385732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XZeii/VW214rh0vsKwtrU2Ok4yszGoZRil5bEJfNkjY=;
        b=YEqKsbVOuFBB6SLM4j2cIeGYyPSS8+F0H5XM/gI83OmpUdiPbo4M7/TBAOG+Leg59x
         D7lwAmegvs+GSnwcCv+/ejtT6wgpTArApRDktNOblYHiMjvSVrSum4JoF69EqGyKfzQY
         5uJWKYVePiKYuJ3bI0VAB/R+EVxUDMBBa08HCAHF+UYlpNMkUBlbNfCOP8qTz0QenMFS
         p7PHePYgwyxS1rN0KUYWZ1Zvi9qmaGAK0XOf7t+HNa+BhK+iuiIuwsEDkxwWlQcRslCc
         lamTvvBDfYaB8rFgIMbrZ0e4NER1BrqkVE6nVkqaj6G8bT8qFXOTzm7zUHEf1cabJMP9
         a3wA==
X-Gm-Message-State: APuU4Z/BaLyCpxHC8/y/GNifYTTpoI2aA+tFwoazN7vJxdBJScTrM9sP
	uFZCokPa1sUDesAXHX5mGq1ReQ7CbgdCMFqSHFIdi6saZTC/mH8VjcyR
X-Gm-Gg: AZFdTZc2Kf2hoF6jZTT9l/no4ZpRKG3/9bBks5mcC42NLmSZ8TBw8tWabmXgNKs9hSf
	tLOGDZxtCr6pOgsbO9LkNnyVH4ZcgxtWkKBKBqVQMFkHlh9vGA3YD+HZO0w984O/nr3qSybKyT/
	63c98UW+fpGGMOGAWQ4vEKj308x84AMcUPDgmKnRaz/NAI05R7NKzg8RvKyQUsgqZ8s6IYuiFqb
	8ejRdSjLQuPQ6b6OBfJz234sLnhyIMDaswU/jbkrGFG0Jiuz0+Nau5t55JRtc8XEIqeG4akLVf9
	iRFk+wGOLgqEA+9AG3Xdk1ZEQ5kbM/noWe0I5xUtNmqLv5YfwUpvM+O5um9NXVc/wpLsS+EKd5e
	tVCEG1OEDUJkn36fbYKJkGnnALNHNRKGhI9ipPI3fONqO57yocAG7vkJDDKImE+irDpMCiupZna
	myJL4PTdg7ifnkjvJZRMjptd5x0VRBRxnQzzLxsmDlk0MKmLaozQ64v6I4SknVhplvF77oFNHWv
	aVqF5C1YSY40/lQlvwWvOvXVDlQ8kAq09v3MIblbBQi/pXutPeXRDBkxpG+7esE6tDNcen/YuVx
	796sjpBqm/1NH4S/KEbXbbgxm7zgXG6XH6I7j4WcP7YgaaeTWzcnV37/XBKPrWaCGjWL
X-Received: by 2002:a05:600c:c173:b0:4a1:813f:2a60 with SMTP id 5b1f17b1804b1-4bb88800134mr467671145e9.11.1795780931338;
        Fri, 27 Nov 2026 04:02:11 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906640a2sm393684565e9.0.2026.11.27.04.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 04:02:10 -0800 (PST)
From: Jose Nieto <jnieto.alaber@gmail.com>
To: Corentin Labbe <clabbe@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	devicetree@vger.kernel.org,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jose Nieto <jnieto.alaber@gmail.com>
Subject: [PATCH v14 29/30] crypto: amlogic: drop redundant A1 platform data
Date: Fri, 27 Nov 2026 13:01:02 +0100
Message-ID: <20261127120103.1532882-30-jnieto.alaber@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261127120103.1532882-1-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-1-jnieto.alaber@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

meson_a1_pdata is identical to meson_g12a_pdata; drop the duplicate and
reuse
meson_g12a_pdata for the A1 and S4 match entries.

Signed-off-by: Jose Nieto <jnieto.alaber@gmail.com>
---
 drivers/crypto/amlogic/amlogic-gxl-core.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index c11d7d8250ea..d11319425d5f 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -305,14 +305,6 @@ static const struct meson_pdata meson_axg_pdata = {
 	.support_192bit_key = true,
 };
 
-static const struct meson_pdata meson_a1_pdata = {
-	.descs_reg = 0x0,
-	.status_reg = 0x8,
-	.setup_desc_cnt = 1,
-	.hasher_supported = true,
-	.support_192bit_key = false,
-};
-
 static const struct of_device_id meson_crypto_of_match_table[] = {
 	{
 		.compatible = "amlogic,gxl-crypto",
@@ -328,11 +320,11 @@ static const struct of_device_id meson_crypto_of_match_table[] = {
 	},
 	{
 		.compatible = "amlogic,a1-crypto",
-		.data = &meson_a1_pdata,
+		.data = &meson_g12a_pdata,
 	},
 	{
 		.compatible = "amlogic,s4-crypto",
-		.data = &meson_a1_pdata,
+		.data = &meson_g12a_pdata,
 	},
 	{},
 };
-- 
2.47.3

