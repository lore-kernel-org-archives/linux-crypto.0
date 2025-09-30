Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D572F39C3;
	Tue, 30 Sep 2025 08:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759219762; cv=none; b=WtNyspSc1HaWXNadpOJyFFzbDx0/zikp3sSU35M2Fl6MJ4+eOBdVIg7pQNtKoEl2KI/fIQbXp+/1Mc0iIB2zUWEKsAIoUFcjD7TycrzMIF3M1bkv2bTEmuL0fml4TVhFc5jNLQHMbxCcp5Vafq5TZEJdEUdcd9akp6J/C2adcP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759219762; c=relaxed/simple;
	bh=Py3yCoAGUCq2pdjLCRrdHxYGxN1ZVdhsZCQ4ahkBGvM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XxKrjHYTkYNKFFo6uJIkr9tF3hb9RY5/Bvsf80kqcwy2FiUDXXwWacVXkuvON3MVn8A3A7eDqHlw1dKq9q5q3LgoOUoLj0K+8sA5lU1GDTdo2tHCvD6g6T1/HaBJFCh3Idy+uEIvjkoqPIQXyzSQY1qszpIRdd7Uh7/697U2y9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=OUoPEgaY; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="OUoPEgaY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:MIME-Version:References:Message-ID:Subject:Cc:To:
	From:Date:cc:to:subject:message-id:date:from:reply-to;
	bh=SNl+JjIRM7qiedHpV2E5vW8Z43H70pcL9HXRcwW98v8=; b=OUoPEgaY2Om8Dxww/thydnKrAA
	UPck2JTT4NJ/82oH9tlSHFmZ6IKJbS8qyAIbgzWdk7Oel1UoTvj/N5uJmRsP9MZAzrwQRTarHgugZ
	AOHtaGmT1ArzuycdwrH1Lb+0/bvLOnCmnPvAyZFwUHrc1doFgskyKFwDXdGEDvm9jGA2roNRgA6a9
	D8YTkVVNKbhplJQjDaKxxdILtf7MiMhqA2NHDUrMrrBAMnmpfPWsWzThFYjtfAZ54BJCI4u3wvBPd
	WFkPBq9S012jMzeZVro7+GE4HsCXO4/62UHJm93vAetQG+/Jgv/dvNjV1Uoc2qxqba0lhIGRwFXij
	nOv63TSw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v3VPW-009OTT-26;
	Tue, 30 Sep 2025 16:08:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 30 Sep 2025 16:08:34 +0800
Date: Tue, 30 Sep 2025 16:08:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Han Xu <han.xu@nxp.com>
Cc: "suman.kumar.chakraborty@intel.com" <suman.kumar.chakraborty@intel.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"terrelln@fb.com" <terrelln@fb.com>,
	"dsterba@suse.com" <dsterba@suse.com>,
	Richard Weinberger <richard@nod.at>,
	"chengzhihao1@huawei.com" <chengzhihao1@huawei.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:MEMORY TECHNOLOGY DEVICES (MTD)" <linux-mtd@lists.infradead.org>,
	"imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: [PATCH] crypto: zstd - Fix compression bug caused by truncation
Message-ID: <aNuQAr79Hdky3WII@gondor.apana.org.au>
References: <GV1PR04MB9071B5AC95DBD48B67FACF44971BA@GV1PR04MB9071.eurprd04.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <GV1PR04MB9071B5AC95DBD48B67FACF44971BA@GV1PR04MB9071.eurprd04.prod.outlook.com>

On Mon, Sep 29, 2025 at 11:51:36PM +0000, Han Xu wrote:
> Hi Suman,
> 
> The patch f5ad93ffb5411 "crypto: zstd - convert to acomp"
> leads to the following kernel dump during UBIFS write back.

Thanks for the detailed report and instructions!

Please let me know if you still get the crash with this patch:

---8<---
Use size_t for the return value of zstd_compress_cctx as otherwise
negative errors will be truncated to a positive value.

Reported-by: Han Xu <han.xu@nxp.com>
Fixes: f5ad93ffb541 ("crypto: zstd - convert to acomp")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/zstd.c b/crypto/zstd.c
index c2a19cb0879d..ac318d333b68 100644
--- a/crypto/zstd.c
+++ b/crypto/zstd.c
@@ -83,7 +83,7 @@ static void zstd_exit(struct crypto_acomp *acomp_tfm)
 static int zstd_compress_one(struct acomp_req *req, struct zstd_ctx *ctx,
 			     const void *src, void *dst, unsigned int *dlen)
 {
-	unsigned int out_len;
+	size_t out_len;
 
 	ctx->cctx = zstd_init_cctx(ctx->wksp, ctx->wksp_size);
 	if (!ctx->cctx)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
