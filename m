Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28880306D3F
	for <linux-crypto@vger.kernel.org>; Thu, 25 Sep 2025 16:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758818448; cv=none; b=WUORVu4K1mpYDZSBW15MRff5QHWo9MCItWAsHOtSKebvC3WKx14mUKO4aPUY5ftipiS/igdf35KAzwD0zbtKDqQnuDZhCh6SEUAzlWljdaiI0OVIzfPJFWnkJBb12hu0M1v3B+yGf/q6DhkMzBrOiG/AvlaWUBvmffgmn/8Vizw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758818448; c=relaxed/simple;
	bh=MAVG6XeMaP+9pF3hULqJiFuqVbiW3W69qtIjS2eHzx4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=n0q0lk0O8Oxxufabv9T9WsxsBLrdFxWQ8NyovIfP67AbpoPTR8z3hzuYF+LO2XvXZfQy7BbrzhQj/lDLN2XtDqjExllwp2oqXg4DQCJqEBrisRuXBzbp82kjPUN+pdPJ4JEzCK/Fn5PVwoRBaCbY3dgnsGgMuCjUJ/Q+TpN4Es4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VerTbg64; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VerTbg64"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3eebc513678so1317176f8f.1
        for <linux-crypto@vger.kernel.org>; Thu, 25 Sep 2025 09:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758818445; x=1759423245; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ms//Cx2KpQPodFvmBjr5qtYhxMu5fF/NuoJ5civygTU=;
        b=VerTbg64pRKBH8pEy48WmhMQFgelsTYCj43OUSAUK8auqBrFt5ZbInOHXu72cPeMSo
         KPi/kXif2CQjNd5AEXhVXyCBnskfq41aI+iJhs42QwToRsXaAWGL89mHDLSCKzLgSaQW
         qCaMwXBN2dhTGtutISZkfGMgWtIUuxfzeihv0Z6fMcR0UyKrVd+J36EJjs/iRXC9gF9U
         TYVGH+AmbsI21VQzVM2yNkiPrOIyH3mHp1oAqjTq5Rvln/fYPy+cEa8QKsDWDeY+Zxzn
         0cPK32BgcKYbeeIbMjt4rcg7eNKvO2/eIbT7HmLzaJZhCRlgcl35dPU5VEP+cFwIYr7F
         k/xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758818445; x=1759423245;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ms//Cx2KpQPodFvmBjr5qtYhxMu5fF/NuoJ5civygTU=;
        b=W7rm/M1SNT3ibl5iw+FHn1aIg2h3DtuR+cNSOiZprDgVV2N8vHodfuW5Chfb8cLV3d
         fXG/NJlNnvZ+0VksrjaLkP4pwT/MkwZsxlLjGWXFF1vjSpKK7h4e7ShZNe8n1LeZSs9W
         B2iJIB9PKTiBcLx93F+2fhLphPQmNI8X4j3PYEi4JBDslTvyw0mS8WpM+RlRgAEv0ItS
         GOQy3USFNW6UXbtVd5U7wKxfRIsuJvOjwQjrDHI0qpCOGJfmTEBmZgNdei/bSiHqHlvF
         PccDNKJBLf/L1SBjHo6W2CFZ4rb4IdBZ2H6zE4leWVNKqgwrfBqQwMV1akCa2oU/HPy2
         3RJg==
X-Forwarded-Encrypted: i=1; AJvYcCX1p/5hQXEB+K2qlXmM6Xy4yHy0nnL5WWgjwvslH1gu9Vs6T1dW6QaHkSBBIfDR29wTCYnNLIalr5x47+k=@vger.kernel.org
X-Gm-Message-State: AOJu0YySYPdqUWj8TwK/bY/0hYNKVxe7Qsnal0MvYv9FUrhQP3/S1nGh
	xflUqS42HDZ1ZdnIaCFFeL9CaE8sefoDnWiCtz5o9ICb7YdH8LeNmF3I
X-Gm-Gg: ASbGncuPF3N0ppPFN3tSkgHWUY3O4WZDMZFqVXEv+w1ii8uz/9SwaXFlW+yJMVpzTwB
	KweMNn4s17SzaHUTVIUWkR8FH93A1rRCbj3ImtBZ91TLhBpKz2mzhqZNPXwy1tHjw7CzkYkuMYQ
	h6OvbPbqisDYH3TE49ULOZGWY5ELpe7mkMYdUrcr2TIZ7cCOhzEtVu1YV6ePCYelM9T3IbX6Lb5
	RxOuxEVLroROR1Dnjc+X7RhA8upAJMUyqbvBI9M10QflbOMZ51hJLDtCYKliC7iaVQbCZ99BL0x
	FPYh53hsFg/aHhI/CKQ/283RX5iiBO3XCZxlZ3C+o4admzmUX0cINZC9PyNgHhoAgznqL+ah3GU
	LDKtnxiMKQWe7AByG4wBWafrmemNwr5dyEUMJIipEnuuzIygyViY3nV7hXQ0hLWwDIpMi0AA=
X-Google-Smtp-Source: AGHT+IFhsb6qW5/GahKJeP2Wl3RdIGj6vmskf1jEdNXYYA/Gj3jq1OBG69r49jeZED4H7pHpv3jTpA==
X-Received: by 2002:a5d:588c:0:b0:3e7:6268:71fd with SMTP id ffacd0b85a97d-40e4cb6e2fbmr4192124f8f.52.1758818445399;
        Thu, 25 Sep 2025 09:40:45 -0700 (PDT)
Received: from Ansuel-XPS24 (host-95-249-236-54.retail.telecomitalia.it. [95.249.236.54])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-40fc6921f4esm3591904f8f.44.2025.09.25.09.40.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 09:40:45 -0700 (PDT)
From: Christian Marangi <ansuelsmth@gmail.com>
To: Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Felix Fietkau <nbd@nbd.name>,
	John Crispin <john@phrozen.org>,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-watchdog@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH v3 0/4] arm64: Add AN7583 DTSI
Date: Thu, 25 Sep 2025 18:40:33 +0200
Message-ID: <20250925164038.13987-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Simple series to add initial AN7583 DTSI. More node will be
included as they will be supported.

Changes v3:
- Fix typo EN7583 -> AN7583
- Add specific compatible for watchdog and crypto engine
Changes v2:
- Fix DTB BOT warning (fix crypto compatible and OPP node name)

Christian Marangi (4):
  dt-bindings: crypto: Add support for Airoha AN7583 SoC
  dt-bindings: watchdog: airoha: Add support for Airoha AN7583 SoC
  dt-bindings: arm64: dts: airoha: Add AN7583 compatible
  arm64: dts: Add Airoha AN7583 SoC and AN7583 Evaluation Board

 .../devicetree/bindings/arm/airoha.yaml       |   4 +
 .../crypto/inside-secure,safexcel-eip93.yaml  |   4 +
 .../bindings/watchdog/airoha,en7581-wdt.yaml  |   6 +-
 arch/arm64/boot/dts/airoha/Makefile           |   1 +
 arch/arm64/boot/dts/airoha/an7583-evb.dts     |  22 ++
 arch/arm64/boot/dts/airoha/an7583.dtsi        | 283 ++++++++++++++++++
 6 files changed, 319 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/boot/dts/airoha/an7583-evb.dts
 create mode 100644 arch/arm64/boot/dts/airoha/an7583.dtsi

-- 
2.51.0

