Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F00E552
	for <linux-crypto@vger.kernel.org>; Mon,  7 Oct 2024 01:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728264296; cv=none; b=T5DqYdPcwi8XXlXUMXG4v/fLV5A+48fbfnY3OU9LNUSALBbHx5xSAso6lYKTnVCyCSTBswIoAFulKjwu2uGQ+0USz9MI3y7Q46DSs2VHXKhKideyLmDPjm+RL5sH4z/NYRyYV+E8IiD+HCtEB/noauZ5h+pRflTdt4r72KF52Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728264296; c=relaxed/simple;
	bh=HcQC+jvPVUJx2RKcjbg0itHn7eBtluu0O12lQvkpdxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrxSsZpmRdkXebw+fFQzfMGSyXZ8yvyx2zcwmzfL8swi7ZKPaDG1n8KzQtbRQtSr5AQnCK6PFowBorsLT170UXQjs45ns+I3X/HaDoPKWRL2Wv8QuTCLSTMf+R2YOOBH58cYe6Rgc+INYR8EaUX63sy2hh2v8ehX8DpQo4NgAVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tS6OFWY8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tS6OFWY8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AFF0C4CED1;
	Mon,  7 Oct 2024 01:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728264296;
	bh=HcQC+jvPVUJx2RKcjbg0itHn7eBtluu0O12lQvkpdxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tS6OFWY8NDw8G8vPUTuSHHERsO9WiRbh9GgcfOJPNo1TAVFUbf1F8FexwE4yoe7fP
	 JYrXPR3TEekFx4Tur4Ay0Zc7kS/XaW7Z5qe08U8jcblS9/buwCAKDYp+1sPC4Qqx+f
	 XKpXceC9rBAACkJLntGOsDr3v5haenc4H2yt2G+4vTX2xIR1hOhRk/ANEdVIbawd33
	 Ek483kQKYGAuKM2A+J3PIBQ/s/QzmuFXqZTp3B94vxF7pCaz7mnso0h0ZG/1f0CCLQ
	 jEcPDtt7kUR2pw0R3CCaylbgnQwfuL4HMrn87DcubznldFiGA/yg8L6CZBRXHZSsOV
	 +udhEF/gcKsAg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org,
	Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH 02/10] crypto: x86/aegis128 - remove no-op init and exit functions
Date: Sun,  6 Oct 2024 18:24:22 -0700
Message-ID: <20241007012430.163606-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241007012430.163606-1-ebiggers@kernel.org>
References: <20241007012430.163606-1-ebiggers@kernel.org>
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

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aegis128-aesni-glue.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/x86/crypto/aegis128-aesni-glue.c b/arch/x86/crypto/aegis128-aesni-glue.c
index 4623189000d8..96586470154e 100644
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
2.46.2

