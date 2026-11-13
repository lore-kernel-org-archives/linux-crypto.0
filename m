Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=54.243.244.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794552935;
	b=Tk3mLS6QmCLQ9CotF3OLVayCnMGqL/jo831tY1cq2zQIoWF80Hw8qnZCcgIRjTYJ7fY8
	 hMhgrygyy0kS2pJHwBAADvxwgUfq4OvKhsLRO/mWLu+Jbqm1PEU69aH2wa6uh9MSD3BWt
	 cYQX5ABqRpbv7ditZR6JPj+Q7CCMphu1AB7Qg0sxtnpSDsnW9tFE6ynFugoBw1TrwcZt6
	 KYE33uqZi829a3RepVLjm0T3mdup3VUiJK0XxTcJHxFHcmtndCvRiuAUSIBw/SRJMLnqF
	 HnzdRPgDdUtUB2Hta9OuXLUn+6Hxxwy5Hw+u6CUGBx3Rrxplr0KxNJI7Srm5LnM+h3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794552935;
	h=DMARC-Filter:DKIM-Signature:X-QQ-mid:X-QQ-Originating-IP:Received:
	 X-QQ-SSF:X-QQ-GoodBg:X-BIZMAIL-ID:EX-QQ-RecipientCnt:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:X-QQ-SENDSIZE:
	 Feedback-ID:X-QQ-XMAILINFO:X-QQ-XMRINFO:X-QQ-RECHKSPAM;
	bh=paSbcaRd5LsiAHg8B7AZJSVgdNrX0BRwq71ts7bll00=;
	b=PuhPQQYgWo+W/DeaUbhqhG6anysqOaIhozylJYxIMljIC8lJ58rMm9sQGt4gXxd5SYFk
	 O2FXUgo+z2RtAObw/qCIPXoXg3a+O8e/wBiLj5BXQ8m38HXHyQRgmdVGdfyM0ocqRKaUz
	 ZV03vne8phaqbHjnWjGx4mxMDv46EhhrYLFvlc3+MSgfr8ihhLpYtWzW8QRqSzE1NDT5j
	 5QIHkwQPOTTDCbivroUZb59appohyTzLD2rkmib6+MGlHTP44z1imetubC1QdbkH+PBaH
	 6242wJLvO7Pf4XAD8Qctib4KFrlrPOdmSkWs+heTypujrZ0EtnVSORmF1TDnAPLPZSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=uniontech.com;
	spf=pass smtp.mailfrom=uniontech.com;
	dkim=pass header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=pPEl0SXa;
	arc=none smtp.remote-ip=54.243.244.52
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037E5606A890;
	Fri, 13 Nov 2026 06:55:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 037E5606A890
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=pPEl0SXa
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1794552905;
	bh=paSbcaRd5LsiAHg8B7AZJSVgdNrX0BRwq71ts7bll00=;
	h=From:Date:Subject:MIME-Version:Message-Id:To;
	b=pPEl0SXaCDLqUcmo+hH9Crajlu78WUi8FLj3jq40V0eQTANgggBLsKi2mpqKBkWDi
	 1d9drm9nMsmHHrbFcinKiDQkuHPolboD/tkG90B9OS8wHikE5vopu+oYnkxbvWKVqE
	 DBWcvVZdfZ8Hk6KwMWEk6BBgkpyoCgU0OSFlxWvM=
