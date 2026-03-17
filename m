Received: from inva021.nxp.com (inva021.nxp.com [92.121.34.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9433A6B7E
	for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2026 10:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=92.121.34.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773743160; cv=none; b=dIgt4vNDwIC3MHV8z/MRwKNP6es+vwrOyWTHcEMj+AAp0ZzQo+1ydOKJXREfwbOvhJUSowx/LxrhYsaHCcJN8bERT6EJog0GbGvXh1DaY38wpfIFUtuw6s13dOAZCIAQWNWGoV2yMrE0MWi2l+aZ3O+6MQAqqvJwZJ84T8+9C0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773743160; c=relaxed/simple;
	bh=hjoBpHPC9Y8AEx3vQdQfREpdCz3NGob+FEFJLvpmPAs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qmt0Lvn0xuf08sUSpbvJLMxj/XEsdSboquZ99MFkfgQPN4n+VPTxfs3wffHzVe2U1raA2gBdBbI875gIL0TsaZi93uFDpUp8I4VMWJr9kG4ovJu+vPZxxHzBTfuULxugtptSS1EcOztIPhtIUEXS2iC5CbOPnBx4EFOAn+x+dzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com; spf=pass smtp.mailfrom=nxp.com; arc=none smtp.client-ip=92.121.34.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nxp.com
Received: from inva021.nxp.com (localhost [127.0.0.1])
	by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 35B972000CA;
	Tue, 17 Mar 2026 11:25:57 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
	by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 2591820014B;
	Tue, 17 Mar 2026 11:25:57 +0100 (CET)
Received: from lsv15509.swis.ro-buh01.nxp.com (lsv15509.swis.ro-buh01.nxp.com [10.172.0.253])
	by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 9020220354;
	Tue, 17 Mar 2026 11:25:55 +0100 (CET)
From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Paul Bunyan <pbunyan@redhat.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	linux-crypto@vger.kernel.org,
	NXP S32 Linux Team <s32@nxp.com>,
	imx@lists.linux.dev
Subject: [PATCH] crypto: caam - fix overflow on long hmac keys
Date: Tue, 17 Mar 2026 12:25:14 +0200
Message-Id: <20260317102514.3882809-2-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260317102514.3882809-1-horia.geanta@nxp.com>
References: <20260317102514.3882809-1-horia.geanta@nxp.com>
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

The copying is performed using kmemdup, however this leads to an overflow:
reading more bytes (aligned_len - keylen) from the keylen source buffer.
Fix this by replacing kmemdup with kmalloc, followed by memcpy.

Fixes: 199354d7fb6e ("crypto: caam - Remove GFP_DMA and add DMA alignment padding")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg_qi2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 167372936ca7..78964e1712e5 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -3326,9 +3326,10 @@ static int ahash_setkey(struct crypto_ahash *ahash, const u8 *key,
 		if (aligned_len < keylen)
 			return -EOVERFLOW;
 
-		hashed_key = kmemdup(key, aligned_len, GFP_KERNEL);
+		hashed_key = kmalloc(aligned_len, GFP_KERNEL);
 		if (!hashed_key)
 			return -ENOMEM;
+		memcpy(hashed_key, key, keylen);
 		ret = hash_digest_key(ctx, &keylen, hashed_key, digestsize);
 		if (ret)
 			goto bad_free_key;
-- 
2.25.1

