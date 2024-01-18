Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2426B2C841
	for <linux-crypto@vger.kernel.org>; Thu, 18 Jan 2024 17:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705597660; cv=none; b=XKmqYdJEdWhfmWwnGhtcwq4zybpjJi0CD7z2ZJiIxb2Afp0mCER8c+YFqyXIysLtYR/Z/yWrzJjYqCA30evMuVx3md5u7Usqxg8H1yWPEZy1L0nnLxtVf8pIWzn7STPeRLZM0/0OX+hwAwmzwEnMbVAkP7Wk2a0w0WEY5n3El00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705597660; c=relaxed/simple;
	bh=qnCIU9DCzBK9gNLdVZmVouoNwxtxVTk6+4HdSQ46Dk8=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Date:
	 Mime-Version:X-Developer-Key:X-Developer-Signature:X-Mailer:
	 Message-ID:Subject:From:To:Cc:Content-Type; b=dF6pIluyZF2BbTWI7/hcqDSOZTC83IpidQHPo+MIT1VTqwmJ+kR3FPpV5TKIfpNM/7RbayYgJYQtLvHU8V8ZVwcAusLZruVvYFzg93d28dG5dVSOn78FO4ok/vKVny2gXJi9UnhcvE23oHpwiZ7LUjCi3ZruOmSUDb5kk7M+2h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZivK8SHN; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ardb.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZivK8SHN"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-40e74860cb0so34330015e9.3
        for <linux-crypto@vger.kernel.org>; Thu, 18 Jan 2024 09:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705597657; x=1706202457; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TaLJBR5Z4LahRo4ULsPf7tLPr9lWmVS42gUzB4fErWI=;
        b=ZivK8SHNonZlPMkYxhEON11t+IgNfBYTs0LPNLlYmy+oqzV+CnvOHwhTs2Sp6C5ilV
         Hx4ufIUXiqOxtriMGxQtOmD/5Sl3NXn0MOdBnXoKUdodc7Z7mRJSogKWZdXkYk8MPh+I
         cs8U0nhZOQ7huPJQY+UocNwOtzTcwgzXKhrDEQKbrRW/X3v77ECM6zZX+IW43V3Frbyo
         T1MzTk2mP8AARVuK2Y4xcUgPNGZ7A9RIfrQNHKeVT6i8Qggy38PkBsTAjraPWr/muJ0R
         dnNBBd1UiJm/RyROFOUXANbNjMBUFO06+MB8AHir7/9cVP+FcL6UeMvFiSgib//lm8eU
         EoKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705597657; x=1706202457;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TaLJBR5Z4LahRo4ULsPf7tLPr9lWmVS42gUzB4fErWI=;
        b=Ls+1vkgeiIQ6GAEe4TdvB/rqRgDiw434wj3jpEq6Nx+BE8jCKC0gRGchjp4UNld2E+
         E6+7NdSXaonDxKYdFdObTR/t1W/DrYAroRLHyegFng0H4ipF490iw8f19Yh7QWS/T8qm
         N0l2ULqcR582Jq3FNif4OnusjnKAG7fB7iZ3gP5QJL8u13uTuIy7FRhsHwqwJgHdhbTk
         idzFjjNxqj0jNPYtJhxXpASn+iWLWY2gVqlXJVzhNxY5gP5uD9pTVInaJwNBMs95Hg+J
         JCc9vHCU6xhXNhSmV9e81XOO768nFmK55zf8uXo4PIu5vOkAq6HIlIsj2byeK98CbiD1
         YtZQ==
X-Gm-Message-State: AOJu0Yy0SN/3UkcbnCczcIsqFR0zTrTx1xdk5WqNQrln4ishWZFupABi
	QxM3SqW/edhEVWVFpoO5goyfoZ6VjGzkX6EznOpjVT4rlN7hj3UMsLkpBuOInjBEwVSjXOnHccj
	8XAx/t6d6zegBniIK3VV4sVBh2VefSTxZFHQ464fufzoypw6uwNPDF/gaH1+myQ4sIZpTvqB3hT
	5psxf3RNQJmRYuxTbbzs/G4YlmRRpXgQ==
