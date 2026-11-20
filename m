Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795180487;
	b=E6+Lh5qH0u3UIjGIY+Jjd69Xv0o84YENW4S4JqCnFqPBhQ6Yshh0WnMCUuaeQtyHXv2K
	 N+q+eyrJgUov0fMZjmccWISSrfnoYYYnqbKJ7I5T3y3qnjR9ZF3mazOqIBQAEyxNhi0Wa
	 h3gAsc5P19lVmIQh4Tomp4bFjiA7+im26s1oAdBPLaar9H+t60lB9n79qh1u/YGos297O
	 p+QKJQbuNww8vY6nDwkB33OUH5pRX4aDFO9QIPZc2Hef6UNC9tSkC2S0x7VzrZ1mbVS9z
	 0z7DaYhBRx0/+HK03aqd+IN6vor7RGXcApSc9U+HvgPByJ5mohD10tO4qWkR7Vo10KQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795180487;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
	b=CVsCilcw9ptZS3f0x1nGDoYb96ODfENidxO+AyJ/M8pKVHc/4k8mVjQK1TM79YOTGRZy
	 01cffjuY3g/3DOad4ZxH8KmpTu2gt0lOha6mmWcVQKgcU6cj9svCmLiqZH1ihnyBg4iLv
	 KDjNV66cJmtETvTeIyNcZO+Pn4RatBy/BjBLDJq8ibfv1zs19ouNpv1CS5rIk2ZfcVN4a
	 vIiFcovtHHdmxDtHIdCqlYTl7d7DB3HXuSLPZr+EMyfaEU2sgeZuc6Y5ajaB2gAuaj30i
	 bRpqGXRiQslzzOFx63fXR+j8Vz0tXDtMCWP02dT5XhzmgH+uyjaDB2xBCw1qJ9JNS2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=vayavyalabs.com;
	spf=pass smtp.mailfrom=vayavyalabs.com;
	dkim=pass header.d=vayavyalabs.com header.i=@vayavyalabs.com header.a=rsa-sha256 header.s=google header.b=QQ6FNR7K;
	arc=none smtp.remote-ip=74.125.82.176
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E78F606A338
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 13:14:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E78F606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.a=rsa-sha256 header.s=google header.b=QQ6FNR7K
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-38190551625so1422278eec.1
        for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 05:14:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1795180486; x=1795785286; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
        b=QQ6FNR7KDX2plbGuPnWqev3VN8S8pMCEsElxebt2M0UElMBOrvh9bkeG19vovWcPQW
         kSY0d7Ry41DaizxZkLHqLB5CaplCz441PRuFw51ZEb+UcD3wfnCa35IqaRO0zgaq1EGS
         Ql8BgdZIMHvUAph9x9MeiXOpYVTccURJTzzyU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795180486; x=1795785286;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
        b=GRcCNSfTEcW2dAPIdRvvAbmCcweFVeqhLau3E5oceVyPr54lTgyIR8gbpIUBzmAagi
         35x5f7cqgNodwYERrY+N3DVsihkiIUm5FqqVWpIeeFhSCC0pRcEvFUHeyWDnL/DQZt4Q
         mPK1iNpJHlXEhH7FTeRLOYMoZvgo1WtBlRrvZYiWATejVu//dvj6TpwW7th7kRxxIxa9
         z/OgH5umXy8B3oyTizxxNulF3wSZ8xGHYKYm815tLtVoWoAVBVEtobytiSo73u+6aKN4
         RG3KHC4JLyzY+yqG03fAZoFeohTRK1QOPtwUt3WoWtevt6AuTk4LWzhS/zvGh2aC4LyW
         mKvA==
X-Gm-Message-State: APuU4Z/eXKn1ky/s5vV2fBy65GpgpUU2Co89a7Byy0IDJIk8tZ0HxtE3
	bb3+N5GtshaGZvZJk0iTkIr3Wlc4c1QX5nulm5Ds2EavM9uf8TuPbMrBiU4SMsiEM40ve+U570d
	UouI8
X-Gm-Gg: AZFdTZc31CTaq5j4QwCiiLsEs7Wpzh+Xtso1qIrYX34Vu2HTJ9iGKNOQqYBQZ2WjXoi
	vAw+hMa/YH3bnHmAQ8W0wWwDGDA0P7IJJmePO1pkkiuZYT093Nht3wVDxquvgsXzcytZza1zvu8
	EW8YhOnVpbb7BfFJIsHpI3UzJfx7SRrVulDKS8EBEvmqEFrW5E0o3ZqWPcXtvXX+QaEM2viXS4N
	Og6YOJMU1dmlOUzExOtmAnQL/atbXtHsn3bkaFmb4Zkp2p9oxmDhop9PJp6ch1B6mWcoyEC84C1
	HEya9xQsx3Q6Tv0bX5M0Xlw5XeNqzfQoZ3hvKQloXqbybZYhOBn8Ok3TRBzq/6O2RbTKWkXXBfK
	kCd2nEOxG+DicAhEX5gJSeyrwUACkt8XS5USgEsDl3K2+VfRJcJ6lnfSOFfSK9NpCal1TPgLEqW
	k28OjYSKe59H00r3it6gqHtIN71Eby8poFBIKo+oIdPdWrkW38Q/VRfIVD5hzOC6GzETd2MnZvQ
	iSooQUiRy0VY/GgtOjVRmhwejLl64+AyRB4cEbomHkytNg04kWOzZOlUEDzc8xqOa2LctAM6FE5
	hlJ7vD9AxU/jyAZz85vZDjgHOVIg9vWeoF7DeNUIp0zfYEP+NgIX9GZrUhGm+hwNPObKVep8P3N
	xlnSw7YU9k8N/Ka6uGiDXL/MwawxMdkitGKY/KaJbQyPnj7heJxXqq1bSMXTXY2s5uFVF
X-Received: by 2002:a05:693c:88ce:20b0:375:f17a:d691 with SMTP id 5a478bee46e88-38570f2b261mr2924838eec.38.1795180486175;
        Fri, 20 Nov 2026 05:14:46 -0800 (PST)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385677c349csm8900527eec.22.2026.11.20.05.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 05:14:45 -0800 (PST)
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
Subject: [PATCH v31 1/4] dt-bindings: crypto: Document support for SPAcc
Date: Fri, 20 Nov 2026 18:44:01 +0530
Message-Id: <20261120131404.976959-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261120131404.976959-1-pavitrakumarm@vayavyalabs.com>
References: <20261120131404.976959-1-pavitrakumarm@vayavyalabs.com>
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

