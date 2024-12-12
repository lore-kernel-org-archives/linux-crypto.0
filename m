Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343361BE251
	for <linux-crypto@vger.kernel.org>; Thu, 12 Dec 2024 21:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734038955; cv=none; b=r44Q7cSOoRdtXN11Ez950o7VWarFYdCJ4O5pxlTr/TWYklwOi/74lWgZJP/rWiG+EpFDrcUagFevIfiiI86PNYFK1SbujLR+P0Z/mWxkT8R3YVCIvlAZ8XzFPHC8FaQ6HNasStQixHTHqPjhNrBGuyW2ldNbPymgDKlx9J5WKAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734038955; c=relaxed/simple;
	bh=TkP1XJrK/GJ7EK8JMVMUypBZCWeEbTv3W9FS8gOMKRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SP3G6VAYCZXi4/GM4bZBA02yXJPF/WdjCNjR9DzgqORnatDQKAfA5TcFG/sP9ENTKdbT4FPanFnUwGatfDbUo+kycsFm1hUAQkW0juxpoGQskUrW7wlSCbUcFQj1v/1d/CexQD/neV5Ang3kGLqQeTDq4CQlmqpFVbeK1CDigEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D7kKsSXr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D7kKsSXr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CC8C4CECE;
	Thu, 12 Dec 2024 21:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734038954;
	bh=TkP1XJrK/GJ7EK8JMVMUypBZCWeEbTv3W9FS8gOMKRQ=;
	h=From:To:Cc:Subject:Date:From;
	b=D7kKsSXrPFKvm/RRjZN4pWLrsLPkMRiPy6SlOzl1LEAR5pnv3RXn72vHfOxrc1rF7
	 ndRgeLnN0Q6Yv7KbdKwvqHWFcdDWaqtYbULaCYzg4RJDQ7eMMMEov30CkwT3IrboSp
	 kQ6aAw5JWp25unipWVfs9ps0pXouXERmaGL8aQ6BP2mW72B8eHSawWnyjqIQOXuNZm
	 qGQL+irRiBW75BWYyavjPDGIqVlTZqx+tydktuTHqNiHFJIpWw72tNDIbt5wwuXOT0
	 umrojilwH38iDIqguGkWqEwRVB19l+0DyPSC5a7ihR/4Sr9mPvPUZEhStR8cGR1OZA
	 z7EUB6q8jiV5Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org
Subject: [PATCH v2 0/8] crypto: x86 - minor optimizations and cleanup to VAES code
Date: Thu, 12 Dec 2024 13:28:37 -0800
Message-ID: <20241212212845.40333-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series contains a few minor optimizations and cleanups for the
VAES-optimized AES-XTS and AES-GCM code.

Changed in v2:
  - Added patch "crypto: x86/aes-xts - additional optimizations"
  - Small additions to "x86/aes-xts - use .irp when useful" and
    "x86/aes-xts - improve some comments"

Eric Biggers (8):
  crypto: x86/aes-gcm - code size optimization
  crypto: x86/aes-gcm - tune better for AMD CPUs
  crypto: x86/aes-xts - use .irp when useful
  crypto: x86/aes-xts - make the register aliases per-function
  crypto: x86/aes-xts - improve some comments
  crypto: x86/aes-xts - change len parameter to int
  crypto: x86/aes-xts - more code size optimizations
  crypto: x86/aes-xts - additional optimizations

 arch/x86/crypto/aes-gcm-avx10-x86_64.S | 119 ++++-----
 arch/x86/crypto/aes-xts-avx-x86_64.S   | 329 +++++++++++++------------
 arch/x86/crypto/aesni-intel_glue.c     |  10 +-
 3 files changed, 221 insertions(+), 237 deletions(-)


base-commit: f04be1dddc70fcdd01497d66786e748106271eb6
-- 
2.47.1

