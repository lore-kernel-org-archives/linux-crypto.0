Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9B93563F1;
	Fri, 24 Oct 2025 19:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761332967; cv=none; b=LtWGvtrEKvi3MPxUBTwix0Licyy+OsTtA56lnHlipOpnK9+EFrL62SL845g1/cGAVjuVRklwX3O89f2yGYltsEO00BV9dTo1Pjjt69XSmFH6M4Lb6bcz+mxU7ttU7+ktojJQbVjpzGcY4d8aJrdbvO4d+zmUEp2rjOaP1QWkEKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761332967; c=relaxed/simple;
	bh=+Eq9xOCq1pUJTZafUHci4ZFEe7NEbByt2MpP2q80+FE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=R5QZ3sWAr0YIVm2mAZGQf/RVA89709qF8bEU5d7sPkGb8S1NM8BCystCMNg8nU7Z6kSkpRvkROtfvEE8i9FgWUQqmn3IQr8Me1oL5Pr9N/zhW2ZROuG+FcrEcJFWc00Vg+QuuNLtTtKiSLYUhH6boD7OgJMSAfQQchnWiMGJp9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z5PcEiIh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z5PcEiIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43FE0C4CEF1;
	Fri, 24 Oct 2025 19:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761332966;
	bh=+Eq9xOCq1pUJTZafUHci4ZFEe7NEbByt2MpP2q80+FE=;
	h=Date:From:To:Cc:Subject:From;
	b=Z5PcEiIhZq3la5ZHktJfC4yAkSk7NhKkNZfmW6uJx6nCqfwOk5piWHd5Xabdv8zL1
	 FtLuayUkG0fxLogGBJn57j+IrYc60iiZEx9VOl0aGKz7Bb0u4rQVwMEV4+3fLYWAkl
	 cqSbUkWB8DeGk4zOTsGepmePdVB/mBhBU1k1RgyuZe55m1tCSunVLLCyd2tFs4Tt6x
	 JkyUP5SCmxqAgcdc4BtMhyPhLzB06xurWd4q12AKRXPVTb7fO5dGkMWrRdyV8PwoGY
	 IYVAhJxPx9VJyiQQxUgodEKdSxeGkSvpUJorkG2FpZOy9jlrgKBLKng+sP7dnv4XON
	 zm3zHS5LhMZnA==
Date: Fri, 24 Oct 2025 12:09:24 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Pei Xiao <xiaopei01@kylinos.cn>,
	syzbot+01fcd39a0d90cdb0e3df@syzkaller.appspotmail.com
Subject: [GIT PULL] Crypto library fix for v6.18-rc3
Message-ID: <20251024190924.GA2068@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 211ddde0823f1442e4ad052a2f30f050145ccada:

  Linux 6.18-rc2 (2025-10-19 15:19:16 -1000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

for you to fetch changes up to 1af424b15401d2be789c4dc2279889514e7c5c94:

  lib/crypto: poly1305: Restore dependency of arch code on !KMSAN (2025-10-22 10:52:10 -0700)

----------------------------------------------------------------

Avoid some false-positive KMSAN warnings by restoring the dependency of
the architecture-optimized Poly1305 code on !KMSAN.

----------------------------------------------------------------
Eric Biggers (1):
      lib/crypto: poly1305: Restore dependency of arch code on !KMSAN

 lib/crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
