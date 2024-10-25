Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C211D26F9;
	Fri, 25 Oct 2024 09:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729849691; cv=none; b=uxw5jcoS4Tnh5JEsb9TPdnchrCisWjpiEf4QVeHahoI2UnwVaV9vq25ATxKg5mKBRG0uNAcenIn6NvBGFL2lE/9hYNUVtVqwor8KmIhcOKC+mfjbOGF1Dnd5Tfgk+VvfMSe0k8MJmUJ3PDeBvqylLsN+/wAlwnKwOFgWvLn44WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729849691; c=relaxed/simple;
	bh=upJqRRtNAZPU+dg1sPXNWxkryZ/KlxdvcsJwsUACSGQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uzT9Vuaysvj8I+LBALI55UF7nmdZHtUvTaYlto8trHUcOhzPn6EK7dwLcI0WKKpbGlVG/fT4ymGiymyNx8+zco7Cvj7QU3T7NOzbE8+b+6FPebCP8L8DPPT0QdzF8fjseIZk7iqcf2Qp5c7VCCdN2omExxTXsKPWqApJXsNBIRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Twd/I/FO; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Twd/I/FO"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43161e7bb25so18168515e9.2;
        Fri, 25 Oct 2024 02:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729849688; x=1730454488; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n5asADBS1F3aB0Wg43P3iJf8SGA9bnOGbMba6H5z7pU=;
        b=Twd/I/FO0952yhBD42qkXICa7R47HfMMV2GkT87jiV9cSuRLKVyzh0AwSJ6QnhDjiT
         Q4UOKgUDWhE4jZXFsaQHLDrNohKYuazcBbUe7Elchm/OTY60BRYI6zpe7xJBTWGGJJUi
         rBciHCI807udNKb/Erb4JyARExnjOFSSM9EW5jnSL/hcYz07WVDuwHV7qVOxC4lE1Az7
         hxraAxvkXyNOZKq2i+3d3DE8X6Zrks5pFXe9D4N8sGPhyaoHxOHINykNTf/W0hP+ZNsX
         00BtHDmEvtoLfgbuBG9gwFNRZ8wkzYQNPSt+CtTvwTQUNuENUDFS3UL+w2xvf0TrzflJ
         JOOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729849688; x=1730454488;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n5asADBS1F3aB0Wg43P3iJf8SGA9bnOGbMba6H5z7pU=;
        b=MOR6qJS7GKBIvrnevYjS5YbntWwk3dgpGh1Los1h/RjCt+MyyPP/fEVjL9IpGfagjM
         DcuiZPQwuBFLcncjJ2122knnGAtlPZMt0j3737Wx0Dz+kG2C5cvJu4UlILbJarUH+Lps
         u4UV5/fO89QUvlfVQubVJLFxl8HlI96uSlen5CUF5toQWViWbWmbERqSmgWqtuYlAdBY
         0eIChBjeZsqLRJBTa2nqppA1tkB4sFKZiX9vAVG7WuJPSK1SfhUZJU9rderzxrAXupBc
         l0gOwGe4FUV5YnmT1TQauPY94JekFRHj+lZ51Mlz6/evBYcDfI0pJWgt6ko7hZ/qUEyO
         pvTA==
X-Forwarded-Encrypted: i=1; AJvYcCUH+6+2VRPMMjD6lfTPAcjbHYmPnfQVThoW2rDWTnGuXoIyXyH7Fa8kr6CwtJrKzQEFLNuQSvvk9Sc5@vger.kernel.org, AJvYcCUqyVBF3dcQXquySPiQmq2QTIRV5m7zBW9zW5SvR+mxlXditrhLKjHv5WOc9LfwYxmUfKJCNyP7RDgb/tBW@vger.kernel.org, AJvYcCX+jNmACCcK/lCgLJkoG9EpyKFZYB1DOBCYSLBxfzcKxigDVe3LfBJnW1iDJyir1PpwypJNEUOSwvJIbRFb@vger.kernel.org
X-Gm-Message-State: AOJu0Yxykq75xx1jAWYZyEM3yjB5I5E/IVdxz/g9Eu+LT5ri+372h6uy
	e2jZ1ReU/qyRaqyILfg/WBwxHo0HXBXbV+U3OhJoKOSLE1Gx72wA
