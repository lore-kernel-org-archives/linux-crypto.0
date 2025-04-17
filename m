Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77AC2153D8
	for <linux-crypto@vger.kernel.org>; Thu, 17 Apr 2025 22:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744929476; cv=none; b=l5jTa5RpTvu0F4GAfQa4JZyS8AUNqN6HdCsVRjSmyrFN1tklAib0VOsRBrfUszs055cIf05LZzUql5/PfIRHVYcieqbI982XubrPpQ78NGdSDuSfaYwUUgkygwAdcFBzDZM6Luyxk1irWXrrWklR7LECAvhM9+BbcfRi1NT2oDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744929476; c=relaxed/simple;
	bh=3DpawYJNdPiK+Wj1dDUe9l1ENJfOB0aohxjotazsNzI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z2jFqs21teckA9/mhNxUzuEd40Qf7lrBYLNT5i8yL/aP7RGN3t30OTxlpQsOUp43VezumSwNGFzU+EXumuiKbXujYgV/DZqqkDl7IwtRytpRY6VT6d5RYXtbZtZyw0a7yONssYoHRWMMNLRnpg5pRqVzlJr014pTAiSWd3DEziM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mg9NHyVK; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mg9NHyVK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744929461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=A0Zj7XbH7jorqAvhaNTeetJGNlbxYBB7mbYxezOdBjw=;
	b=mg9NHyVKo06KpJrkXnTktGn7K+I+YkOSat2k210PdPOm/xKbRzkHONH9VJiObQWMzFgVdz
	YTPm1JGGz1LmhJEBQNd0Y4S+94SkYZA8tHcxAeJ1sUKxjX1ldj8SgBpobWUuv+wiCuzvsk
	xKMy0Xuo7LMLaXDPhJA8optufs+gspA=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: engine - Realign struct crypto_engine to save 8 bytes
Date: Fri, 18 Apr 2025 00:36:49 +0200
Message-ID: <20250417223650.72687-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Realign struct crypto_engine to reduce its size by 8 bytes. Total size
is now 192 bytes, allowing it to fit within 3 cachelines instead of 4.

pahole output before:

  /* size: 200, cachelines: 4, members: 17 */
  /* sum members: 183, holes: 3, sum holes: 17 */
  /* paddings: 1, sum paddings: 4 */
  /* last cacheline: 8 bytes */

and after:

  /* size: 192, cachelines: 3, members: 17 */
  /* sum members: 183, holes: 2, sum holes: 9 */
  /* paddings: 1, sum paddings: 4 */

No functional changes intended.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 include/crypto/internal/engine.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/crypto/internal/engine.h b/include/crypto/internal/engine.h
index fbf4be56cf12..b6a4ea2240fc 100644
--- a/include/crypto/internal/engine.h
+++ b/include/crypto/internal/engine.h
@@ -27,10 +27,10 @@ struct device;
  * @retry_support: indication that the hardware allows re-execution
  * of a failed backlog request
  * crypto-engine, in head position to keep order
+ * @rt: whether this queue is set to run as a realtime task
  * @list: link with the global crypto engine list
  * @queue_lock: spinlock to synchronise access to request queue
  * @queue: the crypto queue of the engine
- * @rt: whether this queue is set to run as a realtime task
  * @prepare_crypt_hardware: a request will soon arrive from the queue
  * so the subsystem requests the driver to prepare the hardware
  * by issuing this call
@@ -51,14 +51,13 @@ struct crypto_engine {
 	bool			running;
 
 	bool			retry_support;
+	bool			rt;
 
 	struct list_head	list;
 	spinlock_t		queue_lock;
 	struct crypto_queue	queue;
 	struct device		*dev;
 
-	bool			rt;
-
 	int (*prepare_crypt_hardware)(struct crypto_engine *engine);
 	int (*unprepare_crypt_hardware)(struct crypto_engine *engine);
 	int (*do_batch_requests)(struct crypto_engine *engine);
-- 
2.49.0

