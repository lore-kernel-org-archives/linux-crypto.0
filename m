Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DD734D394;
	Sun,  2 Nov 2025 23:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762127043; cv=none; b=nIvjPjOBOU/0H7uR5677tdeZdFCXXoT2/emufB7MOkVI1awdxRtvreX2/cNV+J/MOKrxfn0EZiNT4ctjM852gaPCBlx00qosYENaxepemXdyG+v3xxcHOrh/Ic6r7POXArj+2NE3gLFpzvDimKApuxMhKJrdjeECzm/OLPuGu2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762127043; c=relaxed/simple;
	bh=Q7QXZ/Qj0FeCy6FMpj+maeazXIun4yipJEjx7uRGw38=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CBp3XfgSCj/14f592uBuzc4UWo1svsUbIUoJRCmxeei6CjT2eglzRuU+EpCWYNqDMjJwV0ViJwzCJa979mx34OWbkUuNwUGq3cfY+PzbkyEd7RnXHe/PVLp3rJ3Bt9H97Fc5pnUtuQreDSZqWRzdE3bmoWHEoVqqAaGsm8m2qpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ktHwqGAK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ktHwqGAK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC09C4CEF7;
	Sun,  2 Nov 2025 23:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762127042;
	bh=Q7QXZ/Qj0FeCy6FMpj+maeazXIun4yipJEjx7uRGw38=;
	h=From:To:Cc:Subject:Date:From;
	b=ktHwqGAKeHzzSV8OINhp6oSGgv1mdUt2Mj2VrKzTHvan9w0f3k3SCZcXtSLOQUmRN
	 d35dNNqaJB2c5eCFYYiD8ov774jYlm/cGppZ2x/KsJkjL3S9u4VrZYGDRGUqWGxPRQ
	 NH4Ium1oRxFn0c/IfknC4WGwMIurz1/SBqz5UwEJDBkKErvHR3uiR3zrtsh3mADITa
	 rqiCoq+QwTrjiny3iZAYeJ2xs0CyWesN9o+kdYJgRo+Okpu0DQJgEfv9/yGa3rX6FP
	 S3nzBVVMI1mQZ8pq2RB1FS0T/4gOCfKtaq4hYIVBtmngO4lyG2e1HAekHrZw6noBOk
	 PPnGypXlgy9Mw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Samuel Neves <sneves@dei.uc.pt>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/6] x86 BLAKE2s cleanups
Date: Sun,  2 Nov 2025 15:42:03 -0800
Message-ID: <20251102234209.62133-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Various cleanups for the SSSE3 and AVX512 implementations of BLAKE2s.

This is targeting libcrypto-next.

Eric Biggers (6):
  lib/crypto: x86/blake2s: Fix 32-bit arg treated as 64-bit
  lib/crypto: x86/blake2s: Drop check for nblocks == 0
  lib/crypto: x86/blake2s: Use local labels for data
  lib/crypto: x86/blake2s: Improve readability
  lib/crypto: x86/blake2s: Avoid writing back unchanged 'f' value
  lib/crypto: x86/blake2s: Use vpternlogd for 3-input XORs

 lib/crypto/x86/blake2s-core.S | 275 +++++++++++++++++++---------------
 1 file changed, 157 insertions(+), 118 deletions(-)

base-commit: 5a2a5e62a5216ba05d4481cf90d915f4de0bfde9
-- 
2.51.2

