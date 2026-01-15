Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C576A37A49C
	for <linux-crypto@vger.kernel.org>; Thu, 15 Jan 2026 11:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768477248; cv=none; b=LmaQEdNM2mz8/PXhUbmmJKdQ7TihZHcsPe094MZuLJbeCCZ9nGw/v5REsStI3pP5gcE5yHeSDpd3PVbpLGzWGah4SeY25KlTYn7YkIr/gMGLgU1wmZ21E0sJ36FHfb/Tyx9QDWuibaYFuzzWW3Qidx2VWAJdx/lxzeqXtwiFpwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768477248; c=relaxed/simple;
	bh=WWvO7fvS51VGIasNJgUp3QyEPuObUZpxHbR7pn28FTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mY6f81Fmbr159wriL6HuLExZV654EP+nExJ2+RVEtc1D5/o1Vdt2F9rO0Y8VDigwDZ0uUE5CgLpFjTqncGs19Fe5ZTLiyi6vCLxP7b42kBWiaRdOKX3jmj3sesQGb17AdUYHf3SChXSDKIBsGbuFOgjG7+2j9dAPm4V5VmyCQnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=UVcP/v20; arc=none smtp.client-ip=74.125.82.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="UVcP/v20"
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-121a0bcd364so1061217c88.0
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jan 2026 03:40:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1768477246; x=1769082046; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tEJGOG9KziC5WmpmFadtMIPKcgD9jyuKUB8JZhjDo5k=;
        b=UVcP/v20an1Ri/KQX0pwKtk8IAvtwsby0xjBw61cKlNrVlC3TDhaqpNaluYDS/2jIM
         BWRr1w+09ZCctBa2GQGQxakTSqfDNXYv3gb9kcXbnYzK/j3ghIrArgDxhs6vWGUp8+oz
         8LISVjzM+5XaCtbqkAGVoGpwEvW6JpAY2v1pvUMP1+rMTXo3eg4HGJn1CxRU2zsaJeGx
         hvT4IEdvfB/SCQiQLmtXEG5pFMpWDJRIQvvpl4zxcqkYCpHN4rAu2SCJ/cI6615bsSsL
         suoU/9ddLvKABiycIMuTvbtzXnKVugaz1cHH7XQ61XUJVkJFz4lhWMBiVYPlKlSIoXT0
         2QVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768477246; x=1769082046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tEJGOG9KziC5WmpmFadtMIPKcgD9jyuKUB8JZhjDo5k=;
        b=vGAGkMUOZsau1Sg0g+5hZmZbST5b7iiC1C9yg4+L+8E4ZrdQ4O58Q4v4Zi+PQsdl83
         1YABeTkUn8dzpFKqxF2s38uaqPo+lcmcHOTeCkTRypz8XUz+MoHPw+XSlNiDHBGdSEfK
         pr06WLp8SEAQxEu6VGGahEzCoY+5D4PNAuw38DE2qgCvC2qDozOgeeGoyAeHdoM4G0cW
         TjF8DmEbNsCnnL6a4KEUbNXzrVRsdyCUM2fHo4iBBCboxFEij9SuVp12Yy5Mq6yaUgpT
         2MqyiUcM/emqPGM/4pODXtXVW+wAJ6WqJGkeD4+A2jcQZqAFXyofMno5yyKad57uT83D
         Ddsw==
X-Forwarded-Encrypted: i=1; AJvYcCUzq1wmhG30QNQxcnIRflzc0rUvSZ3VCTvs46wtzKGpdcmvAVXwUmFvfaj380C7kY6OwWIDHOtmcICCmt0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyyo/TGZEKZvTs78XQrRIdzxx/gNnfj3LZBaR7p83+gAv32i6FU
	Uo7d52bpIgCllM4Q4rMqWGlqi1IdT0HQj7S7fASVoXWK1ATYsFU9lF1wVgs8SOzktCo=
