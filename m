Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3B03911A2;
	Wed, 22 Jul 2026 02:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784689025; cv=none; b=edVS12WI6+LFG4jyNQv7ZiDguAI8cyE1X8MjetWmQIzKXnFSrRP3X+RY2Ao+tzn3rZR3imHeJ8PJzfbJu0J+VKDtwW4egDQLczujjrLZ2KXgkTPCJYFGbOaN15Cdz/bQMzrQSlD0Sjinwpn0J15b8l5m1er8EP9qc7/cphxa6ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784689025; c=relaxed/simple;
	bh=X+zkaMw01Mv4odh0AfDTXHLTGwCBLjDX9AfjvKLr+7I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R1dDrSw5WPVayNcLO5632OeQWH1s1iJf5XI78ktvxOwIQPOU+hsNgrdK9M/v6ZrHzG/23plg7i0uWwiGS6wSzcWXdQLej3Gi/OllD2hw/bvb8IL0CTBqFGu7OEJ1ELcmK9dRLwC+OreDR3PI+8T3ddsNHts8yXP7nRxtOV9ZnWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GogiBELg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GogiBELg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38A5F1F000E9;
	Wed, 22 Jul 2026 02:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784689022;
	bh=ZbtGGIXJpFieb+pSJwSiirglBC0xWaE8482qBRF+TWg=;
	h=From:To:Cc:Subject:Date;
	b=GogiBELgfWH160mBBxbtOc29ZjU4MCETMRWJitUkEmjhjwejh5HGroFDoRrbldmPY
	 jRDsm/BQFmBJvt2eRgSI9O1wwVUyvyU+W/PWT87SMJtppFqWT0tbbbY4RrwTibC+h+
	 vRoIwSYNpZ4emNsZBYaD7EfBsBqWch3B3H/LtMxlajqsuUoyxPxBS6zuI4HGtPojNu
	 8+r5Z4Lyq4ejkyumhrE8z7NXeB2g1YKyCraP5gp6qhIJIp9uCvJY4oNMtyd4a8vlpm
	 Zxmmn55Dimo/LkHYldzkbMyHmaf5C0TDJiBzu2QZfpXdAAJJBwgR9qVtLUY4CzeL7D
	 ivgkI+mVOjRqw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Borislav Petkov <bp@alien8.de>,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	Alexey Kardashevskiy <aik@amd.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/3] Remove old AES-GCM library
Date: Tue, 21 Jul 2026 19:53:35 -0700
Message-ID: <20260722025338.33354-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The old AES-GCM library code is being replaced as part of an overhaul
that is adding support for all the common AES encryption modes with
consistent conventions
(https://lore.kernel.org/linux-crypto/20260715221153.246410-1-ebiggers@kernel.org/).

The SEV code is the only user of the old API.  Update it to use the new
API instead.  Then remove the old API.

This applies to libcrypto-next.  If possible I'd like to take this
through libcrypto-next for 7.3.  Acks are appreciated.

Eric Biggers (3):
  x86/sev: Use new AES-GCM library
  x86/sev: Remove obsolete virtual address check
  lib/crypto: aesgcm: Remove old AES-GCM library

 arch/x86/Kconfig                        |   2 +-
 arch/x86/coco/sev/core.c                |  53 +-
 arch/x86/include/asm/sev.h              |   2 +-
 drivers/virt/coco/sev-guest/sev-guest.c |   7 +-
 include/crypto/gcm.h                    |  21 -
 lib/crypto/Kconfig                      |   6 -
 lib/crypto/Makefile                     |   3 -
 lib/crypto/aesgcm.c                     | 721 ------------------------
 8 files changed, 26 insertions(+), 789 deletions(-)
 delete mode 100644 lib/crypto/aesgcm.c


base-commit: e4f23159c8d09b6b15d47f2c95e0a3e7c62f52a2
-- 
2.55.0

