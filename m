Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A005293458
	for <linux-crypto@vger.kernel.org>; Sun, 11 Oct 2026 13:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791726552; cv=none; b=js1grD8JEBIIEZtDqb5DBDuSIq6laVqLkDXVWE5Ef6xqZY2pw5D7XWDFqTym12CWIzWVu2AYzgsNjkaaYp6LacsHbvyCDjU9fUZViDkyQvj0mm5OZrvblBgFNm7b4zhJES1ktQ+uYwrf8nXXTKCrFrl/Kixbsku07te7hJ5SqFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791726552; c=relaxed/simple;
	bh=0VM7pBo3y+9LWG8OHOy3ypRycjujUjpKXKv8y6hS5Yw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LBP04AuPhyek46xWZ85kAU4olj1/GJDxHa0quhh7sEWuf/BXuZlocnTi2V6mjc9W9Vs1nv9J2WJip2AM67N78VX/XBViYseHYq13B2GMmnjqC3fYmwh3sdLf3WbHOeyB2Tx/AGMLyk3BPEqfQYaqLC14ffPKuJL/tOJHJD72HRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nqjoEoJH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nqjoEoJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FF31F0089B;
	Sun, 11 Oct 2026 13:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791726550;
	bh=eA0FLLK8pGRkN32bzKdOFrC/pOd9CliYyDw33OWzEac=;
	h=From:To:Cc:Subject:Date;
	b=nqjoEoJHCPQRluYebtkCxSkqMRiAbpiVgqbxSSmImQyUFEGYa9udHSqH6ljNW0JY1
	 O635kyUYQybpbOW+0pKtAmMj1eMfQqmEnQO/y0MWs99AJVb+hY8n3hhElv+UAsUeyF
	 2xDKMul+Z+OHTQ6Uz5iRwNd7rWXCD79htVY+giEwOAndFdsCk07klFkorIEOGso9Nt
	 hWYoDGXDtr5w56IZaNkdwFVCChDfmRIv+uz+cVLqRVLpuQpT1/NmlSr5mlOj2KvFcY
	 8GsFx9IamhQ2121rTnpG1QV1Zq7c1SUP8CBSGlPo/SGtFOxhNT2aFk972F4d8uEyIm
	 2nUQCQB/ffVrA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/3] lib/crypto: x86/sha: Follow the normal %rbp convention
Date: Sun, 11 Oct 2026 15:48:40 +0200
Message-ID: <20261011134843.166585-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series updates the x86 SHA-1, SHA-256, and SHA-512 assembly code to
set up %rbp before pushing GPRs rather than after, so that the frame
pointer unwinder will generate call traces reliably.

This doesn't matter much, given that the ORC unwinder is the default,
and the fallback to scanning the stack made call traces sort of "work"
anyway.  But it annoyed me that these assembly functions use the "wrong"
%rbp convention, differing from the C code.

This series is targeting libcrypto-next.

Eric Biggers (3):
  lib/crypto: x86/sha1: Follow the normal %rbp convention
  lib/crypto: x86/sha256: Follow the normal %rbp convention
  lib/crypto: x86/sha512: Follow the normal %rbp convention

 lib/crypto/x86/sha1-avx2-asm.S      | 10 +++++-----
 lib/crypto/x86/sha1-ssse3-and-avx.S |  9 +++++----
 lib/crypto/x86/sha256-avx-asm.S     | 10 +++++-----
 lib/crypto/x86/sha256-avx2-asm.S    | 10 ++++------
 lib/crypto/x86/sha256-ni-asm.S      |  9 +++++----
 lib/crypto/x86/sha256-ssse3-asm.S   |  8 ++++----
 lib/crypto/x86/sha512-avx-asm.S     | 11 ++++++-----
 lib/crypto/x86/sha512-avx2-asm.S    | 11 ++++++-----
 lib/crypto/x86/sha512-ssse3-asm.S   | 11 ++++++-----
 9 files changed, 46 insertions(+), 43 deletions(-)


base-commit: 6a50ce0af5c91fd665d65d357af8ae55db1df7d0
-- 
2.56.0

