Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95571DFDA1;
	Fri, 18 Jul 2025 19:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752866402; cv=none; b=uRJjixIIDAFepnDgZ9MihjLceSEephrpmT4G49Z0JnMl75MXVIhaMuLKuZymPGeVOzpT/nbg5ZdQJqheWjGWWof5zzLC+eUEQmL6w2ebKBK8xRtDY9YjQT0UubW11fDPE6n/hVMzHm2ABw6ynmzDPrZKSk+pLw8vUS+HbbOeLGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752866402; c=relaxed/simple;
	bh=RCnvIJ2yqVZid3IVlJuh6YiRIgY7YpShXYnefGcyE3s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cb7SFDu/pTVv9RNansnhvJfcsQSJIGOerVEEvnwiPVR7z5YsWciSxNRXFucy3dhTckM0k5klsLY/mtM8BIwpIFPkdvQObDRK6pskvaujC6T+c6IBfVPiCGYj6iufTeO+NW4LApsoIG9j2JsEinw8toubE79zy1SeQhBaeNzl2uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lIzOmown; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lIzOmown"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61349C4CEEB;
	Fri, 18 Jul 2025 19:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752866401;
	bh=RCnvIJ2yqVZid3IVlJuh6YiRIgY7YpShXYnefGcyE3s=;
	h=From:To:Cc:Subject:Date:From;
	b=lIzOmownckXUJAmZ6G7Mn5qVkxVmUUS/pAXYF/3uttIRO99AWTZiKtI5S71MUGP8o
	 tjFg6ODOt765WK0uDtQnwdlD0Eu6vmnl9UqirkctX/wdXWvX7hII1aB0mwtxr5t+SC
	 tF4sqx7gOmw+s3sMXcjf3+mz1oKuBkXHdtbdB+yb8xOEHnBuRxOZpHpCEiTtqaoBGd
	 fvz2mA2tYpQDpt8F5VmvbzAL5uyG5y2G0W67woxQ0C2uySAqHKzZQC6poej/hSiVj+
	 yxfGp/4rrnLP6vKHQ0hyOeCTas2LWJ6qL9qneOUQCjPIz2hE9ow/q8lINh0ANu7M2i
	 4aztSaDiw+peg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/2] sha1-ni-asm.S cleanups
Date: Fri, 18 Jul 2025 12:18:58 -0700
Message-ID: <20250718191900.42877-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series cleans up the x86_64 SHA-NI optimized SHA-1 code.

This is targeting libcrypto-next.

Eric Biggers (2):
  lib/crypto: x86/sha1-ni: Minor optimizations and cleanup
  lib/crypto: x86/sha1-ni: Convert to use rounds macros

 lib/crypto/x86/sha1-ni-asm.S | 253 ++++++++---------------------------
 1 file changed, 53 insertions(+), 200 deletions(-)


base-commit: 78792545ad68c05d1eb7b3c3b03c4309da921a04
-- 
2.50.1

