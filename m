Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7694E79D0;
	Wed,  4 Jun 2025 23:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749081488; cv=none; b=LwbskyKK7jNvYM3BjXe4r1NMpObT6vzaC2uCVJJAAkbe31y4jDrLkclMsN73duykaV9GpHNsDqRh222WzFBFC1GdfkUPSALSnA53O/VlvKRzCOjotoaf/blm0nPydShDu8KEbQ1G7Bgi6+wmHnot2DmDZLSXKcedF58Ah04N8q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749081488; c=relaxed/simple;
	bh=QzfZr39HeqY7H3B6TYyUxaMLUgwPEK0TtDJisXAYCmo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Nz1njWwjq0Rk9anvh+UOTa+zRGxBYh2VRvN8pZUr8h0pKXLFqbiBCGyZiod+6djBLBXTPzZ65G1N5JC10DAKAmQaW4eirRCTa1JrI9hqvsglybnFU+cZf3ow5XHNG7GH3mRNG8P3jXyhSK/n0d8lPW7imlpt20LjmBOCAkMh+XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DEqopVjf; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DEqopVjf"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-70e767ce72eso4732847b3.1;
        Wed, 04 Jun 2025 16:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749081484; x=1749686284; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=D1urpv1CAifgJ6BNRWX3RtwUoCLKVqZzHUlUAbIF8kM=;
        b=DEqopVjfifQKiXn6w03M1mWTIJAunPmdt5sEdxwYspninI7Su84xvdrI9uxr4Gk2LX
         4i+nMWTm9xtR0SToAKsW2Q5rfUjN/rOl/NID5vz3GJ+JjZIBQkAunbode7J2llXijm8G
         mSRpKG1g91vv1+4DiemC4QhI9NCog+zvfxlTrVcSgl0USIrfWOyfFsFW7OvTm4dHCm1p
         AOWjifvqyyRWc7zO8NeM0fXara/105hQ6CNS4Ph75Z2wg7UN5jlpTfbaD1Sm2tVI68yC
         jFIFUcbZwH3PdnR1zhF1Fxd9Uvin4+IrFt/QUUYAeIJnUeFSxosFDbQh+O6GI47kAHyZ
         If+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749081484; x=1749686284;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D1urpv1CAifgJ6BNRWX3RtwUoCLKVqZzHUlUAbIF8kM=;
        b=hdGiNUsXWU7XjixeqSuOe7yE1WN52evcVRL9IefUswj5O/rx9jmkEc7uRkoW2uBXAl
         R3WSPXJEhJTDcbNOCsGgwra592do3M8pjnkyWOILmKo8MJNhd+TOcJxDyxtIlDjzkcIX
         FiQjEthYfypxnURKsIUWyMgK9IG1akYdi3rvEG4i7Qdyb4EV11EJrrE+zN+8HMyCZ/zF
         zZl+PARf4jSXWukHC/yMeBO0Ss8snFGhTjiDddouuulZJ4C/apkMc6VUeYnKY00ynKKX
         naJt/LgDJ1wFs7zz8vJtwT61azJkh9aackp+S2iWskjEw0D65wESK+PaazEYJwMknkj+
         JhQg==
X-Forwarded-Encrypted: i=1; AJvYcCWCDxGz/ZSPoN0B6dDXKFZBNfxFifEdQRPlPtKTIDmnGTkHbZ24kSqqMwhyOroNokMNhexQoGLYNtaXhnE=@vger.kernel.org, AJvYcCX8AzH3WLquG4Ki+0BGxwGLCvy6jzrF+HxJhLkbEFLNTdUIFWhz7GdtW2kqNH4ymj1hMP69zu+IIW2XDsw5@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0+9o5N6QYNOJ04w2nOj4sbsKoGvwVeT2lTMywDJnSwTateEj9
	3GPW5A74St2t5864ZD8j98u9tjY24zngkEWCRshx9ZdTbcwte/FmI2BS
