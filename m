Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486D7231C9C;
	Mon, 14 Oct 2024 04:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728879932; cv=none; b=j4te0h6oGItMdRn4vEIHwKFCsPHeVQhtbevYBXJMDnQZSQJoXTT3grX64NcMt0oPp/oM/dgwtvnE345yT5WcAFylEgGUPkdKs/ks2EgwHgcoY+y21fPmrJVWMs7EMf/81oCgCAUYO6RoiitojBwYkf0bbwt+8e+CO6qDPxvZTtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728879932; c=relaxed/simple;
	bh=5P9LScVWjTLtQygD1zib7XPL0Z+hYsICfNucfMYnAuo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K0AJsvcXXK/CTpw3hkpD8m87E9e0rTCTYSmn7zIh97VmjfCjD3wMBbK23g2k+6Mf+YriJIMv9SqMTaLdPI7U9r2AL1GvPmXcNopdd06xiSXLqWRoSgul6ZVA212LiqhHt9FHKUB6MAFKOsVuHvh+8/wVbcZIUzlZ+Lvlun59ucM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nx2fHF5j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nx2fHF5j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95939C4CEC3;
	Mon, 14 Oct 2024 04:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728879931;
	bh=5P9LScVWjTLtQygD1zib7XPL0Z+hYsICfNucfMYnAuo=;
	h=From:To:Cc:Subject:Date:From;
	b=nx2fHF5jpeki/P8dNzf6KX5363y16tlxkQnVEhAvza2gNAJWfFwRxvImEEIg2c194
	 4GV+7oWsvL7oui2jKAmz7YZRdr+JGUQwuF3HIvzBSi+NpcOEkseTPfsQss/qxR4C7U
	 Spi0T+RGsvHuf4AsC3cCpFUDw0fhlhY6mLqQt17xmTCD0UVO/QIp3Uo4cIgcwUKLGK
	 Gis0PmOR9qITTX9741mR0Sa5gAFw9tALsnCNAvSv0nFvbV5WFPPMOB1N3290UKorUr
	 Cw8bMoFciW1FwPm46I9QPYZ3csogpcI/3BIAL/rEW5GpCAc342AHlPAmUCScUhzEIB
	 8KC9VHw5I3K1Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 0/3] crypto: x86/crc32c - jump table elimination and other cleanups
Date: Sun, 13 Oct 2024 21:24:44 -0700
Message-ID: <20241014042447.50197-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series cleans up the x86_64 assembly implementation of CRC32C to
reduce code size, improve performance, and eliminate the use of the
outdated and problematic jump table idiom.

Eric Biggers (3):
  crypto: x86/crc32c - simplify code for handling fewer than 200 bytes
  crypto: x86/crc32c - access 32-bit arguments as 32-bit
  crypto: x86/crc32c - eliminate jump table and excessive unrolling

 arch/x86/crypto/crc32c-intel_glue.c       |   2 +-
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S | 354 ++++++++--------------
 2 files changed, 126 insertions(+), 230 deletions(-)


base-commit: cfea70e835b9180029257d8b772c9e99c3305a9a
-- 
2.47.0

