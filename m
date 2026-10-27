Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793097462;
	b=IaNjjNciuSdJJCUqaPxSsLhafYIzIjnRk6PBY+ik27floDY5DiPc4fgbjgqGuYnG/z3R
	 8ESZR5tK6y1MpDU19B7inRmddawPC4Il5tsUgHCGzLqJY0uGbFP3K5t3+aws9sU7cxeL6
	 lyBZ5ew+ZfzMEQ4Gq3xMUEGFA4lsDitx1jsNx8Ct9zlg/yqAKI0J5OhrKUx85wcTtPA9l
	 AZll9LAMiisN/PWhybC4kxo+jJqQWT7njLjX8bUOz854aWCsLmYIKgeTM/EYu1YJfpEzw
	 Ii1dYN5RWmHzy8BbTsAb2gxygkzNJwmepdlm5AbYd7qVOw1UAw16JcuSsZyJQiayoLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793097462;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=+mrEVkAgekbQpxca/ChRh+/oqCX+0L52EDhJet4h4ZA=;
	b=LklhTKon2wivikwaRM0nSdmG1u8u6Vuh9FYRtu84eJJ4NsRg7nC2ciiBZNzsNsFeAueC
	 4vh+mLgb9+lnziC2p8V9osbh2HXk8QFUbsfRVDdguksePEZ+3VyA8LYsCvymp7WGKWihU
	 mSi8xBPPqtm7CbaExNw+qqM3/diZ27/klykt/wYnT9KlwRKY6tGpFaxwnKD7XGHv5+l6u
	 FGxEqey7KH1K3q+QSH862raZhkybeQH5Itf9RpprDfUnU7LrPERsHkcR4IGuh7ylTcYXA
	 7T1tY7DKY6qvcI7qt4v/TVzbKZAVJdsYjCsyoLiVQf8iI2QsfKSlMPmmxDg8YBxqW/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bXawf0Og;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A49606A322;
	Tue, 27 Oct 2026 10:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bXawf0Og
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD521F01825;
	Tue, 27 Oct 2026 10:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793097461;
	bh=+mrEVkAgekbQpxca/ChRh+/oqCX+0L52EDhJet4h4ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bXawf0Og7N05yXLBApLiZ+lC8eRRfNvchKC8OPz7HwnHyhWwhz/HgC26u8pCGUAvk
	 9AmUchJezRxKfQsBu82gLXsQ0k5OijfVKu7jbDcCqC0g/Sx4mssbxNK8c3xDP0+FL/
	 NUUkACwktsovPYyx0rn+1d7TpM58l2kTIGguBa3EDlc+0XjL+eSpgiLXKCNSfLZgh7
	 CpGag/CF9cwaU805Hk10Ip4+BIpMDFGQWxxJ3oaWB6zCoHm3PYj8XNc/iTQE7Ox58w
	 Xol3n9fOUADMP0oPEwnkSzzBfDWYgUzVZJzResI50jf1oM4BL2ZoABJGDTj0rN5xjv
	 d2LvpcVV1N9cg==
From: Lee Jones <lee@kernel.org>
To: lee@kernel.org,
	Qunqin Zhao <zhaoqunqin@loongson.cn>,
	Yinggang Gu <guyinggang@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	linux-crypto@vger.kernel.org,
	mfd@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH v2 15/27] mfd: loongson-se: Zero-initialise controller command structures
Date: Tue, 27 Oct 2026 09:30:44 +0000
Message-ID: <20261027093306.2812695-16-lee@kernel.org>
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

loongson_se_init() and loongson_se_init_engine() declare struct
loongson_se_controller_cmd on the stack without zero-initialising it
and only populate a subset of its fields before
loongson_se_send_controller_cmd() writes all eight 32-bit words to the
controller MMIO registers.  Zero-initialise the stack command structures
so that unused words do not leak residual kernel stack contents to the
hardware.

Fixes: e551fa3159e3 ("mfd: Add support for Loongson Security Engine chip controller")
Closes: https://sashiko.dev/#/bug/linux-b81dca3d-6812-43b6-9ad9-912727674154
Cc: stable@vger.kernel.org
Reviewed-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
Signed-off-by: Lee Jones <lee@kernel.org>
---
 drivers/mfd/loongson-se.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
index 8dcb90a067b3..485ee4a6ca5e 100644
--- a/drivers/mfd/loongson-se.c
+++ b/drivers/mfd/loongson-se.c
@@ -93,7 +93,7 @@ struct loongson_se_engine *loongson_se_init_engine(struct device *dev, int id)
 {
 	struct loongson_se *se = dev_get_drvdata(dev);
 	struct loongson_se_engine *engine = &se->engines[id];
-	struct loongson_se_controller_cmd cmd;
+	struct loongson_se_controller_cmd cmd = {};
 
 	engine->se = se;
 	engine->id = id;
@@ -162,7 +162,7 @@ static irqreturn_t se_irq_handler(int irq, void *dev_id)
 
 static int loongson_se_init(struct loongson_se *se, dma_addr_t addr, int size)
 {
-	struct loongson_se_controller_cmd cmd;
+	struct loongson_se_controller_cmd cmd = {};
 	int err;
 
 	cmd.command_id = SE_CMD_START;
-- 
2.56.0.307.g5fe7bd680c-goog

