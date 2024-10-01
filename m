Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6DA194AD1;
	Tue,  1 Oct 2024 23:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727825152; cv=none; b=q+/3c9UcaHdgTuHezHgw4DfoODORflokAeG+iBI+gCk9AzUmWSPWmrCr4Pxr1cfJNTxYFYLeySQXxUk3gHwgoLBz/82m2fbcfj9g9+r9Sn2Y88rEIiSMi1AuXJxlzCol0LX+pHbsM80i8q2yn307xV9xsTe6l0NzUgmHTTXqoAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727825152; c=relaxed/simple;
	bh=8tEpKzuJJod0wz3ZcPjN+AayChvMMlQKA3FkFqFp7Jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cZehetutr1nvJYdc50uX8cejHGCRfzUgETQ5Wyt9yjsZokaOyMqyTTPH3lw+H5R8WM4rcg/lmeEqrwXMGYVUy0JMvPTR5QbbVf944S/iry8A8p1iTnxddM4SlXuhl2ZGW+kRpLhPZnjAz8KZbUa37PDPIArY0mFD+doYEO+9IPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E6cK5iNB; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E6cK5iNB"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-7ae3d7222d4so5173441a12.3;
        Tue, 01 Oct 2024 16:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727825150; x=1728429950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q/vVq5169u7i4biYWRH+U02krdapDJFUv5/71gKhc60=;
        b=E6cK5iNBdFuBOAsjJ+jmJEba4Bi9irSxpR7FZJ3eye9J9C7nf3KUA+0ImBe/cdETx0
         EHsmn864n4HsKr5yBx3kb3rhOrNwnXUaqtnL4dUZRJx6DW3wjZSB78qN5PkyEgpfv9wP
         VhbYLo1GC+wSHgTV+4vyAWVCz6KFKW0yzB6DpInwrlqil3OveYzdcuJqnTereisR56nT
         wKwieyMf03QKaNsqtfMzZR7f0hNkcKzR7M2FYPMUk9u5+569r/Nz9k+qQURz2QXzSyjd
         VpbmH8QHTvdqRDfjuEdKh6UVAprD0gxNhlNagAoe7hJbDw5VOEe44OvXij6vMA0Zwd5P
         kToQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727825150; x=1728429950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q/vVq5169u7i4biYWRH+U02krdapDJFUv5/71gKhc60=;
        b=LYntOVR8WOqdlmlZTDabcEOfpzBCMb/71dn4W2RIRgshQAj47asog6YW7e1IfIyGqh
         BTo0HIjIZExotwwkypXLTAJWN98tjxXAEnNOBTQ3MpjvPJ1/Rqe9X8wBEZkk/sfE8dKQ
         Zy1/5coOn7UPg7DndEYI76SZtuSPHfenGz87phqy5S9QA851D6SDrfN2EeaM1x74ExBv
         gT5LSJdA3V3Ht9dSllLByf7vQexa08kYBT9mQsZ4sEevqrjhrrAQ8K5f8Xj8UykpcloE
         LcmSMPBnIecJrPkGV6VWGP4bWshFMj4i9SLIeKRMrYZIOgqLIPfj12JQ88iLLkKjNQGB
         /fwA==
X-Forwarded-Encrypted: i=1; AJvYcCWumrofxUB592Z6j3E6G7NTIMTAGXdDkI62fYyehtz+CgxrkmsRIK66c7b8XZ0DPw3aUfJi9eetI94VJxs=@vger.kernel.org
X-Gm-Message-State: AOJu0YylGOmnuYXcwHwRBQTzukavcK4V2+RzyN6Cxz6HxRv5tCcykxQh
	Ep1Hpo1o/03f0/H18aHk0GlpSwe+LQlOtcGsXFqJIMwAETlVypL9p9rCgIyQ
X-Google-Smtp-Source: AGHT+IE1E2KWyzgwB8LlkbX3Ajc/4on2xVRaGQhje8ITWVkxBHFS5d5erJB8YF7nQ6durH3H08gA5w==
X-Received: by 2002:a05:6a21:e86:b0:1d2:bcba:70b7 with SMTP id adf61e73a8af0-1d5db196560mr1913875637.27.1727825150244;
        Tue, 01 Oct 2024 16:25:50 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8200:dab8::a86])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71b26539c5asm8628143b3a.210.2024.10.01.16.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2024 16:25:49 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Boris Brezillon <bbrezillon@kernel.org>,
	Arnaud Ebalard <arno@natisbad.org>,
	Srujana Challa <schalla@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rosen Penev <rosenp@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/5] crypto: cesa: add COMPILE_TEST
Date: Tue,  1 Oct 2024 16:25:43 -0700
Message-ID: <20241001232547.355947-2-rosenp@gmail.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241001232547.355947-1-rosenp@gmail.com>
References: <20241001232547.355947-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This can build on x86. Allows more CI coverage.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/marvell/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/Kconfig b/drivers/crypto/marvell/Kconfig
index 78217577aa54..4c25a78ab3ed 100644
--- a/drivers/crypto/marvell/Kconfig
+++ b/drivers/crypto/marvell/Kconfig
@@ -7,7 +7,7 @@ config CRYPTO_DEV_MARVELL
 
 config CRYPTO_DEV_MARVELL_CESA
 	tristate "Marvell's Cryptographic Engine driver"
-	depends on PLAT_ORION || ARCH_MVEBU
+	depends on PLAT_ORION || ARCH_MVEBU || COMPILE_TEST
 	select CRYPTO_LIB_AES
 	select CRYPTO_LIB_DES
 	select CRYPTO_SKCIPHER
-- 
2.46.2

