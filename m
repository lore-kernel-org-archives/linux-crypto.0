Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB65219FF
	for <linux-crypto@vger.kernel.org>; Sat, 21 Feb 2026 15:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771686681; cv=none; b=fcCUi6JRJtOkpke5zpAp+0JGJ5WVwNpgrtolUrEISzQjjqs6xX5vsjcCU4QDroAYgYJpTIGMq7mGhJNsUlRtr1jlEc+nC8vW4VwliNhz8X0pZ7B1Zg9GfCyfQPm2JZaxCSLQc7Ak3JayuM/nFNNDLZIluPR/CP5Rx8byMIz66k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771686681; c=relaxed/simple;
	bh=31YwMowNkuM4idkQhWbY+/kiCcVdVFVM42qTq+Hc+Og=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Kqx4EwbguOUX9ORo46Dcp6l52qQ3HrQfjrZIqaSgu7JyZP3Ct5wTL90n7KqU6ZGyapAU7q6ORcupULgBLP/A7eM2McDKMmnbNg0xZ6CsLRzI7XyuAnX0jiFw+EhGMY3afIkhLG6DlaOuS2fj0Spg6xFd2hbaCJ+79j6Rr7e/itM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xw+i1+24; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xw+i1+24"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2aad1bb5058so32258785ad.0
        for <linux-crypto@vger.kernel.org>; Sat, 21 Feb 2026 07:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771686680; x=1772291480; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nZ1v4uZYYfrFz53g2OEyCTHVBc4Ni9iWSFPy2XJU9Bc=;
        b=Xw+i1+24a7ShCNdUHTu3QJ6UUyUHuTHUrHuO+kNehuHppUQBNb+uSzQOl7w6Lwtn5p
         w4B8kzrBuYt7oCq4itdLHvYTdFPlh68tcTNqidcJtBC/bAB5x9umqtv1HILIe+wjAv9o
         /9YpP+PGMSNDg/qfE00m1FUVCYvqBjzxVcAuLtGtlHdO/lmM6ibgZL0XaUagS+SQzgYv
         VlX2wB11hgTFVgmhBl+tOHqCJ30BudirxCUNVJS7MMIbOOqRdJk4zAe704WkiCWP6OPi
         HJPgssQb2qVtlZhirZCPmoEUXTJ/CbgILsheUKTGVra9PCT9WTF8oE58AbcBZzPzznuj
         qp8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771686680; x=1772291480;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nZ1v4uZYYfrFz53g2OEyCTHVBc4Ni9iWSFPy2XJU9Bc=;
        b=tGvFhXc+ojKY4f6ANVtH7uaxb/q1WUGM1OnJVEfqiva6NG1rS13rL8/LsanUBjifD+
         oe7HVAt71j//TRPulfJDDTt4pbWoGn/gHiEPgSvHcNWT4QMePHgpBC1Wrck8YZFKcDx5
         swbDpmURwlsvLKVwnMC1t4vyhm+mRHYp8CBH1YtPRF/JxR710mASu022oPW/+hbb7WQC
         l9K8uoh+59mKACjXMs7HiKe4sYeb3Ji0YcwzPfGJaRIeuGdwtEsMqc9N6Q9e9jKupasS
         v+9RArZId/7eK/CrTx6TqUOhtALGQsBZLQETNMp/AEJeChEo1KH13zbCQrEg7o8lArZu
         iZoA==
X-Gm-Message-State: AOJu0YxUkMTmN8OeFI67mTqrr1HgHPUD0avHlmNp1ITv/WJfKjuwpQpc
	wRopWFx/XNtbTNkqCFC22OwhukH9RsY41UbWsSbjvFoG4MzvNPIpjYIP
X-Gm-Gg: AZuq6aID/GBzhrlLuocRnP0Ux2GCXtr5gSlaE3mQZnDyQG60++8hvnZaFuAnTX5oq7y
	wNO0TiWJRZPIVrS+xJaHvl23wDHTurziU+kZwWkk+Lq8oBhkcET7ezHvPW1hqS8NKssC01Gw+r9
	GOLpmZAwGWTrvx7Fw0bCDm+8BofRtQbi/VTKk3MsJEI936pVa7pf9XS7+VHGBWkDMz8cFopoyfW
	7hmt59BvGvuNk01osow9k5k0zPxIceksuUWOzCDdmmG7ahB7LMxHR7T9uFhIBAt1/Jr1d2QndvD
	CA/thG4jvUc4uKi0DmUtcVnvNkfpnsCgkhppC6UA+nJc5uJamUf57BigYSkmMNBq+U8aYRs8Xyn
	8Gg8DNpLg132o0My7mPRqcmplez88i/RBHkxXW09lb3GXPeNqjtz6dM7n8szbbtMPdPkpUgQpC1
	+hNhg9DHqwgcsNvfdyIa4=
X-Received: by 2002:a17:902:d50b:b0:2aa:fad8:7474 with SMTP id d9443c01a7336-2ad744ec585mr29723225ad.33.1771686679877;
        Sat, 21 Feb 2026 07:11:19 -0800 (PST)
Received: from lmao.. ([2405:201:2c:5868:cba9:7936:c19a:9313])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad7500e346sm34517345ad.49.2026.02.21.07.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Feb 2026 07:11:19 -0800 (PST)
From: Manas <ghandatmanas@gmail.com>
To: davem@davemloft.net,
	herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Manas <ghandatmanas@gmail.com>,
	Rakshit Awasthi <rakshitawasthi17@gmail.com>
Subject: [PATCH] Crypto : Fix Null deref in scatterwalk_pagedone
Date: Sat, 21 Feb 2026 20:40:41 +0530
Message-ID: <20260221151041.65141-1-ghandatmanas@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

`sg_next` can return NULL which causes NULL deref in
`scatterwalk_start`

Reported-by: Manas Ghandat <ghandatmanas@gmail.com>
Reported-by: Rakshit Awasthi <rakshitawasthi17@gmail.com>
Signed-off-by: Manas Ghandat <ghandatmanas@gmail.com>
Signed-off-by: Rakshit Awasthi <rakshitawasthi17@gmail.com>
---
 include/crypto/scatterwalk.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 32fc4473175b..abbb67391710 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -78,7 +78,8 @@ static inline void scatterwalk_pagedone(struct scatter_walk *walk, int out,
 		page = sg_page(walk->sg) + ((walk->offset - 1) >> PAGE_SHIFT);
 		flush_dcache_page(page);
 	}
-
+	if (sg_next(walk->sg) == NULL)
+		return;
 	if (more && walk->offset >= walk->sg->offset + walk->sg->length)
 		scatterwalk_start(walk, sg_next(walk->sg));
 }
-- 
2.43.0

