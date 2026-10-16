Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5629F296BAF;
	Fri, 16 Oct 2026 02:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792117029; cv=none; b=WMYsNM/+IuuI71aRHw954jJzpPumw0Ahp3WKC3CP/NP8XW4LPo2wD7fgsVAYMyOnes1e33NN4WR+iUhL7QZpD5X8k0bGlcB9SuLjS7yHK/Z+h7H8dYNtHmII74h1CLQSLfkIxD8dBGyReSchXRaYxWjrYPEYq5n4XO+R4f/IaWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792117029; c=relaxed/simple;
	bh=TTT14QF+WfdMYzv4WzQoOlSLB396aXZxrFJGwcrBbPc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EEyIntkPIfZCneUwEmlpmxK7KWFPvbb01VJcpe/Pr37mxNac1iIaOF+4/kuFgTXSanUNLQmu6T6TPRhwcgdKEUfqqk+TfSwlYDtQZ078eViC3ESW3ZCPMuyLYS56dCw0nLe5oYzPhL1qRrv40Xm5TVKtbHVPwyrHjWycuqROF2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=hmJq5HiI; arc=none smtp.client-ip=54.204.34.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="hmJq5HiI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1792116609;
	bh=91AsMCy7X0Y4fu2KXMtMCql8lp0l/PhCy5ti85R10ws=;
	h=From:Date:Subject:MIME-Version:Message-Id:To;
	b=hmJq5HiIntPtrP6oTB3uEAA6Em0+8p4JflNEF3AbltCBBIsrvg5iS6AXRQMzh4A9p
	 uUr5ZZxO2EyY0MYN9OEOUg/OpzqT0etqZ7tYfhTkdInTuwjd6GHND4uA+1nR4up1qD
	 cUtMCpak+6FP68gnZs6f4/16mo8CoPezxTc+da3A=
X-QQ-mid: esmtpsz11t1792116604t3df3fdc1
X-QQ-Originating-IP: WAJoGk11Rm/OsSWul0eEGzvbcUTZjkfzrOkEzS6+o0w=
Received: from [10.10.7.69] ( [1.202.39.170])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 16 Oct 2026 10:10:03 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 7012578184215976480
EX-QQ-RecipientCnt: 9
From: ZhaoJinming <zhaojinming@uniontech.com>
Date: Fri, 16 Oct 2026 10:09:43 +0800
Subject: [PATCH 1/3] crypto: qce - unmap the correct scatterlist in the CCM
 error path
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-fix-qce-ccm-adata-leak-v1-1-f54a82af2de0@uniontech.com>
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
X-QQ-XMAILINFO: ORfZ13EUooM/x3eTC0jMyAlz1PCeClTu7lmwGC4Ja/94myQ4M+5eEURN
	u6qIuiC3cxHg4R6Rn41mduBr6orL6W8Ry9yhrRgmruypzKC5he80PJJy8q+xfb7Xu2jzEsP
	vAF4SV7IbkIoxMXKSmYa9p19dViz2MAGbAPWRNH7Dual4WHM5BN0w89ntJl1KzrGbsOvICT
	M8B2CrhgvlI/8A5Sipo2nCJabyU7KXZ8dAqTsFMtFkTCSzwUSJ3VHRUlg6VaAVvwRgvUN3G
	fvXcwS7+X9YJhNZjECMAMW11t3BJ1AzWumbjY5ImR1rCh9+pupwsndPu1GPyxh62vVo19nv
	XzIDN9UE3NDj8i/EJam2UZe948fFWHud2BP8BC6PehiHeKbW+sYtP8+yTatRK/I3E2fhd/K
	r9E+KolCx8c/3tp/K9lTX1VlhtL1K5zFlRBRvjAPcubX3COUieGwSuDzjGKBXfcoXjCX7GJ
	OiZC2wmqCYIwUmALRNezVeADFs3vNvDET5rl6Y1yDf34Ia4IUMa7IWFeRQC6x74XTKD3Nfn
	7INULoQTiA+2nHgxE79INYFKpJ3L2w7GTx83LIw6cT+xR6GgY7E89mkkGdZprhQwpfZMHO5
	C4mlaUaJcmVRICwtVX3eK4CE97MZx86tmhfE2/590Dd3PGT/LsSSShOzI1I7mKmk3ORgEv4
	5VaqeRk4jqEK3b2i6OT2ebOsswDsUems4P9M4QzP2Wy5u43NuaLvAf+pb35pXESQ+Gwbdzz
	0Yr+N0mVNPek0kq5tGK3+BA2Q96o/7cZiMfeERH+AZi3xfVr8/fK2hC7h8iIQyYbWb0yFgg
	qwgethYN7go+Q0GRp7g3D0bmNHfKkmVEGxlKDWLaWFHxymFNc8HLPAEuo1ZoPFmfjE91awO
	XByo8GPbHUV7+f2kFWDkaCt8z4Xhq/vOZzbKC9DBsDIvyUvyYYU6zSWeWnB5v2GCH8s9IsT
	C3KgHpkEWNWNz24IX+LFPHhsJ5ITFjbvu/jartaGSvWm2HT/1SYlu/Xv0oWUiKw4S2Zn7Ih
	WTnxmPXJ9gopYlqkm8Rf9pzaKl5tY=
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

