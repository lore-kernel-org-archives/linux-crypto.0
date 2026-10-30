Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793381168;
	b=ePiKXqKxbLvKqgQaZ1IzzZYtDhSDQ5WUriUvHHXG0hJKpsjZ96FrIZLnKWBU77HucxDO
	 xbIKjAPXcMv1DIT6WB/D+/Bk6wOdYCUa0yducaI4dXh1/j2xeG9/1jJQ2OmBrCJwOX/ZS
	 3+oUnZDc2tECCTShdnhl9rUV4HS1m5CiqYzQZ/ZaemT0IGf9WOZYeSz/QAFTE+bpp4M6C
	 4NmWrTB5gHWyeWSgSIeJcEsF0u9VVd3gggkT01BaolNmNPrlRs32P01O0h8FbnbEskpGJ
	 20V4sMaP6P05eMcI9UgHUGHgKsUKcEcJICz9mxMqG6Pk9pUUlqKbSEbLFc6vysluB6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793381168;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
	b=Y62pQ8NLPNFcY9jpsZupq1idyJMku0dvp6aw35AKACkLHtstdw6OlvsmBIOO9umzFssh
	 gYvFxjqfB+EG9K+couhYDWvNpnDvuv6fO4S89q6mqepk8cImtIg/39iFuiq/kyz9zabYo
	 Qk0n7egEXvpGaiAs0E3xYpox6Qxukruxz60R6PUBFi4joCYbWrJKIcbmZbMvcAngXvgjm
	 Lkucu3i9kTN6QQM6RW7NPXUlNf9EZ6/y/I1fquc3OW6Qy3sJF/e4CKj5NUd72skJhspAQ
	 Fmk2aolPha3gSut4SFvgQ+caKd5RNeOdHwXtfeC5hq2CZYTZGgDahk7C9/GgIPFzgEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=vayavyalabs.com;
	spf=pass smtp.mailfrom=vayavyalabs.com;
	dkim=pass header.d=vayavyalabs.com header.i=@vayavyalabs.com header.a=rsa-sha256 header.s=google header.b=RDrve0kD;
	arc=none smtp.remote-ip=74.125.82.175
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64244606A321
	for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2026 17:26:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64244606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.a=rsa-sha256 header.s=google header.b=RDrve0kD
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-353804b591eso1530451eec.0
        for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2026 10:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1793381167; x=1793985967; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
        b=RDrve0kDSFOB88oNjlZWHltoE1NtVglhxEUK1bTd05cIdtrx0kOExT68SonxAm1dHd
         /Zywur+Zp1oyY6nNdKGag2Ddui4xQroPQ16FOYSDb+0szg502CCa2vyaC/Je0dgYBZs4
         NYRuCEKftml3xiOArK1TNpYHfWSOJVb8HAlm4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793381167; x=1793985967;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
        b=Pu4Yav1fXHuq0RH3K8uvGDcRMFnezkifuRO8BgzsCU7fL8ySXH8RVp9Z6JcRTS0sxf
         q/NhMEfjg7s9bXxeu2Aklc7/35OgSfGOHLMAprUTjf9wv0malI7gEcgFYPYTfMGvVcF9
         JogyyM8rilWgbxWRdvDf8CPKaaG1JdkJldHxE3xfoxDa1n93gD0Cl1Q00KVO/MofFg8I
         AlW9UmhmrEZm8vYR2D05VC8u8LOP7DgTAwTE5cdWhJy886tFxNQwD4kFzxarFPQfW0J/
         Pl6aS1YEkOqzuVSJP8pdci5hR4fcFxYPMzmZ7tgR952P8SfYFHpRLetD7UYoe44HCC1i
         MfZw==
X-Gm-Message-State: AFq9FYLHQUf/VUctPSpWtkm6gmAGlLloKmcEvTWJoxgE28vwqL2vW3kj
	UfQKtCSrFVS+ptykECkCzyQNefwbk1ECoD266X2o4ySUFkawdl8r/MohwxV4OJdTU0whUOCGzJo
	sq7Mv
X-Gm-Gg: AYBFou306Z387zirXsVve9s6QR3liy7Ef2YoyYD8h5/TzlcxVJa3d4J1fi5Hxa2Ed0M
	IhbBqaXF7g6V4YtjpxDP4/6g6NvKz4rVzGVlnypWg7J078H+ZFw3v7W2YGldisRVSDuBKkzgdx8
	eNRAZ+/g2LwkHr3ovzqhYw+nl8QivH1Bnz9kgLWvE20f8zNkOgMh9Lk26fJqRBi2nYvBNs0IwZi
	r6AGKYHjJ+bzCFgZaOHxet6mGvh7O7Mmzk6EWPifS3BFooikzJ1D652JwHc2ffn3+CIMNLRtvui
	DMzz9ZUESWCqrSvKilu0QeMPFUbdT7Be+McE1i+Nu7RZy2pVg3vfW31jHKWkGidlRRbqLHIqGVI
	9C0yPsDJz1KcMtVcATnu5eMhNJ6fvfug30V/BLpWtVNMqDrLNrnUPko9+mNBfi+osDrqcbkiQGK
	EBJMGYQmuOTFdi7OajpJqDvFCAylO6A1FOYpUZL4BOwbfdbI138ZX4hK1BjX9AUF45z6wDYcupA
	yu3cVmRaIRlbJ+pWuq85umRzSH4A65be1LeE8skcXRAoiB3x86bsl+M8NrC5sG9H694Xo9gxzqV
	UpwSAeEFw3DotRtqQRcz/b8zy/UOPnMvAyH/eYk3HyF1DpUjjFWvRAmB3TooA0oIMoUb98ageWk
	BZrPgdy4l9B7wlyD4vMs4eycwF8V+7/mTmBX3MFFCyt9XeKyM0DL5itLvDg+GGY6BA+Ga
X-Received: by 2002:a05:7300:3aaa:b0:369:21a:dce0 with SMTP id 5a478bee46e88-36a42345883mr4194608eec.6.1793381167415;
        Fri, 30 Oct 2026 10:26:07 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428ecb61sm7641152eec.10.2026.10.30.10.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 10:26:06 -0700 (PDT)
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
Subject: [PATCH v27 1/4] dt-bindings: crypto: Document support for SPAcc
Date: Fri, 30 Oct 2026 22:54:53 +0530
Message-Id: <20261030172456.274744-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261030172456.274744-1-pavitrakumarm@vayavyalabs.com>
References: <20261030172456.274744-1-pavitrakumarm@vayavyalabs.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
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

