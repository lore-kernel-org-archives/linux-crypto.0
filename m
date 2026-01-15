Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3460337A49C
	for <linux-crypto@vger.kernel.org>; Thu, 15 Jan 2026 11:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768477272; cv=none; b=rBa6D/CYjh34ECKOGNUQjiNN07WDN8NU5LM5fWs3yIUsDtPQUl2iA3rc8SWrUFU5h0UTlbba6qwbZ4lmJ9DOOyc+14Q/alA2zcFsFYwNCDWHkSu4CEwnGmK/2CqlPTNvwB+2qm55vVQchURQNWRwyZy4BveZ5duxnEYBwU8xy8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768477272; c=relaxed/simple;
	bh=ooKaWydLYAU6ZinUS3YSKV/BPM0KTw6HZzaYhJx/zZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRykarMIXa/VseMWVESPnQEEWRJ0mIC8qBh1IcWRQq+Ij3oWLTj7/P7W1TaeRNgps4uQpfG3s2320zvvxyhKyjKIK1EmIoDY7pfb8gemh0HcgTVnVDKDllxKPv2I2B3ujQK4QY2bwaLauDYevbwgn874ffeb2cf4NOTIQHae/wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=O5lnGvCp; arc=none smtp.client-ip=74.125.82.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="O5lnGvCp"
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-12332910300so2054019c88.0
        for <linux-crypto@vger.kernel.org>; Thu, 15 Jan 2026 03:41:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1768477270; x=1769082070; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jyqWPUPdksTIWYuKZmgo4nd2lHSjHXcu6SXb4jlQ4Xc=;
        b=O5lnGvCp5bru6pC2QaWeoBDVHfK15uwu/E3xAeyAUrr9SjEKNdMJFD808ELIWWp8/P
         cT1hffs6A20FXgIcfPjrhRBE/hnQ4mT7Cdn5difSKDrwyd2hfnL+VBgve9xW0YEZo/mK
         BWpmhZEsY0pVJb3Ze+8VNhQ3fjwCJFeMmyElICoDzR9t7Tm46dWQKLCA3fYhx4CQVHT2
         qxTosX+FWOY8D4BqXIDxbpEGADEzw9xh+L8NnwM67RGSd7pTqsiUedvqnRJm6445hNaA
         pK/cG0ss6J5hDKrm1Ag3z2x/qoAeHC3xbnYbZ8jcUMwAMJUqeCEBR1fGzp9vT/vOqmX6
         FI5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768477270; x=1769082070;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jyqWPUPdksTIWYuKZmgo4nd2lHSjHXcu6SXb4jlQ4Xc=;
        b=UfEvn8ImX3nPZVl9Su57H2DNPMzXueJDNI6EKgBlQ/AdgDl23KB4hOTcg0YoBs96t2
         b9qXkt3oi51VbLoQkSGkd472hV1T6jjSabApc0UHyKJqoMp2LVg9kq7Z3XszMnyi5Mir
         07nsOj/s5x06WuFTIqD7Tg+fPplb+eyVZNTbSqcZ5EO/79djl3sMgN8S7jiukF/J25nB
         bTGOJ5y7x0R+vOIdKfQc48UUP72xJT3d1AimDuKqOeufPjKBkXDjXuYMpEygWQyYocIP
         yJMTvMj2ydm1550eBIXMOaBzykvGyzYESsTV/v1TIyAAZU4xJjVoOHC2T5a8R4EWNB9k
         zTGA==
X-Forwarded-Encrypted: i=1; AJvYcCXoXxDtgLef+Y4EX6YEPINqJDO3q0l4EwniORIBBv7m4kO3yFjbWIsC13Cew/3mzOqr+ovv1zqV0jEFCIU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+muArR0sI4tgO0jfGkVogvAUlSKqyc/F67U90x0EjboV0sGZN
	bWNTN3LV08z9/p/Xzc47dXwq+9znCg+wFf2vd2rPu96PWIhUEX1/TEzfnjMzEik/imM=
X-Gm-Gg: AY/fxX7g8Q1pDQ7VNgGJPaTuvijR2CgEBpkzGZeKL4q3CrSSwZwadbZ83V7w1MrU+so
	FprPW/HxJmNVL4N8BjYHaOsYIJeBGCMZenmBcjB71of3ov27h6ms8BCqGEOOA5liftY1I38CIrG
	rBFijzH5jaTHQFrLz4QIs3Dec7Z8WpGg0xpWS3BcrPUgUdw/pAVM5g+t6GEFo+vzOQFJ00stX3d
	K4dIkif76UFreWXKbd0Px/r2gAPswlmGODWzGhJxHrQ+/lNPvnthWCilQSDH/SgPXd5DAp7OCR1
	wRMohcvb1kUGQ6OZCNuHJJz9/lb0uvjLcFaWAG09ljnE6J2EU3BzEKBpfY1p19ITOAO8VTCfDG7
	UbyBYU8fWxTKlz9iFtGzR9o1piZfRVMQLQHWcUQ3mcsw8mR3RO5PrkSOIzkJ5msWSA9WdjEnv6U
	XzZFPvCo03iEMYXpNRhPJIOi3lHF5AFV0PExSJUOai15msH3haa56eE3pEzm9OhCdO0AThPw500
	GMwtdhg
X-Received: by 2002:a05:701a:ca0e:b0:123:2c98:f6af with SMTP id a92af1059eb24-12336a45a0bmr7461678c88.14.1768477270097;
        Thu, 15 Jan 2026 03:41:10 -0800 (PST)
Received: from fedora (dh207-14-52.xnet.hr. [88.207.14.52])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-123370a051esm4875347c88.15.2026.01.15.03.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 03:41:09 -0800 (PST)
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
Subject: [PATCH v5 04/11] dt-bindings: crypto: atmel,at91sam9g46-aes: add microchip,lan9691-aes
Date: Thu, 15 Jan 2026 12:37:29 +0100
Message-ID: <20260115114021.111324-5-robert.marko@sartura.hr>
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

Document Microchip LAN969x AES compatible.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
---
Changes in v5:
* Pick Reviewed-by from Claudiu

Changes in v3:
* Pick Acked-by from Conor

 .../devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml        | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml b/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml
index 19010f90198a..f3b6af6baf15 100644
--- a/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml
+++ b/Documentation/devicetree/bindings/crypto/atmel,at91sam9g46-aes.yaml
@@ -16,6 +16,7 @@ properties:
       - const: atmel,at91sam9g46-aes
       - items:
           - enum:
+              - microchip,lan9691-aes
               - microchip,sam9x7-aes
               - microchip,sama7d65-aes
           - const: atmel,at91sam9g46-aes
-- 
2.52.0

