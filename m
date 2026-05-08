Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED4F386C28
	for <linux-crypto@vger.kernel.org>; Fri,  8 May 2026 09:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778231050; cv=none; b=FYDEhl6WH61fDD+2nrKxdzl1qjtfIQPOpyi/X3MhL6wI7OFpswUg26V/tHZ0rJnhRBGRcII8PguB985HjnmJ9B+ZvUOgo5YhwZ82/GV79Poqp/0UteWUmjoeoeNRZtLXzK8wCST8Nqs23RRF+pJgpo1wDnBW6RpjwTBBmfjzmSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778231050; c=relaxed/simple;
	bh=zajsfd6Zx0r+0jFiouMsfLQHH3EpQd4NklNufX7L6ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Af8HMuIaTYujon7+Sc/0a4kDoneFDng0AwYk/MATUj5OADPUdpWB+FGOR2jVcLivlMgluP67F5UFsEv3B3iNnLhN7uSUJ3cNVNp+b7fxuz6epBHQvIjBTynmw40EDQUPEnvKplete7eGJvCl+QNJ6GjDDcDMNpxditufXjIKbg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in; spf=pass smtp.mailfrom=cse.iitm.ac.in; dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b=Pszw1Oin; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b="Pszw1Oin"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2b9fcf7c91bso17085255ad.0
        for <linux-crypto@vger.kernel.org>; Fri, 08 May 2026 02:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cse-iitm-ac-in.20251104.gappssmtp.com; s=20251104; t=1778231049; x=1778835849; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jPkAvC6+8Qgyj82iA24dzkSdXJ8Nbp5ATROfqKNJE9U=;
        b=Pszw1OinQ0er7PYgofMfkf4am8zuXx1++Oev4YtaGiBDa7/88b1uVNgDpiaaLBGRqN
         kX31CHkjgsp14yf41FkqW6oSAGn1jqF0fkSxU9pbWAGpbaOWnuQ8G4EASJH6EsuqvV7r
         q4HMr6Kx6hMCYvDcaS2u2rBPwcZM3SgPSrGowi+uLa7c9DXpsd/K6pKO1TOZUbUGgL66
         ZK8M9O2daVshz//FLRV/xfhcIPpzzwD6VturmItMo8DblVPjzHtFkg/GVD/dKHXPzAzc
         yN94zVXvZ1nQDFyB9+InG3YTYix1XynlV40rislw6/8LJhb8sDJmOIBPZQIzrGTADuqM
         jhhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778231049; x=1778835849;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jPkAvC6+8Qgyj82iA24dzkSdXJ8Nbp5ATROfqKNJE9U=;
        b=OakT5gZprL9oEn5ooBvNWK/z9nDyGz8sqZbY2qxMOYc1LVTq4tJqKlp6tiPfVl7R5l
         EZF2jQIa6tIPvnyxCZo/aAQyGkueDOWrlu2rzYbL1FpewIB5h+QfPBm+sMsvGaK9IPJa
         yzsJb6RTKW7rGGPuF5mcAah9I5KmIKHa1Hku3Nm18gFUtTK4CtauFMsGyhR0qPjo8S2L
         frpibl2lb/7JmO3HJTv9EjT9RZHz6uBw0sg6OfmBQ/++a7NNi83CVjuoZMUAi+EcXE9T
         zyXkhoQAMKYekd7btnjUm0TWGFVFQcGdFOkF4WFOmZ/oXDHlpmKn5Z+GHcWI5PEMW5vi
         8xng==
X-Forwarded-Encrypted: i=1; AFNElJ/4ER0zj1jzKXJjwQdmKDVT/JleNQ3C9MPuPhuBY19J6+B2UKXRkU9/gNAHu0zcR2kInisNOGZC3TG0CJo=@vger.kernel.org
X-Gm-Message-State: AOJu0YweXz326cBVsjudzjl6+vd2+Dsh8CmJ+p1w6i6S3RqQJDcVoTCI
	/tTFYIFTjc4LkpCGO6/vtAKlXju5tw2c0+UVbz7K5sY2M2aKaCI2tTywxyYh0pwNoOg=
X-Gm-Gg: Acq92OEHCpVz0WUuQmqinA7isCLvFwEvK69MusFG1HN/mgLrurCAzw8SsPkgNs0U5Jd
	zbFIvrdMde/re9fq1s03uzI668bnLZX62+dHmyP+iLRCMbZehUboEgAdTEt+/srM5RuNRw1D6Bz
	Vkp0qhZV3+saHUtH9hIu1F5i0Qr9chyNChxcsKEJQ5P5iuwEuksNmCqzzQulvexX0Nx6LXkL4rp
	db6T7waTvT2PdOj7WVzDEjkkGroyw5fsBQzbVi53m2WNHxEsTnzDaPzlzJsE/VtwXN9K+V8Er8X
	A5+QtEbz1qtRYc74z4aByUtqc0FGsC43u0TgoHn3KlAfP7SIz+zlgudRblM+CRbzpHc1yB4v5me
	rJFKBMmKAR5tZahSPnrnD22QRSaJyPQ1axA0L3IGJAT7yxKorJDEuOU52ElxFv9BUlQs0WTVOWq
	AEgz3Jphi1SL+fu7oHG/rINNb6I7dIGII6ex2ODJTExcyW2tvgD6w7+UOgapmlx8ZAAb/ffppb6
	nD14mT3+lQH1lQ9661OlMfJ5ordQr4wBSR9TN+21pjYuTGhM0n8ANQ6Bw==
X-Received: by 2002:a17:903:350d:b0:2b0:6f21:8289 with SMTP id d9443c01a7336-2ba79c2232amr113703265ad.25.1778231048621;
        Fri, 08 May 2026 02:04:08 -0700 (PDT)
Received: from localhost.localdomain ([103.158.43.41])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2baf1e3571dsm14056585ad.42.2026.05.08.02.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2026 02:04:07 -0700 (PDT)
From: Abdun Nihaal <nihaal@cse.iitm.ac.in>
To: atenart@kernel.org
Cc: Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pvanleeuwen@insidesecure.com
Subject: [PATCH] crypto: safexcel - Fix potential memory leak in safexcel_pci_probe()
Date: Fri,  8 May 2026 14:33:45 +0530
Message-ID: <20260508090347.74176-1-nihaal@cse.iitm.ac.in>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The memory allocated for priv in safexcel_pci_probe() is not freed in the
error paths, as well as in the PCI remove function. Fix this by using
device managed allocation.

Fixes: 625f269a5a7a ("crypto: inside-secure - add support for PCI based FPGA development board")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
---
Compile tested only. Issue found using static analysis.

 drivers/crypto/inside-secure/safexcel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index fb4936e7afa2..2bd8641a07b3 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1893,7 +1893,7 @@ static int safexcel_pci_probe(struct pci_dev *pdev,
 		ent->vendor, ent->device, ent->subvendor,
 		ent->subdevice, ent->driver_data);
 
-	priv = kzalloc_obj(*priv);
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
-- 
2.43.0

