Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B245F27B4E3
	for <linux-crypto@vger.kernel.org>; Tue, 29 Apr 2025 09:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745917959; cv=none; b=dC+n3hdKSVqCIWK2XUffR9RpS/xYUHOoFHusbnrttYEz303oY/EjG/OWd/HlNaXJ4wx4JTFcHYbKOLexcYl8l0uSnJ7DysF+MtadWyFPVTtNvSs97dt8zNR/LdYoBkH6NE6VIS0QA7FwLVHgwymo4ZUOEHRmNBLg+h/K9U7j1Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745917959; c=relaxed/simple;
	bh=pOS41m5lkMjQzadNx+j41GxqtdZXY/qNBY7dJb1WLds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mke89qZQoFCIAILidMGqrbMF6FJ3ZwpoinLeWIzGJ1j2iOmIYfCz5gAPWvwy6lq4DvTINbylfjHBQlOOljC/5gCRYJVAQ37YTKKAffgfoCwDPHSaVO0gdf+iKgLZ+1NuYcJMpb6GpBG6Q7mV9gFNmSKV49uI/PBNm2Pm2oDzAzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=WE81ZGzA; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="WE81ZGzA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=CqAIMgRGCvQM8g40vZqe+ONpJnCgmmHwbHVpU/epjPk=; b=WE81ZGzARSjsBXwk6xcnmCNa4X
	PFw+bcB3zyQtx3uspBjOI0ikx9VD2/+/qVyLb/GYyANVitoNoz/TD+3Yed+NGUtPDfdV23SRvDQeq
	cqW+EVPMD/ONm3eDqzOI+W2jNwm6v9554NcLZr428LahSKWLLHJ9oDDDJj2UGWRh3D0rat4+nN+6S
	hZVHnTZ4GNsgpHqx3tk4wjZYcCtSKflFWGadpBKQtaz8K3SSvk87fkHGtj1Lh/JU5s+nS60kQA7Sh
	vluY49HdwKpHBKrr1GQ1kbvBUhwEVxlCSVsXwN2zM6PAhdpv49sgCbhDsPfABq2YlFUe2NSysE5E7
	rz/ZuTzA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u9h0w-001tSF-31;
	Tue, 29 Apr 2025 17:12:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 29 Apr 2025 17:12:30 +0800
Date: Tue, 29 Apr 2025 17:12:30 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: Ingo Franzki <ifranzki@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: s390/sha512 - Fix sha512 state size
Message-ID: <aBCX_l0kSHVx4xQn@gondor.apana.org.au>
References: <632df0c6adc88f82d27bbabcc3fc6d7f@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <632df0c6adc88f82d27bbabcc3fc6d7f@linux.ibm.com>

On Tue, Apr 29, 2025 at 10:57:38AM +0200, Harald Freudenberger wrote:
> Hello Herbert
> since commit 572b5c4682c7 "crypto: s390/sha512 - Use API partial block
> handling"
> all CI tests related to sha kernel modules on the next kernel fail.

Thanks for catching this!

>  struct s390_sha_ctx {
>  	u64 count;		/* message length in bytes */
> -	u32 state[CPACF_MAX_PARMBLOCK_SIZE / sizeof(u32)];
> +	union {
> +		u32 state[CPACF_MAX_PARMBLOCK_SIZE / sizeof(u32)];
> +		struct {
> +			u64 state[SHA512_DIGEST_SIZE];                  <- really big
> +			u64 count_hi;
> +		} sha512;
> +	};

I was trying to keep this thing from growing over the 360 limit,
hence the union.

Instead I managed to make it go over the limit spectacularly :)

---8<---
The sha512 state size in s390_sha_ctx is out by a factor of 8,
fix it so that it stays below HASH_MAX_DESCSIZE.  Also fix the
state init function which was writing garbage to the state.  Luckily
this is not actually used for anything other than export.

Reported-by: Harald Freudenberger <freude@linux.ibm.com>
Fixes: 572b5c4682c7 ("crypto: s390/sha512 - Use API partial block handling")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/s390/crypto/sha.h b/arch/s390/crypto/sha.h
index 0a3cc1739144..d757ccbce2b4 100644
--- a/arch/s390/crypto/sha.h
+++ b/arch/s390/crypto/sha.h
@@ -24,7 +24,7 @@ struct s390_sha_ctx {
 	union {
 		u32 state[CPACF_MAX_PARMBLOCK_SIZE / sizeof(u32)];
 		struct {
-			u64 state[SHA512_DIGEST_SIZE];
+			u64 state[SHA512_DIGEST_SIZE / sizeof(u64)];
 			u64 count_hi;
 		} sha512;
 	};
diff --git a/arch/s390/crypto/sha512_s390.c b/arch/s390/crypto/sha512_s390.c
index 14818fcc9cd4..3c5175e6dda6 100644
--- a/arch/s390/crypto/sha512_s390.c
+++ b/arch/s390/crypto/sha512_s390.c
@@ -22,13 +22,13 @@ static int sha512_init(struct shash_desc *desc)
 	struct s390_sha_ctx *ctx = shash_desc_ctx(desc);
 
 	ctx->sha512.state[0] = SHA512_H0;
-	ctx->sha512.state[2] = SHA512_H1;
-	ctx->sha512.state[4] = SHA512_H2;
-	ctx->sha512.state[6] = SHA512_H3;
-	ctx->sha512.state[8] = SHA512_H4;
-	ctx->sha512.state[10] = SHA512_H5;
-	ctx->sha512.state[12] = SHA512_H6;
-	ctx->sha512.state[14] = SHA512_H7;
+	ctx->sha512.state[1] = SHA512_H1;
+	ctx->sha512.state[2] = SHA512_H2;
+	ctx->sha512.state[3] = SHA512_H3;
+	ctx->sha512.state[4] = SHA512_H4;
+	ctx->sha512.state[5] = SHA512_H5;
+	ctx->sha512.state[6] = SHA512_H6;
+	ctx->sha512.state[7] = SHA512_H7;
 	ctx->count = 0;
 	ctx->sha512.count_hi = 0;
 	ctx->func = CPACF_KIMD_SHA_512;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
