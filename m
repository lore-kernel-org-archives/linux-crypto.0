Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326B02F3E
	for <linux-crypto@vger.kernel.org>; Mon, 24 Mar 2025 04:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742789338; cv=none; b=X0UDrfORqDAT9/gAzmij1xGJcAV41jGFMD+G1KlYSOUa8mcQ88Lzuq4f7EZz0it3GZyYwUmg0cQoepXkynkHad2Uzldqm80szIOvJtPshqFm+w42XCxEb1ChKYc+7JPd3h8ldoCrOdyFYisDJjbQJ93b6Fd8bqlAIfFL9jVwTHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742789338; c=relaxed/simple;
	bh=xeyNLPka4KHLGcY/XF1CEdGMnzGyE87csaKYO/g+i2k=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=dU2XcuDa9I02MOFFWBCLLThIdmF9ucyW3C507uUK+HN9Tk56O7I7eeMARdiJO2YZFBUBrOryYHItjmZWvx3NrR1xKn7k+dLIyJoXlHJtdWxLRlbl8TmsenZ7U1yw0flHPJysR6LON5gepuchT2xxfJNqsm/ZNrbM7iwkjeTuEsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=UB+PLiq3; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="UB+PLiq3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1zq+lYieLoBCN6ScmSLGKx72XmKPg5VBUpVkTwaMRyE=; b=UB+PLiq3nTYcu1hyW+HSTsQ6Yi
	1FMMKTt+86YUWNdYS9IVq0Z3/6dOXacLF2FlOQJ7dd5O+PxuPg6vkLjlC2+uWANQk6ELsxbaAijRR
	a4riV3ay/ZeAOmFrlsVXRgM3+Bg/Er0nFygR3HR00R0abILtcBUJgIZESijxWrkls4R9rig68lMaZ
	DkfDxURVnBBeUoneZ+UBp7zAOoVnXTnVoHga++SnP+lR0MrDYGqDwUrXx+LRNi90mLkax+8cV8bBF
	mWK2TFY8LnDmsjV/tCaW1Wt6HRiGCtLM8GrXmO5aCIOzP94zOJ9Bkyl0Kybj3Foee2xM2Yiji4bJp
	y5fIqwcg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1twZ7M-009ahF-02;
	Mon, 24 Mar 2025 12:08:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 24 Mar 2025 12:08:52 +0800
Date: Mon, 24 Mar 2025 12:08:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kristen Accardi <kristen.c.accardi@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH] crypto: iaa - Remove unused disable_async argument from
 iaa_decompress
Message-ID: <Z-Da1Jr6nkWpCVWw@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Remove the disable_async field left over after the NULL dst removal.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 773aab8a8830..aa63df16f20b 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1366,8 +1366,7 @@ static int iaa_compress_verify(struct crypto_tfm *tfm, struct acomp_req *req,
 static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 			  struct idxd_wq *wq,
 			  dma_addr_t src_addr, unsigned int slen,
-			  dma_addr_t dst_addr, unsigned int *dlen,
-			  bool disable_async)
+			  dma_addr_t dst_addr, unsigned int *dlen)
 {
 	struct iaa_device_compression_mode *active_compression_mode;
 	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
@@ -1409,7 +1408,7 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 	desc->src1_size = slen;
 	desc->completion_addr = idxd_desc->compl_dma;
 
-	if (ctx->use_irq && !disable_async) {
+	if (ctx->use_irq) {
 		desc->flags |= IDXD_OP_FLAG_RCI;
 
 		idxd_desc->crypto.req = req;
@@ -1442,7 +1441,7 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 	update_total_decomp_calls();
 	update_wq_decomp_calls(wq);
 
-	if (ctx->async_mode && !disable_async) {
+	if (ctx->async_mode) {
 		ret = -EINPROGRESS;
 		dev_dbg(dev, "%s: returning -EINPROGRESS\n", __func__);
 		goto out;
@@ -1470,7 +1469,7 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 
 	*dlen = req->dlen;
 
-	if (!ctx->async_mode || disable_async)
+	if (!ctx->async_mode)
 		idxd_free_desc(wq, idxd_desc);
 
 	/* Update stats */
@@ -1650,7 +1649,7 @@ static int iaa_comp_adecompress(struct acomp_req *req)
 		req->dst, req->dlen, sg_dma_len(req->dst));
 
 	ret = iaa_decompress(tfm, req, wq, src_addr, req->slen,
-			     dst_addr, &req->dlen, false);
+			     dst_addr, &req->dlen);
 	if (ret == -EINPROGRESS)
 		return ret;
 
-- 
2.39.5

-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
