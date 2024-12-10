Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDF022E3E4;
	Tue, 10 Dec 2024 20:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733863771; cv=none; b=F1uelLtsMIQHCI95sFEMXn/WDnhg9Xt/E0sTJXiRI1EEYE0p8Xx0mp594IhvQNVC4mGbt8cohiExCjCtDnnmo8GwJKo+Do0iqKSM+t2rpzXWPklLqSQ7D2p0Zw08D4kqWS/mL2gt87oqlTJb+sAeX/hFiHKe6CPkwA2HR8vn4K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733863771; c=relaxed/simple;
	bh=E8cFp+bHGIU6pZjCwgdyEMfWXs0JQy/krXTTtrw2utY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzfYtsYu1i3tBMAqe2Bw0ny5LyXGx2LzgxlLI0KgSQK5f7FecN5i0vKkUVXJ5tytRlnES9TlwKgQXj4Tzs7gRf2dpv+oa7FzeXP483lQf9rR6IC3KIMBbfzOPUgr8QRFM+4I85WXJg/itQ9Fd1nRzgzj0berVEgFMol+igZFrWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=giP7YH2X; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="giP7YH2X"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-434f3d934fcso19181535e9.3;
        Tue, 10 Dec 2024 12:49:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733863765; x=1734468565; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i0cVLwNBaKmRixL4jHSZNuCFVNGOC7PS8Cjxhvb4LMQ=;
        b=giP7YH2X/wQqvWM3GbN9FhkcOg36Mxf1p9yNOlhvGFM8XjZC6TntuGde+PdDfnnDQi
         ZCEhooVyPAa5ZBSWrCbQ+2ZYTV4BCWQkg2JpZpn2KBcSvBFn5svCBTD1yOBYLr5RBQG+
         V05HglDXKoZK+Y7ibEwBSYyTxZH0guDqNRImJHRzFbtiSTc7YQzUeyb2U8viIbDv3LhC
         CseWJhD6WwEtFt9AHlKa13Aks/68Aw976jgvw63PEyR62HGcGX+thmVgUX8oWRqQnsdH
         393/lzPFyDWd5ByCbuS1iFwSs1EdIDbglWBfiCaZQnAKQyZPoXbnfFRw73uJ4PFsK3XT
         lIeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733863765; x=1734468565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i0cVLwNBaKmRixL4jHSZNuCFVNGOC7PS8Cjxhvb4LMQ=;
        b=l9WCPNiSi/FJPqE11Ry2pu3l+cofEwuWoBD96fp+8aDF99FXqns4eF0VAb/2JTA7wV
         cuDRRk0oMaVwfHnhDFFAsVrNEpdOpOnAxX9WNuHiYN7xnpBrjDc/VPgg9gUpk0YkvU8d
         7xdHhe9u8TYcg0fx2fyrPSviLSesHE22/mJwmw1QOGN8gY6Poh1rTdrgeNlW3qm7oH65
         EDYjDifWbDNEXD4caNPhS2eUeCIpDphrptnCqfUYgt5wbDb5lH64oMOtkOdH3Hkotmyq
         nD6BVT3eoOb9CJPBkrIvtmt76dO243p249G5tAgB2c5fU6dH3X1/OYf1381hdO1RNJHH
         6g/A==
X-Forwarded-Encrypted: i=1; AJvYcCUEwFcr9Dvl5PHZja6uHSB5a03uuC+NK2jmgSCj03a6m1kQbACom/sSDjHnWErunBuMlFVT5fx8bBD6pGlD@vger.kernel.org, AJvYcCVzrzzXkiT9D0WKC6fH71MXtUj4cBPkAMJOSySxoFDe5UfKjvAOundPuE8ssrcj0AAojvYn4aJpoKb3kLQZ@vger.kernel.org, AJvYcCXonsLTMxRcBI19FmI4Sgbjf7u06Lf/7v8OeBRly5LZoTesyh0g1F++09uQ+sulptc686wHLtzv22HM@vger.kernel.org
X-Gm-Message-State: AOJu0YxMqIuI31kCmnGW+NKAF7jTt9q047M6QcdSdSXLqg4kKkHkSmN5
	8pH50bfB0/hv47tNBQK2Z6krLLMYB72w2hmAeQDCWrliOhu396uy
X-Gm-Gg: ASbGncsfpBELKuz+EmR9ouOn6we+wUceAIF0DQk9dou+1L7BhxsIA9Q+c9gWuVpxA9q
	UhTsX4cgvvP7y8RPXMEpj4w23AD9H0Dwb/ERgI6JTtB3e/SqbpdIn8VHAmIyGbLOFM9wd787uEm
	JezIYod/9O9kTsLtJLauYG1GST1kIPZHYFGh4GgZ30x0sgwkGbU9xvrpfMQx0F0SU44E1WXWBrh
	uqh7Tpe6g2iRr48Mw7IjWQ1Yov9+6Ng25LTEhEKku0kq1kdSLLAq/WUuP2+JcIXkM6X8uuRxqT/
	53is95B53IDnsPd6b9Sbs4c=
X-Google-Smtp-Source: AGHT+IGvv4Ly2KPrbRRZpRumd0qbQ2u8GLsDvhDkpsORNeY/yaMp4Cm5evTgLhjTFRv5XUrVeAKi4g==
X-Received: by 2002:a05:6000:1788:b0:385:f3fb:46aa with SMTP id ffacd0b85a97d-3864ce98548mr397640f8f.43.1733863765391;
        Tue, 10 Dec 2024 12:49:25 -0800 (PST)
Received: from localhost.localdomain (93-34-91-161.ip49.fastwebnet.it. [93.34.91.161])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-386334d0486sm11808307f8f.50.2024.12.10.12.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 12:49:24 -0800 (PST)
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
Subject: [PATCH v8 2/3] dt-bindings: crypto: Add Inside Secure SafeXcel EIP-93 crypto engine
Date: Tue, 10 Dec 2024 21:48:32 +0100
Message-ID: <20241210204853.18765-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241210204853.18765-1-ansuelsmth@gmail.com>
References: <20241210204853.18765-1-ansuelsmth@gmail.com>
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
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
---
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

