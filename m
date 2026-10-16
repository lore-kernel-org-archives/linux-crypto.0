Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2011F3939A9;
	Fri, 16 Oct 2026 02:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.194.254.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792116668; cv=none; b=rRBRgMvplTzkHI03+OoYIkCo3ClCY9053XmgsaOn8Rb04D4lJSx1jnE8O5fVkMxE8DkGwMuMc/7TX7KggYjXxGkTZ7WU4wDNB8GSjpV3Vih6P1Geqb5Q/gZbJd6W4xyXzUGMgJ+7VhHcfH16PuCyheciX0JVepWdHn0K5iKMcDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792116668; c=relaxed/simple;
	bh=hl8pKbwVlYBx6OrPid0iwr1adSPzZWVHUwkOaviPQgk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kIYDmCwshMhZUv6IEXcTUPXl/NUA4iMabDZOIyRfdtYr6UyZVw5ynrHyLdbk3Sz6jYO8S7BjqtoRZXqUv18HTLVKXDvu0J35ppC25zlvRodx2Yb35in4uxTLk+N1bIk5ksBSmFFq6M27ef0ZT9OkUM4biYeniJjrWKHbP9M2xYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=E32CjZ8r; arc=none smtp.client-ip=18.194.254.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="E32CjZ8r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1792116613;
	bh=8osGWg0ilv6J76JQLDUU7vDPE8TuX7X5EONtGKZSgfo=;
	h=From:Date:Subject:MIME-Version:Message-Id:To;
	b=E32CjZ8rUpUoYox5gwdJGjMoCY3rfiOzK/2qexQmQyODOifnsB4e+bkX6DImz5Pmp
	 ulPcYkURcMenqyR8pZqwNigcpIk5cVcFMGvQ4U2rWq9oLjr1TRZ0p+g4lZ4oKbkv9S
	 AyHgpczE27AJLujqFImk2U+ASwzDzdLExi2/FZMU=
X-QQ-mid: esmtpsz11t1792116608teb5753b9
X-QQ-Originating-IP: fqo+3tqnzUYbhVA9m5C2DPTLYD5YFKe9t0LCHV7tYoI=
Received: from [10.10.7.69] ( [1.202.39.170])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 16 Oct 2026 10:10:06 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 14748860426757089161
EX-QQ-RecipientCnt: 9
From: ZhaoJinming <zhaojinming@uniontech.com>
Date: Fri, 16 Oct 2026 10:09:44 +0800
Subject: [PATCH 2/3] crypto: qce - fix memory leak of the CCM AAD buffer
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-fix-qce-ccm-adata-leak-v1-2-f54a82af2de0@uniontech.com>
References: <20261016-fix-qce-ccm-adata-leak-v1-0-f54a82af2de0@uniontech.com>
In-Reply-To: <20261016-fix-qce-ccm-adata-leak-v1-0-f54a82af2de0@uniontech.com>
To: Bartosz Golaszewski <brgl@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Thara Gopinath <thara.gopinath@linaro.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
 linux-kernel@vger.kernel.org, ZhaoJinming <zhaojinming@uniontech.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: Ngk7ShESHkQuzwvKvtmkDqfWZAnM6gpFmiELiunz53qJPTvd3eU+lvKY
	V1StRKaE7ulnFwzSggndfzmwvGaTOfUjg39LOZm1iIovCg/GEjb9aAZp3SJubebkjswvhAY
	erTVDGfV66JvW72LD6GcpDdIRPWhujlLtpJoGv0ZjxDnkR/zVzGEqtFSMh+kz0T3BEjYP0P
	GlXTNqaVdRbqAZDsdjbcjnSCbOb27yILt14gv897b9Ue0I+pP4Lm8xy9p6bOCskFncKl6HF
	0P3c4AX+oMAF+vsif6cfQ0YsJaOGlC3RTXkgaAag126K+l8mWJ2EGW41a1NlquheT7N/dnf
	/gp49yCXMEfK19yQSl44KE5Y5FIRWdiSJVocPQ1f58dCUL6vssMrjQZzmLteIXBK2/+NMQx
	+hEFXu4PCbI9CRcVYhG3uCvVnTCf7ckV4DBMYhJ1/5Duba5FEtWR4jN6iGqU6LP9KfggngY
	peVYTIBOeg9TpysE9vqwv+Nau6WihQGvjrG6KEUR+IEeYbmL2LpkCd10DSKae2ghxD3zPEF
	zyqmiCdmYbvKGXnkjMeVe01Vvj9U8qnIWTUKh9dUwHCidFytYQdv2qI8MSo/p+nw4SFRbGu
	qvgKRxBtaJdmKsLQOFnZ90AD7oYPnyRYh4f7egJCehuJeTR3embs/hP6k+HTq/xcO4S7cWp
	tRXiRYuEHW3bGFd3KmWDA6GT7nm8ofraPaK/Y4ZY9iozujQ1mOfTBiiKe21qG2WteZd5PHI
	m9Hh8zndJ3AnGbwXaTKSzzjvpATsHctFyDUk2fXY4tUdx4vfOfpO52xf5hE6FJS88G0r+fE
	8GQCvSf8UfgZLDHoC/iYTjYIw7OWdLVEOUL9Fbzrmce7L4BVxJuA2bJsmuA7+IuSQISDHLl
	rR+67PmCCDNS3tzODPtdCOmLKvWZaOiko2Tcf5ZMKLI8oAl84vklgsnMCfc5/0uSLwpzTG5
	ub71CNdKUl7U1LQOInrGAvLP9Bb/aiM/wBHgrW5TDF5wcH9QWAq5um7ZjcC1EbZz6StQUM5
	41dpkO+mD0bSeQwTfoJPS+q8bxUu99CHMzg0Bob0DXfKwxpvRn
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
X-QQ-RECHKSPAM: 0

