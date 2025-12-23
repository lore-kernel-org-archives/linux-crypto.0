Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE95352949
	for <linux-crypto@vger.kernel.org>; Tue, 23 Dec 2025 20:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766521263; cv=none; b=oM1Osfga/TG5l7V6FDmDwdQmXDHVIWM6Gs58i0ELgJ39RkKXziDv7F5H3JqFT++4REXwXnQI1zbtgmwX0F1cIs4FTqIbda6/EmOlSbXSEgWHNjqvXgnqb8BOLG2I62M5/hyGFiOz9Q50YFk+R93//8cTiXAWSXEM6i8AyCTyYfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766521263; c=relaxed/simple;
	bh=7hKH5EzmH1tw2QTQXNXPEJl0sVHK/le/PcpUxmqe6fQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bake5IgyQR2MDvnanwUbRG/JR3nXEG1k6Ga7lyNUZkSv01EbMd9B6yz2/LmKLw/1O29Uuf430EbmOA7U5CTnjOw0onfwprA0fb0Wgxb9RWCGyUa49Y6BYVfuRpw2hHoaSe9oFQTdgHkSwEfim2g/nJDkAeh1m6qI2D+RtlMyrKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=qEXm32uj; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="qEXm32uj"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7d26a7e5639so6112624b3a.1
        for <linux-crypto@vger.kernel.org>; Tue, 23 Dec 2025 12:21:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1766521260; x=1767126060; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MElNA+evLW3q9gh9PLqoqAuYhUoiUgxuy1qDVWGw3Ao=;
        b=qEXm32uj1+odh+mia+XgDAG39bxsV8BBnWSP0gbyH5RJhUfEzyjInuhiC1FtX9Wppx
         KLxk0YDYruP0rpIpgefdNHqLi8+C65Db06vxmizhWFJNlUeyE4PALzO+idf0NA0jEvMt
         4bfGeG4K9boAoeBljyhuYdHQPXx1fzDNbBeLm+/ymuEu2mywxvu0nFbFozqKna0aW5o9
         UF/l+z+RE/wWwKcEoAMBfnOLbiRWzz5O8Ua1eIoWr08agzCuSQBanUqTE3b4fvbRKl4J
         RwJDjpDIeBb/IhuLWShFAWC3/IHBkQBxlolO5/7LijryExtWwxx8zreGCz/caCv02scj
         QTrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766521260; x=1767126060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MElNA+evLW3q9gh9PLqoqAuYhUoiUgxuy1qDVWGw3Ao=;
        b=Gv7opYly1s12EC0/iQuWSwk7eqiRa6j+/va++/yLhPR9vYNrf35fpr9Z6RJCp7b2tm
         Q45wzfPcP7ksicKb5bBnU49bLN+U5RDtHzXwJd32ptVV4yekES8wK2ADHrLCnc4/NM1d
         qteDcofERnkhOnAzV7oQKJld7PD7J13ZwHfPCx6fT8Jhk02iLbr6bujlkyF3V/vMKddA
         0R9VuyRPWcKnks/o76uXBCBjJNc+97iNdZug8TYSznULr0tQP8B5jxcKxfAoOvKGqG5z
         kD8VhSeIjv9U4zAOVqG4E8oT3tMN6n34zaWGuR8MXTSFJO5CAs23BzNq+bwXPWv9vC0D
         DFQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNao8X9BhS+/5iawKLSCiyNFSrAJS+WJIuI23vs1bZuB3XguK69FgUg0nRIHcEBZJWpImoaPtE5CU7VT8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz303gGjDSOU5i/Ue1M2bX27I3b8V70D9sKPoN5yjX0i0IAz6Eg
	G3dOUeB5RCkG0jVu1qfzE9KOa/tsHvg7bYLAglJx9PCS9Oi1t8bTxDScRy3/3UvuX3SXqF3xRK6
	LNvWiVhc=
X-Gm-Gg: AY/fxX535bf+cyUIX+eqnsI3z+ylj/JsARgV5MmIflKIIa8QYqhpWKr59RhfF9Mp/Zo
	YEDLR+/cPa9TzgsLy3V3s56IqZCjW3fEMT+9XDmYdruWbVk/Dh6NHFsyMWOsQnyn1WfTGmUcTCX
	pwh/ISlLamk+gsGPFW+OOvHQeKokJ7JjkyVvS38M5N/p+1Sif8KEcRBQDh6PdHJdqnYzjERmS9i
	nusfhywUohfmzc+qwZEFUyUHai99F07ekjceSnjYifNOiA9ai50if4OnRKWgr2pz0CZyp+FgK0t
	MeTHelMHpgy5KUCYIIW+g2aVsxYi/aTgn8OTI/V/Pb2KxELFCwqKhDLP/tA8UrXZriNdRjpC90d
	EiVLHgEuJWLeTI6XzM85ZyNnqZFH2oNZOzj9qXmqnmI8Wu49L9l2tw+8oY4puXbbh8z49WBVVKB
	Fyw7hKUXQHOFBlXrPEA2tLbjbtGFgEp2jx69o86SpQPAJPOkRrvblElQsa5gLE1lPTG6pG6pZt1
	Gm0yVYd
X-Google-Smtp-Source: AGHT+IHKfwHDjFbBjFoOP1ZNZG2yYIy8Xdi86MslAqVbrnS76U8emwCJO7CURd8duOcxnItzlu++Ng==
X-Received: by 2002:a05:6a20:7289:b0:366:1880:7e06 with SMTP id adf61e73a8af0-376a5449622mr15082294637.0.1766521260025;
        Tue, 23 Dec 2025 12:21:00 -0800 (PST)
Received: from fedora (dh207-15-53.xnet.hr. [88.207.15.53])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-c1e7cbfa619sm12567549a12.36.2025.12.23.12.20.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 12:20:59 -0800 (PST)
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
Subject: [PATCH v3 09/15] dt-bindings: crypto: atmel,at91sam9g46-sha: add microchip,lan9691-sha
Date: Tue, 23 Dec 2025 21:16:20 +0100
Message-ID: <20251223201921.1332786-10-robert.marko@sartura.hr>
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

Document Microchip LAN969x SHA compatible.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
---
Changes in v3:
* Pick Acked-by from Conor

 .../devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml        | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml b/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml
index 39e076b275b3..16704ff0dd7f 100644
--- a/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml
+++ b/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-sha.yaml
@@ -16,6 +16,7 @@ properties:
       - const: atmel,at91sam9g46-sha
       - items:
           - enum:
+              - microchip,lan9691-sha
               - microchip,sam9x7-sha
               - microchip,sama7d65-sha
           - const: atmel,at91sam9g46-sha
-- 
2.52.0

