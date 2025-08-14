Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D69257459
	for <linux-crypto@vger.kernel.org>; Thu, 14 Aug 2025 06:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.135.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755154329; cv=none; b=tF24zWLgY7FmTDVecuE4+4OQXC4xhccLcmrDDzg1Ffv+qAJatXWJbO6+MpT8ojk77nnK/xNoNcT6uugjRvsCZ4mefHULxyBSjsiAFDCijVG5+fYF/CJVqKBXFX+yVLFCglZ/0yG3KvFCrCk9/fbIpHfoyTSwbpk9WSZlFLz3WEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755154329; c=relaxed/simple;
	bh=0SONc79+M4F5Fy8quIOdueQ4jkrHUL1smlCPEM8IKVs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Rpow1jJggGfxFjDIWtyYupPIu89SN4YXRZKX51g/GAFy9zo7TOASUqbkJXJ1jOkCRSmloFrhpzQfP7s5PUFXWi7EcUgf8fmmVrqBdzVbtJ+7rAO/B2FYuNRf5gPrVr/qao+JQgMJ4+K+faq6VGnLC/XE89mNV9WkGMx/jhza1b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=n1p18cVn; arc=none smtp.client-ip=148.163.135.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="n1p18cVn"
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57E6CoCe014175
	for <linux-crypto@vger.kernel.org>; Thu, 14 Aug 2025 02:52:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=pPtIzBQ4qqBBxPwXppgvPl9H8B
	j48UMU3Ie34Hi7Exo=; b=n1p18cVnviQwI+tkl0s/942e5ixuL3oHE6aDbHQXYo
	Q7nsyy+ghUsxCpTx2ol/PVft76BVQjcz3hQAC9+AkNHbtEYYNCVlbW3lA1b3JRrt
	NJLScgu5nrJVZ8uj5fenNz/ZhlSBbj1iQbj4ggCr0Ijqhs7vFzVuFsE6lPfC7nXc
	OVh4UMrYI94jrLkE8aaHiIKyVqJER6Pf32z55AcpaNCrw2/KrN+rlQwVIKgybkTQ
	d8Is0Lsst4CbzpN5AwmbNd1HfrvOI9it8sfOqGs7ke7rINywmlI++IZjjMDMkyhb
	4Wc1QHs8s6Z4fBvu1Ln7MXeKFK/ZhuecTPrbSzg28BeQ==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 48h0m0bda9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 14 Aug 2025 02:52:07 -0400 (EDT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-4b1098f924bso18379891cf.0
        for <linux-crypto@vger.kernel.org>; Wed, 13 Aug 2025 23:52:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755154326; x=1755759126;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pPtIzBQ4qqBBxPwXppgvPl9H8Bj48UMU3Ie34Hi7Exo=;
        b=FrxOLabVwI9NcnuMa+tF/sQeg1iP0W06r2gN/6Nks0w0yOedPLXdwybj2MvDjYw2aL
         dVzyfuThtc4StfZJuQ37kdr37KNxd8g6QTVIbOPf75RJNH4qaam1OpvyGDzvaTl3iDrX
         AYJUMc1xx04tBbHfoC9joHUzsWfRTyRK5G95xibta4wW4U/BaKiy2ble3eL0HcGPSmNE
         1qarQRYf2m6Fj1ZCBZqSKW3qqTc34Xc0ABeHiGmqmWIk52xfI05LSAiY293aTp+JSzEn
         jU78kw8utHyeErnMBCWpRksNQJgYsbfyNHLG1JuOJipBCy+FCGbXcFe22vzgOwBgt+aH
         DMEQ==
X-Gm-Message-State: AOJu0YxHRtmzT9PchtZOZ476cbijFlDbrt7z3HyQn1tHfwih+m7yY1Ki
	WQv4+cVQmzCBJf8uq8wrEOdljrXVkUi9fhra2gJR/PpQXfQuktXPE1cNFRRqML0V8lYbpDhHcVf
	m5Wu+I2epNZkVO/bU34mFsj/LUPnTeYIBrgLccmEsDzhg+iyYAETuK12XD4Mj7w==
X-Gm-Gg: ASbGncv5BNZoa+4gpuJNpuKU3wGikcrJ71vN9UBnNdhn031GzhIMDQRjb7ZBrCXmvOL
	InxxjRvN7r492AsLittJBFfy2DFbkT39RsiCj6SDgyz99uOdpHbZG6xhGM0/BCUuYhShbmj77OM
	UVMjEZpgzaFARqT+IisGGKn9p09jurqDLQ0m79KLvqiRoByYTmqVcZSkrSezMOJFUFFN8GwGiEF
	H97n9Gnp46aEeGcVEDbC7kfurObkqzryb2UdBik4caJ67agn0IVG5WmqYSYto4huictXaqgVrAI
	4poH5YygXwFsJFQ6Y5urtTLWhLyi6PjusOxkxA4PExluDSV/ru3oOZ/GUclVPpaIbdFbxVNh8Ds
	5XorNrXKoFA==
X-Received: by 2002:ac8:5fc6:0:b0:4b0:7439:4578 with SMTP id d75a77b69052e-4b10abca984mr30407171cf.33.1755154325677;
        Wed, 13 Aug 2025 23:52:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGq3dv25BPBGO1UYoji2p0IQ0vub/2hHhl7EyabyDycDYiWSKHCHWs+yzKSpVyt3zuaUYEdcg==
X-Received: by 2002:ac8:5fc6:0:b0:4b0:7439:4578 with SMTP id d75a77b69052e-4b10abca984mr30406941cf.33.1755154325184;
        Wed, 13 Aug 2025 23:52:05 -0700 (PDT)
Received: from [127.0.1.1] (bzq-79-183-206-55.red.bezeqint.net. [79.183.206.55])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1b7ed5edsm8484345e9.3.2025.08.13.23.52.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 23:52:04 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Thu, 14 Aug 2025 02:51:57 -0400
Subject: [PATCH v2] lib/crypto: ensure generated *.S files are removed on
 make clean
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250814-crypto_clean-v2-1-659a2dc86302@columbia.edu>
X-B4-Tracking: v=1; b=H4sIAIyHnWgC/3WMwQ6CMBAFf4Xs2RoKBdGT/2GIactWNsGWtNBIS
 P/dyt2807xkZoeAnjDArdjBY6RAzmaoTgXoUdoXMhoyQ1VWTdnxmmm/zYt76gmlZa0Sg+hqFKV
 RkJXZo6HPkXv0mUcKi/PbUY/89/4JRc7y+PXCVadM08q7dtP6ViTPOKzQp5S+MvHqsqsAAAA=
X-Change-ID: 20250813-crypto_clean-6b4d483e40fb
To: Eric Biggers <ebiggers@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1755154323; l=2612;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=0SONc79+M4F5Fy8quIOdueQ4jkrHUL1smlCPEM8IKVs=;
 b=NHnqyN7w8qQyUx+t4c/nbbab14Qyty6Dm3TJiJ1XId9/KFWJbXKjMr3DyN//ekqiizOmcScVk
 JR2pxo//yZNBpl/uklLjefLU8iRe5CmTEJH/p0jpFzY0rb11pKCHflR
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE0MDA1NCBTYWx0ZWRfX/4F1Osskc5pI
 QyBJ2mEuMBSE+Iv6aKcMUijiOYwpGDwlHfi8/NSsEyBrkeq64PSG9aREHXsJh8nzhhmqq6xOQ5Q
 0Hj3BibITE4p+lrfYLmm7l5AjPbgNUUX5dsXvsDB4jBvt+RWpWXs3alHjtPduJ4bZ7NNmIRQ36U
 KN5+wK+gnIl/ja1WLSLuAZ5Ge4IQeZ84iYAegE1ZDp98zr15ySBegPdDEQZp3po3w2DR7tRV/57
 c/jXJ7MZ85N/nWYYALXyp/RSEjxuUykBgDYbHQxItdpgrzQMV/O3RHmDSV8/sDrnQyjrAiWBf/+
 uLReOJSXh/lPZOe8sOxGR1sFm87ytsqJ0QIa+avwuYzGKCLEB/4qf3OQ/qyt32mTKXTFjO/e9u4
 alwqTbM5
X-Proofpoint-GUID: SBKRmpLtC88DOvqyXlJGS-mJItTd1frQ
X-Proofpoint-ORIG-GUID: SBKRmpLtC88DOvqyXlJGS-mJItTd1frQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_02,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=1
 bulkscore=10 impostorscore=0 phishscore=0 spamscore=1 adultscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=10 priorityscore=1501
 mlxlogscore=189 mlxscore=1 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2507300000 definitions=main-2508140054

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
Changes in v2:
- Fixed clean_files paths
- Link to v1: https://lore.kernel.org/r/20250813-crypto_clean-v1-1-11971b8bf56a@columbia.edu
---
 lib/crypto/Makefile | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index e4151be2ebd4..539d5d59a50e 100644
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
+clean-files += arm/sha256-core.S arm/sha512-core.S
+clean-files += arm64/sha256-core.S arm64/sha512-core.S

---
base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
change-id: 20250813-crypto_clean-6b4d483e40fb

Best regards,
-- 
Tal Zussman <tz2294@columbia.edu>

