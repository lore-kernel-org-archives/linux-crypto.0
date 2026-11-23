Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795446704;
	b=TeiDu0FQgiZ4PVVwVFtBoRfmTLrvs1K+WLvUPx5JMwEZinHkpTLXR6nXP/mXze0NmA+W
	 AOSn1FwnreykvNR5lf1AK60GCs8tFT6JkxxrV7ZKuLCbltALxvJ0/95lnKg+ST1QLdTY7
	 +OWsRfCf00rNYbseWOQLIyZUjvdW7j9/B5wdnLqifR2jDILTHZ0wWGYIHOINDprJFEZP5
	 U7K2OGgfX/GCML4baj0jPDVGX2mIoItgi9Ut6qFDjHMBmpLpHjvNGvulUx6kGrp6mcG/z
	 jfUgCTU5ce8qb1kqyO8CCvuEPokXDqCpsMKRDH0e9LR7ZZ6RSlic9EoQJjD7FXNTyHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795446704;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=DfbRQ3HnqUlBbBOkMY4WXnsIOLfqHv92zVcp48pdCgQ=;
	b=oEaYHt/0I6FX2+2qpd0RtcJATLhv/hDmzcY3P37VGuVpq5Gu9c4RwLmI1GXbxH3g4fUJ
	 OrLazVOJ9RR+GrDJKxDN7fK8cqJgGmMj+QnuicM/G8W8WuvvNWEKOLAfLriqWJ/5QU0xR
	 uZrGD4CJbhdKBWdZ3mxcLLx67SBWQ+sj+2+/ocaGI2Y3FBWij/U9HP4TNxiZj6s2SXjbp
	 b5JRZZkX2vj5aF4NNRK+cVGYVkp+4doVQKkImomRbAC0GwDFqnJi8MShXhCW4H3PdP8zP
	 pAIMnZvg55vlDbae1X0I67X7xBBjj2fL3ui+f1teeKUiqYe5xWPxhIxqr2v1mlcmAGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mBqHRmE9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA87606A680;
	Mon, 23 Nov 2026 15:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mBqHRmE9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3267C1F000E0;
	Mon, 23 Nov 2026 15:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795446703;
	bh=DfbRQ3HnqUlBbBOkMY4WXnsIOLfqHv92zVcp48pdCgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mBqHRmE9PzpwWkvO333jNUWX4odAsbClveRn9S5M39rtXxX9WqrZXphjd1VD1LhUj
	 Sf1xfxo5t6oV/t1I6rYc2CKMpyIbuBAoZf0AtkmYh/VuyLYPAAVoFnh1J26MRXWQBD
	 oCmsOjnQlXMIqp025+cxJgM2BpE+L6vFMJZIfkEXlgMKsn5inI9h4HDdyCsqMb1btT
	 N8IHyaJViMxmK8SaiF7zv1lW7XWLMv+iefhN1fjLCv8qa2sWrcvffRlhIdqDdZziRv
	 X4glwRqt0+bFgKzWEbsBJAsudjhusLGGNBrTXL/BB1TzZotDXP9Ej7esyOwd0eXdUw
	 OThmSloIlcVPA==
From: Lee Jones <lee@kernel.org>
To: lee@kernel.org,
	Zhiqi Song <songzhiqi1@huawei.com>,
	Longfang Liu <liulongfang@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Weili Qian <qianweili@huawei.com>,
	Zaibo Xu <xuzaibo@huawei.com>,
	Meng Yu <yumeng18@huawei.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH 05/10] crypto: hisilicon/hpre - Fix buffer overflow on odd ECDH input size
Date: Mon, 23 Nov 2026 15:09:56 +0000
Message-ID: <20261123151055.2533735-6-lee@kernel.org>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
In-Reply-To: <20261123151055.2533735-1-lee@kernel.org>
References: <20261123151055.2533735-1-lee@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

hpre_ecdh_src_data_init() validates the input public key length using
ctx->key_sz - (len >> 1) < 0 before copying len bytes into the upper
half (offset ctx->key_sz << 1) of a (ctx->key_sz << 2)-byte coherent
DMA buffer.

Because len >> 1 truncates the least significant bit, an odd input
length of (ctx->key_sz << 1) + 1 (such as 65 bytes for NIST P-256)
evaluates shift to 0, bypasses the bounds check, and writes one byte
past the end of the coherent DMA allocation in
scatterwalk_map_and_copy().  A zero length when ctx->key_sz is unset
similarly bypasses the check.

Reject zero, odd, or oversized lengths explicitly before computing the
coordinate offset.

Fixes: 05e7b906aa7c ("crypto: hisilicon/hpre - add 'ECDH' algorithm")
Closes: https://sashiko.dev/#/bug/linux-42c6cdd1-7f7e-4071-bb2f-a4db5935267e
Cc: stable@vger.kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
index 66a276786a7d..78ae987d338a 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1484,9 +1484,10 @@ static int hpre_ecdh_src_data_init(struct hpre_asym_request *hpre_req,
 	int shift;
 
 	/* Src_data include gx and gy. */
+	if (unlikely(!len || (len & 1) || len > (ctx->key_sz << 1)))
+		return -EINVAL;
+
 	shift = ctx->key_sz - (len >> 1);
-	if (unlikely(shift < 0))
-		return -EINVAL;
 
 	ptr = dma_alloc_coherent(dev, ctx->key_sz << 2, &dma, gfp);
 	if (unlikely(!ptr))
-- 
2.56.1.750.gf70dc682cf-goog

