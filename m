Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795446724;
	b=tB+30exjGmoLRv2nx4VV6WINblK2e0l9552kRB+LQL5B2uJzvbpBDYlqto0zOwXMl08I
	 5eeJzR7JJzHp56AYZR0nxm29nTSc+NZT/OU8+UpGFL8QmEZZDtsVxjL81O26YCDjKGZ+g
	 o3eENwj+nsfTdjcQ1ytVnq0Q7TqBxOeKhkjWkKw/6dT4q0xo7GFOXClZSNLESskGxUm3n
	 AsBEkT+n9mxSBjd+hXeaNj4vLj2AGuLMOH8QoXwIiQNH82ibhLO4E84e6a0vTV7UKfsLy
	 32Mmj+hyF8r6Y+Zsqryv3Zz1vfbom/xs02zb/RIGm+nCuDscJw78aoSW7Qv2WDiOh7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795446724;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=942v3ZCrBQ0IIQdj+0OgDIT+vLHnq12r1KgKzAslZE4=;
	b=jJ2MW5vV336T2GcP8A+QJt0n8mdWTv9wE2TgKSIXI/TzGXPBs6c+rmUqLtitirV3wDEe
	 3sz0+naG5s4MwfCyLUceZcO54tFtwckWts/vIsf4uZtfvmvb3JtOry/meHxoRdVBHaV2C
	 CjMHMAaR3oRqwM9JYj6Jktc17cqW8ok5RhGKRuUwk2tJ1PtVpSHPM+ApK7dQEEYnYZmzg
	 cxoqkNVboOS0XYDls7659D0i9vtdMs5xvQvlluagnBXc3mD8mEpy00z6nW9nHvw8xJBS+
	 KRJarRgyAvVC9YYz0ZTQyepCg3kogUNgGj3tR1xbj32lnjaEz2SfwRUUFu/Ntx/gJ9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iJ1660FV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6E3606A327;
	Mon, 23 Nov 2026 15:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iJ1660FV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A4311F000CF;
	Mon, 23 Nov 2026 15:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795446724;
	bh=942v3ZCrBQ0IIQdj+0OgDIT+vLHnq12r1KgKzAslZE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iJ1660FVxTnDEtFWf3qFsQExOTK/em9zRj2LQuG2Gn5HevzPnjmuJpovE37WT+jIM
	 WrHwtoFVKHWiG4DX+1nzgHNdG6nJnWoQzehuIzqQT4H+wlw74JaUi3OKRQ0AbeA3xp
	 U869jefBJUP9xHSlDm+RPPulfm4Y8Qeon/lbKoJj1cJ4q8Yd7vraK5eiunD1JaaYlP
	 Jqx89M3ybGTv5hG31PV+GTGFqbgrnySJaVVi0fwBvWmyLXx2gnZcSpMxXWuHdNO4tE
	 8grLY/Y+Ag9mwFVzPn1CXr33p5T3cOmcFt6rUxzdaVpVn21enSsa+qf8hb7LXcc8td
	 oqdLTaMyU4NTA==
From: Lee Jones <lee@kernel.org>
To: lee@kernel.org,
	Bartosz Golaszewski <brgl@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thorsten Blum <blum@kernel.org>,
	Stanimir Varbanov <svarbanov@mm-sol.com>,
	linux-crypto@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH 08/10] crypto: qce - Pass mapped scatterlist count to qce_dma_prep_sgs()
Date: Mon, 23 Nov 2026 15:09:59 +0000
Message-ID: <20261123151055.2533735-9-lee@kernel.org>
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

In qce_ahash_async_req_handle(), dma_map_sg() maps req->src and returns
the number of coalesced DMA segments in ret, which is immediately
overwritten when mapping rctx->result_sg.  The function then passes the
unmapped segment count rctx->src_nents to qce_dma_prep_sgs().

When an IOMMU coalesces scatterlist entries so the mapped count is
smaller than rctx->src_nents, dmaengine_prep_slave_sg() walks past the
mapped entries and reads uninitialised DMA addresses and lengths from
the tail of req->src, while dma_unmap_sg() still requires the original
rctx->src_nents count.

Save the mapped segment count from dma_map_sg() in a dedicated
src_nents variable and pass it to qce_dma_prep_sgs(), matching the
skcipher path.

Fixes: ec8f5d8f6f76 ("crypto: qce - Qualcomm crypto engine driver")
Closes: https://sashiko.dev/#/bug/linux-24490c31-257a-4148-a816-0aaf416f64a1
Cc: stable@vger.kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
---
 drivers/crypto/qce/sha.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index b67d749db05f..56106f415db6 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -77,7 +77,7 @@ static int qce_ahash_async_req_handle(struct crypto_async_request *async_req)
 	struct qce_alg_template *tmpl = to_ahash_tmpl(async_req->tfm);
 	struct qce_device *qce = tmpl->qce;
 	unsigned long flags = rctx->flags;
-	int ret;
+	int ret, src_nents;
 
 	if (IS_SHA_HMAC(flags)) {
 		rctx->authkey = ctx->authkey;
@@ -93,8 +93,9 @@ static int qce_ahash_async_req_handle(struct crypto_async_request *async_req)
 		return rctx->src_nents;
 	}
 
-	ret = dma_map_sg(qce->dev, req->src, rctx->src_nents, DMA_TO_DEVICE);
-	if (!ret)
+	src_nents = dma_map_sg(qce->dev, req->src, rctx->src_nents,
+			       DMA_TO_DEVICE);
+	if (!src_nents)
 		return -EIO;
 
 	sg_init_one(&rctx->result_sg, qce->dma.result_buf, QCE_RESULT_BUF_SZ);
@@ -105,7 +106,7 @@ static int qce_ahash_async_req_handle(struct crypto_async_request *async_req)
 		goto error_unmap_src;
 	}
 
-	ret = qce_dma_prep_sgs(&qce->dma, req->src, rctx->src_nents,
+	ret = qce_dma_prep_sgs(&qce->dma, req->src, src_nents,
 			       &rctx->result_sg, 1, qce_ahash_done, async_req);
 	if (ret)
 		goto error_unmap_dst;
-- 
2.56.1.750.gf70dc682cf-goog

