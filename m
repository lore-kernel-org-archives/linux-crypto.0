Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4039D400DFC
	for <linux-crypto@vger.kernel.org>; Mon, 31 Aug 2026 12:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788179503; cv=none; b=Cn6cXmjVX8+ZcEWBs3/i9NJCqKlaZPwd4DJHdl/kblcccSsiVxsY0/7VwOuYF3TOytRAIZzq2tMNk91IZFBH0Bs0kk+RwGm942J8bfYQLanJnlfatWDQtjBQKWDiFvM/hSfZxSMLgvts/x9HPJj4Io4FTRjq6uvxt6Vrz8IPHKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788179503; c=relaxed/simple;
	bh=HugAla5NxeGvUAW6ybPWIq/99Qvbl3GRpGgOPmECK8Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HpFJRiM+pfoUmuz7SKnvQSbCuzSea6fkLu39WndkjSwFTvI5O8AJh+w4jtiHV3mCPGdYciQkBEiZrYkw4I6Na1xFQ4K8cOCiLXNUKiinm9BR3DRjdp7Hhix5VQusjJySBxPBYgXrBXO430Llbqnor8kAJBQMOwRTfeBDIHHFw0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=Dscyzzj2; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="Dscyzzj2"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-39682983a0fso4268526a91.3
        for <linux-crypto@vger.kernel.org>; Mon, 31 Aug 2026 05:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1788179502; x=1788784302; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
        b=Dscyzzj2sDEXM+uM48O518jGnYVBmpf5uiq/P1gNpoimaHk8rD+Cbk+5t7B9WuYBHD
         yyWOm5dTZWdK7YJJVe6lrBu98BGjh7M8fSS4lFK4mzXN5lm5tSqi0YTQV/7VtbZAQNXR
         cypr8w4NkvmH+Tugb0qCdyux1uib5ZrYlYdAc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788179502; x=1788784302;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dNttZqyddGtfpM6shjyHncnhqR2TNAPYpAsPVppmIzU=;
        b=pXuAzOPqNdzFrshC9P47BED3ZrUPMc4GLfAnwS7ewt8UMXiBKXbXQR1GpNUIFzF0o+
         8sEYUkLyrBYsoWxnt3ODQfQVKdwFALBIyn6oPwdw7pRRQJQbynNYKkW+Z0EGOzUcrjN3
         TAT3dlSGTBwV0zBaMyuy+WhfyRDpWluRWiIKj9o14M6EPhSuTi4YXVmVYZih89vS5cTU
         sbFGTmjzQiL+LnWHCz0VpzOwpulIpxcbs7LwiBuCIAnqKVh7HRhjOm+xlFVjST3wQzSF
         j3HEtsZZ5AIxdVPaShFGXwvwT5qF7XBAWKsyetnSCLNlnyRZw4aeUbLJ0tQ+74WcBO7L
         J8OA==
X-Gm-Message-State: AFuF++mEdFALcqYRmDgeJVwH66WF/wfGN9EmANHo6U80S9Fpn4zVTrVn
	svdnXNwCl+rOvI2BgCvYGomfQGMnzDiNGYS7q/XSfH8HIycvlJpj8f8L8LC4d6DB0t9iwFTCnIy
	HMKVT
X-Gm-Gg: AYBFou0EBBlHw/1YMV5C3Q30SxFJ+J8xHF+l3HFF06vE6LG3+v1hTBQexS0+DPLSF9e
	E5bjLga0hDjohDg0kazQinJsQZX31WBRR4w7x6PBhhnjhknopGl8nd1vRlVbT4M/y+TMsDOOLoY
	vnh1v62tN/XcmxS6nwZJm11G96QdE938drw36I+PfVgkWohlIMr3cm8eO6JZyung0WEFCmDAFYp
	nTWew/mtnUZSVOYerCxyYYbzJ5cbKMnuXXnzHmmuK6B+RmSE3hqxK9qTSV8wlo1riIEhOzhogQt
	nPLcNjLfkGvMd08LfyrjYGOvVxr2vzAnrDOl2fSR60e/3m/2zXGkU400bFpjdLhy4lt/XwZud9R
	BuCDWH3JkMXDLOxk2RKnIHF9RK+/rDl6LyPauBUvdjTx677gVFvxYX6Snray4fBrVXQ7KEPIebN
	b43ITp9TzrZxv2xWYdiljVK0MIqCyKBMwZDrkKKqv7k1ib3uH//+z0+X5raOZbBuSP1OFFs7y/P
	Jp/HZySrv8IjO+mZiWiEe6Z1MmUIViu8lwxSc9HhFwx/7qUUlNHfKX6mgWxuK6zqKLJV1ZBZbmU
	wECHxT5d42p2S8VvKXVoLJ4Wno57
X-Received: by 2002:a17:90b:388d:b0:38f:5869:387b with SMTP id 98e67ed59e1d1-396d0ed8eb2mr38352172a91.9.1788179501530;
        Mon, 31 Aug 2026 05:31:41 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-142e0d38207sm27470376c88.5.2026.08.31.05.31.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 05:31:41 -0700 (PDT)
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
Subject: [PATCH v24 1/4] dt-bindings: crypto: Document support for SPAcc
Date: Mon, 31 Aug 2026 18:01:10 +0530
Message-Id: <20260831123113.870832-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260831123113.870832-1-pavitrakumarm@vayavyalabs.com>
References: <20260831123113.870832-1-pavitrakumarm@vayavyalabs.com>
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

