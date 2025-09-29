Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C67D305076
	for <linux-crypto@vger.kernel.org>; Mon, 29 Sep 2025 11:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759146574; cv=none; b=g08OkQS7IMn0uOqfoy0tKJyV0cWtlv+Hz4VND7rODu5DhDJDiNcmoTeGUxPlT463K4Zaz5dJOfGVuHNMOe2pdZxhEJtFtffOsy8gxOMqdHxYpBOT3EfODtZ7uDqk892q77D72ceebiAYhEviIuYPVKo9xQxOUFM53/bXOfBk3cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759146574; c=relaxed/simple;
	bh=tXM1CxOM4vCqq8YBToQQUXlfse+Xjw1zD+k6o2Xtvs4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BUV7IzZq8kwCJYV8NRIaOif8crIeMJok8bvSfatgEFonviHwJPP91V78RKwxm4n/KtcVisiS12xx1g0wgZqbmUPcuQhFwWHpY24zT6u2jQvrmFAN9yDXqzOxVAutx0/Cs9Jov5Ok5Pmlb02b/nubW4Cec5WK4S5aepfWCuaZiTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J5HlwL4k; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J5HlwL4k"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-46e3ea0445fso15777055e9.1
        for <linux-crypto@vger.kernel.org>; Mon, 29 Sep 2025 04:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759146571; x=1759751371; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pIsMYN876VGoFoSvGb+9plrH+kv/tFGDMPOel0bH+u0=;
        b=J5HlwL4kNc05SZ9J6SRAi7OwzOk5KM1fTOB5GEXLyQwIRsqW2488L9/EKyzSiLGDY/
         dY+zVpAyGv96Hcp0Qv2nM//MeW7bZLMWa16XcHHZg7JOIiqzNgRIuPDBsxU/I9g3hPRl
         jGeHaTGVqPLpdY4Vr4C8LDBbfjNa6BQfDF/MSyz6fkdEVlePBtRNvBtNe24od/EXKOGc
         +ooNMv+A7BuvRoWnfY9RDab9wqyuuIF/8JA2OldIJ5925+A7HEFByKZQEbVzbaFphAC3
         ZHCRGw2qOX5wl/aoc3Ll7qhkFzRIn6dm7hCGRn02KAm33CrbEVel4r640tjCAdJe+ZeE
         t/1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759146571; x=1759751371;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pIsMYN876VGoFoSvGb+9plrH+kv/tFGDMPOel0bH+u0=;
        b=Ze4pt4I6s3lzDeiHd3MlSzPDBBC1YwN0q8VQ+I7FSTFvUidnFjp6IgKQtoYZqQsPzU
         YH3tVIgL0yPEBiyqcZzXVAGFmMWzpCeTPVXLdXeXHtQept9s/+mTwplQGP+8/cz+vcyq
         XANgx+QunX4b6l/uH440Ey04CXCP6JKKhPVa2UUN+zwdfhF6q5Im1Sj9hB3TlHUHNob3
         aeZxy+VDKdSIcABs8heUdsUSOFY+W7tnX6Pfjrhlevdam5FfUEEvMtorzViCBbxtsavp
         Nh4WWi8wHghyOGEGemxBhHC4npGjtYO35nqWI9VYS8RAXUnSmIjAjUqKpIkkHFyoKxAh
         PRRQ==
X-Forwarded-Encrypted: i=1; AJvYcCW9XkqMgznRx2WUnhNoVFUfhEuM5Zknsr/x2pZ9ILfguzm9CGevn0L995Rf8hgd0GZN1YtPcvkh15p8zBw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVZ0pknyK9mjOcGdCN1gh4820WPgrZxw5fSH+dNZNDWfBZTtXd
	kHUgODmP4dHPNCszuIcCXslTVPgmHIQ+GcEgKc/7NV7lF8mqL/PvfpfI
X-Gm-Gg: ASbGnctcku3AYWOePblAEZzlO0oDWtk8C8T3LholfUfcZ9ssRW+EGF0Qv+IVdKNOMZY
	9N9fA46LI8CWSeYqkgUTjBuzX1HIXhO9qunfCn8bTulq8FInGa8yWcs2Tm32bRtewVqrNkZIfMx
	vXQV8EBfbn1LkFS9QkJhO8WAYouodla/eqZy5EZG7q1wfx/kKg5NZCRFBSkOq8Qmap0YixONP2R
	jLaU6m3oalXQIg0AGOQEOJr0t6VnYAkUgQBGq+xRnXly70zQUNDKIr42EELS3KtYegTKnIgGOjP
	ExGVNM/ArLiAm6NwUGU6GOaDdZv7vVRe3xVwMQl4J9iqHNDvDmVw3tMv4/H++PHo2mmU3O9jZgO
	vvXarWkK4NT2LA7e7GZqR1BVch9UV1q6itsZmIC4gtay/ZykNd3uF7C0l5ViVWGT/0KuXohg=
X-Google-Smtp-Source: AGHT+IHF2CwXyWBOC4BcrLBbsAVVrnt/gxj/QYgegqRmUtsThNiGS8+anT8fVSz00MWmGGHmAtEBwA==
X-Received: by 2002:a05:600c:4689:b0:46e:32f5:2d4b with SMTP id 5b1f17b1804b1-46e32f52ec4mr147677375e9.37.1759146571403;
        Mon, 29 Sep 2025 04:49:31 -0700 (PDT)
Received: from Ansuel-XPS24 (host-95-249-236-54.retail.telecomitalia.it. [95.249.236.54])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-46e56f77956sm10030835e9.20.2025.09.29.04.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 04:49:31 -0700 (PDT)
From: Christian Marangi <ansuelsmth@gmail.com>
To: Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Felix Fietkau <nbd@nbd.name>,
	John Crispin <john@phrozen.org>,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-watchdog@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH v4 3/4] dt-bindings: arm64: dts: airoha: Add AN7583 compatible
Date: Mon, 29 Sep 2025 13:49:14 +0200
Message-ID: <20250929114917.5501-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250929114917.5501-1-ansuelsmth@gmail.com>
References: <20250929114917.5501-1-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add Airoha AN7583 compatible to the list of enum for Airoha Supported
SoCs.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
---
 Documentation/devicetree/bindings/arm/airoha.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/airoha.yaml b/Documentation/devicetree/bindings/arm/airoha.yaml
index 7c38c08dbf3f..df897227b870 100644
--- a/Documentation/devicetree/bindings/arm/airoha.yaml
+++ b/Documentation/devicetree/bindings/arm/airoha.yaml
@@ -18,6 +18,10 @@ properties:
     const: '/'
   compatible:
     oneOf:
+      - items:
+          - enum:
+              - airoha,an7583-evb
+          - const: airoha,an7583
       - items:
           - enum:
               - airoha,en7523-evb
-- 
2.51.0

