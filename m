Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25249205125;
	Tue, 12 Nov 2024 01:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731376800; cv=none; b=DYPAmun9+Cefm+PIRuxWAeZ7Klw+bQpcxxy84Vrd7JNi12JB094MC2CrhxOKdHUtDRahjZ0axHNWlZMFZiUEybUCA+xpgKZ6t8qVcFYoT4O9hW6zujsz+ads8g7jAaKfWjF72hA4cNXnGrdixQrl6NIyU4KELp7CHI0PrUJs3+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731376800; c=relaxed/simple;
	bh=E8cFp+bHGIU6pZjCwgdyEMfWXs0JQy/krXTTtrw2utY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E9XpaRbHGYY2PWefrdVvnbVdvAJr/5TW1KAISmgHU5zdg1rYkDZKNzHVMuU4I/YI7eiN8QvIuG14t5VKxxLwED14mYpk0CXC+ke6IiIqup8nnxlT2XgBHjfPUB4ku7wu2T0TfMpK/Dd85S9tNqjYWXxtx5dsZYTNQ6cKJLIShTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U1esnq2v; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U1esnq2v"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4315baec69eso45106595e9.2;
        Mon, 11 Nov 2024 17:59:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731376796; x=1731981596; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i0cVLwNBaKmRixL4jHSZNuCFVNGOC7PS8Cjxhvb4LMQ=;
        b=U1esnq2vquryABCpoAtoC3oMU2KhMiH+HD+KA6oqo+t5GEtZO57GPsHQZdPhGTcIkX
         stUP8UClzqaM8nREWGPAOB5mTsctYOFKd/v/GHfuyp5CaZA1185iMBB5u6biJSgLNGdN
         H+sP0s1x0i2G9BGJCuYK+fnz86MjRbMIlZIdThUJqtXAuqZP/uZ3x398BeyFHKLid975
         DCqJuhhCrfPGor78H8b2Yd3rm+3ic0Ns/QYadoyBsLZn4j3vKbiAkhCc/PmoQAUnsPV9
         Bkl5EB+LVHwsd8VFG01wOdCe9EC7lAy4Z6hP9QdPOekAb7Qp6xrXaDOE7xyZmgswpHlZ
         q6pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731376796; x=1731981596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i0cVLwNBaKmRixL4jHSZNuCFVNGOC7PS8Cjxhvb4LMQ=;
        b=ro5WK5Ve0fv9boIWWs4VpRlYEjNBLSj/O364owtaRnouBXsDCWuB4A64Mq3x1geiSf
         ykFrWU2cUvUo7uZ4fS9vkAFTecoXCsyaPLGKQUMrPxS+Cg063duUfZnmxh6tg/eJux0p
         FLu0WBNF2eZOa3M5sbxclHYeYyij+pM6FhoZzgWMbNJNAGIZSD87DYHIPG8cFUrRR/QO
         Am4yXqqCr/W7Aj2ojzNXwHetxm+8KTRGYjkm0ek3aD2/WW4WgiHBB1ognq3sFw5I49gl
         stHeMSbpFyCASNsDKOPErNgeGs7rL1ABmQUqMfn+fQ5DkfRHtu8KY6Nnn11Au5ulXUJ4
         W/kA==
X-Forwarded-Encrypted: i=1; AJvYcCVme3ftTp3TUu++zxdeVKkH5QFYNCwOfk6JdnxQ+p7RqfEROMODm9b/bMFhSJyKZduy2q2AToZyUtVl@vger.kernel.org, AJvYcCWEouSSF+fpQstdykdCBIME2umSmKqs6pCfJ9pO9kzWJ+JKZa3ut0m0M3x838tNW7UXioraoyPccF0JXgq8@vger.kernel.org, AJvYcCXOjnVkFC7G0vMhOSu1eWKbggD3PCsNNo8DMC5lLj98OvYOPlx9e8PvU4SCPL+cQg+qx0QyJdRqJKh9bZ0m@vger.kernel.org
X-Gm-Message-State: AOJu0YxB6XJ2I+HbR4108sINQ2RuuP7SgQzR3J+mADUOIgq69NKC6+J0
	GBgQ2z5iYxIErCfLjAQpayZvzVfuUcqTnoeEQrp1iXc4WMphAw2E
X-Google-Smtp-Source: AGHT+IHh+FojbNL2CdYQ38Ct2xsICb+etljbviKPkFa4AcNmatN3JseunhpjYhhowURZPL1cELfe+Q==
X-Received: by 2002:a05:600c:1c8a:b0:431:5ba1:a529 with SMTP id 5b1f17b1804b1-432b7503557mr126159325e9.14.1731376796429;
        Mon, 11 Nov 2024 17:59:56 -0800 (PST)
Received: from localhost.localdomain (93-34-91-161.ip49.fastwebnet.it. [93.34.91.161])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-432cf2b9fb9sm1783295e9.1.2024.11.11.17.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 17:59:56 -0800 (PST)
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
Subject: [PATCH v7 2/3] dt-bindings: crypto: Add Inside Secure SafeXcel EIP-93 crypto engine
Date: Tue, 12 Nov 2024 02:58:59 +0100
Message-ID: <20241112015920.22564-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241112015920.22564-1-ansuelsmth@gmail.com>
References: <20241112015920.22564-1-ansuelsmth@gmail.com>
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

