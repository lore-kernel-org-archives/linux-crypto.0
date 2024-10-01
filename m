Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7DB158218;
	Tue,  1 Oct 2024 23:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727825151; cv=none; b=Pv3v/FY4BnlDDTB5VvLV0Yy0z8H0zcEyzZtIrDUvbmbZ7Z6sxYio43/xqOKB6dKgPG3Mhzc/BvewEQbWUi9Ns78XvAynlEoXPKVAEJoS8XNKt2xepz+B4h96IM01yaDdYwBZ9Hv/KXXJrmx2iDZuwO408MnDcEXonBrNwVY4Hc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727825151; c=relaxed/simple;
	bh=OgskX+l0APlVibbMrpcfTiMB3GYLJYGuNLEXvasVrXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Tj++AX8CB1odOYit5ihbTGnA/FaQZJ2clOfw7Wf0C11aZB8xKSb54ySdzXwPV+4BHnXogwQfxEC4moAXSqp5TkqrB96wpLSW5zeZsOAvl+YGByS632ql/3pXZX5+8mXmchpXvaDJ9C80wcrWRE2rqn4w19QLoB04XySMEOrVwz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PUfrj+ju; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PUfrj+ju"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-7db54269325so4654163a12.2;
        Tue, 01 Oct 2024 16:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727825149; x=1728429949; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+DbarH2e/XW7qHiFyEkw3ptuWWFX48Ut81rfmzqCA3g=;
        b=PUfrj+ju58K244f79T80ELcjgJMwBOcDZFwAQZw4aSDUjUVHz/WzIMJPW4EoTNLf73
         KhD6s+AbFrRh/DN3K18myAEdzUt9p5e1LPxvhc/eKdlduHWrFrHaKMpDJOFxtCIa6K8E
         3lCep+N74ZqY9w1gEh1K+WBYI0664IeJ1Wi0UcJ/veXPzhzCzhygWeTh+/r/zLwDADo2
         nvJYl+AinabtsvFOxWVOYvyKbiPYHEZM12/LrbMp+Nwuzp0VIJSj5eLXo9S+E3lj3Q0C
         HyTBZWOMWABeBwdPm1SeUwRN8i28o2dxkgElm8rA5g2VSCqqdIDjNyun1Y6oF1s3M28Z
         DrDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727825149; x=1728429949;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+DbarH2e/XW7qHiFyEkw3ptuWWFX48Ut81rfmzqCA3g=;
        b=TrwyQFiWqr1BCK81KR5tojvE+mlaXrtNgMhGUuD+ndw0ev4yOqMThRcAchqVhe/svj
         NOHeGD8btShxIHm9npbMJSEYZXsbnHQ4WkYEqkwUXpEVAiUOV0nuitI2UEuM0XulSq4N
         vu+A178CABMYuiTpyvnMO/+wkI0VK0gbQcO9IFWI8lO9F0j6L7XwHegPdyFwlCKtmwdu
         zg/KqpKnciDO0L0mEtanZrI940gBRD37bTqFZXJcf8/ebiHItFjhVRBlFQIbO9zEJiYv
         am0RR9geDyfzkGu1jJ6Ds+Nz9b8VAo787vbQDRuK6xUL/SS/wWIbntz6cTMLShNi7aql
         tD/A==
X-Forwarded-Encrypted: i=1; AJvYcCX9udkDfDjhIalWZNQS4ab8NNmPUOJRSGg/bnyry9kPtTwr8smuN+YR51v/zGRBCe/1xj7Ad6jRRpk07uQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyX0RzFvgz4Ma3As+k3RTczE1EuqMxbhnGiuBdEuMULD8DsWCmt
	8xXieO5gDMKV0j6/Q+kdxQcqnOg+3o+aEdzeZtC3uVbDM4cKrVOb2UnkCplU
X-Google-Smtp-Source: AGHT+IF2wlJNU8NHwo5P85gPLraUz/6K6btqxoTg82fpUeidznKKjtfqoIbjNiVROzA1cIdQPKkCAg==
X-Received: by 2002:a05:6a20:aa88:b0:1d6:a7f5:2e19 with SMTP id adf61e73a8af0-1d6a7f530bdmr1250946637.2.1727825149098;
        Tue, 01 Oct 2024 16:25:49 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8200:dab8::a86])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71b26539c5asm8628143b3a.210.2024.10.01.16.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2024 16:25:48 -0700 (PDT)
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
Subject: [PATCH 0/5] cesa: small cleanups
Date: Tue,  1 Oct 2024 16:25:42 -0700
Message-ID: <20241001232547.355947-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mostly increased devm usage and added COMPILE_TEST.

Rosen Penev (5):
  crypto: cesa: add COMPILE_TEST
  crypto: cesa: use enabled variants for clk_get
  crypto: cesa: remove irq_set_affinity_hint
  crypto: cesa: move loop to mv_cesa_put_sram
  crypto: use devm_platform_get_and_ioremap_resource

 drivers/crypto/marvell/Kconfig     |  2 +-
 drivers/crypto/marvell/cesa/cesa.c | 71 +++++++++---------------------
 2 files changed, 22 insertions(+), 51 deletions(-)

-- 
2.46.2

