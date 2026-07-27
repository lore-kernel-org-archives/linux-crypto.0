Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A883EFFCC
	for <linux-crypto@vger.kernel.org>; Mon, 27 Jul 2026 22:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785192581; cv=none; b=RE4iNeVtejzdrsYrzd0YdJAPGOhoS862vKkPk+JL2AgEKtGSTsHivT9XKx9ljqXf90bdvR1dPQYpKq9FITZK8Zt4QSx7Mj5emFgsTqk+a+ZVRX/G8cKO6YRradCFw6gmZ+9EcVPqF2BWLxn7wNAtLv4I7NypK4d9PvktqnLms2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785192581; c=relaxed/simple;
	bh=8H7JHgiLaU/ijwccmJiKbKzu5HBvFDH09Jmq+QyvNGc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=laTE6xOrKvKD/0OQ9Mb/gSuvrm4qjkYKeti4YUHKuxI6VA3pxwuGvMLZomoZF0E8reR0XT2non8gYbCJLWZnSu/rNebgPo/SOOzLiNTmrVt+Gt16vPtQj+4rrcf6/TNZa+a5TZrPDEadRV1SupR9Mjm7YSpQ3npMIS3sn3CcDDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=JHsL+m9A; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="JHsL+m9A"
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 0853A3F997
	for <linux-crypto@vger.kernel.org>; Mon, 27 Jul 2026 22:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1785192190;
	bh=956NfCuSF/TqqzmWFsuMn2yMhAz0GO/MfVVWa/Wqj30=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=JHsL+m9AZ/M0kmDCYdGSysbEFWkDJvhiOnGB8jQlgcMpcBgqkHyInaNsE+d8X73J2
	 7GiOgfpD5M9v0tT9oES6TQcpAiThGQUCUUivbAmREG4boR4yG4DVwUFGoeFAD/qP1y
	 mz1YqCkuanMKPec3QlwCzz8XVezrviUTgcUkLkfZWJgOMRaroxr1MhRk/m/dFv6NeC
	 L3uK0J1TV8A8dpDBCYYiSdZX8JUMoSsgwQohRC3UVwxRCnDwz5tIY1QpTrtuYbQjjb
	 EcIE9y9qv1PSM6IgQw36lQOIQPDjUM7enhEzlUzO1HCLksuZ47G8tDr9y7A6Ih/5FY
	 k2335J2if1/kVP880pcwW2HykN34ww0VgNfWQYmwDOR6yaiqoNTSYvyIbjpV3j3IrA
	 EKmyigK/lPxXoOZj4KCmN2BEUBoKnHJyFSsWFxE+5ppEA8eu3eOPJzQAfiDHfJz1Qg
	 gEWgN9Y3qtf7rJnqXndT8D6EiRnT6bJ419gjA4+Mt365iTgOF6LQvG8l9qf2aduKdM
	 aC1uZ2ZYaTj4GWyfjDEOqQI8cDp2Y3xMzb0NKtRZT07PAQtfBPZ3JIpJ1voY7J6Ttn
	 /7zr48TC4Bdn1IWPtiAVx1IkqDm0VNjb7u+ZFYLwJG1KQ5eBptrR3TZZ73kFlUYNes
	 P3ejDSXZg+g3mP4K4gNC3Z30=
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38e2237bc43so1990776a91.1
        for <linux-crypto@vger.kernel.org>; Mon, 27 Jul 2026 15:43:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785192188; x=1785796988;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=956NfCuSF/TqqzmWFsuMn2yMhAz0GO/MfVVWa/Wqj30=;
        b=JiEyTI0eJo+A58iRHzHUZDj96qEQVCyklPBsJFIuGyQ1WAtUHa9C4nNGbEL4SyFaL/
         vIRFV7aCtGBFa9gVCAcl7P+bwPLJ5AGjVmaFbbOARIHUqh9zz/WlX/YRNQdvBXjtIwoG
         QNuRBp4NbDJGN062Tl6kEQT+s4rNKp2mKPO9rvUy5LYrqQb3WmSuMoW4Y/gwFoP7IhB+
         zf/cJQ8I4Ni8F9W+8KK8vsLlE7BnCgeDeKAxmyMt6c66alfmSOf/mh+2TUGBrKp8O7q8
         bgDP0wTvwn0w31dEFgujapDVopd2TWI3pzCL/MUZ9lAGBfq8KR0iUX64pbsUYX0o80UM
         JDVw==
X-Forwarded-Encrypted: i=1; AHgh+Rrj2PkeAlPlAJl2gOwzVCDkViTvXmnHtl/2qIIqcRXphc90FkPqQ5C+ssGu1jhmEPInt69SDF0fe9rZ3BM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyviK8RALBxhakA/icJsAoS/eioedMbbSZtxI/Bms441TfrzkX5
	/mWRIFoueG27eizyaafxf+zAa85dSdI7POQHnvEHgI5Zy8caqqu4ASyrmYhQxrwpT/UvibAW5bt
	8KjUwZBe/ALpeuTZBpLlvEeOf9/wuhKUiIZHKCxDkDjWXaHcegLKTVz3bGRWYlXVhZqAkL+JFa/
	+5ejXQQE6yS4lHNA==
