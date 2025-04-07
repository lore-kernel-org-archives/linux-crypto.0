Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA56230BDA
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 10:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744021265; cv=none; b=BRAIwlSWihruQBUqY2KAyA7nFV8TC/1+xOBAS4NQClJteTy6WRCd2YB31/ov6v0KNoM37bT4WbJPqVOMM223X4WJLnxURLhLKViMB7ogZpgNd6ikVr81ICnv+1q9S6Hl5TuYUHo/Fuajj1LJjsF+IvvQT2IxPM07jEwU6dcamuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744021265; c=relaxed/simple;
	bh=/T9GgtkPTCnx/4d2Z+wY7oIgoTNPALu+0RukcObwAzI=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=soWRs4y1e4E8NgX5DH7wZYkOWlQw+xSFTKqGOppqe0cxBKZeolcY1dATX3FZv+Afes/BDR3cN33T4/DqjdOPUD3uzf/RVbds7igjqFu6qChCBXhIOh2nAdWhjBX31u3tpDdQ8T8ik+8wkw1FvCSt+arUaG2eUBWY9x1wehGAiaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=gs9mq85r; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="gs9mq85r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mZwzS+grlNdgXUZLUiRtMcjlF4qMaIDgjgj3lwItU7Q=; b=gs9mq85r8IUC94lGS8ppUTBAH5
	MAQ47ir2yj6+7Gs7FsxaXUtldDTNS59bZrnDyUk+GRv8vZHpB23NH4Avwkcvt648Tc59Yd/TiKsb9
	Gvw42WRrXWy+//a5Ad2tgwsA5aXwr/wOam2LoLMh34t4FMGwbkRN6mBY+n+zFsdEPYbYe3NxW3r1F
	hMkaGq5DCpxn/Zllaeja6cGsF54tb6NdoDic/N+kOlRhkt3/VOL89kYxoQC7fKc7PyHteu8HB6ehr
	MZdpWG2Bpl68YTPKmBhIrwMYWq64NVKcJJpFCTAH6yQKsboxEyS4fJgnysXikn0ygphGL1qyC1lcy
	ja9JbORg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1jb9-00DTZC-2a;
	Mon, 07 Apr 2025 18:21:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 18:20:59 +0800
Date: Mon, 07 Apr 2025 18:20:59 +0800
Message-Id: <658b1db49fa1968d6e88fc178b8e5c757971f13c.1744021074.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744021074.git.herbert@gondor.apana.org.au>
References: <cover.1744021074.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/7] crypto: api - Add reqsize to crypto_alg
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add a reqsize field to crypto_alg with the intention of replacing
the type-specific reqsize field currently used by ahash and acomp.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 include/linux/crypto.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 56cf229e2530..15476b085ce3 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -276,6 +276,7 @@ struct cipher_alg {
  *		   to the alignmask of the algorithm being used, in order to
  *		   avoid the API having to realign them.  Note: the alignmask is
  *		   not supported for hash algorithms and is always 0 for them.
+ * @cra_reqsize: Size of the request context for this algorithm.
  * @cra_priority: Priority of this transformation implementation. In case
  *		  multiple transformations with same @cra_name are available to
  *		  the Crypto API, the kernel will use the one with highest
@@ -322,6 +323,7 @@ struct crypto_alg {
 	unsigned int cra_blocksize;
 	unsigned int cra_ctxsize;
 	unsigned int cra_alignmask;
+	unsigned int cra_reqsize;
 
 	int cra_priority;
 	refcount_t cra_refcnt;
@@ -441,6 +443,11 @@ static inline unsigned int crypto_tfm_alg_alignmask(struct crypto_tfm *tfm)
 	return tfm->__crt_alg->cra_alignmask;
 }
 
+static inline unsigned int crypto_tfm_alg_reqsize(struct crypto_tfm *tfm)
+{
+	return tfm->__crt_alg->cra_reqsize;
+}
+
 static inline u32 crypto_tfm_get_flags(struct crypto_tfm *tfm)
 {
 	return tfm->crt_flags;
-- 
2.39.5

