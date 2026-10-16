Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7360A397AFF
	for <linux-crypto@vger.kernel.org>; Fri, 16 Oct 2026 02:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792118172; cv=none; b=qg+qwY/06hvJTr50xFSFDxiUJy/4QQBls2MYTnt2ooJLLEu5Z5yR02c5JsvhlD7yu37JIsD90afto4X/YshKZFF9Ry3WOuoSZxWTrdOlZy0TJK9JLCDxUpuA7E2OEAeYO16IIQhIzjIJCG1dWmPb2yzm/kKrfBGVntsUNj435Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792118172; c=relaxed/simple;
	bh=GD75konp9X8hKjfWp4g1B9w5G0DNq/ZqywkiaURwnfs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p2dypWwtug6Fpzj1VJ+Q57yMy0Lef+pTDRQaSAD3002CHmn4hwf6rvpnGF0QZ0q2ijXOMBhwGbkthEcsLYu86zcZmfzUZDiwtyJS0693PiaeZj9+syUVelHVF4R/lFdmpL5+jQyjAhQ40etyTLvGEmf58EtbFzQuFJJq3O0GzjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G4Iaqa6V; arc=none smtp.client-ip=74.125.82.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G4Iaqa6V"
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-15943c9c005so2994086c88.1
        for <linux-crypto@vger.kernel.org>; Thu, 15 Oct 2026 19:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792118169; x=1792722969; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8vSsCec48AEXEIxa63eY/u58uAdNJ00/at9BOY534QM=;
        b=G4Iaqa6Vo8HZ68mDM+EkJfLngohVxaVabDPU0rH1fjT6JAvS0t4UwOIcMSuQYrANPS
         koiIeKLvGVKjgV3/t6cK9Z5GS1cJgl19pR+Qm1kkDqOlMyd4p0d2QvJF4A/7i9d/+zvH
         OCJifDQJHT6m/dU03rM/lZig9frQAGZWfI4MRvvTPXFVfwoPrg/Coh8BXkqcN4i6PN3r
         yzJtUgI/UFOC2eTOUZgx5bRPjq+5bPz/Dcjoqw6foSCmm1jv3WN475QMWF0cjR8slxi7
         R4OQRXOdV6CCBz74zr5RkH1HlmUnRcvjf/KXY/gB5ZbWAS0L7FmN/xhJuax2IguiKc/2
         zsQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792118169; x=1792722969;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8vSsCec48AEXEIxa63eY/u58uAdNJ00/at9BOY534QM=;
        b=gLKkk5C1UgTORfPHeSx3DALZl3IRgvqV/U6vxWdgQCT5rZVR7NLHX7Ya3qbSYIQIFL
         nWrsWCxWdqiLaKyMF/yn51iJk2o78dwxo4brlcsBmkMMLKxE/gwXfKpv+9PgGBUkvRPO
         KnYinCMqrtHPhFs0ZEDH28pkqIEgBSdJThoTuH3uNyc/m2QnCsmb66zLzjgNsDZ/TKjk
         PEP5dc9s2weH+d8C9DYKjcu2sSrgizroK/Aw2odkY6/5uPkz1r7oi+qpbZpVc14+epvc
         jngXKqXFa2sCCr6hSy0AsyHdUKdCmjsPwaOP0sf+IbHzRT8q+1w46Zh2M27I8JnKAcMJ
         NCiQ==
X-Forwarded-Encrypted: i=1; AKwUvBwS2cMcAEPivTDP3uTmVmY3t6nJfjIPeKulJqbhuKMgEtLyNjWiFhGkthMJxMtI6kt6HJ+JDcWOgQ5cFKc=@vger.kernel.org
X-Gm-Message-State: AFq9FYK5nyvBYkLtP9ce7PRmJ9oNtoq9uTKtCP1IJ2K0niPkN1/CkYjh
	0Fz8OYTGAEb9YUNWjnZFto0M5NNvpRPtXshvRWTGiRSkpmEGz4cOPUd/
X-Gm-Gg: AYBFou25fYYMV3Jq8VXrGpj2SMLzyqkF2Wft766Q/y3pGkXInvQ0XCcJpiVf9DYUq+j
	4OwR7OKFKfnhUhu14DJCi76wIPc400byKXsEveyprYJAYoiApU+eukC6ORc9iJGpwtJitbRg+su
	owz9yIyEcl+ivURW9qTMuovPuSazjL1oXSKcY8w5wU5TwQhs6Y81/h9u80og0NJLJb5Idi+HOjt
	jYtqq7fsczk6GUte+WBpt6sY52NGYYLZWSBX1AAV5AHjV8FpZaPZqoCEJd6C2mvmhVvckFXdSwO
	ZqrdmSDEy8QdoWSoBl+eq0opjZgrnEfnh3qVNZpMQqJxpSCFEno/lnPBTmru468DGFRN313fBeq
	i/JMYLYuY2StQjmTxkmq86lEKZvhWNrbxYjy2mZh70rESGQMV6SV98bFTxTFzus4qM9prTVM3ji
	VNmJyuGeZs/oRPviKlIxmN7M3+h8WDf0MnMTKDzTleLUG63EytZQKYS5hTChaeZbkQJBKvoqYH8
	3qT4Xsm0PP8hF4=
X-Received: by 2002:a05:7022:b0d4:b0:161:3942:c07f with SMTP id a92af1059eb24-16a660d44f5mr31483316c88.47.1792118169433;
        Thu, 15 Oct 2026 19:36:09 -0700 (PDT)
Received: from kernel ([45.251.35.75])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1831c5cb39esm1509214c88.22.2026.10.15.19.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 19:36:08 -0700 (PDT)
From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
To: ebiggers@kernel.org,
	ardb@kernel.org,
	herbert@gondor.apana.org.au
Cc: Jason@zx2c4.com,
	skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	jkoolstra@xs4all.nl,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Subject: [PATCH v3] lib/crypto: md5: remove unused header
Date: Fri, 16 Oct 2026 08:05:57 +0530
Message-ID: <20261016023558.8797-1-raizudeen.kerneldev@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The `<linux/unaligned.h>` header is included but never actually used.
The code handles memory accesses using memcpy() instead of the unaligned
helpers.

Remove this unused header to avoid false dependencies.

Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
---
Changes in v3:
- Update the commit message to accurately describe memory accesses.

 lib/crypto/md5.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/crypto/md5.c b/lib/crypto/md5.c
index 3d2b017a0525..ded7ccd1a5fc 100644
--- a/lib/crypto/md5.c
+++ b/lib/crypto/md5.c
@@ -16,7 +16,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
-#include <linux/unaligned.h>
 #include <linux/wordpart.h>
 
 static const struct md5_block_state md5_iv = {
-- 
2.53.0

