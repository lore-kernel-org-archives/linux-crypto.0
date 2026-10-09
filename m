Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5524F4D37BE
	for <linux-crypto@vger.kernel.org>; Fri,  9 Oct 2026 12:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791550470; cv=none; b=owIJB0Cnn+vPBEynIoXgsuCYz1xY7zRnQ4ShfCtz/XL1kHkQyv+iQpSCgCnpe1k7ZVU9LErdTCvEtgt+llR7PFjqTTR0opp0njK9CrulImxzSJouV5Gb8PjTUnriQ9xAajnnecsZCPTp5cosKA/6Qfwjpcu0KgAue+adCUXX/hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791550470; c=relaxed/simple;
	bh=oFXViLcU6nRZlIqU0e/dvHeGmV0H6CzsE20a8ie0DcE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=N5UqEyFWDWDMDwDQckwxzwwtXPNIx0zWlT3pF1BD25rxjpyJ1M54g38xIkWHFZC18Rllcuu4RVGkmE0UNv1VawMsaZOlGIj1vtM6/bTn87hiNckWQPnFuPrZ7AaI0l+2a1PsONB/g0jM4gfGzhF/zwWg346QqQuDY19pnJGmsAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mMTnTzhW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mMTnTzhW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DFF1F000FF;
	Fri,  9 Oct 2026 12:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791550467;
	bh=c09C4KTZtxsB1EwbJfHre3kLSdUdymxJsJbi/9voYA0=;
	h=From:To:Cc:Subject:Date;
	b=mMTnTzhWWbiNnDJ6gzOvtfs0hAJBQh3V3SB87jY2RW9HQ/QdHd94DCX94UrKjHj6t
	 hxzbKtwGiVGqIR/emfhal+5HbBulT+Ch+toqpZM/Na/lneJ7C8+VvV9dJdJMb/i/KK
	 iIsdn9agveAsrf7FK9H7qRCOAoH7UQWALOyIzLTPhZUd26KpHy2vogP+YW87LcESb7
	 eF5egryx0kXePamJG6XmvxfUP3QX8dEdoxj4TRO4xA79KzkUAJr5s9fk8cTNyW+qKw
	 bkPtMxwVrpFkX9Dl7WwqY1J8HN9kgyr1pz788W18ipeZNhukiawzV5YcUv2Pb4QP0M
	 exF+E0jcktZMA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v3 0/2] lib/crypto: arm64: Fix Poly1305 NEON resume carry loss
Date: Fri,  9 Oct 2026 14:53:52 +0200
Message-ID: <20261009125354.315476-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series fixes a lost carry bit in the arm64 Poly1305 implementation,
then adds a regression test for it.

Compared to v2 sent by Jérémy Jean, I cleaned up the verbose
LLM-generated text in the commit message of the fix commit, and I
replaced the LLM-generated minimal test case with a more comprehensive
one similar to the existing test cases in the file.

Note: the second commit has references to the commit ID of the first,
which I'll fix up when applying.

Eric Biggers (1):
  lib/crypto: tests: Add Poly1305 split-update carry regression test

Jérémy Jean (1):
  lib/crypto: arm64: Fix lost Poly1305 carry when resuming NEON state

 lib/crypto/arm64/poly1305-armv8.pl |  2 +-
 lib/crypto/tests/poly1305_kunit.c  | 97 +++++++++++++++++++++++++++---
 2 files changed, 89 insertions(+), 10 deletions(-)


base-commit: 572af6872e520c7102e58362ef7cd7c2ed4342be
-- 
2.56.0

