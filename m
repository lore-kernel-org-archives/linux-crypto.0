Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A67C2135A5;
	Wed,  5 Feb 2025 03:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738727465; cv=none; b=NjTx9w7/k59HHGExRg1gnpby2Q4b4SQSWHa/97nSwyTjZeCcYBMe62JptnrHtC3Thu8n5wL7u5QqQ8D9ScogI1ma6BAJ1G5kyi5AswMqKjLrXZs0PaaI/8cnXhbG9QjrF2qkDn65KPP7ijJf9cL/B32f8ddo2XGiDJ3UoLvoivk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738727465; c=relaxed/simple;
	bh=hAnIDXuDf0PShrfixNOdDSriQaWe2OVhupNLGSMTHWc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SZPxOJEEGssmcoy0CVzSx0+57evbHwVIVVPZ/SEPvxWDNaQnAXktZacUKx1ejh+Gm1bE83XGZLH6QXNcfxwLgAQ+xcPupxiRy93gQaL8+Ao0yvby+vgiSnt9LE5Vy52BdVUhnkzW/zmo0M/1LTD0fJN/dwom4Hhc+CoRkp8eTHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D8c/XgUI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D8c/XgUI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A2CC4CED1;
	Wed,  5 Feb 2025 03:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738727464;
	bh=hAnIDXuDf0PShrfixNOdDSriQaWe2OVhupNLGSMTHWc=;
	h=From:To:Cc:Subject:Date:From;
	b=D8c/XgUIg7fIE0SHZStay8ounMGyM9v51v9XncriJSyijyMBt4hMfqgOrNf2mHwLc
	 6uU7+Zr2rImT6pdvtyhX5Nq2chpcrIpw620sIJ2uyPN9WPGACEqkKFIB7FKEjkHZuG
	 +wZK89somZBZm0dMihRdJKNYQ0HBduJsabDYbH16Q6zeziFC94/xJFMN1/915HvoGb
	 JNu3np5S+7EJbb/LUMuNYPqXmMzK5EhIUvqQnQUmP9tsqrN45LXkJjaCdthoMXrHHk
	 HI2DJ2x9KU9+bKoGUyNpnDRAPX2sxpgsfn7V3crJeR7uHpZdVG8PoaTvNSsWduYGEo
	 LpbzlYDI6Dexg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] crypto: x86 - AES-CTR and AES-XCTR rewrite
Date: Tue,  4 Feb 2025 19:50:24 -0800
Message-ID: <20250205035026.116976-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series adds new implementations of AES-CTR and AES-XCTR that are
optimized for modern x86_64 CPUs, and it removes the existing
implementations that are superseded or obsolete.

Changed in v2:
- Split the removal of the non-AVX implementation of AES-CTR into a
  separate patch, and removed the assembly code too.
- Made some minor tweaks to the new assembly file, including fixing a
  build error when aesni-intel is built as a module.

Eric Biggers (2):
  crypto: x86/aes-ctr - rewrite AES-NI optimized CTR and add VAES
    support
  crypto: x86/aes-ctr - remove non-AVX implementation of AES-CTR

 arch/x86/crypto/Makefile                |   2 +-
 arch/x86/crypto/aes-ctr-avx-x86_64.S    | 552 ++++++++++++++++++++++
 arch/x86/crypto/aes_ctrby8_avx-x86_64.S | 597 ------------------------
 arch/x86/crypto/aesni-intel_asm.S       | 125 -----
 arch/x86/crypto/aesni-intel_glue.c      | 450 ++++++++----------
 5 files changed, 756 insertions(+), 970 deletions(-)
 create mode 100644 arch/x86/crypto/aes-ctr-avx-x86_64.S
 delete mode 100644 arch/x86/crypto/aes_ctrby8_avx-x86_64.S


base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b
-- 
2.48.1

