Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com [209.85.128.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A4F33D6ED
	for <linux-crypto@vger.kernel.org>; Mon, 29 Dec 2025 18:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767033644; cv=none; b=G9RvdzdIp895N8Xqr1T87xFxtHwY2x2HPI6coGIOa6eylNDUmhp4JiHG8uio7lzyrS2ot18vmR7TXgfL5a8s4Fba7Gs1VAqXL47u1dL5fzvMia/TlhwPRF4aJZyoSDOj6dLzx5oJwHxOes+iTLSbqMyFywGPkSbUUrzAwgDbPPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767033644; c=relaxed/simple;
	bh=XoF0Eovrxm1txLTrLfP7MB7ayo4/Y25gdep/95xkk5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xc+je59WHqJArVhgNclpDFcpDCmGZY38mtLmUfGf2GQG9PXR0RRHHimqtPCZIazmtKmlYEiocKKBkD+Kf/PZk5vOa5RO2ptuDYtSJMzd1Z8yf216q81kjBw8FmxgXr1BSY1Wi/9ZDq8YRHPiHqKimFEznXvWJxuzQClM6BZKSwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=eDl6YqTI; arc=none smtp.client-ip=209.85.128.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="eDl6YqTI"
Received: by mail-wm1-f67.google.com with SMTP id 5b1f17b1804b1-477ba2c1ca2so98481265e9.2
        for <linux-crypto@vger.kernel.org>; Mon, 29 Dec 2025 10:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1767033640; x=1767638440; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qfMU7MT4/V4GUajmsYnn75DFErJTnupop06HbanZvHw=;
        b=eDl6YqTI35mE7mdIDYxmhJcA4HqpioN6T+TrIWpO7rhwFXtvwMqpaCt2rVWa5KOT3Y
         PzQmjNcD3ZrlKKrL+sLhAkAO1G+9JFeLQ6HfZ4RLRD+vGzqZ8nbHnAvPszy0K7JPB4H0
         5i9ecXb3tDLcQBOFCP5IF14KvLKRYmOOE1wWHk18pvjPph5g85omJIHxFYCFgCNgFzc5
         rRMoxkFKU+zAxax3cIGiVYf33wmRRaGswKq8m8cmtly5hnQJEOUTlktu8+2f62IgiqfW
         u/Neehn5EO2WPKUDyLjLyQBW3zkSTpdvIy0w+c2swIdgRBGSJSsWnY55ywc/rwY0oCsw
         nL7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767033640; x=1767638440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qfMU7MT4/V4GUajmsYnn75DFErJTnupop06HbanZvHw=;
        b=nepLqGHwUJN3IZVIQfcRN1UPScsbu3MtEnmX6JFRp8vUaKq8E1qrKaEirZEZUy64RL
         BZh/4JmuzCeQobVc7JKp/AL+Fu4WhsRFBxnYChP8OvxFxiuyX+ccYB6vvHvcbkigqGRD
         8meCOGQQNMgtWsTV2cjmu00SgMizqtGmLp09TXB/BPCQmP3R/a3cqlm6k0THUqhSi7++
         R82kRdxIbXo5Mbmfgho16Sxvdd1AJiZirAv/dgNKyPy0fOBnpr957YEdLTXxNxklOqgq
         K82xWyD7g7S//RhwfSE6YaZiw1HJ4gz3f69EErrSv5K0vJHvUgwF7rtE7qG/XiDLOKQm
         qmLQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpBaQ1OJNiaeVxOK7fTcNmHWc+Rx8R9shUOXO03vCtzEtFANxyd7iG4rKBYqrWKnkq0ul0/boc4kTQHlQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3Gln/Kug2FFv31e3sKLT3yTRSs/OjTKPkEVph6FTyt8mf1pLg
	L4BCr3NG0jpBtvp9H1Y+z2QFt+If6klq8cal4Gga+dfm4nxXIee1o6qwcFbIAlpVg0w=
X-Gm-Gg: AY/fxX4+NyU6R7YJskKQVxdIAZyCePow4hrqL/sG18O9HLYJIVFC/6dMzztD+PJrOE0
	5l1gT94T8Z1CzmsuYgSaw5lLNW9ifUPhYbhFI/ZaY60CuhbNnuCuF+oa49TiyCV3tw1OQ2glrgj
	8Xw5a+/C1LjMlTfDdrKTJ8YUJIP3HQKf4FRjVfnd+B0vHU9RbbjqH5W5e9K8f8oXzCnkQ4u1VtY
	nXOSnpz5z94H5TQrknr30Zed/wbhUgAo6koG/tVLwLx3jS0cHVhwtjemfR3CZvNplykurtKGwix
	GF6o6wNjzGecNbJBu0DsRM0CtJph3yTFMZzF+1PNTXO/zO3+z9t8Mni4cqTVPLDVNy7ajNr8PUg
	9Yedhi2WUyl0ojhRJC4HvlHJu1Z1rzYL+CxZuI3YpJTeHhfdRO5de9+EZhwnP8Rmdm2MH7gm1Jd
	IejNk0PS50TxTAtHWH2onA/S01tWmefOhfplytDNkE+iWy5PvWo8bn4GwQ5J5PmrYuS9rbzPgOM
	Q1oH/h/xxbOABJGwD3qbTJ6I5fU
X-Google-Smtp-Source: AGHT+IHW2rHrGjnHbMx7gSl8Rbl6YVS9e37XXYhb9JI7btIp7PDkapkLHawpn2EWrbvZF2/0cVQnBg==
X-Received: by 2002:a05:600c:8595:b0:47d:5d27:2a7f with SMTP id 5b1f17b1804b1-47d5d272cd4mr3349085e9.26.1767033640044;
        Mon, 29 Dec 2025 10:40:40 -0800 (PST)
Received: from fedora (cpezg-94-253-146-116-cbl.xnet.hr. [94.253.146.116])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-47be27b28a7sm604907455e9.12.2025.12.29.10.40.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Dec 2025 10:40:39 -0800 (PST)
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
	linux-usb@vger.kernel.org
Cc: luka.perkov@sartura.hr,
	Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH v4 14/15] dt-bindings: arm: AT91: document EV23X71A board
Date: Mon, 29 Dec 2025 19:37:55 +0100
Message-ID: <20251229184004.571837-15-robert.marko@sartura.hr>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229184004.571837-1-robert.marko@sartura.hr>
References: <20251229184004.571837-1-robert.marko@sartura.hr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Microchip EV23X71A board is an LAN9696 based evaluation board.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
---
 Documentation/devicetree/bindings/arm/atmel-at91.yaml | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/atmel-at91.yaml b/Documentation/devicetree/bindings/arm/atmel-at91.yaml
index 3a34b7a2e8d4..b0065e2f3713 100644
--- a/Documentation/devicetree/bindings/arm/atmel-at91.yaml
+++ b/Documentation/devicetree/bindings/arm/atmel-at91.yaml
@@ -241,6 +241,12 @@ properties:
           - const: microchip,lan9668
           - const: microchip,lan966
 
+      - description: Microchip LAN9696 EV23X71A Evaluation Board
+        items:
+          - const: microchip,ev23x71a
+          - const: microchip,lan9696
+          - const: microchip,lan9691
+
       - description: Kontron KSwitch D10 MMT series
         items:
           - enum:
-- 
2.52.0

