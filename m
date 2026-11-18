Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794983735;
	b=g5gYkXgZ9/3BYY6W/wU/S6Fh7SD6UmNe6lSRJO4Oezj4V+7FylLr3DuE6TLUFaiQPaH2
	 nOdhx3hk1NA6frS3ZpuTjBfM+SVcatvePjDi3oBabKk9QV4o1zeGlg7e0yoR0vFHTKEJg
	 ojU3SDSehbINMoGYjes1t/UBy4I80efB4+3t01la9QJNwJTtwI7VgWPPRW2M+IEOJA1a0
	 tsJIor4YjPyvtYUYKIhIw7Tsd2l4dtXBmC1mZ5eLpitKNfGGKHwTlOoQcO3RqsWmYIIKU
	 dDNP5MjCZ2wpMVvsW2Mw74Gq8HZuQalw+heC8RNmIV6tuQwJLVGUS9kM1fTgdHUYvpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794983735;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
	b=ccRQ84+9B5p+XwVH9d0zcgjXZCNwXjVoe2bZVF0uVHPQWFECcPPMuVtlXxYHHuGvUKbR
	 kpONvjsGrS4n/PGE0Vc4SY8Bp7DApQXAh5f4RDlpbveNQqA5M3tk/dkUx3KaMLS/EEK+R
	 E2tyMdELrIyyofT1IjTCuMVouIXyI4f4CSlLDc5JIo8gwJnzd2ulbSvh/U37QiibMfniu
	 tGy1+FNZLUqR47ffO5PuR6PmP24XoN3RkbN/o3ObRoJRmq+Z9yU06dhGrOIxbfoZxwa5P
	 gBSomO33nmfcFAn+8J18qcc0dyVEcuhAxHWMap37DwR5R3l4AbKSj5bKPx/PGnIr44g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=vayavyalabs.com;
	spf=pass smtp.mailfrom=vayavyalabs.com;
	dkim=pass header.d=vayavyalabs.com header.i=@vayavyalabs.com header.a=rsa-sha256 header.s=google header.b=cbVxVLK8;
	arc=none smtp.remote-ip=74.125.82.179
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624BA606A32A
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 06:35:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 624BA606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.a=rsa-sha256 header.s=google header.b=cbVxVLK8
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-36a315ed211so475841eec.0
        for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2026 22:35:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1794983733; x=1795588533; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
        b=cbVxVLK80ofnnYEOxZ8RmtFCY4qt4CXvWAOGAaSEpjuOsiyOyTnx8kv+BIgRavweLd
         cactbbmutvrZIFMvov9jraLIR4+oTSOQf3hOznKDaE0DjqXVY8Y/7sOSMTtdMRgoSY+n
         9QckQ9IexFYvPhNuCdk8W8csBzH1KPr2hrU6M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794983733; x=1795588533;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
        b=x+b6FNHyq8AKC1ni/d7kTl0y1VoAFhKVTWgfa75rvxsqFE3tT5fKi8FYIh5WYAwBmR
         MVPzrQAcrgNIAN6KAIVrKusqa9/AZzMp1NBqD0Exjgq4CyDPbT9WkiCPx2d3/R/jv7+2
         CJ6z+vAbmJXLR2ewnIHNcTYN2IJqFHmWZCIqfgEZfNq2jI2RV8VO4IGw1x37/RCyX/oR
         cFoBDnIIELW/U47C8NV3M2WnAWlUP4Y4udsZ8aIbZMDJtiR07kgQfyBDm+Mxq9Mw4O/8
         TM5fKi5kQx/8fgpqY0gaqz5Rjx+TvUbfqsplZGjcdLd1Er2SDDXtCLLqwZLrDq2U+9xc
         8KXg==
X-Gm-Message-State: APuU4Z8l3eWpzwaNB8Ci/rpVrkAZLmPmMYEMjeQ7RW4V5qNZl5P+6mRE
	uof73T3B8M5Z+k/IdPAqJ+XOZpWoE4WzOZh6crbM+PsCYzONMd8dOgfXWeX01E4sLoqfVOzxEil
	TwZBkXTI=
X-Gm-Gg: AZFdTZfcst3pi9EDL1g+4rx1fEQKCxFJHMCGK0uhmUWYUT/vzJ1kC6GbU4L5jVPMSUc
	3h4AqMmrcAr05dPvQOpp8ajFex4orSgmQ7XEi/t2Zxh/7Qm+2GlOR8TEMbHiCoXPgKXJyNLvRlm
	71Z6W91RN665aOLFpE7DzgkeC6lyWihepfhE8oipp+CYYYcDCJQdB3XxZDVZHicMOruD2gKw2Rh
	bsi+3MIrk2Z199EfSHsZrpFS2A3i4gDoq7tBDB2X3DlcmnW7bH0ksr+Fem4/L2ixdHPCLRAfO9u
	XKKDDCfzU1eop9x8T48GzOqfnmTCzd5Rhypm3CIzIpYPmDICtdsrlL6xLBhLdIzs/uuJ2MF1BKX
	Sw+FlEl0QNTLiqYHEcx9l3WBqvqh6U7zwaODaNOz9kkSnodAssnllA8j9wBq96hs9L1PbhIUqW+
	Iizp2YPd3S8u5GKqwkpdtacCGuJ8IHwmqShkzU+x08tfCEzYS0nx+vpiiwh70BrqZJyIZKdXKDD
	hm6G2WnpqZgL6L4ST36sARTzRfO/1UDplsjoxkBNaw8FYDBWNiX9t/2G3/IZ5DbUuS5TkciXsZ4
	3+V/pNQE3q1OBOjhXPFONRidPP+5PafJ6SyLn9xhk+Jvay8v7wH6y5Hdop0E5SRy+LbemeDPxaf
	6g15+gnvhuKEHSU24ECF5VUNVAAiW5nbDvfsaLlY0N24vAAw5Pi4fxr9EiFVU9b729x5e
X-Received: by 2002:a05:7300:2146:b0:375:6fed:8e71 with SMTP id 5a478bee46e88-3810e419ea7mr6808685eec.7.1794983733360;
        Tue, 17 Nov 2026 22:35:33 -0800 (PST)
Received: from localhost.localdomain ([103.219.60.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-382a72eb2f3sm5002338eec.18.2026.11.17.22.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 22:35:33 -0800 (PST)
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
Subject: [PATCH v30 1/4] dt-bindings: crypto: Document support for SPAcc
Date: Wed, 18 Nov 2026 12:05:01 +0530
Message-Id: <20261118063504.835259-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261118063504.835259-1-pavitrakumarm@vayavyalabs.com>
References: <20261118063504.835259-1-pavitrakumarm@vayavyalabs.com>
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

