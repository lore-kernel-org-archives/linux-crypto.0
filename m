Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794662814;
	b=a5r5CYqMDUy1PSHtLlBbQzNKGdegnTE1G1Q59LgmmCh0Fn7CxCjgouUrnTfN4uY92fsv
	 1WhoWyUynU01rVazQEphvRRYd51cHkQYuCxT9wbecsfwH7yF8PiYttSrVdGPMzQOY+vaS
	 Rs6se1djexGHvJ8H+2Dj7xmZXVQQA++MGUvxdrcvVLDyL4PL4stW+rNBlssrN0paZdfzB
	 y0qciNowvIMOG80mOl/4/uilw8C1vJsoIPA26psgjn+oDsI6CjJNJ6DRyh5BniVl6YFGn
	 8qYfDytMenOJQjo0LA/wZ606zJATodpCqHvFkytS7SBmWlNynGn7YdpEK1QO3mmdsDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794662814;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
	b=yQEl1svm+GRx69HuC/sBm89Vo714VQhwWDsielq3AhkvUPsfwccpRoyyGj1aC25M+vxM
	 o9zV1xeVtZfxMPlO8gzEC2hQ/fcou3XwIULLcrkPhvRTm6AOgXqRTUOQ4FNGSSjVjBRLj
	 vKS1k/8IDFfG1yvS64joc+PjsaJX1gM04akUknVb7Y3CQ5vvHXCQXgdDwC0tw9sMawLxW
	 +/cFQ6mii4Duib9k8MicUmjmjuIEdIC/2bbRdOpMlD2Pr8164aVjXqGBZnZu5H4RFN3hj
	 1qAj9Y7AUmPFEvflpdjIO60KDc7BTdFqYFl7XJ1P3bpUGVY3OfAW7MClPmns0N2sP2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=vayavyalabs.com;
	spf=pass smtp.mailfrom=vayavyalabs.com;
	dkim=pass header.d=vayavyalabs.com header.i=@vayavyalabs.com header.a=rsa-sha256 header.s=google header.b=HBgH1sjv;
	arc=none smtp.remote-ip=74.125.82.41
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B73606A329
	for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 13:26:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 35B73606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.a=rsa-sha256 header.s=google header.b=HBgH1sjv
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-1a3c08d6928so2604421c88.0
        for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 05:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1794662812; x=1795267612; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
        b=HBgH1sjvlslaIb6CvKtHf4HH6uELxQ8+z9yzXhw44KDCXs8z/Pm3CdGt2tXKYKRBde
         4OE79M6iyaW0kjR8tuOp+GtEIPyeX+hUI4GUmlW4vEBKhDHTPB9ERIe5R3E24huRNs6D
         WKgqwMvjRsxgQ1pIdu4H5h/KQ6gxalQCq1B1g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794662812; x=1795267612;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
        b=VHzxv9oJLqfM6E4leYKoHjp2SGMzZ+ePWJ67PzR97Cqh3OTuRQQcvS+7Dbmc4VtaV6
         n01J1Qh8iEjJkUdcS3MNYjp6ko2EbAWNR+jWyxg7lGgABlVW49OGntUtJ3bsP6ust9A1
         AmeW+jh24KYuxfE4McKZs3bHlGkIoFWp+RcI4861edkD0HFKOD84DsiYljlfgqqgvw0P
         Q0hSg7g5Hkl2LfZeZ0toH91iUxwXDp9JY92GbdBd8kaKbEbQqsLNMyJNZoD6OvxBwMRb
         nhALfqBy78yB8SdQAdP4obFBc5+Y2uxyBATSgwZZQ0huosyiCp3HfgaDhdVIpc8l1noD
         s0/Q==
X-Gm-Message-State: APuU4Z/iokSC3tTGOTncDWQgtVwZkzpjRfJYYmMmjcRX8BkdpJ423ROQ
	67/DZ+rk59VcXsvY1CtikHBa1KNQsXIeH2XHaJ1hWs68sj9PQiE3rB5qNyC+z0UtjNCHqHjigQq
	sPfgB
X-Gm-Gg: AYBFou24JxraSJt9EVRzNJh/u+tt7hQZt0/4O/NmoFEkPF2pHTZuMBaI2Z/pSwwGdzx
	2BV8ONxGI2V35qMXVL95pwN2aSqx3iUHXQjALC5qfP1jQsuYybbaW0AyzJkqz8O4w7OKuJpN2q6
	ItannSCyOMesjEDqwLiLav5o1UTvtvnW9/YMefXyiE6A4kcGfa8pL7x66WJOzM3HxEubdKyORO0
	h11bPDo3Npttdyenp8SyCGh07IXhgJpVW86bvrpurt0Udrm5PZ0D7qdqTjhnWVFcwWMNilyZP2o
	lUaOcDoYZGesCdILSPNi1TqzIuQV6TsOVrxKcl3mv9a5Oz5q3sMTSM8TLKZ3F4+1SSjqR8IiLhR
	gYhTVqcPx/cMlCF9nbz43fgde2uQGnPBDdi9y0uWuksykwtnVp+sHmWEM+6Vz4rBi0No921RrYZ
	4HrNSnvHKLQBWvcYlCLfSqtUD8ipdPMQCJg98+c6r+3Phe0nyZRgy+LfI34UMqjconeGYU/l84E
	hr603TMVwEW4PwBMX2/BZUM3Zw/UOoaAjgCYlMm1jwMYhvZn0PyH8hAtFk4LOMw/ABv6ojX7o9i
	o9A62osURFlxw8ZZnwBtUpie31XZXYShdTLls8KtZOcd+HUkCGeJ3G++o4l/5xQ2tJ/qFTSNY9D
	+lPNI2H81f+EY+b0LUBe/UKcNVg+Wjf7vhBgdeqcwirmkMjhaUvootAmKjwZAmf6cNX6OxMd3gN
	S01WZWtUmWRzraPQ==
X-Received: by 2002:a05:701b:2096:20b0:1ae:59d6:91d7 with SMTP id a92af1059eb24-1b5031007c1mr5430086c88.40.1794662812150;
        Sat, 14 Nov 2026 05:26:52 -0800 (PST)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b50319e381sm15712003c88.12.2026.11.14.05.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 05:26:51 -0800 (PST)
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
Subject: [PATCH v28 1/4] dt-bindings: crypto: Document support for SPAcc
Date: Sat, 14 Nov 2026 18:56:19 +0530
Message-Id: <20261114132622.690129-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261114132622.690129-1-pavitrakumarm@vayavyalabs.com>
References: <20261114132622.690129-1-pavitrakumarm@vayavyalabs.com>
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

