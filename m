Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=54.204.34.129
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794552940;
	b=XrhD1waWer5KmRP5vTsHXGNe+kF4eyaYRMpjt2KnJbDqKo189ib4czHcclQuWivru2CG
	 H6Ws4wB3TP4fna4A64Tc3oiI1s1QElpJb+FSX1NnCTF3QXAfgtwYFdUrSYd+u10bpNuW1
	 MI5K5bdH6IVyPU+PKZGC+40vjSMcK3zK3lvyRxNCA/yh2CgllnFIus1DwBe7sHfE9k235
	 UpLWA6q3ABS/L+fdh53ckX2WYNBqS96OIUDYL6hUUfw1ACMftP8vdnIxjNiIqGQDYaH7A
	 8Anu+4bVVsLSihTQyhvwC2Fk5ym6zP/yJnpMZis0rZy61vF1AIFjGmepF9rmNQ/hWGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794552940;
	h=DMARC-Filter:DKIM-Signature:X-QQ-mid:X-QQ-Originating-IP:Received:
	 X-QQ-SSF:X-QQ-GoodBg:X-BIZMAIL-ID:EX-QQ-RecipientCnt:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:X-QQ-SENDSIZE:
	 Feedback-ID:X-QQ-XMAILINFO:X-QQ-XMRINFO:X-QQ-RECHKSPAM;
	bh=A1CsuQjmcAkOAaAS3S0yQLoSRdVX2EIZP3LSLTBOykw=;
	b=RNJOBacGlw9XPmAnzoFNNYw4Zuphe3iDJEvRdQI79zUKw2qzFYF5p4rOZKEOkcE4VtFZ
	 2QYeGxDXLxk4gUbkD5r521oX+RfNCq5wtIb8tRa/+TMWLQA4KdfCaH4z/i9bCeO6noQvQ
	 12cI69OCyClT7VNn99IXk3hVMDu9mOPz3kz5JfeSkuKxMKMVBMbCiZlalGidvFbgUVvj/
	 qbI27kvK9XjWmPyCEhbvY7MbtjZRn2XUltORcAV5kXk+v26QfOda0jgI5lAeNUWPuT77L
	 t0SlGTG/Mkt6SUd1VldRHV6FCOc2fMU1kFfU/RysEdTnkLpF6SUBnGxXe7T/zSnxlBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=uniontech.com;
	spf=pass smtp.mailfrom=uniontech.com;
	dkim=pass header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=OMrgw8we;
	arc=none smtp.remote-ip=54.204.34.129
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F3C60A2629;
	Fri, 13 Nov 2026 06:55:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 62F3C60A2629
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=OMrgw8we
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1794552897;
	bh=A1CsuQjmcAkOAaAS3S0yQLoSRdVX2EIZP3LSLTBOykw=;
	h=From:Date:Subject:MIME-Version:Message-Id:To;
	b=OMrgw8weOaRti5vrvPC7a6+EprrvAa1Cg5Gkq9cu43bmLovVd5B2DHlcYvuEqii7A
	 Kv3nmPI/Eewk0kEJJulQNsvx9Utz3iO8MoResfdPpBBBzzALaizyKdfKnE4hCQwbRJ
	 PKU52lRiCegeOA1/TEXmT/sCkib6FbAqViu6sw9o=
