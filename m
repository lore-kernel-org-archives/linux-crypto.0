Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795780877;
	b=0GRGf6WekwHLwl5NNltquL2rBYZrPsAR1uUqEtrXotQWNMZaIvk1POWoxQRUrmJYUhVQ
	 srdIsGvFJYjo8r7JxgT7GyViro5koS0D8tsMvOCTzroR0Gf2JPnfiZfYUTRCbfrQX2XR6
	 uc9cOp2cui+WgJo+tC7pBAkgpn5vXjDSCHNMGTZpp8Q5zXHRzFCmsa7HGpcgWDTKOem7L
	 fnJ8k4vZTeBuF19/x/9qCzwHBs2QFnDaJIa5C3UrKYv2f4AsyxCLhQZ+E5ADHKUGB+Gv0
	 O8fOb2yiN4vuX7RCwsBirMnaxPDl1+1USyEzxtXxRYcnUMkL9wWg9LEzxAG/Zoc5mgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795780877;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=LiLmIUs0OkCCdpFo34dseBA6Y4Jh270a70ul1A3BXtY=;
	b=I+5xuNkBeuxLnas+1nFpx/UtKXVSn4B8R50/xSm0GKxZyfRgsf/xmfqWvLjWW3ETPQIO
	 7AorxzXNrMnH5aeHCjv0oZ5xYalzFcPbwtEt6oKTq3HqqBLCF0zDO++FsNL6ri7cQfgLZ
	 MY7bFnvtVtOs+7A810351/20vFwRgL7fmwHTXtWdj6mGXTmSglR7N1GOxq//WWznmhCyr
	 qLN326mpDM+d5VhTYt7JgeUehXPqsYSg/uoSnnJYAla+Lm06oXryX1aFwOk+qXjwm0jj4
	 DiqKBQ+mjA3eFVI17xlaC+UP67iM667l7gk9qhSzNCFe4/yCLfMX79ZcceG1W9+qyMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SqtudJZi;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC358606A31E
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 12:01:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC358606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SqtudJZi
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-498f5fa4f70so6635182f8f.0
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:01:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795780875; x=1796385675; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LiLmIUs0OkCCdpFo34dseBA6Y4Jh270a70ul1A3BXtY=;
        b=SqtudJZirmep+4E88lLbx3+Z9HziLVpTuJj5EqIzpO1Hz6MoRJmTWUPtrWtgQu6NJj
         9U6ky5d7AoX8DEKqSHesz1nmL/n44K+NW94H304YwsXftIl9KtCoK7hRTCvs5SmBS93S
         jCo8O345BBBJmPB5005/j+3RIBPPzHzSSHU6en038497nWB/UShR8opUK1xLLT8NKeLS
         0GFW0gsAF2A365RRM+GvOxfbf82PAk6U4cnAMtm5MwP/fWuS9OXt5tUvS4ynFDY/UQcP
         dRPFiZcZRhClSa2FrfJWzZ4SQryhfKX2BwjCObDSVw2/Zr69uqctETPdhGz2TlQLPm/T
         ygHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795780875; x=1796385675;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LiLmIUs0OkCCdpFo34dseBA6Y4Jh270a70ul1A3BXtY=;
        b=0/JxoSeLjKZRazfCGlEf6dpy1OZAvGtTjI4z9zLwEHkrT25WSOFnzlz26CkWBnVejC
         xSCyVxVxio0YQu6ErHc7q8NjlvoeMnTFUl+y4I2MEtpnmQOeL35XuTwbmz/721YR6Fzk
         ACQRxfU8+7NtqKvWSqSV4/peEv7MBDoCFi/tG3DHu2q/o1RXnUiks8LJzy5u4PbE/dNb
         NDgxSoAPPaZMOh4HPk8/1JkCkx0uYq1gY1fsjqAUpYWv+mOG/Irn1XFEchA2w0dTjhyG
         0eymLfSLQlsueykbknkqFp1e+nGkI1dfTjzXIORey2iQ77K975vTymFKqIcgex5KSVPc
         NN5w==
X-Gm-Message-State: APuU4Z++Bfh1BwyneLyPDGoX8NUc6fJQ++amyclgSOet4Jsqccbg/89+
	HE6J9a6W1Tguej3+4+7865lGx8piyuD0MwcN8Meg1NFYGETrdZiwsVTO
