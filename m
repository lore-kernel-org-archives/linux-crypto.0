Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6815A3BB134
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 22:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789078363; cv=none; b=HVaCj6X5Yqy4nXJxFUtvcNwuXW6QIhVSh8yUjmYvh21Yclg8oD3Fqg/aAbmdbQOHpScKVmX931mLb1F8LUZZJje/iylbrAkRP/GnXoWxarwzEk+73Xz+3yFD71s+iPVkQQsmX6aHnqXbcluu++YH/w7gQG5z7dRKlSdTJ8xoln4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789078363; c=relaxed/simple;
	bh=3NlwmlgeR9UStztzEJOa5XxE0OKSg9rGXxb09yHnIZY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=riN6aZLANycNU+4d4EwqI7GtPA548tt8av9EGYLLV9ZoP7T2ufOGxxWLJ/1wJ/zEG5eLAQdIkZ4MvN8t3P6k5sl1vFyWB+fCVUbpeyOPorLFGAlbuX8yZ8kQ8ECev9KVtoiowdeDMbbc8faA0WCA7bYRsDFMAqj+LCtv7B0O+H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=STrEwEKK; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="STrEwEKK"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc1ab16a9ceso25671a12.2
        for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 15:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789078362; x=1789683162; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wnvNRJTUsdTr1CADcV3hYsbAspY/4YujciextqHo7XU=;
        b=STrEwEKK2ioQFBgMIdG1IkLkN5wi61R1ORecpfnEQdMmxdvR8yqJEELoLlbyefQQUR
         wymqfJwsNL29zliR2t/NHP+pzYw/MagJ0xJyygiC4h/KkgiKkDuEsI1UTf5ywmS5Kc/X
         AIDrmrqZVJ9BZVuwcTpz0nTREQUtXGGjSu5MKQBcLVrOFyQ8Ze6FAY+sPyeqHire4XLe
         KEhXpM9kwANrPq5HMhaybLT6nZlf7g3NKV6jSUYcPU6ztEQa+ElnuOc/eO8zWC/H/uSK
         Zz7hTNv1S7hj89vP4cCgDsLUsaOIbnY+0OimHHWBAmDHapV1b23YBUzslWYldcO1JgmV
         Xraw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789078362; x=1789683162;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wnvNRJTUsdTr1CADcV3hYsbAspY/4YujciextqHo7XU=;
        b=EyrgRWMnfovMTRBWPKU9cIfJKD9a7kHSVcSTM8beS9RdbgZvlX43s2qfSmMbgRkIDe
         zQqyQv3ZuKknrHG1d8aoQ7FcVBJb640TKv9ksANIl9HrX2kx4bHDQQawUZKzSP8lqj5M
         5KdqXKsyyhMf9MfpErFKQ58AqS4iOOq48emhesrni6pNlKLcsG6Hi7HiMaRlfOF9isQ7
         OmrGPqljnUQTLPbPnu+PcqA7WOS+RX4aOxcWGzOAuacBpqvAkujMF/Up82Ypp//4rQYz
         iViZwM72oHMufuEpJku3KFUpGO47FlaKfI+lA9uSTOBuoXJH4tLF8fDy8wMeOhsBrdpt
         9ppQ==
X-Forwarded-Encrypted: i=1; AKwUvBwyHT6inXv1/LLSRKE/ZhSh7Pam06u0AfrHPlbqU52zbYFFKiApT7G7YdsnDIQiEMoFo9yuElvwU0xn0Rk=@vger.kernel.org
X-Gm-Message-State: AFuF++mlmk0c8hWeR83OAQqa0G0i6t4/2ATpbr1fnqrorv8m2Pjl1uCp
	K4kFDoHqSuHXXiIrts8CXD5tbymSXuFfU4M6k1RvR1FCC/ykcbpwFszSSrdAXQ==
