Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7371D175A7C
	for <linux-crypto@vger.kernel.org>; Sat, 21 Mar 2026 04:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774068475; cv=none; b=BFirp3lFwKTs/VNHLJpyflJsbBTik3iOi2H5bfbyDI8FyOW4bSlw0y1NWelzJxrf5xQjP+So1wbjZ5CSL31dQLXRpTkevraTlbuo2rFFOIkdnm0J/KpnI5QgO/2oS4HKbPhxatlbIocvuzEn8E70ZyJw6YKjWX46YDhQTO/+H2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774068475; c=relaxed/simple;
	bh=KTXZCBjAqj43lrPosf4WPq89LSgSq+NE0c5r8BhTbeI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=lGfGYf8FYRs1wjMUu5OJ3GP3HZbLq7lZJ+Ai1hw0g8WnQfWq7Cn0iJHPiWJMW+KSiaNbMmh2cZhPTj+HIrr2tJ3hKLY+3LrnWTwJnLBafqsS7KMzdruegLSGxXGuYa1Y+kN2l5TW3hb9D+bb8qLKe/WE0v9iwAHpgyW2PFMiggs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KlU4zyU6; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KlU4zyU6"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8298fad2063so1257849b3a.3
        for <linux-crypto@vger.kernel.org>; Fri, 20 Mar 2026 21:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774068473; x=1774673273; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kqLPNlBQLbB7NflD25K4/nDk4OFafHfJS0iAAU1q8bk=;
        b=KlU4zyU6VipntpBii2RkiUb/QIeS9dZiRtnx5vVTYOxif593/pTlP1ttvDZO4nlx1v
         uF6xlSefbx4OZGJkiiAf6r01h/DB6RCd2FPafg50aMfkmRKrpOsLEaL9xxhBlZ+Fd56c
         Wzj9zH9/hwfGeZDwSFg6fkn6om4dpnPvFjOWe+ad6wPGD/bb/1WGFSTuMBPQjdPOGQD1
         q7jwlQ2aqwjrRoll+D5xHg997oQ35+0przPslDg1ZC6eMvsM3dhnnPJ3uy244WGC7fPo
         sPgxSB1zR0jyTbPo51r49BEfQp+iXolZ5QtuBFLb6jAHcz+6LhjrXB2E779Ps41HKZhB
         +uqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774068473; x=1774673273;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kqLPNlBQLbB7NflD25K4/nDk4OFafHfJS0iAAU1q8bk=;
        b=IWeWE2UPl1otkNuf565MSNa0pvXbUoXRzRF56ta1Ug6eUBFvEP8hAV1ybH0rMNV+0Y
         PbryTUh3mTMSFlngTMq5zFGPIVXOtwa3GPHCI1ibr/OyjvFH+Igk6YaS6pRbTPMbdp94
         0GsYlTZeADBrpwoQOO5CNqYd8acA28u0kJoVHofEvsAuBDz88Dsnw2F31+PBPzBOPFhk
         JQXtfk1VbS9ejYuS0lPkvWURyH2HL3KvIZOggOiHZHEWFSdtdE/Wl6PQQgeMuwZCcLAL
         rcxngpBVicuCL+VoBo2ks7qiysDbGPB5REtHjh3PSy1x7Kf2ZWQn8V9d2ULwgv9DokOz
         5hZg==
X-Forwarded-Encrypted: i=1; AJvYcCXYFXRj682ZhnKnKnL21Eb753EXHi4a7kkwcPWDMog9YnY3HUGOj3+eeC1gg0qPsXABMhdXeYXP+s8kSIk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzu45aLRrxZOtO/UvPwLxyPNWnBTIOcP01ym1K51FH9kb3yAFQM
	JAQZNLBYrzfViLIS3ztiauQ6smSA2WE7fU/d2c6Rm7KiXPyoeh6txEAx
X-Gm-Gg: ATEYQzw2EpafG2AdANXjhp8vvWVmMPs6tkrvWZczYw0GlMzSdbSXuu2g0CGRV2l3rN3
	/ah/SQbGgWiwFHgKpOE7az99aV0t8YwUIF4lhwE+e0GCT2vJiBMMhXPmy+QlJLRZfEeM3Ow9g+8
	WyxXdznm5wmFJ5QfJyPOwrHuuK4+nsnqRp4eC/tKDucZvYC4yyyaD30icZsEbo+m7HqDYWx+TGI
	/3GsQDKheQbLBxiFVs4oyer0m1bwYC3LznePIYwRDQV5mhP5Oto5YFJAVeF1bX80qeuLGL6+aIV
	Ywhkxr32Q3jmYvsc5vy+3FVeF6BReyK9GXx5oAPIE9POtgCvsYrSte6CFY82ziGSpB8wMV5Q4kz
	AxuPBp8HpH6UgbKze6h8sTo67qFSsrw/FO+GHd7E2DuTkVcEZvVr7hBpOUAJBFGbs/bamQQ1PDU
	5MPsnGe8xdnyGsvfAX0lUN4Uf+9s8J62XM/QN6
