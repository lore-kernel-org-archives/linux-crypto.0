Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA81370ACE
	for <linux-crypto@vger.kernel.org>; Wed, 15 Jul 2026 01:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784078138; cv=none; b=FE0K51jAUmYg0PHcwOzGu8QmkxQ+TqD0w6kT6DwUqA5JERIiYT919+Ab03qQ5vwg1acw0RnENf8w0GbNZ7Ba5g3o54oH/bCNRpZPW8PEUST2ydn/OOYaFICGagVgI8yoA72r+s/UAQIq6wQ6i8NjECAE8JUllAL5RFq6vf1A+Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784078138; c=relaxed/simple;
	bh=rsXZicNA6CgICpzQ4UlJMXAShtqDyxeuEyA3g+edfNE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DHFJYX368eCUKDOShklgdaS3m2xfznd2peqkY49PVcjTkXfBDM9nPP4Dytjb303KZ5d5/B/KQHa0i3Q+rcP1dQsgw//0q3bE1+h4I/10E5TpLR6DVbwlkUU45snOopyNTyyuvFhQoKhsYXVeOPVIT8ll3h0WSMSWrIWNuG754+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OLvBOWNl; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OLvBOWNl"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-38e041ea211so2249724a91.0
        for <linux-crypto@vger.kernel.org>; Tue, 14 Jul 2026 18:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784078136; x=1784682936; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jcGjK0t9D92tDFqE5kgmtmyyKNtamGW2f/Lgn1+ZlUM=;
        b=OLvBOWNl0pYQx9/zPqrD/sX1yUdS114/Nme2gYqwbqzm3SvfAT88tvntNqIF3BCyZF
         nvJG3SrLn6Y4UcuIxI7ZTGaFjT4jANX1WWVbIPuK6Q6slkl45Z4b3wMQNdKVanH1hiEt
         82XviDQax+mQiZJHGS9vosKKDp2PHUTXbvwVM/dPsz2KNN1nQsI5pHTsMvnQ9q27awjh
         7Kbby73NlWpGUgUuRDaNEF9L/s+DWQdsjFt+oe0BwGHWvVFKTl7KSX1egjypXq5AEF/u
         rNN3o+GRdW9eaVpgdQ2FQWrzt1wLhIAJfAoSYw0vTkuDF0iFHzpca9GSUBJwFDPNRt1c
         0R0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784078136; x=1784682936;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jcGjK0t9D92tDFqE5kgmtmyyKNtamGW2f/Lgn1+ZlUM=;
        b=BkbjkuMrsr/1GQWfYzmcZQb27/F6FxtQ3uSQ+UKg8RX+wc7K0sU+cjCNHWXJJ6vMi/
         KZs9NS1vahJ4TSWaxvnDHumwI2ekTQthKzGJtgRL7JHvAjqFV8aVgRxZJNYMr2hprS/W
         9Fco2/+rCJpv6UsO2Dn1Y/ZqO4zjT6l5nQQOjyZeQ7LQRAS0rWgxlo0+8izdUuNmN6uE
         TFz/VzK2Gc2aK0iRrnwjmnG/HJR51dMYuAJGd6rpwd9TdWEFuamSlXSU+IBKJNKleq/2
         N70jjmT6SJf4XMtmNR7PztjkmrA7CMraO91hyTTggQ4wASqu9XwIc5bhAMtdtKvHRDQr
         IoAw==
X-Gm-Message-State: AOJu0Yxv2+Z3RpgCBrsb0qFImzjylwBG5gBxmDnkS0AJgretbkJx01vV
	JMrUVEOsHeO2Mahcukgm0QHoEbWTptZOz1zh7qYJ3KmgV6YM9TelIT6nfpousseK
