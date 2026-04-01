Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00132C14A;
	Wed,  1 Apr 2026 00:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775002069; cv=none; b=rZ0S9nzObODH7IO/SdptMCuZH3zbOpB2iLloy3AOr+uaVhLjtKEO+5k0rjK4zxfp4xevGrihvjt3ZdKXdc5lZDmZRnmoljgWxmZFVSvT4GGyIGkr5TS6VpXKxXdHnZvlfj4g0kfZP2n39MHf82w8taZK1LQcBd4CQTILCRdlET0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775002069; c=relaxed/simple;
	bh=8Wk+kFZc7waXaSJYEDxUWXjaoxO2Oov/KreukESiZx4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ayKTSGjlTVctcFLQ2WDP6fhoMRmTr0/VxhA7MdgGTtpHyFcH5St0CMa0alpY5AEEPGgLEQpaiwecYsgKuQOr8T/f50ZObzYDJKRS5cmI4ggh/8QpPjbXAiEZOteDA6DgJTkYeIv3VS+JFKB1CjrQRSCMpr9KO82jVejiJXg1VHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JKccItLG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JKccItLG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F62C19423;
	Wed,  1 Apr 2026 00:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775002068;
	bh=8Wk+kFZc7waXaSJYEDxUWXjaoxO2Oov/KreukESiZx4=;
	h=From:To:Cc:Subject:Date:From;
	b=JKccItLGonJH94enETWtGvP+7Klm94Wx+xVq6BFbRvITQ2tuq30dxzZHrbqp8QDjV
	 c09IurE9gRIlpp//Af/aO2fpUznFYNc7MdxdENK4GNv6QLbWP6+7rIQ3/Q6thZzN06
	 QGk9SC6huu5X38URLd4a5tapogBPffk8JNbSQ3cc/NMnoh/oksvMD63POwbzk13peq
	 L6DNZb+diqu+AU+PMN4jaF0J64Ke+8uMZVYG5aia3OFYy/rXblOatq/ByIRA/8FrXA
	 2qLIyAhtYpqlrmvXAPmqcy49wiuzJdhygT+C1nzTc1Py60t6OIxy8G20wsKpKQ2uHA
	 vzmJ2PzyXL9zA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/9] lib/crypto: arm64: Remove obsolete chunking logic
Date: Tue, 31 Mar 2026 17:05:39 -0700
Message-ID: <20260401000548.133151-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit aefbab8e77eb ("arm64: fpsimd: Preserve/restore kernel mode
NEON at context switch"), kernel-mode NEON sections have been
preemptible on arm64.  And since commit 7dadeaa6e851 ("sched: Further
restrict the preemption modes"), voluntary preemption is no longer
supported on arm64 either.  Therefore, there's no longer any need to
limit the length of kernel-mode NEON sections on arm64.

This series simplifies the code in lib/crypto/arm64/ accordingly by
using longer kernel-mode NEON sections instead of multiple shorter ones.

This series is targeting libcrypto-next.

Eric Biggers (9):
  lib/crypto: arm64/aes: Remove obsolete chunking logic
  lib/crypto: arm64/chacha: Remove obsolete chunking logic
  lib/crypto: arm64/gf128hash: Remove obsolete chunking logic
  lib/crypto: arm64/poly1305: Remove obsolete chunking logic
  lib/crypto: arm64/sha1: Remove obsolete chunking logic
  lib/crypto: arm64/sha256: Remove obsolete chunking logic
  lib/crypto: arm64/sha512: Remove obsolete chunking logic
  lib/crypto: arm64/sha3: Remove obsolete chunking logic
  arm64: fpsimd: Remove obsolete cond_yield macro

 arch/arm64/crypto/aes-ce-ccm-glue.c | 13 ++++-------
 arch/arm64/include/asm/assembler.h  | 22 ------------------
 include/crypto/aes.h                |  6 ++---
 lib/crypto/arm64/aes-modes.S        |  8 +++----
 lib/crypto/arm64/aes.h              | 35 +++++++++++------------------
 lib/crypto/arm64/chacha.h           | 16 ++++---------
 lib/crypto/arm64/gf128hash.h        | 24 ++++----------------
 lib/crypto/arm64/poly1305.h         | 14 ++++--------
 lib/crypto/arm64/sha1-ce-core.S     | 14 +++++-------
 lib/crypto/arm64/sha1.h             | 15 ++++---------
 lib/crypto/arm64/sha256-ce.S        | 14 +++++-------
 lib/crypto/arm64/sha256.h           | 29 +++++++-----------------
 lib/crypto/arm64/sha3-ce-core.S     |  8 +++----
 lib/crypto/arm64/sha3.h             | 15 ++++---------
 lib/crypto/arm64/sha512-ce-core.S   | 12 +++++-----
 lib/crypto/arm64/sha512.h           | 15 ++++---------
 16 files changed, 73 insertions(+), 187 deletions(-)


base-commit: 7ac21b4032e5b9b8a6a312b6f1d54f4ba24d1c16
-- 
2.53.0

