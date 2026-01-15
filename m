Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B74037F74B
	for <linux-crypto@vger.kernel.org>; Thu, 15 Jan 2026 11:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768477286; cv=none; b=OvFb1kXfOFE0HGtJCV8tbdLW/Xv69nqouFJ7YivKrWhjrfzZeJuEHvXoRdPTRLSjTptmQwPYsx5Mz8FTznH917N5uklyjk+IkFTgvrAY6Ue0XOywx2KdpUbTLcnjQC7X6pJMIeRvry5iAaCqBM7194BpokfKMQkIaThLo3P9f9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768477286; c=relaxed/simple;
	bh=oZkxyNVxYkEwJ2vPpe6uc3+Y+pRPWdMC9g09igJuSnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTWBEja0+6l6/L4+Ms+hdn35HXz+yw6VPedNxwGp87Dc79nj55uH/rtv0W6gej00zckIj/fyJ/mFx2sbo3L9jA552OioHa2tMOg/sSIOTVEaohA59pQP17RncidSfwmHajY3djN2DX7pIqQuIsckqhQ6V6TVQo3yjze6a3XuSow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=CtS//emF; arc=none smtp.client-ip=74.125.82.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="CtS//emF"
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1233b953bebso1972035c88.1
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jan 2026 03:41:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1768477278; x=1769082078; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gMliUwDqBaPP5ftrxzLcCvtEBpKI0UiOIsqsdzxW70g=;
        b=CtS//emF+yK1ZnuPnD/oY+JHTsYeSeCJRHslgL13DIGHhrYLJR2WCsrABgc0FDz8tN
         B2v3/aJaX0rqioEPj7o6UvPnblVbJ5BPUMXs2FXhaRbIxfK0vsBzIbFeVHwdxxFaji4E
         8mHJHdwEiS4v814l7OR4XJBze1m8pxWiBGpMmTX0hbE5Ny43XDLAq0XZ01eYty2yYqYg
         SionVUSa0Q6EdmpcsoBEeUJTyDPEqbksBJ6YtE3S4YwwYt7lrHjinWVWjcSd5Dvm+0KH
         MeOibqCGEgq2WYCsaOOHC/5sPhmbpR56RhjmRHy6KRPCGEJnYoaNT8ETSEgIZnm5Y8Qr
         HoPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768477278; x=1769082078;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gMliUwDqBaPP5ftrxzLcCvtEBpKI0UiOIsqsdzxW70g=;
        b=wjN5QKjfQ0/1XzZDBNyUYgKP8zxbrBZfbL9yg7EhIRFdPqe6p99H9v2muPpwZOz+YT
         0ok76yhk3Ht5h+z33UHWwgpn7YVrpyA8Z6w10vIUfakKl8hkZQW1hzq9YVXoy1nu4Fzy
         RfRr/BwCqSP+kfTww7spCYQsqfYAWtoaD3MTnRHGv4vlxFThdpJXmK9CspQWG7Hd5DV5
         x7qB1y4bUo5Ou6UExq9Ur/SFEI1FluLuOOmrTWSg1Pz7kNf/8sAddw0h3KwZJxrRKYfW
         4zaRSpc9G75QiRBYnTzIMigcoMADRFYU7EdVAhMIGsgkdDFo0fsDWk+FlUi3dEkZLM+s
         QivQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4rCJ6tSS2iKEKA3lhFRtzEw7SJ/FPyD+PMGyWyRgRkjqCao9BU+2Jg5AkA8kNI6TPl4XohZfpWqXUc6A=@vger.kernel.org
X-Gm-Message-State: AOJu0YymqNJ3sv2a4bXVfUIKwKkPgzXiGNvVFrb7eX5j5pk2WXtqKTsX
	+u6WsmtSslZMZYFoWSHVogldzb//Ne0kr6EcHmDn3uCWgIkNT3f/H3r+F4FWW+VXdaQ=
X-Gm-Gg: AY/fxX5GENd4MEN0C8yM/d8jdalA/t6i2Gbp927dcY8y0XoffjB+MMNlBI5MJ3vg2Tv
	BmjKyybhrmnqriDR4892HfOA1lqsMkDqUBWDGm+Uipe76ukIb8LGFHgobH487iKTPDxrQWT5jdq
	9lNh9F+qX5EhYypa9w1QwdMRSDYwDh4/TRuSmUt5BqP4slwRLJmCTqqvfYyTuLCw2r4/vYU9Hj/
	0RsaZjjOsERrGQG+ynTeCsDLfa1LGfwfu5ebgabJ8qOfMV+litUTS42NyKy/XQ23STAtxxFyasW
	bwpachd/5PTid8RseNNNRsqGexfWC9A6ebqNuLjHVqE235Tvk0HYuCakReb20ydoKAuR0chzF/o
	YDHFJfIKw4IjImawlyeNWfpAmJp1kBeKbDGhcV22vQ8tK6f4hos76118rmVI1oVSzfSwphbNsWd
	lgNKQfxXb6zn6JQrsqC/ENs4XoQpLjPYHyFKzPnG/M3YbfTID8DxGWesF64FGYGmgC2/YG0bWgW
	FFBoQFf
X-Received: by 2002:a05:7022:c90:b0:11b:9386:7ed3 with SMTP id a92af1059eb24-12336aa83bcmr5197544c88.48.1768477278199;
        Thu, 15 Jan 2026 03:41:18 -0800 (PST)
Received: from fedora (dh207-14-52.xnet.hr. [88.207.14.52])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-123370a051esm4875347c88.15.2026.01.15.03.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 03:41:17 -0800 (PST)
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
Subject: [PATCH v5 05/11] dt-bindings: crypto: atmel,at91sam9g46-sha: add microchip,lan9691-sha
Date: Thu, 15 Jan 2026 12:37:30 +0100
Message-ID: <20260115114021.111324-6-robert.marko@sartura.hr>
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

Document Microchip LAN969x SHA compatible.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
---
Changes in v5:
* Pick Reviewed-by from Claudiu

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

