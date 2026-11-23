Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795446697;
	b=PnFrvo8v6C4Qe97VrT3tb1FZBGeTJYFNutmnaxwn1iCGa++bnBDv4Jix82DQIvhsTiOn
	 252aO/3ZJzXgG70cXBcRdD/M3v8uJ8LZAtKinMIzp20HfInw4eACL4+l4jUl1sDAhUEyh
	 1OQFNtScsS8BiB6oQTmOQmH4PBERAKDjHcBctcCZvP9qTfPLF7BkzulPi2LiQMs+sWd6Y
	 aJWYgJTn2Y8/D/qV9s1JDm/owAA8NS2/G/vMM9RLsVpqe7Oxa4IIiHNZ126xHGfTgyHps
	 iDqQ3CsPASH16gXBYHP1ydGtCXd/Ge/TSxoLstgklkGgXthjGzX1gU3tRRuxTlgsPKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795446697;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=STeVH55BBeBKM6xcTx+69M7sUEKnUAjtUBsUatOVMGw=;
	b=bNT7CdbpJbcNfA6mdeOEl1gRGOXAPj1UUIG9DajsqDuZowBX7BMoErxLal2L8nz8k7EP
	 VO62ebH9mjtIakpmviG63sK34Oi8mJXBQKFZk1dPwPGjipAlwDzrFihEzDrBEAEDPJAxn
	 CjPptvXyWY61Ux2iMhGHMYrQ180+2B5H55vU2Bh/tn/uVNpcpgkecmDL6UOAblloZ82ND
	 U3cPspJJjTQjw2vANRxSXXFSr3+3b/dWSE61XmPq2l4H1NRlq9jkP6Y1kzQe/ucZ7i0a4
	 K+wQPImXkpAoTZX0vpGgHWN5Rq5Ojcc8TgXrbeUsFlG6/7VXb36VXUy2McUJN2UnqZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iQuxI9z5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87C7606A32C;
	Mon, 23 Nov 2026 15:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iQuxI9z5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282D31F000CF;
	Mon, 23 Nov 2026 15:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795446697;
	bh=STeVH55BBeBKM6xcTx+69M7sUEKnUAjtUBsUatOVMGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iQuxI9z5WzUZZyvlumpBl7lcu5ipk202NNdsZPnzmCgWGAvZa1ay60Fxq64Rp5KCp
	 rHfctmjrETxSiuULSIL7i3VOpXh35crvqibh3btRqwuRLzMrSHbul92HPic8ircLfH
	 bsBKfrFNI6SwINufuwPRKS98uTt0xnRuI8hfm40Khn+C+Od/orlQuiEyBHGUz2RUzQ
	 R5nMiXWOcIHzT7NwxLinqSHvkCdZYQeJRzl/w1gyX1j7qQsXTtr6mqzkCDfJnRulc7
	 66NyzfOQZY98dQ23iYtSbhtTGi+T+R3x0cP4LkbwXIyWS31Yiok+k7lUWRtO3iCOt8
	 74cstbe/A8PZg==
From: Lee Jones <lee@kernel.org>
To: lee@kernel.org,
	Corentin Labbe <clabbe.montjoie@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Chen-Yu Tsai <wens@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>,
	bui duc phuc <phucduc.bui@gmail.com>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH 04/10] crypto: sun8i-ss - Fix scatterlist array overflow for HMAC requests
Date: Mon, 23 Nov 2026 15:09:55 +0000
Message-ID: <20261123151055.2533735-5-lee@kernel.org>
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

sun8i_ss_hash_need_fallback() reserves one hardware scatterlist slot
out of MAX_SG (8) for the trailing hash padding buffer, allowing up to
7 input scatterlist entries.

However, for HMAC requests (tfmctx->keylen > 0), sun8i_ss_hash_run()
also shifts the mapped source array up by one slot to insert the inner
pad at index 0 and increments i before writing the trailing padding
entry at rctx->t_src[i] and rctx->t_dst[i].  When an HMAC request
contains 7 block-aligned scatterlist entries, i reaches 8 (MAX_SG),
writing past the end of rctx->t_src and rctx->t_dst, corrupting
rctx->method and rctx->flow, and indexing out of bounds into ss->flows.

Reserve an extra scatterlist slot in sun8i_ss_hash_need_fallback() when
tfmctx->keylen is non-zero so 7-entry HMAC requests use the software
fallback.

Fixes: 801b7d572c0a ("crypto: sun8i-ss - add hmac(sha1)")
Closes: https://sashiko.dev/#/bug/linux-93388c71-507c-42fd-9c86-8076b06fc7c0
Cc: stable@vger.kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
index 56ba4ff6d5ff..c2e0c6520f84 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
@@ -344,9 +344,11 @@ static int sun8i_ss_run_hash_task(struct sun8i_ss_dev *ss,
 static bool sun8i_ss_hash_need_fallback(struct ahash_request *areq)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct sun8i_ss_hash_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
 	struct ahash_alg *alg = crypto_ahash_alg(tfm);
 	struct sun8i_ss_alg_template *algt;
 	struct scatterlist *sg;
+	int max_sg;
 
 	algt = container_of(alg, struct sun8i_ss_alg_template, alg.hash.base);
 
@@ -360,8 +362,9 @@ static bool sun8i_ss_hash_need_fallback(struct ahash_request *areq)
 		return true;
 	}
 
-	/* we need to reserve one SG for the padding one */
-	if (sg_nents(areq->src) > MAX_SG - 1) {
+	/* Reserve one SG for padding and, for HMAC, one for ipad */
+	max_sg = tfmctx->keylen ? MAX_SG - 2 : MAX_SG - 1;
+	if (sg_nents(areq->src) > max_sg) {
 		algt->stat_fb_sgnum++;
 		return true;
 	}
-- 
2.56.1.750.gf70dc682cf-goog

