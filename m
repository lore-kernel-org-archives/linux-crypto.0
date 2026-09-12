Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A4E384CDF
	for <linux-crypto@vger.kernel.org>; Sat, 12 Sep 2026 14:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224384; cv=none; b=lhgfEgiT/AmCy5n0dpJyLDvagBwihlQVeo00OQBz7k14jUg7yZyXmZdnSEj4AO3nbtMFhcrWnV08ToEoEVefpuNuHVVuCSLW+AozpeegBudFPtWowQihvPAsa4j5I8gURHtrSRIYjMqMEoN66bpJB/Z8QQavUzWJByiMxQFKj4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224384; c=relaxed/simple;
	bh=GAg2KcHj6vIzVzvOv0EEQoUKS+sOiIbdJa3s/8hSw+I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dFqgJ+wRojNKaPC9e4mAg4WigqJvpO8G4puQCx1zv9rswNBF4MIW/TpfLh89aYTG/HW52hRh9rk1DM3f3rcMUeqNharn3SxeXh6C9a40UJIJlMOafutkCxBrCR/oSJPWWBS5HsH9E5C6CkVa9F2Y04hdssYd96trzpCdd58whBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gPq7Wr2P; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gPq7Wr2P"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc1cebad4afso877469a12.0
        for <linux-crypto@vger.kernel.org>; Sat, 12 Sep 2026 07:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789224380; x=1789829180; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TmaoDFxzQKVyaXm36B4ffdDPK6QYqEtkuSAzwPXlrsc=;
        b=gPq7Wr2PLo1XnI52+zR7mv+T6kM+yhLU3I9uuxGGVhh4M63utKJYsgv5o3yQVhagEP
         qf2++SHF65zzSxtIwmRjC2EkJkeVOCQa6Kv/SkVX/4cacnIS6qIv7llloPvZpeKCtN97
         N4jmndHQQ9WhoRW0HyKliGIAS4hX6jgvvbIKgc7eQt37OoWcafzeX3tWkA+GZ4XfFoRh
         QSvNXlqADbom9O0CjA3J7/c2LV6BJLueYDt4GtoJ9k38ghjiV9DXzli6cAZPPvR4Jg9i
         DEklXCrZcOBYMR5ySQbbmTIFvzpHSWguAGuxta4OCOcq6x1H7n3BCxJrl7sqkzpOt98K
         rGZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789224380; x=1789829180;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TmaoDFxzQKVyaXm36B4ffdDPK6QYqEtkuSAzwPXlrsc=;
        b=WC+X8QUsFG+S1ZGAqaP46ztXWVb1aBIDiXdfqLjGtEEKvvyIEsi8oC0TQgT9PcGeu/
         9Z+3Hb0vTz1N2E3rNYqB/cQALCHR1tnonq2VZJlXSL8GKrx50kEnMu7CF4mgBgI5+4ut
         +mxRYe23T0BwQ8T7Yz42rlCbRwVMFbo/hPA4MDorR9rIxYOhbaMB5XHSMYElKYdB/NPI
         IkZ+Yj+fUi6gq/KBi12uaG/3ge6Bi2YLPRvloW1EOl7kcHCWwaIt5asXywtd/s6rKUv4
         3d7anrBpK0topFpgPJNNKnFxnXZNBOMu1fulmLfTYdNivbon1apUibwhxTDhCBB/aCn7
         T2xA==
X-Forwarded-Encrypted: i=1; AKwUvBzriuAT4o7g5PfFHvMoqeUatLEvOJoGZ+Ph0R6cpWsuFpxsGe7FuzlKMz3wVywsrHfSAZFeqFvdT2h4AVg=@vger.kernel.org
X-Gm-Message-State: AFuF++kmHBPBWcK9kOPt5Gl1ZRZ8Isz5cHXB6/8o7VJlQs16e3O7YYVB
	74S8baqNBfr6tvAeFSjm2aLmIY7s7tJUzK/IBIG8bcsOZLo1AypxgiA3
X-Gm-Gg: AYBFou28hcNrfLV/1i3c75dcpDLbo+aTd9GjbjrZtKPE8ryCtIPBOeqpRmMGBBWZjXp
	UaREP0KUpzoIHEZ0tP2iExLpKh1Bszkb9t2mfErYnXIPHx15oCGywSD4lZ0hyRd+ZuCkjFSR0Eq
	lss9Ifm/W9xqABd6HxyWnD+XDGXTm68TKVZp0Hr0vuC7MS4rqhuRsr83UjqGWxlq2vGOjhy44gq
	5J7oVUCueTVYg7zHAYAVXsfjxDDbH+0hxKVUG16RJjxc+S8b2MM9OlooMaAkkHffdABMjFDoDpi
	yXoSyuTfdRopO8+Qd9JQkQ/kkTfncjLFtXgWxduTWhqhE0Wp/WVvcSsV40E5JAVbtHDFXFNfNib
	WUKclFtqt3aKtJqWSrtgyStB5VTTLUQR7+Ww7jXnVtWpyjX/AMNltsj0n8o8Nfe9NfhuI7p04cO
	oNUM0anu3KYh5+YdC4Ju4Po46gtGrR98j2qhgv9wmM4D0CP+abHG3PiQ==
X-Received: by 2002:a17:90b:5383:b0:390:8361:a532 with SMTP id 98e67ed59e1d1-39d9bc44d58mr18616906a91.7.1789224380269;
        Sat, 12 Sep 2026 07:46:20 -0700 (PDT)
Received: from lgs.. ([2001:250:5800:1002::de93])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d98e60484sm10398006a91.4.2026.09.12.07.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Sep 2026 07:46:19 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Tero Kristo <t-kristo@ti.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: omap-sham: fix crypto engine cleanup
Date: Sat, 12 Sep 2026 22:46:08 +0800
Message-ID: <20260912144608.994510-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

omap_sham_probe() allocates and starts a crypto engine, but the remove
path does not call the matching crypto_engine_exit(). The probe failure
path already performs this cleanup.

crypto_engine_alloc_init() creates a kthread worker for processing
requests. Without crypto_engine_exit() during driver removal, the
worker is left running after the device is removed.

Call crypto_engine_exit() after unregistering the algorithms and before
tearing down the remaining request handling resources. This stops the
engine and destroys its worker.

This issue was found by manual code inspection.

Fixes: 133c3d434d91 ("crypto: omap-sham - convert to use crypto engine")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/crypto/omap-sham.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 6d2dd0b88f15..207fc7680c8f 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -2129,6 +2129,7 @@ static void omap_sham_remove(struct platform_device *pdev)
 	list_del(&dd->list);
 	spin_unlock_bh(&sham.lock);
 	omap_sham_unregister_algs(dd->pdata);
+	crypto_engine_exit(dd->engine);
 	cancel_work_sync(&dd->done_task);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-- 
2.43.0

