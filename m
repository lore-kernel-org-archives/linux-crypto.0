Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A3B1A6825
	for <linux-crypto@vger.kernel.org>; Sat,  8 Aug 2026 08:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786178862; cv=none; b=bW8dxyOgj7CZji0eNgXMZFqBCfhyKon9+JphkmPI8fcUMJsrwucjitsTFrPuK40Bl/SKBRrloPViFZL0uGuEyuoxUNLIzU4c2D84Yjv1ELb6JPciYxTlamwTR7l69shX3cgbDwXyhJsSpp0RZP6GfHqUjbyrcuKIipMQPgbi61k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786178862; c=relaxed/simple;
	bh=dXcsRK343bCHW9vLskDGkSW4aM3ih07rCmEM3TPGVzc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EEnGKpZ8UBl0qG79CX0kGwHOBYPcsldkOZd+ZhmM5CnIdyVm0qxgPudPCDJ12rY+52w+YV/GNq8IHUURi3v0sElo7FLc0+FAvhpvd0nDJlQDVclMTgwo1d/K9CRKwGrnAujmHoGu0mkzCxuNORRlDdaCernmv0OVXEnLXjLs/ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L1Cpn42e; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L1Cpn42e"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-38d489b6b71so305084a91.0
        for <linux-crypto@vger.kernel.org>; Sat, 08 Aug 2026 01:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786178861; x=1786783661; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TPmyBqI4sq6YMQPDv/UOXNOpQTMSjsFXQkKHa57g31Y=;
        b=L1Cpn42eGh1u5MrcYOy0DzFysUzSm5sA0P1xjg0V/u7Qr9oujJcg1DCBL65f9d8U3k
         GVuKm7sxTjuibLR+bViQx0hr3DJvGSh4i7Qvasyve9ygT7K0u5HO6SZzxIqnSKRsP9tT
         lvuaAiQmGUL0ZtJkOBuJHsoSaZPgQ0zXCA5IuUm8zWt1eSgsDqGAtxWUTTcOX+XcmhlL
         Iustxt2PQZnWUx12hWl+DxJMmS2JQ9rvHOUguF0PiyZgTLGyIIa4s9tzuGJySTgMUJ7B
         FYrZvuzXS0inPBUW+ivnjKYVcsU8s0Ls+tnMmj5Bz79DLpbivf8uu6V/+fVXEHETAjJ1
         NuTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786178861; x=1786783661;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TPmyBqI4sq6YMQPDv/UOXNOpQTMSjsFXQkKHa57g31Y=;
        b=graHJsHVZnX+gNtJbSzvkC/p6yPMNYcMZ6KRG9zTjYF2Ab9re4FcOW4p+nxnno8qIr
         Z9jcLy03llD2chlbyQFqb3xpWki3YleCbBi/x6eOcPTUbYAKwQWFrPm8o4PJSd7jIj4n
         UuU05Qv0tjZwiQwEq1rwvWRlxvjbDOVL7+ENCMY/QKRt41Mbcf5i1VOOyxM0guvktVyR
         mB23zk1dGn0zPj8C7TU50OF4kg5ZPiIveoISPLyp4tUp64IKq2V+ESfSdyRE2GTDesGj
         vdvvSb6KxJorG3oS/siO1cop97myrJjYWxLI0kTKEfaW7Kj/G2RgB6Y5VyobVdOr7mcT
         s2Rw==
X-Forwarded-Encrypted: i=1; AHgh+RptFbUGxWR3SXAjrgs8lDjtO2iSMNhugB6NQb64p7siYSKf/l5kfBzIlRngZEEMaMFWpC4DoC1V9JRgmKM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiGg/4515UkOR3ER+pP2A6kBfTbBxTZBa0j8zGAR5g6qQ7V+6K
	a2+EnzUfeQRCiNTVRc/EC6KSYRRBt3H8pzfHm3yQ7ydLyl7GwKW0nyAbgb3TNOwHnng=
X-Gm-Gg: AR+sD10oySF20Taqb4+xCIQE4cK1UqRMi5yOAAQZYwYRzzaxmn4zxwmZYAMlMmivtY2
	dy5SE6a9Rh4pMdcW3xppvGgKp1829FwhJvrednz0m0LYnLdHL1qCKQuVOEpQxQlxd4LsHQz1F+4
	A0AV4h3I1wLLciFURXgIsfIoFmCUdkLNTITwOjZX/wW2sc4DB5wFJgC+vgyc+XBBbza9RJKZeCW
	zS0gC54Yp8k3c//uFR//k1IUOTWoBwIr0+RTQPpoRWu93nUrVlOULyIqeoTJQHFnp8h5OJaQXAT
	vRH9soY8WEy+0XKT+sUvLD9kLUnH26MWeP9EAshCvLUkiLRFQj7cFcs6KmFsXwVyY4taGxDkGya
	g5G+gjOc1wGNrnSSrPHZ7TPXE4XXFpRD50BPArWhpt1POl++ET0ELnEkSSXRpKxbZv77G3LlxGM
	avljhyrCs7clLGJOqaNQANx9qr0i3FEu3LzCdK1ExowoYZqocoQ3V0aA==
X-Received: by 2002:a17:90b:4f91:b0:37c:6910:5758 with SMTP id 98e67ed59e1d1-3903c542f55mr23925788a91.1.1786178860876;
        Sat, 08 Aug 2026 01:47:40 -0700 (PDT)
Received: from lgs.. ([2001:250:5800:1000::f280])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39085f2b2fdsm8109997a91.12.2026.08.08.01.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 01:47:40 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Tero Kristo <t-kristo@ti.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: omap-des: fix autosuspend cleanup during teardown
Date: Sat,  8 Aug 2026 16:42:12 +0800
Message-ID: <20260808084212.2704516-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

omap_des_probe() calls pm_runtime_use_autosuspend(), but neither the
probe failure path nor omap_des_remove() calls the matching
pm_runtime_dont_use_autosuspend() before disabling runtime PM.

If the autosuspend delay is set to a negative value while autosuspend
is enabled, the runtime PM core increments usage_count to prevent
runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
during teardown, this reference is not dropped and usage_count remains
unbalanced.

Add the missing pm_runtime_dont_use_autosuspend() calls to both the
probe failure and remove paths before disabling runtime PM.

This issue was found by manual code inspection.

Fixes: 418f2a8cf2eb ("crypto: omap-des - use runtime_pm autosuspend for clock handling")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/crypto/omap-des.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index dfaf831dd8ec..73425c06597a 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -1066,6 +1066,7 @@ static int omap_des_probe(struct platform_device *pdev)
 err_irq:
 	cancel_work_sync(&dd->done_task);
 err_get:
+	pm_runtime_dont_use_autosuspend(dev);
 	pm_runtime_disable(dev);
 err_res:
 	dd = NULL;
@@ -1086,6 +1087,7 @@ static void omap_des_remove(struct platform_device *pdev)
 
 	cancel_work_sync(&dd->done_task);
 	omap_des_dma_cleanup(dd);
+	pm_runtime_dont_use_autosuspend(dd->dev);
 	pm_runtime_disable(dd->dev);
 }
 
-- 
2.43.0

