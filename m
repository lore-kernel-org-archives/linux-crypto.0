Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=54.243.244.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794552933;
	b=ft2hRpsOr28Wskgc97gNzhYYV1fGIc0U5ZR60ZDDGRpQG0SMVFRu1O6oksvOSY0x6uu9
	 9g6NEt+zqreFJ7m2S3rVgnHxGuzWEFg4my7lm6ZzEx26XPbWpH6PGUr/a/cBCMJvt7YvB
	 zdWrAdB43H1Pl0Gcx+mf0QIBNBSTjFNxARdBA0KZ/u0jMSIh2PpnPx4XNza7siEmUWEkc
	 OD5WBDcMhe91qVTzeqjmCHxjEOisTCGZBEJOhT4TXSy+4xrck7Gc57LJ24k6Ljt9i88En
	 dY7g7WYMP1Vt2iINGClG6C1zjecmzjTso5r2jZv6OSJ3LHj66GoDyyHiXYKWCC+F6sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794552933;
	h=DMARC-Filter:DKIM-Signature:X-QQ-mid:X-QQ-Originating-IP:Received:
	 X-QQ-SSF:X-QQ-GoodBg:X-BIZMAIL-ID:EX-QQ-RecipientCnt:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:X-QQ-SENDSIZE:
	 Feedback-ID:X-QQ-XMAILINFO:X-QQ-XMRINFO:X-QQ-RECHKSPAM;
	bh=ME6CrnFCt67LvGWP5aD09CbuTCYW213BLRMgS0dlvxI=;
	b=Z5I57QF7lPHcvV4gpjobeEbJVw/yft5GlaCdhyQWq5okgl/BBuXj/aqah5w/0i2OYkgp
	 yRJ/EOmMENYw1oO9vmoGxwFGTd1GsQrSteGdChdGR8UA/kn39/qvbXFvLK9NvE00Geu1h
	 4OJp7k1o3bZTxzsVCgdljevimmfyNCIQmpRs/vXsKXxDDEKrH0ZpWVVWKpZ0tcdf/juNS
	 yRkZCrfh5Z5Fs5lxN9ejzJcVkbhxKOYmm4kQsMJw/XcUo+oi1RXKJ105wbc3EOsZixHtl
	 ZjD8p8uZqz5HFzuZk9kzjE1a54cP6lPG+2HDcHmm2Yi+C9w4DOHDW+Z5tmrnnAWpN+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=uniontech.com;
	spf=pass smtp.mailfrom=uniontech.com;
	dkim=pass header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=dhaTh7PW;
	arc=none smtp.remote-ip=54.243.244.52
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AFA606A32E;
	Fri, 13 Nov 2026 06:55:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4AFA606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.a=rsa-sha256 header.s=onoh2408 header.b=dhaTh7PW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1794552897;
	bh=ME6CrnFCt67LvGWP5aD09CbuTCYW213BLRMgS0dlvxI=;
	h=From:Date:Subject:MIME-Version:Message-Id:To;
	b=dhaTh7PWjRjlq32rgs1oKyUwIn93gsBAYcg/Ri0jX7h4i9FeLNUCWZUltr0Eu4K3R
	 chGMFdCdjdFlWZ4wF5NQ+l42y6mYUABIccWfw/PqUPN58H3p96gQSUeavz2oW4Q2OI
	 QzsSTAIu9jBzIi6lOvgWe370VDXOVMzpludbt2Do=