X-Gm-Gg: AfdE7ckTr+iJzgZtbrtg7+ZrPr0tu/hcrO4EMEMjaVG1uUw82iRJcFe4bAVz7enh96U
	NCEKRH0E+2+rtHelN5757gHfu1/3pUzNOsqQ/1MbF6z+55wX3sITVRZBaX3dxsSKJUPUY+oKj+E
	sxaI4b9Rznwfc0Dyt2LHmj9K7tIfJwk5Vgsr11l6teUYkHcy+AnEWmk8UvKb392dF9cQIA7TIGu
	+lTcFjWWXA9R5Bu8JvXvIqOZ+YNKeIP4btVPP9AAfQqmS9dm8Ew9VLmucwoS5poLUN9Tz3aveg8
	OP2P/1QElZ9+tgFwKcqeouQFVpLHfZjhonxIWEF3crNbtli4cxm7ptmJJYNhc/yaTnO7tq72DFw
	Q0n9EMCDz67u4CGiYAocDk2i74nYr3imzvUFZW8C2evmGrBM8Q0qd6RAnmCvH1Ref6JPHleGvAF
	ze5UhvOxt5BpOaXRUyLOYfP3Hx0lGbHeUfkH3PexPe8biTY8RKcnERtEBIRK3w7FXAV2h4au+iF
	h58WCqCnkSj1KuxpNWJ50/xUK76oHrQ8/D22csTYb3wpr2FMpFZODTK0J8eySt7HQ==
X-Received: by 2002:a17:90b:4cc5:b0:38e:2524:7272 with SMTP id 98e67ed59e1d1-38e25247950mr2152483a91.39.1784078136280;
        Tue, 14 Jul 2026 18:15:36 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e34])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31198cb2b99sm58425447eec.26.2026.07.14.18.15.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 18:15:35 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-kernel@vger.kernel.org (open list),
	llvm@lists.linux.dev (open list:CLANG/LLVM BUILD SUPPORT:Keyword:\b(?i:clang|llvm)\b)
Subject: [PATCH] crypto: hisilicon/sec: use devm_platform_ioremap_resource in sec_map_io
Date: Tue, 14 Jul 2026 18:15:33 -0700
Message-ID: <20260715011533.1278258-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the open-coded platform_get_resource() plus devm_ioremap()
sequence in the SEC_NUM_ADDR_REGIONS loop with
devm_platform_ioremap_resource(), which fetches the resource, requests
the region and maps it in one call. Switch the error check to
IS_ERR()/PTR_ERR() and drop the now-unused struct resource pointer.

The driver only maps indices 0 and 1 (SEC_COMMON, SEC_SAA). On hip07 the
corresponding reg regions (0xd0000000, 0xd2000000) are 0x10000 each and
disjoint, so the region reservation added by devm_ioremap_resource() is
exclusive and does not introduce overlap failures.

Built for arm64 (drivers/crypto/hisilicon/sec/sec_drv.o) with LLVM=1.

Assisted-by: opencode:hy3-free
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/hisilicon/sec/sec_drv.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec/sec_drv.c b/drivers/crypto/hisilicon/sec/sec_drv.c
index 129cb6faa0b7..2514a5e1f9b4 100644
--- a/drivers/crypto/hisilicon/sec/sec_drv.c
+++ b/drivers/crypto/hisilicon/sec/sec_drv.c
@@ -1010,25 +1010,12 @@ static void sec_queue_base_init(struct sec_dev_info *info,
 
 static int sec_map_io(struct sec_dev_info *info, struct platform_device *pdev)
 {
-	struct resource *res;
 	int i;
 
 	for (i = 0; i < SEC_NUM_ADDR_REGIONS; i++) {
-		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
-
-		if (!res) {
-			dev_err(info->dev, "Memory resource %d not found\n", i);
-			return -EINVAL;
-		}
-
-		info->regs[i] = devm_ioremap(info->dev, res->start,
-					     resource_size(res));
-		if (!info->regs[i]) {
-			dev_err(info->dev,
-				"Memory resource %d could not be remapped\n",
-				i);
-			return -EINVAL;
-		}
+		info->regs[i] = devm_platform_ioremap_resource(pdev, i);
+		if (IS_ERR(info->regs[i]))
+			return PTR_ERR(info->regs[i]);
 	}
 
 	return 0;
-- 
2.55.0

