Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CC33290C8
	for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 14:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774882001; cv=none; b=FR+Dqob3szZzYp6TLHefWMWJM7dr8G59GCqSd5WoWegEcNUgvxfmJup2lXihlgQ9ROXwwQ7HfpB3jw/UORxl3AS0fMiirXyau7qkkyO23SSgehhKn/fQQhiReU4Qn8KoZke6obRxptL6W59jjpBB2EHulY8IFEiCI8hW09jc+Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774882001; c=relaxed/simple;
	bh=MnnqFIN2vC8heU3/zvcEJ/dikTf9Y4MoH+gFtljmtJY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RkjFZsLul0kNigXcgDbBWQH9H5D7aicdzbJ9CY2J9zSZNXGDt2+nNfqEP1FaMBuqnPAAPtCMH4lbMk43BPL7RKKTktYFFMQWNlRIayvCTsuD7ESoz1iGXm7UBiuo1v+XLyw1K6wvJicmSo/2ss+N3Qi1maDhDV1TdfrYnldpOTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=USMzJB4N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="USMzJB4N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA92C2BCB2;
	Mon, 30 Mar 2026 14:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774882000;
	bh=MnnqFIN2vC8heU3/zvcEJ/dikTf9Y4MoH+gFtljmtJY=;
	h=From:To:Cc:Subject:Date:From;
	b=USMzJB4N+pOL5ujlqYguF3cwn18bdH6PH/lIot1UdUzd/15yyv1GGfpgT531q1S2j
	 jSSDRVZrwhveQHA9YgDSLHjNmNeWWRxIjgoFvF8BXsriXNo3ZKldSYGsRJfXwL1cAG
	 qWzxH0EjbL8qIo1B8kEMX7f1CHVeXGEMBe0GOfCj1rZCbadqrgo1azNW9H0REuuzWe
	 Y3ZnYcs1KHnozZDjGn/4C9QxXpZ7eoCCoFLJjxDPkP0tAhWrcZgAxX0FP2qZzXrEPt
	 RYL3ytrW3muZg0vSq1ALlLWUK+tv+D/gRy2FL0mBTo+R9EcC41Pux83TcSxW8FnHdO
	 VmaQlPfVUE6VA==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Demian Shulhan <demyansh@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/5] crc64: Tweak intrinsics code and enable it for ARM
Date: Mon, 30 Mar 2026 16:46:31 +0200
Message-ID: <20260330144630.33026-7-ardb@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1495; i=ardb@kernel.org; h=from:subject; bh=MnnqFIN2vC8heU3/zvcEJ/dikTf9Y4MoH+gFtljmtJY=; b=owGbwMvMwCn83sBh/rljoYmMp9WSGDJP9RwX/5f5PeeeRbFV6GpFiYTbW51c7GrKHzmyTF7hm 1pePLGmYyoLgzAng6yYIstO5Zzu1y6i7/QVKnNg5rAygQxh4OIUgIls7WFsmL2oszC5699FcYZr efz+la/FM3cEZy15fGD+PSuJO4W/Q6/zRz5TcuCJDzrYlWPBensHY32x7uJyw1rtN1Huu/m+LTa /tfftb8tL0b83duVFFog2rbyR9/ZhQ8y1N7+Ot5S+D996vxkA
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

Apply some tweaks to the new arm64 crc64 NEON intrinsics code, and wire
it up for the 32-bit ARM build. Note that true 32-bit ARM CPUs usually
don't implement the prerequisite 64x64 PMULL instructions, but 32-bit
kernels are commonly used on 64-bit capable hardware too, which do
implement the 32-bit versions of the crypto instructions if they are
implemented for the 64-bit ISA (as per the architecture).

Cc: Demian Shulhan <demyansh@gmail.com>
Cc: Eric Biggers <ebiggers@kernel.org>

Ard Biesheuvel (5):
  lib/crc: arm64: Drop unnecessary chunking logic from crc64
  lib/crc: arm64: Use existing macros for kernel-mode FPU cflags
  ARM: Add a neon-intrinsics.h header like on arm64
  lib/crc: arm64: Simplify intrinsics implementation
  lib/crc: arm: Enable arm64's NEON intrinsics implementation of crc64

 Documentation/arch/arm/kernel_mode_neon.rst |   4 +-
 arch/arm/include/asm/neon-intrinsics.h      |  64 ++++++++++++
 lib/crc/Kconfig                             |   1 +
 lib/crc/Makefile                            |   8 +-
 lib/crc/arm/crc64.h                         |  36 +++++++
 lib/crc/arm64/crc64-neon-inner.c            | 108 ++++++++++++--------
 lib/crc/arm64/crc64.h                       |  12 +--
 7 files changed, 179 insertions(+), 54 deletions(-)
 create mode 100644 arch/arm/include/asm/neon-intrinsics.h
 create mode 100644 lib/crc/arm/crc64.h


base-commit: 63432fd625372a0e79fb00a4009af204f4edc013
-- 
2.53.0.1018.g2bb0e51243-goog

