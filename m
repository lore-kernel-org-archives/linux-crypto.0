Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BD83E8688
	for <linux-crypto@vger.kernel.org>; Wed, 13 May 2026 10:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778669892; cv=none; b=nOsz8ZJcVN/BDBULXYutNsC26eGwia6SzOyVq/F26p6k7q+2DEd15mNocaMFIltR3En1jKkNspy+hbxVJjKtR+NFrhIgk4BG22XqeFztALtSTV1qejca2TksoHqHed2bapDuLMkDV3D/I0rz3PSVNicE9dP1xBzaiDy9pFeWNlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778669892; c=relaxed/simple;
	bh=ZV04lyVPArME+npQY4qcyNI8K6Mzz6Qn49etnV7UOjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QnQVzA8YPo7H85GZed3TeVb1sx82w42RJyhpPeiR797BSYVLs7q5wRvHW1QAjTKKixqYDc2qwH8jWEcD62XGod7pAJTP1q53jJ2MD9LCcZM3+Ptd48ok0XtfIla9V/KJ6r5Dp3go+drrh9DvWTs8bvWM9VPClebJz5kw1+J4HXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iEiNA0Ox; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iEiNA0Ox"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-67b32c695efso12088989a12.1
        for <linux-crypto@vger.kernel.org>; Wed, 13 May 2026 03:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778669889; x=1779274689; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2sLwoHvJvcfpvNr/4u698QcTPwR9URSepxShcHXDFhY=;
        b=iEiNA0OxKWjF86ugkka/LKfu/cPv7D/1pF7FBWSTF2DAgdavpAb+9ef3JvGDpDJ7ue
         zdIhgCIZ7CTRxOIe35rACkC9X4gtKXtEaK/9jThUNxlH2maL75wC+0mDG0Z5mekeFjSQ
         aWqK0/fCT0RVmHNVzoV6dfGldQkrd5reWR7RtHMj2IpVOvCl2X1NDmfRVQqxct8QleJG
         QcYhMgBxpA/pSGYiYNPR4cYvjs7gL+8Qzb9wZIY9dqYAhFdyqMyhhsXc4lV9g2+StMil
         39Wpf+8PZbhGCMG2PejWYB5Ixi0QRk4kqfIT+rvgxSYcN56JbvhINO4oWUcJgKEtVjPh
         S/WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778669889; x=1779274689;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2sLwoHvJvcfpvNr/4u698QcTPwR9URSepxShcHXDFhY=;
        b=G/eCuzTOLen+XK/wfMU1xMY4Bu/+Z5rm3RKJI0ponUG4oaODg/Hzu22SdvRunHK+jt
         RCVQqk3SSxx9RHTUDh4HIaM+kVknXWv4x79u9lHlS3yFmqjWhNC5O2ohUuEP7OPsf180
         C35ivUEhtx1tAMUKW8YZVIOGOOfIJE+Dfa3finP/2C2/j79qp/mzgvPGjwWioBSMCGWu
         kdmeywB1Kptj0UyhOhc3r25ijWHsNiAErsTYeDpFBzbGhQTgEqULa0pDnh0/wOQblTs+
         IK8Lf3DjbwzXgNdmw+nNi+6xpNlFZugSDrNztB9N0ATQqdb13q8b52z1tTE67r2MtRDK
         I3FA==
X-Forwarded-Encrypted: i=1; AFNElJ/R+8GeryXv0d4k0Sv0aJYAmyGJyw4VQg3TCxG7zYdVDFw23PIxI6LgSZxx7eoO+fzD4mUq1g/3Ituex24=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwYNw/4WWvgbHyLqaMfd8zlxWDeSd4kUNUGXPNGSSu5ESUaKRi
	LPwxanefyGFjBco8DXVjAWhXMLSeEZetAi13WvYygcNVFzmMWOoKDPf1
X-Gm-Gg: Acq92OHQZdW+jI+6X/tDnlarr2f2OP1mjBhvqrXO48+UjsFADgV+2aeZfKpe/FmIxnH
	yeDh8bMsS/IY1waPojPgviePJr78msWspUrdah/UbzjT04P1/cOvaiYe/EPLtvBo18WHb7dEUpm
	OWOGo2argFl/6Z1leABO/np9FLQZs1RUpy4fE4kTh9Wz0OTxVGcSmy1sM+0QosTt6mpLVYgb3Yd
	N5aKeghOMuMesjQ7Yr6cbMIQzcDCc6cYPm4ePn+362quAMjgrydNQzzYsiOsPIvH2t6C0cdK/5J
	2Ecm3mZhsIDwypovwrLWVH9osz8M3F0lm7FboNUBVbwg0zm56A9sHognV3SFKHi25toXDUuq6SI
	TbCOMxEwsbHniAYt0MVXjiVf0GjoW1+sSt9S5CGcXpOXN5dIFcouLhF7XT5sMoMthYka9SV4o8V
	PAKYi+TI+px+wgakAV3WPSeLRUvtZKRRwgCYtDJoOMkBjo6RbICEV8yb6h
