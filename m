Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969572367CF;
	Sun, 31 May 2026 19:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780255382; cv=none; b=BzJ+QfdbitRCN3LROh/jHnOdsLBd52zd/9YS1QeJCkg7z4aqVrEyQTZleV8rF6OCryICzWrbipEzS+BP3so5tYc6Bj8cAsjRXltsiWxGes6QB8XuKJA7Xnmc8K6WusEGrCxFUMpZD/ksm6rWfaopU2nZmvzYP5egaMnp1pZeibs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780255382; c=relaxed/simple;
	bh=zQrSG2kSHe1uJzFd27QTtobyzUqWjZA81Nd1eqrPkvo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IkHDkNrc922q2smAgRykHa8rZDgAVYoJKQs84uVQA78qjbSWOoJUWdZ7tr9fjuV9fn+W+GevD8Ikm+t75tmtSKiTJUUo+eZ8x2QZ5kGWBcvwaEJQCp+2VbSUvj0y3d8YDEyIFodPQybssGAh3g6ho4LSWI3FvuBDf3++Yu6cmpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dws3z4c5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dws3z4c5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D711F00893;
	Sun, 31 May 2026 19:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780255381;
	bh=WN5vnPFviUeFL5NXDKTxF5DmYlONBZ8T8/DEkRn0fw8=;
	h=From:To:Cc:Subject:Date;
	b=dws3z4c5ikBkfSFjo03lEPKwSoWHgcPAbhf9k5unktZ3mh+aPsy4L9BZpZ0dwksA8
	 XHAPpNzc0rXNaelTshQnFrU6Wuumrraa3dFfyDfWD+/cJ+CbCJcPMfFaqlAskJel0X
	 cVqQpMiqosVafTcv/drCo37ZULK0CNZn8dEQHkPyO4L5CWPGtEoB4aAmaHVGWtrtHK
	 yILr4yvSAw0u0BC0CnAzZABaTdS+HORKE9/DUY8HMcdOZv0+o5uvyl5oEHh002aEtL
	 rYfUY97EFov4bwIHdZEfpOTu6+OS+S8nsG9G6iQrDLozVYPZM3Kz/9+WCOGOU0XXN7
	 6X0C7V24/pnRQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Mounika Botcha <mounika.botcha@amd.com>,
	Harsh Jain <h.jain@amd.com>,
	Olivia Mackall <olivia@selenic.com>,
	Michal Simek <michal.simek@amd.com>,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/4] Xilinx TRNG fix and simplification
Date: Sun, 31 May 2026 12:17:34 -0700
Message-ID: <20260531191738.55843-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes and greatly simplifies the Xilinx TRNG driver by:

- Removing the gratuitous crypto_rng interface, leaving just hwrng which
  is the one that actually matters.

- Replacing the really complicated AES based entropy extraction
  algorithm with a much simpler one.

Note that this mirrors similar changes in other drivers.

Eric Biggers (4):
  crypto: xilinx-trng - Remove crypto_rng interface
  crypto: xilinx-trng - Fix return value of xtrng_hwrng_trng_read()
  crypto: xilinx-trng - Replace crypto_drbg_ctr_df() with HMAC-SHA512
  hwrng: xilinx - Move xilinx-rng into drivers/char/hw_random/

 MAINTAINERS                                   |   2 +-
 arch/arm64/configs/defconfig                  |   2 +-
 crypto/Kconfig                                |   5 -
 crypto/Makefile                               |   2 -
 crypto/df_sp80090a.c                          | 222 ------------------
 drivers/char/hw_random/Kconfig                |  11 +
 drivers/char/hw_random/Makefile               |   1 +
 .../xilinx => char/hw_random}/xilinx-trng.c   | 134 ++---------
 drivers/crypto/Kconfig                        |  13 -
 drivers/crypto/xilinx/Makefile                |   1 -
 include/crypto/df_sp80090a.h                  |  53 -----
 11 files changed, 37 insertions(+), 409 deletions(-)
 delete mode 100644 crypto/df_sp80090a.c
 rename drivers/{crypto/xilinx => char/hw_random}/xilinx-trng.c (75%)
 delete mode 100644 include/crypto/df_sp80090a.h


base-commit: 5624ea54f3ba5c83d2e5503411a31a8be0278c1e
prerequisite-patch-id: 07e982b663ac3f8312ca524f6b91b5b38661df5e
prerequisite-patch-id: 72064361a8f36e015ab0b7e1fa4d364b40d90506
prerequisite-patch-id: 8978b8e0db7f47935e5f6f0aff14a97f55d3073c
prerequisite-patch-id: 6aa0e3e93a008279d71e535a3d0cf48643f55e19
-- 
2.54.0

