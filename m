Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F241CFEC2;
	Tue,  1 Oct 2024 23:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727825158; cv=none; b=NFpjLSOLhKj5QYZ8M8HLemOOFr89P8lpbk0Y0RaHH2wNAgFW0w2u94ZXA2wofFkHSdKTt2n1XrrO1jlCFWdaf+zL3n0X/iyy8RC8MtRbpSSEdvCjlPnXMg8ljfJrRurID41xQWEVvRuEhYtJ5yTRN5ZB9dQzqlDWZvG50psUoiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727825158; c=relaxed/simple;
	bh=FfyDs1TC5dH9vKpYzlHY/EKwJnCmVg4259BQUa5YcYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JsiiTtAUuSgciOB026aJqV+uGKcWOAX2YhKxWGsFlK9w10AgZWA2zWgoU9bncKZfsPNofvaAZiA2xQot7NBlDPZ5Z5YrbyRFabebg8RcR2gM/4PipgPXJycrmkEJ9Ko4jA2//zovrgJvKVuFz6NXBIGB9pC6X3N/G5AEUUHo3N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W9rxST40; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W9rxST40"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-7e6cbf6cd1dso4154123a12.3;
        Tue, 01 Oct 2024 16:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727825156; x=1728429956; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d7A11XDgxNYin/VkwABPFnYDQbab1NvKclWfdZ0MPzI=;
        b=W9rxST40BZnjeZrQ0GNwxdRa1UYL+tCrNvVCDUhMl6pxNgbG7fdVEOrlJCDiF6Oita
         V+hRjCtIrKaytql4iv3p5liOWluzJMKpW1vu1KwCkGzedOJxmTGnRP4VnSTiTPe2jkR2
         Lx8gF0dD54w+uVt+ppgxuHGM4A4gjFh/uBDvCsLAhjSLAly/Ke2auS9PkcnLLMAayeY7
         vmWxfnj0hUzyT+WbGQKSd/GpAUCEaS4BSQ5whOrwfvYURYjyxUABb/HxiuaB6oP/jrw2
         gUTem7ts4Rlp+EnIqzpdNPFIDoUc80CQW48KqvFu/K3Sig6qvb6taj5D/nKJPruBvkl1
         RztA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727825156; x=1728429956;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d7A11XDgxNYin/VkwABPFnYDQbab1NvKclWfdZ0MPzI=;
        b=gMPMDV/SwomSWd3kMpJlLPyM+TVcwETVMXANDKwfjrNKeGpQzJ3l6u1pR/S0yhX5Y9
         Q59TG5ud7zbenfXCQYWJKUuERFXLwtxvstK6sDQpKvMeLfa41NsxYdJt3F5SjM+aRX3N
         XGczibYotWBBjO+kN4MX55ghWKeS60rt5KOOYVf9UYpSmouBcz1ZOHXFade2CNBLOFzr
         slXUNDvPOqKSLGSMBwXD7Kq62J1HbaakUwqyaLr3aUdQ47yvZLmw1L+YT+5qqDfxA5wM
         PSIQJBWAbpxov75emEuf2D9c1U1oUJ9JcaS86QSfWxyZfHcdTqUYhT2k8E/O388OYt2h
         m4FA==
X-Forwarded-Encrypted: i=1; AJvYcCUGx0hoEiJ0BYoS4f+vwOXoqV37yyK/7rijLZ/Lo2+aBCIUsSTrfaYeH/dO/nunCvBDLurxtSUjhtOXpE0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx10WROi/Tp6JU5RhuAXbjf8CACpXUhEhfyTiNTVYnguDi+3kiM
	8SzYB+FY0vfW87f4lQbaFZK4Cj0vcXCbGSHgc9FsR9pAWXOrkCgBfwmJUZp5
X-Google-Smtp-Source: AGHT+IFZHRTl5EAhvQKFyHclozxa+8AxkxZSFrzbQ+m5Ud6J0wQJEYd435ynTrzb90hJnJQ/RJIx5g==
X-Received: by 2002:a05:6a20:c6ce:b0:1d2:e888:3982 with SMTP id adf61e73a8af0-1d5db13e781mr2037818637.19.1727825155866;
        Tue, 01 Oct 2024 16:25:55 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8200:dab8::a86])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71b26539c5asm8628143b3a.210.2024.10.01.16.25.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2024 16:25:55 -0700 (PDT)
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
Subject: [PATCH 5/5] crypto: use devm_platform_get_and_ioremap_resource
Date: Tue,  1 Oct 2024 16:25:47 -0700
Message-ID: <20241001232547.355947-6-rosenp@gmail.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241001232547.355947-1-rosenp@gmail.com>
References: <20241001232547.355947-1-rosenp@gmail.com>
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
index 3dc74d1a8514..e2d31b9c35d9 100644
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