X-Google-Smtp-Source: AGHT+IEEF7awH1j3gIQP6Vh7oLgFCgOqchJ3nrz9vB5cEhtAQsmv4zWgpb+KY2pKqSZxa4ZXOlztGg==
X-Received: by 2002:a05:600c:4ecb:b0:42f:8287:c24d with SMTP id 5b1f17b1804b1-4318415cfccmr80191065e9.21.1729849687427;
        Fri, 25 Oct 2024 02:48:07 -0700 (PDT)
Received: from localhost.localdomain (93-34-91-161.ip49.fastwebnet.it. [93.34.91.161])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4318b55f50csm42785605e9.17.2024.10.25.02.48.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2024 02:48:07 -0700 (PDT)
From: Christian Marangi <ansuelsmth@gmail.com>
To: Christian Marangi <ansuelsmth@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	upstream@airoha.com
Subject: [PATCH v4 2/3] dt-bindings: crypto: Add Inside Secure SafeXcel EIP-93 crypto engine
Date: Fri, 25 Oct 2024 11:47:23 +0200
Message-ID: <20241025094734.1614-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241025094734.1614-1-ansuelsmth@gmail.com>
References: <20241025094734.1614-1-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add bindings for the Inside Secure SafeXcel EIP-93 crypto engine.

The IP is present on Airoha SoC and on various Mediatek devices and
other SoC under different names like mtk-eip93 or PKTE.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
Changes v4:
- Out of RFC
Changes v3:
- Add SoC compatible with generic one
Changes v2:
- Change to better compatible
- Add description for EIP93 models

 .../crypto/inside-secure,safexcel-eip93.yaml  | 63 +++++++++++++++++++
 1 file changed, 63 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml

diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
new file mode 100644
index 000000000000..13341710ee31
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
@@ -0,0 +1,63 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/inside-secure,safexcel-eip93.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Inside Secure SafeXcel EIP-93 cryptographic engine
+
+maintainers:
+  - Christian Marangi <ansuelsmth@gmail.com>
+
+description: |
+  The Inside Secure SafeXcel EIP-93 is a cryptographic engine IP block
+  integrated in varios devices with very different and generic name from
+  PKTE to simply vendor+EIP93. The real IP under the hood is actually
+  developed by Inside Secure and given to license to vendors.
+
+  The IP block is sold with different model based on what feature are
+  needed and are identified with the final letter. Each letter correspond
+  to a specific set of feature and multiple letter reflect the sum of the
+  feature set.
+
+  EIP-93 models:
+    - EIP-93i: (basic) DES/Triple DES, AES, PRNG, IPsec ESP, SRTP, SHA1
+    - EIP-93ie: i + SHA224/256, AES-192/256
+    - EIP-93is: i + SSL/DTLS/DTLS, MD5, ARC4
+    - EIP-93ies: i + e + s
+    - EIP-93iw: i + AES-XCB-MAC, AES-CCM
+
+properties:
+  compatible:
+    items:
+      - const: airoha,crypto-eip93
+      - enum:
+          - inside-secure,safexcel-eip93i
+          - inside-secure,safexcel-eip93ie
+          - inside-secure,safexcel-eip93is
+          - inside-secure,safexcel-eip93ies
+          - inside-secure,safexcel-eip93iw
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
+      compatible = "airoha,crypto-eip93", "inside-secure,safexcel-eip93ies";
+      reg = <0x1fb70000 0x1000>;
+
+      interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
+    };
-- 
2.45.2

