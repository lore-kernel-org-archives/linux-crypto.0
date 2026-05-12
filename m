Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E373911A9;
	Tue, 12 May 2026 13:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778592898; cv=none; b=GjS0bH9l7SAFwjU5ijAVY3JT/kgnPtSYSxNrzDRaOr8/vk4ZcoDzMd4RETjX2sqiBPm9mwMIFEZhwbZ367Mcax6PD0VHaAyOeXcDDlJcnVCk6jqDzlGg3hsCVAfBISzjDF7/gtfq8eMKylK6vi2iO8m6O9PnlGOxSKJxqrWQKxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778592898; c=relaxed/simple;
	bh=TSg+xn4IusJGqvTX/t6/8iMnzbosJnJX4Tp/s6TBZ5o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YYTve2hyRM7hVOc+u3xIgleXFA5bFPUyKZ06Dpu+t+NbO1bUILlhssOGeJrdC6DeFVhLn21bbvGODgtazb/o5SeMmv1if1RB2ecS44FKmOjiGHY6bcc/MnEs8Gpa9o99/pO8NBRqrkz2rPVw7eVNG55HlJ9YGDjMpLzCOTK1/FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=O9jXPSSs; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="O9jXPSSs"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778592893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Z+9bToHXc6fEE/aOZjxNRhmQh3cOPeQjTx2UGkUmTTw=;
	b=O9jXPSSs/2blaH+c3xl+dQ9phvCPEHbsOLHmh34UQCsg9QUK1gTnLl6VYzjxeznGkwYYFo
	3FKfXB5dSLTOUCpAsP9Eaqc+TKtEfTsDlMZGKaR8Wpn17QHbaJ27dPzTBvTtNDIy1Jtli7
	QhjJDcuTErAgRr270JKo/qsyIjlqe7Q=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rosen Penev <rosenp@gmail.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Krzysztof Kozlowski <krzk@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: cesa - use max to simplify mv_cesa_probe
Date: Tue, 12 May 2026 15:34:15 +0200
Message-ID: <20260512133415.302370-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1091; i=thorsten.blum@linux.dev; h=from:subject; bh=TSg+xn4IusJGqvTX/t6/8iMnzbosJnJX4Tp/s6TBZ5o=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFnMOuFNPv9OCf/606Unvtb90cw/TjIBZUHp0z9/ndb5J izi4SPPjlIWBjEuBlkxRZYHs37M8C2tqdxkErETZg4rE8gQBi5OAZhIYzIjw/xc4Tjuvy/ySvkl 39hYbo+vfLFGujlS5NueY2F2ht6+rgx/pX/f+ikf7svj2fVErcapb9fBCWUXtuz/x85qW771Qut lTgA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use max() to simplify mv_cesa_probe() and improve its readability.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/marvell/cesa/cesa.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index 687ed730174d..75d8ba23d9a2 100644
--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -18,6 +18,7 @@
 #include <linux/io.h>
 #include <linux/kthread.h>
 #include <linux/mbus.h>
+#include <linux/minmax.h>
 #include <linux/platform_device.h>
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
@@ -442,10 +443,8 @@ static int mv_cesa_probe(struct platform_device *pdev)
 	sram_size = CESA_SA_DEFAULT_SRAM_SIZE;
 	of_property_read_u32(cesa->dev->of_node, "marvell,crypto-sram-size",
 			     &sram_size);
-	if (sram_size < CESA_SA_MIN_SRAM_SIZE)
-		sram_size = CESA_SA_MIN_SRAM_SIZE;
 
-	cesa->sram_size = sram_size;
+	cesa->sram_size = max(sram_size, CESA_SA_MIN_SRAM_SIZE);
 
 	spin_lock_init(&cesa->lock);
 
