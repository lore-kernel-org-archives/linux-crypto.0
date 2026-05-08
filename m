Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5ED36D51E
	for <linux-crypto@vger.kernel.org>; Fri,  8 May 2026 11:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778240972; cv=none; b=HfqaMcAO0YSGA91PQv4ACdfQBHNe9Vf/p0c3wdwKDUGf7CVF9m27NJW7Ic2s5Kvdn0fB0jYKidcpMwGbm6i3IKLXr7xM1X/cx8Gf86DcBuye7slPp/jFeKYPgGMpRuhYUMpQqfqXHb4Lth/v/rxdDO9xlkVHdVIdIk4YzoOX9cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778240972; c=relaxed/simple;
	bh=Z+dOeoUVh4GN7xXwfzT4PipGR2w1MslUMmBn4kUlQuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q1dAiTQMcaGXpxME7IYJolpw68zBXD2GJ/MJM9eIm7yePVXFQcvfx5hcgj4NkPGRxhvcHw1TGYGDh7IAUKHYxfm9jMQNdv0XzuqkIhD/P2GbKsDyMlzhbMYVn4aEwXt172w2x8hXn8Tp0eL6ZI0TXw/axBXMaWpYGfkqmX3T1sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LYMVzKeC; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LYMVzKeC"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-393da8f389bso16655401fa.1
        for <linux-crypto@vger.kernel.org>; Fri, 08 May 2026 04:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778240969; x=1778845769; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wBVIuGPalW20UUvV7tEQr4ZoKlf0MwtNwF5pPYAVLWw=;
        b=LYMVzKeCtp0qdzrKtavtxK/E2AutnNAVM8yELSC8GyQTYF8KNVYDxsT6qaexs9qNOz
         b/lsJg9MQVYsf7juaoYmzCys7kjLWBBoEPGouAbFWTpxzD2pFmkOGzuPpZ86OdFTKSda
         CviXUPMtjmWp+UkrBJqqRxZ9IOGBOdgC6b5VdY1LYhqBf+dabi/agKWQeUFYNA1d+sAD
         iLXXPDUC5/+ahqDViyRq4kcT7H5ZQG+WDQz3EOYj8OfEOnM5PeQqHyqa3Tv610EnGFDf
         NMYjgqcNnsHzoxv2QPqHexp6o8UAInWVXJJjy9LLKfrJEEg8Pb7VTIUoQW2NSNcDFIXI
         79gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778240969; x=1778845769;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wBVIuGPalW20UUvV7tEQr4ZoKlf0MwtNwF5pPYAVLWw=;
        b=o9dIOe8A26mU35YVZV83FJAfdbbScrb5ARuT2IdYVFxtGNL3j+BGHKu16iy2pmoHjh
         b1RoNZOlVziMOplX32QOhK8cXdj/4Qbkg+NT9gZhIyaW+gJCyVoQpbkZ3U8fhRFK6h/t
         AjJdfOzwzhtOgb0RHtXHW2BW+sK0Mlqgwk/KOommYve8XMNQlBW4YXAbzqWUbLd+E6lW
         RHkHWadJZxKwsBiZpgnTg4b6aosB7/jvGCVUGhCtRAl7Ol68O9GTaky8uRbCxGyhfiWj
         Sh79dSR5aP59w6Cze49c9YINo4G/eTgeDX5K77YiKfrizEhJtZPy00Qu8WJjp9uby2fi
         WGmA==
X-Gm-Message-State: AOJu0YxBGMZ9IbpVHpjHd0xA1YQI+xGK0IbD20PJ2Ru1FaxkVlkWiNeQ
	ELEaP5P83tbpAM/8qdge1cjSqTnYxMgCeABbGgoGm9j5FB1l6f1OSBRH
X-Gm-Gg: Acq92OFFgMDMgpi91rkCvDZ1qrQ6EPMOWSss11mAjmBl5J1uW15fdXBFdIgm8BcjAvk
	ny/eUwu7Jivd5AyUEAdhsa/geNwWJjbGCac7qnyuv73sVI/3XfJqo0cqtf5xK2Kk9RGK5X2WrA/
	vgNfepJakxpn5MNN2WRU3+/5O09xhUIGdV99nMYqX6q5MaO/kdRv9Ck86NVNuYMCvUFNW0PhV/l
	/x6sNFBkJF17vdprmA7zEN7v5zh5CsOTicOXtBHuFk4fam9ptngYMZYh0WQMdrw5w/LYN8XXI5V
	aONtZdcw8lw/7eT4uDusULCqKTNW2CqIYRx/9VWqmtg6K+5Xr6pXkCsMs1wh1EYh0GKmIIjsxiB
	cMEHOMEqAK9i1wYQNQ7Nz18VDe5c4DyvMpETZLQHWMz/MAaN5EdanrfxpbSw1L3Hh1xrMJCN/gT
	a3ZaS7Hg3Kohr3j9x7B/jaWTJTGFyrLih5CC+GqlNRuYi1ag==
X-Received: by 2002:a05:6512:1304:b0:5a2:b3dd:7a74 with SMTP id 2adb3069b0e04-5a887ceafc7mr4536300e87.33.1778240969424;
        Fri, 08 May 2026 04:49:29 -0700 (PDT)
Received: from svery.. (109-252-11-240.nat.spd-mgts.ru. [109.252.11.240])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a8a956bd58sm449992e87.84.2026.05.08.04.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2026 04:49:28 -0700 (PDT)
From: Anastasia Tishchenko <sv3iry@gmail.com>
To: Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Anastasia Tishchenko <sv3iry@gmail.com>
Subject: [PATCH] crypto : ecc - Fix carry overflow in vli multiplication
Date: Fri,  8 May 2026 14:48:44 +0300
Message-ID: <20260508114844.29694-1-sv3iry@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The carry flag calculation fails when r01.m_high is saturated
(0xFFFFFFFFFFFFFFFF) and addition of lower bits overflows.

The condition (r01.m_high < product.m_high) doesn't handle the case
where r01.m_high == product.m_high and an additional carry exists
from lower-bit overflow.

Add proper handling for this boundary by accounting for the carry
from the lower addition.

This issue was discovered during formal verification of ECC functions.

Signed-off-by: Anastasia Tishchenko <sv3iry@gmail.com>
---
 crypto/ecc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index 43b0def3a225..dfe96471407c 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -427,7 +427,10 @@ static void vli_mult(u64 *result, const u64 *left, const u64 *right,
 			product = mul_64_64(left[i], right[k - i]);
 
 			r01 = add_128_128(r01, product);
-			r2 += (r01.m_high < product.m_high);
+			if (r01.m_high != product.m_high)
+				r2 += (r01.m_high < product.m_high);
+			else
+				r2 += (r01.m_low < product.m_low);
 		}
 
 		result[k] = r01.m_low;
@@ -488,7 +491,10 @@ static void vli_square(u64 *result, const u64 *left, unsigned int ndigits)
 			}
 
 			r01 = add_128_128(r01, product);
-			r2 += (r01.m_high < product.m_high);
+			if (r01.m_high != product.m_high)
+				r2 += (r01.m_high < product.m_high);
+			else
+				r2 += (r01.m_low < product.m_low);
 		}
 
 		result[k] = r01.m_low;
-- 
2.43.0

