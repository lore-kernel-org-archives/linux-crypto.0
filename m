Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A2C227E95
	for <linux-crypto@vger.kernel.org>; Thu, 27 Feb 2025 10:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740651302; cv=none; b=iLEhO3KPa5IqPQja0Uh0Pf2nYTj7W393Gb8LRUlK+aSBm8FNpGGgvd+lkkmRL/aG6/EJUrp+shdioyNP66U+JecUoUV1SQIXb3Us2SYzE3S94lK4q81Yii3otoe3uVNcPQwbueKWj+Z7Hryv3K2tRL0Bu0pES9OwV83MDt2Yxp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740651302; c=relaxed/simple;
	bh=K7VNYRDV1yfJVKgFsqppm610jih+a7OPEQ+mKbsc+N0=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=JAVycvcyfmyVtATRykQVhBmjD4Un9OdZiOAkFxSwDoU2B1GNZvnQweqHwrp1IiwzixClJmLxnweXPnuWIGQqGqquIB14Z5MvnGiJZ8MrFhoJFF7WiI7om1Aj2oqxHnasOsuSfCjelohRgrdIkcG3hNWyc5asZCmfH1rZynIHjak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=dTTXozfv; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="dTTXozfv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=B0mE1hvDwybCOi8Ma7SncwsCTkexIE9OZoKz2lEpXNE=; b=dTTXozfvVo/hJt1WOaRBEC3ouX
	lqowE/dGvjahetzBhkorXNlmG//rfv/fUaxwOgjcg8clQPZBqs+/m+5/i1PCqQYnvPUGtL4oPi1e3
	JQJF+4/Z5RfUzxOoN6ihJZrfe3cppEbpToVSRGkFvPU4jLvtdQYvWa0Uz75B9YH/Eic0wVqA9lt1r
	2FanPtFLMIK6B2e12+dtkq4ah3sK4phQfNrZvGghq/QbpuRHguDdsA3fGPDxZL5Ey7Ja/c/CsAY83
	a17cAj0AS4spz8/cIssGRzF/mOWpfwXYjk/ngmwWTgMpOd2SJOBgvoDBzM4/QsjEOZh2E0OZ+uhX+
	jxRUidLA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tnaut-002Dqc-2J;
	Thu, 27 Feb 2025 18:14:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 27 Feb 2025 18:14:55 +0800
Date: Thu, 27 Feb 2025 18:14:55 +0800
Message-Id: <aa2a2230a135b79b6f128d3a8beb21b49800e812.1740651138.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1740651138.git.herbert@gondor.apana.org.au>
References: <cover.1740651138.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/7] crypto: iaa - Test the correct request flag
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: linux-mm@kvack.org, Yosry Ahmed <yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Test the correct flags for the MAY_SLEEP bit.

Fixes: 2ec6761df889 ("crypto: iaa - Add support for deflate-iaa compression algorithm")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index c3776b0de51d..990ea46955bb 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1537,7 +1537,7 @@ static int iaa_comp_acompress(struct acomp_req *req)
 	iaa_wq = idxd_wq_get_private(wq);
 
 	if (!req->dst) {
-		gfp_t flags = req->flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
+		gfp_t flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
 
 		/* incompressible data will always be < 2 * slen */
 		req->dlen = 2 * req->slen;
@@ -1619,7 +1619,7 @@ static int iaa_comp_acompress(struct acomp_req *req)
 
 static int iaa_comp_adecompress_alloc_dest(struct acomp_req *req)
 {
-	gfp_t flags = req->flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+	gfp_t flags = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
 		GFP_KERNEL : GFP_ATOMIC;
 	struct crypto_tfm *tfm = req->base.tfm;
 	dma_addr_t src_addr, dst_addr;
-- 
2.39.5

