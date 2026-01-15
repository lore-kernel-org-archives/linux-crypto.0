Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED055313E1D
	for <linux-crypto@vger.kernel.org>; Thu, 15 Jan 2026 11:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768477258; cv=none; b=bp6ukpq/Pzo38kTylmPTnwTzz93X8skLPhxyhya+11UsxKMfSbzgvalzWHknvHtqS8DT2zYg/dU+ZAtsjZ6UniuUfYuznDEA1RYthhuDMFNj+HqHkckBGoHFrQjU7UHdhf4kGQLiHoNib7oLTmhC/yPExhYNPzDjLdF5v/IHahM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768477258; c=relaxed/simple;
	bh=b/54xVwD9NWBApT/YlbKlATwkJX1Z2JAQOFmiza0IIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzCqevCmK5bpGe4Q9itYcFMyzzb7pbVlbuTLp3tcCCTgcDvaWdoLvLdNe8KBqbwxp1Lvw1/4BaWVDCCqDPsVD2ymf5ZbcNgMho3FT64V61wlKoYULfLfizTpoJpHtoRACN8z5HGS45QtIjwGojhtx0yGgMdQOAdxu7gaMrZSwx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=BzmUI76H; arc=none smtp.client-ip=74.125.82.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="BzmUI76H"
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-1233b953bebso1971294c88.1
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jan 2026 03:40:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1768477254; x=1769082054; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W3+In9zGTnNVCdfWyUqUmvhLH5cDZ41X5IQo0vghvEY=;
        b=BzmUI76HFoIf+H2p1c/j0xVbV4COe063YZKargTzFj/IGBRMeJPYbUTaHaxA3d45xG
         z8lSpJ8fz9wv6JQE09xRzLQTKoktg6GvXS/a8od588oaSVTo+xhBZ4Fqb74NiN6xvQZl
         HtsQUCSb7ngWotCTs5g2GJnkserXtPybEEXO1A2is6tuUeQVQ9jfHuQZVE8uX/IxPmM+
         KVHrgxVVvGxbUYvzt2bh43cxu90LawRwhWUJdAaZRIBmJZl91t5X4KDK98mBFre5IhJh
         k1dZtAE8z0oetFMzXE/+2TxlBijLZAi0Zr0lKGTLzrmxY51ROW2ekXGE3hQheRXpbNd2
         9xaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768477254; x=1769082054;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=W3+In9zGTnNVCdfWyUqUmvhLH5cDZ41X5IQo0vghvEY=;
        b=w7pADb6RrEjXbimDvSYqw5m/sDl4EnFZeyPIqKnQ5ezZFNG51USO2yRMjMQqn0cKtL
         iPfryHGuMo2xtLBqPmjQPCp8boCAy185ZcF7ks1FN8QZLCSR2ICGFAy3YLD/IJSOKtGH
         ZuofDIl6DLv77RcwZh4yiG+Maq1OhWZ2qrK4AvPn8Njlv1P7oXQbDv2H69Lh0t4VHL+8
         oubAtYh5H8lqV9YmwGoSLHudKGBM5SGD9+9RovGh2p4J9Pcb7GSxav1nBUF/1nzHwgtf
         yiPqNT9gpZnZ8Pn2XoyFVUjibayeyHkG/58o7wK/ffosDhwuGRJBcWmj6T6R9Frx6kMy
         uzyw==
X-Forwarded-Encrypted: i=1; AJvYcCWXPskLuO64B65Bz+udYynbyvKMmuocK+ScNbLCFR7XG9l1aJ2idcQHa4icbRVK9U040V4GbDOMX/ozlhg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxk+bM6GMMtVfFiaLNXbfgo7VV+jLT67c5p+H64hVMbAVAAqdpU
	3DvPkGqf/DaG8vuXtUI0qEXbOOTqVDZzWDylrQ2gpT1Tr1AyMgANjMRng2UuUI7cGok=
X-Gm-Gg: AY/fxX5eNl5xDvu0dRP/sh4oPTkDNvZoaz4M5dTaSRDIsxYKsUWGmFmsyKBBsT49pP/
	ZrOI63VQZnbDXdoMJpXjUV3P4jrIg4n0FIFev8DG+iYJnkSEE1qQo72kiaw74sR2YfKLOglrf2d
	NaxZBw+PT5Ve2IyWhPste6sxLUbuoT3poZfKVIUJY2Y+rKjKvxPe/1pUiay7tLVbvHhvEkQFzq1
	DfVBMuKu4UkZnZHSt7v2qczusNLvt/4jU46ZoHpSgz6XBOw0UO9uwtifrR7nshLD34fzjG6fw7O
	PUgCNQs4LbuCkKOBxHojgQVwarE5b+PA0rG0RSVYjs2IULPeuvLTjS09w8Zy9e0EHhPOke8eETv
	rp6oHyZXAHpjbyUZSnH7EiqIHy3+jkKj5mke6/vio3Vg9Z8PYBQvlprkfNF/azaow+DU5LGDnA/
	36Xeu9csNrRSsoZUeNE5t7Da+JADqA8PyNnZ6xZTFZwhDemmAycANxDBOlWetCH8uMGqjoxNWI4
	CdbVnzO
X-Received: by 2002:a05:701b:2715:b0:123:3461:99be with SMTP id a92af1059eb24-12336a38feemr6811395c88.21.1768477254152;
        Thu, 15 Jan 2026 03:40:54 -0800 (PST)
Received: from fedora (dh207-14-52.xnet.hr. [88.207.14.52])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-123370a051esm4875347c88.15.2026.01.15.03.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 03:40:53 -0800 (PST)
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
Subject: [PATCH v5 02/11] dt-bindings: serial: atmel,at91-usart: add microchip,lan9691-usart
Date: Thu, 15 Jan 2026 12:37:27 +0100
Message-ID: <20260115114021.111324-3-robert.marko@sartura.hr>
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

Document Microchip LAN969x USART compatible.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
---
Changes in v5:
* Pick Reviewed-by from Claudiu

Changes in v3:
* Pick Acked-by from Conor

 Documentation/devicetree/bindings/serial/atmel,at91-usart.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/serial/atmel,at91-usart.yaml b/Documentation/devicetree/bindings/serial/atmel,at91-usart.yaml
index 087a8926f8b4..375cd50bc5cc 100644
--- a/Documentation/devicetree/bindings/serial/atmel,at91-usart.yaml
+++ b/Documentation/devicetree/bindings/serial/atmel,at91-usart.yaml
@@ -24,6 +24,7 @@ properties:
           - const: atmel,at91sam9260-usart
       - items:
           - enum:
+              - microchip,lan9691-usart
               - microchip,sam9x60-usart
               - microchip,sam9x7-usart
               - microchip,sama7d65-usart
-- 
2.52.0