X-QQ-mid: zesmtpsz3t1794552881t89786f1a
X-QQ-Originating-IP: NprMIgge9uLDowXW/Wd1cYNUKtLb7jbxgkdSwOMhDPk=
Received: from [10.10.7.69] ( [124.126.19.250])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 13 Nov 2026 14:54:39 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 8924661771922529570
EX-QQ-RecipientCnt: 11
From: ZhaoJinming <zhaojinming@uniontech.com>
Date: Fri, 13 Nov 2026 14:54:19 +0800
Subject: [PATCH v2 1/7] crypto: qce - unmap the correct scatterlist in the
 CCM error path
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
Message-Id: <20261113-fix-qce-ccm-adata-leak-v2-1-914501377a62@uniontech.com>
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
X-QQ-XMAILINFO: Ma4CB9LXNscGDY4Mg4V5ImxeGD3frA/nABZt7QFomX7RXk89weQNe5zH
	uyXlrXcEO8QvWf0KVXTEBVqSxrFfjoLTQMfla19YM1AKTzs54UOOx6hyksd3jDQ5LuvD2s3
	xs6D+zMDUDlrP44eeA78+eTWgpzU4ZiKLqdSz08FU532MqixgY8DZkbcBGkPycFOg9cMN52
	Im8C4rQL60Kb36y4oI2J886Gy5FQG8evadeAbOPbHtZVH4fnaG8Udd6rNfcgBEHiZib+aD0
	G3o1GhKDMBP6Av8mCRdbL6UcUKU6g0brCEi6nozNCdIfn3N5rGnq2lWuBnocBR8PAuWrbZR
	T6kEIs+Ak0RgS5uf/3roH+zEqFvZaCiyIVvtC76ik2BJ9INDTcNZvFWY9N/chQTmW/ltOSP
	98hXnDVj2GZrrl+rF6BPJerfzN3MjUv1tz11M0z0ps23bcsrCyEwaK3g6IVXbxwem2H66jk
	A7HttXRhQZ04orKDSm08oeSXYc7KS8nJOABlTywEU5mf0vLeQwjby3ogY653b1I+dVnwQkW
	su+gkSus7Ojd0ZhaflOdL4ugomgIeyyqVV9G4VDhvSe9Eibr4kQqxbnJ3aUDcqo36UohVYE
	jWHn7t9OY+Hq0CGIkxke2sYRglzX1AXCBEsPBW8KYwl6KMLhKkjG+EMjLegCX5A5lEYyvwu
	AiwD7NwuM7YXECpmK57hTkSRNsrSj1czC+YOmRJ0NdpGB7rZt/agjikPOpYD17KXZC9r8zN
	ixGn4SgSegpzpdOQfrADgB7lWzil6lQSLPnNgxl7P/PR7PcxR+G0KCC3ZeeMk25+dWevKKa
	/PSAIV4aFscBXAtWrfL5SKspBmD4HVrGve621uhwEy1NVEAPPnsaltknMPrHvZDDUASM7nW
	Vm7zfOjXfFMPJGrxsvLORCB4PtZzuZEm9v6Tm5OAfZs4joiLWBuPuJGZxkV+FmDv+MdQjNd
	KBKTa6MbYLVRNz1nhBBhuFFKMmNCRcmxgyuO/TmzKmV20SquyB7mTVTa74OZiBURqH8T/hH
	XWW5uceikbjU2Jk9KZcnD+1s7arZwqCs0GBbsaCDPDE2bI59BVS863pFS7JcA=
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0

qce_aead_async_req_handle() maps the source with
dma_map_sg(qce->dev, rctx->src_sg, rctx->src_nents, dir_src), but its
error path unmaps req->src instead:

	error_unmap_src:
		if (diff_dst)
			dma_unmap_sg(qce->dev, req->src, rctx->src_nents, dir_src);

For CCM requests with associated data and separate source and
destination buffers, rctx->src_sg is a scatterlist freshly built by
qce_aead_ccm_prepare_buf_assoclen() that carries the AAD, message and
result buffers, so it is not req->src.  The mapping created for
rctx->src_sg is therefore leaked, and req->src is unmapped with a nents
count that does not belong to it.

Unmap rctx->src_sg, matching the dma_map_sg() call, as qce_aead_done()
already does on the completion path.  This also makes it safe to free
rctx->adata on this path, which the next patch does.

Fixes: 9363efb4181c ("crypto: qce - Add support for AEAD algorithms")
Reported-by: Eric Biggers <ebiggers@kernel.org>
Link: https://lore.kernel.org/linux-crypto/20260723183438.GB93534@quark/
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
---
 drivers/crypto/qce/aead.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
index a9642c67f476..f8e6054ff15d 100644
--- a/drivers/crypto/qce/aead.c
+++ b/drivers/crypto/qce/aead.c
@@ -478,7 +478,7 @@ qce_aead_async_req_handle(struct crypto_async_request *async_req)
 	qce_dma_terminate_all(&qce->dma);
 error_unmap_src:
 	if (diff_dst)
-		dma_unmap_sg(qce->dev, req->src, rctx->src_nents, dir_src);
+		dma_unmap_sg(qce->dev, rctx->src_sg, rctx->src_nents, dir_src);
 error_unmap_dst:
 	dma_unmap_sg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst);
 error_free:

-- 
2.50.1

