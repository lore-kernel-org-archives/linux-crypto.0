Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C919F8BEE;
	Thu, 17 Oct 2024 00:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729123333; cv=none; b=ntq1tLSlbJLvqT5k5IiqEEfVzP5Q+4Nsc0Jn6vKPjQOSLgYdWpyZGg2iQtNOp72F9iYWTH4whteuAksrC88ezzjs0lGmvLDfNYEuq3cj8TJkRyZdLEb3fDV5FFgeARCRxHc/WcZY97mTikbWpJz61iPaGvy23YKyeEA/aC1lIzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729123333; c=relaxed/simple;
	bh=GOg2tfF66KOFcc1MBoC10XwLYKnKiGkh8fnJesLZqp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQmaGl4lDQtO9zPrElZ7z44buu/f1eUq+M+ehaArLWs9eCiF3OfXBLPWZOObiBFFqU1S8U461gVq/uAAaXHTiSufl3/4IQ4KNxd9jh8iYCICk/L1lk9hz2cvOWljkczbGeT7xyisYFqUgGSFjP7NiQab+h3OV56HeMjAg5cp4p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cMgU5Vxv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cMgU5Vxv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF28C4CED2;
	Thu, 17 Oct 2024 00:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729123333;
	bh=GOg2tfF66KOFcc1MBoC10XwLYKnKiGkh8fnJesLZqp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cMgU5VxvlVj3Foc0L25L1fWmDitGPxp+p3FTXXRPCmPxRHRQckFndpwjDZiu17Ce0
	 H/sa6SF7t5riuz/3trlNBsvFykwTteaJSY+b8Gt6l3yCzAOQ2VgtVjZTH73LX71bCk
	 +xxccrAS+fIMLX+jdMjtt0N0BTTzcrRYKp2/5FsuRRRSfQ1OxaQuI0BnnkJZNHKKye
	 xnvYRhlz6I8hNiTWmbUrAKrIyxCblJD4bk2TmNzzdgtWlY7KXhekC9eoMvYyxU7Nhg
	 0C7P5/9Y99uQlBrnWf2QsRB2WC/OZWy7Pj5/0gb5C5x0AuqKwQPAxzqkeHt3MzRAp1
	 w3eNZpPU16U7A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org,
	Ondrej Mosnacek <omosnace@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 02/10] crypto: x86/aegis128 - remove no-op init and exit functions
Date: Wed, 16 Oct 2024 17:00:43 -0700
Message-ID: <20241017000051.228294-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241017000051.228294-1-ebiggers@kernel.org>
References: <20241017000051.228294-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Don't bother providing empty stubs for the init and exit methods in
struct aead_alg, since they are optional anyway.

Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aegis128-aesni-glue.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/x86/crypto/aegis128-aesni-glue.c b/arch/x86/crypto/aegis128-aesni-glue.c
index 4623189000d89..96586470154e0 100644
--- a/arch/x86/crypto/aegis128-aesni-glue.c
+++ b/arch/x86/crypto/aegis128-aesni-glue.c
@@ -225,26 +225,15 @@ static int crypto_aegis128_aesni_decrypt(struct aead_request *req)
 	crypto_aegis128_aesni_crypt(req, &tag, cryptlen, &OPS);
 
 	return crypto_memneq(tag.bytes, zeros.bytes, authsize) ? -EBADMSG : 0;
 }
 
-static int crypto_aegis128_aesni_init_tfm(struct crypto_aead *aead)
-{
-	return 0;
-}
-
-static void crypto_aegis128_aesni_exit_tfm(struct crypto_aead *aead)
-{
-}
-
 static struct aead_alg crypto_aegis128_aesni_alg = {
 	.setkey = crypto_aegis128_aesni_setkey,
 	.setauthsize = crypto_aegis128_aesni_setauthsize,
 	.encrypt = crypto_aegis128_aesni_encrypt,
 	.decrypt = crypto_aegis128_aesni_decrypt,
-	.init = crypto_aegis128_aesni_init_tfm,
-	.exit = crypto_aegis128_aesni_exit_tfm,
 
 	.ivsize = AEGIS128_NONCE_SIZE,
 	.maxauthsize = AEGIS128_MAX_AUTH_SIZE,
 	.chunksize = AEGIS128_BLOCK_SIZE,
 
-- 
2.47.0

