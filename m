Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694B336E478
	for <linux-crypto@vger.kernel.org>; Thu,  7 May 2026 23:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778197076; cv=none; b=uY9wg0Clu1hu5RGasIoYWb5Z++ruO4Vh/RboGHqjzk6n+ZLL7S/HRwQifbhahkAoEwyVN46MSyiGULAi+Svlh1+NAz1nz3KYXUmTk0oDloycr+UMDNiislKTf/SIceGaI8WkYZMa0XYIFRvIFcf/3notled1Fd3ydOStplPNkHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778197076; c=relaxed/simple;
	bh=dymaywSsJ8bL9nKxldKN+amZarY0Rc3i6Hw2CU/N3Rc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nWQ/yYq2lVIVR1H6KMLv2WDLuW5One7l28rt4NDtqx9fF5zFLFBLcTtPpdaVxy1Ar3oO0t4nGyZC+7ltXYlo51zezmj1srW2a23Be4bVdPFP5v8IduFXjvYO0JcFXyov0RSPjAjko7cpd+juedSo0dShJizKG4nAlXr2p1vcIAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OcGDhBBK; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OcGDhBBK"
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-42c035bb2f1so112198fac.2
        for <linux-crypto@vger.kernel.org>; Thu, 07 May 2026 16:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778197074; x=1778801874; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=evwJ3WUGDeN11ruEycjl7by7AWSkCxsRcEiQqBCjgN4=;
        b=OcGDhBBKvvC8JXYhHlIolDtuF3pQwUJKAMYyIaBVZHx6WM0yorg+lKAbZ/CiWReDFf
         g93WwYjgxX83uCKiV0PbgXnkskPnatfr0TKfgylOSC5AtIEfnGu4JhNUnza1d9ljtxwy
         nO1CDNp3/wpxVlEljP50kSTiHkIlTpWpa6Ws//CiZlqB3MPNoCGnIFYBlnWW0M/fDeql
         VzSIOi2f/yy2R1uwpjyYcMSqwrFhsV7SDC7tUx/2Nnph9PLsXLuDpf3SrFhiDMQA0BCq
         ALtG6BqTAjObumtLqb4tJWDn/WWgJkC8toBOKyg32Nt8BC2l2UlYWwXiZZVsV7PFy3tE
         B5lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778197074; x=1778801874;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=evwJ3WUGDeN11ruEycjl7by7AWSkCxsRcEiQqBCjgN4=;
        b=ELybq2Q908kPwjinm35mb1ZCbBunuYKW80qNWjITL3QcXaECh/KXmcf7QP5ODFaBA0
         W85i7yNS/voNRdh+eB3q/wYCzRaG2ePqiBKwDMKpxydKgOJy6rnRo3gVttk/EvkKGu1X
         jICp/sNAc1xwmz+9enofElX9YPZmg2/HePbMPzjnmvR9cCSo78vB04ypC+YpEfI/IkkQ
         COgney94N7L8Prl4nqNZn6G2+MSUgc+9KmYmvGeIuvbWA2ObVm+WJm13E0VmxTXnjyCU
         247Na8MyO48McJ0Hbo5UuT1xHnRkXGZOXI3VGqnxf7qwyV8FjydsOdqnnwWRFhBcTHLD
         yWcw==
X-Gm-Message-State: AOJu0YzhhQei/J5gXgcnLc9QN4rhcKsWt7FIpT2tIzIzX1v+y1OtmE+p
	2VmLSWIpO5Ng1YldXsYPqTOe+97hCIT8Dh79FctkxE6uJ7Q9L84Ih3dpH3tskesGBbI=
X-Gm-Gg: AeBDiesmiSyGQDb/2+8ddQn0VK3BXQRKwKEmjDPwEImL4LRg1my22GT9+dmJ7R3SX3Z
	Ubu5GpK2HC5/JQT2PIBg8mW6b1p19IrV40Zo9Z/ffVhla7P866sdWC3iUyxMcAfjPK7Fn0o8lvL
	q4tTKv7LN2Nk/Q6ITbTuNcsNQBANbPNM1X0gUN/oe2VXEF50eDZ8eEmBXp/ErFWYJ1Ogo4HjVJR
	4Yoh8OTtjaV0W+21N8N19QiaTiYZ4iBeCkMAILRGqZrPR91G9rX8lnDIgepOwq0VJFnfu9ebk/h
	EPvIAaR4dcnEtHfYw7Oakc0TTwsQsac+29hUKFu+hY1C24o4bX2bF1NdUoCI7BFTYgfyu/yAokV
	yQFU1eimH+tYTTuQmwl8IfWnskc5kyEHDKQcSAII+cp5znDjlU/Cpo3jtiNKS2eDbE49A84quXk
	imF1r4qzocqVgvemJdmOUUHUvJzo3w+dTkZxt03dNWvaExdSoRC9JvzIGmkbLt2p4nlnNUIsW5a
	J9QeSxsPdzihXuemlQcJQi9rnCNXoEPozc=
X-Received: by 2002:a05:6830:d1a:b0:7dc:d390:4999 with SMTP id 46e09a7af769-7e1df0d2f3bmr4084450a34.6.1778197074200;
        Thu, 07 May 2026 16:37:54 -0700 (PDT)
Received: from localhost ([136.49.184.116])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e367d8fd96sm78980a34.19.2026.05.07.16.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 16:37:53 -0700 (PDT)
From: Aaron Esau <aaron1esau@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aaron Esau <aaron1esau@gmail.com>
Subject: [PATCH] crypto: acomp - fix dst-folio branch setting src instead of dst in acomp_virt_to_sg
Date: Thu,  7 May 2026 18:37:48 -0500
Message-ID: <20260507233748.327004-1-aaron1esau@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In acomp_virt_to_sg(), the dst_isfolio branch calls
acomp_request_set_src_sg() instead of acomp_request_set_dst_sg(). This
overwrites req->src with the destination folio SG and leaves req->dst
holding a raw struct folio pointer (via the src/dst union). The
algorithm then reads from the wrong buffer and dereferences the stale
folio pointer as a scatterlist.

The bug is reachable from UBIFS decompression on systems with a hardware
compression accelerator (HiSilicon ZIP, Intel IAA, Intel QAT), where
crypto_alloc_acomp() selects the hardware driver over scompress.
Software scompress backends are unaffected because they set
CRYPTO_ALG_REQ_CHAIN and bypass acomp_virt_to_sg() entirely.

Fixes: 8a6771cda3f4 ("crypto: acomp - Add support for folios")
Cc: stable@vger.kernel.org
Signed-off-by: Aaron Esau <aaron1esau@gmail.com>
---
 crypto/acompress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index f7a3fbe54..5a8b0cf3a 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -237,7 +237,7 @@ static void acomp_virt_to_sg(struct acomp_req *req)
 		sg_init_table(&state->dsg, 1);
 		sg_set_page(&state->dsg, folio_page(folio, off / PAGE_SIZE),
 			    dlen, off % PAGE_SIZE);
-		acomp_request_set_src_sg(req, &state->dsg, dlen);
+		acomp_request_set_dst_sg(req, &state->dsg, dlen);
 	}
 }
 
-- 
2.53.0

