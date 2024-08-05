Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9232A15B10C
	for <linux-crypto@vger.kernel.org>; Mon,  5 Aug 2024 18:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722882764; cv=none; b=Rg0m4JAH1CdnSfuaN4FU/BEVDRy3dD/h9kZbrRlHC6sXnwdUirDW98Q8UiNitiYJkr+ClgWwWUx0ew/iIYoG/ekaZK7ZP6HhfhHO9OBKYyKwXKC+Nkh1zTKKAz/1J4KkO19KKXVXj8Ma1c6OTXp1+teNH5vuuN73COmCKMpcBfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722882764; c=relaxed/simple;
	bh=2VZEf3K908crnNiPP3q8mxQFP5JuhJk6gP/LhchbfSM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sTAG0t5rGd5l0OUssI/EoSynaMspg7vaT4r3M2KytSREhkeR4doVAdYKyK9jRsLyyOJ7an9FL52eF/ndZjgi2k+7tR6yWXURTXzMuHswHybd4QRk14tyZZCu73ThCpGu1bcN5k3fiN3i/B9SiQn13totiTjV1TLSsXvn/UZUl7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aqW8HxUu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aqW8HxUu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA968C4AF0C;
	Mon,  5 Aug 2024 18:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722882764;
	bh=2VZEf3K908crnNiPP3q8mxQFP5JuhJk6gP/LhchbfSM=;
	h=From:To:Cc:Subject:Date:From;
	b=aqW8HxUui/g6eokk/wbbmm+PmPQCkObm++aC0IaWUCej0w9idj93c3P5lMnOEEobn
	 UQLTPdvbdCMH04MssF8I7udjPEHdu2dVRzJt8Peub68MABbhwHoXbajuQf0dtmJv32
	 03nRzjIsP/y4EsmU4mL04cvOuptwzfQGXj5i5rtc6muabXItfcdAI5aQ0S9HZADCZr
	 2NLU6KXeoeVcVWbdCI4tBvIgbgnbx8iWH/oE/+qn/z+F8yOgWnQiUHPP2pYtitL4nn
	 eZc8JZJERON8J1EQ2qbGVDRNgeRLIY2bvXevhbFg5AkPPkY/QBNrhyENtnVGchf88S
	 /wDUlmKg2uOmw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] crypto: x86/aes-gcm - fix PREEMPT_RT issue in gcm_crypt()
Date: Mon,  5 Aug 2024 11:27:13 -0700
Message-ID: <20240805182713.161198-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

On PREEMPT_RT, kfree() takes sleeping locks and must not be called with
preemption disabled.  Therefore, on PREEMPT_RT skcipher_walk_done() must
not be called from within a kernel_fpu_{begin,end}() pair, even when
it's the last call which is guaranteed to not allocate memory.

Therefore, move the last skcipher_walk_done() in gcm_crypt() to the end
of the function so that it goes after the kernel_fpu_end().  To make
this work cleanly, rework the data processing loop to handle only
non-last data segments.

Fixes: b06affb1cb58 ("crypto: x86/aes-gcm - add VAES and AVX512 / AVX10 optimized AES-GCM")
Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Closes: https://lore.kernel.org/linux-crypto/20240802102333.itejxOsJ@linutronix.de
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aesni-intel_glue.c | 59 ++++++++++++++----------------
 1 file changed, 28 insertions(+), 31 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index cd37de5ec4046..d63ba9eaba3e4 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1364,10 +1364,12 @@ gcm_crypt(struct aead_request *req, int flags)
 	/* Begin walking through the plaintext or ciphertext. */
 	if (flags & FLAG_ENC)
 		err = skcipher_walk_aead_encrypt(&walk, req, false);
 	else
 		err = skcipher_walk_aead_decrypt(&walk, req, false);
+	if (err)
+		return err;
 
 	/*
 	 * Since the AES-GCM assembly code requires that at least three assembly
 	 * functions be called to process any message (this is needed to support
 	 * incremental updates cleanly), to reduce overhead we try to do all
@@ -1379,41 +1381,35 @@ gcm_crypt(struct aead_request *req, int flags)
 
 	/* Pass the associated data through GHASH. */
 	gcm_process_assoc(key, ghash_acc, req->src, assoclen, flags);
 
 	/* En/decrypt the data and pass the ciphertext through GHASH. */
-	while ((nbytes = walk.nbytes) != 0) {
-		if (unlikely(nbytes < walk.total)) {
-			/*
-			 * Non-last segment.  In this case, the assembly
-			 * function requires that the length be a multiple of 16
-			 * (AES_BLOCK_SIZE) bytes.  The needed buffering of up
-			 * to 16 bytes is handled by the skcipher_walk.  Here we
-			 * just need to round down to a multiple of 16.
-			 */
-			nbytes = round_down(nbytes, AES_BLOCK_SIZE);
-			aes_gcm_update(key, le_ctr, ghash_acc,
-				       walk.src.virt.addr, walk.dst.virt.addr,
-				       nbytes, flags);
-			le_ctr[0] += nbytes / AES_BLOCK_SIZE;
-			kernel_fpu_end();
-			err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
-			kernel_fpu_begin();
-		} else {
-			/* Last segment: process all remaining data. */
-			aes_gcm_update(key, le_ctr, ghash_acc,
-				       walk.src.virt.addr, walk.dst.virt.addr,
-				       nbytes, flags);
-			err = skcipher_walk_done(&walk, 0);
-			/*
-			 * The low word of the counter isn't used by the
-			 * finalize, so there's no need to increment it here.
-			 */
-		}
+	while (unlikely((nbytes = walk.nbytes) < walk.total)) {
+		/*
+		 * Non-last segment.  In this case, the assembly function
+		 * requires that the length be a multiple of 16 (AES_BLOCK_SIZE)
+		 * bytes.  The needed buffering of up to 16 bytes is handled by
+		 * the skcipher_walk.  Here we just need to round down to a
+		 * multiple of 16.
+		 */
+		nbytes = round_down(nbytes, AES_BLOCK_SIZE);
+		aes_gcm_update(key, le_ctr, ghash_acc, walk.src.virt.addr,
+			       walk.dst.virt.addr, nbytes, flags);
+		le_ctr[0] += nbytes / AES_BLOCK_SIZE;
+		kernel_fpu_end();
+		err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
+		if (err)
+			return err;
+		kernel_fpu_begin();
 	}
-	if (err)
-		goto out;
+	/* Last segment: process all remaining data. */
+	aes_gcm_update(key, le_ctr, ghash_acc, walk.src.virt.addr,
+		       walk.dst.virt.addr, nbytes, flags);
+	/*
+	 * The low word of the counter isn't used by the finalize, so there's no
+	 * need to increment it here.
+	 */
 
 	/* Finalize */
 	taglen = crypto_aead_authsize(tfm);
 	if (flags & FLAG_ENC) {
 		/* Finish computing the auth tag. */
@@ -1437,12 +1433,13 @@ gcm_crypt(struct aead_request *req, int flags)
 		 */
 		if (!aes_gcm_dec_final(key, le_ctr, ghash_acc, assoclen,
 				       datalen, tag, taglen, flags))
 			err = -EBADMSG;
 	}
-out:
 	kernel_fpu_end();
+	if (nbytes)
+		skcipher_walk_done(&walk, 0);
 	return err;
 }
 
 #define DEFINE_GCM_ALGS(suffix, flags, generic_driver_name, rfc_driver_name,   \
 			ctxsize, priority)				       \

base-commit: de9c2c66ad8e787abec7c9d7eff4f8c3cdd28aed
-- 
2.46.0

