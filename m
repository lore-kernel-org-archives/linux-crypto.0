Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4C3286D73
	for <linux-crypto@vger.kernel.org>; Fri, 20 Mar 2026 18:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774030780; cv=none; b=MgG066qv5JTb0SNGh5kbPOcpNNVwJu+dc9ZRWZy+zu/4pAIRIKq0yk0JePx679aCGxxWOjK7EJD/XMeH5206NwfnBzIEDw/gL3lwrx5aNSptiEtfSEWBrMeE0M4dMschBMhowOlqXUi6iQA3uhZFQb39enRBjFvGeg40PB4A8+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774030780; c=relaxed/simple;
	bh=7fESqhDf2H0GUn5V37K9O8WpKhbqlyLBKpFZ4HRMN7Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=s0HWCRRD6+UPuE7YXmGD8lQSlZxWeXsPOqIvgIEe1KTwVsI9xKK1v4Q8WnzZ9/mmOzv4NjBEMMcZSQaYTtrJ+XC5ZzvMITFL/UoQ1EjFbX4ri6ANcux2T2Weg0x/2Sue8FsZd7PYaKvNxPhywY6oRdI7sECzq1emPw+7Z832fso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D2ng0ttm; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D2ng0ttm"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8297310ce0aso926921b3a.2
        for <linux-crypto@vger.kernel.org>; Fri, 20 Mar 2026 11:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774030779; x=1774635579; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZHZ6Ubx9LHMWB6rqhYcMl9MpcqJFvsOzesv/BgCZYCY=;
        b=D2ng0ttmfiBZKh3S7tFuPi1Gj9MenKXPRVw6hwaLjNoKUUqFSDixeb/lKQgWfGBxSD
         qM/fFnD5RcE3SE5UYJWgr30hGdB3zBJhp4gQLsjtzPD1/MgViFk6V0HeyAyLZYXWZQ1O
         iaO5m0n0WEz7Tl/6+T23MTZdkWCmJFVuOvsEQfJIA3G61vup8GdiIik+MvNWgJ0H4KNk
         ZhlMYViWhDYLbcLj27nBSU9xWOAH53fkVIiqC6MUDtttwlwhtmwB1oG6dD6XWcJQPvsU
         TqndO9aAPhjTwLjH6HRO4AjnYmAsOFuEP2zE3NDt2G2DZTfZEIlx7HKjOae2bxXxOb8H
         7J2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774030779; x=1774635579;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZHZ6Ubx9LHMWB6rqhYcMl9MpcqJFvsOzesv/BgCZYCY=;
        b=NzY+PE8njOZvj89PbgSbGJWnM0DXw7cCFywFteyTJ7WGBte5V893EH1DcHJiids+7t
         R8PMKuzNbA2R0Xu2qmHJYgciqxgtpnKPkYaOXTv5KifqmG4NXdrx/SOC6NYsGH907kaC
         q9BxGMPa2Yhg0+jauucrrXdCpD5nphy71nVq8ll7JipuiJIp7yGwseqls/cBynYJISKW
         T7eDlw9tP9q89+CCuo/yTOyBcTTC+zpKhE3e7lT7oQq8bhmdq+TJUWYGmDxKs3hXHW7r
         Yts84/g0fUQ0JcRS4/ToDNKAip+TYSBOOoIb7SElvmoP0kZZLJgw0+E1b+BiwvxTDri8
         x/ig==
X-Forwarded-Encrypted: i=1; AJvYcCXz7d66io5UeDiwCwFBBVPZH0larhZCT+EPZRL8J0id8RIfvCQoaRUVzKxziX5LgHnzXzmKMnFpTD1vE4c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1E3JNKh05Hfn+5IEwbOr0W/m9LKtrujNGHkvL3byieeIznfvo
	6XQhocUMuCxNDrw24z3tX3tRWPJZgQcRRspPhNgmHxqVAq4iPzfsYozA
X-Gm-Gg: ATEYQzwF9+gTFOWtCAXpcrgvOG4UzDvSrKOyNFldLePNlaoFxp8XY/y8EHV4KeH5PUg
	jbCtbnteDQMbhKh4gBzXaRtjjC4ZqWiAvOu6W5pQ38f10LZjjaNDrleD7YpbKBRjFU0xnuADuGg
	xUxEwR2C1sPs7EcSOT5z2YgoNRGICpDyCPWFLIVQGkDxXZ4qOWxT58xVKGrrjehEE14oEmJpqNR
	eAJgGvt23GJ2Su5B+Hn8se5TtWBdUxTg0op0g5TBbW0nZcbLWxDFa3/E/NGaPjJHhkZ+mWq9dHC
	ReBoj+kdvoAFraZQ8fZnTerzIhkLFNYJEAd6kTK9lpKcJzgj9IzWe7c5asb8h77F1RnRN7KX+u5
	Bj9cfqdr6ByrOMuMRj6MCu50hjqI8cCDeRyRWcbcXthqjXMIRChLgeAggfosh4/pOgwwpkta1EF
	+ubHYp8moovRnB9Z8Isw/UipphHw==
X-Received: by 2002:a05:6a00:880b:b0:82c:215d:5e9d with SMTP id d2e1a72fcca58-82c215d6c5dmr1005621b3a.32.1774030779046;
        Fri, 20 Mar 2026 11:19:39 -0700 (PDT)
Received: from [127.0.1.1] ([103.216.213.160])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b03bbf0c2sm3198614b3a.15.2026.03.20.11.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 11:19:38 -0700 (PDT)
From: Atharv Dubey <atharvd440@gmail.com>
Date: Fri, 20 Mar 2026 23:49:28 +0530
Subject: [PATCH] Crypto : qat: Replace scnprintf with sysfs_emit function
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260320-sysfs-v1-1-91fd5ef42dea@gmail.com>
X-B4-Tracking: v=1; b=H4sIAK+PvWkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDYyMD3eLK4rRiXfNUQ8vU1CQDM1MLMyWg2oKi1LTMCrA50bG1tQBJwd/
 FVwAAAA==
X-Change-ID: 20260320-sysfs-7e19eeb06586
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: qat-linux@intel.com, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Atharv Dubey <atharvd440@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774030773; l=2159;
 i=atharvd440@gmail.com; s=20260314; h=from:subject:message-id;
 bh=7fESqhDf2H0GUn5V37K9O8WpKhbqlyLBKpFZ4HRMN7Q=;
 b=cwYk8xAbgvcZ3nZ5DbDfY2BIS2IRTPZ75Mm4uLLLluGbc9ISzmWULipdBo9/U6TSccqyyflor
 Ap0SeNoVdKcAY/lRm/opyux366au3b3Rn/3Zcm5Vpcz9bKrVGoy5g2Z
X-Developer-Key: i=atharvd440@gmail.com; a=ed25519;
 pk=T6i1xWOKT/RUSDYATSgyVG/4X7ac8jPjRSG1mMAcqVk=

Replace 3 sysfs functions in the Intel Qat Driver
to use sysfs_emit() instead of scnprintf.

- erros_correctable_show(): Replace scnprint() with sysfs_emit()
- errors_nonfatal_show(): Replace scnprint() with sysfs_emit()
- errors_fatal_show(): Replace scnprint() with sysfs_emit()

This change is in accordance with Documentation/filesystems/sysfs.rst,
which recommends using sysfs_emit/sysfs_emit_at in all sysfs show()
callbacks for buffer safety, clarity, and consistency.

Signed-off-by: Atharv Dubey <atharvd440@gmail.com>
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

