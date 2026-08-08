Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4240830E0F2
	for <linux-crypto@vger.kernel.org>; Sat,  8 Aug 2026 08:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786179576; cv=none; b=aYPDYhSB9waRl1ISRAagqKon23uxAeYgIWvEGQV8xF0Oe235ueqyGX9et+BFYzd/nsSUI8pyMuE2oTcwPLzPE5jy/2qM8XFm9TrAtPU9yOJDB39P8/zt2+eMyF7j1tYiXqnpkhlYaR/lnRKsY2Zi5UeZ6nxZnJg5kcpjVZpdVqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786179576; c=relaxed/simple;
	bh=k1jte4S6kmlNkWiF/TPSrh2PJp0JqoJa7csBL3XZxhw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FYs87s8uvKd8/Oz0qHQ4BDBFVcwoCbAlgXMFfcssuF828ewhaFXQnYmuJQBgEGPQ6UxoCEFkgwN2IrdoLotmu8CBLvnwTUZgyeDLgfrnv6rbCpGaQjD51xHWB2gl+zYFiqVfo1WvUtE/miWZ7V5LiEtW9KE2yWCAEvMJT3aeyf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wrg8I+gV; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wrg8I+gV"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ced3386430so4421225ad.1
        for <linux-crypto@vger.kernel.org>; Sat, 08 Aug 2026 01:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786179574; x=1786784374; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=n/y7c/4lG8eevhNAw7vtPbWQQOLv7HTFTCbAr3jVwm4=;
        b=Wrg8I+gVL904edaMJxaKH+QL32pIWXbPwVMQNuYbQAVrI+fUEMsA7YjnudjQpfuWBu
         xvu3zpDZd0AY5HlP1KXvNloa0/e7Onod+QBQNTRIABUdA720QyRkHn0W6E3H7Uqmo55O
         gIsekM4GFMWJpig09+r1EvrmrOcD2ecqp/Qc2nx/CX2bmYM9Z4YK6gjkp2odap6Waq+9
         LaGckMALUOXNwRpFWF6TfDwzi0MqNmRSEpkoWUM03uYrXOcfoB++TOROWNKpArP6Wx32
         DafC1DNBSbO+AgX5VrZWoGtE5MMTjZKsXqS0zEtPVkrFi06DxNS2LU8R2/yQ0vlOc/x4
         oYPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786179574; x=1786784374;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n/y7c/4lG8eevhNAw7vtPbWQQOLv7HTFTCbAr3jVwm4=;
        b=iTwaXQpuHG4VZobPkIoVaP/63Qag8grufa27FzPH3CGff4ShDMwVmmU6IJRvN6cLo1
         6iYv/o/5juLWEEciya/PL8hrzZ8ced90BjWvxkINYeishpuFpGMDURx0L0XvLFPvpqXS
         JABaYEhyZ+oKPAWABEnZT6/0y3cD7Wdx9gBglUeWQfflWoOkWsPl+b7KeFU/UEULJLJ3
         UCfdeOF8yOGuJO+3A9J7A0oYj8dmYZulythAozO98O3T6ukdfiON1nznMj3GKYo/KB0P
         fnos9Xb+MSOflsH4AP1xXLGAU5N917E27BCKp6HVyuztKdKozsV9Fk9gfT9DfsoQFBAe
         GlDw==
X-Forwarded-Encrypted: i=1; AHgh+RqnT2fSCqXorweDuZZEMZ19BKPru84QjYILnXao2NHedPDua3ep0abjy6SxTnRkvmEeSD7rmAlW5DQ4qVk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzz5aGOJfKUCAou5MEY0TIffs53miiJmK7zf4QpLgyCm6sMyc3i
	iUMRcKagFaoFOtDHqHskhvlDzK8zCGjqiFoDVNviLkjLBA4uT1jpOSjh
X-Gm-Gg: AR+sD10aCsaS/EybRR05U2Y1gmzEwSt3TvVRLpt9+6f5boeZF6tX3cM+YAC8G+P/O/o
	Z04LdDfoSUnHM0ndxKoVIziipV5hHlNa/l53UN9egmX7cDN7XLvNd+iTLOvwNT9KdzcNKbRlauv
	zhnuP5uDyx+P/SBOTCh25Nur0kxUIk4Apf+eAa5s0x9+qv0lH/AD+uH8yzeZCKcd9vClVQy3mz4
	zkFO87leQa0A1xCy5Rp85DS+aEz+DEK4BJHqKxOhS43SPJ3uCaVjAIs81MJi/ArIGnhCKaMKU4N
	4vEexCxZKPopFA7Rx2CkPFKHjawfXTsMvUlXIaglmuPT8C9/1ZMNAN+hZbnAcn0p3sKpDPDtnmS
	OZTvHBJ2BtAUX+5+j7fcfRUco668EAlARYcvTwjtLyF09LNJ42kXzGuzmI0w8z/a6FboEr/s4h5
	jSFVrSIhf606EbOQXM03faVyC7/7Ic7z7hjRZ7HGM/JBg=
X-Received: by 2002:a17:903:37cd:b0:2ca:d9b3:715e with SMTP id d9443c01a7336-2d294b4b5b1mr126407935ad.9.1786179574331;
        Sat, 08 Aug 2026 01:59:34 -0700 (PDT)
Received: from lgs.. ([2001:250:5800:1000::f280])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d16c4a6db2sm17431155ad.64.2026.08.08.01.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 01:59:33 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Corentin Labbe <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Chen-Yu Tsai <wens@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Maxime Ripard <mripard@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH] crypto: sun4i-ss: fix autosuspend cleanup during teardown
Date: Sat,  8 Aug 2026 16:53:37 +0800
Message-ID: <20260808085337.2715506-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sun4i_ss_pm_init() calls pm_runtime_use_autosuspend(), but the
autosuspend setting is not undone if pm_runtime_set_suspended() fails
or when runtime PM is later torn down by sun4i_ss_pm_exit().

If the autosuspend delay is set to a negative value while autosuspend
is enabled, the runtime PM core increments usage_count to prevent
runtime suspend. Without calling pm_runtime_dont_use_autosuspend()
during cleanup, this reference is not dropped and usage_count remains
unbalanced.

Undo the autosuspend setting when pm_runtime_set_suspended() fails and
in sun4i_ss_pm_exit() before disabling runtime PM.

This issue was found by manual code inspection.

Fixes: 554c42b4efd4 ("crypto: sun4i-ss - enable pm_runtime")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
index 35ef0930e77f..10c0f05994ed 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
@@ -304,14 +304,17 @@ static int sun4i_ss_pm_init(struct sun4i_ss_ctx *ss)
 	pm_runtime_set_autosuspend_delay(ss->dev, 2000);
 
 	err = pm_runtime_set_suspended(ss->dev);
-	if (err)
+	if (err) {
+		pm_runtime_dont_use_autosuspend(ss->dev);
 		return err;
+	}
 	pm_runtime_enable(ss->dev);
 	return err;
 }
 
 static void sun4i_ss_pm_exit(struct sun4i_ss_ctx *ss)
 {
+	pm_runtime_dont_use_autosuspend(ss->dev);
 	pm_runtime_disable(ss->dev);
 }
 
-- 
2.43.0

