Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792427132;
	b=1X6FODl79uK1jzpJc4O++X0zdbmysRhQrzJayRjFTrHyqeEgJrz6CpDyRdYUAeU0Dw6N
	 DeItKB/++du0qALmKtmsvOefADCF770heGITdkk64DwN538/Aq3Smnyg4hw3A0S8BJ6wE
	 iGIsVW2QLYYQUKEU3f4lRmQgr/RwqVHY5YvF3shgca+Q8OgvEsHmocwin/8brfIyQcE5c
	 bX9dVur34zTdFL2WJcA7Y7SheCoDfmHi9Qv5Q7+tS7s87cuWM9I1CT8LjpmdbJWlBn0Ez
	 /2ExNPZ7u4JYchxFAEGsWJj98anCQeIqcpz0dLe//9bCLMrAy4IhkQtUz5UYPPPo/uQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792427132;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
	b=LA/oZ9rxQljyZpOr19dNxSzYlWG5M8PhJuU/CjdCuTEeAsRArdxZtq6Dy/5M5kRAxYWs
	 gbV/MmlEkPch5oljGjBoc0t30Xtic44Hd+JiPIjCLLapVg/M1XOY8u0VXKes33daNhshO
	 N7mL73tjpMuTTFNB1vPRBwvBlUd9mSGRakfuGR+7hUfmPltZ7mqKv4jSAqPTWGhGr9xnl
	 Ypwt6XZM/hdANwpkmGVrAe7OiSs75vfZIkZ+UM86IgUZeQ8z3moS9AB1SfiHfWU1DwzZJ
	 2jt7n/NYdVfqz3kEuTv2wyOuafth1MDAWoFXu64ezqoypyDroDB+Ej+YIIz5YvA5ukg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=vayavyalabs.com;
	spf=pass smtp.mailfrom=vayavyalabs.com;
	dkim=pass header.d=vayavyalabs.com header.i=@vayavyalabs.com header.a=rsa-sha256 header.s=google header.b=dGv9qhFk;
	arc=none smtp.remote-ip=74.125.82.177
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACA6606A33E
	for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 16:25:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BACA6606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.a=rsa-sha256 header.s=google header.b=dGv9qhFk
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-3535a54bed9so3188801eec.1
        for <linux-crypto@vger.kernel.org>; Mon, 19 Oct 2026 09:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1792427131; x=1793031931; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
        b=dGv9qhFkilxL93XAvfjT6XnAjwozvu2TkGSBtYbO8asDblaqAKYJyZvPZgRNfHusoc
         uXdg/5cpOIn3JtK/S9z5jhqYBvYBkQHf8N36WWqkTu+dcXTwyCkZbNH7kh8ehv+N7hxk
         YkHq8uxVL426exJfkSGhWZJJPFNwuCc0n0HVE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792427131; x=1793031931;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
        b=i6JeRVXwph68ttSyVpEB6xrvREh2+EnvBZ/SSw4cVHCRql8MTLQo9yNdQOHmEf/0jg
         3Jy4UjXk3a/2SChLTM7YKhZOOg0KmlUMSs06dgtOzOGVpMRokdLhDnVUsYtkhEdYhG6Q
         pzyxG334zdPhuNb5fnGfts++oyExrx/rVlwBEd9DdyKj8ybFClW3PGVhRQohwC1CoVB3
         G1U674coy9yUcB94dsYTATWuMPY5KwQGKSPuYbVSzQ+csaUEV0og8GUCx0CXFHw5Vd7k
         vjXgkJUIsIGQoRceOk8KeQvlvIFf6KuhtZbFrBWL0nEigD0fo+6fB8Cph8d4MNSn8TW/
         v0Aw==
X-Gm-Message-State: AFq9FYKi8SlKZ7JlJCYj/U+TFJkIoagCsvqkUVnZVXrP1w/y9/wuz0qq
	We1HzIhQxJNyMl9LdUllrJ8eHO2y+M+jXXHY33QjofMRjKmn71nd/4Zj2MJaT3CqLSyWQ7GOyn7
	ILGpAyho=
X-Gm-Gg: AYBFou0ByTVzHANL6+SX8UOpX+lzdlCpMsz9ESR4uTMrz3BBCIwScT0ZK8XlIZr+3kt
	zl+JqAcjOok7fzmIYphOIH5RAxHNhXlnkcun8KE2pxYP/4fvWf8iA+dgWkK2lJGPsGBDKAq3htk
	BWiNs5TxHoCazlAyDDvcvKXNIzPvtUzJc9D34x0THaAsv2iqk3TmnCSjkzvjUoL1RWoERDslVBk
	9zmWeuteswDN+E08y6P9fx7pj+YdzfYT3IYUZ2tVNidOOKOhyJlYbXo5/GSa6PN+V0N0HTMGS1p
	NaDMsGZ3Q6Vwg2a4EuIiMTGtNMziWjdQu1w+4ZZnNzdoDb0tGkMiYD0Gm7gDUOZ/prxZLcQh6IJ
	zOaWn/gF6UmifTD0jPtnqYAnfBkRpTzT+c1Go5kOOq4yBsMjzlISN3CSQsb9SKeJmauKMwQEOcJ
	MbDOR3tXI75mji9MtLDYxrEwwWD92t5phioGB+xAS2ZC5EJfRL5BrAJ8BEI3XDozppshbRGy9Ud
	HlxaxRJSZInkinaGD+F0plvBHC5XkQhMW1I6E9AV+xSbvzNReOGptnCVyZv+nb9jKiCy91g1wC+
	Zh8oGmI6nMGYSzG0jsrXoTjvVNMyYS189OtybQ==
X-Received: by 2002:a05:693c:20d2:10b0:35e:1807:cedf with SMTP id 5a478bee46e88-3619ed0fbc7mr12378533eec.1.1792427130572;
        Mon, 19 Oct 2026 09:25:30 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-360819bc569sm32218885eec.11.2026.10.19.09.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 09:25:30 -0700 (PDT)
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
Subject: [PATCH v26 1/4] dt-bindings: crypto: Document support for SPAcc
Date: Mon, 19 Oct 2026 21:54:54 +0530
Message-Id: <20261019162457.1000115-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261019162457.1000115-1-pavitrakumarm@vayavyalabs.com>
References: <20261019162457.1000115-1-pavitrakumarm@vayavyalabs.com>
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

