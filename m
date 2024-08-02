Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633F51E210A
	for <linux-crypto@vger.kernel.org>; Fri,  2 Aug 2024 10:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722594219; cv=none; b=AGCJ33Y3Snqz3bM9rUUgsP0IpOe8P4JPW2XgZC92akWGHWsKBvvbgwKv+uPQkMfjxyC4jvQ0gKY3bel0WX/eRdlkmKlADkrxxOD97FRM6qZbxwVrWYfzdl4txjlkfCh1FP45zYfFCf6CKQvSYhXtQX10ARPmEBog6GbO6yMG4LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722594219; c=relaxed/simple;
	bh=CjQ6pUUSX8DTl/PHksrsoTLYiqI+jVr30a+zjmpos+4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Z2SBZDjRGbqgG0GFWXhXlQ5u0Fjt8jxHLw0nRFj4U8+HA/VKEXxyV7AxO003Lpx+a7YmGNGmKdqmmtZmmj2Wsnf772+M2V6v8nNGB6y0A8FUqZVZm6ZTJEph/EokUUxP5BQ1IwljV3QUc+MAvpJcZ4Rhd0PJS8MjBg0ODxqTJRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Bk1XZQuX; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=+BKsUb4D; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Bk1XZQuX";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="+BKsUb4D"
Date: Fri, 2 Aug 2024 12:23:33 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1722594214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=ok8C12tYQndFo3ju9Bm0d2KGLW3WR4ip/OYyR2oVex0=;
	b=Bk1XZQuXsVYLNvzdf3mVfI1jHO05ocUYJ4kFSgMf0sxtD6UbAk8S5hnsxQWnZtlR3+3pAG
	RiF5Pt6R9RVHcAOifAZ25BarOqR+ulfAuOeQTHNqIXz2RE8kiuARhv7BZqB098YkLlJaTZ
	AJfvtTg0asZHoLkYjIRa0jWSVChhk8AVsdBdVyU5NjbnPUswTrtkktxL20J+9TkJYsxaI2
	bp915TPencf99M0BVRceXda7i0uw4fTYlj/SdD/3RscCbgKj+T3P0TEWn3Gmi2yTiet4ij
	Wm3ooZrO7kvmi2aBTowDFxGg+m2uVfK0IsuYh3EWy6RnaZbTc50dWu/nOFWr+A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1722594214;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=ok8C12tYQndFo3ju9Bm0d2KGLW3WR4ip/OYyR2oVex0=;
	b=+BKsUb4DXKGZmWDxNh/cbnKsldb5O/rpTTxm2O6jN9zbRIVmhBxgb9upVTuUtHheYJVO/Q
	t0f1jIJWTFDkyJBA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-crypto@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Biggers <ebiggers@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] crypto: x86/aes-gcm: Disable FPU around skcipher_walk_done().
Message-ID: <20240802102333.itejxOsJ@linutronix.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

kernel_fpu_begin() disables preemption. gcm_crypt() has a
skcipher_walk_done() invocation within a preempt disabled section.
skcipher_walk_done() can invoke kfree() which requires sleeping locks on
PREEMPT_RT and must not be invoked with disabled preemption.

Keep FPU access enabled while skcipher_walk_done() is invoked.

Fixes: b06affb1cb580 ("crypto: x86/aes-gcm - add VAES and AVX512 / AVX10 optimized AES-GCM")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/crypto/aesni-intel_glue.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index cd37de5ec4046..be92e4c3f9c7f 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -1403,7 +1403,9 @@ gcm_crypt(struct aead_request *req, int flags)
 			aes_gcm_update(key, le_ctr, ghash_acc,
 				       walk.src.virt.addr, walk.dst.virt.addr,
 				       nbytes, flags);
+			kernel_fpu_end();
 			err = skcipher_walk_done(&walk, 0);
+			kernel_fpu_begin();
 			/*
 			 * The low word of the counter isn't used by the
 			 * finalize, so there's no need to increment it here.
-- 
2.45.2

