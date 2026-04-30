Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348F63E51C9
	for <linux-crypto@vger.kernel.org>; Thu, 30 Apr 2026 11:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777546962; cv=none; b=EZvoomK4mkB+NKsQKtfKU2S1FCNJlPzhuJOxzDpzf/sLKi8RRoJx/rneovknGOBsBUj0EYM0/ryBi/91uwOT9IgzQuCJZB2FgFV05AAgqgYZXJ0++Wj54qTBFh8tj1juKsGiPqMZ4Hzp4GK8f9WlMcuXtrCHN8Lv6VK6LoqNg+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777546962; c=relaxed/simple;
	bh=aoJSJuihLA9P+OZ3rpdOiSQXCyYtBxYq1IF+637Tio4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L8TiTLqUOy1uxLv0cRgQSgm0NqhWq3OfZgkNE5ks4mx+/pvpfthooUaM+N8sb+pgy1TRpNgtNYMp+TDtA8jaPoXHlbGOFvM/Oh7aqT7s1YwwLSwBClm6ErZdJltCvo5yKoo9Gm/MjYeXyZciFuKA3v3MxTdc6LMo9iZ+kDSJdLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WeyUfWxR; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WeyUfWxR"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777546946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=k/Ax3rJzZx6lwyaackm0hVg0xDKQ2TzRvxu8b0FYoMQ=;
	b=WeyUfWxR8sazSyxj94kQ+GmLZC21QuDumSZn6toXXehwwvrg7ENO0tWOU8aJJ3RDR2lM2P
	xgwoZ3eYwCKoirb3KneS/Fv7r9uj1GnOjLiu9kQJ/nm7bfWrzKNf3y6ajVJgwGmknHUCZs
	bJD0VSJnUWmUfWGEQtIgNunzJ0I7DYU=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH 1/4] hwrng: core - drop unnecessary forward declarations
Date: Thu, 30 Apr 2026 13:00:48 +0200
Message-ID: <20260430110047.248825-5-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=904; i=thorsten.blum@linux.dev; h=from:subject; bh=aoJSJuihLA9P+OZ3rpdOiSQXCyYtBxYq1IF+637Tio4=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJmfzeL//PMrEd3WOWebwf53IZMNrWfvfXDmVczf+TI/t i0+ve3Yw45SFgYxLgZZMUWWB7N+zPAtrancZBKxE2YOKxPIEAYuTgGYyIkqhr9SNfGyWl87hNaW /uxm2ixr8frWt0u/Sh5OeR/7VaamaH0jwx+u75UbIp6fzLVLOt8zNfCOvLiPE5P7/Ms+fv2XKk1 5zZkB
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The forward declarations for drop_current_rng() and rng_get_data() are
not needed - remove them.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/char/hw_random/core.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index aba92d777f72..68add1a97f31 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -54,13 +54,9 @@ module_param(default_quality, ushort, 0644);
 MODULE_PARM_DESC(default_quality,
 		 "default maximum entropy content of hwrng per 1024 bits of input");
 
-static void drop_current_rng(void);
 static int hwrng_init(struct hwrng *rng);
 static int hwrng_fillfn(void *unused);
 
-static inline int rng_get_data(struct hwrng *rng, u8 *buffer, size_t size,
-			       int wait);
-
 static size_t rng_buffer_size(void)
 {
 	return RNG_BUFFER_SIZE;
