Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793097473;
	b=CW+sK6AebypNzd1Z8RRLUhKP7nt/hfLsfh5nRwm6xQx7WwT6KuLLJQVosxCBoJjHgMJ8
	 ehZNMZ3q3Dq51NqQ2ndqM0RiY/FuTKx7Mt68tEujML7H2MSBE2nlTEHzYyULVaq32CSJI
	 N7A+Y+9KAiJDsQxfEIdii/aApU3J+8/kWhtTwAqZyhI8h0lkKI7dnPs5vLn7yI1kmNUxP
	 +d438XzFbledRcByQ/sKXyA7zDEz848xpGgytRvdokC1wNRYX/xq7BKJSL2TU4MofU1cp
	 Q5gMpM5bUcYz213Nfh7TqUkvhaAJDGcsSEkpgzibXG7lFvT1bQHB4jKhcjgGeO3eFMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793097473;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=gzsgjU/xMTz8ToPcfVScc+tYunBSCQb6/g+6snOG+FM=;
	b=x8J9+Bvvv/QCjs45/65em4un19i/Ovs1GaY4A3eAR701gSVJGoWSl3W9x9r9EV53n9tP
	 7NBEkFxfelTCbUVzzoStoAFFB939YxejeSv++2lHahfC28qiSdHqMDmAJvbcMvZ+SSV/a
	 NGVJxQAxDpKXzJ/DG5AjlYFaCJAJl6SghrpkNQWIRj7uqX2Wj8CFUGRZGTSVD2EL0cZCH
	 n6YbkJRedxORX/dfkCK4hvivcmVzCm8tdx/GHdKfhxmD0Cdlv0nZzSVVtHIqvQEQrrZ2C
	 t1IbZAPvDJCc+K8ciMvpdbzCC+7x0lQcu4uhYSP9A0yM6Sk+5X/HU+7jKJw9sdZBZjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EPuR3dEF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0487C606A325;
	Tue, 27 Oct 2026 10:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EPuR3dEF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA2C1F01825;
	Tue, 27 Oct 2026 10:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793097472;
	bh=gzsgjU/xMTz8ToPcfVScc+tYunBSCQb6/g+6snOG+FM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EPuR3dEFM9c6au0MRvhNcySX3zY/M/wNXPmH24kacID3+2XRLS1AoMm/exCp7uYO+
	 gMLjsgyAp8ShkGRNplOnjXMmNxcv6YM3yT0heHATM28smQRVsFEngIjK9H4eYMZh8v
	 vZgQ2tAsuATWKtN5lvms+pn3sA9rADlZKhHzYxx+Ar8+M5g6hv+M0RKygJJHao+XLo
	 kWaXVS1N4q+4iCVi+OQmKVTPrdgGFgK8dSIUIfy9jCu+DNEFv8ipigE3Gak2pAowif
	 6Xp+Jx31ERjHZBLcAHiaGKFhWVBXFbuq+8gbp5BFEb8LSC8rDVeTTcN8OR1w87qmUt
	 rx2ZuyABvD7Uw==
From: Lee Jones <lee@kernel.org>
To: lee@kernel.org,
	Qunqin Zhao <zhaoqunqin@loongson.cn>,
	Yinggang Gu <guyinggang@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	linux-crypto@vger.kernel.org,
	mfd@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH v2 17/27] mfd: loongson-se: Zero-allocate driver data and initialise engine completions in probe
Date: Tue, 27 Oct 2026 09:30:46 +0000
Message-ID: <20261027093306.2812695-18-lee@kernel.org>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
In-Reply-To: <20261027093306.2812695-1-lee@kernel.org>
References: <20261027093306.2812695-1-lee@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

loongson_se_probe() allocates struct loongson_se using devm_kmalloc(),
leaving the se->engines array uninitialised until child MFD drivers
later invoke loongson_se_init_engine().  Meanwhile, hardware interrupts
are unmasked and se_irq_handler() is registered during probe.  Any
engine interrupt arriving before loongson_se_init_engine() runs causes
se_irq_handler() to call complete() on an uninitialised completion
structure.

Allocate struct loongson_se with devm_kzalloc() and initialise all
engine completion structures in loongson_se_probe() before registering
interrupt handlers.

Fixes: e551fa3159e3 ("mfd: Add support for Loongson Security Engine chip controller")
Closes: https://sashiko.dev/#/bug/linux-ad9310d7-13b2-4a4a-ad7d-78a4c612c78c
Cc: stable@vger.kernel.org
Reviewed-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
Signed-off-by: Lee Jones <lee@kernel.org>
---
 drivers/mfd/loongson-se.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
index 9b531e62fb85..187ebbed0422 100644
--- a/drivers/mfd/loongson-se.c
+++ b/drivers/mfd/loongson-se.c
@@ -106,7 +106,6 @@ struct loongson_se_engine *loongson_se_init_engine(struct device *dev, int id)
 
 	engine->se = se;
 	engine->id = id;
-	init_completion(&engine->completion);
 
 	/* Divide DMA memory equally among all engines */
 	engine->buffer_size = se->dmam_size / SE_ENGINE_MAX;
@@ -199,12 +198,14 @@ static int loongson_se_probe(struct platform_device *pdev)
 	int nr_irq, irq, err, i;
 	dma_addr_t paddr;
 
-	se = devm_kmalloc(dev, sizeof(*se), GFP_KERNEL);
+	se = devm_kzalloc(dev, sizeof(*se), GFP_KERNEL);
 	if (!se)
 		return -ENOMEM;
 
 	dev_set_drvdata(dev, se);
 	init_completion(&se->cmd_completion);
+	for (i = 0; i < SE_ENGINE_MAX; i++)
+		init_completion(&se->engines[i].completion);
 	spin_lock_init(&se->dev_lock);
 	mutex_init(&se->engine_init_lock);
 
-- 
2.56.0.307.g5fe7bd680c-goog

