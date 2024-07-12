Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821041422D0
	for <linux-crypto@vger.kernel.org>; Fri, 12 Jul 2024 11:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720784225; cv=none; b=YzhUxkrFL+Vuzdd3IS0g9SoHVQrWBA+VCmsGaqH+2X3c/m0WvGPh0PEhlqs2K9xWB3EPPreJkrSmhJa1M+TPPdia3bqBjk8ddsLIIF9LKGOmPHSVB6prU8FnLyjN+F4i3In8LAwLWkw2IlvSCwIqPJ+eLl/Q1SP6sZVJa+pSTg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720784225; c=relaxed/simple;
	bh=p4NxVk0rjDz2kW4OESgoYIaQnoWCV2cum2MKUWwd9d4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=i4reUMogiPW1BF/sfaqPPGCvqEjn1DYIlMvh1//SWTIei6GBTJOhs3GGRlRjsZCiJzXSe+DyywiyTe5YYT+vZh/gHcOUWt0pz/Ni1b6222FSFmaEVSfvuuZfmjTRy/xE178uZyVOJEnBVJcphDpkecL8HGmkUbE0NSA04QfaiGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R4v1RwI3; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R4v1RwI3"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1fb0d88fd25so14282065ad.0
        for <linux-crypto@vger.kernel.org>; Fri, 12 Jul 2024 04:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720784224; x=1721389024; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xVM0XJp2FJzTFJbBM04PyGmu7lyMciruK9DmkCIXQAE=;
        b=R4v1RwI3mFl/IrEkC6V6TO1V1QoQoL674s/FHYMx1BX7fIxpBkaBTCZTvbbQh1JB5x
         L7L7Ys+tmjs74Y77V8E+ovgvLiiF+ASxCU9Ugr5r5AONscPiHayxxdAefjz13tY9xDtI
         ePmtSGM7O/zGxFyUvurBwGvZWq+Rf6bfLuuMz4SOf5NUJecLeUJaHkwr19P7AZj7YYsk
         ppPr6bTqwOHCyQi7mPSuK205R/kva5QMdoN/L/UkE/pQmHesADEr99GAIZxKVniF9pFs
         j2WgZEpQk0WMwkjQIERXTcBgFfcmHIm6SMjPCgtNUSltQYEGPXrwNEwWMrsvFAs/QBd4
         nvqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720784224; x=1721389024;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xVM0XJp2FJzTFJbBM04PyGmu7lyMciruK9DmkCIXQAE=;
        b=Egek99uzAuVd3b1ww0Slrc73n9GGywyk6mehAB7I7AalKOJp4PyxvHvs1G6tDeNber
         gAZjpbPOz5v8y8HMXARkwRQWRCvnTtK7feWZHL8il6Nhtp4nQmS3pw3erEbcU4uodyy/
         lW0jD9KswppBtbyTFa7PfBEkL4ubhxnwheeg3X6pfXAg5MzY+IGSHyy78S62fBPrXMff
         uLcKNVcDqtnrq0vPRR+86tKPkhUH0F+ugX7zDSjmcrpgHnrpvNcf/1XE2PMUppvDfNC/
         +GaTe21zTKvg25BsL5B3OH2zHEpEUCc/TnuhOYYmXiT3sDiY+KchVtxVdOLB9T6dBOEh
         ntkg==
X-Gm-Message-State: AOJu0YyWhghRKgsXAVt2SewuvxgKM37pRDGGn9mGsDfW+5lqfV/Eo1zN
	SerVGEIqHa/BxQHS4v9bayA8Tp+GyjXykPCeAXi9DhxkLCnwXmOT
X-Google-Smtp-Source: AGHT+IEPKljvFtBm3FlS5d+VSqBcMAHDW+cXwHEtUDnwBxC2TM981pz6/DJKwUiMuBZrhFvvz5SFVQ==
X-Received: by 2002:a17:903:1246:b0:1fb:8bc5:7864 with SMTP id d9443c01a7336-1fbefb7f5ebmr36732975ad.10.1720784223572;
        Fri, 12 Jul 2024 04:37:03 -0700 (PDT)
Received: from FLYINGPENG-MB1.tencent.com ([103.7.29.30])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fbb6ac35e7sm65079545ad.223.2024.07.12.04.37.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 12 Jul 2024 04:37:02 -0700 (PDT)
From: flyingpenghao@gmail.com
X-Google-Original-From: flyingpeng@tencent.com
To: herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	Peng Hao <flyingpeng@tencent.com>
Subject: [PATCH]  crypto/ecc: increase frame warning limit
Date: Fri, 12 Jul 2024 19:36:56 +0800
Message-Id: <20240712113656.30422-1-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Peng Hao <flyingpeng@tencent.com>

When building kernel with clang, which will typically
have sanitizers enabled, there is a warning about a large stack frame.

crypto/ecc.c:1129:13: error: stack frame size (2136) exceeds limit (2048) in 'ecc_point_double_jacobian' [-Werror,-Wframe-larger-than]
static void ecc_point_double_jacobian(u64 *x1, u64 *y1, u64 *z1,
            ^

Since many arrays are defined in ecc_point_double_jacobian, they occupy a
lot of stack space, but are difficult to adjust. just increase the limit
for configurations that have KASAN or KCSAN enabled.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 crypto/Makefile | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/crypto/Makefile b/crypto/Makefile
index edbbaa3ffef5..ab7bebaa7218 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -190,6 +190,12 @@ obj-$(CONFIG_CRYPTO_ECC) += ecc.o
 obj-$(CONFIG_CRYPTO_ESSIV) += essiv.o
 obj-$(CONFIG_CRYPTO_CURVE25519) += curve25519-generic.o
 
+ifneq ($(CONFIG_FRAME_WARN),0)
+ifeq ($(filter y,$(CONFIG_KASAN)$(CONFIG_KCSAN)),y)
+CFLAGS_ecc.o = -Wframe-larger-than=2776
+endif
+endif
+
 ecdh_generic-y += ecdh.o
 ecdh_generic-y += ecdh_helper.o
 obj-$(CONFIG_CRYPTO_ECDH) += ecdh_generic.o
-- 
2.27.0