X-Gm-Gg: ASbGncunehCW+WfNB4F5j8zAqWBVpQqUSVgUS72nXSIdlTpj8iOTXv1SvUvyxOrK8CD
	jeswBcELRL6cj4GPIFCRAB2RHjlsYTzKLwngIt6TqEiRtmGLnJpQfrmvI45ZrLiOPaVqJ0awkqu
	PVA4oiDg/IOmQQs/+IRo63/LC92SnFhoyK/wBjzwNAzLMcb3ZrJelpF0bNyJxJ6bePTQRtcPtt5
	dAOtKZCoseaWym1H3cXQ9KNnbxuXfmEq3oYBp7M4XjQtgKbEwXYP7t2M2tWdxGZBH4zu0HnAZ8r
	xguNAUBasrDKZQG0WY+vPBZ2IdaSMsdrEToPDM1G7nCWcXZ+JDfKgSNhnZo9v/HVcwubbpX3VnO
	lxD1ABHkyt6XRs2Iy1pUT8/1YUQ2MA3Or
X-Google-Smtp-Source: AGHT+IFe3m1viL0iywi8an0eIFaeH0OkftD9KsusLITaB8ddgPDMqk3K3v2ets/7F+bm+WuhdzE3qA==
X-Received: by 2002:a05:690c:4c01:b0:708:21e9:a20d with SMTP id 00721157ae682-710d9dfb30fmr69922217b3.16.1749081484286;
        Wed, 04 Jun 2025 16:58:04 -0700 (PDT)
Received: from localhost (c-73-224-175-84.hsd1.fl.comcast.net. [73.224.175.84])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-70f8abef1d0sm32587187b3.27.2025.06.04.16.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 16:58:03 -0700 (PDT)
From: Yury Norov <yury.norov@gmail.com>
To: Steffen Klassert <steffen.klassert@secunet.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Yury Norov <yury.norov@gmail.com>
Subject: [PATCH] padata: use cpumask_nth()
Date: Wed,  4 Jun 2025 19:58:01 -0400
Message-ID: <20250604235802.44411-1-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

padata_do_parallel() and padata_index_to_cpu() duplicate cpumask_nth().
Fix both and use the generic helper.

Signed-off-by: Yury Norov <yury.norov@gmail.com>
---
 kernel/padata.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 7eee94166357..13084bbf4404 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -63,17 +63,6 @@ static inline void padata_put_pd(struct parallel_data *pd)
 	padata_put_pd_cnt(pd, 1);
 }
 
-static int padata_index_to_cpu(struct parallel_data *pd, int cpu_index)
-{
-	int cpu, target_cpu;
-
-	target_cpu = cpumask_first(pd->cpumask.pcpu);
-	for (cpu = 0; cpu < cpu_index; cpu++)
-		target_cpu = cpumask_next(target_cpu, pd->cpumask.pcpu);
-
-	return target_cpu;
-}
-
 static int padata_cpu_hash(struct parallel_data *pd, unsigned int seq_nr)
 {
 	/*
@@ -82,7 +71,7 @@ static int padata_cpu_hash(struct parallel_data *pd, unsigned int seq_nr)
 	 */
 	int cpu_index = seq_nr % cpumask_weight(pd->cpumask.pcpu);
 
-	return padata_index_to_cpu(pd, cpu_index);
+	return cpumask_nth(cpu_index, pd->cpumask.pcpu);
 }
 
 static struct padata_work *padata_work_alloc(void)
@@ -192,9 +181,9 @@ int padata_do_parallel(struct padata_shell *ps,
 		       struct padata_priv *padata, int *cb_cpu)
 {
 	struct padata_instance *pinst = ps->pinst;
-	int i, cpu, cpu_index, err;
 	struct parallel_data *pd;
 	struct padata_work *pw;
+	int cpu_index, err;
 
 	rcu_read_lock_bh();
 
@@ -210,12 +199,7 @@ int padata_do_parallel(struct padata_shell *ps,
 
 		/* Select an alternate fallback CPU and notify the caller. */
 		cpu_index = *cb_cpu % cpumask_weight(pd->cpumask.cbcpu);
-
-		cpu = cpumask_first(pd->cpumask.cbcpu);
-		for (i = 0; i < cpu_index; i++)
-			cpu = cpumask_next(cpu, pd->cpumask.cbcpu);
-
-		*cb_cpu = cpu;
+		*cb_cpu = cpumask_nth(cpu_index, pd->cpumask.cbcpu);
 	}
 
 	err = -EBUSY;
-- 
2.43.0