X-Gm-Gg: AZFdTZc5FBJqCw5zC+HEnPcfYvSPozvdNoaED7EJryUiVCqa2ts+e2xoJBAmrVlWw41
	+Ym2mJ9wydl+y0z10DFMGH/nncSL0kSYeqzc8hbZxnVSfHuszD598klYpV/8z9ugCgiH46LGhX8
	hO2WZJUIzCb1DLigdq0Kd0qlc1Fld0LBs40jnpMfRHBIEXeSbSoUFptjmNrH8bEaX4us9TEFptn
	Dk3mXBHtwPuVbbEzbqpFnB+z/EZz5iKw5EGxp1zA7Ao24PK+D9hZTrLw8IEU+BCvRyQ9t325Exi
	O8/XwNo42cvuTNVavDBR7n3bCfG/BASErc9/0668GhjRc6XfYAeJHphPxbZUESJw7+NenJVsyVZ
	7I2jNHnWBNqKM118KVXjxJwoAiN1EC5ZlO444O9UTdJN95Angfk3oLZlKYgkgcs3OOhZ9mBvhx4
	btGbRJBQnQnVBn/b70LBYZ2V1akrGhOYRpTb5c6obIMN8Vl34EI/xaOrKLdwTZv4hjSgmHHC9jw
	+zO99qNcuzzhUglofTKGgUKtFmGFzIZiiPSqVvaKOAoWeln8ihGZH4NyjeSBDQh98Bzh+dp1J9z
	QgVeB3lhc1TJjTTlDRaWQ1CkMdM/hgCIwZqyYue099fWNho=
X-Received: by 2002:a05:600c:5487:b0:4bb:5de1:e92c with SMTP id 5b1f17b1804b1-4bb88813157mr490184945e9.26.1795780874947;
        Fri, 27 Nov 2026 04:01:14 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906640a2sm393684565e9.0.2026.11.27.04.01.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 04:01:14 -0800 (PST)
From: Jose Nieto <jnieto.alaber@gmail.com>
To: Corentin Labbe <clabbe@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	devicetree@vger.kernel.org,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Alexey Romanov <romanov.alexey2000@gmail.com>
Subject: [PATCH v14 02/30] dt-bindings: crypto: amlogic,gxl-crypto: support new SoC's
Date: Fri, 27 Nov 2026 13:00:35 +0100
Message-ID: <20261127120103.1532882-3-jnieto.alaber@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261127120103.1532882-1-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
 <20261127120103.1532882-1-jnieto.alaber@gmail.com>
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

From: Alexey Romanov <romanov.alexey2000@gmail.com>

Now crypto module available at G12A/G12B/S4/A1/SM1/AXG.

1. Add new compatibles:
  - amlogic,g12a-crypto
  - amlogic,axg-crypto
  - amlogic,a1-crypto
  - amlogic,s4-crypto (uses a1-crypto as fallback)

Difference between this compatibles:
 * Different registers offset and the number of setup descriptors.
 * GXL doesn't support hashing like the others.
 * G12A/B and A1/S4 crypto HW don't support 192 AES key.
 * GXL, G12A/B and AXG require a reverse IV key before processing.

2. Add power-domains in schema, which is required only for A1.
This is specific vendor design: in old SoC's power domain for
crypto HW was not configurable, but in A1-series it is configurable.

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
---
 .../bindings/crypto/amlogic,gxl-crypto.yaml   | 24 +++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
index fdc39797a2a9..106a9d1fed69 100644
--- a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
+++ b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
@@ -11,8 +11,16 @@ maintainers:
 
 properties:
   compatible:
-    items:
-      - const: amlogic,gxl-crypto
+    oneOf:
+      - items:
+          - enum:
+              - amlogic,s4-crypto
+          - const: amlogic,a1-crypto
+      - enum:
+          - amlogic,gxl-crypto
+          - amlogic,axg-crypto
+          - amlogic,g12a-crypto
+          - amlogic,a1-crypto
 
   reg:
     maxItems: 1
@@ -24,12 +32,24 @@ properties:
   clocks:
     maxItems: 1
 
+  power-domains:
+    maxItems: 1
+
 required:
   - compatible
   - reg
   - interrupts
   - clocks
 
+allOf:
+  - if:
+      properties:
+        compatible:
+          const: amlogic,a1-crypto
+    then:
+      required:
+        - power-domains
+
 additionalProperties: false
 
 examples:
-- 
2.47.3

