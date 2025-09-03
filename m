Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB9530E848;
	Wed,  3 Sep 2025 13:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756907888; cv=none; b=lLQ9oYCM9ZgCelvJOA43mo/feEldFRBIT49yl76IwruPyww1PudreF+7vXfIysKHQbrWtXQZ7FkLNmZ1/LDJ8bG71TfZIfjEk4kxxYuv/9zCoJMNwUurdubBzjaz/z9y0qL9EMxQOV9M6X7azVoNgOJAVztoRbQH6TPfDoXUUCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756907888; c=relaxed/simple;
	bh=Cg+cy/lnJVTJNsMBnsyb2jSqgWGsEaA2DBFAw5Fw3xI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JGTPnCWadFKNHISx8ZSgUJynwxpUQlh0UcxQHyM7awYXWSLIeIZpwoidT+UUd2sZ5XyQMfxxq3ePharl84TgjxV79Rvx3qIeh5IopgK15GN8nyVIN3BeqJ12kIcJwws18DqU5iVWPzSMeTyLQ7YOE4c6rNUfpgFHFGXwwR4cpUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kzalloc.com; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kzalloc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-76e2e8d14a5so379454b3a.1;
        Wed, 03 Sep 2025 06:58:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756907886; x=1757512686;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9032Jz/PsnxJvtA1xEMwXw5STUoeplAEmM12lWCypOQ=;
        b=IY6xJAxORzIuxaHxSnHL85cjS0gMd7JpeqCmbABS6rhSpApKs+oExr7VLu0cEqzqA/
         mOLIeE4hSvQpCy57Iac97/b0cFSa7QMzUrt/0eQH0lhYSOwmXamkOsE2hQdUHUGpwX8+
         V5OeZUwtz6oURbmXE+PHQaqr1yQCxsLgbpsKLjit/5iTeVIZ69THa8KP5Y3AYF7nslBv
         MCtZdhyj19fUDrIinjaO5/qjD/3uPLGPzPSsVDDX31QsIXQSPWBmeS0PaFhCbGG93OqX
         Eft6/eX2moWmQB59t7T/RcQnrHHTXVGGfxRgRNpoFPBuEDYnVbJOpZsK5HHn/npqfMRT
         9+bQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtrrZoEYlevcMBU+Cgip7ckJ2/a00JuQuo5pU0JCdzg2ClTqzoePZNpobJNSHG0Iir7Q/lgke3R4jyJcs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBu3/YkwU9iWBLbDC+yZTn2e9iee5WN7B/bKCG5jvwd+D9u9QP
	iM4HKPWWOBNBO/k8+CU/4cAcToF+gPMkgkYfh3BJ4SjP8ToPROU4Tq8s
X-Gm-Gg: ASbGncs5FN08WTP5xO+BUkzffsn/IHrbRPEN9626Pn7CyW7pUCDMLhFb4GiAgVYuPhA
	DHatSFmUhTPQmSpEjYiDsZoo5qK4GvxRDcCLYnD0h5e+jRwBl9WvDq8kwn3O6Dd7B+cyI9ETa4a
	O5ZHV900t3Joazs1yl6e0pHatsaKpMdMd2iw3KXRxvRVSXZINx1vUe0OslekX5unwpFTvI8t/SP
	mFdQmmcocbdIkj+To4VzCU/Vy+whBAfVox+P7YYJPAb2Lr0gX0Yo8S6BykiVYQDnl5WCp9TwHsx
	jcIOUtOMQDV7mIl63QxxumBtmmKOc1EIkr7ctWRhk2ntb6MpIYHfCW8w9GrjIupWxqtbiKVovBH
	/QPF3w8v4kSxcoLuhW8KMwIpPxZHmj/GKZvRkhEZKCNGwGqA6dVkpClcHd8QqXiN/lWkksraxn1
	vM
X-Google-Smtp-Source: AGHT+IG/Nc6usOhV9GI3heocP5VFgPcAb7FV56GLt+q4kD+TNRvrfxROfbqTjWdNs6cMI+8gqFeLmQ==
X-Received: by 2002:a05:6a21:3391:b0:203:cb2e:7a08 with SMTP id adf61e73a8af0-243c8457780mr12685594637.5.1756907885661;
        Wed, 03 Sep 2025 06:58:05 -0700 (PDT)
Received: from Mac ([118.32.98.101])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a2b7d10sm16947130b3a.33.2025.09.03.06.58.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 03 Sep 2025 06:58:05 -0700 (PDT)
From: Yunseong Kim <ysk@kzalloc.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yunseong Kim <ysk@kzalloc.com>
Subject: [PATCH] crypto: ccp: Fix incorrect return type for psp_get_capability()
Date: Wed,  3 Sep 2025 22:55:48 +0900
Message-ID: <20250903135547.19617-2-ysk@kzalloc.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

psp_get_capability() is declared as returning an 'unsigned int'. However,
it returns -ENODEV on failure when it cannot access the device registers
(i.e., when ioread32 returns 0xffffffff).

Since -ENODEV is a negative value, returning it from a function declared as
'unsigned int' results in an implicit cast to a large positive integer.
This prevents the caller psp_dev_init() from correctly detecting the
error condition, leading to improper error handling.

Fix this by changing the return type of psp_get_capability() to 'int'.

Additionally, change the type of the local variable 'val' to 'u32', which
is more appropriate for register access, and reformat the long dev_notice
line to adhere to kernel coding style guidelines.

Signed-off-by: Yunseong Kim <ysk@kzalloc.com>
---
 drivers/crypto/ccp/psp-dev.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 1c5a7189631e..84dde53db25b 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -140,9 +140,9 @@ static irqreturn_t psp_irq_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static unsigned int psp_get_capability(struct psp_device *psp)
+static int psp_get_capability(struct psp_device *psp)
 {
-	unsigned int val = ioread32(psp->io_regs + psp->vdata->feature_reg);
+	u32 val = ioread32(psp->io_regs + psp->vdata->feature_reg);
 
 	/*
 	 * Check for a access to the registers.  If this read returns
@@ -152,7 +152,8 @@ static unsigned int psp_get_capability(struct psp_device *psp)
 	 * could get properly initialized).
 	 */
 	if (val == 0xffffffff) {
-		dev_notice(psp->dev, "psp: unable to access the device: you might be running a broken BIOS.\n");
+		dev_notice(psp->dev,
+			"psp: unable to access the device: you might be running a broken BIOS.\n");
 		return -ENODEV;
 	}
 	psp->capability.raw = val;
-- 
2.51.0

