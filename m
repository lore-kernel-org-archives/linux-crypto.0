Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=54.254.200.92
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794552932;
	b=bsymDbzpjk27dupcQqM9W4cGK7AuSPFf8OLA06vjvtuN6dA+7780+QrcMCK33+gHG/JH
	 UOEWZEWm8NHUMPisx1DhGEyfnXVhcWYS6Qb2cgWQVFR7yI/NVHW9xGo6X1le5Q15K+Vqs
	 MmE3GnYubCs2nuhcGi3E/PC8WzgrC+faGgddHB5yySAnq/fQfbosDN6Npaaxykl035SQG
	 43DE2P4F1uPXjZEh62z1gvjEVFiGlnp44WbWFg2474IlLG6u1v2Z3PYAwqoIVZ8f/5o0b
	 GueSoVcWt9C6lMjw8pqDQWAIJ4TjHeTiR3HjNPUfYvXyitJ5NIuleykeUvtZoo2v8Ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794552932;
	h=DMARC-Filter:DKIM-Signature:X-QQ-mid:X-QQ-Originating-IP:Received:
	 X-QQ-SSF:X-QQ-GoodBg:X-BIZMAIL-ID:EX-QQ-RecipientCnt:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:X-QQ-SENDSIZE:
	 Feedback-ID:X-QQ-XMAILINFO:X-QQ-XMRINFO:X-QQ-RECHKSPAM;
	bh=S9xB5/BduPnlfWQ8P7KI8rH/Fvga0iHfv65Yb/2nG5s=;
	b=N9FMsv2FRNUVyT644NBIBobojKHf4WCBK+As9pbqK89kzi7uaYNzedR9/pDisYWqqSjH
	 am35g5EGNAXG3ghAmSympLQRrgwhjIFGevhxDIEZzlFHFjHOHqcSzBIjLXKKLItYqHNwe
	 rjFnPkRbRdteoyX/ebE/lg1dFCYCcPbWoiUNO3IRR7umYc5rPMNR/srjAcmt/qWRO7VWA
	 avjG7tnUR1hJSysCt+9jBBwMqAevgAMTxRKJJLZTnpBT+RqIe04eD9TVOlGlgUtV6/psk
	 qolRWx8rj2C0rNc0jJTWAyzHSjSiKCH5pffAx4L0AYJjVW+UjjSzjEs3Q3nBQTsrCfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=uniontech.com;
	spf=pass smtp.mailfrom=uniontech.com;
	dkim=pass header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=WEheNwh9;
	arc=none smtp.remote-ip=54.254.200.92
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F1F606A321;
	Fri, 13 Nov 2026 06:55:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8F1F606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=WEheNwh9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1794552901;
	bh=S9xB5/BduPnlfWQ8P7KI8rH/Fvga0iHfv65Yb/2nG5s=;
	h=From:Date:Subject:MIME-Version:Message-Id:To;
	b=WEheNwh94CEdakxGyR8FV36cUwXYzfP1LIClSeHr6UHvuLSObhpTRaxwp5+hgDkut
	 aV4jqKK451ZYBeFssmcyuhR310XeRLNM5cyGmFD70whu5nscutCiUlFgOI7YXeYCbX
	 DhwsJ/qj+1Lu6he/+2EY4N3KoIExDe3ZRNU8Ynso=