X-Google-Smtp-Source: AGHT+IGlFVHjyN684hsmdGdXRkxRTai22MInRWTx5naYWb14B/cgQ6B6l9ZE8+v7V3DVqrCuZZRVOxoH
X-Received: from palermo.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:118a])
 (user=ardb job=sendgmr) by 2002:a05:600c:b8c:b0:40e:96b7:7231 with SMTP id
 fl12-20020a05600c0b8c00b0040e96b77231mr1176wmb.7.1705597657313; Thu, 18 Jan
 2024 09:07:37 -0800 (PST)
Date: Thu, 18 Jan 2024 18:06:29 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2039; i=ardb@kernel.org;
 h=from:subject; bh=VeKweEQtVwC+9ITQUkrZng6Gt9Ikb5eDQGB8ai93PUc=;
 b=owGbwMvMwCFmkMcZplerG8N4Wi2JIXVl1FSb3KXG2nuVbRVVordFzIwXeKt8TiRU9fznDxsyn
 nzc3qLRUcrCIMbBICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACZSxMjwz/xnDbt/smBC9tf8
 mTIe9r9bp38/tigs9nF2RJ4gg+aCAIb/nhxO/5kO/6nwnX186Y8q5v0ap6bxnIjLS2z5nNpYpS/ HBAA=
X-Mailer: git-send-email 2.43.0.381.gb435a96ce8-goog
Message-ID: <20240118170628.3049797-10-ardb+git@google.com>
Subject: [PATCH v2 0/8] crypto: Clean up arm64 AES-CCM code
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-crypto@vger.kernel.org
Cc: ebiggers@kernel.org, herbert@gondor.apana.org.au, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Ard Biesheuvel <ardb@kernel.org>

The AES-CCM driver was written 10+ years ago, based on the very first
kernel mode NEON API for arm64, which eagerly preserved/restored the
NEON registers on each call to kernel_neon_begin() resp.
kernel_neon_end().

For this reason, the asm helpers were constructed in a way that used
only 6 NEON registers, as the kernel mode NEON API at the time
implemented an optimization where kernel_neon_begin() took an int
denoting the number of NEON registers to preserve/restore. Given that no
actual hardware existed at the time (except perhaps for APM Xgene1 which
did not implement the crypto instructions), all of this was based on
premature assumptions.

These days, the NEON API is a bit more sophisticated, and does not
bother to preserve/restore anything unless it is needed (e.g., when
context switching or returning to user space). It also no longer
disables preemption. Finally, we've developed some code patterns in the
mean time to deal with tail blocks more cleanly and efficiently.

So let's bring the CCM driver up to date with all of this.

Changes since v1:
- keep primary en/decryption paths separate
- fix rebase error in v1

Ard Biesheuvel (8):
  crypto: arm64/aes-ccm - Revert "Rewrite skcipher walker loop"
  crypto: arm64/aes-ccm - Keep NEON enabled during skcipher walk
  crypto: arm64/aes-ccm - Pass short inputs via stack buffer
  crypto: arm64/aes-ccm - Replace bytewise tail handling with NEON
    permute
  crypto: arm64/aes-ccm - Reuse existing MAC update for AAD input
  crypto: arm64/aes-ccm - Cache round keys and unroll AES loops
  crypto: arm64/aes-ccm - Merge encrypt and decrypt tail handling
  crypto: arm64/aes-ccm - Merge finalization into en/decrypt asm helpers

 arch/arm64/crypto/Kconfig           |   1 +
 arch/arm64/crypto/aes-ce-ccm-core.S | 265 +++++++-------------
 arch/arm64/crypto/aes-ce-ccm-glue.c | 154 ++++++++----
 arch/arm64/crypto/aes-glue.c        |   1 +
 4 files changed, 200 insertions(+), 221 deletions(-)

-- 
2.43.0.381.gb435a96ce8-goog

