Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=54.92.39.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794552931;
	b=HE0rBd/xrNE3p8u+7vF7mzLUOWAwyz6JrCQ2PC+Da26F7XzkiEFHmY92yx8LAgQ4kP+i
	 WH0qgArvUa2rCETfjPh91S3Wwwm852atYDefUSd63miQswk3RJF3blfbxmAcwA9vFoT08
	 uRYB0EYWteX+WcQ5m8RhtoN0oGiHRB3rsmk29EiQ2niGgj46/HgUVoBN/YpqwtrjYlNWX
	 o25n9h1JgMA+fQUvNW1HzkEI0b43MnwOT5v6U2UsBwrUR6fVWfRLVgzbRrPkflEZ+ZFvl
	 gmWzFmNcOwyaMFWLaYp1S0wu1Zm3RabqUcGR/W5rZAZVOFHL7Uh3EK3xgX2NM8088mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794552931;
	h=DMARC-Filter:DKIM-Signature:X-QQ-mid:X-QQ-Originating-IP:Received:
	 X-QQ-SSF:X-QQ-GoodBg:X-BIZMAIL-ID:EX-QQ-RecipientCnt:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:X-QQ-SENDSIZE:
	 Feedback-ID:X-QQ-XMAILINFO:X-QQ-XMRINFO:X-QQ-RECHKSPAM;
	bh=uwj6r9dxBe0KPAQLQ2ZEBT+/Ur+cpWwUyD1v84lejmo=;
	b=z05pAB45qrie3B6P7vXA+TjVWRKtmY+KknQ8WVXBYMgKlPiEGZpP/Tq6M2C0N2QrSnmT
	 /+Ix337hp8o61Pt5klWYjGZ0LeabGIikAHVBUpMrxiyvseUyFPFxXsjD0cG4jtAGmXP7A
	 Eei5c38EaS+TJOAoQCZLrYGN33ahs7DdoGf/rRn0MHAjaUniT11TTWsUV6HfTWiqfDhIb
	 FRTfMudHtX8TviPZwwnPN/6kGlbaUJqrn1qHrYDX0HlCKMXLFzZ6Rgc3TLsrF/3CPapnl
	 x1zInxSsLBW6H5nfcxhoZmKuE3KGO33TVwYqPiY9eE/GyPzYg6mFBdWMusHYMj7AKgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=uniontech.com;
	spf=pass smtp.mailfrom=uniontech.com;
	dkim=pass header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=Fw8oDbRu;
	arc=none smtp.remote-ip=54.92.39.34
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2096A606A31C;
	Fri, 13 Nov 2026 06:55:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2096A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=Fw8oDbRu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1794552909;
	bh=uwj6r9dxBe0KPAQLQ2ZEBT+/Ur+cpWwUyD1v84lejmo=;
	h=From:Date:Subject:MIME-Version:Message-Id:To;
	b=Fw8oDbRuTkgvERyy2Pl69EDwi0JyFiv9H+MtSZpiukkGZtIEAaJRJlErOxgyExpAH
	 0jd14k/kmKh6WDvL+acuI0L3YyaztnAub1TXOf0Gxm3Ify4q33Mh2rP7Ot1slmBzdQ
	 +Zbst5Jt1n4Nff/IP5N711OHE0xlxbM/S9qKeHk8=
