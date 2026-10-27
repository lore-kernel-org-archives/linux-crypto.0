Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793097482;
	b=gJOJNjgLhvppGkOguc7tGnWhI8qKnBIzBCGM6FX89hVXg4FW2YrXonUi2PKFwrtdio3o
	 rbUGdrbXJKgEfkYhOBa7tcmTh3XLP/LaCb3X54tG3O8A5sa/hAzBlotQyY2zdRriAvlTD
	 ABNE9v2xGN5nlzzMxsLF83XmUHxgD97P1p7NteWTSpdOSwssy+Nbb7y8Sr0KWqe+fJhWs
	 7512mHjjSPj6H4KPEbEbFPnH0bcaFDfCZnWg2hYq8Yyo/Yv2Cc5JthrhrFDpV9mvChdKV
	 sSWm7lsbiQ5eV+H2oz5rBIkIvJ2VwtXTIb6Ri68rsR0vThxgKaokEfFkV+Am+MCG0Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793097482;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=i118X57VQLBcZZyXtQ2xwoBySl67TE23jZgcwtlPfoc=;
	b=FjrWYH/6+b6Ypfq5LJuQz8X9KHTX0pkSzMCWe8FjtjpY01ohj+tPaPhBr8mlNWrozgHT
	 Al/EvCseVD/1WWr+RcHBALFEc2nl2wnbFJem7ZoNfH5QbU6aPTfoehfAVMFgp2OoArLTI
	 qnuP0V69hE6rB8V8Qjqkqs2DlV/QQ9YmWPArfCPHW7WC0+b/N/BKmCWSnzv8pwz8z2H7K
	 XT8whGWlHnQw+1bUh+7ErKObbaVRJKor5cnjnQ5REDYXAO3FcGXjep/TqU/NYy6Bc2j51
	 7uWs1DuEoA6Ewq7gcWtKhHDNAhS2zr5xgjGwL/p/XWY3ejFWSMxQ5l8VCJRf4vIsOag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IjFYTPxY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F92C606A31A;
	Tue, 27 Oct 2026 10:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IjFYTPxY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CE81F01825;
	Tue, 27 Oct 2026 10:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793097482;
	bh=i118X57VQLBcZZyXtQ2xwoBySl67TE23jZgcwtlPfoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IjFYTPxYg1dhlWJUisOTs+EIqSyE1qDv5EXijvM1jfekzm7mQoDepfqFT0k/7sms6
	 8la8D1QdYEjybTUl8WjdM/XPLhrNUbSz3nw2oo65Xocyn2kiitlQ6ue+skpI2dwPLG
	 djOcyHofv6jvD4YjpPWRYZ/xNMUYazSW7pdiw7jMQwoow8MzgMs2wLiKVQq+AolDID
	 NBI4M5Oj4yosUOH/OusSfvAueLpgyZetxmCJMYTN8hZ7uJpKWTUbCOxu1Te1PxIiRe
	 xybq2PbOfCEC6KEgK7y/B806yj2M8TPcvWptBQzhCgt0QofyDhr9riXOLnB8UIHReQ
	 e0CmKmG07q5dQ==
From: Lee Jones <lee@kernel.org>
To: lee@kernel.org,
	Qunqin Zhao <zhaoqunqin@loongson.cn>,
	Yinggang Gu <guyinggang@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	linux-crypto@vger.kernel.org,
	mfd@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH v2 18/27] mfd: loongson-se: Prevent out-of-bounds engine access in se_irq_handler()
Date: Tue, 27 Oct 2026 09:30:47 +0000
Message-ID: <20261027093306.2812695-19-lee@kernel.org>
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

loongson_se_probe() enables all 32 interrupt bits via SE_INT_ALL
(0xffffffff), and se_irq_handler() uses the set bit index from the
32-bit status register directly to index se->engines, which only holds
SE_ENGINE_MAX (16) entries.  Any interrupt bit asserted at index 16 or
above triggers an out-of-bounds access on se->engines.

Restrict SE_INT_ALL to GENMASK(SE_ENGINE_MAX - 1, 0) and bounds-check
the bit index against SE_ENGINE_MAX before completing the engine in
se_irq_handler().

Fixes: e551fa3159e3 ("mfd: Add support for Loongson Security Engine chip controller")
Closes: https://sashiko.dev/#/bug/linux-bc962408-5c42-40af-8111-a8463a05ccdf
Cc: stable@vger.kernel.org
Reviewed-by: Qunqin Zhao <zhaoqunqin@loongson.cn>
Signed-off-by: Lee Jones <lee@kernel.org>
---
 drivers/mfd/loongson-se.c       | 3 ++-
 include/linux/mfd/loongson-se.h | 7 ++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/loongson-se.c b/drivers/mfd/loongson-se.c
index 187ebbed0422..10af13c3b7cc 100644
--- a/drivers/mfd/loongson-se.c
+++ b/drivers/mfd/loongson-se.c
@@ -158,7 +158,8 @@ static irqreturn_t se_irq_handler(int irq, void *dev_id)
 	/* For engines */
 	while (int_status) {
 		id = __ffs(int_status);
-		complete(&se->engines[id].completion);
+		if (id < SE_ENGINE_MAX)
+			complete(&se->engines[id].completion);
 		int_status &= ~BIT(id);
 		writel(BIT(id), se->base + SE_S2LINT_CL);
 	}
diff --git a/include/linux/mfd/loongson-se.h b/include/linux/mfd/loongson-se.h
index 07afa0c2524d..2d0a8b1e5c9e 100644
--- a/include/linux/mfd/loongson-se.h
+++ b/include/linux/mfd/loongson-se.h
@@ -4,6 +4,8 @@
 #ifndef __MFD_LOONGSON_SE_H__
 #define __MFD_LOONGSON_SE_H__
 
+#include <linux/bits.h>
+
 #define LOONGSON_ENGINE_CMD_TIMEOUT_US	10000
 #define SE_SEND_CMD_REG			0x0
 #define SE_SEND_CMD_REG_LEN		0x8
@@ -18,10 +20,9 @@
 #define SE_L2SINT_STAT			0x98
 #define SE_L2SINT_SET			0xa0
 
-#define SE_INT_ALL			0xffffffff
-#define SE_INT_CONTROLLER		BIT(0)
-
 #define SE_ENGINE_MAX			16
+#define SE_INT_ALL			GENMASK(SE_ENGINE_MAX - 1, 0)
+#define SE_INT_CONTROLLER		BIT(0)
 #define SE_ENGINE_RNG			1
 #define SE_CMD_RNG			0x100
 
-- 
2.56.0.307.g5fe7bd680c-goog

