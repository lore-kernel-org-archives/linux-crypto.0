Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE5A1AAE33;
	Sat,  2 Nov 2024 17:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730569884; cv=none; b=LXEtDnn1M78uYD4lWhVAleYzf+GWRuiumVVVFUNXLv4b2KxxyN00XMfi9fGZyyNSm2/pesANi6/+PFAVQgOCDoeWQdmk/GZn/Pj5IGVYSGyRYF1L6lZuOUsxryiyttTKoYegFcZKZwR7edAxjwE1h5QU9SXtYoqa6/YXhoqDZWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730569884; c=relaxed/simple;
	bh=yEI+hQHiZQY7ehD56rzBwPffwdH92W/UhMThLRYgnhc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RnykRkeH4q+s4C5kHqt8jz9Z6w5Cn3sbhQKLdTrgJff1Jni5pm2qq7Gp1jWZpqtgfhKcKKk9y6vEHkLvPgzF2ZGzknK8G9VfZ9WSFq8jVKi9q57h921Z1tCkHiIeD3OZwOKrgocHYrHLMUqH+YMGQk4YYWgb1H+iYUiDwZpUthE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j2dx5sXJ; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j2dx5sXJ"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-37d6ff1cbe1so2059243f8f.3;
        Sat, 02 Nov 2024 10:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730569879; x=1731174679; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q7A9KiIj5azyBmcBDWj3pk1ALcLPY6NaAlc3dg84Ruc=;
        b=j2dx5sXJnN7UG+cYn7whyACK4J+u0rfZi2Rnmh4zgPq47/7y/kBWP0IG6UE+ChgZXk
         gJX3g9crsMdi5+H8WGcCPlDYnLn3aIi3oiksVKRGaB8sfxUgQ3/y6xd7VrMBx+wIGNGZ
         RyGRoyPjS8cTjokBYTkN+eMGnoWNX1ngHKZDokEOGg85zNGtGScG0r7zmhE6TztCFAwk
         D5EDpHErhpmMHh7F+H71BW5rd+QBmc7t/rz8rdOuFolQhnePEJEYvNEhLh9Zg/bOSxAr
         59E9r/GseeFG/6OGUXSHCQB8m9Ky3s40EByOCiFu3rBIe6mAAPlTSLq7ZJnhnPf59v0F
         a17g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730569879; x=1731174679;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q7A9KiIj5azyBmcBDWj3pk1ALcLPY6NaAlc3dg84Ruc=;
        b=ODJZOpKLD/TsF5F8qWWuTWRuaO6GeGjSq3J1V37s0eBXR5rhqVbQazA0Pq4jQEORoV
         BmaPlxB1IpwGNSnk0yPmIxhGDh3x75PEjueKMFXfn3sS85DsFGeaHEVLQyX9gWH5iJIg
         Xy79v7FwlmE9CU1NSOYBC8Srv/Se2cmQhTbCgfP1SBvTSGwtPgix6+KTbNbVwU2dpCKq
         BohA4lmmbLThQiQcII3/v+YMUSIAHL6+k9it5qP6+Y3bZSswJ5FgjdXVe6u2SNrEfmyC
         LbqXTJZ5VPiREP/HdZ01r7wHiJQILJL+54cSqRFTjXTDo7Czjpw8CJmJnmAmCzQXb79G
         E5lA==
X-Forwarded-Encrypted: i=1; AJvYcCUJ2wUURbqzkLmXUiszX3ZiUebROu5JxtTpJa10Vh2BS9la0zf6vWL1REO7g5XtKGM/Z/TvbfDPvRqQmRlB@vger.kernel.org, AJvYcCUMY3sJPiNe3reutUeVfirsFoC1qm1RTOZg8tnNX5MXyt23WEyQiN5c0W67jMGqZmn0qgO8ogPhrwH+Wj8a@vger.kernel.org, AJvYcCVSGpQPbofOB37H1lC/TNWICO79cxs8D33xHxnZcfQQB77GNeEbTwl54EtAFDT3CYbHuCzDm/ngp9Z6@vger.kernel.org
X-Gm-Message-State: AOJu0YytphyZNsYAyrWqk5uGtgwkosCUlASthqVTZfHagyNYiDo+D2jd
	jh1eo9N34r1O8ideVqG71PZn1/vaElhhuCWF+bQe5ceJ2GtfhWnC
X-Google-Smtp-Source: AGHT+IG/88Fs6owiWfglDv/qT3GWO4sjkF23tstNx+tGKllkCTOcMQ1YtJoOpjeW19r68AgBat9Ecw==
X-Received: by 2002:a05:6000:710:b0:37d:4821:fa0 with SMTP id ffacd0b85a97d-381bea26456mr8048925f8f.48.1730569878636;
        Sat, 02 Nov 2024 10:51:18 -0700 (PDT)
Received: from localhost.localdomain (93-34-91-161.ip49.fastwebnet.it. [93.34.91.161])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-431bd9aa611sm131471715e9.34.2024.11.02.10.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Nov 2024 10:51:18 -0700 (PDT)
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
Subject: [PATCH v6 2/3] dt-bindings: crypto: Add Inside Secure SafeXcel EIP-93 crypto engine
Date: Sat,  2 Nov 2024 18:50:34 +0100
Message-ID: <20241102175045.10408-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241102175045.10408-1-ansuelsmth@gmail.com>
References: <20241102175045.10408-1-ansuelsmth@gmail.com>
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

All the compatible that currently doesn't have any user are defined but
rejected waiting for an actual device that makes use of them.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
Changes v6:
- Add SoC specific compatible
- Add now supported entry for compatible with no user
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
index 000000000000..997bf9717f9e
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
+          - const: airoha,en7581-eip93
+          - const: inside-secure,safexcel-eip93ies
+      - items:
+          - not: {}
+            description: Need a SoC specific compatible
+          - enum:
+              - inside-secure,safexcel-eip93i
+              - inside-secure,safexcel-eip93ie
+              - inside-secure,safexcel-eip93is
+              - inside-secure,safexcel-eip93iw
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
+      compatible = "airoha,en7581-eip93", "inside-secure,safexcel-eip93ies";
+      reg = <0x1fb70000 0x1000>;
+
+      interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
+    };
-- 
2.45.2

