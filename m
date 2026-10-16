Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89D136215F;
	Fri, 16 Oct 2026 02:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.22.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792116909; cv=none; b=g92FcSk7+q3NciWioCbbhLmaW8ITU4X9eyP0LX2Lr1jgvH8YL85fbSWY9epolUbuchEar8kGJvaeCQZzI3yFX1Q7RKnt2VoD4fWs/4IL8pUlHke767XUXdRaY/3PGeFDqpkzluEjFcVlyhncHj09oLVSOI9M4ORoSxodIIrQw88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792116909; c=relaxed/simple;
	bh=F8XskYXmDY7NG20Xx7FRuAb64nJBS3xlQz2LL9hKv+g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=J3kQ2HNcqcbzkCty+Da9loxZ7hCa0c70/PDXQFRICNdfVRrF3o9oyt8p0xmYpz8+wuOlOgq+Fzbf0EFfhnC7N8m+B5NZSV2FGH//WVDbvNzmEMng57+j5JUGTE17rgSJgMVX6e7RoyfnonbU5qkTPhpM5C1sohIkvJrv2XqV8GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=FBLVcWOG; arc=none smtp.client-ip=54.207.22.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="FBLVcWOG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1792116616;
	bh=DnzS1kZFdGs11qsxeWSEoN6CTO1k+K5Ab5z2mQxm1LI=;
	h=From:Date:Subject:MIME-Version:Message-Id:To;
	b=FBLVcWOGM6e0yZfbgr75OSOXm6hJbAEnvbnBYfHE0vZFaFR3cdPsowSnONQJiXCPF
	 NCC95dbUgosNHVENbdyNBlcbmV1D6jzUB3QaPlHJoxpHfr5nGGh+E/9C93BHxseVIH
	 M0BEtD8iI7xhbr+gNv4T2QJZZ8sbrDURcIUjRt+Y=
X-QQ-mid: esmtpsz11t1792116612tb3d0eba1
X-QQ-Originating-IP: wJzGh483W7hPPVJzeA6tfEzsFXhRl63ReBSMbd17db4=
Received: from [10.10.7.69] ( [1.202.39.170])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 16 Oct 2026 10:10:10 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 8549966789764888741
EX-QQ-RecipientCnt: 9
From: ZhaoJinming <zhaojinming@uniontech.com>
Date: Fri, 16 Oct 2026 10:09:45 +0800
Subject: [PATCH 3/3] crypto: qce - check dma_map_sg() result for the source
 scatterlist
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-fix-qce-ccm-adata-leak-v1-3-f54a82af2de0@uniontech.com>
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
X-QQ-XMAILINFO: M4iqtcQzl/9FD130QD7hfDfDEPMYGprr+vn43LJAGfRXZfGYHR6X38MG
	djsYUx8XMat5WmgwmdshXAOLjGYpsCYR+jnn6x2AG4is8ORQMnA34M00FbsJpkFGjtZlVP+
	PHmdJgYkxRaaiPwvVUorWsV3A/OFpjyQ4msDPbxm2zde1H6kbhSqtbeF7JNzs9FZlGVA7wX
	E+uS9VfokqHaf9rg4ofLY+yLkTSg5aK4/wZoZo0nyG2lC9jMUZ2PM00sLpGUH3AY7otyYVl
	hZABdpKYeSQg6RMNqYPLnuBDjduRVyE1NPYGIx25CCi0mir/dlpay25xqjD9RdJqj3N8/Y9
	vk8SwplDIhrfNXmroDSU/rF3XuAKB2rK6jpatRLV15wgVo59seNbLp9xe3t1izFMEkX8yNd
	kdwGmlAM5zoSbVjZg55/LvDRZyvATfkJHc8elvmfVfWKnPuJ8JuVwf4JCpI0sQx3hYcWQp+
	9fzmYaaB5aFXcaoZGfT+tBuTIb05HI1SMyFINAk8lYwc8nPi4/XRcFXw0layJgx3YVsU4Sa
	LnB6nbd2eWxiqw2L3lWScoMC6TYHbK9ta28M5y+hwVAkFt7Q3EO344b0xmqomRzphZv6ebX
	/6RwjMayrIKrezj9+3WjUCZei67IOj9YsRapZke0NWE/4f4VpWJxkYgltOfv+2npHn6XMY8
	/ZfV0LaJFO4GykZp4UzMsXt0IUZdnJw2Dkfzst+Xw6O9JSpkLXCKAKewlLAu6iLP5wH0mG8
	7fsr8yBs8/RoBwg58XpDG05CDkPB66d9jXcd6oLvzX3D1hfTPPv2l7Rqw5c+S0C3akZ4sq/
	SwRaSc1po5U3WemK9n5AkPqNAAgSmtOVC5uPa04PryjVeREFhXs/G8iR52lfu5iuCw25T8U
	cWV1NuOlLRIpIt1jnWcXNbohmJS7f1SqPDqNLMhtbq+BPRe99UWgY2+l3XFeRyuslRa+W2e
	FSlGu390Y8SyMMUqITZOd58k9I/P69nMgO9vvEVosXfcSJyZSAtJZmVwIeK2tYZPovj4kLH
	KRJiom7Kh2AbogDNTcYPiVwM/t6+DYApp2IlZ/NP2IM4hWTdlU
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
X-QQ-RECHKSPAM: 0

qce_aead_async_req_handle() maps the source scatterlist with
dma_map_sg(), which returns 0 on failure, but the result is checked
with:

	if (src_nents < 0) {
		ret = src_nents;
		goto error_unmap_dst;
	}

so a mapping failure is not detected.  The code then calls
qce_dma_prep_sgs() with zero source entries, which fails, and the error
path calls dma_unmap_sg() on a scatterlist that was never mapped.

Check for !src_nents instead and return -EIO, matching the check that is
already used for the destination scatterlist.  The error_unmap_dst path
skips the source unmap and only releases the destination mapping, which
is the one that was successfully created.

Fixes: 9363efb4181c ("crypto: qce - Add support for AEAD algorithms")
Cc: stable@vger.kernel.org
Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
---
 drivers/crypto/qce/aead.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
index 5bf59cb9ae9a..15ce778f019a 100644
--- a/drivers/crypto/qce/aead.c
+++ b/drivers/crypto/qce/aead.c
@@ -456,8 +456,8 @@ qce_aead_async_req_handle(struct crypto_async_request *async_req)
 
 	if (diff_dst) {
 		src_nents = dma_map_sg(qce->dev, rctx->src_sg, rctx->src_nents, dir_src);
-		if (src_nents < 0) {
-			ret = src_nents;
+		if (!src_nents) {
+			ret = -EIO;
 			goto error_unmap_dst;
 		}
 	} else {

-- 
2.50.1

