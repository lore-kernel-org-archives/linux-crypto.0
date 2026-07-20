Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D5313E02A
	for <linux-crypto@vger.kernel.org>; Mon, 20 Jul 2026 22:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784586864; cv=none; b=AHGGD+q4J3d0eDA4lSkHXNe56+nJCfaWXVdPHsnGwkLfAnpg+fU+DHV+Sy5g07b6w0drnILzSG1tGBH0fYVuJ+9NkqM3J3hVO1RTjoXf27ZXA3Lp9fDGQjqUC6rwLQst5zRuJt4LjSmTOV+JeopUleaDsNQmy7lGF54AiwXBpVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784586864; c=relaxed/simple;
	bh=rdGvS+HNfZ40WYAYo7qNh/Z7CVyix7+Kosk6SECyIfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUxFS4K5LyIEv8HJFF7CXdNZ3cvkateLUN+CEvltld8fByVKvab9997ftDm+kYbeQhdf3QVjY11mg7lR8e6G827c4KFTRMLq2FsR2e6fDKJeDsFR+m4v8rt6rEh0VbIPqI0hfnFTz3IX4YMEy+pkRaIbUqvc4xly+yjGIPAkZXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hQgrRBWM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hQgrRBWM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784586861;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wgcia35GYcmtPGaPSc0D2gTSMPc2NgUDFNh7MO/Uu9o=;
	b=hQgrRBWM78/pwZV+dMLIoV2urDHaOvImx3Vuj0j1oD8aMXo1qd9DGsoq/t7+jLF+HzUthX
	E/kXgbqZL974+F8aEF+DA7EyKVn7m1FssI6gSGLCT2RCZna7C73OIr+XUqAwrIXEw0F+sL
	xh+zcBL6Vum21zu+gk4EU45mozS1U24=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-96-YnbT-VqON8aPsQhHk7CjRg-1; Mon,
 20 Jul 2026 18:34:17 -0400
X-MC-Unique: YnbT-VqON8aPsQhHk7CjRg-1
X-Mimecast-MFC-AGG-ID: YnbT-VqON8aPsQhHk7CjRg_1784586856
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B736A1977008;
	Mon, 20 Jul 2026 22:34:15 +0000 (UTC)
Received: from rules.brq.redhat.com (unknown [10.44.24.15])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CA9FE180044F;
	Mon, 20 Jul 2026 22:34:11 +0000 (UTC)
From: Vladislav Dronov <vdronov@redhat.com>
To: Akhil R <akhilrajeev@nvidia.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thierry Reding <thierry.reding@kernel.org>,
	Jonathan Hunter <jonathanh@nvidia.com>
Cc: linux-crypto@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	vdronov@redhat.com
Subject: [PATCH v2] crypto: tegra - fix rctx->cryptlen calculation in tegra_gcm_do_one_req()
Date: Tue, 21 Jul 2026 00:33:31 +0200
Message-ID: <20260720223331.404050-1-vdronov@redhat.com>
In-Reply-To: <al135EQMcdtTnHxZ@gondor.apana.org.au>
References: <al135EQMcdtTnHxZ@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Perform rctx->cryptlen calculation in tegra_gcm_do_one_req() the same way
it is done in tegra_ccm_crypt_init(). The current formulae may lead to a
crash if a caller does not call tegra_gcm_setauthsize() and so ctx->authsize
remains zero. Then a decrypt operation with incorrect rctx->cryptlen will
lead to a write beyound rctx->dst_sg buffer.

As a follow-up cleanup delete struct tegra_aead_ctx->authsize field since
it appears to be completely unused. Also simplify tegra_ccm_setauthsize()
and tegra_gcm_setauthsize() functions respectively.

Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Signed-off-by: Vladislav Dronov <vdronov@redhat.com>
---
 drivers/crypto/tegra/tegra-se-aes.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index 9094c03e991f6..0fd1d70358996 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -45,7 +45,6 @@ struct tegra_aes_reqctx {
 
 struct tegra_aead_ctx {
 	struct tegra_se *se;
-	unsigned int authsize;
 	u32 alg;
 	u32 key_id;
 	u32 keylen;
@@ -1290,7 +1289,7 @@ static int tegra_gcm_do_one_req(struct crypto_engine *engine, void *areq)
 	if (rctx->encrypt)
 		rctx->cryptlen = req->cryptlen;
 	else
-		rctx->cryptlen = req->cryptlen - ctx->authsize;
+		rctx->cryptlen = req->cryptlen - rctx->authsize;
 
 	memcpy(rctx->iv, req->iv, GCM_AES_IV_SIZE);
 	rctx->iv[3] = (1 << 24);
@@ -1394,8 +1393,6 @@ static int tegra_aead_cra_init(struct crypto_aead *tfm)
 
 static int tegra_ccm_setauthsize(struct crypto_aead *tfm,  unsigned int authsize)
 {
-	struct tegra_aead_ctx *ctx = crypto_aead_ctx(tfm);
-
 	switch (authsize) {
 	case 4:
 	case 6:
@@ -1404,28 +1401,15 @@ static int tegra_ccm_setauthsize(struct crypto_aead *tfm,  unsigned int authsize
 	case 12:
 	case 14:
 	case 16:
-		break;
+		return 0;
 	default:
 		return -EINVAL;
 	}
-
-	ctx->authsize = authsize;
-
-	return 0;
 }
 
 static int tegra_gcm_setauthsize(struct crypto_aead *tfm,  unsigned int authsize)
 {
-	struct tegra_aead_ctx *ctx = crypto_aead_ctx(tfm);
-	int ret;
-
-	ret = crypto_gcm_check_authsize(authsize);
-	if (ret)
-		return ret;
-
-	ctx->authsize = authsize;
-
-	return 0;
+	return crypto_gcm_check_authsize(authsize);
 }
 
 static void tegra_aead_cra_exit(struct crypto_aead *tfm)
-- 
2.47.3