X-Gm-Gg: AY/fxX7yDTsnOmPRUpclaMXPnqdg+Xw/saQlSpa6381C7StwCCyLpXhw4l7wF4lIX2N
	Q8dOTieXCGle+srfrfAIY7QCep6zXUooKqr3RwISv2CIi6LiDDr1UZSNjQbbnTakq5LZ8Dr9EYx
	dBA6o5v4JJbuXWhyl8uolx66MFsIQApjj/0XY3lVNnDuV7dmRCnvi3y4bcpIaztaikE1xGIxsUr
	3DmEGZJnLhqG3h32auvCAsjt35eIi8jqhbynOWybdIBn0udkD1FqhsSvuS0uiPIbsp3la2lmAV6
	908nUerY+CnC8iwJkMIggWTeCCBuwCpnOuypC4L29RBHWnyns0/ijTpepH1nVLEjx4s7yzqXDu4
	FObgKyRp0IhZujRXffXa+P0DbIlCuruQllYgX5atiDA+uwmh5qD5gHquaAYgrJ/cqt1+1D/iGxV
	kFqurPawvmWJ5KPbiL24ruf5lu9VDHnZ+Os0Y3d0RxvAfuvJMBzg54+5kgmT3jxEe+GOTM2RAxm
	IQaijJe
X-Received: by 2002:a05:7022:4392:b0:122:2f4:b251 with SMTP id a92af1059eb24-123376fccd9mr8604410c88.21.1768477245907;
        Thu, 15 Jan 2026 03:40:45 -0800 (PST)
Received: from fedora (dh207-14-52.xnet.hr. [88.207.14.52])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-123370a051esm4875347c88.15.2026.01.15.03.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 03:40:45 -0800 (PST)
From: Robert Marko <robert.marko@sartura.hr>
To: robh@kernel.org,
	krzk+dt@kernel.org,
	conor+dt@kernel.org,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	lee@kernel.org,
	andrew+netdev@lunn.ch,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	Steen.Hegelund@microchip.com,
	daniel.machon@microchip.com,
	UNGLinuxDriver@microchip.com,
	linusw@kernel.org,
	olivia@selenic.com,
	richard.genoud@bootlin.com,
	radu_nicolae.pirea@upb.ro,
	gregkh@linuxfoundation.org,
	richardcochran@gmail.com,
	horatiu.vultur@microchip.com,
	Ryan.Wanner@microchip.com,
	tudor.ambarus@linaro.org,
	kavyasree.kotagiri@microchip.com,
	lars.povlsen@microchip.com,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-serial@vger.kernel.org
Cc: luka.perkov@sartura.hr,
	Robert Marko <robert.marko@sartura.hr>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH v5 01/11] dt-bindings: mfd: atmel,sama5d2-flexcom: add microchip,lan9691-flexcom
Date: Thu, 15 Jan 2026 12:37:26 +0100
Message-ID: <20260115114021.111324-2-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115114021.111324-1-robert.marko@sartura.hr>
References: <20260115114021.111324-1-robert.marko@sartura.hr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add binding documentation for Microchip LAN969x.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
---
Changes in v5:
* Pick Reviewed-by from Claudiu

Changes in v3:
* Pick Acked-by from Conor

 Documentation/devicetree/bindings/mfd/atmel,sama5d2-flexcom.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/mfd/atmel,sama5d2-flexcom.yaml b/Documentation/devicetree/bindings/mfd/atmel,sama5d2-flexcom.yaml
index c7d6cf96796c..5e5dec2f6564 100644
--- a/Documentation/devicetree/bindings/mfd/atmel,sama5d2-flexcom.yaml
+++ b/Documentation/devicetree/bindings/mfd/atmel,sama5d2-flexcom.yaml
@@ -20,6 +20,7 @@ properties:
       - const: atmel,sama5d2-flexcom
       - items:
           - enum:
+              - microchip,lan9691-flexcom
               - microchip,sam9x7-flexcom
               - microchip,sama7d65-flexcom
               - microchip,sama7g5-flexcom
-- 
2.52.0