X-QQ-mid: zesmtpsz3t1794552893t3c246ece
X-QQ-Originating-IP: LHgc1R6wLx+1zB6icyossbF4brXomjUr7thcgK2UemM=
Received: from [10.10.7.69] ( [124.126.19.250])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 13 Nov 2026 14:54:51 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 8241034351459073195
EX-QQ-RecipientCnt: 9
From: ZhaoJinming <zhaojinming@uniontech.com>
Date: Fri, 13 Nov 2026 14:54:22 +0800
Subject: [PATCH v2 4/7] crypto: qce - do not free an uninitialized dst_tbl
 on the error path
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
Message-Id: <20261113-fix-qce-ccm-adata-leak-v2-4-914501377a62@uniontech.com>
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
X-QQ-XMAILINFO: OdB2ET5bBEcaVwIGqcOkAGxjqmqqS0Q6E2FxQW6qYkLclYVkbDMDoxwE
	0LIf6B+RogocuyyZW2PnPlcovF+LQdYj81TQ6h1nD3D0yDasS/n/qgCtTc1kdkX1e77DYaL
	OMn6qxkIj7dnZ+s4qksiX+ZzvU6hOkCrWgGhDlt5jtJGvh3HeFlnvcfqHNEbX7VMoqp3sjv
	nI1NTCSgXMnMEi0XbA9ogtpwsYyW7ZKDkOY79G2ozUnS1mJsB1eyajLGg+vmsmEecu5hwF9
	XABkkB1+i/2d1EskdKOofa9WR83/q4dA9HrxJ4KqfCLgtzkGRcQr8ijcw6bWWGVO/iXN4u+
	7LElLnvYoAeQcBj+8Cz7XB8rnq/rWAsrz7fMGGQql5//2/y4lGdwYYAkD+qpoEJwQxwZ9tB
	6j4oZnxRtsyKgd9mAD6++sCzJWEuZUrlP5xrjjFCUem2nsGRsZvVHw7tp2WBF/vkuuxNjxD
	6rs0P6exiK7qroS0j83vbkGxdgFkmMxOtkbl7XhYoPvndcW9ODuSL27tmM+RlpkYUgRoh+Y
	yHgUjxOYHhypcUqqjytWoY35x1GmOlWs+yFPdanU9+zkBrT0XgeouOGHKzu132FfQZnOAZE
	qvDE1Jsc9n8IYSqYcjv4Khqa7OqhblHsHEvHVQMJ15B1hG4E+yhXYhlnPFu87LL++AP7T9+
	S3T9lpex/eFTju5Lv7T1RsY8cyAsIwmw5nuffgleuO/oecwNIE5SML4S2FjT5l8t1QJgqxD
	Shg4QztKpuLuz0iDq7feBX5XnAlnRlW6Tj/Z30eq3pkqRIz85RgezRU86g/RzncvmLiGA8f
	K1xlkwtofwqwMzSyM9Sq72bgMZyLI2vM9l6+EiJHto1AWAuIHXC+JiZ7Cbl29GXIn7XeDac
	sLQS0SUum6hPQFWNDdFZbpiHQwKLfZMOF3JJ4aHAFIY2HmgvTsk61Z2hZwpb2+FTBMsGIXS
	FAkMC1Cckfd1KPnFJhVygHWX/UNAFyeP5b64FTC6Fbe2qlLtCpfFCT9SCR00Z+WarT+8Wp3
	xCbFUjyJ4LvdYp/q7sKJJeFh3TkixsKVjsEgxdKy2RuQeKaAKY
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0

qce_aead_async_req_handle() jumps to error_free when mapping or starting
a request fails.  For a CCM request without associated data that is
decrypted in place, qce_aead_ccm_prepare_buf() does not allocate
rctx->dst_tbl, so the else branch of error_free releases an uninitialized
sg_table:

	} else {
		sg_free_table(&rctx->dst_tbl);
	}

The request context comes from aead_request_alloc(), which uses
kmalloc(), so this can pass a garbage sgl pointer to sg_free_table() and
crash the kernel.

qce_aead_done() already skips this case with
!(IS_DECRYPT(rctx->flags) && !diff_dst).  Apply the same check to the
error path so the uninitialized table is not freed.

Fixes: 9363efb4181c ("crypto: qce - Add support for AEAD algorithms")
Cc: stable@vger.kernel.org
Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
---
 drivers/crypto/qce/aead.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/aead.c b/drivers/crypto/qce/aead.c
index 15ce778f019a..dd369328c8a6 100644
--- a/drivers/crypto/qce/aead.c
+++ b/drivers/crypto/qce/aead.c
@@ -493,7 +493,7 @@ qce_aead_async_req_handle(struct crypto_async_request *async_req)
 		if (diff_dst)
 			sg_free_table(&rctx->dst_tbl);
 		kfree(rctx->adata);
-	} else {
+	} else if (!(IS_CCM(rctx->flags) && IS_DECRYPT(rctx->flags) && !diff_dst)) {
 		sg_free_table(&rctx->dst_tbl);
 	}
 	return ret;

-- 
2.50.1

