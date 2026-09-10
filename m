Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32B73D45C3
	for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 22:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789078340; cv=none; b=H9Hh5ZAHKSmTNMisTOw1c/zBXCx+Bc0rrBrInf+Jja7eU6CluFI6N22DOPWtqshiMHrYfxv31vuwIbItJ5N2ODq9BzWGy1DSVaOn3CB6UYhynzyWKFA5smJMJUCRLjlosp7ZtdgA52elUb5NdFTx2m4TVFeNaxlatL0GytJ7OwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789078340; c=relaxed/simple;
	bh=7eZ6MGYrn7UuTOMdMokn5OY5P6XozBWE80r9RYz8pa0=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=mpHZZcbH4bhYfqrzsUUYEj834q4T0zyu6nDz7oUI0EwWrRhP5xk2cF5X5ofn5UFaN34LhJBTqueKejnxu08FZ+KyT2+f61BaK3QZWDJHIiy1G0xZfu988sfqaQnmm33U8g92+bcGqIBdkgPDGlKl+DCJE4UJFhnUflJKC0VNrxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qgy/Yiyj; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qgy/Yiyj"
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-855ce7e3990so18884b3a.0
        for <linux-crypto@vger.kernel.org>; Thu, 10 Sep 2026 15:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789078336; x=1789683136; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=rIxoez68u6cYjUY8xm3+9MUMr1Da3TBEKdq2C8N2mec=;
        b=qgy/YiyjHbP7NT9NwyzQYaXOgwKg07ngmehhevd/YTY7OIrMZqWsdRnRuOlisuqk4D
         26MAi7C4V7qNia53Y+e9zzzCTXawzazS3zfPPoT1EieIWwxt7NZjPw8/F8UdlAZsKfw2
         UhjhK4Sf7nc/UKZhUFU5bvz+DrFsrq5kZyHqh8r8N4S1pkhR7X22WNZ2tLZuKs7ZU1Cx
         AqqL3i0g9SgM1TPHC8dfnql4Vt8cRYNVutJzAozEys2qDV13lzuo2zT4D46q15V6YBCE
         UKeA5gH8zQUcB0m6rLPdN0APchAvjj43zgxDYrLTvjaCmOTNscRXUw7Pnav+ZXEA1230
         vpLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789078336; x=1789683136;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=rIxoez68u6cYjUY8xm3+9MUMr1Da3TBEKdq2C8N2mec=;
        b=pri5T6NSp/O1xqbt1E1NBXte0UDPsQ34NbGwLQ9PWO/XRFu45CMqV2m+mfBM45OcTf
         TrrxW/S7snzyJGC1y7rsvlh+jZpWkf+SQuoifhN5mJ92dHYuGQPearKqb7RllgIEDJg0
         TLljd3S4nQVkfoIR7yKMC0I1YCrpRigEN+S6rLcvhzqhbyypossz/7GbAb/6FsvV5bFq
         +95KWJ7V0pkqlKoxaqWp17YAn4AY6jO5XUPNBn4yDIMwbA1vxgUeOYmxDsB4+Lg2Pdku
         jKF/AXhDR2ohlvpWeHt6Mc6cxNmA5lVHMGbSwSqOLuztxcVSqX+5sFPawD3zGU/YhFFf
         boAQ==
X-Forwarded-Encrypted: i=1; AKwUvBwgB+JTc663InTUGiRSJnz0l5bNboaN0wDXJkn8z5vZ6nd4IahkqwFd25ONHeUwIZAb0KC+PDTDKSRopwA=@vger.kernel.org
X-Gm-Message-State: AFuF++lRdu8usSQd6Wa2mla6wjX9plVCuPJwZGC5ap2ep+yEuiPKgU9B
	q+E+hciz9K0/LrrU+8fdrvSLl29U5Rt7PdHpIJ4YPPA4qBsL8ApffgRfPNVq5g==
