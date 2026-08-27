Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74F2538DC7C
	for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 04:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787805870; cv=none; b=paHuOmTPM24kWDdgBheSHCBnss4sdkxZe3aOrMKSLA9N8yecc0F7B+po0KMIgEoIpL80OVy4daVqdGoub/Z+T5gvqwygS0nKtVP8oamwSdQ1ISSHVlZQm8ydV9yb9JlXYTsftQAhy2Pk/mkdFukK2m/LAJzoUSAbf/bUFIYtRko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787805870; c=relaxed/simple;
	bh=HugAla5NxeGvUAW6ybPWIq/99Qvbl3GRpGgOPmECK8Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aGPlr5W9/qy5cfaOu4U8Zo6CT8oj9zuSuRfTTsdsrcuoM0hpWHym0Z5Ich2zF2jQI3PidVO8/TcP0NkNh/qjyYLl51/IgvpqqFrixX1+wDbEdhE0FbeCu2c6Iwq6ix/mLrvQ8jjx4AH66YOxmDzeJZqk5lbNzWfI4Q3FAHgJPu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=KHmq8oSB; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="KHmq8oSB"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ceaf8a1265so4863825ad.2
        for <linux-crypto@vger.kernel.org>; Wed, 26 Aug 2026 21:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1787805869; x=1788410669; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
        b=KHmq8oSBZu4Vouk4iWHX+Wm1bsXg/9zJQfKaz90DifWgnAGLVvHs+dsrA/Bfqj+wqi
         rk7eMXzTlPlj79RykWUWnquagVHzvLpdIepOOSLKMinctbFIadxsOwLfi5ILMLNiyN7/
         AkBsQQVVeMHcw4WcVLXn+It4d2BZIE2ZyJgJ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787805869; x=1788410669;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
        b=lzP/XBZTGvqgkou3wcy+kVmB/44tWQ641lmRN6sBtXP2cs3e2btKQxBZyzro6ovr4I
         rw35vhF07zWD8oyslUd0TXlEAQUT3BNfbM7cN+mkSDuF37ImHT56CzlLPaQDEO/EKErl
         tDOM2vtwOgBeT8kLWmLx7qddg1bxD95c2Pb0Zn5bEkne5gJ47mZGUayIo+VxOzvJ9t9S
         1jHKmpjMdFSgTL9BRZMyUOm9p8H6FZbzCMfgh24d3lGiow2YpNE5U2B8vO7SVITC6GU3
         SRlb5WrAWW/tDu7Ye96SpzIc4n0R+f7WwomLRL5kxLpqoi+/uOgxI5NV63gDovwXrsXz
         xOmQ==
X-Gm-Message-State: AFuF++m3Kl5IGZ7pXvGBPk6DRk30aDSC4u0wouNjsoXnZXacdaaPUtqy
	v0OMEuUmhe3BbcSEWelJq8/5THUdrFVAHjbdUvIxzfd4Nq6FxmUy7kW2B5RSDVlmpiMwfsBmzGZ
	yu2aP
X-Gm-Gg: AR+sD11WLjXMO4k7BJkxCIQhGHn6zNTxoSFFBg2o9HmZ6cIld/n10AgneRlLuYSLA4i
	17K+lt80eZgyyPlOj/15XDvrQ/Fr2Mw/AmZlwNEmueyNOvAflXPUqvbrQyaNBal4ciREsujjSeN
	X+cxj2o2Dnfrjkp2oLVeQVrRfAvMyvDauR9DiGx6mm7fxLyQa2S9ZjlFEXTkpoLiLtMX6FCs221
	FXQbmkH3yaMbSuLEVttGye4H68m4chDYXx1jXV1KURvQjg+y0gdfuu2WnvZUyM5nVOtsJo6JaDu
	WgrLE43WBYyc3L5NhnbHzkrdmb8YHJLtlIPXsJIzeKh8ddCaFJ//StfG7yhvFHfccKOLCMa+hRM
	PhlHllQn28bZwxcfk0SsgD8F0qAb/XAe0lNYrF4nr12jO8yTL/sK5MXdwKOIzlgnqe9Gs/cRrFX
	d358k/xIACpqyyGOrsFuS42e0kLQfsP7AQAsj7LimE/kh5jvdbgHB++9sZfCDqzpdk/7TcbgBKi
	XzWgFndyiGrmydGr20AeNEkTDR48ICThiBRvvIAYzdFf+jVT2VmxtbNoZ66XichUDEYMsMEhMVg
	mX2X6f5RGv32jRp+mik4MrL0bsaN
X-Received: by 2002:a17:902:fc4d:b0:2c6:9f66:d573 with SMTP id d9443c01a7336-2d7079ffd98mr242482965ad.2.1787805867775;
        Wed, 26 Aug 2026 21:44:27 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3283d63bb23sm14554224eec.7.2026.08.26.21.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 21:44:27 -0700 (PDT)
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
To: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org,
	herbert@gondor.apana.org.au,
	robh@kernel.org
Cc: krzk@kernel.org,
	conor+dt@kernel.org,
	ruud.derwig@gf.com,
	rbannerm@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	adityak@vayavyalabs.com,
	navami.telsang@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	nazim.khan@vayavyalabs.com,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v23 1/4] dt-bindings: crypto: Document support for SPAcc
Date: Thu, 27 Aug 2026 10:13:46 +0530
Message-Id: <20260827044349.826534-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260827044349.826534-1-pavitrakumarm@vayavyalabs.com>
References: <20260827044349.826534-1-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add DT bindings related to the SPAcc driver for Documentation.
DWC Synopsys Security Protocol Accelerator(SPAcc) Hardware Crypto
Engine is a crypto IP designed by Synopsys.

Co-developed-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
Signed-off-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
Acked-by: Ross Bannerman <rbannerm@synopsys.com>
Signed-off-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
---
 .../bindings/crypto/snps,dwc-spacc.yaml       | 50 +++++++++++++++++++
 1 file changed, 50 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml

diff --git a/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
new file mode 100644
index 0000000000000..a337f7b473cc7
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/snps,dwc-spacc.yaml
@@ -0,0 +1,50 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/snps,dwc-spacc.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Synopsys DesignWare Security Protocol Accelerator (SPAcc) Crypto Engine
+
+maintainers:
+  - Ross Bannerman <rbannerm@synopsys.com>
+
+description: |
+  The Synopsys DWC Security Protocol Accelerator (SPAcc) is a
+  semiconductor IP designed to accelerate cryptographic operations,
+  such as encryption, decryption, and hashing.
+
+  In this configuration, the SPAcc IP is instantiated within the Synopsys
+  NSIMOSCI virtual SoC platform, a SystemC simulation environment used for
+  software development and testing. The device is accessed as a memory-mapped
+  peripheral and generates interrupts to the ARC interrupt controller.
+
+properties:
+  compatible:
+    items:
+      - const: snps,nsimosci-hs-spacc
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
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
+    crypto@40000000 {
+        compatible = "snps,nsimosci-hs-spacc";
+        reg = <0x40000000 0x40000>;
+        interrupts = <28>;
+        clocks = <&clock>;
+    };
--
2.25.1

