Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161D2234CF7;
	Tue, 14 Jan 2025 12:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736858521; cv=none; b=rquHcSqAymtEi4nim6g9qyZeQJvY3+jpsh+G4DaQd+cgbQLfwnc962A8Xy2CbI7nPv3cnK4BLueJ+8rzOlB/Q76hhrER35FyI0uXgIug+b9NYC9g7oVgkmgkihpvAscYPtoRQcFyc4ftL03gUF2jI6ZoYs8qHObIIrBPC0cIxAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736858521; c=relaxed/simple;
	bh=E8cFp+bHGIU6pZjCwgdyEMfWXs0JQy/krXTTtrw2utY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pV8H0QhP6XveTekn8yc6Xha/CME7is1junPpCFzDFY0LLGHXxifSn1ZmoI5ZH1BjM8lw4Lh79JvC/Acsnojes8kdN65EUZ10X6uPrNpcHR5d2smwBjVPjYIaI7zQMvLQIxPVAwxJclffsU/Gwp4FjHIPXBDE4RTzcWff1Tf57rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S32W4V4h; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S32W4V4h"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4364a37a1d7so56280165e9.3;
        Tue, 14 Jan 2025 04:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736858518; x=1737463318; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i0cVLwNBaKmRixL4jHSZNuCFVNGOC7PS8Cjxhvb4LMQ=;
        b=S32W4V4hNDyqNEKECTQVX7XRsB8inwdfmzbpQXv4NjWjRY8guebR0jukMDXmmHBxXd
         nSQrGSpLb35dOd2fVFGEGNRF6f25bOtxzaWOvammIvqhuDxd9WDb+y6O4K3Gl2s/2W/J
         Scpc1H97rAx5Opi+Fsm03ktPPMzAuCJ6JLKI/ZboZQ1mzeNofFuWjQaDRy/4XNo1ymV0
         AZr3qxQx1mTEyNnH4GXPI22XdZTO+fXQujKEGicIYtYt6Lh8V24fdrtw95y7xBAgzrJ2
         1HSCOB0PsqMXl+xHAO/fnmtfjJu+t55WXDQ0caU8Gb8QaHkRvj+HlXFE49lmVOJtz0XG
         +MHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736858518; x=1737463318;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i0cVLwNBaKmRixL4jHSZNuCFVNGOC7PS8Cjxhvb4LMQ=;
        b=NuB0zrHgEChZI9614bPWCRejMH05Pf6PgP2XGcqMk0k+8uI0h5qgah3hB7XVgbONFp
         wHRDqdcRXTHD4pqzNuq3+g0Qk2TM/XSCBHBRbG9cqpKqtMZNpG6qLouRR8qo5KcD1tl3
         yuWB9Tic8hpOBRySgMKTLG3SMyzS/vxP9SZXbT27uKbYViFSfXW8SD485eyJVfwJ5NEV
         YSstk0kZQzI9itijKvnSwFlaJylqpDNRxbJgan+mHB2UeSOH5sxV+a7OfQYLjnwN8tyQ
         19JOk48AsVQ8usvltqyJr2bvZ1lMvTsfR8ZzzTurPTQaMqXPOSVpdtFDdeTx8bfWd8Zv
         ZqrA==
X-Forwarded-Encrypted: i=1; AJvYcCU/+ACa0ycC7IUhraSGIyStQDTNQjOYlL0en401/ECXcU3PksDBWy6xHo8r+BdHhk9vfSFyWRXc49p5hx/f@vger.kernel.org, AJvYcCXSZBnphbZZErGfjnXfa2L407c3Db6iezVMsLfJv6MfK4oaErH7Fwk3t9jlZv1+iIJcXn2lbiy7fpSY@vger.kernel.org, AJvYcCXy4XNrANifCTmlYDXKmmVtwq6GTQG+QtPmjYzddWBnJ5tqUXzWTGpoE8CXmHGK/+Aql/UXAuaHr0zcqY3i@vger.kernel.org
X-Gm-Message-State: AOJu0YwWpWd3N3E7gHGEp4xm60yzJIzdq8rxlE8h36SELndhOjLoc6Re
	7brq9KcoUTJCvv6vK61coy8EMrrvj/rvnHy0K6nGZBr4TSzO5iYi
X-Gm-Gg: ASbGncsm1qlKj+36cg3pfMIG5xAj1wEsi5204/zUThixg2vG/Ssgitd9dtJQ9766qDY
	s5IOpGiNDd21OyKaw/Ve0Gl/pqY6IQf56kjb6Vq+1A2dW/vrMd8vzlLh1n8X7z8xGX+pbEZD9zx
	zIhnlpiLk8y29C//1/7bPH8hwqUxrDfreZRNO7+DLOQwUZYOiaJ7hbWbgl4Ij6tjwGB6nl23pBc
	yVGVvV0XNJF7Ec9nMGXMInOSpD5nt67jdwn8z94Nrdi8XvfZ/2yb0k8qDVaE6WeF55NpH1/xgkz
	2bmsSUPMzAYClp1FZCto+oCWjQ==
X-Google-Smtp-Source: AGHT+IHXY4XWbdnBWLd1KAqb2AihBKBzZE+gV9tUIoHxG09rz5ryWx1Q+/tx1cKZFhVbaysHV1GqXw==
X-Received: by 2002:adf:a312:0:b0:38a:88bc:bae4 with SMTP id ffacd0b85a97d-38a88bcbb29mr14866716f8f.18.1736858518309;
        Tue, 14 Jan 2025 04:41:58 -0800 (PST)
Received: from localhost.localdomain (93-34-91-161.ip49.fastwebnet.it. [93.34.91.161])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-38a8e38c6a2sm14798771f8f.54.2025.01.14.04.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 04:41:57 -0800 (PST)
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
Subject: [PATCH v11 2/3] dt-bindings: crypto: Add Inside Secure SafeXcel EIP-93 crypto engine
Date: Tue, 14 Jan 2025 13:36:35 +0100
Message-ID: <20250114123935.18346-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250114123935.18346-1-ansuelsmth@gmail.com>
References: <20250114123935.18346-1-ansuelsmth@gmail.com>
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

