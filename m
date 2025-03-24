Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7AD2F3E
	for <linux-crypto@vger.kernel.org>; Mon, 24 Mar 2025 03:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742788661; cv=none; b=J9zJ1cCniTbMvcetlv61CyMY59zqFUo+xQHtiBkgA7djHcVQPBsM8kmuJuaKE4c/iIGBwB6tFsp0DIi6k2HPQ+9zSL9vJm2okkXIrN5pdKx7vE5u5POtXndjpodrutoZxRLt/M5PfMIrvypxV5fKUS8KPHhwHJN11Dv5cok1qso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742788661; c=relaxed/simple;
	bh=yjcW1P8MFutzWl6DndlK14kNLMWUA+kzCj+Nwy/z3jk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=I0884ymXuOt6/xONmQlHWnZyi80BrGtoa17Mn/UGy7AIOwVBSMvBiCuqIrlxbPXgAWsSTACcHiR+ouVZY87J9QaYsUqVsqhMosTfEF28+XHxau7kOTn0D2AO7L/7ixH6kYJzJidu8X2DJGQQ0ElgP238kgLNTfFgZfEmVOe61VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=P/lkakeA; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="P/lkakeA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+YBQE/fUp6+VAGFe3DshlpNRcn7JrjS/HpjreCZTSLg=; b=P/lkakeAPABsu/5LHrXdI4hqMY
	y/AonnU4B6iWUhay3snPkDGkBRZhehl6JOwmwtohtEqvTfddZ3zvUJIhKuB9fcE7OS9krjAwIfQi7
	f+BdgBWm/cSFXc9F4LrH3EsrkNE1wWjbe66w0Z72EGOYHk0ztFk9Ayuo4NLNOXOf3yZngoBbu/fwn
	2qwrmOG/eGL33E3KLnHJ11sSEatJj27wnTY+ooTKFkmAiAJ3qHQGVdnKbpphtfWs1MHy3YqJYzYdv
	61IGyCcQ4xq4Gz9cyWmYssAcTosf9X5YkjqcOFgPqhfiu8lDaHIIla49Uw2kQ4BHUzt3pSN3iPEm3
	YiAQKJPg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1twYwO-009abI-2U;
	Mon, 24 Mar 2025 11:57:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 24 Mar 2025 11:57:32 +0800
Date: Mon, 24 Mar 2025 11:57:32 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kristen Accardi <kristen.c.accardi@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH] crypto: iaa - Move compression CRC into request object
Message-ID: <Z-DYLB8B30JOzR1b@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Rather than passing around a CRC between the functions, embed it
into the acomp_request context.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 09d9589f2d68..4240a2e3d375 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1020,8 +1020,7 @@ static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
 static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 			       struct idxd_wq *wq,
 			       dma_addr_t src_addr, unsigned int slen,
-			       dma_addr_t dst_addr, unsigned int *dlen,
-			       u32 compression_crc);
+			       dma_addr_t dst_addr, unsigned int *dlen);
 
 static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 			      enum idxd_complete_type comp_type,
