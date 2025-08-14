Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC8B4086A
	for <linux-crypto@vger.kernel.org>; Thu, 14 Aug 2025 00:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755131969; cv=none; b=u6ajg69kQaLHE9Jn2GJjawxGJs3vZgQw/dw8nqE5Oe/L/bKD3Qr77Ch2I9JeXwhvi6D562eCrZX+/mfDAJ5PyBoNIVZEDd6MJqvJPxkmn7WTbqo2EagbApObOo8Tqqwi9Tlj8pJJkmf8yT3//nIKg7BlHu/U1/O+OKUGtbKkVos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755131969; c=relaxed/simple;
	bh=O7IE+ejSOePPSQi6gDfIDMTuvi1ufCtY/CJl7wpk1io=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=jUYmB98TN3uLh2SqMjYrEimKkKduPtZsQSzXDK4qsh/usDmrO35eT80jHU6IuYrO060S9JWvcrxUA/x/REFaENJdwAkDAq60lNMzmYmrBL/DbNOqr99i3Ecz+BHXF4pThnwWDKx/2H44tpPort//ZbCsS2ZALiA6uv9vr9opfzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=e1zTqshc; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="e1zTqshc"
Received: from pps.filterd (m0167071.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57DNgo0H000439
	for <linux-crypto@vger.kernel.org>; Wed, 13 Aug 2025 20:39:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=1lSOihfzUGPab8epdskmq6Brzg
	pTQgrtOKkOcbHMA0I=; b=e1zTqshcfmmIetIxYgIvE1s2fiMRTNDUhkcp2ZzdQk
	9Yx43lMqmITq5b7DKwKClw8E/h3zWdrMMQIyrC1Z+5SVPCOfa0FlIUqp11HTacbv
	b0ekAscil2+1D3frkLHcPzNBCzYtXtrJjwsQ+H5zJBTCgCGuAxPEPGZN+GfWDwp4
	8N2Zg//Jj447JUcbeLp9CdcyrXaHrXs8NQmUiIX88Emvw1fMZZzItR6N7zTCrKXJ
	p9k8cQB6a5fvK95SBff5qgF8OtJSj1YH2ysXKC1hP4p8h6Wadu5EXPTWwPJCLR6S
	J0YYNdNdknUKZKn+pt4BwBrZSpmDoB4ZouH3LfiFgsRA==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 48h1gdhhcj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 13 Aug 2025 20:39:20 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4b10992cfedso9829821cf.0
        for <linux-crypto@vger.kernel.org>; Wed, 13 Aug 2025 17:39:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755131959; x=1755736759;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1lSOihfzUGPab8epdskmq6BrzgpTQgrtOKkOcbHMA0I=;
        b=HaornQbeDVA275Ibh9Zu1SuJRFeISGh2IcZ6RJpn414VcsrfVgdofkItC+ASi4yKCE
         V8zt6wARpzHyG1kaAoyIgNgBuxwRtp8ICcZj/JjvD44QIuscF1sQvpWa22tHlrKGW7O0
         XsvHH18zRaFlHKzhBJw0b24TLGWaeHSuLsg7TvYGR7K+b2MhUfguSHT5Xn5nCG6X7bFC
         R+Ih7Dvd2/9Gx/SIvDIhO7f6AtZNlMEPEG28Bj5u9Qks6JIWIfvgPIP1MTgA5EV1C7K4
         APfo7CRfPrX2DB9ZiZmcz0hTgTbrM8WXV+3c2WqngmlyyzQ5lebcValehFLvB+Ecss65
         MAWw==
X-Gm-Message-State: AOJu0YxiFVN27Blyy0wiR6GBU3+J8XfiH3C5Y8BDYqDK0JYjE6bsqpL3
	y+tsyV0Fj6/wl6fSQYnjZ80eWSO9PMRSurPG2aMVFO30xH+D7Y1OY7znY0WdV4iC1l/iQA4uF0j
	rYQxEMCavuCG45sOuSRqF+G5N9/+oWmD9lGHbLtA6O0yEdl2h1nditdK9+wzd5GBWPr5MoETA
X-Gm-Gg: ASbGncuUjnAhXgKXWwN7/USkEW/6JDy9SZWUdo8X+uvw/lscJHKsLUhPoE5NZWMOAyg
	8LQqd0aeBaShu9aNt/QfRYaCUGCssB9iofsKlp9eKOgpYVZeI4FbL4sLvgEg7KRrjF7RO/YHdJ8
	3GiFutjsUAFAVyMYoH8zOEy2S85JZm3t1fmNsHZAozjLE2+nRBv7ojomPn43PT5UR1ENDb2KZ0J
	Ox8ILN/rd1OSHfgpihOFlHcHNcprHlzrZz0MMJiCHJH9q2Dxa+sOh3xgF6xkGQpgCvuwI17EIlK
	KrVuGr7jDx9oHiJCGgf5XaeRAt2kF6eBSEKM8l1tWyucnQknUsRKcaPeC28inoWloUU0p/JXdmU
	FznuE3bsTtg==
X-Received: by 2002:a05:622a:5599:b0:4b0:cf35:fd5c with SMTP id d75a77b69052e-4b10a956060mr20519331cf.3.1755131959042;
        Wed, 13 Aug 2025 17:39:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEfpfGWrobse0BwUQapUxjeAw1tQ03aWFjrB+6vcenXXQtMBhnSB7KOlKmpNdE2Bb+RvzZWEQ==
X-Received: by 2002:a05:622a:5599:b0:4b0:cf35:fd5c with SMTP id d75a77b69052e-4b10a956060mr20518991cf.3.1755131958543;
        Wed, 13 Aug 2025 17:39:18 -0700 (PDT)
Received: from [127.0.1.1] (bzq-79-183-206-55.red.bezeqint.net. [79.183.206.55])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1c71068csm357825e9.29.2025.08.13.17.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 17:39:17 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 13 Aug 2025 20:38:47 -0400
Subject: [PATCH] lib/crypto: ensure generated *.S files are removed on make
 clean
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250813-crypto_clean-v1-1-11971b8bf56a@columbia.edu>
X-B4-Tracking: v=1; b=H4sIABYwnWgC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1MDC0Nj3eSiyoKS/PjknNTEPF2zJJMUEwvjVBODtCQloJaCotS0zAqwcdG
 xtbUA0b/gnV4AAAA=
X-Change-ID: 20250813-crypto_clean-6b4d483e40fb
To: Eric Biggers <ebiggers@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1755131956; l=2701;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=O7IE+ejSOePPSQi6gDfIDMTuvi1ufCtY/CJl7wpk1io=;
 b=1ZKUlxBymgujUOGOAaAxqgW7+GP++NlcYPABLpIEGJhUQQFl4G9h5w+3oVmTlY2QzQHD7QZGL
 Q0JSzwJoopdAydmNpPkaYv7+So36WbPxmc7wRrEBa/364BE39K5V6w+
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: sVL-FCQjFzZU9myFbwOeLyUBonKFCu25
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE0MDAwMiBTYWx0ZWRfX0R5rKQqO7J3y
 mwiktd52X1EGHuxoAWADML2epvH4skQPN5b62BlruML92bMg2bNQJWBLYAgtu2Hb8/K7Owb7ePa
 kSpS6bNqxC4xLgcq+PEbyzZ9FHfEiZURrrLBfIpmxV2OdWD81WU98TSziOfti5vzuUzyuMc7t0r
 vQe9Zn3Z7+ljYi1g5d0jKe9nZfydoDyG509njjBcaUUEavLmVNYQ8gfKvaJdv+/ngu9h3lIpN6+
 gHGy3bVWzghmItnYskpG8gecxwHvp367+pblY+o17AlXWw44eyyioHOFhfo2ccxcvFZBG32qbJv
 QVBxLu1VqnK9vBhO8R0ragNVdrkYNQmBbpMRct3ZOZaPIbY39FqylWj04pZGs7y1vDJ2zqiERJK
 J7QWW4DV
X-Proofpoint-GUID: sVL-FCQjFzZU9myFbwOeLyUBonKFCu25
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_02,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=1
 clxscore=1011 suspectscore=0 spamscore=1 mlxlogscore=209 adultscore=0
 malwarescore=0 mlxscore=1 priorityscore=1501 impostorscore=0 bulkscore=10
 lowpriorityscore=10 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2507300000 definitions=main-2508140002

make clean does not check the kernel config when removing files. As
such, additions to clean-files under CONFIG_ARM or CONFIG_ARM64 are not
evaluated. For example, when building on arm64, this means that
lib/crypto/arm64/sha{256,512}-core.S are left over after make clean.

Set clean-files unconditionally to ensure that make clean removes these
files.

Fixes: e96cb9507f2d ("lib/crypto: sha256: Consolidate into single module")
Fixes: 24c91b62ac50 ("lib/crypto: arm/sha512: Migrate optimized SHA-512 code to library")
Fixes: 60e3f1e9b7a5 ("lib/crypto: arm64/sha512: Migrate optimized SHA-512 code to library")
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
An alternative approach is to rename the generated files to *.s and
remove the clean-files lines, as make clean removes *.s files
automatically. However, this would require explicitly defining the
corresponding *.o rules.
---
 lib/crypto/Makefile | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index e4151be2ebd4..44f6a1fdc808 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -100,7 +100,6 @@ ifeq ($(CONFIG_ARM),y)
 libsha256-y += arm/sha256-ce.o arm/sha256-core.o
 $(obj)/arm/sha256-core.S: $(src)/arm/sha256-armv4.pl
 	$(call cmd,perlasm)
-clean-files += arm/sha256-core.S
 AFLAGS_arm/sha256-core.o += $(aflags-thumb2-y)
 endif
 
@@ -108,7 +107,6 @@ ifeq ($(CONFIG_ARM64),y)
 libsha256-y += arm64/sha256-core.o
 $(obj)/arm64/sha256-core.S: $(src)/arm64/sha2-armv8.pl
 	$(call cmd,perlasm_with_args)
-clean-files += arm64/sha256-core.S
 libsha256-$(CONFIG_KERNEL_MODE_NEON) += arm64/sha256-ce.o
 endif
 
@@ -132,7 +130,6 @@ ifeq ($(CONFIG_ARM),y)
 libsha512-y += arm/sha512-core.o
 $(obj)/arm/sha512-core.S: $(src)/arm/sha512-armv4.pl
 	$(call cmd,perlasm)
-clean-files += arm/sha512-core.S
 AFLAGS_arm/sha512-core.o += $(aflags-thumb2-y)
 endif
 
@@ -140,7 +137,6 @@ ifeq ($(CONFIG_ARM64),y)
 libsha512-y += arm64/sha512-core.o
 $(obj)/arm64/sha512-core.S: $(src)/arm64/sha2-armv8.pl
 	$(call cmd,perlasm_with_args)
-clean-files += arm64/sha512-core.S
 libsha512-$(CONFIG_KERNEL_MODE_NEON) += arm64/sha512-ce-core.o
 endif
 
@@ -167,3 +163,7 @@ obj-$(CONFIG_PPC) += powerpc/
 obj-$(CONFIG_RISCV) += riscv/
 obj-$(CONFIG_S390) += s390/
 obj-$(CONFIG_X86) += x86/
+
+# clean-files must be defined unconditionally
+clean-files += arm/sha256-core.S arm/sha256-core.S
+clean-files += arm64/sha512-core.S arm64/sha512-core.S

---
base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
change-id: 20250813-crypto_clean-6b4d483e40fb

Best regards,
-- 
Tal Zussman <tz2294@columbia.edu>

