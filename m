Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4AFA39902C;
	Thu, 30 Apr 2026 07:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777532613; cv=none; b=Acg7hBi0T0wKyi+4OH0vv9Bb8zB9iPYD8o3wAAP78+H/eBH8S3Ka2TajHIOxW4Q9WdFx/hz7M4u3/+ogg4fVT+CeGbEQjF2GyEhbpbDhA5GxLd64DD4QipoJmiQCIRtUPAEYqH0M4trjPR8QnGgYx+7Aft1WgTVuniu3s7sHyyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777532613; c=relaxed/simple;
	bh=/aG2RjoBxFDZ0SdTU70+NOuBeXB62tQmvHbwJZY5BJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5V3TV8fFpOBsOAmH0bay2fK7EIPM3FCIYMmv/URZFiJ7bE26B35nLystsMYhq+ujDD2XpCGroZzBxw380KUV6mr6iIPqU7/kJNsC8Fiei00PL1ju3aTYRqu/EiLvtdieLSwlo4YXNwVSsTZz3+zMd7lmkO1ffMs1v0s9B+PpuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MvYoWeUJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MvYoWeUJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B22C2BCB3;
	Thu, 30 Apr 2026 07:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777532613;
	bh=/aG2RjoBxFDZ0SdTU70+NOuBeXB62tQmvHbwJZY5BJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MvYoWeUJfNydAtKwiylPXwxHCEo4Rc/jt5D8X8Bq0irYpbTRBKPtf7zNtTToehJfQ
	 GV/PGHK6z4pCqNeo30wvjIOO3ZmlcT/IUqDV/OtmBHYjC73FckSCfyYa6IcOv9owsb
	 pchkyFwuFCHCOP7xwXVHFe0xOz9KsK3lAlNAP7fSORyVEbrCA9wCfizn/QBZ9futGw
	 G/WYKREwmyuuSEhWQynOX2H1HSJuBm01uHLuc8m1KO/39gB87+esO4ERDEl9uG2mLC
	 gRGPANhMKTmFRO7Wf2sGYM/f1uesLoc4DN71gmMl3kUHTc0yaTNLy/aBPWF4X/DtnO
	 7tvQ9gP7ImnwQ==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Wolfgang Walter <linux@stwm.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.10 08/10] crypto: authencesn - Fix src offset when decrypting in-place
Date: Thu, 30 Apr 2026 00:01:26 -0700
Message-ID: <20260430070128.219863-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430070128.219863-1-ebiggers@kernel.org>
References: <20260430070128.219863-1-ebiggers@kernel.org>
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

