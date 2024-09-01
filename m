Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7323FC7;
	Sun,  1 Sep 2024 16:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725206842; cv=none; b=AOluyzduLmutnvpVCmJaWJYp1J2kqgD0gVWorOxvpFQTgCjh2/He0rc0EFCKPpI8uPBD4s/g5gTziTpzjGNjP4X6EFRigl/6d4kDDnp9pd7LTC15VWqXh4zV8FC3NhtgM4sVLZ6/glFP9rHGrZBmnUuHqq67uYsBsHl6JgtgmSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725206842; c=relaxed/simple;
	bh=PEKbhOoFlVX8YUiyHbi3XuPmBlu0tFvrDsTCjxY9z5Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=uVd31nETouv/YR6DXfJ468Ns+gSs+NCEyKQbjCprVJA5oifd0M5cfdDg65b7M1Ag3WtAyU/GOyJAdsAx3GV9prdsfTT0VzrRfH7LCmdol/jWISYrlGc5g+LkZFT5djiFCNEo2rirKoh6iIH3T4xFWct/4UHE8/sPN9Fud9v6n5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nUIznfC5; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nUIznfC5"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5c210e23573so3457476a12.0;
        Sun, 01 Sep 2024 09:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725206839; x=1725811639; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FwcSjCcT+sTlDDTDScDweyeWxNPTfQSTrbXIW/fa5kg=;
        b=nUIznfC5aPY2AtpkzCrlDF11qvyHiaDgIlGUYDTL/UQy0j+qy8xQCBR3lX6CdbBL2y
         mNjS2Icw4X97pvRitNp+U83/m2V8SzVc33z9gk5irjuNtxvnZHgHQ9MUoLX7jW2J2aKD
         n5NlHYTSEMMxEMmC75YdPPqY3ERu96XEz8msmFRRHufYaOlkuqugNlXBzK/urxNJlKyd
         C0jNLA99jSTAJuOsIbfXSMluh22DRkuYFxs62o9VNOkp7sUgKrBWCB+Qj/m0SYLlJW7v
         QaeiGhTmdFD9zXn/Z4L6SwUikNHYjIK+gRgPXWX3XCa2nbGKd8YPUEgvXLUu7g3hbO2H
         3O3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725206839; x=1725811639;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FwcSjCcT+sTlDDTDScDweyeWxNPTfQSTrbXIW/fa5kg=;
        b=WfEElaIGWC+ErzfNQZq5PspctNDQeCAUM8mh+6ygL+4LD4FMdVFQ0087qwlKEVjLTT
         HMtQLiFP/pNRGvRMw1+AvGNmhCmA1qVYjELD+mtfbyxLJ1gXiHjYbsBTxYTLzWAPKFUV
         G2mW7LyHGtNap4OGvGYgQIY6GSoWlXihRAR1FFwfDX9xZDh9NpLxBeRc6Tsi9//tAxXw
         eiemOdOACCiBugEmN4LcgqeFwxpUMDahg0/8Ora+dU12I15uZ8K7Lf37XFyWoJXURTF4
         s3ftSNfz9GVspA/7gabfgRm4/2R94861vE2W2IOMXNawrpKICdrIshK6l7r8A438EbT5
         W5Vw==
X-Forwarded-Encrypted: i=1; AJvYcCW4lQKU1yrV7/sJjuCX4zUZPnAYcMbZ0Ey7JJcypZ7Wz5TjBcCZVSI5IFgWIyxe/Yrh5nD9P8BX2eqApYCB@vger.kernel.org, AJvYcCXrfeus/zjAPO4pAXo+EDkzvfRfqd1Tif855ldIHgs/i3pubarwEVQN3+k/8MozyQ75s9YhC/uJEUrZTV0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yykdl4foMslCOqjG8KcnOZF6Kdufsx6LKsxL24avF2D0cxjomFK
	i2EFvqtEyhnxEnlf6BUPZf8RX9XvvuZN1kN3z6gQUQSuc2kqUoKg
X-Google-Smtp-Source: AGHT+IFJmyE3MebeV1DKi0VBZLcVuRBMldbRsVQTZl0XHigxIbVf0OPvW3Ju+JMfaQBINVQn/8iC9g==
X-Received: by 2002:a05:6402:35cd:b0:5c2:524b:7711 with SMTP id 4fb4d7f45d1cf-5c2524b7c2cmr1211903a12.33.1725206838630;
        Sun, 01 Sep 2024 09:07:18 -0700 (PDT)
Received: from localhost (craw-09-b2-v4wan-169726-cust2117.vm24.cable.virginm.net. [92.238.24.70])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c251cf4384sm1010584a12.88.2024.09.01.09.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Sep 2024 09:07:18 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	qat-linux@intel.com,
	linux-crypto@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] crypto: qat - Remove trailing space after \n newline
Date: Sun,  1 Sep 2024 17:07:17 +0100
Message-Id: <20240901160717.143334-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There is a extraneous space after a newline in a pr_err message.
Remove it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/crypto/intel/qat/qat_common/qat_uclo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/qat_uclo.c b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
index ad2c64af7427..7ea40b4f6e5b 100644
--- a/drivers/crypto/intel/qat/qat_common/qat_uclo.c
+++ b/drivers/crypto/intel/qat/qat_common/qat_uclo.c
@@ -58,7 +58,7 @@ static int qat_uclo_free_ae_data(struct icp_qat_uclo_aedata *ae_data)
 	unsigned int i;
 
 	if (!ae_data) {
-		pr_err("QAT: bad argument, ae_data is NULL\n ");
+		pr_err("QAT: bad argument, ae_data is NULL\n");
 		return -EINVAL;
 	}
 
-- 
2.39.2