X-QQ-mid: zesmtpsz3t1794552896tb95be6bd
X-QQ-Originating-IP: bpw1viB69li/X4G06J1ke0dy5JyGWFnhbJ6iJ2mocbw=
Received: from [10.10.7.69] ( [124.126.19.250])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 13 Nov 2026 14:54:55 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 9421328609788192417
EX-QQ-RecipientCnt: 9
From: ZhaoJinming <zhaojinming@uniontech.com>
Date: Fri, 13 Nov 2026 14:54:23 +0800
Subject: [PATCH v2 5/7] crypto: qce - terminate the DMA channels if
 descriptor preparation fails
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
Message-Id: <20261113-fix-qce-ccm-adata-leak-v2-5-914501377a62@uniontech.com>
References: <20261113-fix-qce-ccm-adata-leak-v2-0-914501377a62@uniontech.com>
In-Reply-To: <20261113-fix-qce-ccm-adata-leak-v2-0-914501377a62@uniontech.com>
To: Bartosz Golaszewski <brgl@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Thara Gopinath <thara.gopinath@linaro.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
 linux-kernel@vger.kernel.org, ZhaoJinming <zhaojinming@uniontech.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: N71rnkwxYMwynW6MV13nhmWGzw5rGRej3Ycw8xYoVBEPdLVQCMCCyv+W
	kaJM4vwzgR/ZqyVdxVjTY3aTBMml5h5BfN5rUW24JBOYxOybian32Vcd2ZSPQfE5Wjg1Il/
	dVnd6AQ9PW9nbdhlJ0ImLylQ8kCpUtaVFOl3Qak+P9A9Q5uoaXayZz42ITzdPeDHW60ukXQ
	7h8N56us5JXkM3MTJIxfJbDloEZi5tgGOjVPjaOWMudN/B98hJT3w0ay3dQbb1BFBnBTpKG
	OwxwIQzOPtqdR1uzMOxQaqa0aarqrIsmL97INYZTWTcj74sbiJnm+qtBtUaALAPzVTiTuPS
	2R6CwdNPbqEN2Xix7dgPy3jvsCmoVDhBRDdsds+5Iec7Oiu3mQq6LaKVXWu7AwsTkLdJbys
	eEM8719rPTt799xOGy/AVdjw6Xm9auCc9g4k9EnV8414/vTIFiipZ7e1QT4OL5eJx9Zne7J
	pft73HTheu8amJjNmD9qAGeKl/vYV+5jZgcVsCEQzUf/nzdzDvjTvRodcWid62z3sbifEBU
	LvqQDpqHmO2NKJlPneE7/DquxHw5lmG/pO44xrH0jDw2ymsMcQHMvOHTz1Vq8qMVB85D7Kl
	+h7KIE7oYnU3Jmt/lsK1kwlLyGxqQMRzRlqQn0ScYFUyA8qMczAfmDg5paXYR9qnGEBSrmT
	0OrfYWF0j6ftk0MwCJtRag9C4/NZf4mUH5SlVXAiyfxDsjgVrbZXFamLkXqT8RORklozYKh
	QiqjufKdlC3xQPzjixRh7dAW4puGejL9st4E6lKoucp977b5IbNgX3GSfNdl9/hoVMRZsKe
	1/kDXiYuQHF6tBIWxKNYaeOsV5gHgaZkZ9mILeQPAGtA6fuUHxfS1xnkC3gqoq5EZzvbh7K
	P1EG9H2xTgL25yjdxg57pjAmDePclFnMyHwlHgeo3Vun68+LYe9Mu+b4da6Pr8+T7Fj9CD8
	PtSclPz0EGMZD1wPPAT9Zb9aCaknpiYxkHObEjK5OvIYy/GOdxO6GoYwo4JEq4LAgFw958y
	gkhkKPoFQuYoBw6fFMdRvlHrBoKr6MttmOWfrV7VXuzUuZN1tNLbeUE54AUG9++HFZaK4qu
	g==
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
X-QQ-RECHKSPAM: 0

qce_dma_prep_sgs() submits the source descriptor to the RX channel before
preparing the destination descriptor on the TX channel.  If the TX
preparation fails, the RX descriptor stays on the channel's pending queue
and qce_dma_prep_sgs() returns an error.

qce_aead_async_req_handle() then jumps to error_unmap_src, which unmaps
the scatterlists without terminating the channels.  A later
qce_dma_issue_pending() from another request will run the stale RX
descriptor against memory that has already been unmapped and possibly
reused.

Jump to error_terminate on this failure as well, so
qce_dma_terminate_all() drops the partially submitted descriptor before
the scatterlists are unmapped.  The error_unmap_src label is no longer
needed; error_terminate falls through to the same source unmap.

Fixes: 9363efb4181c ("crypto: qce - Add support for AEAD algorithms")
Cc: stable@vger.kernel.org
Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
---
 drivers/crypto/qce/aead.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
index dd369328c8a6..00c5924c057e 100644
--- a/drivers/crypto/qce/aead.c
+++ b/drivers/crypto/qce/aead.c
@@ -470,7 +470,7 @@ qce_aead_async_req_handle(struct crypto_async_request *async_req)
 	ret = qce_dma_prep_sgs(&qce->dma, rctx->src_sg, src_nents, rctx->dst_sg, dst_nents,
 			       qce_aead_done, async_req);
 	if (ret)
-		goto error_unmap_src;
+		goto error_terminate;
 
 	qce_dma_issue_pending(&qce->dma);
 
@@ -482,7 +482,6 @@ qce_aead_async_req_handle(struct crypto_async_request *async_req)
 
 error_terminate:
 	qce_dma_terminate_all(&qce->dma);
-error_unmap_src:
 	if (diff_dst)
 		dma_unmap_sg(qce->dev, rctx->src_sg, rctx->src_nents, dir_src);
 error_unmap_dst:

-- 
2.50.1

