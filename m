Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB45372;
	Wed, 29 Jan 2025 17:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738172497; cv=none; b=aAyGCnFT0PfZpL53o7M+x3+9ObAQ3la0MVc1fehXgUIkDyEa8xsnpVv+Fp2BxoJHau8DXYMZMWCs0okRwNr8K9RGgopyGGIaIO2w1K43uAURytUI5u7mGaMDednnpivcp0KCbpGckr5vqm8uHSQIhcoHYJnwdLjyh8Qlw0MP8t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738172497; c=relaxed/simple;
	bh=lKv26esaqJ9ZDwu7NoLFWrsVCGlL6kFrADFq+NJRUDI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=OtUq1lIBSBxSh+xyaFKVkTMZhWNdjqKXhygJ87vifqSCHKfPOyNy/ZC9D876qkcU27zCdv+AiWlqd93vum+epzOvWF4P1RVp1qlPG/ZGMQQ/ePU0fVJzZDrxYT/tFXKd1gSDHmYjAoNhbzRVSFjRPUwMnpYYIv4usfz2MepR16Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=clXK80rJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="clXK80rJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C88C4CED1;
	Wed, 29 Jan 2025 17:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738172497;
	bh=lKv26esaqJ9ZDwu7NoLFWrsVCGlL6kFrADFq+NJRUDI=;
	h=Date:From:To:Cc:Subject:From;
	b=clXK80rJifvTBTqlipZ4KtQ/57CVy7Ng9yCMP8mA1f1Nu2caOvrqtvgScOpuofb2c
	 bLYY/kkNb0My+k1fFqzHTpHJl9R1Z6oU6JsQhs4K7mOs+WYGHUsttPQXJXmAKxo2LI
	 wxTRlm3WppVw7Xyi3akvKbfVGXcvZyrGkYkhTEaoAKHdzNUj4nA9GyRdET4pimjrwR
	 MFRHyRAo7ZPue7OqFRCd3dhbBgkPFSSAvN5mHfGer/kVe6n6apEGO78NNVOXdpO2Ca
	 60JJpFK83BAz6eGCPPLEL2gfa0G/2ocTk9QX398mjzU3PaPjNODduvMBg4y0k7MQ0v
	 CPTFtTF0pUXIw==
Date: Wed, 29 Jan 2025 09:41:35 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>, Chao Yu <chao@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Theodore Ts'o <tytso@mit.edu>, WangYuli <wangyuli@uniontech.com>
Subject: [GIT PULL] CRC fixes for 6.14
Message-ID: <20250129174135.GA1994@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit d0d106a2bd21499901299160744e5fe9f4c83ddb:

  Merge tag 'bpf-next-6.14' of git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next (2025-01-23 08:04:07 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/crc-for-linus

for you to fetch changes up to 5e3c1c48fac3793c173567df735890d4e29cbb64:

  lib/crc32: remove other generic implementations (2025-01-29 09:10:35 -0800)

----------------------------------------------------------------

Simplify the kconfig options for controlling which CRC implementations
are built into the kernel, as was requested by Linus.  This means making
the option to disable the arch code visible only when CONFIG_EXPERT=y,
and standardizing on a single generic implementation of CRC32.

This has been in linux-next since last Friday.  The late rebase was just
to add review tags.

----------------------------------------------------------------
Eric Biggers (2):
      lib/crc: simplify the kconfig options for CRC implementations
      lib/crc32: remove other generic implementations

 lib/Kconfig          | 118 +++------------------------
 lib/crc32.c          | 225 +++------------------------------------------------
 lib/crc32defs.h      |  59 --------------
 lib/gen_crc32table.c | 113 +++++++-------------------
 4 files changed, 53 insertions(+), 462 deletions(-)
 delete mode 100644 lib/crc32defs.h
