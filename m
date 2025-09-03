Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DEF35975;
	Wed,  3 Sep 2025 13:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756905464; cv=none; b=M0owMxBUOaF9vANG5cuKJ4iVABrGX2wWK8PH0kn0uGFBm5tHSRCBHuM00SyLcuWz8xzs7vPstz4Xiv+gX6fwzouD4KtXdEpM/UkJLtwew77gUMuy4K4a2kiUQFxoK4lpF7c5mmBIXg3Etfpv5Lp5anZhGghUX3D9LPLlzpegVkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756905464; c=relaxed/simple;
	bh=XfxmH6UK2ibQsPOKW9Ol2JJ27dhxXwHJwBICU3wHA3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eu/YJFqkkIv8aecX7HM1HAi6dtIH/5OkXaHvSeyDB9pwXK4BzC+WeowbTpA4zr+i2aoCwqA4fAz2J80W0NrIhhfBltITGl+yQ+U1iN9HLmOFNFWkRAfEeJD7BaznfSxpVgMGT4jumhvHYN1Pd8rKYNZrBV80Aw9/GhNIZE2AV8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kzalloc.com; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kzalloc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-248f2da72edso13187915ad.2;
        Wed, 03 Sep 2025 06:17:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756905462; x=1757510262;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CROsVpMnA35LVenMVE+pivgjteHeidZyh2H5z6yvf0g=;
        b=TiRabSH8KSna0FppNqAEZCFq9BZePORqmkBXYZSp5fCd+PAI7c5d46LYUqYkT9yb9r
         /U2zLEAVc6aQz6IRBKaG+EtrTLJyPTqFBdpbDT29XL429AePihBnOca6bzpu8Ofy570g
         iBQH4aS8S+lKRT6f0eaAdaycBZwI4obxUDwFWmLyROfJPYyWXyA5FgQdndlT2Q+WM6G1
         DDGW2Q3LHfX7TF2qHh+NZDpz7S1WYVQ89rSDvKGrJVgAm49n9ZJRCqK75jhDhGGtvUQ/
         SknyrnpqHklEMFrl5qB8N7uc0k/SB81DD3/PR9GK+Zzj8U3kKP11t97C/4FpbR7NiGM2
         saUg==
X-Forwarded-Encrypted: i=1; AJvYcCV3nf78fm2WNBMzBMrNNDTqi0pZQ5u1UYDVquBLZ/S1gbgzTUWa/s+hpmiNtAxc7r9HtvkLgsmpyaNMQg0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFN40T89H732nG+5UayQ1i8Ewi9ofXhEyVRLeRjjIk+r7dgr59
	FowHqcvDK60w8uNi5W65beXQE6c9xnoug8+7kiIYWhJLAIhnahHPkSAL
X-Gm-Gg: ASbGnctKplBwILzFHO3rh+qt1oUbYO0TWd1OzZ3m2SQovcgOYBZDrSvp56guD96oOx6
	cT3UgI/nnAw6haeVpm9v3khcsPYvKNYwPd1dwDbO0ODhU6BYvIn/cXDAERl4/2lLzhAAAYlEjOx
	SPpWuv8kOnu3Bl+IPWQHSWV6lKtz71JpwK8YBPeKPMRJmk9JxWlfyJAE2OB5yz9q1n1TeKNzcO6
	IF5F2VBzabp3GBaga9hnah+HABDDGTts9wJ+oKVxGYHkm3WpU4U6QGt5/hxqGpMhpDZp4fd9Gvz
	D0w1lr7NB0vbkP9hQaTbv/oPges0h/6+wliKXzstEBmUP8vmxkK15ZdAb62AfyCTRZl/E58XUYx
	daIB28cUZA51l9t9t4g7bbXkyp559zrcZCE631FNsiXyHNjiH805jZA874sVDrDas6QLgKYdj8Y
	e2
X-Google-Smtp-Source: AGHT+IGzpiCJiBP9pg+60G7NQ3a1j1HjJ/8etZjzvVWlz1aNOdumlJ/fdoJ3AWAFvRJG99h8S3pEVA==
X-Received: by 2002:a17:902:c40c:b0:248:a01f:a549 with SMTP id d9443c01a7336-2491f27a5ccmr146702275ad.11.1756905462243;
        Wed, 03 Sep 2025 06:17:42 -0700 (PDT)
Received: from Mac ([118.32.98.101])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24cac2f24fdsm7361615ad.46.2025.09.03.06.17.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 03 Sep 2025 06:17:41 -0700 (PDT)
From: Yunseong Kim <ysk@kzalloc.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yunseong Kim <ysk@kzalloc.com>
Subject: [PATCH] crypto: ccp: Fix incorrect payload size calculation in psp_poulate_hsti()
Date: Wed,  3 Sep 2025 22:16:43 +0900
Message-ID: <20250903131642.16798-2-ysk@kzalloc.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

payload_size field of the request header is incorrectly calculated using
sizeof(req). Since 'req' is a pointer (struct hsti_request *), sizeof(req)
returns the size of the pointer itself (e.g., 8 bytes on a 64-bit system),
rather than the size of the structure it points to. This leads to an
incorrect payload size being sent to the Platform Security Processor (PSP),
potentially causing the HSTI query command to fail.

Fix this by using sizeof(*req) to correctly calculate the size of the
struct hsti_request.

Signed-off-by: Yunseong Kim <ysk@kzalloc.com>
---
 drivers/crypto/ccp/hsti.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/hsti.c b/drivers/crypto/ccp/hsti.c
index 1b39a4fb55c0..0e6b73b55dbf 100644
--- a/drivers/crypto/ccp/hsti.c
+++ b/drivers/crypto/ccp/hsti.c
@@ -88,7 +88,7 @@ static int psp_poulate_hsti(struct psp_device *psp)
 	if (!req)
 		return -ENOMEM;
 
-	req->header.payload_size = sizeof(req);
+	req->header.payload_size = sizeof(*req);
 
 	ret = psp_send_platform_access_msg(PSP_CMD_HSTI_QUERY, (struct psp_request *)req);
 	if (ret)
-- 
2.51.0

