Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32AB15ADB1
	for <linux-crypto@vger.kernel.org>; Thu,  2 May 2024 15:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714664104; cv=none; b=T+n7BN+yqPpzPUQ2lO8A2x7D+B0RQY58KIgTwkLvEKS7BKZhaqAqH/Y2jwLW+oIL1DQMWqyrFfpMYSLnkAIaENgCX4SNtwqKUafDkpVKczmGRauatT8jpqJGyZA+BKSlP8/DiahoWDE5uTOM50/kXx9Uql7EmoFelOp85BzhXUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714664104; c=relaxed/simple;
	bh=R+pJmmxpNrZ/XJxigie9GtGPdSpA3KgFHVA0wipAK7E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MoEge3UujmNAU0n67ToQqQ1EQguBwgQ0vH82Vm5x+ZQvUqK0S3Mw2WFk5tE5iNzsA988T5YoAptxV5jm8XMhaIm+X3uLwINQabTFYUPGvk+qM5Yq3meR082feQ1nSyauOYBO1W8cXRwlL0FezeDPTAIHmicbLNgDBZBs4RBJ1NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=yScL0wg9; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="yScL0wg9"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a5966ea4fafso191335466b.0
        for <linux-crypto@vger.kernel.org>; Thu, 02 May 2024 08:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1714664100; x=1715268900; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ce5FXE5idr82jeqevYO8YWeQ0hM+JzLoZr03p3rxaCE=;
        b=yScL0wg9qUChw1cmaZ3tDo4DHELgq6gUPBj5+tZ7W/eKXER+BT9WKBfsuWTWWDXL/d
         tkBSsxbh7S/DxXRT/a+KuLYpv54ihMRiljBcSetSqEZqGCoO3MSF5CB9BxIaDZl88Jet
         pP8aTSfeZioalHZ2rAohCiVBBoJ+mOovAXk52PwCh5/lLbi3eIfGHwZRgZDsBdrNcCgC
         CmeSqjp1YhEG3XQAO1QJJq2rPpY6H+j6EDIWLdW6A3JbPkANaPWtsLkeolS7Lu162gLU
         2/Y4znvNX42IofJg7tBbZZpgkWHHmSnwTeSu1LMPtFxibFRskkyfpb6TBTAnI6aFPibC
         Cpmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714664100; x=1715268900;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ce5FXE5idr82jeqevYO8YWeQ0hM+JzLoZr03p3rxaCE=;
        b=phTM/RWBQ/rIFBQ6k+pFGUwVxhkXTC9OIeH9/E1cTHjSCcjV9dqI2TueCxNUCxJ2D3
         59j1chWVF861f2r+5T4llG5xIyCrL3tXP6AW/deDGxLieqWdFI4FmTMLN3KshDAkElLy
         hhk9OMm2vGrs4FGkeleYIFWkc0Kbv1NtxgJY40fPZiIGARWXgSIPETq4vzO6uN+l07R/
         XvPKLVvgKHNmoZDLaM9RtZjTVrK3Gt57Da5zAiClES2CQCHW3+RAJpBp6rqyxqGo4oK3
         nWR7+sJmBACi4rS2dlmSfFA97kgLOkFPvtFIPBf/1kmXlyAXeZdIcLYkvL9TCHvJe6u4
         6X5Q==
X-Gm-Message-State: AOJu0YwYpcIahpdwOoaB7xgIvhBxQOurWP3FEwzNPKmDhYNw0KiAtD+e
	IVBev+j9PZMB7oVZuesL1ueWCXEuclCqCT19zI8Shlt6kR3VFT5NHP3FtXgFq3g=
X-Google-Smtp-Source: AGHT+IEQfs59rIUKVTrOCgSJ3jKTTUJ2JzRMpQm4fmKS62RfKZlGAhSLcI0NsdYjXVyyfSKA9TdCqA==
X-Received: by 2002:a17:906:6a05:b0:a58:7ddf:1805 with SMTP id qw5-20020a1709066a0500b00a587ddf1805mr3302521ejc.7.1714664100017;
        Thu, 02 May 2024 08:35:00 -0700 (PDT)
Received: from fedora.fritz.box (aftr-62-216-208-100.dynamic.mnet-online.de. [62.216.208.100])
        by smtp.gmail.com with ESMTPSA id j21-20020a170906279500b00a5587038aefsm675107ejc.156.2024.05.02.08.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 May 2024 08:34:59 -0700 (PDT)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: Tom Zanussi <tom.zanussi@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@toblux.com>
Subject: [PATCH] crypto: iaa - Use kmemdup() instead of kzalloc() and memcpy()
Date: Thu,  2 May 2024 17:33:39 +0200
Message-ID: <20240502153338.6945-2-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixes the following two Coccinelle/coccicheck warnings reported by
memdup.cocci:

	iaa_crypto_main.c:350:19-26: WARNING opportunity for kmemdup
	iaa_crypto_main.c:358:18-25: WARNING opportunity for kmemdup

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index b2191ade9011..7635fbebe52f 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -347,18 +347,16 @@ int add_iaa_compression_mode(const char *name,
 		goto free;
 
 	if (ll_table) {
-		mode->ll_table = kzalloc(ll_table_size, GFP_KERNEL);
+		mode->ll_table = kmemdup(ll_table, ll_table_size, GFP_KERNEL);
 		if (!mode->ll_table)
 			goto free;
-		memcpy(mode->ll_table, ll_table, ll_table_size);
 		mode->ll_table_size = ll_table_size;
 	}
 
 	if (d_table) {
-		mode->d_table = kzalloc(d_table_size, GFP_KERNEL);
+		mode->d_table = kmemdup(d_table, d_table_size, GFP_KERNEL);
 		if (!mode->d_table)
 			goto free;
-		memcpy(mode->d_table, d_table, d_table_size);
 		mode->d_table_size = d_table_size;
 	}
 
-- 
2.44.0

