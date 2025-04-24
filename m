Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C3D17F7;
	Thu, 24 Apr 2025 00:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745454177; cv=none; b=Ie0CF/ihgAhiK2HmAl1Q2vHsIXx+9AK3jpyZoAKeWnfvm8BNZIFAn4J/h4fuSaHpp0jPSMVFE9WdKvWk5JCMrWXuBD2pKAYIj4YUOBjQRPuD4heCS5CtPehBMZvcFo+XQFZf6fFOBnqB0xbb/lTmPeTmetlerlcfq5txGGFrClE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745454177; c=relaxed/simple;
	bh=zkgW3SiDgnggtuRkQQ2RvOw/6rX9QtoTG8UCIHjtB6s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=G0IeIbe17B7qzDYMeD/ggvd7I9E+lTBh/t6pmT0H+H9b+qblszKBEuaFIpVG254jyQ4J+WOaVDYdnVNt2pqIm/kYtnrb7SK7V8Q+j0ddmWPSYhpaBS2xVzXKaa/qMJy2rrkKvtmiV9+9KOoAjLBRMAucLP+iy5u/Cb0pbHXt2jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UO/B6EN6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UO/B6EN6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23DCC4CEE2;
	Thu, 24 Apr 2025 00:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745454177;
	bh=zkgW3SiDgnggtuRkQQ2RvOw/6rX9QtoTG8UCIHjtB6s=;
	h=From:To:Cc:Subject:Date:From;
	b=UO/B6EN63Q0MfszXeohxRiovANguNpxtJg/NNqgy8lk+bdQaa6mbu/8S4libCyQRR
	 HSIRMYpy+ZiYfoztydxN34bUyWR6KCKmB0xU7hRk8iYxvJIOIkrRWT8Zmc1uU02NsJ
	 xsBYWT37QGnF9rebc74+R/9OllnOrqij45u+GI7YlOwbQwtqkd0s2GL4hFXQmCr5GG
	 /n8N6mnXAy2GCs2mMHcQJVwFcppJhYXpQ5n4lleosLvV9DlnLFRP9uYCdskDE+QiTN
	 0YTC5KsqgM5kAzcadtPwXpGKAj+oluDbScYL38nyedfMU0m402zA/WhqIEhv3zsxYS
	 1+YvvpI7odh7g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH 0/7] lib/crc: drop "glue" from filenames
Date: Wed, 23 Apr 2025 17:20:31 -0700
Message-ID: <20250424002038.179114-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes an odd naming convention that was unnecessarily
carried over from the original Crypto API code.

I'm planning to take this via the crc tree.

Eric Biggers (7):
  arm/crc: drop "glue" from filenames
  arm64/crc: drop "glue" from filenames
  powerpc/crc: drop "glue" from filenames
  powerpc/crc: rename crc32-vpmsum_core.S to crc-vpmsum-template.S
  s390/crc: drop "glue" from filenames
  sparc/crc: drop "glue" from filenames
  x86/crc: drop "glue" from filenames

 arch/arm/lib/Makefile                                       | 4 ++--
 arch/arm/lib/{crc-t10dif-glue.c => crc-t10dif.c}            | 0
 arch/arm/lib/{crc32-glue.c => crc32.c}                      | 0
 arch/arm64/lib/Makefile                                     | 4 ++--
 arch/arm64/lib/{crc-t10dif-glue.c => crc-t10dif.c}          | 0
 arch/arm64/lib/{crc32.S => crc32-core.S}                    | 0
 arch/arm64/lib/{crc32-glue.c => crc32.c}                    | 0
 arch/powerpc/lib/Makefile                                   | 4 ++--
 arch/powerpc/lib/{crc-t10dif-glue.c => crc-t10dif.c}        | 0
 .../lib/{crc32-vpmsum_core.S => crc-vpmsum-template.S}      | 0
 arch/powerpc/lib/{crc32-glue.c => crc32.c}                  | 0
 arch/powerpc/lib/crc32c-vpmsum_asm.S                        | 2 +-
 arch/powerpc/lib/crct10dif-vpmsum_asm.S                     | 2 +-
 arch/s390/lib/Makefile                                      | 2 +-
 arch/s390/lib/{crc32-glue.c => crc32.c}                     | 0
 arch/sparc/lib/Makefile                                     | 2 +-
 arch/sparc/lib/{crc32_glue.c => crc32.c}                    | 2 +-
 arch/x86/lib/Makefile                                       | 6 +++---
 arch/x86/lib/{crc-t10dif-glue.c => crc-t10dif.c}            | 0
 arch/x86/lib/{crc32-glue.c => crc32.c}                      | 0
 arch/x86/lib/{crc64-glue.c => crc64.c}                      | 0
 21 files changed, 14 insertions(+), 14 deletions(-)
 rename arch/arm/lib/{crc-t10dif-glue.c => crc-t10dif.c} (100%)
 rename arch/arm/lib/{crc32-glue.c => crc32.c} (100%)
 rename arch/arm64/lib/{crc-t10dif-glue.c => crc-t10dif.c} (100%)
 rename arch/arm64/lib/{crc32.S => crc32-core.S} (100%)
 rename arch/arm64/lib/{crc32-glue.c => crc32.c} (100%)
 rename arch/powerpc/lib/{crc-t10dif-glue.c => crc-t10dif.c} (100%)
 rename arch/powerpc/lib/{crc32-vpmsum_core.S => crc-vpmsum-template.S} (100%)
 rename arch/powerpc/lib/{crc32-glue.c => crc32.c} (100%)
 rename arch/s390/lib/{crc32-glue.c => crc32.c} (100%)
 rename arch/sparc/lib/{crc32_glue.c => crc32.c} (97%)
 rename arch/x86/lib/{crc-t10dif-glue.c => crc-t10dif.c} (100%)
 rename arch/x86/lib/{crc32-glue.c => crc32.c} (100%)
 rename arch/x86/lib/{crc64-glue.c => crc64.c} (100%)

base-commit: 1ec3d4ff5c77422927896c1f7d0ed01267ec1213
-- 
2.49.0

