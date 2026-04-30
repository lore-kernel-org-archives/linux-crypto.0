Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0FC3BA229
	for <linux-crypto@vger.kernel.org>; Thu, 30 Apr 2026 11:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777546951; cv=none; b=RAPybUX1EQM23VxlUud9f+XpL25tf6opCGc0ysUkq1r85j1jgmjOFBecAV4hu2zPPKFl84AXtWsbnWtD0+698PcgzqyS0SOrlGNHtzkR6h8gXRfbESrMQULrsRXzeQV9/hs4zFQNA/vwi8k3RY3L6eI6s08sYXGbHUZmc2UFl7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777546951; c=relaxed/simple;
	bh=PsHu5iuEUHv/PDOb/SwRJjKuYuK/akECq1Vnh0LYFEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUcZq9jliI+W5+hoB123+l70W8vMCRCYCSFskuhUTIFvnz4w+/Z0Orn6pf/N0m0InqPuXGOCmwqexBcCuD1Qfcs1Wb6u06QkqLnOuJ+n9d9qHFd+xhR5uY6nw04DFK8MEph4iCEdHmY1+F/5iaeKpTURpLoxh0GTnfTZLvq/KbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mnVivxBh; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mnVivxBh"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777546946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pG03wJvkCGREBkjpwEJLodaP0qZR8DF4vyX+48wV+CM=;
	b=mnVivxBhvaGkiY6ENbCTcQ0f7rPdK5liS/nybPhsKTARU3o1cNWmeeTVTPjoU8ayi04FxL
	Kx7A8qp+z/TXpFLBirl8tEYx2T9dXbfCWiDE/fGWG0BfbpHNWeevKHgPuMXPxUTlpydS4D
	An0odNKLHY8avW44aMQOM507WKRnuyI=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH 2/4] hwrng: core - use bool for wait parameter in rng_get_data
Date: Thu, 30 Apr 2026 13:00:49 +0200
Message-ID: <20260430110047.248825-6-thorsten.blum@linux.dev>
In-Reply-To: <20260430110047.248825-5-thorsten.blum@linux.dev>
References: <20260430110047.248825-5-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1094; i=thorsten.blum@linux.dev; h=from:subject; bh=PsHu5iuEUHv/PDOb/SwRJjKuYuK/akECq1Vnh0LYFEQ=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJmfzeLXHr7wyG1i5Hzx+QIV27Rrf947durEXXHGyuQ/U +6sj5OM7yhlYRDjYpAVU2R5MOvHDN/SmspNJhE7YeawMoEMYeDiFICJ9HIyMuxJZHrmojbrk23n LoGPRYfEX0o7p987kz0l3n6NW/an9UIM/0MN5VbpZR0IX25+xsr5F5+E3+u1K+e93702WJh53/G 1G3kB
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The 'wait' parameter in rng_get_data() is a boolean flag - use bool
instead of int to better reflect its actual type.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/char/hw_random/core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 68add1a97f31..905a63525831 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -211,7 +211,7 @@ static int rng_dev_open(struct inode *inode, struct file *filp)
 }
 
 static inline int rng_get_data(struct hwrng *rng, u8 *buffer, size_t size,
-			int wait) {
+			bool wait) {
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
