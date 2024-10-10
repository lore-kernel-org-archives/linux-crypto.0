Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5131E572D;
	Thu, 10 Oct 2024 19:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728589529; cv=none; b=rLts7WgEuyQc6olFSyPptuzQPFIbtD64zgQZc+I7x/t2A9l6VhsLfLTrlPaAclCfdNs1NaKT8J8uxaeDHnwv0ajeoGsf9GXlK8PqF8A17TjQYd4OULTKc2wT183RAmgLIsj1wyPvqnxsm4uJ+qlcneDbLKBfXDFh+eOgGyLjpvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728589529; c=relaxed/simple;
	bh=Z/AKn3jdK5QJr21NEh6M/axjNX6uEKUZyzNVe8ZBoCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDEIYNOdmH5Ut7hBiFwVpOGY2bwI1ApiRGTJrAfZIdIbsmwZIV/h7g3RVBFplDJJvCk4XmnR/d6ggkFPNPqbWTDhFGKA7CSXMD/+zf1rPUgWJhg2zaiR7WhWMMg5dtwpKfkklyCg82zGPjJ1SDR+DkRTr3HTMC8GGtvhbr1Dcek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OzD9dJEq; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OzD9dJEq"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-71e038f3835so1274507b3a.0;
        Thu, 10 Oct 2024 12:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728589526; x=1729194326; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+3EI4XTDmYBqzGsZ4sox7/pa5h3v/nZZ5pZc9pzFM5I=;
        b=OzD9dJEqCKwLN184uh9UGd+Ratf/TbPdmh4oo2vButKohat7orITGKpyvDzCquzh4q
         FsRRAFrPB3n9yyMosz1BQW8I0H7Bqt1VsNkMuzvWp0DipcMd7cEUj07zHKwtLnL94kS+
         W2ijaVRlMdvFqbCe/8O/DBhFe9Lkym4NNPnIH+tc4iZZfWTsTSxCcbd1QSGiCOKsWstt
         Rkq10uqaUxFgk6byR+iNBXU9iEelfMpHo6H4Jvglu+6QQ/TZt3APe4cMYc86NYUvQSIV
         tDrh/gz3IV8meGca4Uipx4eqUZGnp1+WP00DNCOGhq8qgyi1kT/O9hzn+c8mQaIJ+Sy2
         f4Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728589526; x=1729194326;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+3EI4XTDmYBqzGsZ4sox7/pa5h3v/nZZ5pZc9pzFM5I=;
        b=G4HOYW36XZ1mQ0guE8oxzuNaF1Zw05HU8cBrWPcHJQ/Bw2gfFvfFNc2Tb+8diQamJY
         ypOwRA7IcMMydOAxPIkOOIhW39qpY1bYJ5SDUL7tE/b3jS18XkqbXqgpy4WA2V0R5wrr
         YfPKY83TDRkp+hqOYLaiy063AojL88gPoXP0Mc8FWmpDo2ZIDatOmDKhoohoYebPGU6I
         d6RWGyYjAQMklGEVU6I0Ovpxzlh12HYJBhkMkdZ0AoOhEIEwGuMBMdYdK5rxgbInBwhj
         E3FfLRLYgQPw0ClWvLsGiAfhLXiTssNFH4CI7q7yVwcJ8TdNT+8rNdynMmDC2kbyk497
         zlrQ==
X-Forwarded-Encrypted: i=1; AJvYcCX8WpcwfRn++aSnH1zMVE40GwmSh6rSoifR2IJx+Thgav8j4w0JLobolohw/jnqhqaP3FyAekxgDcjnYyw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0RYrYw19/isXrHL4Qa/rJFQYg+YgS5eJu+6l2cK2HNQEKMeWI
	EbQYEYmdhhMt+iUnoVLzduyoP6NONiyJCSx2TwWdTkWORPRmU/dpirteUqO4
X-Google-Smtp-Source: AGHT+IHJuZRDWcftnPRua4fr9uRoKs7TTb6YTz0GeS+hpwkLoxjCCAZmkRNuK3lfqm3lBYPdzs0xWQ==
X-Received: by 2002:a05:6a21:4006:b0:1c8:a5ba:d2ba with SMTP id adf61e73a8af0-1d8bcf356admr168084637.22.1728589526287;
        Thu, 10 Oct 2024 12:45:26 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8200:dab8::a86])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7ea448fe50csm1374762a12.29.2024.10.10.12.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2024 12:45:26 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Boris Brezillon <bbrezillon@kernel.org>,
	Arnaud Ebalard <arno@natisbad.org>,
	Srujana Challa <schalla@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rosen Penev <rosenp@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCHv2 5/5] crypto: cesa: use devm_platform_get_and_ioremap_resource
Date: Thu, 10 Oct 2024 12:45:17 -0700
Message-ID: <20241010194517.18635-6-rosenp@gmail.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241010194517.18635-1-rosenp@gmail.com>
References: <20241010194517.18635-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Removes separate steps. Requires index instead of name.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/marvell/cesa/cesa.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index a65f328b7094..ef4b1c2336bb 100644
--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -375,7 +375,6 @@ static int mv_cesa_get_sram(struct platform_device *pdev, int idx)
 {
 	struct mv_cesa_dev *cesa = platform_get_drvdata(pdev);
 	struct mv_cesa_engine *engine = &cesa->engines[idx];
-	const char *res_name = "sram";
 	struct resource *res;
 
 	engine->pool = of_gen_pool_get(cesa->dev->of_node,
@@ -391,19 +390,7 @@ static int mv_cesa_get_sram(struct platform_device *pdev, int idx)
 		return -ENOMEM;
 	}
 
-	if (cesa->caps->nengines > 1) {
-		if (!idx)
-			res_name = "sram0";
-		else
-			res_name = "sram1";
-	}
-
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
-					   res_name);
-	if (!res || resource_size(res) < cesa->sram_size)
-		return -EINVAL;
-
-	engine->sram = devm_ioremap_resource(cesa->dev, res);
+	engine->sram = devm_platform_get_and_ioremap_resource(pdev, idx, &res);
 	if (IS_ERR(engine->sram))
 		return PTR_ERR(engine->sram);
 
-- 
2.46.2

