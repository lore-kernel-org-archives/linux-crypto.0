Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0962034EEED
	for <linux-crypto@vger.kernel.org>; Tue, 23 Dec 2025 20:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766521244; cv=none; b=s+kQ7CACiZ141Z2YIapECPDJ54e/SffshHTvWbKM1VduP7pQ8oG5GynU9qoWFDNHrDUBGQnMlp8HBjSFZRGHlbxRoGtfM3XpPEOttal5/hxZaJpiq6+dXH3H0axVe6QCSEoSr+PlLvlQpBkeHSs5MBmHP82flgU+HKvHYXR13oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766521244; c=relaxed/simple;
	bh=FesjP41xiT0Kda2nCLhQhKtJNrqGgysPl3yJ23vj64A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MjEb9pHkulLe//t/RZiJ+y+v8PDtFaiFHXM5UxcXCdS6OcKuSZLt9GmQDEbh1bkulZE8gz7z/TH0mm34lzSxl807JVSHQtFWWMKOag/uaiMdSA2GOpU5yD2vGoV4dZAFEZgez41DmYl8MueLzx9yg5pqawWRHRxeod4UYss0gy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=ZccbyyzW; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="ZccbyyzW"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7b7828bf7bcso6122957b3a.2
        for <linux-crypto@vger.kernel.org>; Tue, 23 Dec 2025 12:20:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1766521241; x=1767126041; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ClyoGQdLbQ+NSakHU5SbIxGsiXAmeIUAvdUGZfMfHas=;
        b=ZccbyyzW2lxJMbJYlm/wBafWsE2XB2bAypOFFnOukvOGI4F8bnHvNijeGAjtavqUGB
         p0NANjErF7ofDVkrLy/JmBZttd7li18QNaynTXMtfLOpiv0nuWEKeVd6DYSHktO1ISNl
         6HyxFIVBPwLfGivhk+/vTFkVzBO162ZkHkA0Jkp141/OWZ4XiUFeOAFelEoZvX1rskGB
         Wmk7CX8M65WvlFHXo4cHRpqzkjaDkKV3yp4+zvmH9jj17QAzZ6OaiuFPVXcNUQshasmH
         a2wdlKOVQBgvLOgq5SEy9w7xvNTCfKQBAhS5xqnESy2htUeDknWhV2G8qFo/rgWWwYNn
         KE1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766521241; x=1767126041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ClyoGQdLbQ+NSakHU5SbIxGsiXAmeIUAvdUGZfMfHas=;
        b=au6m/obUnI2u6QtI7e+cNYOIP2r8/yyy8ASBOy+A71tF3AjdE4tUUsB4TxkSBsD86K
         T88Gede5XnhYFKZgH+TpQmNJw0fQvIRSiKnQGyurTgBe2FS759v/kHjuPyPWbYpQqo54
         AvflQuRXoFE2JtyOth/6xQ/j8Uaa++dWyWfNh1xwoOxGI04bMuMPNdrjgpf539Fu/grL
         oII7lfJRY3oaSzIHatyGaMfQpHRl73xAdU7jCLuLc+ZkScWOJXVzGxwzStZb/wncDaDx
         pps4pREnkxGWbtaGW9Rs42vTWCVZz1WzVBPe902O4EmIBzHgbXm4DUj8HTkEPogS+9cT
         CXaw==
X-Forwarded-Encrypted: i=1; AJvYcCWIsTnoJoku7vTdh7A+ZlmSbcrh15boqa4mDNDd+NN6mNpv6zVq7ypCRYQk19h8Ks5/OZeOLvPar2zBaZc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKi00j6E3UFkvL52CHjssRU2IxW2+qjYbkaLe5aWWHDBpSS98E
	spTyUZSdaWDYYk7RxvbnGDWVVSsXM7ttsYA5WFvjwtgo+AlSroo1GkWo9EgUDlYguPY=
X-Gm-Gg: AY/fxX6IP+SiYozgMo3vFmeOVea1e1H1vFjD+ESUlD11ti1PcESC9uBtK1BxZoOq0qB
	QPk+JNbEdu+mdI7TC0Ty9mUG19GJ1VjNi3AP1vIKcNlvr9Ye0M9haLpSghkUvwCh3tNj1UcFou7
	i7leoN/6pVr1nHeh7UumKlfbKs1PnrULbs3bu2ZHM5yewEgg9V7OWfpFewG9I8P5QbviR5/HcdS
	6hdIqv0Pe8Tji/dqwvBIleC/Pu/yfhUhdmL+nO5laN/9tSOdmkZW4T1MBPvnSoLWVwOW6ELzpzC
	qvXXoiyzjhO5KkhuL3aWEAxYSQy24I+sR28fq1LeH77b6UNFzcn9+CRptFk1VFHxQ3ifeKdHace
	HHuAQ7hjpgRkNwkKBnxnz3bRf2Li7S5I0FVE2KT448IJncvQefNUKsmnptTlrejufx19EAt/DbU
	J2PdIkAvIS45tHzcHvaLvhuwrWdIcKWFz8d9fHbRxrRwMw/N2gbBg92yWSkc1/nDelSgEj5GV/2
	x6MFrk2
X-Google-Smtp-Source: AGHT+IGuoAHYa6yGZT2xpCk4O6bUCM8poDOiYCaAoun2Nvyagb0buXaCaJOvoitd+kEUFeEHxHKv2w==
X-Received: by 2002:a05:6a20:9185:b0:343:af1:9a57 with SMTP id adf61e73a8af0-376aa8e98d6mr14530108637.56.1766521241361;
        Tue, 23 Dec 2025 12:20:41 -0800 (PST)
Received: from fedora (dh207-15-53.xnet.hr. [88.207.15.53])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-c1e7cbfa619sm12567549a12.36.2025.12.23.12.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 12:20:40 -0800 (PST)
From: Robert Marko <robert.marko@sartura.hr>
To: robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	vkoul@kernel.org,
	andi.shyti@kernel.org,
	lee@kernel.org,
	andrew+netdev@lunn.ch,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	linusw@kernel.org,
	Steen.Hegelund@microchip.com,
	daniel.machon@microchip.com,
	UNGLinuxDriver@microchip.com,
	olivia@selenic.com,
	radu_nicolae.pirea@upb.ro,
	richard.genoud@bootlin.com,
	gregkh@linuxfoundation.org,
	jirislaby@kernel.org,
	broonie@kernel.org,
	mturquette@baylibre.com,
	sboyd@kernel.org,
	lars.povlsen@microchip.com,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	dmaengine@vger.kernel.org,
	linux-i2c@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-usb@vger.kernel.org,
	linux-clk@vger.kernel.org
Cc: luka.perkov@sartura.hr,
	Robert Marko <robert.marko@sartura.hr>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH v3 07/15] dt-bindings: rng: atmel,at91-trng: add microchip,lan9691-trng
Date: Tue, 23 Dec 2025 21:16:18 +0100
Message-ID: <20251223201921.1332786-8-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251223201921.1332786-1-robert.marko@sartura.hr>
References: <20251223201921.1332786-1-robert.marko@sartura.hr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Document Microchip LAN9696X TRNG compatible.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
---
Changes in v3:
* Pick Acked-by from Conor

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

