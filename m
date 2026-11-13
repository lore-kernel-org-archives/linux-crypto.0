Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=54.204.34.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794552935;
	b=hq7NNNP+FXM20i8/5xZ0cKG23XQZBE8w14lFK1lLcWh2Q01pv/sZcBWhFX0CKYZpURZX
	 JDVobnrec59q//F3tj5z9ZOVyz7j6WwwE1Hz5EuyWrOLM8OActz2ieFCXW2oI62x2tLUD
	 KBYLtOMZ2SPPil0SkeXssDqdjnSW5xq0hLukMu8AQQNsTE6lQNKvVyMVNSPs/De54f1K8
	 ndhVa3QAGcF6Nc7peSauLnv5nYDGtyO+7xHDnIiDwav//8RbYoyD3gf54cWencTusP0mh
	 EjZMiT6GKEr6kWZgoWTZeXDM4yQAazZvxXu4LI+cl6+y5SKE8W1yT0qktO1XQbXxyjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794552935;
	h=DMARC-Filter:DKIM-Signature:X-QQ-mid:X-QQ-Originating-IP:Received:
	 X-QQ-SSF:X-QQ-GoodBg:X-BIZMAIL-ID:EX-QQ-RecipientCnt:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:X-QQ-SENDSIZE:
	 Feedback-ID:X-QQ-XMAILINFO:X-QQ-XMRINFO:X-QQ-RECHKSPAM;
	bh=EaTbGyUWImq2SatGvSpNU/Fekym2fuItEThij3zsO38=;
	b=UbI/XLue9gNJIgC6+dmt1hWZSQqojGBjpU4SJp65KjOjPYAApDshLjNvzaHiSMFBKobT
	 s4dLSgXxjufWbA6qEF8ddiCMoqLW35x7vfk6BAOwUinlHY7QS+2+5Fg7tFpVg6vAyyOsp
	 565WTUa76L33KA0Ysvftcs+8mq76sIJJSauli1B54z8tkGszFW4nfTcAEn1z3C1HS3qj6
	 iL3BTrB5gpOJdc6/uQutYzqTdDEXzIwacEvYcZwK20a4p4Vm9ZGXP+Uetn6OCEiBrvglL
	 t4Rae4o2Fdjn6DhqZbTrDtn8az262iLxaAic+X86cBTG1mhgJI9W87npdMMWxXdyY5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=uniontech.com;
	spf=pass smtp.mailfrom=uniontech.com;
	dkim=pass header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=G3+VhOAW;
	arc=none smtp.remote-ip=54.204.34.130
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549D5606A887;
	Fri, 13 Nov 2026 06:55:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 549D5606A887
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=G3+VhOAW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1794552903;
	bh=EaTbGyUWImq2SatGvSpNU/Fekym2fuItEThij3zsO38=;
	h=From:Date:Subject:MIME-Version:Message-Id:To;
	b=G3+VhOAWDVje1U4IbxNcA11pUqjcPEhbNQD174lzuGUDZWUySSp+L8o3so7LQ/oN7
	 +YhguWdgLo6loNw3aZxOXqySa1/gLe+jxiY276hbpqd4qqu/qcha6SUkB88hc/VNBI
	 JsyKQNAJUgUD8kHdGMOmjHqW7IYsT8zezKHr03hs=
X-QQ-mid: zesmtpsz3t1794552885t1b5103a7
X-QQ-Originating-IP: oyydzNM/APBrw2FkNgRfc/mxZ+OJ2iM0EpQblNBqjCs=
Received: from [10.10.7.69] ( [124.126.19.250])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 13 Nov 2026 14:54:43 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 13462947088525709355
EX-QQ-RecipientCnt: 11
From: ZhaoJinming <zhaojinming@uniontech.com>
Date: Fri, 13 Nov 2026 14:54:20 +0800
Subject: [PATCH v2 2/7] crypto: qce - fix memory leak of the CCM AAD buffer
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-fix-qce-ccm-adata-leak-v2-2-914501377a62@uniontech.com>
References: <20261113-fix-qce-ccm-adata-leak-v2-0-914501377a62@uniontech.com>
In-Reply-To: <20261113-fix-qce-ccm-adata-leak-v2-0-914501377a62@uniontech.com>
To: Bartosz Golaszewski <brgl@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Thara Gopinath <thara.gopinath@linaro.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
 linux-kernel@vger.kernel.org, ZhaoJinming <zhaojinming@uniontech.com>, 
 Eric Biggers <ebiggers@kernel.org>, 
 Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: MmIUUz9KGMMdWIUv6aNQZAZk1qVm9ZYM+2zunbs1vdUGzAcwJBF4qMBj
	kcm8Nbfa1aQan1LCxeAje/SB9Jghzim6tkm9Ivvk/hjtBCUsWhEqsvrvY282SmhgYTg692k
	HFxgT6Lsa3xWPYm5vN/7dVAH4/xbF8WWZRhZS6cw8ZwGIPfFo2D8xHqs0i6V6faG3J2r8l/
	a2U1hB+n+VUjZ4C9lvzG+I01i3vDvsbPMR0WE6AZY9lsUWK1dZlsauCJetBNSL5xArkGvZf
	XpLd3omrb8kmQp3zAoZmlapDtgWhl9WH/fJP/Qf6PbLyG0yhBuUri5mK18TA6S/IdvY0KXt
	H31yB8y+nc6irihnporYxHF+ZGTVY0UVIJ5eni9SE60oBhBIj4SRodxluvAJRwzZQ8PN3ih
	n3J0S/JPUoBbMYCzSDwdxGAp33fLqeVqSs8hDhO9jRcnp37PnNW/v2Dk6JdGioMIrZSAG0a
	/SMy3xilOIQgaZvTEjx61XOatcYMUyU+wDS7HbWIIZjRGu9GyJ6L1bAtdyquEupc1lG0tby
	r5w2KBKwgFDeihYASUsDtp+UVVtObo2SR1nVp8heV9mxWPmILo1I/GI/GvSmhFlSXDb3gP1
	qmP5nGH3mP3b9WtGilzf5SUYx/YT2IHyEsiNqQa7NZ14ZHPMgqGZ4xf95fV4gS3ViLXOvPD
	YW4Ph8qM7TnpXKSAPJzFDGMUyYneiZjsczwR08vKc4gvGNXOpNqXRfjjdHWz0/MdZXQFLvj
	LBMMBGyU0diEzx8gE6HETtbPYWtVssCS1oh3yAJcHlNZlDwxQ4f18Tls9E1jhTG/s3JaJQK
	CaY0PmZKd2pXZZYRiQVkzA8iegNcqx/IWX4T4mwBGm0lH3q2CXf2dH4r9Qplh8sOiS1g7fd
	1xjNgCdYW+ZQPHeVhUlXbG6XTtlCkNj3TfO3Cdui8NKp89CH17Fg45KNP4Aqv/mhKtnXPXH
	pyBy05lhtTbxc8QDVW0DHDoF4QOLZavnfeSGYxS10gIy4uMwBluV8F17GjdNmM2P7IH2Ryi
	oWiIXlevPywybNLNO0cwt0Hht4ViMhmBNYCjkWCg0defJwIAwysclc1PTn6c0=
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
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
Reported-by: Eric Biggers <ebiggers@kernel.org>
Link: https://lore.kernel.org/linux-crypto/20260723183438.GB93534@quark/
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
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

