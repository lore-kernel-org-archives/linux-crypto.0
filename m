Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792584949;
	b=d50RvgqjUhnPHfaUXKi04aauq8TLvM0MIpHd2VhCKxH137DnHd/o6hGb9WbEq4+Rf2hv
	 45Hy0qy16SyOtgEg6Hq607EEjCCehi4H3ITKYBs1Ww0dlOkGWi8WnnOHE8YsGIEqwwEsQ
	 cBIyLoItSHyuV5C6+SPTtHUuqaJt5piVsk56giTNeZq42mvbRlOo2vhYW7dBPgKIfZFsY
	 98ZEZnVKZv95Vdm5s0/DTnsk8Fe+dZp3ekTXB6CTjBt24xhZUpATFjc9C+eTqdjuMjnbm
	 XgUTEYYpYBKMfGpJMc/fu6mE1RoMWWdsVlSnZ2PRy4I57LB+MZ3o7dxlgGsEGQ/UxNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792584949;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Yk6e5XTViNQOurdZ8i+/SXoCSxLwXqIfJlS6q/37ezI=;
	b=ey+O4TgU1UjPNekLl+Tz6N/tFGtvzGoWb3v9ZmqGXg2Jop8OkBTCgV1YyKvCrrDfZ95s
	 OMg5eISt6VrdCxLEaLPPaJ+OKTGBFKfj2EyG7Xh8Wm7LFvNgF8BpiZRy1C9Di4GoLFz5n
	 +6SSpNvXCkKB4JmRxOlCptjt76OTHGt+A/C8nClfxQQv0873Omtp8IalQnzaIVFJ7qrTJ
	 mEluE69unHyXdf9AKNwzHgBkxOXjWzMjrTNgebbVoSZITINIV2gizXm4T0bhZ6OKQ9bH6
	 6CoadkMO9RQEfrG47kRaikP8oSql45LpLmMdz8HyEBmVQ81eEbit0F0J2mMbGep5/Rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hyNHFMn9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19A360A6F46;
	Wed, 21 Oct 2026 12:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hyNHFMn9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECC11F000C9;
	Wed, 21 Oct 2026 12:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792584948;
	bh=Yk6e5XTViNQOurdZ8i+/SXoCSxLwXqIfJlS6q/37ezI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hyNHFMn96pBjLiFJLlYkVu+pPC3Tx0Ok+cfP8xytJAnACfGlEBStltjNuiMp1jJ0y
	 a/TST1DZDffSiUVUgOas+GUdQVU5wpey4Z5LNFv+1/nD7nmQkMwfaEQCOnYJlz/fMf
	 wTdwGFeRgCc2L/9DeYAjCTZBOaKLhv+mnycLncyRo6Pf7KEflXMWqXJOoFvC0OeoZ5
	 6TFaWKW7zAX6lLiVsb4PKbwVBBsW7v9t5gOIvQr7Fca0bG8aiSzcS9ze7s0mLqVS3y
	 uxjbPSOSmSEncn8Oongn8tLkcQN22IEl48BnZS6YZNnHJnd8ZThZJzBirjhcAeB8gg
	 zJMAASn2EkyYQ==
From: Lee Jones <lee@kernel.org>
To: lee@kernel.org,
	Qunqin Zhao <zhaoqunqin@loongson.cn>,
	Yinggang Gu <guyinggang@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	linux-crypto@vger.kernel.org,
	mfd@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH 18/28] mfd: loongson-se: Zero-allocate driver data and initialise engine completions in probe
Date: Wed, 21 Oct 2026 12:09:40 +0000
Message-ID: <20261021121245.3111563-18-lee@kernel.org>
X-Mailer: git-send-email 2.56.0.218.g1ec904b173-goog
In-Reply-To: <20261021121245.3111563-1-lee@kernel.org>
References: <20261021121245.3111563-1-lee@kernel.org>
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
2.56.0.218.g1ec904b173-goog

