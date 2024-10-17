Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFEA1D8E01;
	Thu, 17 Oct 2024 12:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729169131; cv=none; b=STBiSj6lblmzRinXSF+qg4W7jZV9E2j7uhLbEXEeqHutwIC9FY7BjzQOYKsL8Xv0qrxmWDD3kcGsKPdA4QyKtnekhHHaGaCItKfCD9Kogbi70H3JTcZ8xw1W+WS+2NbPibEXUXJZ79JoIvkYeTU329pwdMc5Bg73Bb30W9S0HYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729169131; c=relaxed/simple;
	bh=deE5KMTn4KaOTECboAmoIAG9aFGuieYcidqotDmDEx4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Dwg5Wgnx5BYhom253Qu6O4Bz1iEo8IHOOAUeeotk+Xlxjv5WwV7iMdboZ17f4p2UI+n391cw4n74kW6vPOmjfvxz6n2WJcIDp/DbQLcoFSQZ7jMHWAfn7MyE2jGD58Be8ws77BuCWsQf/mo1xn337O3zFJsjY5KabiAXR9+ePGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Et9Batdd; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Et9Batdd"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43115887867so6427115e9.0;
        Thu, 17 Oct 2024 05:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729169126; x=1729773926; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=H/+innDKOF43hyWEtHatUGWD9jwLhMbIAvPNTvaYpoo=;
        b=Et9BatddkRYKW2qTuN5bzVcYgoATkhSNYLCqnvlnsHvXfAZNc7UF5tSl3FBgyMD06D
         IeCliyduGGc3LRRywjNNyUsKVmE6JUdpsVRi7gxkO8btHmB0nBn12gPlqDOyPW7aHnlc
         YzD0/1E1qzhGbY1G1JNJUHresm0/TXmP3rTIfZmKuP8ikk6iZNAA6qmmrAR9GAxxuqwO
         9Jw8NgSyH6RoxdIR31T7cbd6n9u+9O755LBa8qe7KiJVc4l50Np3yko8RRUrKaKiO7Ru
         WrGd61RlB++2PmRmKoL/0aXyLD8XfbIPRLgiG+eHIReji4vVcb/xM/n8OMJBVrOT+sb8
         +jtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729169126; x=1729773926;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H/+innDKOF43hyWEtHatUGWD9jwLhMbIAvPNTvaYpoo=;
        b=wwm1zjQ51L6lrCogQx0RHLUPIcxrrU3YJafadPokF28niAWiWxOjZVmTIf6D3gxfc1
         2cOMGxeONZqZwVs0a80WsDbYMPUSdZSWC8CX6HO1ce3vfWLmcJD4U0Aj+BzSGxXgPJcA
         0hWyQ6ZbHm1151Jq6cNedtT0g9xxaiLkHM7OjI8wl6kXQCdEEQkQsFZHWcyG0ayx/6tz
         U1sVHzcd7QI54EJjMxr/HFZUS6/h++TFKIZQn8t7mgBunWxJVm0aKNDwejZRCUEE93b/
         QdvBHVQbR31o0aP0YLvpI6b5BcnPWCiFcSEVx5E5S9YJT4DQ8zUaOXGeN0P/B/ubnR6Z
         P60w==
X-Forwarded-Encrypted: i=1; AJvYcCUDFP6d9WRjwUj/AgjVPXDTuUMQTF8QjLJ93ESjhBNs/4mx9tjjf7HxuAtDDHeSQNoJtwe7cNUtyCzT@vger.kernel.org, AJvYcCV22fTSdtWhatTRPhZnjZD+0Nz9rnZHfzX56W82PWgPHUcJCbV6sAEeyBN0b+TCsc+7gpKWDB7LKTEsODT6@vger.kernel.org, AJvYcCVqeSIE9/0onVCwWUN3oH9e/y/Iwf98m6Wahqvjk+IA15nd6wmjnyzhN7YzzVF8agKHPc2Ri+lcmrEJDvJp@vger.kernel.org
X-Gm-Message-State: AOJu0YzwN3jIgYAfH34QGw9H8enUXrPq0UYreQOxU/AUzpxt/0BHRtna
	n48k6diqOn1d6DyhxqWFhF/j8HI7CvL8WjQGeIyfFW0aIoJtd3JzCKxXnw==
X-Google-Smtp-Source: AGHT+IGZ8dknLqmk2GIy76wfXtTPGGUCSieGuvFLj4VG2MBO+7hsC4vxw8BnP7Gb9PXqB8CVMYVTGQ==
X-Received: by 2002:a05:600c:3109:b0:431:3b80:6ca7 with SMTP id 5b1f17b1804b1-43158756ee3mr20576845e9.13.1729169126055;
        Thu, 17 Oct 2024 05:45:26 -0700 (PDT)
Received: from localhost.localdomain (93-34-90-105.ip49.fastwebnet.it. [93.34.90.105])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-43158c4d9desm24972935e9.35.2024.10.17.05.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2024 05:45:24 -0700 (PDT)
From: Christian Marangi <ansuelsmth@gmail.com>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Linus Walleij <linus.walleij@linaro.org>,
	Daniel Golle <daniel@makrotopia.org>,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	upstream@airoha.com
Subject: [PATCH v2 1/2] dt-bindings: rng: add support for Airoha EN7581 TRNG
Date: Thu, 17 Oct 2024 14:44:37 +0200
Message-ID: <20241017124456.32584-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for Airoha EN7581 True Random Number generator.

This module can generate up to 4bytes of raw data at times and support
self health test at startup. The module gets noise for randomness from
various source from ADC, AP, dedicated clocks and other devices attached
to the SoC producing true random numbers.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
---
Changes v2:
- Add Reviewed-by tag

 .../bindings/rng/airoha,en7581-trng.yaml      | 38 +++++++++++++++++++
 1 file changed, 38 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/airoha,en7581-trng.yaml

diff --git a/Documentation/devicetree/bindings/rng/airoha,en7581-trng.yaml b/Documentation/devicetree/bindings/rng/airoha,en7581-trng.yaml
new file mode 100644
index 000000000000..dfc6d24ee7d9
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/airoha,en7581-trng.yaml
@@ -0,0 +1,38 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/rng/airoha,en7581-trng.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Airoha EN7851 True Random Number Generator
+
+maintainers:
+  - Christian Marangi <ansuelsmth@gmail.com>
+
+properties:
+  compatible:
+    const: airoha,en7581-trng
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
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    rng@1faa1000 {
+        compatible = "airoha,en7581-trng";
+        reg = <0x1faa1000 0x1000>;
+        interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>;
+    };
-- 
2.45.2

