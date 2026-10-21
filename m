Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792584937;
	b=PKIKpcF2frtEik2gyxIP5UB8eLY+PCbyGznTmb9eFopgw6ZsJkTAlPBo0OXC1R+BtYh/
	 1bIWgk71dPRYZ4MdeuYTOv7Uo8B2UT61yZfMBVvp1hqNJ0hcvWHiDPZOu7N3xoXPo3wSI
	 wIitPuK/+ymUmbD0KpY5PF854eWiyuhkWI25NGBpcEKyg7FVuHKYOasHG/v+EsxDD//g1
	 twnCx1nhDANIUu7HgcWMVwtYZ/B8nYCtIFcc9TS41t2HohhbRlTrv+d2XOM1N4oq+FvBk
	 F7qKv9L9CxhN1EaAGKm0iESibCU/HQhGJg1obzvV5eWm9W8t9UsXfNE2Eu3uzcoFKFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792584937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=93EmsKWixLB2KPvdZzjAuggREVPcs9WaZPMfQhaLIaQ=;
	b=J0Yv2LZTgaKyjTlOZ4TOuCMImgfmW8G4wuhNBmMjlOo0Tp0/VVKTjlPfYvZf6EX8TIkM
	 z2MXUyc8Ebb9RVtbFSeRfP/1EQCCo4dLXQkydSflV5RF3wX1s4i9wZ75HGiUK8yrOxE5f
	 sZLFNT7U253kNL6BqKgt49oGDVNi7WsADcNJ6ITf3eLcXKqf+0dl9WDpy87naghMOT0Bn
	 5cQtlLRJnKInY9AdKVM2ET5mPZizWlzD5+pplaL0L7/BaQm3K2EkYfgdt6yVnWFs5EDAO
	 zFPOH2hv6fIHZFiIqnBIFVUjZBgnC+CPZI8+JsjbIb+ga5KtEevJV3vnQoUacxPkOtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kBFEDZcV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1786B60A380F;
	Wed, 21 Oct 2026 12:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kBFEDZcV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9701F000C7;
	Wed, 21 Oct 2026 12:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792584936;
	bh=93EmsKWixLB2KPvdZzjAuggREVPcs9WaZPMfQhaLIaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kBFEDZcVNrUWoOv05Hh2muxrzI0wXFCWU3ib4MutRAuaBlzINyFIAYYv7obYpf6M+
	 xnzDbGUYFVty7jUsQPsXZtI3tLGZYmdt6Lx8Ayjx8ZzPvq0zHDkuRj8ar58OxyohN0
	 J0qu2d1IVzLjHP3MT3pvXkoC0mrbpraDwIPEJ6CwyEfc11FgJNdPN6qFw4VpuFMJ51
	 qfQXs9T586El0sN7Nn5LokrmwnQ7Uq1BwtOrET/UnA1nkv7zQcGyrNMXsHZ48W+0Fv
	 aQRWDaJHwCmrxa0H37nSzSSl8kMOA81tNu/eUBTQoq9wz5dzaV66CYPlMRqO1tzbPn
	 mf0Co8jz2skJg==
From: Lee Jones <lee@kernel.org>
To: lee@kernel.org,
	Qunqin Zhao <zhaoqunqin@loongson.cn>,
	Yinggang Gu <guyinggang@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	linux-crypto@vger.kernel.org,
	mfd@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH 16/28] mfd: loongson-se: Zero-initialise controller command structures
Date: Wed, 21 Oct 2026 12:09:38 +0000
Message-ID: <20261021121245.3111563-16-lee@kernel.org>
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
2.56.0.218.g1ec904b173-goog

