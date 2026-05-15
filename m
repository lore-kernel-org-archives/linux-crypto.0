Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082E53806CE
	for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 19:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778871768; cv=none; b=RIw0imX/7JvzvD834VfQQvAPgJ8a4NK+MDf2jIhG/Olv9lXU5wLzBlmh4oRjRo1jcVWH2lnbkyVrSwQtRn1rjDFmB0yBODIwhD9420hY4sWHRl9Hmbo91KmRgakj5p+0bj416IXiO/H8LvCr97JQkf5PrtLxwLTX+dZIkKU7Fmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778871768; c=relaxed/simple;
	bh=y8b4zzudyE397marBViAbV8N111gNUULioianPD4kNI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mHpf8S/qA2Spy6O1ntpkOXxtau4iuOOGNUskw7LboSulKJtz8mCkhUwfdfLIQ+LAWl0s8DBqlKjMZrT6n72mwe52Jwc55fmQQDGIxKB/pfCPnvpTiK9BKjGiaLYxgFy3QLu1Mkxo8hLeY9MHTivNV/8cLdp6NhUAVDTZB72pmLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KVNwdMYm; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=EWd8NWLr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KVNwdMYm";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="EWd8NWLr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778871766;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tYElUD/qqoaFAUdogkyA9QDrRQvEojGIyiuybZX26ZU=;
	b=KVNwdMYm1kRbuCwfL/HiuN59Fh2iDM9zMFfDgQEYu4aNb2je/8JGN52bbzTC+/AjzbDeMv
	YotG99WETgoMtAEYAXApLUucHjXmTC0Z6SiqPwprX3IKhDYs46fsCyCNxrpPNIfFuDJlrL
	x1w9zoT88yJGnvJr8I9qdo5hqhffPCA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-rlmFOgfdPoC-IaVaXVk1dA-1; Fri, 15 May 2026 15:02:44 -0400
X-MC-Unique: rlmFOgfdPoC-IaVaXVk1dA-1
X-Mimecast-MFC-AGG-ID: rlmFOgfdPoC-IaVaXVk1dA_1778871763
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-488d3eec9bcso700355e9.3
        for <linux-crypto@vger.kernel.org>; Fri, 15 May 2026 12:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1778871763; x=1779476563; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tYElUD/qqoaFAUdogkyA9QDrRQvEojGIyiuybZX26ZU=;
        b=EWd8NWLra0H3tSmn0IdzHPJroqSTGc3c3yJFetjyKuK017ZAY4ys6bRCgmuBFpAEwT
         30H0KRapHnMWGVAlacrT149WHyKkEl5Ob2QSOCnP6ou7PK86WVrz5PqBuPiwgPviLqJr
         3HKkTGhDpCls9dbx63zjzhmGCtYorOPkjVUiOTHR2XHzfDJX+S/kWNOgm8ZYUWm/8r35
         quIp2poxwIRFZaDnH0lw50xzjEHvyAiIgKQi5Mu/iNQA72fk3HI5GdS/pT02ZyFxtL9i
         sDsQSe6Y71WF4xxKakeJujpH23Rr/D7jrgsyln2nbaZ47ep42186xmiiwJ+1O3FrdZ8O
         bgSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778871763; x=1779476563;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tYElUD/qqoaFAUdogkyA9QDrRQvEojGIyiuybZX26ZU=;
        b=psJYL0fhXu+sQ7TRTkqZKTny431o3NAE/rTIvSc6qkoRU/6Nej+duZx1RouiwY/cH2
         DblYZktNPt03B931j8ky94q93fc5mNbzD8McWLt9OZe2ACDEhzvgPbilIXHWgeGVkWQl
         JiIMGDMSTHZibgoFec3LkoRqXSCo3iLDmeBuTzs4Yku2BUGQzWjjD9i9aCIcH3YF+hd6
         4OpPBggb3ha5atMpp77O5UmKeqepZbps9kptPQo3WeII2b1KbJTcRLu67pSz8W2ucukz
         SHMnLu4Y/uZooktCmpRktTphOWK32gv8B28saN/Xy4rQuzoReJY79muRJ/RFvE0UhCVu
         tU+w==
