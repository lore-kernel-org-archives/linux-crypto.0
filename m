Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C6115623A;
	Sun,  5 Jan 2025 14:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736087556; cv=none; b=fVilevF/RX5Us7TPQP8BOr8ehhkjwo/4r0sZRTvRaCvzoMbNr+PXgb7B3wUwnGZjd4bzzY9MYNcVvDPMh5gSc6XLtSO0le8NH8f2P2SI7oaw2Z3zbSVl67HIy7BEzJ9XKi3rKrls6vnkzLPDqnB0NbgATfuVLM5D56HJopnk9nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736087556; c=relaxed/simple;
	bh=E8cFp+bHGIU6pZjCwgdyEMfWXs0JQy/krXTTtrw2utY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ov12PhldXL0uZPWaG6Id4XPrsBPrGZSn6n6oYAUMr8S1BfzOwzNRc94Gd37mAVHiWGoFIwlenUcT+JLpMc1wr7CedkkePSaK9ZyNf9F4jIg+pkEuOy2qIwjBWrbdvlsoq9we6Gqj+tNmyUKlhcRw9ZTDtLlsHc81kRly3+vpUo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nK2C845/; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nK2C845/"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3862b40a6e0so7461746f8f.0;
        Sun, 05 Jan 2025 06:32:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736087553; x=1736692353; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i0cVLwNBaKmRixL4jHSZNuCFVNGOC7PS8Cjxhvb4LMQ=;
        b=nK2C845/tYu/R00Scy2VtywbeNTYUNMukdFj5YRV8JcpY+2G1PctWTxH0kI83VGX+r
         GCUEMoS7zXB8uAgUIbs+pPmfUZUmnq0bKgc9yOhpvFZCeQN3swnTg5yRtgcIYoAKP5lg
         K9gg1ihjOU/EiQ3rJF5qYrcjnZneD1eCgP9cZFW9gL2WBBYsH8tNMfZ8lxDHkF9hoB4E
         N0H1o9lc6jN38Nd/5nx5F9KS9X3w4JxGVvtVhRgNaQ/0Z1HL6xZXH4SJKUDOjnOxxEJO
         tkBNPdPChH6Ym/PRM+dEcyh/M4+LJd8CFY6X0QkPqBrX5U8rEXHa6UCg/Nvl9+PuF166
         yBXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736087553; x=1736692353;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i0cVLwNBaKmRixL4jHSZNuCFVNGOC7PS8Cjxhvb4LMQ=;
        b=CI71oqmRmPpJVqBRM9d4QOGTWbTP4y1fLZejbawqV3vyBDl7Q8jcDNAg9Qq47tJdSo
         EXRbfbXWwPSKJ4jWmuSlWh+s/h1hP7Rq7I+oz4i/XzcFuig/7Nlj9+4eV3ADIJ5cyiWN
         IW3C3V4lAcnK2VXoFh6nyJBrFTWVhc4LcSFLxBPnSZd2Pgbw/274nRVkf9GB/C18X89I
         sH5M+WJP6JCAMJJCVUv6ZLaStZTUA62Ru1+qZPxdoO+dfTHtMPOUAfvhweyQF+ksUP/J
         MJNVNHHGrvD53XpIkhUvK8d/6J8gFYtOiZqynfU1ALFmvYMBBxnUxXY1HAf4joiZ1qN2
         pfLA==
X-Forwarded-Encrypted: i=1; AJvYcCVJcWHNtLDJvySCszCtF/r0LvkwCgz19maRF8jVYSjxUIjf0u1x1aE8nCQF5nL45nvMvOs54q4GCH4Oe741@vger.kernel.org, AJvYcCWvL39jsloyLL6K6sfV05ylKT+WQ0IS2pVCdtuLm3AQv2cQoKg/zB80lqt3ND4geuB+FR4pGYd7hi2gKoP5@vger.kernel.org, AJvYcCWzlODmlYY/XE7j7sTQbw1hhvR7xQ4XVdnz7KCUtCJZhH/mvOyl62ZKSgW6NtXUV44YouRZgQN6FobS@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4kMppTYlJLKkwxdYIJmUQXczYg7mB+dYDhs4FUvxULrGVihDc
	uQcXozYwQCwd06Onc6uzVA84fIo+aZKecOMyx+XmZtemsz1pqMeu
X-Gm-Gg: ASbGncuw3jTXqnI0J95mGkB/bi305kHhez5Hoeeqwqxqqozt0Nt7um6qEdBrBs7nMJA
	ge5cexGdQc1PZSvyFBk5d5aeeGPUGfUFaRo6ZOPDGfiwRw4A6V073A06yVcaZ4gDNoTSSRYiisa
	tlTOtbcpAQ4OPzvvyZcdxMQJQfKvwHaKGG8ft3gFpb58KAX4HbQTcUH7Z73CH+FHpz2FkIm7gYq
	XWLTlPWdlelFwxOfRemXXrSxmouKLqsUO2ax+P1QUnYGjsLXuj3EA+qSc2v4jv87At0RX35LZPI
	cYZK2ru3ADo6bBTiolyrJ5iCSOfYNpqAXgqfdTF9Lg==
X-Google-Smtp-Source: AGHT+IEi1hbiUsTCXiitVIj5JV3LmdqXKw58oZGeTaaLVw97oWSDiJlvd4vM+cqWXyu+F/ixG2x5jw==
X-Received: by 2002:a5d:47cf:0:b0:385:ee59:44eb with SMTP id ffacd0b85a97d-38a221fa9ffmr45282729f8f.33.1736087552909;
        Sun, 05 Jan 2025 06:32:32 -0800 (PST)
Received: from localhost.localdomain (host-95-246-253-26.retail.telecomitalia.it. [95.246.253.26])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-43656b013e1sm568189695e9.12.2025.01.05.06.32.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jan 2025 06:32:32 -0800 (PST)
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
Subject: [PATCH v10 2/3] dt-bindings: crypto: Add Inside Secure SafeXcel EIP-93 crypto engine
Date: Sun,  5 Jan 2025 15:30:47 +0100
Message-ID: <20250105143106.20989-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250105143106.20989-1-ansuelsmth@gmail.com>
References: <20250105143106.20989-1-ansuelsmth@gmail.com>
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

