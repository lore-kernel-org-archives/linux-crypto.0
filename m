Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223FF3321AB
	for <linux-crypto@vger.kernel.org>; Mon, 15 Dec 2025 16:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765816739; cv=none; b=Yqfb1drmmQiKuL6uDDCjUIHeR58J0NWIzI3RlNRwxDjadeK5jL1JL6txUyMC8wXVrGpTC3e0RQKx3uJz5bdY2+aF2L1mMroecUzmr5W/f2iDn/OaFfTVVuV/T1gU0Pd7gU+CyJOISElRf0s5Lph97JgHY38Rlfd70RNbGPbnlR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765816739; c=relaxed/simple;
	bh=h4KBW+OqWMvRHvXvtXgMj+kYkCK8alyetopM4+3I/yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izLD5WxYgmivY4cG9yGDzefDDt5ZWt6osHsupY4sQzLXpbKe8l2PIKcpgFFbvr+5+pr/PaR5BTY4ITtPz5Hy05xkFzffNT9b1JLEn8AqWSPyvnWuJy9gfd9NM0AuBd23fq54W6TJ4UZV7oiqYqhajZxsnI8vnF3Lz/TiQVooz+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=OfUP/ICW; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="OfUP/ICW"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-477a2ab455fso40410745e9.3
        for <linux-crypto@vger.kernel.org>; Mon, 15 Dec 2025 08:38:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1765816731; x=1766421531; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GRhTYOFBvq7YVDoxsO44nCdQXJPNAFf/GkuN2Aepibs=;
        b=OfUP/ICWkdj/41RG3vUqj76mrUf7etPXv1VDW9TPrcx/pbN/0ZqaNMYefTovfAq9wV
         3gSG8GDVlA8WGkb4XennljmZKT9Z/RdE+rgKupgAE9ynOzGJbZlqiPGhmpSai8gk0W3p
         uYYzMMBKoc7UHytUUyzTeNkoN4zNudPYqNyIVoShBl8b7/SGacT6NopHVw28SMw8Hx0l
         LaHRh1t8Lr9jeU95EHQ8koV0ig+m7rOB4Pq9EG96Z4e3cdYVBy6PsiQXH+aHWKdYkqMb
         /inS/mpHbUwzNkk2NjXNQBGHfdxT78IO7GvrhvprYOc7qAzItPVRLil2MBBtGeAJ1g0U
         0ZOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765816731; x=1766421531;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GRhTYOFBvq7YVDoxsO44nCdQXJPNAFf/GkuN2Aepibs=;
        b=gvPjj39pAhtxiwz3h1HODKHuMT+bBsfnGSnWYWVUBLO85mlwsocvZRYgjXBJKlYk49
         vLTX7IHVgF21uPlQm9Tvbhk80Q/muz20mRApNgiKtxQnAdwylEEJb18l86QpSe9u+0lY
         HSC0pzgQBkcBPEdqxnesJmsB/Ys+LSmBSoecMQkA4VPnqYgY1egLc4V/y1TwjeMLBvLt
         kHeQgjwSrcGcTvEUDMCPlnCidLctl99cDen5TWjatHID23Jb3yQaOo5TizSX4xGqh8iw
         mh1JPR+cvdvHzVUc7jJGwlOioUWY48qA4hFJ9Rcz6rOLCOQGfL0ZXg7+FSPDkwYESp01
         HgnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQTEoq2CPS0IjqnUKPAIJkWHPtpuoHz/gbnaa+Tn3HMk3P7EWWV4uDX7cEcADD1BTFmNHDLhcNuriZmVA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyngwyG259ztRfnOok7dlaGtqx46HJQC2DLoIhwZpWlbJNgiFFl
	DNdrsLbM5SvJMUg7dnl1NXk9TB/cEoWwma8r9ty0YF5PtJs8ubJ/X3CnanNJiDJIB9A=