X-Gm-Message-State: AOJu0Yy9RN5guPJwoSx4YliKilYSWMQouFv9O9eXmvL+PDqSaJ2bNYJB
	fw02QiGYzoObSco+hiC2O3MFhN8JUMvsl7y+IcW1WHo6xjf+GYzmC42eVmY5FIpFzaSJOQVMTiS
	m7SWOiIMDqLkukL4Iitbtg4fN5vV2JDHn+U5fN9XArp4WteMaxIar7qtBaA4k96k41yNsN9HCUG
	Hm
X-Gm-Gg: Acq92OEymHkCWvzIrDWiNejOItBBs/dGCyD3nE2RK+LVHI3xqt0jbHIojdI06DadcfA
	FIsnycDt1Lrql8GP//bAxUVSH1gGrSaX6swzg8VGTUxKDxC2xCwSiZCWS0ZdQ69xMO1duD1bRae
	ojlS7K+gry9tYt3xzmMjdxoWYkFieY9OGcsCuJy5g4gQSDt+goBNxkQrmA6I5ge7aveB3aDHtbq
	V2m6TWTFK1Aebax+2UzsAVVa2yHxac0rQaOXDZKsOr5764gYY7GLXTxrAZNOG/kvSlUpmE3OBCB
	8etpk289RFQzRfxJLp50plEkqd02OvFG7eaj6NSbNfPG5Z1BHMnj7iFedA268SwEBKd9iY4PhWc
	1mY4hqEr53dSoeFgItArmcczGDVJbhvE58Is=
X-Received: by 2002:a05:600c:3492:b0:48a:52ee:5776 with SMTP id 5b1f17b1804b1-48fe60e79eemr80824635e9.11.1778871763091;
        Fri, 15 May 2026 12:02:43 -0700 (PDT)
X-Received: by 2002:a05:600c:3492:b0:48a:52ee:5776 with SMTP id 5b1f17b1804b1-48fe60e79eemr80824055e9.11.1778871762661;
        Fri, 15 May 2026 12:02:42 -0700 (PDT)
Received: from costa-tp.bos2.lab ([2a00:a041:e223:1b00:fe51:8bb:7986:c897])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe4c88495sm81843535e9.4.2026.05.15.12.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 12:02:41 -0700 (PDT)
From: Costa Shulyupin <costa.shul@redhat.com>
To: Linus Walleij <linus.walleij@linaro.org>,
	linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Costa Shulyupin <costa.shul@redhat.com>
Subject: [PATCH v1] include: Remove unused crypto-ux500.h
Date: Fri, 15 May 2026 22:02:14 +0300
Message-ID: <20260515190220.1534187-1-costa.shul@redhat.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The UX500 crypto drivers were removed in commit 453de3eb08c4
("crypto: ux500/cryp - delete driver") and commit dd7b7972cb89
("crypto: ux500/hash - delete driver"). No file includes
this header.

Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Costa Shulyupin <costa.shul@redhat.com>
---
 include/linux/platform_data/crypto-ux500.h | 22 ----------------------
 1 file changed, 22 deletions(-)
 delete mode 100644 include/linux/platform_data/crypto-ux500.h

diff --git a/include/linux/platform_data/crypto-ux500.h b/include/linux/platform_data/crypto-ux500.h
deleted file mode 100644
index 5d43350e32cc..000000000000
--- a/include/linux/platform_data/crypto-ux500.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright (C) ST-Ericsson SA 2011
- *
- * Author: Joakim Bech <joakim.xx.bech@stericsson.com> for ST-Ericsson
- */
-#ifndef _CRYPTO_UX500_H
-#define _CRYPTO_UX500_H
-#include <linux/dmaengine.h>
-#include <linux/platform_data/dma-ste-dma40.h>
-
-struct hash_platform_data {
-	void *mem_to_engine;
-	bool (*dma_filter)(struct dma_chan *chan, void *filter_param);
-};
-
-struct cryp_platform_data {
-	struct stedma40_chan_cfg mem_to_engine;
-	struct stedma40_chan_cfg engine_to_mem;
-};
-
-#endif
-- 
2.53.0

