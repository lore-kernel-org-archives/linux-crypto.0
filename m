Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7262133DB
	for <linux-crypto@vger.kernel.org>; Thu, 22 May 2025 09:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747906374; cv=none; b=a4vzkqGoS66jFoKCdaETAQPD97IrutJzUiqa722RVe1L0lgtV4P22769epQRqYC1UmverCOkRfyI+dDk/Rqe38sWLne8WHSrOH5RrlMOghujk8N+TO0xrguGWIXGCqTM0fKoivCOcOGhpzRA0Ws8H2SOmhUxbpTdiQGeyXW3SRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747906374; c=relaxed/simple;
	bh=SZQCSXx7Jr4Y0YKHuHXFYFZr8lyVGGXkoJh7vtDTXmQ=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=O2+d0C+QPM7l8fQVLeDxQ0KpwK/C8ihnuMRw416wqwLVNXWT5lyy9s5m95G4v3Ta0vnuegDWApSkpYE4OkqJOP5vUX5qcNNfsLJRUNquqQ+EKRT/PQXVRBkU3vIfsgYnaj4ky1K1yoH6/O0PhFerR2B1vzeY/MSJhk8ZAivzY64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=hGMvCekY; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="hGMvCekY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=COSOmEiwaZVDqpQ/cmN+Gi4kBl/7Am+8dfoGL07N66Y=; b=hGMvCekYL7yiZ0xy96hkCpvnls
	lu0pNAqX8pS5fCPrQJJafys/OGGJrKBUzv3XHwUvpBWfmgd9n2UlPy66NKFGEVHovNde59aMWWOAT
	BrX4I0ePE/aDybdDwC5keTgw8S/jjWsKT5PRIgz+6JPivj0ubjTpYI1S4Zl5cK/w4RkP8jLWNjuLC
	xI0gdO4OQl0owXuTEw/HL0ctpDH7rQi0UjoqAXxOxsYMvAd6dzx2+FDRMvUXNlm/xBZhLWDC9RBHv
	epky2AZXR1deLW/mXnG+1IpLKtuxk7jFr+EhDqpiDsRzvkowxw3SzV/4qvLAMfp+NuhssIdIop5qf
	/OUt5b8A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uI2IB-0083Eo-2I;
	Thu, 22 May 2025 17:32:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 22 May 2025 17:32:47 +0800
Date: Thu, 22 May 2025 17:32:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: marvell/cesa - Remove unnecessary state setting on
 final
Message-ID: <aC7vP-7pKms_9rOB@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

There is no point in setting the hash state after finalisation
since the hash state must never be used again.  Remove that code.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/marvell/cesa/hash.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index 6815eddc9068..8b4a3f291926 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -362,16 +362,13 @@ static void mv_cesa_ahash_complete(struct crypto_async_request *req)
 	if (mv_cesa_req_get_type(&creq->base) == CESA_DMA_REQ &&
 	    (creq->base.chain.last->flags & CESA_TDMA_TYPE_MSK) ==
 	     CESA_TDMA_RESULT) {
-		__le32 *data = NULL;
+		const void *data;
 
 		/*
 		 * Result is already in the correct endianness when the SA is
 		 * used
 		 */
 		data = creq->base.chain.last->op->ctx.hash.hash;
-		for (i = 0; i < digsize / 4; i++)
-			creq->state[i] = le32_to_cpu(data[i]);
-
 		memcpy(ahashreq->result, data, digsize);
 	} else {
 		for (i = 0; i < digsize / 4; i++)
-- 
2.39.5

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
