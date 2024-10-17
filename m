Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5ABF9CF;
	Thu, 17 Oct 2024 00:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729125857; cv=none; b=axl0AHJRfF49o9t1niSIaK7Q16+mM4y3bVA9xdNBcnw/kZpXovoEQ1HG+HvW48uPK7qM/D/qfJiZlZ6nAG2qovJ3BXDes7rbi2uQX11WkWZmnHUQIT8OfFrUkjfKZX7re5J677arp2YK0GLX1yK5USx1Kj55UyKwvozAyFgRjpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729125857; c=relaxed/simple;
	bh=5HNqVM9qnwTdnf8LZSPKP7FfFdNjkMimx3U6CkrHAmQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gDfiIqszaucmjPCUMesJXIX8Yoo8ZfquYjcep9yC3I4DhYRujDqEEpy/SNOLDo2aAwAMWNkAO/PAwQ3GVBrPUiiwEwCaG5bsaIlFqdL3mSlc6+V9C6qPLRRJldi5COWcbzIgtlMXFSEx/F/fGK44zRq01yFGEmeDheP+b915sI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C4vHqeZ2; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C4vHqeZ2"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-37d3ecad390so1059189f8f.1;
        Wed, 16 Oct 2024 17:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729125852; x=1729730652; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fkq+TGdoIaQ2uoCJZ0FHsGrUlBifo9ioHOm0Z8b6yCk=;
        b=C4vHqeZ2XsxByb80BK86psf/K172QlvlMl7NezHtFOMZwAiDbcKWSHtifckbJ+yEBL
         yOrKLiROIefUwKHf/f68qfY4XqGjg+MLviUXehgID8H6R7xUy1Rz0+1nmXihggcbLmjV
         ErlM7QkzujqvHrEFwXE/zzDf4z3qH5ccNwRS8N4XISW5tTD0ibR1zCsOFQNdFjL5gRWW
         6JSioCvf5foz4QASNeHbCWmAFmOm4Tryz29/4OeSbMTm84nTlbME2WyObIKQzKkKDiXm
         qfx1g1UfjT40iZoeazt+/ywFMlpnmi2730iPw1uuVwrmgcxurKtM7/WLJv7awyS3A5SC
         OgVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729125852; x=1729730652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fkq+TGdoIaQ2uoCJZ0FHsGrUlBifo9ioHOm0Z8b6yCk=;
        b=fyFyUDpx/WNgen9FmXE9yqs3FzFo8l0G2d25A3M5WoLpXAxxys2QGVc4eXjT+zAjij
         I8xhTjivzEGsdCRiMlJj1GeODNZu67RQz+37BHEyPNxOLb9jyj3XE/3CdDO0MoERifXR
         xuStzKbGtOpHGcf/i+tamT+y02OGZMV5UT0jKc5WBaq9ra89TquY2LMEczKCTcKXVXX8
         nvrn4hBKfUhqqmdrsThRB9Uqlk08mkfSeXpdEuL0IVNNYQ55iHYmD5Iq4o10isLVso49
         tYiwIL7+0ZPehV/BC37jYgsx+LMggoBdetCikxcw9BwZXO1vU4pWdPz/l0/2Rt504Q4E
         oZhw==
X-Forwarded-Encrypted: i=1; AJvYcCUiWXpRXsqkOu3xh52vNH3SG9cY2GsWFJ+xoCMQ0sHLBUc7kXCp0/uDUVqScHcYKQIYX8Je2rPoC3DdMY5a@vger.kernel.org, AJvYcCWLb27E7//phqg/SBX6FSviVbyvzCUYB4Yutr4dD/zMSoFbgILIHgInVllaWtaCeq9W5cHFbihYgRWp1nGQ@vger.kernel.org, AJvYcCXG2wbhMUzB0GdY7UDa2YFYG+djT0lCKzIzkyeIzXCEILC5LMJIjPNEosAnhsZM7wqmhro659hQFlay@vger.kernel.org
X-Gm-Message-State: AOJu0YzTdn5EPcoKKLqqpGEB8P2SwBwRJCVIQ2PlkCFDtcxXLc7ewDAB
	gFW2uwMUuR+2SaXTvj2EBOU2JLs/wn6FyeRNdKtFtc2dz37vNFTS
X-Google-Smtp-Source: AGHT+IGHKO8zyKuMJPYXPQOjQsojfPvCA+LIjF3Mqgz66g1Cq2yPn0GGMksORodEQ9ulztiCQoug/g==
X-Received: by 2002:adf:fa87:0:b0:37c:c4c0:4545 with SMTP id ffacd0b85a97d-37d93df72e3mr715226f8f.10.1729125852174;
        Wed, 16 Oct 2024 17:44:12 -0700 (PDT)
Received: from localhost.localdomain (93-34-90-105.ip49.fastwebnet.it. [93.34.90.105])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-37d7fa7a1a3sm5617172f8f.12.2024.10.16.17.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2024 17:44:11 -0700 (PDT)
From: Christian Marangi <ansuelsmth@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
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
	Christian Marangi <ansuelsmth@gmail.com>,
	Richard van Schagen <vschagen@icloud.com>,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 2/3] dt-bindings: crypto: Add Inside Secure SafeXcel EIP-93 crypto engine
Date: Thu, 17 Oct 2024 02:43:18 +0200
Message-ID: <20241017004335.27471-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241017004335.27471-1-ansuelsmth@gmail.com>
References: <20241017004335.27471-1-ansuelsmth@gmail.com>
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
Changes v2:
- Change to better compatible
- Add description for EIP93 models

 .../crypto/inside-secure,safexcel-eip93.yaml  | 61 +++++++++++++++++++
 1 file changed, 61 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml

diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
new file mode 100644
index 000000000000..fc0877d93514
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
@@ -0,0 +1,61 @@
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
+    enum:
+      - inside-secure,safexcel-eip93i
+      - inside-secure,safexcel-eip93ie
+      - inside-secure,safexcel-eip93is
+      - inside-secure,safexcel-eip93ies
+      - inside-secure,safexcel-eip93iw
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
+      compatible = "inside-secure,safexcel-eip93ies";
+      reg = <0x1fb70000 0x1000>;
+
+      interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
+    };
-- 
2.45.2

