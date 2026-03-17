Received: from inva021.nxp.com (inva021.nxp.com [92.121.34.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D123A5E6D
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 10:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=92.121.34.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773743157; cv=none; b=Hiwg5TVATvhcQZEb+AhZrfVblVf81a3bxtGOJwxB4QKQj7CQs7LownSPAaWsESgWhNRkNhHrnaGoGrxh0iw0xSVcdQ71uDEwyovEle0tp5IVgrC7UcuQeszLlJQeX7LjGv7sgzodfrbyELfbQxFKFjqHRrxX13eUtSp3V5pg+7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773743157; c=relaxed/simple;
	bh=jkq2WjYCcQxDWTym4IfJ0pih1gzA3onTSTyIbhDl48k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=hc3yWOHQDkCHt6jTHsNDjqL0j194Qk8DQI8tsu+rA33LBi4kqI2pjePqz07JUIjhSXvRrX/UftL9+nhNG0kCBWs6RjdKKIiO2nTLGxaC9qRqJQgBYNs5kMWvw8TZuz/WhhwtpwPrkk0QZbShLyOJGxyNE8QEVAx3JajCis66PhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; arc=none smtp.client-ip=92.121.34.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Received: from inva021.nxp.com (localhost [127.0.0.1])
	by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 44A6320013E;
	Tue, 17 Mar 2026 11:25:49 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
	by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 374012000CA;
	Tue, 17 Mar 2026 11:25:49 +0100 (CET)
Received: from lsv15509.swis.ro-buh01.nxp.com (lsv15509.swis.ro-buh01.nxp.com [10.172.0.253])
	by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 8DF3620354;
	Tue, 17 Mar 2026 11:25:47 +0100 (CET)
From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Paul Bunyan <pbunyan@redhat.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	linux-crypto@vger.kernel.org,
	NXP S32 Linux Team <s32@nxp.com>,
	imx@lists.linux.dev
Subject: [PATCH v2] crypto: caam - fix DMA corruption on long hmac keys
Date: Tue, 17 Mar 2026 12:25:13 +0200
Message-Id: <20260317102514.3882809-1-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP

When a key longer than block size is supplied, it is copied and then
hashed into the real key.  The memory allocated for the copy needs to
be rounded to DMA cache alignment, as otherwise the hashed key may
corrupt neighbouring memory.

The rounding was performed, but never actually used for the allocation.
Fix this by replacing kmemdup with kmalloc for a larger buffer,
followed by memcpy.

Fixes: 199354d7fb6e ("crypto: caam - Remove GFP_DMA and add DMA alignment padding")
Reported-by: Paul Bunyan <pbunyan@redhat.com>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamhash.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 628c43a7efc4..44122208f70c 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -441,9 +441,10 @@ static int ahash_setkey(struct crypto_ahash *ahash,
 		if (aligned_len < keylen)
 			return -EOVERFLOW;
 
-		hashed_key = kmemdup(key, keylen, GFP_KERNEL);
+		hashed_key = kmalloc(aligned_len, GFP_KERNEL);
 		if (!hashed_key)
 			return -ENOMEM;
+		memcpy(hashed_key, key, keylen);
 		ret = hash_digest_key(ctx, &keylen, hashed_key, digestsize);
 		if (ret)
 			goto bad_free_key;
-- 
2.25.1

