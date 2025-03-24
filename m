Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416DA53BE
	for <linux-crypto@vger.kernel.org>; Mon, 24 Mar 2025 04:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742789065; cv=none; b=Nq7ij+toHfBwZLlAHw2RKamjBUne+UUzBac/69MwnU8h5pAQCeAH5L2S2lfq+3Z6HnfJ4GcbpkHgfzXUdSkRINSHYXqcx7R/O656kOGbRKrUV6VgKAKUCO3d9/ZwXUVbrhntlRQbcSMpE4KRfUytoM/UisckAxu2bU/+z4HutGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742789065; c=relaxed/simple;
	bh=i/ICmjiZsylDfiGXiepdQP7i2p+nPg3l28HT5qRegYw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=g5NLHSjFd4/EdUBYrGoAwHOeuEzG8tcqCCs3Il9T39cfUleoWpmco1yvR/mTSuWHjWaPGC95TE50rGIZ1GstYqwiUdxkqOslbgvwecKU/66xNYnudNN2GWRA/YPUhczFFSBqR/kxv8BeD1qLRFNK6m75jxEdKwL1/AuQ+5FPi/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=fNKtjfln; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="fNKtjfln"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=f6PObSNB+tz+dnHx4y1CyZwWSMPLz6n4KJRAGdgM4Rw=; b=fNKtjflnWNGrDOMdV+hYsE8L0x
	7vKeacEhKEvoNyJ20T6EpeHUDeGrHUoIkXSKEtl+6jpihkH+Plgm5gJkhgsk4DNpP8cZG/halUjcg
	NBJq2bTPj5sDKgp7mn7+WKtcS+GVKbYA1G14zDGZ+nLPpaFi8wF4zfZF6/hVwR/G7XzI5KFY3+sAK
	+rBY2f9E7L8i9Xg0AAdx4stqaNF5q0/b6ZgqgFPGGEvBAKMHnIzvngZ+klqWGkIcLUkkuBLepHDop
	Ud2VEtrbpMvJBdJ2ZFRX59kWJhPWrGWo8tSiZGpSldgBWo0cgaKc5ExfOUSf5R/nJ+ja6WLwqCkAN
	5NdZhZ0w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1twZ2w-009adD-2o;
	Mon, 24 Mar 2025 12:04:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 24 Mar 2025 12:04:18 +0800
Date: Mon, 24 Mar 2025 12:04:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kristen Accardi <kristen.c.accardi@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH] crypto: iaa - Do not clobber req->base.data
Message-ID: <Z-DZwqLEbquS70gg@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The req->base.data field is for the user and must not be touched by
the driver, unless you save it first.

The iaa driver doesn't seem to be using the req->base.data value
so just remove the assignment.

Fixes: 09646c98d0bf ("crypto: iaa - Add irq support for the crypto async interface")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 09d9589f2d68..33a285981dfd 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1187,8 +1187,7 @@ static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 			" src_addr %llx, dst_addr %llx\n", __func__,
 			active_compression_mode->name,
 			src_addr, dst_addr);
-	} else if (ctx->async_mode)
-		req->base.data = idxd_desc;
+	}
 
 	dev_dbg(dev, "%s: compression mode %s,"
 		" desc->src1_addr %llx, desc->src1_size %d,"
@@ -1425,8 +1424,7 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 			" src_addr %llx, dst_addr %llx\n", __func__,
 			active_compression_mode->name,
 			src_addr, dst_addr);
-	} else if (ctx->async_mode && !disable_async)
-		req->base.data = idxd_desc;
+	}
 
 	dev_dbg(dev, "%s: decompression mode %s,"
 		" desc->src1_addr %llx, desc->src1_size %d,"
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
