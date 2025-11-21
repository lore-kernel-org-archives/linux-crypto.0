Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568711E8320;
	Fri, 21 Nov 2025 05:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763703374; cv=none; b=tZdGDppSuCyMw7lBfA3IiH5dxFtBKc/e2gqHFQau9xjNrVJ5Rc3FtfkThW8faBNoQwZO1rPD/ztpZMAFYUlKBLkecrH/GIWpLuNC/mr18CIPNMJUgunR1y3pOCvwuRVwI38snLs/g3PtAsPNMXl0SV43du79yPo29f83aq0cnkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763703374; c=relaxed/simple;
	bh=53IhcEdfFuiYzTIJBavilezp4bcGaJDD6Lvamu1jip0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZbXpP96gUs/GXtjQhPICQC8prqbZaAUfXUhRz8eOLSJldQUPeyJ1UPDl8AfQMuUjE/kt8Z4dc4qmzlYmSbV8Db56BpTttSIBL2FE7il3GaAfMcewwPBBN4XVSGUGQfnExXkBWsA4ZF7Qcy5/U6p/IrqzHviZj3dMsyL1zws1ICs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=C4LLt3Gj; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="C4LLt3Gj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=P5qtzTLhg50TMI2c6Ok/0M02h/+vZsTcvGUwwKFHkxA=; 
	b=C4LLt3GjVuW4nKW5Vd4vgIZjXNx00GvfoO3m0nbnFLaSBpBbwCwADsJSaseXsRk0Ja4krP5EpnI
	UGzLdE8yoU8i1mWa0x6qBKoZibsvF+BzfALBuy9LgIRjtMFgYGExWqDczP4jOLH1qwOAjbpRcTjEC
	i5xEEIvOjtHIIrIixPZ/W2cTXbjHzFxO/4yv5lRKaswwv7muBPNr0nY1pY0nIm2sI4Zlsk2ssXRhr
	XorUVNZflX5iRvM+1/J/q5x0EO8YCLYQ/ktHf3m5sO+xZJi9hjeY4uhheuFYG0e/pv+cIoqtfBVnQ
	WYcM3Qw49vw6QYzMSIj6F3L1sTuUzB4FLSEQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vMJoR-004rgB-2f;
	Fri, 21 Nov 2025 13:36:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Nov 2025 13:36:03 +0800
Date: Fri, 21 Nov 2025 13:36:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Manorit Chawdhry <m-chawdhry@ti.com>,
	Shiva Tripathi <s-tripathi1@ti.com>
Subject: [PATCH] crypto: ahash - Fix crypto_ahash_import with partial block
 data
Message-ID: <aR_6Q4yjEzsQvm4c@gondor.apana.org.au>
References: <20251113140634.1559529-1-t-pratham@ti.com>
 <20251113140634.1559529-2-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113140634.1559529-2-t-pratham@ti.com>

On Thu, Nov 13, 2025 at 07:30:12PM +0530, T Pratham wrote:
>
> diff --git a/crypto/ahash.c b/crypto/ahash.c
> index dfb4f5476428f..9510bdeda51de 100644
> --- a/crypto/ahash.c
> +++ b/crypto/ahash.c
> @@ -674,10 +674,12 @@ int crypto_ahash_import(struct ahash_request *req, const void *in)
>         if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
>                 return -ENOKEY;
>         if (crypto_ahash_block_only(tfm)) {
> +               unsigned int plen = crypto_ahash_blocksize(tfm) + 1;
>                 unsigned int reqsize = crypto_ahash_reqsize(tfm);
> +               unsigned int ss = crypto_ahash_statesize(tfm);
>                 u8 *buf = ahash_request_ctx(req);
>  
> -               buf[reqsize - 1] = 0;
> +               memcpy(buf + reqsize - plen, in + ss - plen, plen);
>         }
>         return crypto_ahash_alg(tfm)->import(req, in);
>  }
> 
> Is there any particular reason why import is like how it is currently? As per
> my understanding import should reverse whatever export is doing and vice-versa.

Thanks, you're right that this is broken.

The zeroing of the partial block buffer should be in import_core
instead of import.

---8<---
Restore the partial block buffer in crypto_ahash_import by copying
it.  Check whether the partial block buffer exceeds the maximum
size and return -EOVERFLOW if it does.

Zero the partial block buffer in crypto_ahash_import_core.

Reported-by: T Pratham <t-pratham@ti.com>
Fixes: 9d7a0ab1c753 ("crypto: ahash - Handle partial blocks in API")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/ahash.c b/crypto/ahash.c
index dfb4f5476428..819b484a1a00 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -661,6 +661,12 @@ int crypto_ahash_import_core(struct ahash_request *req, const void *in)
 						in);
 	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		return -ENOKEY;
+	if (crypto_ahash_block_only(tfm)) {
+		unsigned int reqsize = crypto_ahash_reqsize(tfm);
+		u8 *buf = ahash_request_ctx(req);
+
+		buf[reqsize - 1] = 0;
+	}
 	return crypto_ahash_alg(tfm)->import_core(req, in);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_import_core);
@@ -674,10 +680,14 @@ int crypto_ahash_import(struct ahash_request *req, const void *in)
 	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		return -ENOKEY;
 	if (crypto_ahash_block_only(tfm)) {
+		unsigned int plen = crypto_ahash_blocksize(tfm) + 1;
 		unsigned int reqsize = crypto_ahash_reqsize(tfm);
+		unsigned int ss = crypto_ahash_statesize(tfm);
 		u8 *buf = ahash_request_ctx(req);
 
-		buf[reqsize - 1] = 0;
+		memcpy(buf + reqsize - plen, in + ss - plen, plen);
+		if (buf[reqsize - 1] >= plen)
+			return -EOVERFLOW;
 	}
 	return crypto_ahash_alg(tfm)->import(req, in);
 }
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
