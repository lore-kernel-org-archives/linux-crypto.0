Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4748D29E116
	for <linux-crypto@vger.kernel.org>; Tue,  5 May 2026 09:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974405; cv=none; b=YPHxkU5uE1HW+Wbm2CE1UJoDehX6/OSINLqJLTazaJZLPzpdJwhsfE3AcfNCyKxrrmM33iWilzotHmNaO7P+eKcSXWja0z9ZHX6qCETNlYERkCPg6QQoEI/Iaf/8vAQRjLpJWTiqqvBomWkOPcDHpJn0+ZInI/PS9QuMNNlU1LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974405; c=relaxed/simple;
	bh=t30JCyaSXq4YKIbL5WlJdz49ww4bKSi3lB2KR9wRAnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M1S9RVcmKQDB2kkzJ1wet/mss/iYq18PX/PaZVMlEGBUvJD1w2jkmrozUMtZaSeds4GNXDch1zMQNwioJWXw+92FZMFoBDxf/l1X8WdT6LND1Mjkwhix4eX09WT+Kqk+TgmBUppTYy/ASiQ1m7uOkBEXDSqhjzU9iB63Ok74Rrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=diR2ww0R; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="diR2ww0R"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777974401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CnEKYp/mhi2DaqqIXdAVLLXGwYDnunrVEDqtP5gWYGc=;
	b=diR2ww0RygvUDwBFd1r9VWIBsIVHkHyzvvztpGCroWGNR0f7pyS2QtcPY+OMTvEUZhqh3C
	EMX5whBRAFzkzNxbGwA552lCfytVkd0OX0NMur3hh6qSKKtHEIKv6Gx4QKLhgIHWdu1v2q
	CYb6eAWUZAW/oyl1TL2PsVN1K2IMJPE=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David Laight <david.laight.linux@gmail.com>,
	Jonathan McDowell <noodles@meta.com>,
	Lianjie Wang <karin0.zst@gmail.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] hwrng: core - use bool for wait parameter in rng_get_data
Date: Tue,  5 May 2026 11:45:56 +0200
Message-ID: <20260505094555.158017-7-thorsten.blum@linux.dev>
In-Reply-To: <20260505094555.158017-6-thorsten.blum@linux.dev>
References: <20260505094555.158017-6-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1233; i=thorsten.blum@linux.dev; h=from:subject; bh=t30JCyaSXq4YKIbL5WlJdz49ww4bKSi3lB2KR9wRAnU=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJk/90QeruO9YGDZ887oQchS6b8HxLbYnF/FcvggzyGuE tdHO8NDO0pZGMS4GGTFFFkezPoxw7e0pnKTScROmDmsTCBDGLg4BWAix18zMuxdMOv4NcODYWrB milyVdqCfpEpt7Z37r/9/o3ayZtatZ8YGbYuVdz0Q3jGvqP2vu9SlvxfvFVQc9UtWT/Gm523mLS PLOAHAA==
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The wait parameter in rng_get_data() is a boolean flag - use bool
instead of int to better reflect its actual type.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
Formatting changes only as suggested by Andy.
---
 drivers/char/hw_random/core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 68add1a97f31..870e77c9ec20 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -210,8 +210,8 @@ static int rng_dev_open(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static inline int rng_get_data(struct hwrng *rng, u8 *buffer, size_t size,
-			int wait) {
+static inline int rng_get_data(struct hwrng *rng, u8 *buffer, size_t size, bool wait)
+{
 	int present;
 
 	BUG_ON(!mutex_is_locked(&reading_mutex));
@@ -534,8 +534,7 @@ static int hwrng_fillfn(void *unused)
 		}
 
 		mutex_lock(&reading_mutex);
-		rc = rng_get_data(rng, rng_fillbuf,
-				  rng_buffer_size(), 1);
+		rc = rng_get_data(rng, rng_fillbuf, rng_buffer_size(), true);
 		if (current_quality != rng->quality)
 			rng->quality = current_quality; /* obsolete */
 		quality = rng->quality;
