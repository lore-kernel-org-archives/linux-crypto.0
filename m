Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FBB1E47CE;
	Thu, 10 Oct 2024 19:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728589526; cv=none; b=d46FhFviASvdST5kdgt6UUwJM07ZZRGQPhBkmBOho3RUghUyFhtsgnacgmViszz6qL0K5U9KiG5tmghCSZmXSg2jtlizxdHuQhbqQ/xCnxvY7D11BU2SMsq8JpFxuG3Fw/I+D7GW/x0xfE68rVJ1VrM9GPwt59yMFHnPPfsTnUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728589526; c=relaxed/simple;
	bh=v2wQYF9MfkRR/XoJQpT+R25t14mcfTyXt6lelenjPVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmjAhOmalVtNV4bnmtHZB7X8mTya3s2Y9YN/vS71L65Dycln2r1BD0Xv7VC/Lbno2P77aH9cJzXJ5WRKCv7isbSAHJyoAfht5sXa1Mh5MkPsA67MeGPbryXQnphz08msnjNqzY7Qs4g/m4xoO3eri7Y6wykA8GceIC1/q6vQFcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kNNSo06h; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kNNSo06h"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-7db54269325so1091762a12.2;
        Thu, 10 Oct 2024 12:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728589524; x=1729194324; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AHFPYc/2pWWDgXQYD+cnOLFqpwx1O8WplMBHy/xRbmY=;
        b=kNNSo06hc+iBmJARFm3ZiDNJRJHxxxYdwHRMqVSfNVFq+wQgaGptLeQL8EsCrhEE7i
         Hz07NdOWnZRe5FhqQOJWOQ3ZjUbGmqnS+VCOgsX6NZJlZRTGr7DdXSn483CONvlszz6S
         UIesIIMGkIRRGqar/LIpMbUO3LzJYxYW+1JwMTKeiZazoU3kxxzOgpxZZ/+qWos/akf0
         bIjd2jS+31Jm+tFKzgyEGB3m54JfYoJPdy6aFdkSDSi/IggZLkiNmyWXgCu16x6W3d2D
         xaAsuFuhkHeT/iwri/cC7nFOxUxa7VZUAGVBJacgh0uyqu68PhVEoGPxHKLnl9P/+a6v
         1JxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728589524; x=1729194324;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AHFPYc/2pWWDgXQYD+cnOLFqpwx1O8WplMBHy/xRbmY=;
        b=lAp9DdRDBK1Atepb5L7NQoQ9ayuQDAzZySIYJ3m5/2ZWYlPr+1zbEdE5iN6PiFxmss
         e9xo+xP24OFg7q9IDvoOuDSDzcftoRhrTyJFBtW58xGI1fuh+7hVNwYUw/SeTFZMayAn
         1cIQhk5Jtx+ZmuIHznuro+K/0tkDqTZob1K7kp/jDxYoom0ya5w37D/uc+qNP6mb1Bq8
         sMbIC4SG1PTpxIHHuUHh9sXj3kjLz+9gGQQ+0BFeFBIzJYJTpN8s54vD7007PAsQLnz6
         wT9MQrYy3BgxG9IGghsMG75nCDfs9ttwIx08LP5ai9CWV0M09J+eC10S3fos6J/jX6Qp
         yLhQ==
X-Forwarded-Encrypted: i=1; AJvYcCUw/yj47f8cmBSCe6X/xJaXdERWAwJaOVwZzfwVY+d52cLJqyW+hGuNXoNBuHZcM5dNBRCZWckfpbttoOY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0YSU4NMQFoIwKN+UgCS88iCqp/AxkfoxENG/1Flv4vrIIIMfM
	xCZEzuEBs9aPu71c671tT5Gd3s2WzRJV8EzQnjK108UZXWLyQX+RnOkLqwOL
X-Google-Smtp-Source: AGHT+IEHDCRqtAVf5XduzxtBkZ47GOrAxKwWorGFM60H6Hy1D/4x5ZJC28d+E2rsGb3XRmGjIHLRrQ==
X-Received: by 2002:a05:6a21:393:b0:1d3:45c1:ad1a with SMTP id adf61e73a8af0-1d8bcfada46mr149320637.39.1728589523594;
        Thu, 10 Oct 2024 12:45:23 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8200:dab8::a86])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7ea448fe50csm1374762a12.29.2024.10.10.12.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2024 12:45:23 -0700 (PDT)
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
Subject: [PATCHv2 3/5] crypto: cesa: remove irq_set_affinity_hint
Date: Thu, 10 Oct 2024 12:45:15 -0700
Message-ID: <20241010194517.18635-4-rosenp@gmail.com>
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

This is unnecessary as the irqs are devm managed.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/marvell/cesa/cesa.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index 74a1d1ad67d3..21e13f4a1f48 100644
--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -566,11 +566,8 @@ static int mv_cesa_probe(struct platform_device *pdev)
 	return 0;
 
 err_cleanup:
-	for (i = 0; i < caps->nengines; i++) {
+	for (i = 0; i < caps->nengines; i++)
 		mv_cesa_put_sram(pdev, i);
-		if (cesa->engines[i].irq > 0)
-			irq_set_affinity_hint(cesa->engines[i].irq, NULL);
-	}
 
 	return ret;
 }
@@ -582,10 +579,8 @@ static void mv_cesa_remove(struct platform_device *pdev)
 
 	mv_cesa_remove_algs(cesa);
 
-	for (i = 0; i < cesa->caps->nengines; i++) {
+	for (i = 0; i < cesa->caps->nengines; i++)
 		mv_cesa_put_sram(pdev, i);
-		irq_set_affinity_hint(cesa->engines[i].irq, NULL);
-	}
 }
 
 static const struct platform_device_id mv_cesa_plat_id_table[] = {
-- 
2.46.2

