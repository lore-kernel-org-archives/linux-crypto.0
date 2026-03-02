Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9397345CA0
	for <linux-crypto@vger.kernel.org>; Mon,  2 Mar 2026 11:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772451330; cv=none; b=lr3ku0aXHfNUsZty82HBZtMWBuPMEkzRyqu+8LEEWMIiBDfaEwPvbkLrL+7gTjecfZxj2xg8aAHsIQ6obHI3eg2qdw/Pwu5eXhgOlN5zzHUzsaVSr1w1C/5v1EbdmCaWRyKIDTGnH+2a82w+JnOWYAfIYTctoqlTBRXFbn98WW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772451330; c=relaxed/simple;
	bh=uZGhgmgY/szr/GX6ytm1P8SBL355y+ixAQH0XTZooKY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QWnwKea7p77cQJHYEJl61b0ZeEC3nhhppLC8LR26beUlSsZDgt44PVq6AqVB32pJ2jB8IbSZuvBpPSvP76+GiZSjY76FT++IQp2LEZr2GupEg2JS3QQPZxwiJjAy9SpujZci/2zvc5WvdvrWcoCjPrd1rBB0+11ZHIW5eYhEuFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=n98X3Sgk; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="n98X3Sgk"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772451316;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=x8ZpHLE2DRQLPnRzyw4GcR84TR9av1pRIf3eL+I1eqE=;
	b=n98X3SgkBiMc3l6BBSzaTwypSynKYS+uy42RXkskKRtfS9ifkfKCKqMWFWzeNL0CiRNBAz
	Rdm1L9/1yV0Y3MnobMwN0p/bYt9eGNrdGWTPnloHmJJwC62Hm62IeZhBBSaA82zmIzRc6Z
	ucz7pOPu9hVUVIY89Q+RXprMlp/SXy8=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Thara Gopinath <thara.gopinath@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: qce - Remove return variable and unused assignments
Date: Mon,  2 Mar 2026 12:34:53 +0100
Message-ID: <20260302113453.938998-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

In qce_aead_done(), the return variable 'ret' is no longer used - remove
it. And qce_aead_prepare_dst_buf() jumps directly to 'dst_tbl_free:' on
error and returns 'sg' - drop the useless 'ret' assignments.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/qce/aead.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
index 97b56e92ea33..67a87a7d6abd 100644
--- a/drivers/crypto/qce/aead.c
+++ b/drivers/crypto/qce/aead.c
@@ -35,7 +35,6 @@ static void qce_aead_done(void *data)
 	u32 status;
 	unsigned int totallen;
 	unsigned char tag[SHA256_DIGEST_SIZE] = {0};
-	int ret = 0;
 
 	diff_dst = (req->src != req->dst) ? true : false;
 	dir_src = diff_dst ? DMA_TO_DEVICE : DMA_BIDIRECTIONAL;
@@ -79,8 +78,7 @@ static void qce_aead_done(void *data)
 	} else if (!IS_CCM(rctx->flags)) {
 		totallen = req->cryptlen + req->assoclen - ctx->authsize;
 		scatterwalk_map_and_copy(tag, req->src, totallen, ctx->authsize, 0);
-		ret = memcmp(result_buf->auth_iv, tag, ctx->authsize);
-		if (ret) {
+		if (memcmp(result_buf->auth_iv, tag, ctx->authsize)) {
 			pr_err("Bad message error\n");
 			error = -EBADMSG;
 		}
@@ -144,16 +142,12 @@ qce_aead_prepare_dst_buf(struct aead_request *req)
 
 		sg = qce_sgtable_add(&rctx->dst_tbl, &rctx->adata_sg,
 				     rctx->assoclen);
-		if (IS_ERR(sg)) {
-			ret = PTR_ERR(sg);
+		if (IS_ERR(sg))
 			goto dst_tbl_free;
-		}
 		/* dst buffer */
 		sg = qce_sgtable_add(&rctx->dst_tbl, msg_sg, rctx->cryptlen);
-		if (IS_ERR(sg)) {
-			ret = PTR_ERR(sg);
+		if (IS_ERR(sg))
 			goto dst_tbl_free;
-		}
 		totallen = rctx->cryptlen + rctx->assoclen;
 	} else {
 		if (totallen) {
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

