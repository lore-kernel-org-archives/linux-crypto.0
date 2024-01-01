Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2754820E8;
	Mon,  1 Jan 2024 11:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RZHZIFpP"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a27e323fdd3so76313566b.2;
        Mon, 01 Jan 2024 03:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704109516; x=1704714316; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=E/uOy3CnFQHiCBe8I/foRgMuvqzi5S8GoqT8eS9RKiI=;
        b=RZHZIFpPRJhz7Ce1lw8t2hU5160eBDcM887ljuCkvcaHJZbA33k7NT42yiryTbTDhI
         L3ZhxpFdlJiBaYv+txnBM1OGCLf/DOdvE5J/CXEUtWRviX+HblBtBbDuXUJzK8z1sDUo
         uSkLNikIAEkme1BSJwj+Lo+Z1e2cMrD4sd3gEP1DcUBHj/OGNEW2dUVHR+RH62IcmDl7
         weKTPnDAkM6OOd35XgOkftpI2GS96m0UGkjUUeLIVpALkGnhZi7AWfd1K+d07677lGz0
         7n40MB45RLzYtGL4v7ujlOLfevgK1pRmVpvT0kcPQanqARoP6ZFey40bwwzJloOJnC2A
         Om2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704109516; x=1704714316;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E/uOy3CnFQHiCBe8I/foRgMuvqzi5S8GoqT8eS9RKiI=;
        b=wu6C85WukS8zYehEG944ZcImPd+dCbvTG9tySYkgcLb6/5Dhd5YZwnmhWC2Spsd4dy
         BwCxqRQO75ZjE1AwKYmvoW4mEXbDUTAt7t6pX7586LSCaDeGHg4IVxCb4PAavui4B6km
         7pk5JVqmAM0CI3ABIk7FmJZNbsBVSfgaThOghm3T8CwzUM1Il8uPY4uCZ8V3luo8QhBu
         ftaXnZX6rypv043QseDTppaNun4ucwSBqAXwZt7yam+fDZ92awpoJ049e8XzykQJK5Bh
         NFg9FihN4msPovs1m0vTYU3qz9n/DhX4waUVzpYK8v9IHURCIgo9fMV6ZDCUR7Mk8+NH
         oeEw==
X-Gm-Message-State: AOJu0YxhmsrnvOdyroCFOh2knBZs2Z/gJlwws8mkOADmUDyOHQ34hJpa
	LkmSTHxT4pMdEMRo/0X3cS0=
X-Google-Smtp-Source: AGHT+IFMWdpcy0/MWx/ibh/j5+HmrLs7nLJ4sDnWRai+R4T/INhnpkzvFC/JV7WzEppaM+XkK1gr4g==
X-Received: by 2002:a17:906:f1da:b0:a26:9812:deb9 with SMTP id gx26-20020a170906f1da00b00a269812deb9mr6081870ejb.126.1704109516008;
        Mon, 01 Jan 2024 03:45:16 -0800 (PST)
Received: from localhost.lan (031011218106.poznan.vectranet.pl. [31.11.218.106])
        by smtp.gmail.com with ESMTPSA id fc19-20020a1709073a5300b00a26ea2179e8sm7455038ejc.41.2024.01.01.03.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jan 2024 03:45:15 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Antoine Tenart <atenart@kernel.org>,
	Sam Shih <sam.shih@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-crypto@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH RFC] dt-bindings: crypto: inside-secure,safexcel: make eip/mem IRQs optional
Date: Mon,  1 Jan 2024 12:44:32 +0100
Message-Id: <20240101114432.28139-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rafał Miłecki <rafal@milecki.pl>

Binding for this cryptographic engine defined 6 interrupts since its
beginning. It seems however only 4 rings IRQs are really required for
operating this hardware. Linux driver doesn't use "eip" or "mem" IRQs
and it isn't clear if they are always available (MT7986 SoC binding
doesn't specify them).

This deals with:
arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dtb: crypto@10320000: interrupts: [[0, 116, 4], [0, 117, 4], [0, 118, 4], [0, 119, 4]] is too short
        from schema $id: http://devicetree.org/schemas/crypto/inside-secure,safexcel.yaml#
arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dtb: crypto@10320000: interrupt-names: ['ring0', 'ring1', 'ring2', 'ring3'] is too short
        from schema $id: http://devicetree.org/schemas/crypto/inside-secure,safexcel.yaml#

Cc: Antoine Tenart <atenart@kernel.org>
Ref: ecc5287cfe53 ("arm64: dts: mt7986: add crypto related device nodes")
Cc: Sam Shih <sam.shih@mediatek.com>
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 .../devicetree/bindings/crypto/inside-secure,safexcel.yaml      | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
index ef07258d16c1..c8f4028aa7f3 100644
--- a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
+++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel.yaml
@@ -26,9 +26,11 @@ properties:
     maxItems: 1
 
   interrupts:
+    minItems: 4
     maxItems: 6
 
   interrupt-names:
+    minItems: 4
     items:
       - const: ring0
       - const: ring1
-- 
2.35.3

