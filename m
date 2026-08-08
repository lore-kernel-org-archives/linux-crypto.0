Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7AF5205E02
	for <linux-crypto@vger.kernel.org>; Sat,  8 Aug 2026 09:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786181436; cv=none; b=jvCG005psiYKcYNf6P/Yvfne3htrBf2OaqypZbVe8N/YyZMsG6zN83QiOYvPOu+ND4oKSBmrGw9CYL0eAQLuD+z6RkEoAu4HgZ95so2dgf+GTkT+H6g6xxrd2kAt6toh3rw8ZYdxLIbfY+pBzvyx/3fUgdgKHphdSkYXmasM02M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786181436; c=relaxed/simple;
	bh=JxTOJo4MhGNdlCG8FhGvKU8SJgXQL9LBKbPWw9wDuhg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uaG2dFgFRtFew1DQs+5spmym4t16eWRkfLMXYmUJ9RoxNboLHCyL+PU2z7RU+VeTjdB0BZJB8/CRIX/JLeE295X6QRChDdgO9nYf3tM1oxTv5Ris2bJtkSpE9C2Qi4DvWmJKTZSLUxaYUYEOP7yrc42wtmsld3kDm6pDn4cc4Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nhl1hSL2; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nhl1hSL2"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2d02b4c3601so4010595ad.3
        for <linux-crypto@vger.kernel.org>; Sat, 08 Aug 2026 02:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786181434; x=1786786234; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gC2ItiHuCYFgaLZeaOk4o80zqG6tRez0H0meLhFxwtI=;
        b=Nhl1hSL2gAXO/Z5ct+p8mBtNu+R0MgjJZ3RvY5tZ/DxyWahhLJGietVQ+wZ3wG4iNI
         yWUXSxLbcL5JaYaMj5UhkyAWrKljpIAyu55jRO3QJZvEhK/7guejTmHNTN6dTi/lMyJI
         oQVNuXk1isTLeFgSSBSwSQHiS1drHS34j9d0R0GiJyD9co6yR2ROg8YZAkm5fOOiK3JU
         2F9ujAcSL7hznpITjQyF0nyCJV/5uGjXFyWPbtfGmWEgT83/wf/CtLiDl4E+gSkUVFnG
         VoCm4lLjqdC4KXLqhUR3Rrsb/NeYSJmflqUzO5Na8pmQsCFQfybD8hp+5Jcw7h1CnmYt
         ogsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786181434; x=1786786234;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gC2ItiHuCYFgaLZeaOk4o80zqG6tRez0H0meLhFxwtI=;
        b=NyAci8n2EPX58Z2btxDA7FGlGZzMxktN2658l+iyI9zM7w8sKlwUvrCIU1xwlmiQUu
         pBsshutas122FK6WvQ5HayBt6KIs+gOyPUnFaYxbNr8/C0Y51SP58hQDJ6DWE5Kt1AVw
         5K4mblTxTr7CNdAd3wDVTqSaORnQkvYikwCQ9HPDvq9NYpeH6cqGygxelpmBAwvcPOa5
         axNBs+JGf+csCEiNSytmCL8uRyA7khKuCau5JGlBkDaX1MhfhhMcWdPTwzJbIO+T0mk+
         H44UKIppUhYMFIJ6b4JQLOEOQD+pyA4Vt0g2+8wJgsrblKwAyZLJfYFORTq1S90k+J37
         GEIw==
X-Forwarded-Encrypted: i=1; AHgh+RqrHTDyOeeeL3tEcHtbLggCzSyKi8n0fl0m/U2GQwsFdGS1ySzzZEk+4tC8yBLj1KMLnLry7OJZGXkb2ro=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQ+7k+gNQPoe29aX23QB++SFSL6jhKixGkvF17lGtvfOka1QHv
	MX2YBGgPmsztK2IzqZ+6q2/DvHTUGq6TiLKPEVQLpi3cqQJqDiKAgut+
X-Gm-Gg: AR+sD12vSoobH56t4bJJurnWWQPSNH+D1Uls+VCk2zrjz3XlC0BiKv+vQXiNT0lPYzX
	nifS1khnFyY0uRYcsl9IEUZOOvgpcszf0SQkCf0pPrSJEb2F7MjBXan5ozHg8NYLr/uuPILQ5HB
	fjcRdqWZv2wFN+++7afFHY3n7BxS+YfBT5iCE1iXNwqprGKvhBe515s8DqxBel/O+c9HiDAq+KJ
	BnCFzv0W+LjDwfD5rWGX+gRcgLKBAbkIgr+Sog4P/RNhoEU7maM0E8kSk1I//NpSZBCIHVLvUH8
	vHRfLLnOtoqLQyM9OCVAAfRqk389upSfmCobMRre+kMSxOMg4E+wgClWvrwXwjaOAsdw2xD/P+Y
	lxAyWQKi4SVOYXTwmPD/6bXXZaAxryJztk0qLqNoyCtzuGRJxFShnnXHjUW0UlQuL8gy5GP4s4t
	GLXj0/UEIyZMAUcbTeSwuT+1BtIPeqNGI8dboVpAWf5QwXVMy045bvNQjue9Rx2MHz0kEg
X-Received: by 2002:a17:903:3201:b0:2d0:401c:2ebb with SMTP id d9443c01a7336-2d0ca7125cemr362470225ad.4.1786181434060;
        Sat, 08 Aug 2026 02:30:34 -0700 (PDT)
Received: from lgs.. ([101.76.249.46])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d14ccac0f1sm17098055ad.7.2026.08.08.02.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 02:30:33 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Corentin Labbe <clabbe@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Heiko Stuebner <heiko@sntech.de>,
	John Keeping <john@keeping.me.uk>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: rockchip: fix autosuspend cleanup during teardown
Date: Sat,  8 Aug 2026 17:30:16 +0800
Message-ID: <20260808093016.2738659-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rk_crypto_pm_init() calls pm_runtime_use_autosuspend(), but the
autosuspend setting is not undone if pm_runtime_set_suspended() fails
or when runtime PM is later torn down by rk_crypto_pm_exit().

If the autosuspend delay is set to a negative value while autosuspend
is enabled, the runtime PM core increments usage_count to prevent
runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
during cleanup, this reference is not dropped and usage_count remains
unbalanced.

Undo the autosuspend setting when pm_runtime_set_suspended() fails and
in rk_crypto_pm_exit() before disabling runtime PM.

This issue was found by manual code inspection.

Fixes: a216be3964c1 ("crypto: rockchip - introduce PM")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/crypto/rockchip/rk3288_crypto.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index b77bdce8e7fc..cfca472f996f 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -150,14 +150,17 @@ static int rk_crypto_pm_init(struct rk_crypto_info *rkdev)
 	pm_runtime_set_autosuspend_delay(rkdev->dev, 2000);
 
 	err = pm_runtime_set_suspended(rkdev->dev);
-	if (err)
+	if (err) {
+		pm_runtime_dont_use_autosuspend(rkdev->dev);
 		return err;
+	}
 	pm_runtime_enable(rkdev->dev);
 	return err;
 }
 
 static void rk_crypto_pm_exit(struct rk_crypto_info *rkdev)
 {
+	pm_runtime_dont_use_autosuspend(rkdev->dev);
 	pm_runtime_disable(rkdev->dev);
 }
 
-- 
2.43.0