X-QQ-mid: zesmtpsz3t1794552904t88dd6f2c
X-QQ-Originating-IP: LJ5LHhw4btnKZNUqXes+Qcjtq+9R51HgR3D4wO1S5jg=
Received: from [10.10.7.69] ( [124.126.19.250])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 13 Nov 2026 14:55:03 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 1603796568235897067
EX-QQ-RecipientCnt: 9
From: ZhaoJinming <zhaojinming@uniontech.com>
Date: Fri, 13 Nov 2026 14:54:25 +0800
Subject: [PATCH v2 7/7] crypto: qce - release dst_tbl when the source
 scatterlist is invalid
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
Message-Id: <20261113-fix-qce-ccm-adata-leak-v2-7-914501377a62@uniontech.com>
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
X-QQ-XMAILINFO: M83iEva+1QDB3MtWpZZZoC87SLZaCRyoJe3FOmRYPhP0Nnepxb18Vd7/
	tgzbbf1KRRSMkR04BlyPE430duU92SVNR0GN28HXFDR3RiFpQV7uxLFZxxUd90mWwBCrBZf
	bA4zFtZbfZ7BT3IVnqY6FWz2/09ISoBoTBjjYmG0rlglk164b1osWOOic00JY8f01qxeKPx
	eWibbAwrfDrqvRQX/b7XXUIoGUJ5WrOTytDpZratWDr+cGdXJkL1jjieXQXTuSApevlrxw6
	epTBl1rhhSd30svTjNQ9wM7Fo9uAMKuxr2vwSvm0ZhkbiYu4o7H6l4bmBej+UXOCOwzSVtu
	+zV8r/sjZGWaiLNTozO/MjB86SxNHxU9/TDBeiLqjuK4ghC0ObdL88A0hVJZuzb+JaeANPC
	68KR60ylHsoP3SKm0h4cb4qsSGJHTj+R7kAMamK3V84/fSkmyJ34sYF0uP0s7Mj4ixBnlYP
	zMYYCRSexldrH5YnYIZitvP0xSIzUJxblckK6x7d8zHIJ4xjCdZ5dDtOBR9PbmBLz0tV+ZI
	6pRey7MDacs54jyHntaSUehVWBjkeCEZFy875bZxIiIv9GASMwn1C1QTYAtcfG8Bnu3iWGw
	tQSM5tVrCvSxUydn7z4fI7/O9ZehDsn3hmgFvDDbPmNsR9EWYpYJIHEnutdP6RyJtq2awdT
	VF6nsA503m/PjzCTH2mksNCufrakxW0Bw0NecViUG1/3V3VWwvESkOv3Zsy16G2sq17Dih9
	32iagUMTQM2lJytiPnX87fMPpt8IPyKo3bkZmqSj84OEtH1fAa9wyk50zOiAPsPkBttWpAQ
	4PEZoPSk7oJOxB7O0oJGYecxCOXSgamgmQxvf/fucuExCqDutW/gFP/R6CmICrLWrpSm0Z3
	V1GqaetIhgLS/xcH1hYc1QKwf7mqEY0yiRmWcwVneyAWeeaKHugIyj/ioUrSPQXSllKM0Cw
	QXAqLimmJ5nEVIJsi8Uzkq3oZ6muYuBM/VCCQb+XPfsZsefdeN4QPd37TBfpGoCZLmv69lK
	T91moyCcfhg1/Cj6WJ+BZWq4YTRzgMe56fghh6/ZMojfZL/IvJ
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
X-QQ-RECHKSPAM: 0

qce_aead_prepare_buf() calls qce_aead_prepare_dst_buf(), which allocates
rctx->dst_tbl, and then validates the source scatterlist with
sg_nents_for_len().  If the source is shorter than the requested length,
the function returns -EINVAL without freeing rctx->dst_tbl, and
qce_aead_async_req_handle() propagates the error with a plain return
instead of going through its error_free cleanup.

Free rctx->dst_tbl on this error path.

Fixes: 9363efb4181c ("crypto: qce - Add support for AEAD algorithms")
Cc: stable@vger.kernel.org
Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
---
 drivers/crypto/qce/aead.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
index f75e3827d8bc..78c168086c5b 100644
--- a/drivers/crypto/qce/aead.c
+++ b/drivers/crypto/qce/aead.c
@@ -322,6 +322,7 @@ static int qce_aead_prepare_buf(struct aead_request *req)
 		rctx->src_nents = sg_nents_for_len(req->src, totallen);
 		if (rctx->src_nents < 0) {
 			dev_err(qce->dev, "Invalid numbers of src SG.\n");
+			sg_free_table(&rctx->dst_tbl);
 			return -EINVAL;
 		}
 		rctx->src_sg = req->src;

-- 
2.50.1

