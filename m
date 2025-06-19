Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB7223CB;
	Thu, 19 Jun 2025 18:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750358128; cv=none; b=rgfMFCVP/FWWEZaHi95Z/nbOatYt44mSyoDaJJP7m1O1AEonjwJgOjPk+D2v1BUp8hUNjHFvZ3NmS2tmVUz1QrxGjL/8oxRccADrgQr9pRo/barkGXOxHsS3XjEuxCN+iXxndABpsv3y0vDIiGTLZZejD23tQzVVIUdhFzJmpBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750358128; c=relaxed/simple;
	bh=OVgxB0JNGmUfOOdryOeQCzf81rBLhoS9ohDXBCGWS4A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NUfiiXNsgP0UsEVS8Uh0in9ChzVqmNG4AqqDW86U4lq6hpFJn6ynlxJT/d5i0vTy62lrS//OhsCW6pAnsqBnC9WmqFqzMcnmUN00SapaEa4IKhnwUnbfznf9iddftjIKBxCwTRq6bCsrZV6CzGduTioYpZZAgAukzzI8LtLaOYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IMPX2Mi/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IMPX2Mi/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41CCC4CEEA;
	Thu, 19 Jun 2025 18:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750358128;
	bh=OVgxB0JNGmUfOOdryOeQCzf81rBLhoS9ohDXBCGWS4A=;
	h=From:To:Cc:Subject:Date:From;
	b=IMPX2Mi/YHV+wzkfp2oRMCgjWG85PPvBTlWa/iz9a4tCEwA2YgtHDYmZ1m8e1ZYPC
	 eH4z015TTGwFGbfajSSdAhRnAJQWdYVMQ2qZe0NgxAg9vtbI9EB63RF0PXcSqFIbRC
	 8oQVBzfTXusDbDxvCM2ap262GjDWVv4IMSxrPdvjAmzt2UcX+s5i0wTm+iG3xQ+nYs
	 hoYZs2BCKnQmT6TeRiksF0amUy5NsP6XUv/XrqF8xCdTpKk7FTDwtEw5avlKjwEv2p
	 x0qv8zd8ofterabxzuAJIEYjYaP48OBQoN7Cb1bsfXDcJXK+7hFMpBEL9f7wTWl6+p
	 npqCm/faDz8uw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org
Subject: [PATCH 0/3] lib/crc: improve docs and change crc32() to inline function
Date: Thu, 19 Jun 2025 11:34:11 -0700
Message-ID: <20250619183414.100082-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Document crc32_le(), crc32_be(), and crc32c().  Also change crc32() from
a macro to an inline function.

Eric Biggers (3):
  lib/crc/crc32: document crc32_le(), crc32_be(), and crc32c()
  lib/crc/crc32: change crc32() from macro to inline function and remove
    cast
  lib/crc/crc64: add include/linux/crc64.h to kernel-api.rst

 Documentation/core-api/kernel-api.rst |  6 ++-
 include/linux/crc32.h                 | 74 ++++++++++++++++++++++++++-
 include/linux/crc32poly.h             | 16 ++----
 3 files changed, 81 insertions(+), 15 deletions(-)


base-commit: ee925097a5a76eaf9c4954cdd7288a070d57a8d4
-- 
2.50.0

