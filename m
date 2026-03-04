Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C227538239B
	for <linux-crypto@vger.kernel.org>; Wed,  4 Mar 2026 20:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772656779; cv=none; b=czVb+cQp6UGj3cPothRiCG3WAtB+1zd74UxlOSj2SkJIRYUUM9O3ju3IKSLRMeVYHaMkS3AMQW2T/seQosPaXmFVjNc3LrB/XQocCHquy/Gy/UdXMaKQZxLyEh+EZMIvB06tNx7tj5Yxkrpy9kznE2KuCUbbIpYNzcpWuFXurXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772656779; c=relaxed/simple;
	bh=DpamcfXASa3ixa95to/Qe0lpjPoUekNG01dwO9YD5vE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aQnJSUEQYHxUGy9m6l+F5rUBP4w7FCRGpmuSt48BccYPFiHst1IlXzEa1PlLMHmi86wzx2BYg1TKQBMoMDj0YosvKvyEieBfufNKkTXeGjLzwGiYGI2e8v89nTQuebOfslVXqrnmuW+Eg/OGkbRH89nh7aenkj6s9Ahh/v4tFpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TrZQ6QHw; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TrZQ6QHw"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-81df6a302b1so7806201b3a.2
        for <linux-crypto@vger.kernel.org>; Wed, 04 Mar 2026 12:39:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772656777; x=1773261577; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=UnC23O+7DMPLYBexJgHR9A7aj/3fTz61QsNrjyndP4I=;
        b=TrZQ6QHw7Cc4FAsdBCfOkWmAD9Lk7aGax03zmFVIsBwNwMRXW0pTBeq0weSzrk+8fY
         f472AY4LC/J8mXpkWZmnnPQS68vuEzWD5UGA3Zn9qwlh9losjqSKKbnwh4ZyMnA9MnX1
         DRo709IMpnw8p/9UcWLvKfYMNBZAiCHY7cTcMfjanRNcZgterzOgGrS/Eqj3SNxHFfyb
         +wtShDgaKQOz8gqBaQ2ynXkH1C/P6KYy+v2D2pzhfKEddHFsbkm5Ff0Y0Nvm6MPXM9/r
         E2nNbn9SldvHYUDSIrxqD/5xXE8s8EiDFtABCRRkFs0GDjSe3Sb7VXlCjVOeRJG/61mK
         lrhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772656777; x=1773261577;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UnC23O+7DMPLYBexJgHR9A7aj/3fTz61QsNrjyndP4I=;
        b=udjf+55EAwbSkR5yqe25I9OYNDWPcV3dx0+BwZjBeYjS8dW+Xt37hGVdKZ5hSqy2S8
         EEngeWiV+i7sRfp+Ntlu8zwtdIG83jAw2V6g7yFZSguHT9bGOAAJb13eWkaCgzKaU5Oy
         5UBXe/OCTRdpTVYSMCEvPM5y7vAmZLhs57IEdn35tL/4xe4sV89almOM0pJLTHtMTHo2
         qzn0U6ewb1GVJK/CIwZYDD/TEKbyd0vjck6Kl5Lqlb/ZBYHUYleMaCKbRvNNLM/XuI4w
         pcq8Je7GsvW2xoVoyiVJQTUrfGCEvS+BFs8xDj2v92PjOFTFzcE1RLiMQkXijT7He0sK
         wXDg==
X-Forwarded-Encrypted: i=1; AJvYcCWHBrP8zmLkPIUTxOLY8ot+aUJRYEBMWLHuLJT1n+OK4EncfcumHFICbfCPHz1061Dn7+Zm5Ubhe2JmtuE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxA4fjjBtth73jOPcP6X+Rrs8vJyRXPtw9eULtSm3bpGXl35Pai
	wlBxdtYGDtNe0uN+L+H/hsi0lups0WD5MHk6B8NdhIos6eB/DShZQOSQ
X-Gm-Gg: ATEYQzww/n4r9Gj1RCdlKLr5VJCRWpzGSeR6uD5fcN6AudLAV9JwOP2hCgbht/7KfyN
	UdTaddEoTq6koznIC0rRL78jRkIcZysTQLP/S735hBT+rKsJqX47QOvEPGa/1kH33Rd7c2qcczR
	tjLuvj1PBeM+Nj6Q7lNshzGsB52mZ5LKOBbmSB6NRyctobS5dih5B09bl/+sWlI579DjoQYuWY8
	7LeUxstQby5K6Ws64ZONLxUPTZezGFvYuaZ5nEQKmWk968GgINHYfrw9+czP9wVrdnZDCyZTqDA
	t8Z4JJAGWb1MzhhpcQGr7flh2ZpiH+tDS1Rfu6s8i7XVFzrdAYs9PxhUQcdTs/P6Y2pBcv4a5I0
	6//bLK12OZIx6iSH8xRMbCiaZzSR9E2NyWn7ADRERAGq/NaXvyFmwcHPVJwDRJGke0KfxlP3NxH
	nyTBFY72lSnV8QmCE6P1wEJvifB7SoMRikUY6G
X-Received: by 2002:a05:6a00:85a3:b0:829:803e:678b with SMTP id d2e1a72fcca58-829803e6925mr730720b3a.54.1772656777016;
        Wed, 04 Mar 2026 12:39:37 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82739d544ffsm19534010b3a.12.2026.03.04.12.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 12:39:36 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
From: Guenter Roeck <linux@roeck-us.net>
To: Ashish Kalra <ashish.kalra@amd.com>
Cc: John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Guenter Roeck <linux@roeck-us.net>,
	Tycho Andersen <tycho@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH] crypto: ccp - Fix leaking the same page twice
Date: Wed,  4 Mar 2026 12:39:34 -0800
Message-ID: <20260304203934.3217058-1-linux@roeck-us.net>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 551120148b67 ("crypto: ccp - Fix a case where SNP_SHUTDOWN is
missed") fixed a case where SNP is left in INIT state if page reclaim
fails. It removes the transition to the INIT state for this command and
adjusts the page state management.

While doing this, it added a call to snp_leak_pages() after a call to
snp_reclaim_pages() failed. Since snp_reclaim_pages() already calls
snp_leak_pages() internally on the pages it fails to reclaim, calling
it again leaks the exact same page twice.

Fix by removing the extra call to snp_leak_pages().

The problem was found by an experimental code review agent based on
gemini-3.1-pro while reviewing backports into v6.18.y.

Assisted-by: Gemini:gemini-3.1-pro
Fixes: 551120148b67 ("crypto: ccp - Fix a case where SNP_SHUTDOWN is missed")
Cc: Tycho Andersen (AMD) <tycho@kernel.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/crypto/ccp/sev-dev.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 096f993974d1..bd31ebfc85d5 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2410,10 +2410,8 @@ static int sev_ioctl_do_snp_platform_status(struct sev_issue_cmd *argp)
 		 * in Firmware state on failure. Use snp_reclaim_pages() to
 		 * transition either case back to Hypervisor-owned state.
 		 */
-		if (snp_reclaim_pages(__pa(data), 1, true)) {
-			snp_leak_pages(__page_to_pfn(status_page), 1);
+		if (snp_reclaim_pages(__pa(data), 1, true))
 			return -EFAULT;
-		}
 	}
 
 	if (ret)
-- 
2.45.2

