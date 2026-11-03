Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793741586;
	b=14AOv9rQ6LSwYOTY54fKdCVooHFRPqRokKSf1tHz/CaM+uhSt/8kw2i1wPvP/ZecmC7y
	 JrCGJNgsRO5CQMENWQdZD+smMP1nRe5HamUIlEachAmaL5UMVvUCBsay2oM0p8U/YUZty
	 /LWI2mbduaNqg8qJOHV4Q3R3BlxwM5CutYonK/u2dZ5zWzDsQwRj6LJvzKZX6gyd12nHN
	 DNDz5bbmeYD9jrcVbsHsRDSq305daqn0TKRzaLLU2s7s7aA6rYifq/XC6FpZxhLh6ZhU8
	 PWp1plpDxWAHGHAfHarVyXKH3kepI6zgFA4JojszE7rY8XkrkoZRq3k+SaYPvoqhHPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793741586;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:X-Developer-Signature:X-Developer-Key:
	 Content-Transfer-Encoding;
	bh=UITpgR/WG3sMmpBhiDEynfdsoVXjWJp4sNC8YILTOR4=;
	b=eptdJfsZKIR7cKPA0ISy4xurd6p+GpPv2uSVPzJAjldOllbDAPw94IOR7FIsyy4FYnpt
	 0SfoaK2GvyJYuckQb+KuNMlmiThD/m2fJOQ/QAgjT2S/U8NdPR4HFWgxxuPJbbj0okaVq
	 UUeL00DMoPFQaEVaMqi1hN87cmdnSCRsx6iP0GYgqOiCX6PBMymGunzKRm420LicecqgV
	 fiKTm48n5e56uBE+xPvfMvYZdlms4batKz0tAmEgOB/yu2/Wz08bM0+P9gRm7cavzmrJe
	 gDomqbsFvICfJJaRrIhXyJ8qi1qseGIELrlWzPVnnIrRPOVuuQhggC5PFNwrPsetFFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kkjb1fTv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35998606A31B;
	Tue,  3 Nov 2026 21:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kkjb1fTv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C531F000C1;
	Tue,  3 Nov 2026 21:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793741585;
	bh=UITpgR/WG3sMmpBhiDEynfdsoVXjWJp4sNC8YILTOR4=;
	h=From:To:Cc:Subject:Date;
	b=kkjb1fTv9lriQEjrwVXX/F4iNglEKn+CJm2hGBiGb/ln1fg+TN/Veuc6iaR4EXGD0
	 rsxV5xRvgmNllmjTAqqDLhrV+UqbdDksvfuyQUY6lx31E7tTrBAXCVdNGYl0Fm1WO9
	 PspAsyet4yEnAv3neIbe0YQi+v8bSm7MPpXHpsOmFZ8wS2Nhh3RQoVfPwcQdnlVK1y
	 7oAqCs/Y3OtdQVPSWtOisu4jQtRL1kPRHNKSr8k0w4SuvGKgIBNr6g1epj3Mqr/pAn
	 ujS35DXvmTOE4eCua7KcmZhIl0sKcS69UUOkCKO2CPCjbmbL95E0YXmF3IP1A0GLG1
	 MjgSqcoHBAeeA==
From: Thorsten Blum <blum@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Keerthy <j-keerthy@ti.com>,
	Tero Kristo <t-kristo@ti.com>
Cc: Thorsten Blum <blum@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: sa2ul - remove redundant 0x prefixes
Date: Tue,  3 Nov 2026 22:32:43 +0100
Message-ID: <20261103213242.480649-2-blum@kernel.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3106; i=blum@kernel.org; h=from:subject; bh=En9TdJx2JNSBwkxx3VVLAzIC9JU5hAIajtfLwpQpXrE=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFmvgn5xzjy5aVfdivhJsqsuVM725HgkzWp8+9jcfXJGp 4RPy1l/7ihlYRDjYpAVU2R5MOvHDN/SmspNJhE7YeawMoEMYeDiFICJ8Fgz/E/59uKcwsPyiYmn Ys0X7Du3VJA1xokrrtZE9ueaefznG1MZ/vvc3Z7wWudNzvRttqtubl/Ny2F358Mj47npfdKTfTf szWAHAA==
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

The %pad format specifier already includes the 0x prefix. Remove the
redundant prefixes to avoid printing 0x0x.

