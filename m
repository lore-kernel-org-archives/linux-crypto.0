Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795118404;
	b=FQlxX+jm01c9pyD+ANpitJUt+D0nXdCnSff9RVxrMUdCQrNCXCnJO9rzIUWeBFMDf+2X
	 +BcOn1R2DZIZZ19hob95/MGGGO+O6XIGT8mYPHmg7z72CR0Mrw/d+cEMrbzNF0TIRWMll
	 KRD06UAvkHL/+x9Il7mFn7rOcJXVhwKt4US61n0ED8q5Ps9bVPoqKiH6RTk2ZwfcFvbA6
	 wu2qv3GNAB09+px67/WEkpRc/AUvt8Z3ZDvzPzzTRTIIRh948xaflWgI8AJ2dNHlyBP+m
	 HrAzkN4wjdtpi1mPxy+JDJjnVO9lsD852/yPvgihLQ2KpraWPjrPZJeY3iOj+IWmVAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795118404;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=WlBz7F/HU/h4BwcFnOKQUpgVpsdT7H4O6+TriPXRceU=;
	b=qrW9I8h2ILNWUnG3Kcqab8t26hCBltkLWCcO9GaSHKDIDgRFhBOl2+iJB/hLDZO4HcrM
	 GN1SUD/lvNfUwsi3kK8myF510eOhCgRRXPhHawRN9kuZVGAPzGDmadcikGm16Mans/dzL
	 xh7nFEA20YUG4nK4eJCj1y7eWz8hDvwmutaP/0kcolS4oj8i0dsQFEyzVEzioY6yuWnsn
	 LeiMYliDZBPorg1VCZBAFq8rNSz8YjibEYMxqzRFmAZi8Oe9Gc/H+m70lgKa/fmQ/LEQ2
	 BNptRGY+FjAEMh/qVAm0WL7oFfpCdoHFDzuKRn/7axarjZdbN0TKIVje+527kbuA3Og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=XeepIblc;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D7D7606A32A;
	Thu, 19 Nov 2026 20:00:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D7D7606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=XeepIblc
Received: from jeffbarnes-ThinkPad-P14s-Gen-2i.corp.microsoft.com (unknown [52.177.6.190])
	by linux.microsoft.com (Postfix) with ESMTPSA id ECD0920B7169;
	Thu, 19 Nov 2026 11:59:59 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com ECD0920B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1795118401;
	bh=WlBz7F/HU/h4BwcFnOKQUpgVpsdT7H4O6+TriPXRceU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XeepIblcMoOJaGzg3G6PeJ0Q577WMKIBWlYW/vYDr+/MGy3o4+4/umzkvVqZ81n1R
	 bkZ6qL7dBp4b03FyIGvkMgP6JNkrYfjeb1iWtE4A8lSiQdwN8J0Dp+77Dj30DWM8Wl
	 IQzKs3YGNaEMv0xDp5Xmapv8vZ62cecmAUeTIgdY=
From: Jeff Barnes <jeffbarnes@linux.microsoft.com>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	sahil.malhotra@oss.nxp.com,
	changwei.zou@canonical.com,
	meenakshi.aggarwal@nxp.com,
	tudor-dan.ambarus@nxp.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] crypto: caam - validate RSA scatterlist extents before mapping
Date: Thu, 19 Nov 2026 14:59:47 -0500
Message-ID: <20261119195948.816661-2-jeffbarnes@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261119195948.816661-1-jeffbarnes@linux.microsoft.com>
References: <20261119195948.816661-1-jeffbarnes@linux.microsoft.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rsa_edesc_alloc() passes the result of sg_nents_for_len() directly to
dma_map_sg(). An undersized source or destination scatterlist therefore
supplies a negative entry count to the DMA API. The destination alignment
walk also consumes this unchecked count.

Check both extents before walking the destination, allocating a bounce
buffer, or acquiring any DMA mappings. Propagate negative errors and
reject an empty extent with -EINVAL instead of attempting a zero-entry
mapping.

Keep this validation separate from the in-place DMA ownership fix so
that it can be backported independently.

Fixes: 8c419778ab57 ("crypto: caam - add support for RSA algorithm")
Cc: stable@vger.kernel.org
Signed-off-by: Jeff Barnes <jeffbarnes@linux.microsoft.com>
---
 drivers/crypto/caam/caampkc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.c
index 4f381b5010ab0..d81ef97861c0c 100644
--- a/drivers/crypto/caam/caampkc.c
+++ b/drivers/crypto/caam/caampkc.c
@@ -364,7 +364,12 @@ static struct rsa_edesc *rsa_edesc_alloc(struct akcipher_request *req,
 
 	src_nents = sg_nents_for_len(req_ctx->fixup_src,
 				     req_ctx->fixup_src_len);
+	if (unlikely(src_nents <= 0))
+		return ERR_PTR(src_nents < 0 ? src_nents : -EINVAL);
+
 	dst_nents = sg_nents_for_len(req->dst, req->dst_len);
+	if (unlikely(dst_nents <= 0))
+		return ERR_PTR(dst_nents < 0 ? dst_nents : -EINVAL);
 
 	req_ctx->bounce_buf = NULL;
 	req_ctx->fixup_dst = req->dst;
-- 
2.43.0

