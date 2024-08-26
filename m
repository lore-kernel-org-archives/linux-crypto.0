Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8419130ADA
	for <linux-crypto@vger.kernel.org>; Mon, 26 Aug 2024 07:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724656507; cv=none; b=ThWfZy5xQQTnvZxuzkdB9qhXB2vEqarOSIh6jdizNib9niP9zhiZkSCo7v/KNzEJoW4dQ1UHbJvz98QovesmlRGM35HOQOVM/T21HJxu5kjnXk5XHwZamYXdwvSyqSRTKWxgu5S/NJ0tzaRYtHzjks5Fn6hs612R3HVnlE4zM9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724656507; c=relaxed/simple;
	bh=qDAxbfStrZE1C7xsT/1dyQQQA12Bx8WVEzo2heqH498=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=F5GaHcBafPgS781XOC6quAJ/feqLSJabxKcAszMemRvCDzkzOmhCWI5uZKRRJGiwEr13dGgEkP+4X1QGy90DiStlq4VmLcSZPct3hj7hOTqKUKiuVodbWoigbX6zIT38mRF7ZY+gpPL9Af2e377WIrzgIbnhk0bh6+rZSe5A34o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=Z2el6X1/; arc=none smtp.client-ip=185.125.188.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="Z2el6X1/"
Received: from laptop.lan (unknown [125.33.218.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 47BB040958;
	Mon, 26 Aug 2024 07:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1724655870;
	bh=gAlDnV00OTi8pOFAQvJJe9at6x6rDLA71GGMr4eI9rs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
	b=Z2el6X1/fY1wc1fFsRSyoIlp9qBErm9kXKZcrvzLG1pKHpREBYrra2to49U9iOGCm
	 DoXWADbBeiI7bnjF8kYJHT2alR9G1hl2aGpyiFCaUDr7ajeAKie80HqWpmg0jRm+zM
	 xKALjg+angNL+TtQSJ4FniiQV1fj6OEOy+12j2Zjgg3/q4fn1QEHAoZEn9R9YXFjeE
	 k3gy0nef3E21WHgyvq2d6DYSYM99NE4PEjW369wsO72rb71dq8q7x3nBqpBxZday8v
	 UWpqgYNF0OHAepgvPkc26dcNl9TOQmmhTx/y9jdsh6nBYlVbUiSvRYQ2HE5TvnDcin
	 ju4H2czWLnD/A==
From: Guoqing Jiang <guoqing.jiang@canonical.com>
To: sean.wang@mediatek.com,
	olivia@selenic.com,
	herbert@gondor.apana.org.au,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH] hwrng: mtk - Use devm_pm_runtime_enable
Date: Mon, 26 Aug 2024 15:04:15 +0800
Message-Id: <20240826070415.12425-1-guoqing.jiang@canonical.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace pm_runtime_enable with the devres-enabled version which
can trigger pm_runtime_disable.

Otherwise, the below appears during reload driver.

mtk_rng 1020f000.rng: Unbalanced pm_runtime_enable!

Suggested-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Guoqing Jiang <guoqing.jiang@canonical.com>
---
 drivers/char/hw_random/mtk-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/mtk-rng.c b/drivers/char/hw_random/mtk-rng.c
index aa993753ab12..1e3048f2bb38 100644
--- a/drivers/char/hw_random/mtk-rng.c
+++ b/drivers/char/hw_random/mtk-rng.c
@@ -142,7 +142,7 @@ static int mtk_rng_probe(struct platform_device *pdev)
 	dev_set_drvdata(&pdev->dev, priv);
 	pm_runtime_set_autosuspend_delay(&pdev->dev, RNG_AUTOSUSPEND_TIMEOUT);
 	pm_runtime_use_autosuspend(&pdev->dev);
-	pm_runtime_enable(&pdev->dev);
+	devm_pm_runtime_enable(&pdev->dev);
 
 	dev_info(&pdev->dev, "registered RNG driver\n");
 
-- 
2.34.1