Also remove the duplicate colon from the security context dump message.

Fixes: 7694b6ca649f ("crypto: sa2ul - Add crypto driver")
Fixes: 2dc53d004745 ("crypto: sa2ul - add sha1/sha256/sha512 support")
Fixes: d2c8ac187fc9 ("crypto: sa2ul - Add AEAD algorithm support")
Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 drivers/crypto/sa2ul.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 4557eae94164..e026fc14a411 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -652,7 +652,7 @@ void sa_set_swinfo(u8 eng_id, u16 sc_id, dma_addr_t sc_phys,
 static void sa_dump_sc(u8 *buf, dma_addr_t dma_addr)
 {
 #ifdef DEBUG
-	dev_info(sa_k3_dev, "Security context dump:: 0x%pad\n", &dma_addr);
+	dev_info(sa_k3_dev, "Security context dump: %pad\n", &dma_addr);
 	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_OFFSET,
 		       16, 1, buf, SA_CTX_MAX_SZ, false);
 #endif
@@ -781,7 +781,7 @@ static void sa_cipher_cra_exit(struct crypto_skcipher *tfm)
 	struct sa_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct sa_crypto_data *data = dev_get_drvdata(sa_k3_dev);
 
-	dev_dbg(sa_k3_dev, "%s(0x%p) sc-ids(0x%x(0x%pad), 0x%x(0x%pad))\n",
+	dev_dbg(sa_k3_dev, "%s(0x%p) sc-ids(0x%x(%pad), 0x%x(%pad))\n",
 		__func__, tfm, ctx->enc.sc_id, &ctx->enc.sc_phys,
 		ctx->dec.sc_id, &ctx->dec.sc_phys);
 
@@ -822,7 +822,7 @@ static int sa_cipher_cra_init(struct crypto_skcipher *tfm)
 	crypto_skcipher_set_reqsize(tfm, crypto_skcipher_reqsize(child) +
 					 sizeof(struct skcipher_request));
 
-	dev_dbg(sa_k3_dev, "%s(0x%p) sc-ids(0x%x(0x%pad), 0x%x(0x%pad))\n",
+	dev_dbg(sa_k3_dev, "%s(0x%p) sc-ids(0x%x(%pad), 0x%x(%pad))\n",
 		__func__, tfm, ctx->enc.sc_id, &ctx->enc.sc_phys,
 		ctx->dec.sc_id, &ctx->dec.sc_phys);
 	return 0;
@@ -1447,7 +1447,7 @@ static int sa_sha_cra_init_alg(struct crypto_tfm *tfm, const char *alg_base)
 		}
 	}
 
-	dev_dbg(sa_k3_dev, "%s(0x%p) sc-ids(0x%x(0x%pad), 0x%x(0x%pad))\n",
+	dev_dbg(sa_k3_dev, "%s(0x%p) sc-ids(0x%x(%pad), 0x%x(%pad))\n",
 		__func__, tfm, ctx->enc.sc_id, &ctx->enc.sc_phys,
 		ctx->dec.sc_id, &ctx->dec.sc_phys);
 
@@ -1584,7 +1584,7 @@ static void sa_sha_cra_exit(struct crypto_tfm *tfm)
 	struct sa_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct sa_crypto_data *data = dev_get_drvdata(sa_k3_dev);
 
-	dev_dbg(sa_k3_dev, "%s(0x%p) sc-ids(0x%x(0x%pad), 0x%x(0x%pad))\n",
+	dev_dbg(sa_k3_dev, "%s(0x%p) sc-ids(0x%x(%pad), 0x%x(%pad))\n",
 		__func__, tfm, ctx->enc.sc_id, &ctx->enc.sc_phys,
 		ctx->dec.sc_id, &ctx->dec.sc_phys);
 
@@ -1664,7 +1664,7 @@ static int sa_cra_init_aead(struct crypto_aead *tfm, const char *fallback)
 		return ret;
 	}
 
-	dev_dbg(sa_k3_dev, "%s(0x%p) sc-ids(0x%x(0x%pad), 0x%x(0x%pad))\n",
+	dev_dbg(sa_k3_dev, "%s(0x%p) sc-ids(0x%x(%pad), 0x%x(%pad))\n",
 		__func__, tfm, ctx->enc.sc_id, &ctx->enc.sc_phys,
 		ctx->dec.sc_id, &ctx->dec.sc_phys);
 