X-Gm-Gg: AYBFou1AJSGy8O3+5llXYfQNXyZ85bHRVKB4fpwT/7OvCcT5OGPk+/NIInBJeJi4TeO
	XGxQJ/XKZnkFc2LmF6NayKpKAOQIf71I8k5t/kA9UfXFQb8m/3zRyilA7LeHY0sYX8i1jaba3K/
	vSSKvmRpIx8B76O2BFYM1mC/ltb7O7C/hjiY3pNkNWwyf9axzBrT1yhDi7l18EKWvoqrZUUWQLM
	1xrpCDUiVzMYGy3TfYA3HNt3e6MnU2ert4+JKqDZ+RfLrwM45c8dRBwPW9AiAamM+xIEFXj72lR
	Yv2ebLcy512g0J/i3+jBkmMvAobvjrbf27Kx7bO8FkcdXiDwVF9rkNxlLX97GXuzOxlztT/kpfG
	DMc5TtUe1pMdvRSJkNv1v8SBBUO1fa+cwcaBLOauz18tKwlwbPxkBQ9TB+3qrgTsCwVpv4JIrum
	paJH2tUgH+zL3mSGP7ZpbfMw511LT8wgZU9nf78eBsKlRmxEWKPwFEtJdaiFGLfsRzOyW3WDJyP
	+mPmIRxqggg
X-Received: by 2002:a05:6a00:4708:b0:862:ff57:7672 with SMTP id d2e1a72fcca58-86b3160fde2mr616320b3a.2.1789078336410;
        Thu, 10 Sep 2026 15:12:16 -0700 (PDT)
Received: from [172.29.212.252] ([2409:40c2:5426:e355:af9c:7683:e7ab:273b])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b291bf622sm171875b3a.27.2026.09.10.15.12.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 15:12:15 -0700 (PDT)
From: Bhargav Joshi <j.bhargav.u@gmail.com>
Subject: [PATCH 0/2] ARM: dts: ti: Clean up OMAP crypto bindings and dt
Date: Fri, 11 Sep 2026 03:41:56 +0530
Message-Id: <20260911-ti-dra7-omap-sham-fix-v1-0-c430f01b4e13@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MQQqAIBAAvxJ7bkGNsvpKdNhqqz2UohGB9Pek4
 wzMJIgchCP0RYLAt0RxZwZdFjDvdG6MsmQGo0yjOq3xElwCWXQHeYw7HbjKg1Xbkmpsbc1UQW5
 94Kz/7zC+7weBa3bZZwAAAA==
X-Change-ID: 20260911-ti-dra7-omap-sham-fix-388a067572b3
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789078323; l=844;
 i=j.bhargav.u@gmail.com; h=from:subject:message-id;
 bh=7eZ6MGYrn7UuTOMdMokn5OY5P6XozBWE80r9RYz8pa0=;
 b=0GW3lQ5bVI6HMiNuEB6pRZEm6cBmM2Hx90bycEmsXp0jnGevSiA357/A7PPohTL4EXCeHrTfM
 LePfyEqWG9tDQTNk09aVTB7wgKgUA19zbRwzZJ8NvDgs9oMbdpdlepm
X-Developer-Key: i=j.bhargav.u@gmail.com; a=ed25519;
 pk=IqNDwUZKECEA+n8wXctFLBbYL9NhFstZNbOznm/nX1k=

Patch 1 removes redundant "clocks" and "clock-names" properties from the
DRA7 crypto dt nodes.

Patch 2 updates the ti,omap-sham YAML binding to add the missing
"ti,omap3-sham" compatible, deprecates "ti,hwmods" and removes it from
the required properties list.

Signed-off-by: Bhargav Joshi <j.bhargav.u@gmail.com>
---
Bhargav Joshi (2):
      ARM: dts: ti: omap: dra7: Remove clocks from crypto nodes
      dt-bindings: crypto: ti,omap-sham: Add OMAP3 compatible and deprecate ti,hwmods

 Documentation/devicetree/bindings/crypto/ti,omap-sham.yaml | 3 ++-
 arch/arm/boot/dts/ti/omap/dra7.dtsi                        | 8 --------
 2 files changed, 2 insertions(+), 9 deletions(-)
---
base-commit: 50d05c7c76c96b90462f24debacca971d2e86713
change-id: 20260911-ti-dra7-omap-sham-fix-388a067572b3

Best regards,
-- 
Bhargav

