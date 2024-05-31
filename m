Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59A517550
	for <linux-crypto@vger.kernel.org>; Fri, 31 May 2024 08:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.62.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717145889; cv=none; b=onE7vUr4t7C1lRE93MV34MR13UaBpFwOlQWemmoed1VdeBFIY8CoBbCDlJKAVBPbmplrEDsgszB60FvDWEwWa4Y64y/vXciH/qMLRNPAjf81NGqndQ8y+njSHtgGlfHywkORXJODgGr5vZcFpPX5JNbxtS8mjpve7R1GHeUSe/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717145889; c=relaxed/simple;
	bh=B78LkLOgockLnbSmkw3Af+UmkNpFA0XXABsAcBQJIWw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EkrvLjO5af16ZMw3Cq25KptLst7PgFz5jx/zUlu9gAzWEPaGCzXIh9ewZhiTRmqpxMMch8N7f3UJIe6NfnikIyHhEssWVjBb0ruc5YEmV9CTCHriGbPh9qEuHJlvmsGb84n1+zqL1M6j9Ak0HUL1u4uNs+6c5ZIu7WTqJp4IZ2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=futErEBw; arc=none smtp.client-ip=85.214.62.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="futErEBw"
Received: from tr.lan (ip-86-49-120-218.bb.vodafone.cz [86.49.120.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 756E8882FA;
	Fri, 31 May 2024 10:58:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1717145885;
	bh=QljEamaz3mSONFWT5Op6k1tNyxsfUAuFoqWpRnE3RAM=;
	h=From:To:Cc:Subject:Date:From;
	b=futErEBwCEFrIu33jjPiuMmEdy45pTX8qBNZNjZ9DqVXqIptDnmZqs+MHdBMH+UJm
	 RGcLl22AeH8xM9mHTEHubK0YaEZkGjjgydJ2h4MHT9gDuWtvlEZxD4CUZsNY2sDm3/
	 YAucjgDgz6M9iO+4Ea86VZvxmaXR0ecdiipyXyM8fqVIJIYWTQFtRfOApWzsOor9hi
	 8NcQiSjZsFA/nX+N4Ay+9Ju7u/zsEZ4mQz3fCUBrLoDDkJXy+0IjtKD9BtRUYYLkXR
	 BCTW1+oXdrU3el9psMiAHoYInsmRSqx6pYWPdC/FDxuP3jU4CS2spp1chirJGCTxtK
	 q38BTBvDexP3Q==
From: Marek Vasut <marex@denx.de>
To: linux-crypto@vger.kernel.org
Cc: Marek Vasut <marex@denx.de>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Gatien Chevallier <gatien.chevallier@foss.st.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Olivia Mackall <olivia@selenic.com>,
	Rob Herring <robh@kernel.org>,
	Yang Yingliang <yangyingliang@huawei.com>,
	kernel@dh-electronics.com,
	linux-arm-kernel@lists.infradead.org,
	linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH] hwrng: stm32 - use sizeof(*priv) instead of sizeof(struct stm32_rng_private)
Date: Fri, 31 May 2024 10:57:34 +0200
Message-ID: <20240531085749.42863-1-marex@denx.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean

Use sizeof(*priv) instead of sizeof(struct stm32_rng_private), the
former makes renaming of struct stm32_rng_private easier if necessary,
as it removes one site where such rename has to happen. No functional
change.

Signed-off-by: Marek Vasut <marex@denx.de>
---
Cc: "Uwe Kleine-König" <u.kleine-koenig@pengutronix.de>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Gatien Chevallier <gatien.chevallier@foss.st.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Marek Vasut <marex@denx.de>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Olivia Mackall <olivia@selenic.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Cc: kernel@dh-electronics.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
---
 drivers/char/hw_random/stm32-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/stm32-rng.c b/drivers/char/hw_random/stm32-rng.c
index d08c870eb8d1f..9d041a67c295a 100644
--- a/drivers/char/hw_random/stm32-rng.c
+++ b/drivers/char/hw_random/stm32-rng.c
@@ -517,7 +517,7 @@ static int stm32_rng_probe(struct platform_device *ofdev)
 	struct stm32_rng_private *priv;
 	struct resource *res;
 
-	priv = devm_kzalloc(dev, sizeof(struct stm32_rng_private), GFP_KERNEL);
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
-- 
2.43.0