X-Received: by 2002:a17:907:3e85:b0:bd4:7b9c:6f1a with SMTP id a640c23a62f3a-bd47b9c7479mr48352066b.22.1778669888523;
        Wed, 13 May 2026 03:58:08 -0700 (PDT)
Received: from svery.. (109-252-11-240.nat.spd-mgts.ru. [109.252.11.240])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bcfebf0ab11sm472188166b.62.2026.05.13.03.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 03:58:08 -0700 (PDT)
From: Anastasia Tishchenko <sv3iry@gmail.com>
To: Lukas Wunner <lukas@wunner.de>,
	Stefan Berger <stefanb@linux.ibm.com>
Cc: Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Anastasia Tishchenko <sv3iry@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] crypto: ecc - Fix carry overflow in vli multiplication
Date: Wed, 13 May 2026 13:57:40 +0300
Message-ID: <20260513105741.55534-1-sv3iry@gmail.com>
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

When commit 3c4b23901a0c ("crypto: ecdh - Add ECDH software support")
introduced crypto/ecc.c, it split the muladd() function in the
micro-ecc library into separate mul_64_64() and add_128_128() helpers.
It seems the check got lost in translation.

Add proper handling for this boundary by accounting for the carry
from the lower addition.

Fixes: 3c4b23901a0c ("crypto: ecdh - Add ECDH software support")
Signed-off-by: Anastasia Tishchenko <sv3iry@gmail.com>
Cc: stable@vger.kernel.org # v4.8+
---
Changes v1 -> v2:
* Rename add_128_128() to check_add_128_128_overflow() and let it return a bool
  indicating whether an overflow occurred
* Rewrite an explicit if-else statement using constant-time bitwise arithmetic
  to avoid a timing side-channel

Link to v1:
https://lore.kernel.org/r/20260508114844.29694-1-sv3iry@gmail.com/
---
 crypto/ecc.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index 43b0def3a225..6eb4d97a5f0d 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -393,14 +393,26 @@ static uint128_t mul_64_64(u64 left, u64 right)
 	return result;
 }
 
-static uint128_t add_128_128(uint128_t a, uint128_t b)
+/* Calculate addition with overflow checking. Returns true on wrap-around,
+ * false otherwise.
+ */
+static bool check_add_128_128_overflow(uint128_t *result, uint128_t a,
+				       uint128_t b)
 {
-	uint128_t result;
+	bool carry;
 
-	result.m_low = a.m_low + b.m_low;
-	result.m_high = a.m_high + b.m_high + (result.m_low < a.m_low);
+	result->m_low = a.m_low + b.m_low;
+	carry = (result->m_low < a.m_low);
 
-	return result;
+	result->m_high = a.m_high + b.m_high + carry;
+
+	/* Using constant-time bitwise arithmetic to prevent timing
+	 * side-channels.
+	 */
+	carry = (result->m_high < a.m_high) |
+		((result->m_high == a.m_high) & carry);
+
+	return carry;
 }
 
 static void vli_mult(u64 *result, const u64 *left, const u64 *right,
@@ -425,9 +437,7 @@ static void vli_mult(u64 *result, const u64 *left, const u64 *right,
 			uint128_t product;
 
 			product = mul_64_64(left[i], right[k - i]);
-
-			r01 = add_128_128(r01, product);
-			r2 += (r01.m_high < product.m_high);
+			r2 += check_add_128_128_overflow(&r01, r01, product);
 		}
 
 		result[k] = r01.m_low;
@@ -450,7 +460,7 @@ static void vli_umult(u64 *result, const u64 *left, u32 right,
 		uint128_t product;
 
 		product = mul_64_64(left[k], right);
-		r01 = add_128_128(r01, product);
+		check_add_128_128_overflow(&r01, r01, product);
 		/* no carry */
 		result[k] = r01.m_low;
 		r01.m_low = r01.m_high;
@@ -487,8 +497,7 @@ static void vli_square(u64 *result, const u64 *left, unsigned int ndigits)
 				product.m_low <<= 1;
 			}
 
-			r01 = add_128_128(r01, product);
-			r2 += (r01.m_high < product.m_high);
+			r2 += check_add_128_128_overflow(&r01, r01, product);
 		}
 
 		result[k] = r01.m_low;
-- 
2.43.0

