Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795780928;
	b=paE4YfA3zf1eyR8uyLRovjR0uT2mNPtzDX/vxn6jMx6Aq4uqlh0IV57pb2iWfN3yqRur
	 +Wg6Vyf5rQrCCQXz8bKj8Zq3nIS4K7P8mVnQxhIQx3nxby7jVEBbmTJSyUuleXzbWMomr
	 VToaIjWFq1Ppb8iYD90sQZLcrzUptVwS4LIkO4ik52wuAj2tVkPqOtSEjJJ2izHcrWAsw
	 iL1RhozwZTXmf8JCtFfn81UnVPuKKtWpXNKgFFLkr9dEP/qhdXgmxLGL0IUd4kGQZPlt0
	 DbqI1gTwA2dMJ2yvsDwBHWSvUNr/aed2nlKqzbrOARj9YfFvdq+gKoeJKxEO+bvCeLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795780928;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=QCpB4RhzNL1T4jjBraVD8Rve99tT2QYwwNJiLODS5Wg=;
	b=rzU4uJce1132iRdo2eqfFTdsg745GnkphtMT/sw3A39+VOBuPW/cFGkWadmptzCKnVoM
	 QfvzsPas92+HwQ2VG6hRAhKg6NQVEhPGUfC9yEG/24tKcVDK1TDOHG8sS5iqqfb3oIsop
	 N9qsHQPxjRU5V3hQNdG6IKPodRubIrNSXvSdmo/B0z7++dekQbtwRC9v550sLVY0eCWEI
	 rb3cNNLPMbh8uItYfNKCVu3V5brx2W7XYp7GnqgxyEn9pfojzoLSCApWlka1L06vXhn1f
	 f+4wH8snKuRY03ks/fGZbaAbmIi6KLfpeYMXUkjRomGOOZPqdwKc0MP3fBByEdI39ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hPEdgQnk;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5F4606A333
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 12:02:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0A5F4606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hPEdgQnk
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4bba5e17cbeso26147215e9.1
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 04:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795780926; x=1796385726; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QCpB4RhzNL1T4jjBraVD8Rve99tT2QYwwNJiLODS5Wg=;
        b=hPEdgQnk7ry62KfQpzuBm+Pev6rVBz56dx7C6t/Hkuz2oWGJKdGQTN4W6rQZsOSP8X
         L6weDKWxvj2upp/8ZYzsynmaAiTr8V5/UIZSI49GG9h6UjXtqXWcrUAg65PDW2OnmdGI
         gd42U8hzgIPOpZwOkjGM4v969ZEaVGae0Ne343M6bSjqjkM1GxGItW0AgfXVTV9+SzWv
         9xVUcGPf6VefO9gMLlvaDEx5Hw5J+tBFOVRkow3xiQ5dV9rzBjagYQbgKmnlTZKy/obg
         CTkri4Yoxk1/ugC7oE61KMxWLwCpZulo5FeFiWQDOAJf3VnT6CKOVyrbr34pZEvqBxZt
         kj3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795780926; x=1796385726;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QCpB4RhzNL1T4jjBraVD8Rve99tT2QYwwNJiLODS5Wg=;
        b=QjaSU6vXFCKYMO0CcjrrbmP6gzeHtizUagzrBTUzkcqaL3kBZeyQ6DqeXHEqT9qwNG
         M4DuHiuNfVUPrgPmvmVyknxbMRzYCMii8m2voEh2HlGZ0US2vfTuqOaBx6zVX360i2NE
         Ix0R7z56CFEsIrepsnf+hXWc9/oacFF/Fs0TsmPm0cdK6pxXwBqgWVybhGEbtepJmb/K
         NgsPKHTt8ZqRJg8Dap4IvtWK9Csw7JDwbWDy+XV93VgUs85Id/EfamvVA/P7D2ofzIy4
         LJO2573MKnqiczN5eRLLhiP8hiEbrkIG4eF+hpfpxJ85sfzuH5YyXhsiQCAgpgJ3qWm1
         LOiw==
X-Gm-Message-State: APuU4Z9Ae1zruomnCOsdVLOuM2fgEoZftWF3iTR7EvJjxV2ggJt63Mym
	OZ4lX/fS/VLl4eaZs6E7FT2lkWvPvdADU6vf64gC5OkGiPnNye/6fWdF
X-Gm-Gg: AZFdTZcDT6d4OGc/iovJT50g3CC20rjmyLIbuDiA6mpSqguBM2kgdQGJvktmEeel/MS
	n+Xd7Hwr9462hkIqut8HDADF5mO38W++5otBc+nunhaxk472TMFh3/76jwldb83ACI2DHbE9T2D
	JKx0sZDy+/7b74WvyLSTQpeYohdSpMO01dSVC/qzhgm6OQR+XpT1wm2Y325ZTfbLe7hEOpQcQ3G
	IXoGdWhb/auxOj/LRfPjMXxIkzuvURoDew76PnFmG70OKpMtfM7gMgbf0ZvDnrU/GnOgOO6162+
	IbVnpHhActB92yYfPxG5PqCvcNdMSyFfCPd/Gku3oUPVcLZn6ujhTFPuNnHbQzcjit8+bVSb0dm
	23ecxN7XgzL5lu52PPdZX/1L22JmqXgMb0/QXszydljouTyWs/7Yco2JrQNlGXw7Ga5wXJhhvbA
	Xkz1QNTPJOhq/S/llWEKz5tdNNBIH5VfDkiPF6OeMNKntg/3jCOR/eLSvZ2XW5IkeNVdsv9LUV/
	fKusQ3PSnr/aBVelxevV1tclX+EuqEwI7yPUXpjyxiVfmkiWARFo01z7wuSbpZKvt/IEBHFKOzh
	iCXdQh7Texy9Y5KZWhUpmkPVt3Vl3UoY
X-Received: by 2002:a05:600c:6749:b0:4bb:5f95:c014 with SMTP id 5b1f17b1804b1-4bb8880f283mr492027085e9.19.1795780926108;
        Fri, 27 Nov 2026 04:02:06 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906640a2sm393684565e9.0.2026.11.27.04.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 04:02:05 -0800 (PST)
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
	Jose Nieto <jnieto.alaber@gmail.com>
Subject: [PATCH v14 26/30] dt-bindings: crypto: amlogic,gxl-crypto: keep standard property order
Date: Fri, 27 Nov 2026 13:00:59 +0100
Message-ID: <20261127120103.1532882-27-jnieto.alaber@gmail.com>
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

List clocks before interrupts, following the usual ordering of the crypto
bindings.

Signed-off-by: Jose Nieto <jnieto.alaber@gmail.com>
---
 .../devicetree/bindings/crypto/amlogic,gxl-crypto.yaml | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
index 106a9d1fed69..6f19e790ec0c 100644
--- a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
+++ b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
@@ -25,21 +25,21 @@ properties:
   reg:
     maxItems: 1
 
+  clocks:
+    maxItems: 1
+
   interrupts:
     items:
       - description: Interrupt for flow 0
 
-  clocks:
-    maxItems: 1
-
   power-domains:
     maxItems: 1
 
 required:
   - compatible
   - reg
-  - interrupts
   - clocks
+  - interrupts
 
 allOf:
   - if:
@@ -61,6 +61,6 @@ examples:
     crypto: crypto-engine@c883e000 {
         compatible = "amlogic,gxl-crypto";
         reg = <0xc883e000 0x36>;
-        interrupts = <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>;
         clocks = <&clkc CLKID_CLK81>;
+        interrupts = <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>;
     };
-- 
2.47.3

