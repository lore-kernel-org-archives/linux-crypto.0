Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9409133987F
	for <linux-crypto@vger.kernel.org>; Mon, 29 Dec 2025 18:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767033631; cv=none; b=YG8qBK1nuEgdoqA3PM5TmG0Pz960JhN0RwpSYw1LCjiz0Q62tFkEzfAsLVcxmz+tvC4CD3+SbX7TWcFnKuTTRu69ivcd+eUtOcdaWwxsPIpgOXfkNrRUOmu5Md5iuSlHkcIwH3PcnqQ4IxOCassVI+ZuSKOMOTE8xzVPneKW5fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767033631; c=relaxed/simple;
	bh=zUvrtsolEdengocgVlyXQxoSJXOg4mGPqcC0PLdIbPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFFZ0W28lwdkk+B4j4outJbWDIHYtdbVJXr2W/ZMyyR0D1NJpexwN3g7Llzs35fj+IjBDQxUfX76M3PGXyDhKS/zuRh6GFVACV59BU8zGbM2wgwVsAZX/mHTNx1U81FaiOjE65ViODVYXZsEDieakJdHYBPvIcrrdZX5e3b0w9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=nrSYBFVg; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="nrSYBFVg"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4779ce2a624so71188695e9.2
        for <linux-crypto@vger.kernel.org>; Mon, 29 Dec 2025 10:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1767033627; x=1767638427; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XldW6lxnsgyAezmPBHgoeGUpbHtzZudWE9rMzsQl4gQ=;
        b=nrSYBFVgIwnAefLeDPgYgl8LqPiDckGltKlnnW75XVRuK+1yY9xg3gh3tZq8mkufWc
         bhWiM36cUBWMUAHYQq5VxaauBN1JBIGM1CoAC8bv+EjP4ME/nR6R7Y2d1Atbm5cJQNSE
         YakDsZ/R1kZY+j4wBQsd5PAXPwYKwrwuFRZtmYDWxrtbnG27rLcX1oBpHJzbZkBOJeRG
         /O8465TNdb93NZorMxyrz+2AaTqkqW0Uztj86TFG1zFVqHK9e3/M7xA6e6pQgFYtDjDu
         S5XivWOem/+RsxE7b3hkn3aI+uUJz/5pGcDpvkkbhxo4xpt3Fb/AMTvy+Y9k6ba8G5Sh
         L9Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767033627; x=1767638427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XldW6lxnsgyAezmPBHgoeGUpbHtzZudWE9rMzsQl4gQ=;
        b=uhibDKEqUgXI/25ZQLUD6XfuzqP1LCZ4KCW/JOwyECtqIBOfc+yX7Y0l0F+dXWOcBt
         Sh7WSurYz2vI1c+dTTCovQCmhXIym/1pXCFNaAxm/wZLS2Wx3Jz1QwTAzRqRt91AZCgg
         p56+QOcyYFL0g/RqPwXrBYEzvQi4NPQc/BEn23g/Fl1cas0qxLZaVc8jiMDe3mdtfaxT
         WfLLVZ2bEFY0fSuiX//NMi4J1qVi0hP6bHOKvAYNwJqDbVz2ZdU4sYhtB+WpGKleHkYH
         YKWzsmh88sQ2DS0r7tzOnzsSZbfY1zpRM9LUPpavsORj/BifsLdAz8QoZjUhCD2bpg1O
         eduA==
X-Forwarded-Encrypted: i=1; AJvYcCXoH22OnYM4Z6gdpD5pylfhwRn9/BkhRKnwQr8ghYTY0dsvZi/l96pBnjiwyYWZWFI7jSzIeChCB0KHQvA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyk2+CjH8T1icYctu064ljPPcU0/cyZwqG0WQ8iw2qyfqli6HEZ
	Y9GE6mJD2tQODW+k4qTGejwlW3vY8OGDpMCPdhbupPUy01+HANof0wGJDoZBs4cmmWc=
X-Gm-Gg: AY/fxX7oWQUGlkrH2+VoqjwB47lGfNFEQSDpbIvN0zP22rf1r2tGZS/YezZdxk/WXBa
	9EXxeeb91BBui3a3X1s8nKzqO7a6jj1YuG+zqcqCOLE+KdUMmS9nkDYKSPJNM8sj0I6VNpQwO+k
	EFTJ3cc0NixzNU97EnU3vLkgTWeJMAjuFJvdRhbqj0qlWi1XHNTRU0u3pBbG+l6Evpk/z0BMl1h
	maHw00ZwY7LqZ2lcAPMogECILvRl3t5r8r+XRRRjk+xLtudLZ/Z5BxZhWzkKleGJEUEZxYem7Pu
	JockMpgqJRs9suZBzPWdNS11vekBs7OsplGQeaUxR0uU5TAjjrd8hpsW/e5d6MigYxOkUatXsnC
	pPtbpPYsw4qxtm2H4biIZkkK9Ufz4hlFrquT5Fadqd6CyhhySAgrYp9zPPQ6KvSmfmDTbadaUZB
	5lzQc3AF+LYr4i2uQu2HUcqx6wmHxgHy8zuUOo6EhRaOgelYH5iWCkultA9M9dm1d8hPQAn5aSZ
	/ej8FwWC6kj7vLiKqtA6ysqw0pL
X-Google-Smtp-Source: AGHT+IHcFjQCCkIHzURsiMd4ZffbXQCjBanKlfgaAMAIAjZSkOlosZ6OaPn7ElCbfUOqooZC1IjlJA==
X-Received: by 2002:a05:600d:108:20b0:477:9986:5e6b with SMTP id 5b1f17b1804b1-47d1c038664mr255230805e9.28.1767033626661;
        Mon, 29 Dec 2025 10:40:26 -0800 (PST)
Received: from fedora (cpezg-94-253-146-116-cbl.xnet.hr. [94.253.146.116])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-47be27b28a7sm604907455e9.12.2025.12.29.10.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Dec 2025 10:40:26 -0800 (PST)
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
	Robert Marko <robert.marko@sartura.hr>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH v4 07/15] dt-bindings: crypto: atmel,at91sam9g46-aes: add microchip,lan9691-aes
Date: Mon, 29 Dec 2025 19:37:48 +0100
Message-ID: <20251229184004.571837-8-robert.marko@sartura.hr>
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

Document Microchip LAN969x AES compatible.

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
---
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