X-Gm-Gg: AY/fxX7koqpsFFlkDH+jocE6xAu1GBn/0ve6CHq91AKgs/j5GdkJhBXpUY6ngGunLhm
	m3dnq5q3+lUDRUMBb7b1WmInQIMkFP+wm4lKHilcTi5H3MwEZS/3swlH/EoYSZGRO/xL1N3bwkz
	Pwb9sRv6Y6sSDVp+Yfoi2ZsHQSBC3k+0bU7WhtT+IqkK80EaNqPMMNmXamHm5deAdrcR7v7uoR5
	mcNbFc7m+juzgxduFvAqrs2zVvQ/U3N0Ux3bLk+wVy9Reo8EmHKtNHwpPWRfwjVuw2RVVpLFcij
	APz5eMFltrD36vQNU2/hifdCCS6nC6ZK0O/9JEakxmDOR4zu1asyr4ZO1nphUPVqXVTNfT255rb
	Ih0AJYwdHm7dtYT1KbiiE2pKcH0825h5wbis9A1ySEzR6HoE+gGt3WO4w3c44VDJdu53Jys5m5K
	YXlkFxTP75A3yNID8DNW3DtYdhsQYGYnxPfgfE0aueeFgQ
X-Google-Smtp-Source: AGHT+IH8ueFxxMMyV68FeFfRx9NsSwNlL/Ao6Q/rQdEFzAIzqPflgAc/QenJHtj3S1aXhik6vqKjfQ==
X-Received: by 2002:a05:600c:3489:b0:477:95a0:fe95 with SMTP id 5b1f17b1804b1-47bd466121emr3483595e9.24.1765816730643;
        Mon, 15 Dec 2025 08:38:50 -0800 (PST)
Received: from fedora (cpezg-94-253-146-254-cbl.xnet.hr. [94.253.146.254])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-47a8f74b44csm192209725e9.3.2025.12.15.08.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 08:38:50 -0800 (PST)
From: Robert Marko <robert.marko@sartura.hr>
To: robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	Steen.Hegelund@microchip.com,
	daniel.machon@microchip.com,
	UNGLinuxDriver@microchip.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	vkoul@kernel.org,
	linux@roeck-us.net,
	andi.shyti@kernel.org,
	lee@kernel.org,
	andrew+netdev@lunn.ch,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	linusw@kernel.org,
	olivia@selenic.com,
	radu_nicolae.pirea@upb.ro,
	richard.genoud@bootlin.com,
	gregkh@linuxfoundation.org,
	jirislaby@kernel.org,
	mturquette@baylibre.com,
	sboyd@kernel.org,
	richardcochran@gmail.com,
	wsa+renesas@sang-engineering.com,
	romain.sioen@microchip.com,
	Ryan.Wanner@microchip.com,
	lars.povlsen@microchip.com,
	tudor.ambarus@linaro.org,
	charan.pedumuru@microchip.com,
	kavyasree.kotagiri@microchip.com,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	dmaengine@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-i2c@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-usb@vger.kernel.org,
	linux-clk@vger.kernel.org,
	mwalle@kernel.org
Cc: luka.perkov@sartura.hr,
	Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH v2 10/19] dt-bindings: rng: atmel,at91-trng: add microchip,lan9691-trng
Date: Mon, 15 Dec 2025 17:35:27 +0100
Message-ID: <20251215163820.1584926-10-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251215163820.1584926-1-robert.marko@sartura.hr>
References: <20251215163820.1584926-1-robert.marko@sartura.hr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Document Microchip LAN9696X TRNG compatible.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
---
 Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml b/Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml
index f78614100ea8..3628251b8c51 100644
--- a/Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml
+++ b/Documentation/devicetree/bindings/rng/atmel,at91-trng.yaml
@@ -19,6 +19,7 @@ properties:
           - microchip,sam9x60-trng
       - items:
           - enum:
+              - microchip,lan9691-trng
               - microchip,sama7g5-trng
           - const: atmel,at91sam9g45-trng
       - items:
-- 
2.52.0