qce_aead_ccm_prepare_buf_assoclen() allocates rctx->adata with kzalloc()
for every CCM request that carries associated data, but the buffer is
never freed: qce_aead_done() releases only the scatterlist tables, and
none of the error paths release it either.  Every such request therefore
leaks a small allocation.

Free rctx->adata in the completion handler and on all error paths: the
sg_copy_to_buffer() and sg_alloc_table() failures in
qce_aead_ccm_prepare_buf_assoclen() (through the new err_free_adata
label) and the error cleanup of qce_aead_async_req_handle().

The buffer is referenced by a scatterlist that is DMA-mapped, so it is
freed only after dma_unmap_sg() has run.  The frees are guarded the same
way as the surrounding sg_free_table() calls, so no path frees the
buffer twice or frees a stale pointer.

Fixes: 9363efb4181c ("crypto: qce - Add support for AEAD algorithms")
Cc: stable@vger.kernel.org
Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
---
 drivers/crypto/qce/aead.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
index f8e6054ff15d..5bf59cb9ae9a 100644
--- a/drivers/crypto/qce/aead.c
+++ b/drivers/crypto/qce/aead.c
@@ -53,6 +53,7 @@ static void qce_aead_done(void *data)
 			sg_free_table(&rctx->src_tbl);
 			if (diff_dst)
 				sg_free_table(&rctx->dst_tbl);
+			kfree(rctx->adata);
 		} else {
 			if (!(IS_DECRYPT(rctx->flags) && !diff_dst))
 				sg_free_table(&rctx->dst_tbl);
@@ -220,8 +221,10 @@ qce_aead_ccm_prepare_buf_assoclen(struct aead_request *req)
 	/* Copy the associated data */
 	if (sg_copy_to_buffer(req->src, sg_nents_for_len(req->src, assoclen),
 			      rctx->adata + adata_header_len,
-			      assoclen) != assoclen)
-		return -EINVAL;
+			      assoclen) != assoclen) {
+		ret = -EINVAL;
+		goto err_free_adata;
+	}
 
 	/* Pad associated data to block size */
 	rctx->assoclen = ALIGN(assoclen + adata_header_len, 16);
@@ -236,7 +239,7 @@ qce_aead_ccm_prepare_buf_assoclen(struct aead_request *req)
 	gfp = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ? GFP_KERNEL : GFP_ATOMIC;
 	ret = sg_alloc_table(&rctx->src_tbl, rctx->src_nents, gfp);
 	if (ret)
-		return ret;
+		goto err_free_adata;
 
 	/* Associated Data */
 	sg_init_one(&rctx->adata_sg, rctx->adata, rctx->assoclen);
@@ -288,6 +291,9 @@ qce_aead_ccm_prepare_buf_assoclen(struct aead_request *req)
 	return 0;
 err_free:
 	sg_free_table(&rctx->src_tbl);
+err_free_adata:
+	kfree(rctx->adata);
+	rctx->adata = NULL;
 	return ret;
 }
 
@@ -486,6 +492,7 @@ qce_aead_async_req_handle(struct crypto_async_request *async_req)
 		sg_free_table(&rctx->src_tbl);
 		if (diff_dst)
 			sg_free_table(&rctx->dst_tbl);
+		kfree(rctx->adata);
 	} else {
 		sg_free_table(&rctx->dst_tbl);
 	}

-- 
2.50.1

