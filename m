Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7391C27;
	Fri,  5 Sep 2025 03:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757043779; cv=none; b=rXbE8Y7Xoy8WGEI7y3GsA7A4nfvCq/Mo6KkyhiB+Ti5OG5khv6fdfhgPeRt+CLhLCGSs0J9V4XZslcOkFGY5POLENl8ChbDuS3otp9PkCULzZ9k38MlftKj+SNY/BXAwfXodBRrh+ivAZjM7Gj9EWEkwn/zMOojVgXu4OzknTKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757043779; c=relaxed/simple;
	bh=3uUv/RGXuNkF511V2W3koYnbXdQO5rX5vAVSib8WOvY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=sQK+dnLDcNES4+OwWZhhuMGkIP4167BZcWIHxeD9yGAW8fs7QWtcAUhJknSy5gaIOrmO/N1IirRCrYjRWJ8hZvUhexDhL1hLubZFzQVxrmnen2wV1mQxUxk8IXUr0i/jaHbaSeyzypK0PHYC57W9UBx5y/xV+ejJjCg6toRtgFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ULgv/ynG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ULgv/ynG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C125BC4CEED;
	Fri,  5 Sep 2025 03:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757043779;
	bh=3uUv/RGXuNkF511V2W3koYnbXdQO5rX5vAVSib8WOvY=;
	h=Date:From:To:Cc:Subject:From;
	b=ULgv/ynGOAlegYJr6mCM8scV00qLXK8T/hHYLJGeOskyh7G3bWWKo0Y6UMPCznhMd
	 T23UJDu97uqQa58MjI4i7GIr2RXi4VxDncJeLONau3HOmnYnd2QfcGG3F47/HzRZt4
	 CZCMEbSjw5vdHjGzhMTSoHDVLpZGomSTBbw/5Zqb+9QHwTOsjOuu4zWHhYkhK/gYTc
	 GlHYG32KM5ijzAL7uXWWhKzHW8NvN5UXwjQIWMs0JUW3Bw9xnf2HDEZ7Lh19ZJJW0U
	 gluVqqVCSv5YfFw4ejC3PKrBpUXyqwrjNejZPS4jIVweemqtqkmivwdEFB9V4bKLt1
	 4tPChFHoLtqvg==
Date: Thu, 4 Sep 2025 20:41:48 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Subject: [GIT PULL] Crypto library fixes for v6.17-rc5
Message-ID: <20250905034148.GA26307@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit fd7e5de4b2eddd34e3567cd419812d8869ef4f13:

  lib/crypto: ensure generated *.S files are removed on make clean (2025-08-14 18:01:03 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-fixes-for-linus

for you to fetch changes up to cdb03b6d1896c2d23f9c47dc779edba0a9241115:

  crypto: sha512 - Implement export_core() and import_core() (2025-09-02 19:02:39 -0700)

----------------------------------------------------------------

Fix a regression caused by my commits that reimplemented the sha1,
sha256, and sha512 crypto_shash algorithms on top of the library API.
Specifically, the export_core and import_core methods stopped being
supported, which broke some hardware offload drivers (such as qat)
that recently started depending on these for fallback functionality.

Later I'd like to make these drivers just use the library API for
their fallback. Then these methods won't be needed anymore. But for
now, this fixes the regression for 6.17.

----------------------------------------------------------------
Eric Biggers (3):
      crypto: sha1 - Implement export_core() and import_core()
      crypto: sha256 - Implement export_core() and import_core()
      crypto: sha512 - Implement export_core() and import_core()

 crypto/sha1.c   | 39 +++++++++++++++++++++++++++++++
 crypto/sha256.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/sha512.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 181 insertions(+)