X-Gm-Gg: AYBFou3JWCE8SeY1PvhnkvN7l41vTkvHevOfVCFQ5OIAC143VzWIShSJ6XF2QvQS3qm
	WDGXE4RDDV9sC0Yizg+PWPhWFSm847cPD7Z2NIQT+y3txW/5CIdYydYkVRQSusrY4kRjksmaW3i
	02C3eMvBzr+sUl4Oo4+oJREpQkKID4RaiiApZUZOsObFRMFY/F6j2qfjeYec6GvtVoGyQ7MCZ/m
	AUTnX8ysU2/B+5I3Y2blz53YnCrf3Fj32hh7cQ24peEsurFxiIL4aU20nRXcMfxU+7ulpdYX8D9
	Rr8NWWuvu0sGIT2uOx5awMomGhZImNBuySHEu5TAPmxuLFznRdnC3mKioMqsaERRRmQMA+Mrxb4
	qPWqKsKBdUNL9gvlCX9saSqjGXEyRMl5ih7Lsd6YtdozAfaDU13UkjQEfzVRRL5umz0Fo86SAPc
	zPviwm+yGu1OX7NAhdZT6xT5rrtJg2Mt5Bf3gdKl8AtQwhk08j6YdvuJSPEORy2H45nBrlxPFDY
	pgb0xvGUZGkJVinYiHSLMA=
X-Received: by 2002:a05:6a00:4994:b0:867:8d0b:6870 with SMTP id d2e1a72fcca58-86b2c9f2b7dmr719905b3a.0.1789078361469;
        Thu, 10 Sep 2026 15:12:41 -0700 (PDT)
Received: from [172.29.212.252] ([2409:40c2:5426:e355:af9c:7683:e7ab:273b])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b291bf622sm171875b3a.27.2026.09.10.15.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 15:12:40 -0700 (PDT)
From: Bhargav Joshi <j.bhargav.u@gmail.com>
Date: Fri, 11 Sep 2026 03:41:58 +0530
Subject: [PATCH 2/2] dt-bindings: crypto: ti,omap-sham: Add OMAP3
 compatible and deprecate ti,hwmods
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-ti-dra7-omap-sham-fix-v1-2-c430f01b4e13@gmail.com>
References: <20260911-ti-dra7-omap-sham-fix-v1-0-c430f01b4e13@gmail.com>
In-Reply-To: <20260911-ti-dra7-omap-sham-fix-v1-0-c430f01b4e13@gmail.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>, 
 Andreas Kemnade <andreas@kemnade.info>, Kevin Hilman <khilman@baylibre.com>, 
 Roger Quadros <rogerq@kernel.org>, Tony Lindgren <tony@atomide.com>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Animesh Agarwal <animeshagarwal28@gmail.com>
Cc: linux-omap@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
 j.bhargav.u@gmail.com
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789078323; l=1381;
 i=j.bhargav.u@gmail.com; h=from:subject:message-id;
 bh=3NlwmlgeR9UStztzEJOa5XxE0OKSg9rGXxb09yHnIZY=;
 b=rzU+sCzu/3EItdNAPicMXqfdZGo59KPgmNLWn2f1+uGHccQf9SFGCu3tf6TJ/ZIMHM5Pk4OoZ
 qWogz1kZcxJAiWMdPiaIu6KW3IPg9ymaLWHCxy8AEtTQegE25ifx//V
X-Developer-Key: i=j.bhargav.u@gmail.com; a=ed25519;
 pk=IqNDwUZKECEA+n8wXctFLBbYL9NhFstZNbOznm/nX1k=

The OMAP SHAM driver supports OMAP3 SoCs, and "ti,omap3-sham" is
actively used in existing dts. However, it was previously missing from
binding. Add "ti,omap3-sham" to the list of valid compatibles.

The legacy "ti,hwmods" property is no longer needed as TI OMAP mirgrated
to "ti-sysc". Mark it as deprecated and remove it from the required
properties.

Signed-off-by: Bhargav Joshi <j.bhargav.u@gmail.com>
---
 Documentation/devicetree/bindings/crypto/ti,omap-sham.yaml | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/ti,omap-sham.yaml b/Documentation/devicetree/bindings/crypto/ti,omap-sham.yaml
index d69b50228009..3ef05890e13a 100644
--- a/Documentation/devicetree/bindings/crypto/ti,omap-sham.yaml
+++ b/Documentation/devicetree/bindings/crypto/ti,omap-sham.yaml
@@ -13,6 +13,7 @@ properties:
   compatible:
     enum:
       - ti,omap2-sham
+      - ti,omap3-sham
       - ti,omap4-sham
       - ti,omap5-sham
 
@@ -32,6 +33,7 @@ properties:
     description: Name of the hwmod associated with the SHAM module
     $ref: /schemas/types.yaml#/definitions/string
     enum: [sham]
+    deprecated: true
 
 dependencies:
   dmas: [dma-names]
@@ -40,7 +42,6 @@ additionalProperties: false
 
 required:
   - compatible
-  - ti,hwmods
   - reg
   - interrupts
 

-- 
2.55.0

