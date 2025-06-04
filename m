Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C9A1FF1A1;
	Wed,  4 Jun 2025 20:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749070069; cv=none; b=RoDdyBmX9f49CwLb5NePUXWuXNt1whVImkpCb47X7QByF54JcTh93zpVwAzWMFEtxsokbf8LuJNBH64ZSRcu0XIWHj1rxSlhYX9gz/DRRj3d/q3UY1cEaVc9/o2FNpYXv3PT+j+c4F4H1Y1fQMkgiuxjlHZ0QvcKyT/wFFncfes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749070069; c=relaxed/simple;
	bh=ahIawL/3uECcl0ieqmZXqycsQOB+QbfjIOqNqgm5uDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SyFEDKBbTt2uR0D2YwDwiRapwb+CSHUGrCRAmUqZ+9nxLMUQUTUKWtplvCf1TXqZbiienaOEWJTlYbYYeCtNx6xrooFauctFv17+rw4mu4CzI7J+yZCTA8I8zlCYw84J2hxZ1cUd2Ec+NRfKQ1Xom/9rJChJ4+D59VUNGRVljp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iISEMPYO; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iISEMPYO"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-70f94fe1e40so15476237b3.1;
        Wed, 04 Jun 2025 13:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749070067; x=1749674867; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cmYp+AgXWjFBzOAQ3xKQ2cWb6I5jYIve5Qz9uF8eKkY=;
        b=iISEMPYOSxiTnrt4EwaIuspd/I9S58FZq2UbtwshKEcSDxXL1WY22ppzROZL714VUa
         UYe/7JSA5NqCVBu71ph6k893cBTWstciNb7Y6dYWbZsWGpx/cQX6YHnNKUG0haZBhWzh
         8SzNHSm0rgbVjDOxCXWAyOem/S72ElEQ2N9Zkt1FC+p0rubKCNP4wNgvtvEIHnXu14Sq
         LcmsYwNHMix8Q3kIuvN4v12yccOc4smlCniFH0Dq0golA97v1ar2TcrQgHjGLlRX7OJS
         o2jYW6cNRj7VxuEHvh2BF29o3iKNnIMMu1gzdwOrabvb571gSo1uxaKgTS0K1zYOpecT
         a0fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749070067; x=1749674867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cmYp+AgXWjFBzOAQ3xKQ2cWb6I5jYIve5Qz9uF8eKkY=;
        b=LPKaxI/XX1Hw32ZkIuESU3+Obkx1f0U06QAjPrZ/bIAjzZQMKFT099jXVP8Tbtgb0z
         E+LzJrbdT/++aSxFA+OpaXPVdDdL4FZN2sZ4wDbZMD9GwYOUP9LblsMaP6VcwKYBYrgU
         i0cxfIVfs/Xtlj6WcCHhcgJXIy6j7mG4bP+iwYR7OB8zmxtUccBcb4NlmWq/LrqP4ZeY
         M+YA16q/z8KNMoe4v0GlKDJeuUpZTp13/CRJSdEKVSWMLzHp0ZNsUFsIKgFbrZrycCXD
         VHOB3/w2sH4/k1z6O5l0E/GIWhWJ4ZNpo5giPJ2eGlLXcggM+WJgv5pocZBFIdxiJJdP
         FyZg==
X-Forwarded-Encrypted: i=1; AJvYcCWKwKl63cxTHLNh5SovgxKZKYJlmWDLwWZX9g2Dr67HBjXtyFxYUf59KQCYb+H2v71xd3udWLiilzPDAYo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+WqX13AfsUrN2DxEdy96e1C2OsXaIAvaxslZ/aD4UmPN7pZAI
	mnB6+Ju/jdmUER/e8V3CBKZ4mxy5QVsxP1VGlQgOsOl89J5wGjFw2ISwUmkr5w==
X-Gm-Gg: ASbGncug6bt3jqxQ+n6Io6mgnn07Oe11amyQPee03MJIjVy0z+cGNohpJDigbw96FlY
	CUT4j9IMx+ynBfDqGlWugp/njhJn0mLhCO09l1AOoBU1k1Py2sZockOymg/ka4pFmt6+fV+8B6o
	6hLRd3hN28iu+v7YPLA7E1EkIHlA9XHjlopEH79RZJy0D/B78ARe/+lq1qU1sGZgCfnYAu5Eqbc
	COuv120O87CouCkN14TIebN6oQy4FkyGJcFITLEi49QNu34g0X93iFybnek6BC4dGAG5p2MDKOZ
	FFwtwUIX3lEf5yFfJmZ+U2v8qYUYfpz4x3CmL+U5ljK8EhL8MzT441IrDI4en/et4IHsSufkUx8
	wm+a/Mth+/a4enMd3kyCHBA==
X-Google-Smtp-Source: AGHT+IEYiS315DaurOeALt/L9xPEOmBb4l/x4od1HV/FNKcRr95UAYvqOCqUSwEpWb1iDEwHbQ1m6A==
X-Received: by 2002:a05:690c:620f:b0:703:b708:e15c with SMTP id 00721157ae682-710e7e3e37cmr16027487b3.13.1749070067216;
        Wed, 04 Jun 2025 13:47:47 -0700 (PDT)
Received: from localhost (c-73-224-175-84.hsd1.fl.comcast.net. [73.224.175.84])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-70f8acd546fsm31448387b3.78.2025.06.04.13.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 13:47:46 -0700 (PDT)
From: Yury Norov <yury.norov@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>
Cc: "Yury Norov [NVIDIA]" <yury.norov@gmail.com>
Subject: [PATCH 2/2] crypto: caam - Fix opencoded cpumask_next_wrap() in caam_drv_ctx_init()
Date: Wed,  4 Jun 2025 16:47:41 -0400
Message-ID: <20250604204742.21183-3-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250604204742.21183-1-yury.norov@gmail.com>
References: <20250604204742.21183-1-yury.norov@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yury Norov [NVIDIA] <yury.norov@gmail.com>

The dedicated cpumask_next_wrap() is more verbose and better optimized
comparing to cpumask_next() followed by cpumask_first().

Signed-off-by: Yury Norov [NVIDIA] <yury.norov@gmail.com>
---
 drivers/crypto/caam/qi.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c
index b6e7c0b29d4e..1e731ed8702b 100644
--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -442,11 +442,8 @@ struct caam_drv_ctx *caam_drv_ctx_init(struct device *qidev,
 	if (!cpumask_test_cpu(*cpu, cpus)) {
 		int *pcpu = &get_cpu_var(last_cpu);
 
-		*pcpu = cpumask_next(*pcpu, cpus);
-		if (*pcpu >= nr_cpu_ids)
-			*pcpu = cpumask_first(cpus);
+		*pcpu = cpumask_next_wrap(*pcpu, cpus);
 		*cpu = *pcpu;
-
 		put_cpu_var(last_cpu);
 	}
 	drv_ctx->cpu = *cpu;
-- 
2.43.0

