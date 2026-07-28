Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD07231E831
	for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 22:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785278548; cv=none; b=m67oQeX8+bnhJ0v8Tx20/TSOgeJizugpBmJm/9BdQn8nHbXvReMZWHhpw2vYn7DpIjhhjdx4mgUds6SQ4VrDdZA5gJub8ftrWEUkvMDjnbbQQrvP0rtgxm/8aL78YSO6nD9+45TlOypjS7enNxaYVIv1CQhUq1lC0K1RgNdhjoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785278548; c=relaxed/simple;
	bh=AIaB5I76MWLkDaE51/hOPv4UytZ0f8Ty3GAVN9lTEBI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SWYn2Fj2FErjnR3lPrUXDbCoCTKTOs2weVgoIA48iZh+bZlEs+OB5QPVF7mkOaBsQkvy94zc5hRkd5Y+y4vSIvf5FJ9/jeOMJSn/yspK0/0uBBs8djCqn66MiHcaL/jPlQbbLwUkOB0t21Jbnmjqgu8F/+ZM5GwZSgh7xBYHm3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cwQ30XWI; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cwQ30XWI"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2caed617615so4743075ad.3
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2026 15:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785278546; x=1785883346; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DzP3draKYRTj1F850nyh0ki//dsuTjC4ly33CxuMaFs=;
        b=cwQ30XWIPb73p/eTv5TFVMimo8pL8bke4tGDaOJCOsK2m+V4B/IzJQZLgqZWGz/tsO
         jqcaleBTOGf/FAm6+CB3GX8jbg4/lYFlLMtemw2IGXfUAL3hjjBiCXIATMfLPF5x2Ghf
         6xtahu0hRabsPGZFiDtjQUcz7qeqn6uXi2E35kWvWyWZl6X7Midd2f2dTj0D3w6PkoZj
         BGG1O9sZ2t4IcXy8PlePyOFTmOJqMzp6brFaPZMkai8n7xMRxa3YtwXECbztwUj78pK8
         1iwabrNj0zlXbC0HevTE8vxRh/32eWfhD9Vq7wqAUUjrdKUYHtoJD+rtpvQ/Le7keuLx
         U35w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785278546; x=1785883346;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DzP3draKYRTj1F850nyh0ki//dsuTjC4ly33CxuMaFs=;
        b=e132EnHkz9edqMncmUm4PPriNvH+ZaGrUxMKSHDr8kNMwUg3K76pkmJqv/Haqcnsi3
         xCtTpL0zffSSSzyCRfzuBuX99I2s/Df0HaPOQEIzjDe2VMX006tOj/63hjDrJCPGRr6x
         V5JYZTSrq966QzpmV5uw8eThAz+S7SAjwwTjeTm/S30EJUrUTLyj7hNaRo7uEjyJT5EV
         w+bNJdCltOSmj1xwzO/mfTzQHeMvrw3neGjZSGzwMLbxQI14U2pBC1CGr0vqKP+Mqmf2
         WAIBrkuEcfOJWusfAHrvWtytCMtfxMxt6j0ysovTCNDxfK97aRlMts/mEb7hRrwrUIrg
         LS3Q==
X-Gm-Message-State: AOJu0Ywgrli0xcv0tl7xmYiUyo9Q8nka0k3eRl1t1x+5wP5Eg/z7sCdd
	sE7MUfK0Wk5jUBW+TtEoB8U+hx284zZr7rPqpQOc/IynF3rPXKztN/z54uihd2SF
X-Gm-Gg: AR+sD11VOG0zSPBdRuzGU7cgKO+iRM8NFWuVMCd7wtowTeL04fPqs7JD+q+iqhaEvgM
	UjFKfzyWjNpsvM8HlMeGkwhsi8+6xzS8NClbB0IEkVeJeLYh6DLJC8kQii78oGfPHbRDZBG37p+
	nlP7rPm0tHw5xYXIDenQSknPLtHZC1btxmS7I7/Am5as6VHqcdfJl+JkXWPHg9cQnQYLLwLMU7l
	aIKq8MtrrAHGgk2Pw9UTsV4RNgnTOh+lGEyhxOTgBUvqwErDYF2nHr+KsjKBBfQh2C+/LGoAIpR
	JeQwPqbcHOUKvx4OcVU1ugr8+SWevKYt6Rff6M5lQokA7y0DUvozFy31kMcQ8TwZqQorQLZk56y
	HUfhJ08DKQ42h3ApOy3bzAW03eAlrZlg3biQwXyNpiGC1mkw+vfsObHI7e6Q2v0kIGTiwO0Es4F
	ydQsBZO8C3lO21GaGhNfMt3svMM8P8KH6kOsUGWO8gQh61GvGI/4+qY9t/3SFpFmJIhjxWQYgW2
	zzujqUwPIe0/6LUy0Um92LgTqk2oCau/V49tyirKOAU45EndYf2mKqw3pb3beaIwobmuhR9l4uF
	5TZODU9/E4m2sugGc32UKlXa5VLNZ1wm0UQuNg==
X-Received: by 2002:a17:903:1b24:b0:2c9:d8c6:1dc3 with SMTP id d9443c01a7336-2d01598435emr49118595ad.0.1785278546164;
        Tue, 28 Jul 2026 15:42:26 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022bfa240sm2317495ad.65.2026.07.28.15.42.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 15:42:25 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] crypto: cesa: clear cesa_dev on _remove
Date: Tue, 28 Jul 2026 15:42:23 -0700
Message-ID: <20260728224223.82278-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is already done on probe failure.

cesa_dev should be set to NULL as the driver checks that it is not and
errors saying that only one device is authorized.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/marvell/cesa/cesa.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index 75d8ba23d9a2..f0da4676b15f 100644
--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -527,13 +527,11 @@ static int mv_cesa_probe(struct platform_device *pdev)
 		INIT_LIST_HEAD(&engine->complete_queue);
 	}
 
-	cesa_dev = cesa;
-
 	ret = mv_cesa_add_algs(cesa);
-	if (ret) {
-		cesa_dev = NULL;
+	if (ret)
 		goto err_cleanup;
-	}
+
+	cesa_dev = cesa;
 
 	dev_info(dev, "CESA device successfully registered\n");
 
@@ -551,6 +549,8 @@ static void mv_cesa_remove(struct platform_device *pdev)
 	struct mv_cesa_dev *cesa = platform_get_drvdata(pdev);
 	int i;
 
+	cesa_dev = NULL;
+
 	mv_cesa_remove_algs(cesa);
 
 	for (i = 0; i < cesa->caps->nengines; i++)
-- 
2.55.0

