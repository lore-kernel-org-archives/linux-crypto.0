Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110623AB260
	for <linux-crypto@vger.kernel.org>; Sat,  8 Aug 2026 09:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786181216; cv=none; b=VDWjduej1Vp+g8WjcJ1lLMRdV9xIgqmwAIl6/xFHTZdvnTlsIa3kU8WyrAxZFSjYLiJXwsQ9dwEzlAsZAiYiJ+Ql+6Nrbs8wzBgcsekLiDFmVVZrT/J0tflmIzjuQgycKZG31Tj6ICXZB3d7TS828vD7E/1DsTdXeg4FI0u+MyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786181216; c=relaxed/simple;
	bh=KGQpJDG2e4eg5QZCBOxotyJ+R5vVftN3hOWih4qmIjY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sEJi8B6bmbo16euFmtDq/Ue8z9h31lC9hTdob2/i76Ji5ZG8RRKhGA5PPRGCD9rDaq3DzmzNEqt575F0C0XcFTcoQwBY7pkWIHGZ5rHPzbxTnZlG8rBjPdM/yjNeNJ9hOW7bf9c0EwlYErsRikZ75ZQSiB3kFTXBKW0L7V/fVvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KIbZ8KQ5; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KIbZ8KQ5"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-84f3ab8750cso330383b3a.0
        for <linux-crypto@vger.kernel.org>; Sat, 08 Aug 2026 02:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786181214; x=1786786014; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5/n5vs24CVZDYo6NRZWyHt3f4uc0JNiNtoLIec7JOs4=;
        b=KIbZ8KQ5uXWTHMx7IcqZVqi4W6Vuu/nMQSWPI5txuaIZi2Ynel5CkN/ts2lhxiMkFs
         ok+hs2pkFgVKJNQpLnXcE2ypU4GLJ7dai7PDvmTbJGP29GiKEp6VrRShTIIB9uz99fnl
         doQuchX6ZuVFJ/S+jyZr2zxwyOjXcAV+ZPcO1vH1Og8HZBv58LoejiJOCnaqtDx+bpJu
         AQrz5Ej7eFCb9FSfhhi8JGHIeuTdivI/WGBvNHpyyaNkCYgoL4UfRCAvQ0679YHiBe7f
         YVNgYJ6d2pzUYCoY0btSywXBdGou8zxMf6pNv/3uGZ0gsG33ldof+SRvwotw66MckzaH
         WkwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786181214; x=1786786014;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5/n5vs24CVZDYo6NRZWyHt3f4uc0JNiNtoLIec7JOs4=;
        b=omEVpN8PVlViEzxpLSgzFva/MNsMuozQIWMfxKV72W3/IkH/PCyTlKIDR/KkDDg8wi
         a2bbnNnNfz54HyuQHKFLThvY/ZRWEIlU+8mYneCoOpwQheFXXWeppxPKE9E+3qaSwN7B
         eNcjBw1tLmTRKvKTfsVEHjo7emLCBI5KqNGfTjQgPXrkb4sArMwl6cbrs7ptXtaDcAsZ
         tP0D//aSlYmibmpuxbmqABOLVT9Rt1tfkhHUJlBN60vkwBH9ks5YZnY/OSwLlqYNPO4d
         XJoryzTDwVlACmnR0G0EACGud2huOlgcaruzzapHzuI7MCzuQiur13qHJYD+Rs7WrEQj
         4NdA==
X-Forwarded-Encrypted: i=1; AHgh+RqDVl7v1wcNKJpEq7QsLb3p0zj5EEQ6Tbs+p4xnoxAg+6mnxkH9KQQKD1ClA5m0gdhGv2POJ7bAAcP2kGo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVZsB/9vPF4aXPtVHYFg45XV4KotDCxa3At5Gxh0hE1dhWzPk0
	eO0FiqRlmgPPrxVOv5rktlGZuvH8OFp4THoQ2gufALr8SXBGuVS9qWay
X-Gm-Gg: AR+sD10GAZ50aCKcDam+iSC0POSZICgvwAjyQ5d2e4c7cx/V11bs+ARC9g9eLW2qdq6
	Yw6xW2kytTfTWvzsiOWgs7sGS5tqHEhEab5wnfatpw4IJk1LKBG1w7LSZYIFXnKCv5IE18mjtLG
	AQGrdFXdyvRA+5SQbQD6OgW81/QfROC9+DITyKbYpo4mBnbIVprsdvaUw2wjc6FkY540NYBbbbT
	QTDxgLpuN69GpUJdxpr0j4ANF7j1hDrVv84w1pBqe+Ufd1R1vUtB4qWT7GGNvDvcUk7ILpFueoA
	G0D7OVUoChsu2uEDR6tQ5Pn9vMNaxiImcbicJyHuoRZmywyTM0YgSCypIa+8GPOv18vuSh4FTax
	sjUIMpflCFpvPt0HDn4yVaWzvMVAu0VSohz56b17RbnEonwLjcPk8fesK3z3fJBzwGd37ba1f3U
	j7cddS0S0xCbFmhJxZYK3IaHP5PjxCFjrS5DNRrrODq2JEPyIJzruOrGMPZA==
X-Received: by 2002:a05:6a00:a247:b0:845:4126:222b with SMTP id d2e1a72fcca58-84f2e00ea1amr36933658b3a.28.1786181214390;
        Sat, 08 Aug 2026 02:26:54 -0700 (PDT)
Received: from lgs.. ([101.76.249.46])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f5a51f166sm1943751b3a.35.2026.08.08.02.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 02:26:53 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Corentin Labbe <clabbe@baylibre.com>,
	Hans Ulli Kroll <ulli.kroll@googlemail.com>,
	Linus Walleij <linusw@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: sl3516: fix autosuspend cleanup during teardown
Date: Sat,  8 Aug 2026 17:26:33 +0800
Message-ID: <20260808092634.2734292-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sl3516_ce_pm_init() calls pm_runtime_use_autosuspend(), but the
autosuspend setting is not undone if pm_runtime_set_suspended() fails
or when runtime PM is later torn down by sl3516_ce_pm_exit().

If the autosuspend delay is set to a negative value while autosuspend
is enabled, the runtime PM core increments usage_count to prevent
runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
during cleanup, this reference is not dropped and usage_count remains
unbalanced.

Undo the autosuspend setting when pm_runtime_set_suspended() fails and
in sl3516_ce_pm_exit() before disabling runtime PM.

This issue was found by manual code inspection.

Fixes: 46c5338db7bd ("crypto: sl3516 - Add sl3516 crypto engine")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/crypto/gemini/sl3516-ce-core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/gemini/sl3516-ce-core.c b/drivers/crypto/gemini/sl3516-ce-core.c
index f7e0e3fea15c..f09a7f3445e4 100644
--- a/drivers/crypto/gemini/sl3516-ce-core.c
+++ b/drivers/crypto/gemini/sl3516-ce-core.c
@@ -381,14 +381,17 @@ static int sl3516_ce_pm_init(struct sl3516_ce_dev *ce)
 	pm_runtime_set_autosuspend_delay(ce->dev, 2000);
 
 	err = pm_runtime_set_suspended(ce->dev);
-	if (err)
+	if (err) {
+		pm_runtime_dont_use_autosuspend(ce->dev);
 		return err;
+	}
 	pm_runtime_enable(ce->dev);
 	return err;
 }
 
 static void sl3516_ce_pm_exit(struct sl3516_ce_dev *ce)
 {
+	pm_runtime_dont_use_autosuspend(ce->dev);
 	pm_runtime_disable(ce->dev);
 }
 
-- 
2.43.0

