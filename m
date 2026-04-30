Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FFF375AAD;
	Thu, 30 Apr 2026 06:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777530584; cv=none; b=M5VtsegWswgZ3PGjdmfGMgp/v3sb4bGZ5tabyacUwDGduWnDIj1l1kd3+ED1Y/mt133JGCgxvhGB0SQ7RoFV9P88p/R2tvGf7jTLtRdrz110UX4qirfB/AA8QnwuIUueJkVqgpi0OsTEVFNteF/Wrzxub0uK5RlDY84rmlrjvyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777530584; c=relaxed/simple;
	bh=/aG2RjoBxFDZ0SdTU70+NOuBeXB62tQmvHbwJZY5BJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OXE9jaae6n4iDAaZ0YA0hrltCPBUmLjPEeYm23d6lp2TYuKHVG2VflGs5oQx/eJQ+oj4Kg+2ctAPZeWNHnqRZBvD11WpqiKRGXmWYS9tYD2t3Ifv25EtEiXgV/ydf45eCv8NUpez7Jm5tUeFZ3RpER5L/A3ad1WQsJsyl1a5+Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iO+Je2Ei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iO+Je2Ei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63378C2BCB8;
	Thu, 30 Apr 2026 06:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777530584;
	bh=/aG2RjoBxFDZ0SdTU70+NOuBeXB62tQmvHbwJZY5BJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iO+Je2Eieyl5Ae+Darr3NBA3p2qKWk9qSpIHj3xrvvQxZsOmr8QhvpgWBJoZaPLB+
	 nVmgL6LKIyN0XCpebS4/lDlst6HA8W7uzcTsvTrhc2EVGjenGcju2t9IPPWZMI07L/
	 Z/9KSbsAgeiNfJ/RwhuaxcIOmdDWn8oFN/yGP96CC+E5EocsBXgQlSedDbGG6EL0Vb
	 +8bst7iLa6Y4VPZ6bE5D1A9nIGEKu7uqOpR1Q5LNuyXaiAvmKDf15tJhuxH/yC6yTx
	 rx6kjTqjFAkxhjUZrldL+/jvGHNV7Nw6/BfQnKprqB5gorsH0As2OS0YWDbcitK8ba
	 +mBXIPE2usLOQ==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Wolfgang Walter <linux@stwm.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.1 7/9] crypto: authencesn - Fix src offset when decrypting in-place
Date: Wed, 29 Apr 2026 23:27:29 -0700
Message-ID: <20260430062731.140497-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430062731.140497-1-ebiggers@kernel.org>
References: <20260430062731.140497-1-ebiggers@kernel.org>
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