X-Gm-Gg: AR+sD10tJ250vw60QXpSsCoA5KGS5C6kqBtV+sV0cz+I+u4l9NEDRjv6OYmkkaLCASZ
	kdeOYRZLY5u9AFTdVlYf35lyfYwcHvrrTIIuR1XIQsugHvndll/dCirtBoAYWxeVHQOFfZt+PdC
	6GxYjseiyOWWNtaAPGzVtRXKWHNuC/FIuuwNFfjOfKKgdI0Yon1qpTpQNNKn8gSDK5Nc26vEZ+R
	wFzfYWlIfbFK/tUD76SyW52CuSGn4OQvKgW+/ONDwoCvK5pY1gGdREkCoSe+Z/g4kUdUUwF+R9+
	2i9lIk1S4TT6jKCIqlQNhYW+CNo/sXVtjHpRNElHcpZfs/QS/GnkYCIzXUZ1+ZAg3OJut5krn5v
	DQHWodHWVCy4=
X-Received: by 2002:a05:6a21:6d9d:b0:3c4:34db:9fbb with SMTP id adf61e73a8af0-3c6c801826cmr1649372637.57.1785192188257;
        Mon, 27 Jul 2026 15:43:08 -0700 (PDT)
X-Received: by 2002:a05:6a21:6d9d:b0:3c4:34db:9fbb with SMTP id adf61e73a8af0-3c6c801826cmr1649354637.57.1785192187942;
        Mon, 27 Jul 2026 15:43:07 -0700 (PDT)
Received: from ZBook.gateway ([123.208.39.53])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc5a04b2sm33403139eec.28.2026.07.27.15.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 15:43:07 -0700 (PDT)
From: Changwei Zou <changwei.zou@canonical.com>
To: herbert@gondor.apana.org.au,
	lukas@wunner.de,
	ignat@linux.win
Cc: changwei.zou@canonical.com,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] crypto: rsassa-pkcs1: align DMA buffer to ARCH_DMA_MINALIGN
Date: Tue, 28 Jul 2026 08:43:00 +1000
Message-ID: <20260727224300.150132-1-changwei.zou@canonical.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

out_buf is used as a DMA buffer for the RSA verification operation.
If out_buf is not aligned to ARCH_DMA_MINALIGN, cacheline sharing
problems (data corruption) would occur on CPUs with DMA-incoherent caches,
leading to -EKEYREJECTED.

Fix by aligning out_buf to ARCH_DMA_MINALIGN using PTR_ALIGN(), and
allocating ARCH_DMA_MINALIGN extra bytes in the child_req allocation
to accommodate the alignment padding.

The intermittent error 'Key was rejected by service' on i.MX8 with CAAM
can be triggered when loading signed kernel modules.

    for i in $(seq 1 100); do
        sudo modprobe xfs 2>&1 && echo "SUCCESS on attempt $i" \
        && sudo rmmod xfs || echo "FAILED on attempt $i"
    done

Fixes: 8552cb04e083 ("crypto: rsassa-pkcs1 - Copy source data for SG list")
Signed-off-by: Changwei Zou <changwei.zou@canonical.com>
---
 crypto/rsassa-pkcs1.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/crypto/rsassa-pkcs1.c b/crypto/rsassa-pkcs1.c
index 94fa5e9600e7..a8d90959c871 100644
--- a/crypto/rsassa-pkcs1.c
+++ b/crypto/rsassa-pkcs1.c
@@ -7,6 +7,8 @@
  * Copyright (c) 2015 - 2024 Intel Corporation
  */
 
+#include <linux/align.h>
+#include <linux/cache.h>
 #include <linux/module.h>
 #include <linux/scatterlist.h>
 #include <crypto/akcipher.h>
@@ -237,12 +239,13 @@ static int rsassa_pkcs1_verify(struct crypto_sig *tfm,
 		return -EINVAL;
 
 	/* RFC 8017 sec 8.2.2 step 2 - RSA verification */
-	child_req = kmalloc(sizeof(*child_req) + child_reqsize + ctx->key_size,
-			    GFP_KERNEL);
+	child_req = kmalloc(sizeof(*child_req) + child_reqsize +
+				    ctx->key_size + ARCH_DMA_MINALIGN, GFP_KERNEL);
 	if (!child_req)
 		return -ENOMEM;
 
-	out_buf = (u8 *)(child_req + 1) + child_reqsize;
+	out_buf  = PTR_ALIGN((u8 *)(child_req + 1) + child_reqsize,
+				    ARCH_DMA_MINALIGN);
 	memcpy(out_buf, src, slen);
 
 	crypto_init_wait(&cwait);
-- 
2.43.0

