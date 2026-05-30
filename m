Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274AB331A78;
	Sat, 30 May 2026 20:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780172851; cv=none; b=pnxvBSLVjT/CGCjL7ei/7VIB3HltDQUpm+l7p36RkNRAIHGVb9TRMYtdn42fcQX8qkLpySoJ2RCKYV5nzLsLf2sd0IHIR0ezGb+p7EVqiX7eN774NHiMDggC9g1mtyXTgishlaf3ZWjM4u2zTW6TJGU71ghSPuIa0LJnuBM+ZAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780172851; c=relaxed/simple;
	bh=6FfuDvGQ52ApHLcvnjFmcKbo4qOFlZm4v9QEg206/1I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q6lz69/WpAwoKf/DlWFzoMtbkEHmAd21QQG0VOC0oadtVoLDFDtlDsdvv3HTtiamKWrNTAFBqdLprGbdcZFdA/JSvrDjrkYPXNDsy7W2ypIQUv+olRhMMsgBi0hc9bh9YfT6WVWgZdSGpWqzc6R7/eq1PohN+WG1jOkjacsbKN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C+DRcYR9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C+DRcYR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9461F00893;
	Sat, 30 May 2026 20:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780172850;
	bh=wFTi6Phf8WKLD7q/mNNfxoLqb45y5zUq92DGVlbSmFg=;
	h=From:To:Cc:Subject:Date;
	b=C+DRcYR9EJkOTLmYNwqj2iirQ34NpDmY2nKz9KonGffvKz2FcEIlf0jkkO7aU9YVb
	 /gcwwGq7ZmaoPCFCVh4qHo3116Bj3LkS6y3GdRd/xte5SbvDIC1hZuPCZqgpVsem8e
	 b3UIIT6E1BZkkl4SCE0rNYSnvWukD+TgPLqCHrkm5hRD1A5WXUzHLxGEOaBN0ACYL+
	 xjlbcti0jBI4V3qMrdjdMk9fzoWnNPMU+lj+TlI5PAxlUwv8wsmtYF8VgXCcH6SFT7
	 2t8kmYEsZRjOCvr0s75Q0vdPgs7d857qwse+1MBzlHKScIjylRVCnwoHTJMGCh0p4S
	 fIS+eISfyFMbg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Olivia Mackall <olivia@selenic.com>,
	Weili Qian <qianweili@huawei.com>,
	Wei Xu <xuwei5@hisilicon.com>,
	Longfang Liu <liulongfang@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/2] HiSilicon TRNG fix and simplification
Date: Sat, 30 May 2026 13:26:22 -0700
Message-ID: <20260530202624.20768-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes and greatly simplifies the HiSilicon TRNG driver by
removing the gratuitous crypto_rng interface, leaving just hwrng which
is the one that actually matters.

Note that this mirrors similar changes in other drivers such as qcom-rng
(https://lore.kernel.org/r/20260530020332.143058-1-ebiggers@kernel.org)

Eric Biggers (2):
  crypto: hisi-trng - Remove crypto_rng interface
  hwrng: hisi-trng - Move hisi-trng into drivers/char/hw_random/

 MAINTAINERS                            |   2 +-
 arch/arm64/configs/defconfig           |   2 +-
 drivers/char/hw_random/Kconfig         |  10 +
 drivers/char/hw_random/Makefile        |   1 +
 drivers/char/hw_random/hisi-trng-v2.c  |  98 +++++++
 drivers/crypto/hisilicon/Kconfig       |   8 -
 drivers/crypto/hisilicon/Makefile      |   1 -
 drivers/crypto/hisilicon/trng/Makefile |   2 -
 drivers/crypto/hisilicon/trng/trng.c   | 390 -------------------------
 9 files changed, 111 insertions(+), 403 deletions(-)
 create mode 100644 drivers/char/hw_random/hisi-trng-v2.c
 delete mode 100644 drivers/crypto/hisilicon/trng/Makefile
 delete mode 100644 drivers/crypto/hisilicon/trng/trng.c


base-commit: 5624ea54f3ba5c83d2e5503411a31a8be0278c1e
prerequisite-patch-id: 07e982b663ac3f8312ca524f6b91b5b38661df5e
prerequisite-patch-id: 72064361a8f36e015ab0b7e1fa4d364b40d90506
prerequisite-patch-id: 8978b8e0db7f47935e5f6f0aff14a97f55d3073c
prerequisite-patch-id: 6aa0e3e93a008279d71e535a3d0cf48643f55e19
-- 
2.54.0

