Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E0937B3ED
	for <linux-crypto@vger.kernel.org>; Sat, 31 Jan 2026 21:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769895832; cv=none; b=T7bf7S0jYycuYSAMIRKAtzrtDTne0aAfUgaiNRC8igB5JtZH64cWdPixgUh0iUZpocw6f9aU9TUc5yX0WSjso1r8ndzzkjZ+mbQAGYexKBqxXSq1que4ckY2Pu3aQRoWxWxT9m0l627T4RGnrWq043zuD+KbseOY4ga2CNnwQsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769895832; c=relaxed/simple;
	bh=ahnUAWOoOKFZT1gsXJ2jspzZjBofsyFthBdBHCGN/lI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kEWZ5mXHqqr9WP5HvQCeKUf3k2UYb8ah1P8VNoUPUdTpCHBIY9sGwz1xLceifY3zNeids1nkYdmeGFw+Tl68oOAitpqK/0kzr3qRWNkgZkm43c4SftA/afdv/YophK7NvAO8yDOhT+aUbnH34wszYR0TM5x3d44kJs/uARlH0q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cYoxWarn; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cYoxWarn"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769895817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wFgWw2HfoPPbSf9+6HHmqMYWISdtfATS3BDMhXrb+0s=;
	b=cYoxWarnInEV+Q7Je9V6IAJFw2K4ZXSwFE4KE+yvk/iV8rskQaORHS+83hYpkxBeGuXA42
	tHGyElWAmDgZ30ko5CBt3HBdIjuoMIC3XBUQnP6noqtHMCiDl1CCxEZlDhpnMOTkX2SsXF
	XZPO3C/KeGznMPWnFgDqpP6FrjR7qbI=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk@kernel.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: cesa - Simplify return statement in mv_cesa_dequeue_req_locked
Date: Sat, 31 Jan 2026 22:42:47 +0100
Message-ID: <20260131214249.533350-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Return the result of calling crypto_dequeue_request() directly and
remove the local return variable.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/marvell/cesa/cesa.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index 301bdf239e7d..8afa3a87e38d 100644
--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -38,15 +38,9 @@ struct crypto_async_request *
 mv_cesa_dequeue_req_locked(struct mv_cesa_engine *engine,
 			   struct crypto_async_request **backlog)
 {
-	struct crypto_async_request *req;
-
 	*backlog = crypto_get_backlog(&engine->queue);
-	req = crypto_dequeue_request(&engine->queue);
-
-	if (!req)
-		return NULL;
 
-	return req;
+	return crypto_dequeue_request(&engine->queue);
 }
 
 static void mv_cesa_rearm_engine(struct mv_cesa_engine *engine)
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