X-QQ-mid: zesmtpsz3t1794552900t0bcea3f2
X-QQ-Originating-IP: PZ3/QZODjwoYU4e22pnfd8avR84FXNmIjyjNweiLHm4=
Received: from [10.10.7.69] ( [124.126.19.250])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 13 Nov 2026 14:54:59 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 4678510792523604702
EX-QQ-RecipientCnt: 9
From: ZhaoJinming <zhaojinming@uniontech.com>
Date: Fri, 13 Nov 2026 14:54:24 +0800
Subject: [PATCH v2 6/7] crypto: qce - reject a negative scatterlist count
 in CCM AAD preparation
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
Message-Id: <20261113-fix-qce-ccm-adata-leak-v2-6-914501377a62@uniontech.com>
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
X-QQ-XMAILINFO: N3l5ASPewLWq56wQM4UGXaBPfV5vkUx2nvhvqxjm6qB+ilSZvgbrm5hF
	Owai1ADSuf77jDs+29YPVC5JgE0/QMEK4iQncLfIof7SrDX097/0k40Ol6AwERWkmKEU21h
	C3PTABj9M2iED4zMy1Q46Qhuja24WwVHyfWrueKhAc/JeTShcf9NLsWkO7a9iDsrzz2z9qH
	o8ZZ6SudXXl+Mm5vgn5XPEGsaerr5o9WfI5Svuki0MS4IK9U3Dxm3ku/X3FgJqBTMN+7tSg
	NHTfgaYjup1utZaQPAgJa+KFS/QVWSJZBQf1bZb4zaz1tzFMBvdaz7yMwMobV/lizD9+csa
	+tT3YhBjGdeYZmFp6YVRHagAKD4gdmPfsPkzzktgZU5Hp7ViyZB9YwN9l97oMQm2AnTK1Av
	XFBkD4Fw/zCIARuqks5ItjjA/TLiiBLcIud4wGt9c521cHRg7W1dO0HJ8hpDSUmoXpPC5HU
	r4FaZOYERYW+rK/c3EmrV23/ABgsE02akXW10anUc0Lv2ANMjYrR00Mt/T6XZYNjbH8tPCL
	Xb1Ex6Q9F1MXaMiMewfmBxeBjE8YKHFd2c0JAvCfskzA4fA9l60txmadePLirjfQzm0ub83
	oVf8fvmfJ2xI0K+dtHlKyWlz3xhWmstM89H2IIfbfeU1I4UOSKL40uHfawa6CGOk4IWkIDp
	g5bS3sXP/rDlxq5blfqD8m5cmha5sZY4xJjFX4bOgBjKDcatdjSlk4CSwq4RwtpUlnxtXNF
	RyR4X9kdSlUpa3M1OkJG9PDpYClo7ZGQximo++mchihPFkNw0qxJmc6UplOdrcTZn0ivBpB
	WHihn6uTDko63I9Hyf8j20Whwu6Kk9mZM7hjc+jtsjTz0ZKnu/MpwBVv62KYXjpWosJB1XL
	P93aOt/h78SBi8kR41TTNEQW/g2ItzKu4UALlf730L2TxhIKu/7ZCF8RiVDKREyUfnp/65D
	IfzwqsKWOiWy3z36sK/pssiYInJbK+7O3xp7H9WMFngO/8CEFD1oGutN/LBoYPWgKhtaKwu
	Az5CRjGl1UNYgeQPQN7DpLdxPisiWRhNAsmKM1ouXqm8oME8V7Wcw++WP2dbw=
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-QQ-RECHKSPAM: 0

qce_aead_ccm_prepare_buf_assoclen() computes rctx->src_nents from
sg_nents_for_len() without checking for an error.  If the source
scatterlist is shorter than the requested length the helper returns a
negative errno, which is added to the extra AAD/result entries and then
passed to sg_alloc_table().  That argument is unsigned int, so a negative
value turns into a huge entry count and sg_alloc_table() keeps allocating
memory until the system runs out.

Check the return value and bail out, releasing the already allocated AAD
buffer through err_free_adata.

Fixes: 9363efb4181c ("crypto: qce - Add support for AEAD algorithms")
Cc: stable@vger.kernel.org
Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
---
 drivers/crypto/qce/aead.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
index 00c5924c057e..f75e3827d8bc 100644
--- a/drivers/crypto/qce/aead.c
+++ b/drivers/crypto/qce/aead.c
@@ -186,6 +186,7 @@ qce_aead_ccm_prepare_buf_assoclen(struct aead_request *req)
 	unsigned int adata_header_len, cryptlen, totallen;
 	gfp_t gfp;
 	bool diff_dst;
+	int nents;
 	int ret;
 
 	if (IS_DECRYPT(rctx->flags))
@@ -231,10 +232,16 @@ qce_aead_ccm_prepare_buf_assoclen(struct aead_request *req)
 
 	diff_dst = (req->src != req->dst) ? true : false;
 
+	nents = sg_nents_for_len(req->src, totallen);
+	if (nents < 0) {
+		ret = nents;
+		goto err_free_adata;
+	}
+
 	if (diff_dst)
-		rctx->src_nents = sg_nents_for_len(req->src, totallen) + 1;
+		rctx->src_nents = nents + 1;
 	else
-		rctx->src_nents = sg_nents_for_len(req->src, totallen) + 2;
+		rctx->src_nents = nents + 2;
 
 	gfp = (req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP) ? GFP_KERNEL : GFP_ATOMIC;
 	ret = sg_alloc_table(&rctx->src_tbl, rctx->src_nents, gfp);

-- 
2.50.1

