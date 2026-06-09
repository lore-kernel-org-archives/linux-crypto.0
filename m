Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948AE3EBF35
	for <linux-crypto@vger.kernel.org>; Tue,  9 Jun 2026 10:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780999580; cv=none; b=OS/j1VLDfVHzpg4BzJ0GLldn01zaFZzIJsWaEfclX+LfOkt1ZdSUhqLa9Z5OVxgtk9tgAe/ka8vVk1HGCb2/6aAvDUVtackZ0era/AItq0q4LKwg/2/L9VoWcdj3q2nkPIUnEGYfW1Gt61RnrK4iwBu7dkswAHVixzo9BfYsfpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780999580; c=relaxed/simple;
	bh=BzG3EeqRxWR8HYlURE2Sltt0JWppddYvlfDOjL8KzVw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q/B8tB0qMD9flZQXUptOgQhHC4JrRjWgeMYN1VcFTv2MqNVroacK3AEfUHJcJTv6g3G3jeEFVyTwd00vrLszOGlspHJSkxWPkfXo9wZlql3Mf+0CaEwHEtJKwDSNcTGLU2Z+aEEua5mFyZRRvmkhe0ozEL6Ls8Rkl+Y6QbCga6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NPKxOvya; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NPKxOvya"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780999576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rytQfetHT/8eDI/+MtviowuR9AbKpI1Re4AXCiErncE=;
	b=NPKxOvya8+KOlxS8s4znKr5+1DVYBKAllGoT9fpazBDaqUxYPfV3NSVPUkffyukCkkXGDq
	cVj7yGPD3NsWX1tNr32zWcRIffw/PXnOykLsnWuCP2rXUyqu1FMiu8FVgfUT1xIs3cFrJ2
	7OHfoI8tZT2xdfjwDQy6uFI467LiME0=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] crypto: atmel-i2c - improve comment in atmel_i2c_init_ecdh_cmd
Date: Tue,  9 Jun 2026 12:05:53 +0200
Message-ID: <20260609100552.233494-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=970; i=thorsten.blum@linux.dev; h=from:subject; bh=BzG3EeqRxWR8HYlURE2Sltt0JWppddYvlfDOjL8KzVw=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFnqTxusha/PDl/mfTViatjBGftSVUr3Cl14Xqkf8XR57 uqEO+W7OkpZGMS4GGTFFFkezPoxw7e0pnKTScROmDmsTCBDGLg4BWAiNuyMDHt7U8R1LD+WS69P /3aM5ZTdjVLjqrQ9VwLZXH4/OPn0RwojQ9cbnQ2nElc6HGjtPmMn6vC166f2AbPnfonyCgkLNQr 4eAE=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Clarify that a P-256 public key is encoded as two 32-byte coordinates.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
No changes in patch 1/2.
---
 drivers/crypto/atmel-i2c.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
index ff19857894d0..24bded47a32b 100644
--- a/drivers/crypto/atmel-i2c.c
+++ b/drivers/crypto/atmel-i2c.c
@@ -138,9 +138,8 @@ int atmel_i2c_init_ecdh_cmd(struct atmel_i2c_cmd *cmd,
 	cmd->param2 = cpu_to_le16(DATA_SLOT_2);
 
 	/*
-	 * The device only supports NIST P256 ECC keys. The public key size will
-	 * always be the same. Use a macro for the key size to avoid unnecessary
-	 * computations.
+	 * The device only supports P-256. Its public key is encoded as
+	 * two 32-byte coordinates.
 	 */
 	copied = sg_copy_to_buffer(pubkey,
 				   sg_nents_for_len(pubkey,

base-commit: 79bbe453e5bfa6e1c6aa2e8329bfc8f152b81c9b
