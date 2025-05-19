Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E9927A121;
	Mon, 19 May 2025 15:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747667672; cv=none; b=S9EuVXIGKqhTAlzeZ+5MvSRTBGplydjcY03coZFcPSCslKIIwZEqc842M0eEKe4I2rUYHteteU6FSPq0lngdC61/6LuVZfUKBvTI88oE9crF1R+yKc5gnekDvbG+PpDbyexamWnrGoHkj/00QGqp803RjnhDGV0rtZue6L602lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747667672; c=relaxed/simple;
	bh=tlVXRvNMHzLQ2IjUl++okGPXDqq4MPvOzcHaYSkpS6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JslbY42Doh0LC7d746F5IPDArkc3cw0bqyvvP/HvAhzYT/f8mKaWyyWrYS0XdmSiot0noFMl3LllMutNJpgr7XYCxgreCbRysG7kFIZ7/xTB7wUSOOs+S+SeXu7dHhsYc9ezzoscw89wFv9rsKCr2Czl/wjwje8O3DmULPvatAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YfL7Add9; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YfL7Add9"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-601dfef6a8dso2124048a12.1;
        Mon, 19 May 2025 08:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747667669; x=1748272469; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IqcrMvL7TRi/F7iH7e+SW+BnTVjngWX2CY239LaHS6A=;
        b=YfL7Add9HNsWw6nwGx9ZAh+pTOyN/+2bEaex23JbtmsmTmxTBJXFLJ8ByrSDYTEfDA
         nhB0EczZ8ZZ5QReuWZlRChyLf6pAYfSSuV8n24m854q/FanZ85l/Xiin+oIJiihHqwcN
         0ohg1BooG6/On73uDrIu9HHc4xrPTnNRgnbpRmTh4wsjRsC93UvFAhg48N8hZ0QxFXNL
         SUtMgTL9qjp0hstN77VNzE5i8fiV9vYcocfzjNCe1PRB98va4DoQ2/N0RzU+KBKyxEO3
         LGly71PXNgQ+TnakfKn6HEZ7Rzcn1/R+xgOd28DQybv4pmdUIIOYqWw8TQdDSTR0g7M9
         yCOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747667669; x=1748272469;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IqcrMvL7TRi/F7iH7e+SW+BnTVjngWX2CY239LaHS6A=;
        b=E8/PMmWSMvgOUOkrE0kgPMxd083rlBxXJsgN/p4CYOYnrt4DVju1XbG2mewYamHiQQ
         phwt+QSfy6g5dbXxcODKy+WI8nEQDge1CzMS31E147e783mxJTGr/cYAh9kR7WGu7fvd
         Pxidn18nmjWRaizdjX+cNDzl+2o+a5jwITslWWQsm6TBlkO3sJONmxove7gdrzZHbm3Y
         QA4hrm9cyuIx5kinCddWZaiNF/+GeZcO3Mi4IEySp8A1lcUhVa29Ndb0WRRPotWpUaI6
         Tn943AfqMjLXeGq9UqJhmiC/4DM4KfWIiaSYX+L63OBA17f97zbohKnGYJfEZgUVJajL
         PkYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWU+RPqJ36Hp5XuSpCLYoIEji6P4MTH1yZf4SS8wnFGdZtKOht1QX69pGKQc8VPoDjJarC9Is7aEVp7SLB8@vger.kernel.org, AJvYcCWyxU3lR9MHgoZ3mAMjnJGDyS6qZpHQg/Z8Y1hyTmhvEGOZRxxa4P8NOt7B+HKs6nKJcRgzknZmpZL7tx8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGch6+OeGxBOgqo4PR5Q2uqpZZx3Fw/HJZ0Sty6x1qlZXsSxEB
	/afaY09b+uI3iKQZ56/krPpDbOHnmOcDvsHaAtRuMAz5zWWFBIj4Voek
X-Gm-Gg: ASbGncuS+pDXvSvGkocExva4mOBu4XMjkuuIc+UPm+UEGSKULqOJmIXCGFJUNoUJanT
	QGSGJnOQxqxwnn7bzYXTF6y64DYHY0pWiOKeZC9palFxH94tupxXLBDqqeQ9JaPqHvdofovAp9z
	E9dtsrrQYkaM8nGjjOvwviYFEliwi3FafCC1dvbqiYiaHviHwqV9loAKqunXFrrnMadzpsEU4xN
	eRiTfetkdyM8u/n6OYquWJtCIL2Q39m6Yc8/PFwnSu5Ki7mDjLUX4//mKSH1w6FtFeUMyqjd4xc
	wgHtdeEwgR9DvJKOih3f96FjwRsegWFRlVBuepaZCKlqr/0VwLUT7Uzdo+tWVAEW+oFjq2slack
	Q56A=
X-Google-Smtp-Source: AGHT+IEyDWsgk5ZuKcJJnCwuMrygWqmpsdfXmccP5TnaNBnDa5/JU98yEJj7J7lss4EJg1nxvJYFvQ==
X-Received: by 2002:a17:907:1b09:b0:acb:b900:2bca with SMTP id a640c23a62f3a-ad52d07636amr1189789966b.0.1747667669049;
        Mon, 19 May 2025 08:14:29 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f07:610b:a400:6472:d2f9:d536:4c30])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad52d04b08bsm608522566b.13.2025.05.19.08.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 May 2025 08:14:28 -0700 (PDT)
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
To: clabbe.montjoie@gmail.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Cc: wens@csie.org,
	jernej.skrabec@gmail.com,
	samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Subject: [PATCH 1/3] crypto: sun8i-ce - fix nents passed to dma_unmap_sg()
Date: Mon, 19 May 2025 18:13:48 +0300
Message-ID: <20250519151350.3442981-1-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In sun8i_ce_cipher_unprepare(), dma_unmap_sg() is incorrectly called with
the number of entries returned by dma_map_sg(), rather than using the
original number of entries passed when mapping the scatterlist.

To fix this, stash the original number of entries passed to dma_map_sg()
in the request context.

Fixes: 0605fa0f7826 ("crypto: sun8i-ce - split into prepare/run/unprepare")
Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index f9cf00d690e2..7cd3b13f3bdc 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -278,8 +278,8 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 	}
 
 	chan->timeout = areq->cryptlen;
-	rctx->nr_sgs = nr_sgs;
-	rctx->nr_sgd = nr_sgd;
+	rctx->nr_sgs = ns;
+	rctx->nr_sgd = nd;
 	return 0;
 
 theend_sgs:
-- 
2.48.1