@@ -1087,10 +1086,10 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 	}
 
 	if (ctx->compress && compression_ctx->verify_compress) {
+		u32 *compression_crc = acomp_request_ctx(ctx->req);
 		dma_addr_t src_addr, dst_addr;
-		u32 compression_crc;
 
-		compression_crc = idxd_desc->iax_completion->crc;
+		*compression_crc = idxd_desc->iax_completion->crc;
 
 		ret = iaa_remap_for_verify(dev, iaa_wq, ctx->req, &src_addr, &dst_addr);
 		if (ret) {
@@ -1100,8 +1099,7 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 		}
 
 		ret = iaa_compress_verify(ctx->tfm, ctx->req, iaa_wq->wq, src_addr,
-					  ctx->req->slen, dst_addr, &ctx->req->dlen,
-					  compression_crc);
+					  ctx->req->slen, dst_addr, &ctx->req->dlen);
 		if (ret) {
 			dev_dbg(dev, "%s: compress verify failed ret=%d\n", __func__, ret);
 			err = -EIO;
@@ -1130,11 +1128,11 @@ static void iaa_desc_complete(struct idxd_desc *idxd_desc,
 static int iaa_compress(struct crypto_tfm *tfm,	struct acomp_req *req,
 			struct idxd_wq *wq,
 			dma_addr_t src_addr, unsigned int slen,
-			dma_addr_t dst_addr, unsigned int *dlen,
-			u32 *compression_crc)
+			dma_addr_t dst_addr, unsigned int *dlen)
 {
 	struct iaa_device_compression_mode *active_compression_mode;
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
+	u32 *compression_crc = acomp_request_ctx(req);
 	struct iaa_device *iaa_device;
 	struct idxd_desc *idxd_desc;
 	struct iax_hw_desc *desc;
@@ -1282,11 +1280,11 @@ static int iaa_remap_for_verify(struct device *dev, struct iaa_wq *iaa_wq,
 static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 			       struct idxd_wq *wq,
 			       dma_addr_t src_addr, unsigned int slen,
-			       dma_addr_t dst_addr, unsigned int *dlen,
-			       u32 compression_crc)
+			       dma_addr_t dst_addr, unsigned int *dlen)
 {
 	struct iaa_device_compression_mode *active_compression_mode;
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
+	u32 *compression_crc = acomp_request_ctx(req);
 	struct iaa_device *iaa_device;
 	struct idxd_desc *idxd_desc;
 	struct iax_hw_desc *desc;
@@ -1346,10 +1344,10 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 		goto err;
 	}
 
-	if (compression_crc != idxd_desc->iax_completion->crc) {
+	if (*compression_crc != idxd_desc->iax_completion->crc) {
 		ret = -EINVAL;
 		dev_dbg(dev, "(verify) iaa comp/decomp crc mismatch:"
-			" comp=0x%x, decomp=0x%x\n", compression_crc,
+			" comp=0x%x, decomp=0x%x\n", *compression_crc,
 			idxd_desc->iax_completion->crc);
 		print_hex_dump(KERN_INFO, "cmp-rec: ", DUMP_PREFIX_OFFSET,
 			       8, 1, idxd_desc->iax_completion, 64, 0);
@@ -1496,7 +1494,6 @@ static int iaa_comp_acompress(struct acomp_req *req)
 	dma_addr_t src_addr, dst_addr;
 	int nr_sgs, cpu, ret = 0;
 	struct iaa_wq *iaa_wq;
-	u32 compression_crc;
 	struct idxd_wq *wq;
 	struct device *dev;
 
@@ -1557,7 +1554,7 @@ static int iaa_comp_acompress(struct acomp_req *req)
 		req->dst, req->dlen, sg_dma_len(req->dst));
 
 	ret = iaa_compress(tfm, req, wq, src_addr, req->slen, dst_addr,
-			   &req->dlen, &compression_crc);
+			   &req->dlen);
 	if (ret == -EINPROGRESS)
 		return ret;
 
@@ -1569,7 +1566,7 @@ static int iaa_comp_acompress(struct acomp_req *req)
 		}
 
 		ret = iaa_compress_verify(tfm, req, wq, src_addr, req->slen,
-					  dst_addr, &req->dlen, compression_crc);
+					  dst_addr, &req->dlen);
 		if (ret)
 			dev_dbg(dev, "asynchronous compress verification failed ret=%d\n", ret);
 
@@ -1694,6 +1691,7 @@ static struct acomp_alg iaa_acomp_fixed_deflate = {
 	.init			= iaa_comp_init_fixed,
 	.compress		= iaa_comp_acompress,
 	.decompress		= iaa_comp_adecompress,
+	.reqsize		= sizeof(u32),
 	.base			= {
 		.cra_name		= "deflate",
 		.cra_driver_name	= "deflate-iaa",
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
