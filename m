Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFEF215C61
	for <linux-crypto@vger.kernel.org>; Wed, 30 Oct 2024 21:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730324074; cv=none; b=nuJrzXYmuVrA4shMbKR223UuF798OnJvYQZD3/SEbpGt8Y76r9iBtq6iLueI0Z4X51O3xhLVqzZmgT0E7JOXnk+h9rs8QQs6jblTJasbK1N2VZS+7JqGUdEDd3ePqyGc3ohJjVCVOUcbtwH8FWGmyR6vKmTuKK6Z2ZqZszODUIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730324074; c=relaxed/simple;
	bh=uIj9bxjJ+UW3J2+LRlRVni9rzPoTuE/3qRjSbZzsgs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WN9hyev5dH6b3fZxjk/DmzQuDClwTUJW3MDv6ecKky+ixn2NX50WFe+wrfuBDVEuRWOwga5xHklpL+Jc9yQVJnMqvrYFNq7sb+ylJBLIwKrgAscHMY7CxQvQHHY2l0U92p6BXlG/uITStBy0xvCc69wPLnqMpC3yAqFRlARsATA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=UWhXvd86; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="UWhXvd86"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-72097a5ca74so199388b3a.3
        for <linux-crypto@vger.kernel.org>; Wed, 30 Oct 2024 14:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1730324072; x=1730928872; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=miG/1HK0adKG95UFlClqKo0MqYdFiIcf0KaOP4hdkuk=;
        b=UWhXvd86RxG5wYWz3wjWeo53kXYpw2qGUQx2nVUYlsON+RFAwrKykvldvnsyQ6Dlxs
         VBF1Hx7livRkTegAYpuXk82/7TlfVEceQjvu2WTEefALM0yEE/7aYVmss2r5ffkC6YEj
         fDH9vHXbTE58MCj+62cY3MmZM4uaPiojcjXiw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730324072; x=1730928872;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=miG/1HK0adKG95UFlClqKo0MqYdFiIcf0KaOP4hdkuk=;
        b=b7UZlHcGtKVBGvXJ2Hx7w9DSs0C3ICMEKiDMpNDBbyWo/Z3f2SLlvh+spwEO6JtqNZ
         ij0/fjg0QF4LBgk02wYaOXazB34rmJIURiv4Btxdsf6/gg7wLoSXPQxU6L3rEp+/OWRU
         3VRPfSalYMbkr50FQwbDGY5W3yRQVSLCTFuE1vTV0vhUD9HNyoUhtCY0T6ftnN7kq7mH
         +LEaWRSVK9oRLs/TMNnWUjnH+/W7gRr14wDCXTi08doI61TVRzrDeBTjzjGBpZK6zjCK
         swkYPxK4x+xq3VHBCQ0H5e7o8oSIezp5uminvXHT5SmDdnZPEjnV7KVpGMDnaC784Dmg
         0PJQ==
X-Forwarded-Encrypted: i=1; AJvYcCXuhfb487JfOp1tnjjJAulfuOElbNw5F/dFaprSd1QoQOYQwGc6YARDYPRNbtab5ZYjOIrFZQxqFl1oHxM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBFUFI79TNj4S78B0iXdkP4JpXIB0QU7Gq2rNzuRlREpB3M4FZ
	57hZqulir4Ged12MXEj/aED+Mo6sWVmSitZ4l5KmpRRPkHh3s0kWGx7D1VnvOw==
X-Google-Smtp-Source: AGHT+IEVlkxrvwpC6QCQmAunwAgGVoMYo+UQq+OVf0zsxgZEasH0PzCqxEDNUFZ/6ZGQgbWvwMF0aQ==
X-Received: by 2002:a05:6a00:9296:b0:71e:b8:1930 with SMTP id d2e1a72fcca58-72062fd980fmr24280742b3a.16.1730324071522;
        Wed, 30 Oct 2024 14:34:31 -0700 (PDT)
Received: from lbrmn-mmayer.ric.broadcom.net ([192.19.161.248])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720bc1b892bsm95417b3a.13.2024.10.30.14.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2024 14:34:31 -0700 (PDT)
Received: by lbrmn-mmayer.ric.broadcom.net (Postfix, from userid 1000)
	id 481BE888; Wed, 30 Oct 2024 14:34:30 -0700 (PDT)
From: Markus Mayer <mmayer@broadcom.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Conor Dooley <conor+dt@kernel.org>,
	Daniel Golle <daniel@makrotopia.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Rob Herring <robh@kernel.org>
Cc: Markus Mayer <mmayer@broadcom.com>,
	Device Tree Mailing List <devicetree@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] dt-bindings: rng: add binding for BCM74110 RNG
Date: Wed, 30 Oct 2024 14:33:54 -0700
Message-ID: <20241030213400.802264-2-mmayer@broadcom.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241030213400.802264-1-mmayer@broadcom.com>
References: <20241030213400.802264-1-mmayer@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a binding for the random number generator used on the BCM74110.

Signed-off-by: Markus Mayer <mmayer@broadcom.com>
---
 .../bindings/rng/brcm,bcm74110.yaml           | 35 +++++++++++++++++++
 1 file changed, 35 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/brcm,bcm74110.yaml

diff --git a/Documentation/devicetree/bindings/rng/brcm,bcm74110.yaml b/Documentation/devicetree/bindings/rng/brcm,bcm74110.yaml
new file mode 100644
index 000000000000..acd0856cee72
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/brcm,bcm74110.yaml
@@ -0,0 +1,35 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/rng/brcm,bcm74110.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: BCM74110 Random number generator
+
+description: |
+  Random number generator used on the BCM74110.
+
+maintainers:
+  - Markus Mayer <mmayer@broadcom.com>
+  - Florian Fainelli <florian.fainelli@broadcom.com>
+
+properties:
+  compatible:
+    enum:
+      - brcm,bcm74110-rng
+
+  reg:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+
+additionalProperties: false
+
+examples:
+  - |
+    rng: rng@83ba000 {
+        compatible = "brcm,bcm74110-trng";
+        reg = <0x83ba000 0x14>;
+    };
-- 
2.46.0

