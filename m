Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A6B1DA313;
	Mon, 28 Oct 2024 12:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730119363; cv=none; b=Fy/P5/G6QI0QczFyUk7wz2l3tb1Rm2QhyksABLrFefScyR7rtAqz2ZyfEXueR+S8pZLluNcc4XY0pToU0PmdwZoY8irVy3ujUZra0ar9pyv1fxIDQTkReCn/Yf6KOvyKvKi92W595LtAGjFLLIQVmBlDmWf+0YCxxRlTbP5G4Ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730119363; c=relaxed/simple;
	bh=GeRI8BP/aA44kWX9PQ2iDTyA0xCW/Q++SRP2iIdQ3w4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2a32r/wGhoWKFvAb8OpzJZDTJ/BVlrlEcmAP1dgIRI/nKEv4kLwGl9OP7IGjqaRDK2SScLOyiCaVLQgMofylIfWM+eFqzNw53GlERw0TD6rijmeJOwAqu61PFm9nYdEXwHk/kPeZWbCYpMIxIIhM+08IIMzUQzI1oLV4OFTFwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YOubV7eB; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YOubV7eB"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-37d41894a32so3238098f8f.1;
        Mon, 28 Oct 2024 05:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730119359; x=1730724159; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wPqZCELaBqJktZQkb9UmK7uYBGIMFPnXLMqvprQAW/0=;
        b=YOubV7eB1U7Xk8e043wE8SzxDwq0HZbJbReeAIm5HpzE1s/AHs5/nbCbwEL2pUoBJz
         wf8OBpxL1XZMhnae+JpOMjqW88slaKOnJZs0PgU4CmS/Lz3nXl3i//EnBaGGYz7430+i
         F7+iFbtnHcZtuyYT5a/PBMZnhXTsyHFMuMF8VrUg6s6xn6QD+llrMBYysscU6bJkmmeO
         8DGG+tOQZU0ATiKT6ny+CI0IRHwjBn0UR9rirXVIiiEl1Tl/lwfA3S21yMR+3H1DZv6K
         jgrY3+zAt8QZ5dDQT0wb6b4DqDm+c+uvxiyaHY05jzSzA1rmPE2j+4n/iWscjuVac3Xf
         TGZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730119359; x=1730724159;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wPqZCELaBqJktZQkb9UmK7uYBGIMFPnXLMqvprQAW/0=;
        b=UYoSCGh0Z167wFBLO/5Ok9YUJd58P5g2TB/84DzGMwi4kCU2rFAdVVjLRHD0faRxrZ
         3oEb4S8en5glWoj9EfkEERNBqMifVJ1X19ngpJHuWtWmGYvffGOFt1fLz51BmvhL0Vyg
         Iesabha6pNzaYhu91gRPUZtxuGleiBL2G2Udw+KoEtMU+Da4QMc82VCnmbFtBK/0DI6j
         n/PIqnwr6SHBx784rlNtKjxbNE1KHyGUwsgzqzuZ65Z1e28nrZDnTpiPksclusFRZGem
         ZmsuldlgMO0b2gUNEKJBNZ0hRT7/sbmh3/HfaO7tgdQaz9diNyW3B8o31Mp5U3eoWrS0
         rUqQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjKRDVHH483qkb4uEFXxLkvZ7qBrLiLUSk0g/7Y7CkQSDeRjelhN7Y9+XDlYEa8g8kO8wickexBa/y@vger.kernel.org, AJvYcCWiKEjQWuBrZIWsxAz88uiVAj6tsABqyJ0az8PIQ+GBN+BHyfeo1gw3fNRP5/amOAS/6hFX/G/F9P0Ws2hf@vger.kernel.org, AJvYcCXnwV3vrWI5wPURGJqmATV/o4QxxggUbnmRo6xB1bNTrPRU35HO0IwEuQee57dL36ZY47caECqBIkEhHv/N@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9/whC/5nFXyfz1uhAYdd5X/SakRU2Xl4vNKoqjxZj65c4tw98
	zC7zXiSkLZJ+g6p+qGVNMcp4Sz2K3+GhqbF5A5CoM55bzCzmhRsQ
X-Google-Smtp-Source: AGHT+IEx2APh5d+NgrUF/k2+1R8r86xC6OUaFya4GdmQzDVvcj6CAXvQw7NHIF8BBHby0KDz+fFvzQ==
X-Received: by 2002:a5d:4d4c:0:b0:37c:ca20:52a with SMTP id ffacd0b85a97d-38060eb2411mr6325090f8f.8.1730119359034;
        Mon, 28 Oct 2024 05:42:39 -0700 (PDT)
Received: from localhost.localdomain (93-34-91-161.ip49.fastwebnet.it. [93.34.91.161])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-38058b71231sm9352608f8f.66.2024.10.28.05.42.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 05:42:38 -0700 (PDT)
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
Subject: [PATCH v5 2/3] dt-bindings: crypto: Add Inside Secure SafeXcel EIP-93 crypto engine
Date: Mon, 28 Oct 2024 13:41:42 +0100
Message-ID: <20241028124206.24321-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241028124206.24321-1-ansuelsmth@gmail.com>
References: <20241028124206.24321-1-ansuelsmth@gmail.com>
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

All the compatible that currently doesn't have any user are left there
commented for reference.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
Changes v5:
- Comment out compatible with no current user
Changes v4:
- Out of RFC
Changes v3:
- Add SoC compatible with generic one
Changes v2:
- Change to better compatible
- Add description for EIP93 models

 .../crypto/inside-secure,safexcel-eip93.yaml  | 67 +++++++++++++++++++
 1 file changed, 67 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml

diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
new file mode 100644
index 000000000000..188240b74110
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
@@ -0,0 +1,67 @@
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
+    oneOf:
+      - items:
+          - const: airoha,crypto-eip93
+          - const: inside-secure,safexcel-eip93ies
+      # Compatible that doesn't have any current user.
+      # - items:
+      #     - const: SoC specific compatible
+      #     - enum:
+      #         - inside-secure,safexcel-eip93i
+      #         - inside-secure,safexcel-eip93ie
+      #         - inside-secure,safexcel-eip93is
+      #         - inside-secure,safexcel-eip93iw
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

