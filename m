Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7535A2E8B94
	for <linux-crypto@vger.kernel.org>; Fri,  9 Jan 2026 14:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767968577; cv=none; b=d40uTH0Tfhn1q6LbQk3OqpndmOx55nicZTsFK0Pt8gowYfoE4IEFJO4tRIrlljL7tnWLwWQxBNimjoVOY7cy07n7Tjcrm79S4+Mw560LQp2am9S71TuNPJOwCYsj76lp6izpUUMxqDdaxam3ig9ywIC0mhL7ZXD7pF0RQJZtWX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767968577; c=relaxed/simple;
	bh=ldpV63w1H5Mk2/xAqTHpntSFzVm3q22QRe7D4olLOkU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Pux58lC55Jirfl+QuOEseIFixURRx2GG/wJRaieyFR+e6powaxUZWjEBK4bTKx3KCyXSi9uQ7cRlVZRGNmg7nhI9yj98p5WnbrjyYOy3CSjXMtjJDumNk5rynLtS4LqYuuJTp7Kn1gfm5UI7H83e1j5g62KReqrI2Ka2cu6EtkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SvjBQCu6; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SvjBQCu6"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767968573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jPCJvVh7QKX2iSMtWwv7GRsl36Brtuua2rgRr5lzIng=;
	b=SvjBQCu6HinEYypeIlRCycdHJPXWxUEM9YhGoWwPsDqgIQIyPIOkVozJQWtRaDb7pJ2IyQ
	Z+F3Xr7/AuwBsEjdt7I6UhgkYoj+f7MW5/kxaS7GFypiyqbDYvNvBmtK6fTCCH0u37c8rc
	FVISSmfcWOZE21+gm6wl1tNTf5zaRBo=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: stm32 - Remove unnecessary checks before calling memcpy
Date: Fri,  9 Jan 2026 15:20:36 +0100
Message-ID: <20260109142039.220729-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

memcpy() can be safely called with size 0, which is a no-op. Remove the
unnecessary checks before calling memcpy().

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/stm32/stm32-hash.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index a4436728b0db..d60147a7594e 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -1115,8 +1115,7 @@ static int stm32_hash_copy_sgs(struct stm32_hash_request_ctx *rctx,
 		return -ENOMEM;
 	}
 
-	if (state->bufcnt)
-		memcpy(buf, rctx->hdev->xmit_buf, state->bufcnt);
+	memcpy(buf, rctx->hdev->xmit_buf, state->bufcnt);
 
 	scatterwalk_map_and_copy(buf + state->bufcnt, sg, rctx->offset,
 				 min(new_len, rctx->total) - state->bufcnt, 0);
@@ -1300,8 +1299,7 @@ static int stm32_hash_prepare_request(struct ahash_request *req)
 	}
 
 	/* copy buffer in a temporary one that is used for sg alignment */
-	if (state->bufcnt)
-		memcpy(hdev->xmit_buf, state->buffer, state->bufcnt);
+	memcpy(hdev->xmit_buf, state->buffer, state->bufcnt);
 
 	ret = stm32_hash_align_sgs(req->src, nbytes, bs, init, final, rctx);
 	if (ret)
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

