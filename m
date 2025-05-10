Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C17248F6B;
	Sat, 10 May 2025 10:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746873819; cv=none; b=A8a9+W8jFDhHXx1O6HmeKGv4e1iMdqvRmB9zRPE003svHNGCdEVsl1sFHp8rSf80W/ojwipzm7MPzBVczXM95wnD02MOJkpyaNOa+OHXxkS1uUf/a34yCcTYxOOYcHrDFR2/VNSmhHR6V7ksY99SYq7h6tkxPqzUBlnP37Gj4/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746873819; c=relaxed/simple;
	bh=1oy3SsohnsYZWsa5+4Bgq+YIdKGGm3H3KiT3X3aotZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eiIqvK6h4vU0vi3/K5B2/MDGlJA/xCPLs+QKjHWDQi2CuzN5bzpsoSMGgDCulRCB2V0UbR6QP54MmNVYrV+zTeqwwCEdPZNvMb7RJe60G1STfPrrBD60dSw+3OO/7clkjJbfbrZs/L80wzAE7AJ/JHXfu95Bss+wXG+ZE0OdRAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=VfBupHh9; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="VfBupHh9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=drL9CihMKcOCko6hTyh3ech3ays1rYq5AHHwS/TAOtU=; b=VfBupHh9JfFii+Zu0bbNDK0CDX
	SI2982ZoZoYPH7DdyAKb8rfJot0DaZoN+J12HJWXbq17P58GJ++Kn1gFDU4JuK0Vds7Uq/t0qwG8b
	bd7THmPfCnevsUvicQvDMOS7R5H5eBlPrG2CERqRFATXdSD1kSgvJFQ553Gl045+N8Kdxq4iwKVk6
	WlZeEBVtFGJf5IiUbxQ+3JcJLkTkc5CfJBYOTnPWqORDoytdWs3K+6X/SbrP/FHx/FgQjTjge0vPM
	MSq7ddnz2yHTT4JxL1vPj+iw5rn/O7FE9itNZ82vSeifTdl3P2QmfjyerDzR/r5LqPahLDfATfsAi
	iNpN1XTg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uDhg5-0053Po-1Q;
	Sat, 10 May 2025 18:43:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 10 May 2025 18:43:33 +0800
Date: Sat, 10 May 2025 18:43:33 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Klaus Kudielka <klaus.kudielka@gmail.com>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>, regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Boris Brezillon <bbrezillon@kernel.org>,
	EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>,
	Romain Perier <romain.perier@gmail.com>
Subject: [PATCH] crypto: marvell/cesa - Avoid empty transfer descriptor
Message-ID: <aB8t1ZTVBexqGlcm@gondor.apana.org.au>
References: <5db212655dc98945fa3f529925821879a03ff554.camel@gmail.com>
 <Zw9AsgqKHJfySScx@gondor.apana.org.au>
 <aBoMSHEMYj6FbH8o@gondor.apana.org.au>
 <aBsdTJUAcQgW4ink@gondor.apana.org.au>
 <aBt5Mxq1MeefwXGJ@Red>
 <aBw-C_krkNsIoPlT@gondor.apana.org.au>
 <aBw_iC_4okpiKglQ@gondor.apana.org.au>
 <dd55ba91a5aebce0e643cab5d57e4c87a006600f.camel@gmail.com>
 <aB8W4iuvjvAZSJoc@gondor.apana.org.au>
 <41680c5d41ed568e8c65451843e3ff212fd340c4.camel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41680c5d41ed568e8c65451843e3ff212fd340c4.camel@gmail.com>

On Sat, May 10, 2025 at 11:38:16AM +0200, Klaus Kudielka wrote:
>
> Patch applied on top.
> On the first attempt all self-tests passed, but on the second and third unfortunately not.

This patch fixes the extra zero-length TDMA descriptor, which even
if it doesn't fix the problem, is obviously the right thing to do.

---8<---
The user may set req->src even if req->nbytes == 0.  If there
is no data to hash from req->src, do not generate an empty TDMA
descriptor.

Fixes: db509a45339f ("crypto: marvell/cesa - add TDMA support")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/marvell/cesa/hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index a46ae868110a..2200bc6a034f 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -650,7 +650,7 @@ static int mv_cesa_ahash_dma_req_init(struct ahash_request *req)
 	if (ret)
 		goto err_free_tdma;
 
-	if (iter.src.sg) {
+	if (iter.base.len > iter.src.op_offset) {
 		/*
 		 * Add all the new data, inserting an operation block and
 		 * launch command between each full SRAM block-worth of
-- 
2.39.5

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
