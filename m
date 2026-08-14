Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1CA43D501
	for <linux-crypto@vger.kernel.org>; Fri, 14 Aug 2026 13:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786714780; cv=none; b=MJBIur6Gvid5VM+h4e0PFusbNqA4ocL1RgAoU2vxqEacQvtbYtw4mGZ6BM/ldvwQjtk3T5QXwdObBDf2+i5Lzhcqg5R1a7jDmTOFrEj+CieInAv7GRZT02MUs507Zpvf5V+6EZQdaFs4mXE1x4wIGeLt3/FCAG/L73eL86f4plM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786714780; c=relaxed/simple;
	bh=s6stw3qekj32gPO2Cbo5W9gIsKVEW343T7LTAMhAC2c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WJqC4lb34FGjnlV0+tJW3w0pVVpOK1/usb5WbafUuY3c3xRW8Q0VjrzBW7RUicuSW/BSrYGuzh/tygkjqE20f8NCoJvcyPpu82HPKQ/Q0WVhKq56ObGsCeA/3nBumKx9YJ/Fr1QXI8btl54VECVoqMC+gUrUUdGvjPImv4J2hJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hk2MVYQc; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hk2MVYQc"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c966b9ee9cbso609649a12.1
        for <linux-crypto@vger.kernel.org>; Fri, 14 Aug 2026 06:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786714778; x=1787319578; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=q56pSemoPlmRoOMF/Kg5BWEkXRAm+Wr9UjJACPvLbeo=;
        b=hk2MVYQc1l9bofdSGVqrnTxtOQG71zqNPgu9sWrh+km7bZ/RkwM5/Q0fay/zq6l4Qo
         EVCyaRb6vc8k4IqbUNiu7ZyqG2459uKGiyaU6HJip8G2Rh2Z9M45UeH/uN0keKwVo4Lf
         ZQkdKcoeQQCBwNq24KKcegvrNMO9Is9ApqcQUN/2owe+wS3+BDKzY2Vqw067KUZeFzm6
         9DXrH7ytcBmypWqHrtK3JhLDU0FE33SLB+jZybs7rodHC0aZdGyX5U7qcaXY1FcM7ARJ
         88ZBn4EHa7nQ/jwdzwKx+kk1NrzFsLzyaTZcRuT41cyh5JFWn+8x5b1w42SGcIBbkSdY
         j0dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786714778; x=1787319578;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q56pSemoPlmRoOMF/Kg5BWEkXRAm+Wr9UjJACPvLbeo=;
        b=MnhbIRDRpGQAdm6boOM3voEFhvGSXT+jywCPM7DVJ3czPAKf648yD0daX6hxQXWwTZ
         aQoRK0CEK5ls7t88OC0wha7bib9aCyK71nE2ruBjx4br9xwG/qtJgi3rnYNVB2ObvAp4
         cy6lX8T9pJVQUhc7RCBG4x5P8vCQ4uxi8w+MU/ZsHNZy9xqfCNO/msuNdi52gZesNeUs
         k7NUcpxOrZe9iFZG5/djabAd0Mqq91RvysNygOXwFaAq26rAYtjxF9w7601Iic3v0CiX
         7yUCwXzrrwMYWM2FLAe0lh0aFGGZ/cLgmypfRfL3N6J/APJDxEPMePcTFa6mkVvVxQ/W
         za5Q==
X-Gm-Message-State: AOJu0YxD+yk3Ng6604qjOgVbMBobw+pp5vBlbzv2jvedB3F6AIJhFqCO
	oW2TGZNwOBdGl9xoBNX9FTrEMbDOknwEsckVX0WrFT2FUAFEUSR9clib
X-Gm-Gg: AR+sD11IBE2axd2PZbwdDCkxiGynjs1BxpSbQXa9cHoZ2+TAyPvlNzm9q1m5el2MMJM
	XnR7e5tKnsmSRABxKR9gUBvVSm2d2bMA1VNfo85SHVyzAYw0AW9/Ocwtkx8gXEJJXxp9UE6JPVG
	Q1LxjMZyYRMJe/rTKTUKI/c4tDm6/SqKpbhBIxIuJmCNnI5kk0piqHC9jrGjG9RN3U+VDlNrSIy
	rThZGKEboNPkM5sJZyNMpj/mtTgcLIdaA5UIGrN5cFD+Wk+Xe+7sYnNj630BcqTej7BtF69NJwV
	ARuXCy5cRRi0KNH3MB75xNqdW+YrEPtpbPFNPqo3aRrFqREiqJE3Qc3pd9iv/tqKJ2yHKs7+Kqm
	XKhbVNnuSGCxXPfteXmYX4YoqLo8pnUIP5QsWiz1/Q0bhHCYESOvfVpaW6i4RiibRsXwo12RNLW
	eXghDYzOUmSZep/cBzpO9fXEN38DqJJAZuy5Ck6nmY2AkEqjRU2RkODXy3KVWYLe7ac/cU+NqGe
	obDHpAv
X-Received: by 2002:a05:6a21:3281:b0:3cc:56be:a559 with SMTP id adf61e73a8af0-3cc71fa8c5dmr5670551637.23.1786714778197;
        Fri, 14 Aug 2026 06:39:38 -0700 (PDT)
Received: from haichao.tail057a43.ts.net ([2001:da8:e000:1206:e9af:7c0e:be31:2c3f])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc08f388bf9sm608922a12.5.2026.08.14.06.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 06:39:37 -0700 (PDT)
From: Ruoyu Wang <ruoyuw560@gmail.com>
To: Hadar Gat <hadar.gat@arm.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ruoyu Wang <ruoyuw560@gmail.com>
Subject: [PATCH] hwrng: cctrng - Fix runtime PM usage counter leak
Date: Fri, 14 Aug 2026 21:39:33 +0800
Message-ID: <20260814133933.1385764-1-ruoyuw560@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pm_runtime_get_sync() increments the device usage counter even when
runtime resume fails. cctrng_read() propagates errors from
cc_trng_pm_get() without scheduling the work that later drops the
counter, so a clock or reset-completion failure in cctrng_resume()
leaves the counter elevated.

Use pm_runtime_resume_and_get(), which drops the usage counter when
resume fails and returns zero on success. This preserves the existing
success path while balancing the error path.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: a583ed310bb6 ("hwrng: cctrng - introduce Arm CryptoCell driver")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
---
 drivers/char/hw_random/cctrng.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
index a5be9258037f8..41c338a768ce9 100644
--- a/drivers/char/hw_random/cctrng.c
+++ b/drivers/char/hw_random/cctrng.c
@@ -86,12 +86,7 @@ static inline u32 cc_ioread(struct cctrng_drvdata *drvdata, u32 reg)
 
 static int cc_trng_pm_get(struct device *dev)
 {
-	int rc = 0;
-
-	rc = pm_runtime_get_sync(dev);
-
-	/* pm_runtime_get_sync() can return 1 as a valid return code */
-	return (rc == 1 ? 0 : rc);
+	return pm_runtime_resume_and_get(dev);
 }
 
 static void cc_trng_pm_put_suspend(struct device *dev)
-- 
2.51.0
