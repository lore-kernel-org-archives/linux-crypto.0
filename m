Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB174308A61;
	Mon,  5 May 2025 22:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746484099; cv=none; b=gnZODx6QS9c35df2tZQwcf3kWLmXdf0bH1x758tM1HtOrrAyUp7DE39RipaGYO8Ps42srZUtqgdf0j4qKtrYkf8Qt06sxvSR0uW4WHuqtVV42W9pMxxIfueM3GNHfqojAY7PaxFYqDXgMmcFDv1ggQEHc2yTUXXpQrHwdll0SFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746484099; c=relaxed/simple;
	bh=KYs1DcZ9bQzi1x2KNqpBUUAnWSnl28KCMr23ouWcsps=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hVjHfMLHci2mdYTT0Kake7JYVoYd/FMMT7BsuQEYxZ/ynb5r6KpOaH2baoTRq2yqMBjiFVhhmRJz3A/2rEjXGtJ2jJUSrC0YOMQsxkBnYuGqxxc10VxCjnvgGNOjMrfoPzwpob4dN7br2BGkCO1ZDKPTzrncsRFKSICLax3yknc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jLAXQ1Ob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jLAXQ1Ob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF78C4CEE4;
	Mon,  5 May 2025 22:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746484098;
	bh=KYs1DcZ9bQzi1x2KNqpBUUAnWSnl28KCMr23ouWcsps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLAXQ1Ob3iwgRzW+CKc50YphkT4hrB9W+3On/6BAFVseYmjWfJtCzwbaGfxysZnyC
	 7NoehpoJSUpVdKSfyc68sH6PnQaKiAAH1bhfp+MgaZ5vJhkiDC+HervGDa0OFiRMfY
	 7QeDoK/O20Yjh2kD02nEyPZ9fM1F+ollpIXboZxmB+XDaGbMf6BIykq32h8sGtQmf3
	 LR8RDLlH+jgby/5Q5DBTbPoMf+8scjdb51dSjFMu5TFKpZ+yPYGcitIG0HwvXxBiC2
	 8A21ULALGAgaaVRR7mEia52MTMyLSpSj9vsA2NUMsvmXxN6Zvxw+n/Jijo/aaFx2fZ
	 XFqOzMxNZ7+6Q==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 349/642] crypto: ahash - Set default reqsize from ahash_alg
Date: Mon,  5 May 2025 18:09:25 -0400
Message-Id: <20250505221419.2672473-349-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505221419.2672473-1-sashal@kernel.org>
References: <20250505221419.2672473-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
Content-Transfer-Encoding: 8bit

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 9e01aaa1033d6e40f8d7cf4f20931a61ce9e3f04 ]

Add a reqsize field to struct ahash_alg and use it to set the
default reqsize so that algorithms with a static reqsize are
not forced to create an init_tfm function.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/ahash.c        | 4 ++++
 include/crypto/hash.h | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index b08b89ec26ec5..63960465eea17 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -489,6 +489,7 @@ static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 	struct ahash_alg *alg = crypto_ahash_alg(hash);
 
 	crypto_ahash_set_statesize(hash, alg->halg.statesize);
+	crypto_ahash_set_reqsize(hash, alg->reqsize);
 
 	if (tfm->__crt_alg->cra_type == &crypto_shash_type)
 		return crypto_init_ahash_using_shash(tfm);
@@ -654,6 +655,9 @@ static int ahash_prepare_alg(struct ahash_alg *alg)
 	if (alg->halg.statesize == 0)
 		return -EINVAL;
 
+	if (alg->reqsize && alg->reqsize < alg->halg.statesize)
+		return -EINVAL;
+
 	err = hash_prepare_alg(&alg->halg);
 	if (err)
 		return err;
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 2d5ea9f9ff43e..6692253f0b5be 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -132,6 +132,7 @@ struct ahash_request {
  *	      This is a counterpart to @init_tfm, used to remove
  *	      various changes set in @init_tfm.
  * @clone_tfm: Copy transform into new object, may allocate memory.
+ * @reqsize: Size of the request context.
  * @halg: see struct hash_alg_common
  */
 struct ahash_alg {
@@ -148,6 +149,8 @@ struct ahash_alg {
 	void (*exit_tfm)(struct crypto_ahash *tfm);
 	int (*clone_tfm)(struct crypto_ahash *dst, struct crypto_ahash *src);
 
+	unsigned int reqsize;
+
 	struct hash_alg_common halg;
 };
 
-- 
2.39.5

