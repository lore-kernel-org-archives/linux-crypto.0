Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500C323D297
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 15:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781708513; cv=none; b=hLWlrBlsBoqLicQX4sYZrDh6Xb2LK84qABasJTWPbQSkovSFAogPU6tJ6+fVDhuYrS/K3jA7FwEs0BJlADvuxPMez+EahEXMJgYce0n5X+lbL0PjOEVyAI2jh8ABIqvMVM8TOCJBWG7KXH3os2nwRRBioGrPu9GDA1JFx8/GJHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781708513; c=relaxed/simple;
	bh=v4HgzcMPKtCA1bfRUgCAIH2p6H7a1hFEIgPWyKO8bQc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XMQ28Qb4XlgKeWQj3OoAyvlIv+gOoOG5bfRZgohEyyXpsBXS750vZGU6owYVrdargd2UBmG7/aW0ASzz/X7Abf2uMsEnKGMg82ofxHNL+lGIScfKPNAs43YkdwjmETRAg8lnvLQ8PJpMT4wQwBmT2QwE6apnVNe3OHAtNMKfefA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fireburn.co.uk; spf=none smtp.mailfrom=fireburn.co.uk; dkim=pass (2048-bit key) header.d=fireburn-co-uk.20251104.gappssmtp.com header.i=@fireburn-co-uk.20251104.gappssmtp.com header.b=j0YsbjIP; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fireburn.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fireburn.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fireburn-co-uk.20251104.gappssmtp.com header.i=@fireburn-co-uk.20251104.gappssmtp.com header.b="j0YsbjIP"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-3967738c801so51789981fa.2
        for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 08:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fireburn-co-uk.20251104.gappssmtp.com; s=20251104; t=1781708510; x=1782313310; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UTwZZKye4gPezAdX2S6YpGx1K71xdb9A7yBEG4t0T58=;
        b=j0YsbjIP3pFfC4u28KGWkjco/gPZdd7L73yzXQSy5sfSXSpCnwM2aCEEaD5E7QCdMC
         pOP+/Y06zYULVJr6x/ek7fGk8hK0trF+aw2kGazIRz7+uAXBF+74mzpLe2uR6kJc0qwp
         nKYfDjotXy9/X18qCgiYN8G0Uj+xpo+xPmNR1I7g3qQVcVkMicFS0jyFPbSD8w03FOpt
         CtcZA6+7wquNWh6TbyecQ0nwffKtE581muiYkJczhAAamuLsW/Qg32k6thzNszdsRhOB
         JXPr0DPRJNYLhXOxRRq65qJKAnfwfzX0zXcVLxurErHVDIOrnN04C/ZhuI+Irz5i/sY2
         W9rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781708510; x=1782313310;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UTwZZKye4gPezAdX2S6YpGx1K71xdb9A7yBEG4t0T58=;
        b=PTueF6qvVLgxsyp10d7Q8paRrj9pLYYCNv9K8MkwSX/ZDHdcdwu0O3Agi4yvA5J7bY
         aCunz/suZSIj2F+ZYZYDVi7+mdgd6+XaIHr1Rxe01kc4b4AclwaWI6VjAu2C4juPZbHB
         HGNHFKQBbUdY5r/rJxvwzNje9uEBHJvsiJcgAPFuZ+CiWFF+wqxZDWu7wmaNl3VIoTPU
         0j6Ke9PUWW0/fCPwOSsWW3jJ9y6YojQ6Bi6UUL2Dt4Z0IM846CjHbeIFduBTly7rqCkB
         M5Vp/ZXqUBJR+S6GDpEGpwFr4+BlNywDg83KeVacV8jmTQhj5sslgookXWDaeEKq0m9q
         VEAQ==
X-Forwarded-Encrypted: i=1; AFNElJ9cepNEmV917tidBGQgoGPpphzrgtHfLdZGR03hhfOdL/83PmRl2Ee6UD2ELBgC9Z63xGr78v35uqUg3Po=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnyPUXUA0UUlLl01d5sCTnkFsfiU6bh2WTUwRY91LzrBKU3Ynm
	S8QkRwQqqCUEfsyYNXBtJ/ALSkhg+3fJyDzZMbNdPoWscqCPKxJhajwnRdNjOC1rVjeghRdfi+M
	tCjN62oWU
