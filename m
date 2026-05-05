Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C7A2E8B83
	for <linux-crypto@vger.kernel.org>; Tue,  5 May 2026 09:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974407; cv=none; b=sg33UdyAq6gaSS3FOWk2iF5oTt4LLKVx2WI4Ky+9zsM7I3X6CWuEnkov4vpcNxMPgiCY2W5SSBCsRcTrvTrneUQgJ0ePX3ohmOi0WzIn1vncJCT0Z63aJuMIPi0s+TqET80kVTiSgTFUeMsa34ypFQ7/MtFNTfPFR49xqYhBaNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974407; c=relaxed/simple;
	bh=DHzdhd+wnXnss80CjRsSQclSRXEu/uR8ANVCcaYw8FI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ovvvpGY/Z7h8hWhZ0ltKVuM/NBxobxN29TWgi3GYxKiRsJ0o6bat2KP3cyNser4WddCoy+YL79OBN+YMlePMcjEflYEFlggq8c8DaFfzKYX71aQ89w47LToZqteQhW5d6+IGDBOcCCpFH74d3q9KwsXtO30FZwCNMgeYIoEiwvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VhNswrnj; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VhNswrnj"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777974394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3K7Y1skkT9ki+HcpcGfDuuiLUVEERGgnCruda9u1elI=;
	b=VhNswrnjeVgBl355e5EbfJ6siT0PwEUWxh1MzhrFpZj3oJGLwvU8i+c0a48AG4C8S66gH+
	W+4tc2imTxIW9c+arfsggpgkVc6KTBeoohwApDYXpnm69SMNbRjA6XSFDpXhB6P/c8048H
	TCwo6HqA25db03IVw8b5VVuvtM1Kr1E=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Lianjie Wang <karin0.zst@gmail.com>,
	David Laight <david.laight.linux@gmail.com>,
	Jonathan McDowell <noodles@meta.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] hwrng: core - drop unnecessary forward declarations
Date: Tue,  5 May 2026 11:45:55 +0200
Message-ID: <20260505094555.158017-6-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=935; i=thorsten.blum@linux.dev; h=from:subject; bh=DHzdhd+wnXnss80CjRsSQclSRXEu/uR8ANVCcaYw8FI=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJk/9wQXrumq15/6sC8g6APf/L02putu6LSzbM43TdtQ8 WjSPA+ZjlIWBjEuBlkxRZYHs37M8C2tqdxkErETZg4rE8gQBi5OAZiIz1JGhj3b+JmYbRymTe1Q 9eS66WN2/cOm+PctsTstGA9s5FDi3c7wv/AXdxQzW0PalWqmp+e0TUqu2fG/y5p9T15l6rK5PIt z2QA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The forward declarations for drop_current_rng() and rng_get_data() are
not needed - remove them.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
No changes in patch 1/4.
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
