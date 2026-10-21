Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792584958;
	b=HOUJKrfQFkp2jPtvBEEdotnh8ksXUWXKxtnk+XGeiFz5hcGRDO2USHrpFJ0UUD8MFCXk
	 zpaN0cxNOOy0i28TanxdCjURc8IctUz8tWZ0BhbzM/9anQjcA44lMaWPZxgnUDmllGhsh
	 cFwGmIa0KROFbVh7lbaJ5hbiVVG9dPUW3C8ZYTnLmH6sWGUyKBqgs4mXUBhY0WVGyocUB
	 w6L/cdNbN5sLBuFR6fWOH0RTvnglIFgCoYLHAqdNwJ3lMVxB7a4gLUyL7vPs4NBHveOVt
	 DWRUPW1vBXPTWc7eegXSA4ZAM+gu+0t0cfpRMuivbt75FAU2i38OFoDjalby8GF0aOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792584958;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=pkGIsmN4vJcitLt0b1JcG2oKnxzW45zYK4NJHa52l0U=;
	b=FykVVueZK9RK473HiB8zxWtMo8qJd1Zm1EGfPW2Jx+aFQoR+Y5HlUSH1B3Ut6LDghEyr
	 smSvdcGyGwCexQ/8N79FOo2NthYMgKD8FLTCcJbQGps0mTkWK7Gujzf7glovgz9R6hK3n
	 PEHzRWA+0PrN11TkwW26Cvyw2GZ5/bIJ5XpLq7ofzmnJP01AJr7qm8Z19njCJu0k7gNRF
	 tA8AUZF1EViCFuHADNK/q3XjjgZqkJuinZ9D2PkLFBWYBnHIEf8mW7Bykg4GSrsoyPFwZ
	 UxkD3EXi+1xCxcbWgTegQJqRZOmuMbMQoiEK5ZPeAzy3o7/CY08JIWRmUtseOWa0Z/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RjumiWBv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434D460A2607;
	Wed, 21 Oct 2026 12:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RjumiWBv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B8A1F000C4;
	Wed, 21 Oct 2026 12:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792584958;
	bh=pkGIsmN4vJcitLt0b1JcG2oKnxzW45zYK4NJHa52l0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RjumiWBvv9xL+VFJBbB/AYQp8de89CTJg+G4K1SVnIQ6ePiE3uV5Q/D9k94IbaKSc
	 puNXm5CB+qtl8YExsgxIcKQ4m4Qn6EIZ9aiouzpp/Ah7qEUZPKCpu6kOCNs2i4n/zc
	 dOUFdAfJAI9aoQ2UGes7dC6piWVw9GbeYblg7wJFv3215k/4enLCRwKqBJtnNwBklZ
	 3af/88hCsW4FoloVFMXw7yrI9UzJxOcgRsb7aG9/8koiAkCR+rxu4YMj/sEmZXoKMN
	 dsPdS437YXmFZFYEt6C9pOSod12XUuNvY6MRS4LMCYFR43/Dl5AnjFyTl9u6bxB58k
	 M808N0gOmVicw==
From: Lee Jones <lee@kernel.org>
To: lee@kernel.org,
	Qunqin Zhao <zhaoqunqin@loongson.cn>,
	Yinggang Gu <guyinggang@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	linux-crypto@vger.kernel.org,
	mfd@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH 19/28] mfd: loongson-se: Prevent out-of-bounds engine access in se_irq_handler()
Date: Wed, 21 Oct 2026 12:09:41 +0000
Message-ID: <20261021121245.3111563-19-lee@kernel.org>
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
2.56.0.218.g1ec904b173-goog

