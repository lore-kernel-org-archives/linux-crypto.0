Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A38B1DFE24;
	Wed,  9 Oct 2024 17:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728493980; cv=none; b=RdH6T5suLb/R9oBB5bDKQ3GRozpMSVJvNaicP37ruWEZrvHoifNdkXfk89cH64DNg4+5XoVVW9GUxuiIIUylHVIVniXO3U/MDSgyLfPsFI+u+JgCRpD42LzB2udqRFyiDNAhS+O7JccVm8uItGP0V4layzUGCvcevd6mW9RwiTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728493980; c=relaxed/simple;
	bh=ps7yp/ZWbapIQhC0uqrwY9XJKajSwhNNImyZt+1+twY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=JHTa0qcWv53oUlbQ92zcd+YFpmx0EVXxlVKLMG450LQOiGU+LqLNmFN87Hv+duFUxzvS1jHRGonjT2rhxS9B2uSMVxUErp1febu+so5zd+W1TxmACxTNK9bhx6v19OoAT1qg5cbTgLQuonaI2SJnSTCPr3DO+SafDUZUzO0iUpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cg5b/3J1; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cg5b/3J1"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-42cc8782869so71858145e9.2;
        Wed, 09 Oct 2024 10:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728493977; x=1729098777; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=TCrrrWhv3dQaAiqQKhwPQGsc5yyQQKRtf0rbAQxCapE=;
        b=Cg5b/3J10o+ejgcZghq03b0lEPsZph1aQDu0L5arEhT1vROSJcXQ1G96LwIh+jwi57
         rvYeCWfWMyMLpAMKB9H6mjV2jgLWGjL7Wpa/lxV3ft6soJAQOSL0qP6J5DFLe/XeFWkP
         VnDJK+l+RXiNAaNBMbA2FtBQ1LG6TAHlJEgMrGjNd9p237r2hA3H+ihBqTfXQOT76r4Z
         gGuoajB7sIaLVB4clLnI2Es4n0ZsqMtBos3vZkaYFqCQctTamq34EXLGuJmlsYzfWXUO
         iCRD0Y20RHNDqwkMsqv73mKcV/ZFzAUY6VyUaQb0smv7PH46zs5y4yWiYuN6PzGE3Vkn
         79ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728493977; x=1729098777;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TCrrrWhv3dQaAiqQKhwPQGsc5yyQQKRtf0rbAQxCapE=;
        b=p1LMigPkg5qbVFO6aSR8Wh8TKvCwQXr5B1vS7dAl2RHX+4kmWjsVqU6HUYFJ1u53/P
         Ls10n2djkigBhSUkVIN7JA89TeH+yUDVLCVlbYg/vpIJMHOD5OQl+DrVQPcMlHjGOjjM
         MjNVzsF0ATr/OHaLBg3JwotWo1rdV8ZH3mh7Nd0zk3doJgH5NbLP7O8UX239/oSg5VLo
         Dc7PIvGStIIdcFb1jEguQgLeknPYNqeqf9iDaUf7FDDnXIIt/ZQN8iH186utbS2kxg6F
         1/ZYVkrv8rS1UsOMZqg2ybq7eyvVCGZU7N61bbUhbP8uE51WXJa2e9Ks2BehoBTnpO2e
         0OnA==
X-Forwarded-Encrypted: i=1; AJvYcCU05hvL7HVU+8fx74ETU4O6Co2IuBSJsGP3Sj5SozD9m5EfgLRzz9Bl0b9mprN0/P+fjPuulxLzbDOaYXZ4@vger.kernel.org, AJvYcCWwPLtjnMGuvkrLizCaGDZOlffjYXuhpavYBOcqrZ3VZ8H6J3Gf16bHX0sUiLyFdZWfGyRVU8jAESUeC6Dq@vger.kernel.org, AJvYcCXFa9aGJP6fcmYR5Dzk0Ty9URhyRTKgHgQHSAzQAhO7jSsf7oBLMZTHKfqnGkHVvVNixWWe5TZaSBq0@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/Q8u6p5CANTUBlaHUG65XDgxMnG46YU7kUEpmLFbyVI4SErUE
	V8ZyKNc0dgeBXcMjwXRDRbuwr37sszdKDuXvs0Z9ntL/Xb30GXBRPVekIg==
X-Google-Smtp-Source: AGHT+IF4I5CmGa9hcugWiBWjkOlBhbMKeUrlWDazU08v09g6kAUQr2elrd5mrvrr7e4MNY0RZYyfxA==
X-Received: by 2002:a05:600c:19ca:b0:42c:df54:1908 with SMTP id 5b1f17b1804b1-430ccf4c829mr23359995e9.18.1728493977265;
        Wed, 09 Oct 2024 10:12:57 -0700 (PDT)
Received: from localhost.localdomain (93-34-90-105.ip49.fastwebnet.it. [93.34.90.105])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-430ccf5f5e1sm25778805e9.26.2024.10.09.10.12.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 10:12:56 -0700 (PDT)
From: Christian Marangi <ansuelsmth@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Richard van Schagen <vschagen@icloud.com>,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [RFC PATCH 1/2] dt-bindings: crypto: Add Mediatek EIP-93 crypto engine
Date: Wed,  9 Oct 2024 19:12:20 +0200
Message-ID: <20241009171223.12695-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add bindings for the Mediatek EIP-93 crypto engine. The same IP is also
present on Airoha SoC.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 .../bindings/crypto/mediatek,mtk-eip93.yaml   | 40 +++++++++++++++++++
 1 file changed, 40 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/mediatek,mtk-eip93.yaml

diff --git a/Documentation/devicetree/bindings/crypto/mediatek,mtk-eip93.yaml b/Documentation/devicetree/bindings/crypto/mediatek,mtk-eip93.yaml
new file mode 100644
index 000000000000..b0173b4da42d
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/mediatek,mtk-eip93.yaml
@@ -0,0 +1,40 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/mediatek,mtk-eip93.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Mediatek EIP93 crypto engine
+
+maintainers:
+  - Christian Marangi <ansuelsmth@gmail.com>
+
+properties:
+  compatible:
+    enum:
+      - mediatek, mtk-eip93
+      - airoha,mtk-eip93
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - interrupts
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    crypto@1e004000 {
+      compatible = "airoha,mtk-eip93";
+      reg = <0x1fb70000 0x1000>;
+
+      interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
+    };
-- 
2.45.2

