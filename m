Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD23F307AFA
	for <linux-crypto@vger.kernel.org>; Thu, 25 Sep 2025 16:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758818452; cv=none; b=g9BmATrxYYQtYacGHXSmOSMm/2PXB6RsCBRULN0pC593EBfY2tNjGs/P9KVSYpFNzU9IsQUJcvEhCRSJfUGI2qBW/vxByr936O0+HkH23R3ZNekdks8WVPq7DXjCTytc8BBhavDKtZPN/ueIxKuZhbJ8IYlFfpC5nF2SqMh+5nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758818452; c=relaxed/simple;
	bh=5uSR4NDN/aBsd24THGZvPsdUrUX4xTeH0oi/5l1dY5Y=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9cB6XJohh+EOz/TWNE9Y6HTcLpra+79MJDF9P1kHU81mo/glFRezLHK6MK5ME8C266/cGwhp4c+N7tBfROCxnlxJNB2mYKywwNrfy3QRHAvEEGTAHtkjykaxnq23twiO9UCUuiAGkt/DqBV87aLRnn+ceX+Lao/dA5q9DT5Jr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k2CgI8rh; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k2CgI8rh"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3ee64bc6b85so1146818f8f.3
        for <linux-crypto@vger.kernel.org>; Thu, 25 Sep 2025 09:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758818449; x=1759423249; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k4zaJq9JJc/9ryK6cY2Xn8ASZ9hmcyfG8y41VjWW8NY=;
        b=k2CgI8rhkCMTu/2Fr1Dh8tcv82JbH4ZgDFX1Q4Ee7Pg0oxEvu6D6wbQv37XQ3ypxsP
         jNaIGdXt0YKXBUA7cPguKcXb4J9AvGehE6wXA0YBZXs8sjDtyuEjrexGdjFWdLPGKkfq
         BSSOF6DgnNWnnaoN39p7WYPook+azDZVSNugF9/i/kV3FK8vNOSqA61xBbRaJ+qcfTyZ
         IyPEGsY732RpYBONwgC/e5LKZTcNrqzzpQriI7/T8go0IexjQe5/Le3J0neFnuhEm057
         HXZDb4Y+utK3U0kI6xVvYpv/lsR3/j8SV6X/424ae+jKQU48uL50UusYy0RI9WNUbSq2
         mKqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758818449; x=1759423249;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k4zaJq9JJc/9ryK6cY2Xn8ASZ9hmcyfG8y41VjWW8NY=;
        b=i5Gvhorf31Twpq4wzMC8kVlvIDPFFutBF6NtK7kEs2CknivLk5+pxZ6Vr/6Enz1kcV
         ZyWSTB98eXXiJScngKjPhsSWSnNcTw6TrXbwL+NqMfmz5N7AxDbBnELfHrL/3/08aaOx
         cyAkNCCkiUiv70Me5HEUCZB8+62ClgTIJrLFj1oqRw4XFakujvvQXitzlBuOAAnAyW9y
         UC1rCmCHMb32ffHSvwFRtx5/93F0oO1iumPmg6+EELXmm6cq0/Z+mLLsOsxztwPVdKwY
         W+0gsRwFa3/QMlJrwaLIb4m5Xi3ck3yI/wDf3fhoxtqXY5F9thmvP0qPyQ8ndlfiAHb7
         YGEQ==
X-Forwarded-Encrypted: i=1; AJvYcCWpc1oX7p4XQ6OkNJPgowEEU6mO5OTBgg+EjBJrwqvdmM/QFjwCZuYCUnu00HmQipOJ2MmTgxA4RXl/bQ0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAclK59hE5RP6raUnW1BXfzmbET8oIHQcnTFr16ri0zr1F4BXa
	8Oc0qiVawx1lBkWdG+jTrmN21g0YcoeZy89CZvAhHbsGg9F96Ycq8JUE
X-Gm-Gg: ASbGncuPy/TeB3f0pgFpZyiD2QQUBkhmKNV9XJSoDas7ekZhuOrd3SwS1POu4kLi6Bb
	3ku7enkG3jGrBckal0+CHl8HkjD5kwLpFrtEuxErcz//zDyEnPdyyDLoEd5fQHMkfm/+C0cjrv6
	/qixx69PMsHeaEumusG/+JJBLxep6QY2G8PnrOO9QP6cVRoWT0K95V4QXGXNNmj634cLKm/OYEj
	mLYmn9ptgd3DoHI5usTJfpRdvFNiPXWLoyFsP/hI7nGEb0G0u4mjF/D8ZCzyVXkFbInSnWJMUX6
	IM2RZ3ppxjl/TyIB0kqGFlsgxPWu6Bw+bdHPrUrmkagDCBRYPyTb8rYVWwfkPMM5Nu0UBsOcb5A
	4pc6f7unDcSbqrVHgGikRooY5za8AhQeQ0nnMLDWu+zLXiMQMZydQ8mbFQg57WN2Y8H2PFtk=
X-Google-Smtp-Source: AGHT+IETYpPO9LAGX7zUAqFXRCr1IR36jr+nRkmsy96nynVShQ03CfruIEzXhdMASLXdFRjMR/RaLw==
X-Received: by 2002:a5d:5f52:0:b0:3cd:7200:e025 with SMTP id ffacd0b85a97d-40e429c98f2mr4337564f8f.5.1758818448972;
        Thu, 25 Sep 2025 09:40:48 -0700 (PDT)
Received: from Ansuel-XPS24 (host-95-249-236-54.retail.telecomitalia.it. [95.249.236.54])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-40fc6921f4esm3591904f8f.44.2025.09.25.09.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 09:40:48 -0700 (PDT)
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
Subject: [PATCH v3 1/4] dt-bindings: crypto: Add support for Airoha AN7583 SoC
Date: Thu, 25 Sep 2025 18:40:34 +0200
Message-ID: <20250925164038.13987-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250925164038.13987-1-ansuelsmth@gmail.com>
References: <20250925164038.13987-1-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add compatible for Airoha AN7583 SoC. The implementation is exactly the
same of Airoha EN7581 hence we add the compatible in addition to EN7581
ones.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 .../bindings/crypto/inside-secure,safexcel-eip93.yaml         | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
index 997bf9717f9e..2269d78a4a80 100644
--- a/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
+++ b/Documentation/devicetree/bindings/crypto/inside-secure,safexcel-eip93.yaml
@@ -30,6 +30,10 @@ description: |
 properties:
   compatible:
     oneOf:
+      - items:
+          - const: airoha,an7583-eip93
+          - const: airoha,en7581-eip93
+          - const: inside-secure,safexcel-eip93ies
       - items:
           - const: airoha,en7581-eip93
           - const: inside-secure,safexcel-eip93ies
-- 
2.51.0

