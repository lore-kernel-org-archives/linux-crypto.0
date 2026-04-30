Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4E9377563;
	Thu, 30 Apr 2026 06:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777531076; cv=none; b=oZslhWzYIMDHBqnLW3Iy1KZfDNdoWRZY2kjvAGF/6z3Vgyjv1FWQVyQjdynQnMdQIdHx6vFi9vFTR0eN2Bx9uRYmmNFmMCmEV3GJtLLK5ZcSk7qQJy5J560YpllwJUeqmAjKpJAJa1eXgQTq/LeLrza584P5XWKXPMpO1p8K/YQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777531076; c=relaxed/simple;
	bh=/aG2RjoBxFDZ0SdTU70+NOuBeXB62tQmvHbwJZY5BJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KfdjsaRa3Rz14pYyMKXm71kEX/phP7o1RP+vVss174EeVRKnbiRzPuBsi2DtiuvGsqdkDXSzoi3gvMCqMXFzDBtAERfvEHnqrx5w+XYlmCpDtdmrjrwJ5/En0RJfBd42bT518n0+9BJdcqoDXfALtHoXnVQtKZOG/gQo9rrLUGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EhJbU1pr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EhJbU1pr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9956C4AF09;
	Thu, 30 Apr 2026 06:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777531076;
	bh=/aG2RjoBxFDZ0SdTU70+NOuBeXB62tQmvHbwJZY5BJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EhJbU1pr9g4T+4yqujIeQyeZ7ZjsDPMWoy+dk1faenzFpk1+E5yDy3MRwA9akHFjw
	 eropRSx8qfDtCZoaedHOtdgyvIVEsO3Q6P2PpdDrq9M5CLe6ifovea+YJqKEvOQ5mQ
	 K2K+PftHFPtmEFko8LrtWZwtszGDsBn4eZBpwGw9H2Ce/EG8D0yYj4Akm3e/zJq6Lu
	 XQUpoGaRcYBUDZGEoURpN518BPH8yAt0w81GV7SH+N65tlDMDEY74IIucQTOVmWKNR
	 PZRFm6rx2xmU8UKB+CtqVbTTwnwkXQMfuqfJGZbd2QzamFH6D4tlJGVjv0C8oZgviZ
	 HOiuN/zNJWdxQ==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Wolfgang Walter <linux@stwm.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.15 7/9] crypto: authencesn - Fix src offset when decrypting in-place
Date: Wed, 29 Apr 2026 23:36:02 -0700
Message-ID: <20260430063604.173525-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430063604.173525-1-ebiggers@kernel.org>
References: <20260430063604.173525-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 1f48ad3b19a9dfc947868edda0bb8e48e5b5a8fa upstream.

The src SG list offset wasn't set properly when decrypting in-place,
fix it.

Reported-by: Wolfgang Walter <linux@stwm.de>
Fixes: e02494114ebf ("crypto: authencesn - Do not place hiseq at end of dst for out-of-place decryption")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/authencesn.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index 5dc057cb0cdf..2154d4ab5c95 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -233,13 +233,15 @@ static int crypto_authenc_esn_decrypt_tail(struct aead_request *req,
 	if (crypto_memneq(ihash, ohash, authsize))
 		return -EBADMSG;
 
 decrypt:
 
-	if (src != dst)
-		src = scatterwalk_ffwd(areq_ctx->src, src, assoclen);
 	dst = scatterwalk_ffwd(areq_ctx->dst, dst, assoclen);
+	if (req->src == req->dst)
+		src = dst;
+	else
+		src = scatterwalk_ffwd(areq_ctx->src, src, assoclen);
 
 	skcipher_request_set_tfm(skreq, ctx->enc);
 	skcipher_request_set_callback(skreq, flags,
 				      req->base.complete, req->base.data);
 	skcipher_request_set_crypt(skreq, src, dst, cryptlen, req->iv);
-- 
2.54.0