X-Gm-Gg: AfdE7cm34V/2Oo/n6L3t9vG5oHL+ORZYWpM9pDvbrEYG4WZLaa+8p3YlHt/o1FVWpHU
	Xdn3nwcxIUAxz9BA/SB4DH3ya86d/c9AMc1kFrfu9U2G/iddW4xlPYymrk+BSHUv+qGbVSynRN0
	15fQKLMxvumsSOE6aKP1EZbj+pAsXZ69ZvWHsSbbfSAFke5J4n4FecHlwcrcGMTe+6TC6BeCZv/
	0ls6uMicZXlzBjhFRB3VOlcePqpmpKRZUbOmEQ6Qxfy00E07//FKGwSUtrO3xXrc+pjqJfUJWF0
	hZmmRUk9JP87w9n2Zy0RojPht7ODMFVnZSF86O+ucs6fdC5BBtbhVszU5sQMbNh+Vl7GPauuG8G
	Gyrg5y/ZJhIMIUhK4Znp9hc1Keob29ACldKF2eQ3aXEAmCvku5CuGhyEXmqYDFxMIgtZkivpQ9t
	H8bns3ZU6tWaD5jrUUPyuzJk46/8fiBOMjkxTB2MRSsAZNhHOZTQD369af
X-Received: by 2002:a2e:b888:0:b0:38e:6:4f89 with SMTP id 38308e7fff4ca-39969c2feadmr11390881fa.25.1781708509077;
        Wed, 17 Jun 2026 08:01:49 -0700 (PDT)
Received: from axion.fireburn.co.uk ([137.220.119.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-461abb44c3dsm13769159f8f.9.2026.06.17.08.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 08:01:48 -0700 (PDT)
From: Mike Lothian <mike@fireburn.co.uk>
To: rust-for-linux@vger.kernel.org
Cc: Mike Lothian <mike@fireburn.co.uk>,
	linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/2] rust: crypto: library AES-128 / SHA-256 / HMAC + RSA
Date: Wed, 17 Jun 2026 16:01:31 +0100
Message-ID: <20260617150143.2152-1-mike@fireburn.co.uk>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This RFC series adds a small, reusable kernel::crypto module so in-kernel
Rust code can hash, encrypt a single AES block, and do RSA public-key
encryption:

  1/2  sha256(), hmac_sha256(), Aes128 (single-block ECB)
  2/2  Akcipher + rsa_pubkey_encrypt() over crypto_akcipher

Patch 1 binds the library crypto (lib/crypto) functions directly
(SHA-256 / HMAC-SHA256) and uses one rust_helper_ shim for aes_encrypt()
(its transparent union is unbindable). It runs synchronously in the
calling context with no allocation and is the independently-mergeable,
self-contained contribution.

Patch 2 adds crypto::Akcipher, a thin wrapper over the asynchronous
public-key API (crypto_akcipher) driven synchronously, and a
crypto::rsa_pubkey_encrypt() convenience built on it: it DER-encodes the
RSAPublicKey the "rsa" transform expects, runs one encrypt, and leaves
padding to the caller. The request/scatterlist/completion plumbing (all
static-inline or on-stack) plus a kmalloc bounce for the DMA data path
live in one rust_helper_ shim; crypto_free_akcipher() and
crypto_akcipher_set_pub_key() are exposed through 1:1 shims. Going
through crypto_akcipher rather than the MPI math library means it
composes with any registered RSA implementation, including hardware
offload. It is kept a separate patch so the public-key surface can be
reviewed (or deferred) on its own without touching patch 1.

Both were factored out of an out-of-tree in-kernel Rust DisplayLink DL3
dock driver (which needs SHA/HMAC/AES for HDCP 2.2 and RSA for the AKE),
but the module is generic. Compile-tested in-tree against drm-next.

Mike Lothian (2):
  rust: crypto: add library AES-128 / SHA-256 / HMAC-SHA256 bindings
  rust: crypto: add RSA public-key encryption via crypto_akcipher

 rust/bindings/bindings_helper.h |   3 +
 rust/helpers/crypto.c           |  95 +++++++++++++++++++++++++++
 rust/helpers/helpers.c          |   1 +
 rust/kernel/crypto.rs           | 255 ++++++++++++++++++++++++++++++++++
 rust/kernel/lib.rs              |   1 +
 5 files changed, 355 insertions(+)

--
2.54.0
