Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A9F2563
	for <linux-crypto@vger.kernel.org>; Sat, 20 Apr 2024 05:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713592520; cv=none; b=pIQMpv9Dw1o1CvqWSQhVjJ0nMa4AztWW4hqMHlyr0RjzIcTvHKs4n1bcV3hFGXUUiHsir47GHLbxYpCftEdBChIHqYZosmnLMtObYjMAnwbmYdKSxT3geSIFnojS63AAXLp9f+R3pZ4X5AyrtlFmnsK/YqSB4YpLVh9qChI2Bgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713592520; c=relaxed/simple;
	bh=LTc0gFb4N2F95I5oWv+o2EIp3INIrFlpfFLvrZi6GgE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZqciakYy8EylySkqlVcwM4gN4FBeMFA1IkmW4pXLYL6NKYQP5pxbRJacJ5X7ig5oh82HnnhCwXV0BMv9Um9mlB9o8XgRnajjDfGkBaz6w0qXJClA7CGIZjtZ6CJ99c9H2p3XfY5IF4wp3zQPK9DSYV/NU7WAoUxXxAyHrrNHzGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KIvF8efd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KIvF8efd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA4DC072AA;
	Sat, 20 Apr 2024 05:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713592520;
	bh=LTc0gFb4N2F95I5oWv+o2EIp3INIrFlpfFLvrZi6GgE=;
	h=From:To:Cc:Subject:Date:From;
	b=KIvF8efdSEvuFm2BjphUJ9fzej9/stSng1sXnJp+NhTekeFgxAYtY/ZwAK/dNaHza
	 aYB4WV5hXV91JG5RxeUT0kp1REsnQllTWnaSMWzAojmwYwLDMhrnxHevUshHtawCAt
	 ChoGtAIEcY5zQAkarxsDuji+9aAui1YnYlTDNBniCnYe8YNhZWf4ukZPtKjdxCvGmw
	 DKGn+DSednX0nWkDVVPnFM2WzIuSuqgskr4GJkxMrZgAshUyg3Uo8Kk9TvFiAngIUz
	 VT8lpOz1gR1i/8P8d5yaO5W71Kgz8Q3Wi+Q7Eh2uvLbG2zNnxoSdQngmYqVFvjSQVX
	 LXCazZ0GoGT3A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org
Subject: [PATCH] crypto: x86/aes-xts - simplify loop in xts_crypt_slowpath()
Date: Fri, 19 Apr 2024 22:54:55 -0700
Message-ID: <20240420055455.25179-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Since the total length processed by the loop in xts_crypt_slowpath() is
a multiple of AES_BLOCK_SIZE, just round the length down to
AES_BLOCK_SIZE even on the last step.  This doesn't change behavior, as
the last step will process a multiple of AES_BLOCK_SIZE regardless.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aesni-intel_glue.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 110b3282a1f2..02a4c0c276df 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -933,20 +933,17 @@ xts_crypt_slowpath(struct skcipher_request *req, xts_crypt_func crypt_func)
 	}
 
 	err = skcipher_walk_virt(&walk, req, false);
 
 	while (walk.nbytes) {
-		unsigned int nbytes = walk.nbytes;
-
-		if (nbytes < walk.total)
-			nbytes = round_down(nbytes, AES_BLOCK_SIZE);
-
 		kernel_fpu_begin();
-		(*crypt_func)(&ctx->crypt_ctx, walk.src.virt.addr,
-			      walk.dst.virt.addr, nbytes, req->iv);
+		(*crypt_func)(&ctx->crypt_ctx,
+			      walk.src.virt.addr, walk.dst.virt.addr,
+			      walk.nbytes & ~(AES_BLOCK_SIZE - 1), req->iv);
 		kernel_fpu_end();
-		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
+		err = skcipher_walk_done(&walk,
+					 walk.nbytes & (AES_BLOCK_SIZE - 1));
 	}
 
 	if (err || !tail)
 		return err;
 

base-commit: 543ea178fbfadeaf79e15766ac989f3351349f02
-- 
2.44.0

