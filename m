Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49301D7E4A;
	Thu, 24 Jul 2025 10:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753354710; cv=none; b=SjyctXzJ7LssYAhg57g4hambSb7tlKdPgXnnb2QcoteAzy5D367V6nBI1+aONmmfIxdURh850wALV75RfqgZABdJNuxqdzHXt7AFAwBCMyLwijQumeVgTHJD4ZssnB1kWeEZZ29xLfWY4L+khRWUSyn6kqFEJXpwd55qlFBBals=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753354710; c=relaxed/simple;
	bh=wl+SOkF9O3gURIzsMwzVH/kEkZbhPgd5zO2cNyRnC2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LFoyTfoclox6vk9IBF6v9Pe152tcqQwAAlgNY1rcaLU8nK9ZOXxPjKpbnT/2PDc24nFUsYD+gAMsLaKLI/fxYAqcs89ZEPicfh9DSxzYWLYDNnIHBvdnEwUvJ7gCdsRgqzDSienqQfVH5thdAw4EN5CwGvMZAA6jCYlLq29e/XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z8rKGJMp; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z8rKGJMp"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-455b002833bso3620025e9.0;
        Thu, 24 Jul 2025 03:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753354707; x=1753959507; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RGecDSfQkRQwOHSUrTvJEbSVKAprJg4maVsG15+73gY=;
        b=Z8rKGJMpwdy7AVJQ9sCquhdF0kPoQHzXI9PwEks1YogSQC9C0RWUl0IQcxd6lABZ+j
         mf+NEL/ZvTxp9HlJcz4BMqWbM3IJlHRE90MunDzhWMpjg3RqzXS2ESnijjtkC1tk0PQv
         1841zMMZHLYHMAPbJABPOwaUT67pYX/xyYI+NTW6nv9tG/QznI6hqIl8/78R4zoNHpJV
         Xv87sIBeMc9o/Cjj8HQ3CWmhPuYv/Wy9VackRfj+PTLdI4wU1Ca++Q/nJ1bzAW2oN0Kl
         M7KTi7CyTCJuB0/VvO+uvM302I7mUlVyqCukwj/CzdcLB+A+0yH80e5SglcIItmcFAwt
         gzbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753354707; x=1753959507;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RGecDSfQkRQwOHSUrTvJEbSVKAprJg4maVsG15+73gY=;
        b=IeMTLJfe2gZ58GbpztalT2fMw6Dd1iuQOIno3hW6JPy1eJFsQAEJXgwsLDE3GTb/xA
         F0az0NvS5Zdj03qdS2rycyQkJDBE5xIvmUFswS4T6pDuNthN7yK2wbicRCJhYw1RXrBX
         Jkp6V/qqGeSFtnjAvPYjifYfZGXkaRMDnuDlX2XI4JO31xJVvw+JOeXJOsf83S0y8mju
         zHbDj6ArpFPmrTa6u8dnBAXaZqiLj9ZusGahsHGKQKs8Adj+9ueXunI7yK8xX6Zee94L
         MunuileVBbv+mCu0+YmPgm6BLfB/MVnAL2YBCCE/8xRQBLVmgRLKLXpJM09w2knZqXXV
         MBMA==
X-Forwarded-Encrypted: i=1; AJvYcCVvVUu/jkwPxi7U//Wh64tzg1XbDfh27cY96y+Dtfly+wB0tW6NCDLO3GYpqS3RxQkkstZQ6RyEc3mdUqM=@vger.kernel.org, AJvYcCWJhB/kaVTmkZolO1TlRzkVPKwCm0N7T3gtwtAyn0B5Ik+dZSqFsG5aYvwuzEz0l3t+H54GAnFhYtBf4kPu@vger.kernel.org
X-Gm-Message-State: AOJu0Yzp6Z8qB4PS6kvIeDbjSoiz2MEa+TqPCqCxqlX9AJ+Wxdy6Or4e
	B//xX7K2s6WiaYR74/5UWsTwdOmrAhL27ga8YINywvFRG97/FnXDSKya
X-Gm-Gg: ASbGncuwOpquEBqH4hEv2hc58z/fwDfVBqYxw8pySb6O0rFDk2iu8c3+gC1nG41RENH
	jvoD4jzHXAajLES1YFfYeSjljowjKuV2nhb+PcOaYCFAMu9DRktEq7mO0Lho811MUVd6JEvUVZI
	Giio9ZiptCPUvSagh2Mj3lCWHbCEtga4gcDNw1bLF2uujmwMWocBzfCooGQ8WLozolciOdwPxfn
	kPhpKAfMx6e3s5qCAeX1Jbds8eZcjktrcw+wsLqhgulz/KO37WCS/fv099EVxSX7sHJPGdSO/zJ
	a7y3X4ojqy/Fr11BI0+VSiwV/boNgw7p1Y2Qb0s6BWVtifTD95dbZ/wiFOS8uu+WrHYN3d3VTl5
	Rr1ss5/ZYTiNYECGymzs3
X-Google-Smtp-Source: AGHT+IEec1gAogEhVNDlKxHHWHB5R0+lqM/g4ZlsnII2um+rpJwBJ/Nvy+vyPcI2BysN3G6ob2NnHw==
X-Received: by 2002:a05:600c:3e83:b0:456:2000:2f3f with SMTP id 5b1f17b1804b1-45868d53693mr42892935e9.23.1753354706968;
        Thu, 24 Jul 2025 03:58:26 -0700 (PDT)
Received: from localhost ([87.254.0.133])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-458705ce781sm15812735e9.31.2025.07.24.03.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 03:58:26 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] crypto: stm32: Fix spelling mistake "STMicrolectronics" -> "STMicroelectronics"
Date: Thu, 24 Jul 2025 11:57:54 +0100
Message-ID: <20250724105754.140400-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There is a spelling mistake in the module description text. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/crypto/stm32/stm32-cryp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/stm32/stm32-cryp.c b/drivers/crypto/stm32/stm32-cryp.c
index a89b4c5d62a0..5e82e8a1f71a 100644
--- a/drivers/crypto/stm32/stm32-cryp.c
+++ b/drivers/crypto/stm32/stm32-cryp.c
@@ -2781,5 +2781,5 @@ static struct platform_driver stm32_cryp_driver = {
 module_platform_driver(stm32_cryp_driver);
 
 MODULE_AUTHOR("Fabien Dessenne <fabien.dessenne@st.com>");
-MODULE_DESCRIPTION("STMicrolectronics STM32 CRYP hardware driver");
+MODULE_DESCRIPTION("STMicroelectronics STM32 CRYP hardware driver");
 MODULE_LICENSE("GPL");
-- 
2.50.0