X-Received: by 2002:a05:6a00:22ca:b0:81f:4a0c:c584 with SMTP id d2e1a72fcca58-82a8c1faea9mr4102544b3a.1.1774068472760;
        Fri, 20 Mar 2026 21:47:52 -0700 (PDT)
Received: from [127.0.1.1] ([103.216.213.160])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b0409c1cesm3403649b3a.36.2026.03.20.21.47.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 21:47:52 -0700 (PDT)
From: Atharv Dubey <atharvd440@gmail.com>
Date: Sat, 21 Mar 2026 10:17:45 +0530
Subject: [PATCH v2] crypto: qat - replace scnprintf() with sysfs_emit()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260321-sysfs-v2-1-27ad91b89910@gmail.com>
X-B4-Tracking: v=1; b=H4sIAPAivmkC/13MQQ6CMBCF4auQWVvTFqniynsYFpVOYRKhpGMaC
 OndrSxd/i8v3w6MkZDhXu0QMRFTmEvoUwX9aOcBBbnSoKU2stZS8MaexRVVi/iSprkZKN8loqf
 1cJ5d6ZH4E+J2sEn91n8hKaFEq7xr0F+0Q/sYJkvvcx8m6HLOX7XpzNiaAAAA
X-Change-ID: 20260320-sysfs-7e19eeb06586
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: qat-linux@intel.com, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Atharv Dubey <atharvd440@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774068469; l=2324;
 i=atharvd440@gmail.com; s=20260314; h=from:subject:message-id;
 bh=KTXZCBjAqj43lrPosf4WPq89LSgSq+NE0c5r8BhTbeI=;
 b=WtW8WFKkDehsxJ/R4LYILNmAgvSwtm2XrTcjbkPKALaxHbLcno1oLDmQD+mEcBV4Jxf9Io6qN
 X7bVCl7gP9qBKvk85xAkUgXb4fuIkpJ7PA27Hm4QngG/3wktzXg/ndX
X-Developer-Key: i=atharvd440@gmail.com; a=ed25519;
 pk=T6i1xWOKT/RUSDYATSgyVG/4X7ac8jPjRSG1mMAcqVk=

Replace 3 sysfs functions in the Intel Qat Driver
to use sysfs_emit() instead of scnprintf().

- erros_correctable_show(): Replace scnprint() with sysfs_emit()
- errors_nonfatal_show(): Replace scnprint() with sysfs_emit()
- errors_fatal_show(): Replace scnprint() with sysfs_emit()

This change is in accordance with Documentation/filesystems/sysfs.rst,
which recommends using sysfs_emit/sysfs_emit_at in all sysfs show()
callbacks for buffer safety, clarity, and consistency.

Signed-off-by: Atharv Dubey <atharvd440@gmail.com>
---
Changes in v2:
- Update the Subject according to the suggestion in v1  
- Link to v1: https://lore.kernel.org/r/20260320-sysfs-v1-1-91fd5ef42dea@gmail.com
---
 drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c
index e97c67c87b3c..2ca757e13c72 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c
@@ -20,7 +20,7 @@ static ssize_t errors_correctable_show(struct device *dev,
 		return -EINVAL;
 
 	counter = ADF_RAS_ERR_CTR_READ(accel_dev->ras_errors, ADF_RAS_CORR);
-	return scnprintf(buf, PAGE_SIZE, "%ld\n", counter);
+	return sysfs_emit(buf, "%ld\n", counter);
 }
 
 static ssize_t errors_nonfatal_show(struct device *dev,
@@ -35,7 +35,7 @@ static ssize_t errors_nonfatal_show(struct device *dev,
 		return -EINVAL;
 
 	counter = ADF_RAS_ERR_CTR_READ(accel_dev->ras_errors, ADF_RAS_UNCORR);
-	return scnprintf(buf, PAGE_SIZE, "%ld\n", counter);
+	return sysfs_emit(buf, "%ld\n", counter);
 }
 
 static ssize_t errors_fatal_show(struct device *dev,
@@ -50,7 +50,7 @@ static ssize_t errors_fatal_show(struct device *dev,
 		return -EINVAL;
 
 	counter = ADF_RAS_ERR_CTR_READ(accel_dev->ras_errors, ADF_RAS_FATAL);
-	return scnprintf(buf, PAGE_SIZE, "%ld\n", counter);
+	return sysfs_emit(buf,  "%ld\n", counter);
 }
 
 static ssize_t reset_error_counters_store(struct device *dev,

---
base-commit: 8a30aeb0d1b4e4aaf7f7bae72f20f2ae75385ccb
change-id: 20260320-sysfs-7e19eeb06586

Best regards,
-- 
Atharv Dubey <atharvd440@gmail.com>

