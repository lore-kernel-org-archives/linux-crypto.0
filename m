Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD52E32C309;
	Wed, 20 Aug 2025 16:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755707192; cv=none; b=P2fFLgTV7un23fDrXD1HkIqwDE9QH0IOO1HpnPO2ZEZd+IkflBofOT6MG/NF02s5mmRGMRrgzdbJtIpuwnNc3V8INcBzVL6/KcvApYpOKEvgedJm8A+cq6KI9fR0bgYt7K+xy/WXQBkx0ZSKzApCyPRyNu1bQzjoWaRtYLq0A7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755707192; c=relaxed/simple;
	bh=8oPIqiG4ntZOWMYINRbk9WB/ipFpfqMstSUkt6wUX+k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u5RrtaPGXKXMj0swhLDFC1HJMlyimTEoBlee7Up6vduTlAFu+IHgbUf3VdJ1ygr4Dbp6YfPzQMyuGtvSlLyWYjfT9E2CeAPJhUyTiWBAY3U+yO0VTAMEexR7f3y9BbvU87vyfJT543CjDNFwAiqiaY+EBFKJqwWHCcXxKifZmoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RShs4rSZ; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RShs4rSZ"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-76e2e60433eso112381b3a.0;
        Wed, 20 Aug 2025 09:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755707190; x=1756311990; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1JlCSqIpeuA9FbNX9xQCGajhN6Uvq3tUKfZpcELoMQw=;
        b=RShs4rSZwKML0TbNyT8WewVebPkJ5oWKe1+jWH2gbEyw3bTFqvXN4fpa13JY7VJTF9
         1/oXZxtW4N/6xWzsUVg3qmWuY4JPJv4T6GFXCwZVPa2HaO7Uf4FfSS7R4H+8OAOVqsom
         ByH1GsXHcYSfXK6td4ZcpPzjCHz42t7/QhXFWxti5Ye26YPYV14pBEPzbH3eN6BUL2+Z
         rDgVI0l24cwNFBskvikTMhtYFVaCrzd1aBDFT+4VABc1IOSDZqPq7lzVF0qa+cgb/Yrw
         rXVx29drgUdk9YF08TBp503RLTI9j8cotQ289Or/6HfSXbxyowv6MGAAN89C0EdWOyg5
         shcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755707190; x=1756311990;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1JlCSqIpeuA9FbNX9xQCGajhN6Uvq3tUKfZpcELoMQw=;
        b=B6OysWZGJ7CNtsdD3SdHmX0LOot5ZHFCThw4kZjADvEfxbKYg39lxeleJDzOtK9odk
         NODPWdrm3RtstZjBXdt20vHyjA36HXFT45NghdvkKeo7zeKXhje0GVvly2Vm8DodIaQJ
         oEhB6JHrdTO6/VJRWQ1CWiQK6FqyYjnFIAj/9sncXR80nNPoGNUaJgr248R6KaPU8fKV
         gp8UetOAPG14cB+3AORB7HI8ZVCsFCe+iHLGjiJOUdMEMEsbuM1AO8jP7jPpqD1iPiWJ
         2jJQrZ2Ie7ypwB1Xl4zJ8ZAsWbcyPkY3qDaZtmBS7J03vDepobrSyycBT21cHDpEHCYd
         XV0Q==
X-Gm-Message-State: AOJu0YwhyCwetU67hNnN76omXO3CUsmSAXMBL9g7RsCGqyOsYXIVN2GD
	61TR/6C8Z0ZSkCeioxMvrsTGmN5SgJrslbFwnipsFXktIlhjoWKys7QpUXu6QFM7lME=
X-Gm-Gg: ASbGncvlM6qTkbQgYTnq0XPDst2Ub2OvaI3PUjz+YSDU+oBZ+8nDq5So0DOyHdaK1GI
	tP0FT+SLHsdT9kNHVe62K5CUF+OKKFRyU5Oeo6RTY+vyoQIxqjP+AMsw1Y1Ryb1L1KwF6GfhA7H
	bSvgSE2V3AS3WXIDo+FULvYhqofalUnBr1rKl3DTpdSF3iLsn66k4USnw7ww64lU06Uf6qzvScz
	wu1SDcAv/N5KqrVukFjpXCuxaeSx8oYf+k2Egs3DP499x8hzt6JlU+AwS1G2WY9FRjlLdHDrPRb
	RtxR2BDE8Oxk/OVoC1+sdSoQc6pwCO8/JuVMdJKyPXdkzdwuk4MgNCHfHVeE17Rx1OA8PrGgq1d
	+lSafLUVtoNX6MZcd4KOUrgZLLuY=
X-Google-Smtp-Source: AGHT+IHlSK8Vw8sNsci9qKa77jTzlUH61at+9I/+QWwGNiiFlEw1sPTVzQmBmtVcMiFGNtbk3AKwlg==
X-Received: by 2002:a05:6a20:7f8a:b0:243:755:58b4 with SMTP id adf61e73a8af0-2431ba780bdmr5131502637.53.1755707189673;
        Wed, 20 Aug 2025 09:26:29 -0700 (PDT)
Received: from lkmp.. ([49.37.163.128])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76e7d10fdd6sm5849297b3a.29.2025.08.20.09.26.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 09:26:29 -0700 (PDT)
From: Rakuram Eswaran <rakuram.e96@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: linux-doc@vger.kernel.org,
	ardb@kernel.org,
	ebiggers@kernel.org,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	linux-kernel-mentees@lists.linuxfoundation.org,
	rakuram.e96@gmail.com
Subject: [PATCH] Documentation/staging: Fix typo and incorrect citation in crc32.rst
Date: Wed, 20 Aug 2025 21:56:13 +0530
Message-ID: <20250820162615.6942-1-rakuram.e96@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In Documentation/staging/crc32.rst, below errors have been corrected:

1. Line 37: from "to being" to "to bring"

2. Line 119:  Incorrect citation date:
   It must be August 1988 instead of August 1998

Signed-off-by: Rakuram Eswaran <rakuram.e96@gmail.com>
---
 Documentation/staging/crc32.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/staging/crc32.rst b/Documentation/staging/crc32.rst
index 7542220967cb..64f3dd430a6c 100644
--- a/Documentation/staging/crc32.rst
+++ b/Documentation/staging/crc32.rst
@@ -34,7 +34,7 @@ do it in the right order, matching the endianness.
 Just like with ordinary division, you proceed one digit (bit) at a time.
 Each step of the division you take one more digit (bit) of the dividend
 and append it to the current remainder.  Then you figure out the
-appropriate multiple of the divisor to subtract to being the remainder
+appropriate multiple of the divisor to subtract to bring the remainder
 back into range.  In binary, this is easy - it has to be either 0 or 1,
 and to make the XOR cancel, it's just a copy of bit 32 of the remainder.
 
@@ -116,7 +116,7 @@ for any fractional bytes at the end.
 To reduce the number of conditional branches, software commonly uses
 the byte-at-a-time table method, popularized by Dilip V. Sarwate,
 "Computation of Cyclic Redundancy Checks via Table Look-Up", Comm. ACM
-v.31 no.8 (August 1998) p. 1008-1013.
+v.31 no.8 (August 1988) p. 1008-1013.
 
 Here, rather than just shifting one bit of the remainder to decide
 in the correct multiple to subtract, we can shift a byte at a time.
-- 
2.43.0

