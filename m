Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873D21E32AE
	for <linux-crypto@vger.kernel.org>; Thu, 24 Oct 2024 16:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.62.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729787510; cv=none; b=t80YF0PiWQq0Geot+C6EIbIAYGHDzVqv4gcCaJezNePlVqhSijt85HxPwW/E/NDJoXDpsElYrKcjsshhdlptRUl2N9VFncMf4oTGA1a3HUkDVFmDBCzKmkTTWs5Ml0p5U/vH2pa8h728O0NoXXm2AGzadiajh04pdXKtrcgLhEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729787510; c=relaxed/simple;
	bh=nO3ERuTEU0118RKUrpTGZ8JICg14sxlUIj9uF/rDHwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m09g7Kvd8KZCral47j5am2mmuae+Q7GCZ/bfEzVjeyOk/EdOHbuDyEeKg330s5PkTvK4NduBxMky1jGFW6QwiK8ErnN8OHDlRX0g1W1f6oZKnyu37WgDRAOIkKlOOMu86mDw2USWYgIPhyBbwiBgsTuSpHwWsMV5Jtkd8JPX6gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=REy65Q/F; arc=none smtp.client-ip=85.214.62.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="REy65Q/F"
Received: from tr.lan (ip-86-49-120-218.bb.vodafone.cz [86.49.120.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 778F788F83;
	Thu, 24 Oct 2024 18:31:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1729787500;
	bh=Rsh4v6/PeIHtySykJlhUm80gJ6K4ieESJR6idPtAPCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=REy65Q/F1gvwiJpjztNedWHIiC8K+PJKQshLGDT6deiy62R/3kOE/x7q3ekYjzeSr
	 h7vUBKIwdjSad4stIiqnCG9PsXdKFV67OlddeeSH6w0LB0YSOYPe+bMELr+HDoDXwB
	 eJbBkT8zHCaxl2y2wh3T6tNZeXMHGPPw5KrLXr1Ygy0N6v38a9SuC9z0WWxSgYyX5T
	 ql5sE7DK11Aezu7IU2bXJL/AiYkMU3m5NoHu48GFauPV83W0jk00LboGnDglvEpDDn
	 SxyX4qE8q9zrSsCfE109Ir5CZoPA/nLReIPRd/qWy6gFC+Mr4+bGIvDoHFlwTjPXh1
	 qksjl/iyWrkfQ==
From: Marek Vasut <marex@denx.de>
To: linux-crypto@vger.kernel.org
Cc: Marek Vasut <marex@denx.de>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Li Zhijian <lizhijian@fujitsu.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Olivia Mackall <olivia@selenic.com>
Subject: [PATCH 2/2] [RFC] hwrng: fix khwrng registration
Date: Thu, 24 Oct 2024 18:30:16 +0200
Message-ID: <20241024163121.246420-2-marex@denx.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241024163121.246420-1-marex@denx.de>
References: <20241024163121.246420-1-marex@denx.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean

If we have a register/unregister too fast, it can happen that the kthread
is not yet started when kthread_stop is called, and this seems to leave a
corrupted or uninitialized kthread struct. This is detected by the
WARN_ON at kernel/kthread.c:75 and later causes a page domain fault.

Wait for the kthread to start the same way as drivers/base/devtmpfs.c
does wait for kdevtmpfs thread to start using setup_done completion.

Signed-off-by: Marek Vasut <marex@denx.de>
---
This is a follow-up on second part of V2 of work by Luca Dariz:
https://lore.kernel.org/all/AM6PR06MB5400DAFE0551F1D468B728FBAB889@AM6PR06MB5400.eurprd06.prod.outlook.com/
---
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Harald Freudenberger <freude@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Li Zhijian <lizhijian@fujitsu.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>
Cc: linux-crypto@vger.kernel.org
---
 drivers/char/hw_random/core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 5be26f4e9d975..bb1f4ba602b1d 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -55,6 +55,7 @@ MODULE_PARM_DESC(default_quality,
 static void drop_current_rng(void);
 static int hwrng_init(struct hwrng *rng);
 static int hwrng_fillfn(void *unused);
+static DECLARE_COMPLETION(setup_done);
 
 static inline int rng_get_data(struct hwrng *rng, u8 *buffer, size_t size,
 			       int wait);
@@ -472,6 +473,7 @@ static int hwrng_fillfn(void *unused)
 	size_t entropy, entropy_credit = 0; /* in 1/1024 of a bit */
 	long rc;
 
+	complete(&setup_done);
 	while (!kthread_should_stop()) {
 		unsigned short quality;
 		struct hwrng *rng;
@@ -669,13 +671,15 @@ static int __init hwrng_modinit(void)
 	if (ret)
 		goto err_miscdev;
 
-	hwrng_fill = kthread_create(hwrng_fillfn, NULL, "hwrng");
+	hwrng_fill = kthread_run(hwrng_fillfn, NULL, "hwrng");
 	if (IS_ERR(hwrng_fill)) {
 		ret = PTR_ERR(hwrng_fill);
 		pr_err("hwrng_fill thread creation failed (%d)\n", ret);
 		goto err_kthread;
 	}
 
+	wait_for_completion(&setup_done);
+
 	ret = kthread_park(hwrng_fill);
 	if (ret)
 		goto err_park;
-- 
2.45.2

