Received: from mail-pg1-f195.google.com (mail-pg1-f195.google.com [209.85.215.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2762765FB
	for <linux-crypto@vger.kernel.org>; Wed,  1 Oct 2025 07:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759305509; cv=none; b=qmmcJUOJalv5JhsGyZlFguFPthFCS2RLu9m/043l+xRfI5SegAS4BA2yVaX5JY9BiQNN5YP/PLJdX9gp1uCErAf0T2AfntYkjHH9JyBDgbd54zSchv9LsPW2hrYGdUQ98Y/9wJWawbO2rpg7joed3KsXnHxfNpoRKmtLIhISDVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759305509; c=relaxed/simple;
	bh=N2I1H/EgePZbtvBo25uP3wJB4pP+Q3rAkJ0WZH591WI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SLbQL6el/G71EN8EYC8K4TYw0n0YtnMUJ4dFRZWKKNccsz0b4ASBPBc0G4yTgBoJMfp22YtNk9W9/jDlDmRFblaS+q4czar5xH1iANWFfq1Fs3s/dFjzCAq+b0M7GqPcDcR1/2RZX8LvKu6TsOg8jpmkVwMGjs5hqU/dhyBliIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TNlXwBQ5; arc=none smtp.client-ip=209.85.215.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TNlXwBQ5"
Received: by mail-pg1-f195.google.com with SMTP id 41be03b00d2f7-b556284db11so6645778a12.0
        for <linux-crypto@vger.kernel.org>; Wed, 01 Oct 2025 00:58:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759305507; x=1759910307; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DnIZ0TeoMvk9CCEY2SlnV7jnxp2bLVOIPlczZP3SYN8=;
        b=TNlXwBQ563KTLHRxyvkdiTAlr+jU/r6+RC+t34TPgvF8pu98+G+jWHyTSBwNVrIhh+
         0f2qyJYyR+HZ60l5rwfSABH1T9Kj6KyzLJnHpeDw6ukCQwovDhrFqSu4+eBqGl5tuo98
         UmC0voXBVTUo1Chd0Dize5mJ++KdWmkd7mfhZdc+w+t5fd69ntHALQLVeOAvBzkO3YGo
         ior5vqLbV1QVmWr/njikCXIH3QA+UsuNLdhTTLkGqte/zUKQXTI7zJrXjSK69vNvdPGw
         FfE7B9hgX032B4ToyT29/61PWL11KR1D+tNHcECfgdHQiCC5OmqyEIp3ouWafZGm8WoF
         gAYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759305507; x=1759910307;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DnIZ0TeoMvk9CCEY2SlnV7jnxp2bLVOIPlczZP3SYN8=;
        b=UINvSokbRmGLmTylGTVfIvUCuZXUmR3kgmpyGu6jfUkenas7g8ZwIqQeRbIOMCweKt
         kt8WSf/05oYhNw8iEEF3gFypGfJuSKii7PnMQVLe1PLqtcFegblftL1xMNDO3puHylyb
         fMa1A2NIuB7nHaAp5i3EEK+nXSbYD+lL/zbi9mDAyOOkCx7bLHetsAUsXo262qJskPxC
         pk/pddzP9dhcJpCm1yP6/p63iYuQHqtko2DsjoAkS2NKXp9e6cIW9QMCc4jYjCLqGMqN
         +4BZBubtTKvbdyjD4PnLDA89+87XQ7Bpgs+bmoi/CGs2c6ZV1wDi8rvQgo4zS3MdqZ5t
         Pi6A==
X-Gm-Message-State: AOJu0YyQ/lPEhQyrdOF2ooyFwkRoZ0a6Da/Ayiid4YEHO6pDWto7GWX3
	HSBcFOv0dohV6G57DcZkOhTo9iRNcfxn7i4GTO1kXtlgnp3P5Rdqh78f
X-Gm-Gg: ASbGnctdzwqPWLJQvaiy1gBnbOBpXbm9lujm6HCNl/gzjLJ4ZJgQhfzchu+zwz/SScZ
	01oL151tnoMIyWg0iAgP7qjFbClc7kQitbND80NVVX+jQTO/VtVXz24RcRxwMTkciyAXMmt+JsA
	odlOiVQTSw2Gi/P/2dRiA+/QEduiqk0rZjtg4NGwOdm3qLXroG++hLj2P3TYWh179rymL2iQ6qZ
	2sv/jyuRzxV28n+WugXjn0Ua3b6sH6qJRSsDSRIMgI3Jrb5CQ/hsxR9OQIDztL+fTGzWtXy3yUk
	0IVnr+2pyZYssWCGLoGS9MUVHGUdvw58DyJG7aOLDOo3DjEUmDCGBkqWJUR0lvrWapSgFTnlBEV
	+q4+7QJRQWMkt9SQ9AiTvfaRHunDcag==
X-Google-Smtp-Source: AGHT+IEgSy3v/uPt+4KvsdPnlOkJBed4MJ2OgBhCzYLrYHtZnwDHH0pn2KL1G/JaRiDosOce0dljsw==
X-Received: by 2002:a17:903:40cc:b0:267:d0fa:5f75 with SMTP id d9443c01a7336-28e7f16795emr32870995ad.1.1759305507128;
        Wed, 01 Oct 2025 00:58:27 -0700 (PDT)
Received: from archlinux ([2a09:bac6:d739:1232::1d0:a6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66cfdcfsm180806485ad.26.2025.10.01.00.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 00:58:26 -0700 (PDT)
From: kfatyuip@gmail.com
To: thomas.lendacky@amd.com,
	john.allen@amd.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kieran Moy <kfatyuip@gmail.com>
Subject: [PATCH] crypto: ccp/sfs - Use DIV_ROUND_UP for set_memory_uc() size calculation
Date: Wed,  1 Oct 2025 15:58:20 +0800
Message-ID: <20251001075820.185748-1-kfatyuip@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kieran Moy <kfatyuip@gmail.com>

The SFS driver allocates a 2MB command buffer using snp_alloc_hv_fixed_pages(),
but set_memory_uc() is called with SFS_NUM_PAGES_CMDBUF which assumes 4KB pages.
This mismatch could lead to incomplete cache attribute updates on the buffer if
the payload size is not strictly page-aligned.

Switch to using DIV_ROUND_UP(SFS_MAX_PAYLOAD_SIZE, PAGE_SIZE) to calculate the
number of pages required for the attribute update. This approach follows kernel
coding best practices, improves code robustness, and ensures that all buffer
regions are properly covered regardless of current or future PAGE_SIZE values.

Using DIV_ROUND_UP is also consistent with Linux kernel style for page counting,
which avoids hidden bugs in case the payload size ever changes and is not a
multiple of PAGE_SIZE, or if the kernel is built with a non-default page size.

Signed-off-by: Kieran Moy <kfatyuip@gmail.com>
---
 drivers/crypto/ccp/sfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sfs.c b/drivers/crypto/ccp/sfs.c
index 2f4beaafe7ec..3397895160c0 100644
--- a/drivers/crypto/ccp/sfs.c
+++ b/drivers/crypto/ccp/sfs.c
@@ -277,7 +277,8 @@ int sfs_dev_init(struct psp_device *psp)
 	/*
 	* SFS command buffer must be mapped as non-cacheable.
 	*/
-	ret = set_memory_uc((unsigned long)sfs_dev->command_buf, SFS_NUM_PAGES_CMDBUF);
+	ret = set_memory_uc((unsigned long)sfs_dev->command_buf,
+			   DIV_ROUND_UP(SFS_MAX_PAYLOAD_SIZE, PAGE_SIZE));
 	if (ret) {
 		dev_dbg(dev, "Set memory uc failed\n");
 		goto cleanup_cmd_buf;
-- 
2.51.0
