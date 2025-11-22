Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2725B1D435F;
	Sat, 22 Nov 2025 19:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763841155; cv=none; b=IAn+iuF67m+Bq4M2reQ3a8tORN7HFVi+7lBcy3OjME7E43Qv8thRI/BPEbN4gdHSAGDUVzs2T96ux/lkcNcSca08jRBTaZCyNwxeLDGLjZlv4FiCH/+HyC+pTraX8NfyIq65868mSJP/akrNFMCHWGZaMk12zB6hXUwx1ufRVFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763841155; c=relaxed/simple;
	bh=w70SwOckhcJU7Lu97Q+eMf6XE4owUA5J9/3tCJxHP+k=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=hQiHX1onPWSxNx/qegMxIwta3vVu3XZ67rgCMH65ZEdywdCS9VMPghuwfSUiuBp22mTLTjTLEb2YhlDK7+HBHD2JzWXQSLBqrM3LE7Uo56qpLeOFIYaNTZ514lt2OzKC47k+Hn6vMmgaP3aNdafZwckBoVLZ9l4S5GZt/OP550k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J+QJo81e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J+QJo81e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7ACEC4CEF5;
	Sat, 22 Nov 2025 19:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763841154;
	bh=w70SwOckhcJU7Lu97Q+eMf6XE4owUA5J9/3tCJxHP+k=;
	h=Date:From:To:Cc:Subject:From;
	b=J+QJo81eUSNIflHgHdQNl9QNczD1cKbmmqgKuWpVxo6H4b6gQXrrF0JHOOC5Rblwb
	 zDQ0Hfvcdj/Z/DrNdpJkud6EP1VfnkhU3nvaJeUxHRjFzjSk/S5jSvO7GFTvB8DxGU
	 sDUYsUuTxX0y7aar0UmTeFh+maGsc76AY055tHYi2P1vItLW/WNjtATfsuEeofNlAw
	 XkUhpYL1NMw/XzBiWs/qyoiyPDKwv4g2tHn2uWpemSQ9sMjis4Iak/Yg4g9jdbUTRx
	 5oo55IToT0uxH3u4+82+jC7UUx+Mg6e7DN3MnAi/46/4VVh4xjcgMlbR97Dz6cuz/o
	 dcZaBP+iMyPXA==
Date: Sat, 22 Nov 2025 11:52:31 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [GIT PULL] Crypto library fix for v6.18-rc7
Message-ID: <20251122195231.GC5803@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 44e8241c51f762aafa50ed116da68fd6ecdcc954:

  lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN (2025-11-04 09:36:22 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-for-linus

for you to fetch changes up to 141fbbecec0e71fa6b35d08c7d3dba2f9853a4ee:

  lib/crypto: tests: Fix KMSAN warning in test_sha256_finup_2x() (2025-11-21 10:22:24 -0800)

----------------------------------------------------------------

Fix another KMSAN warning that made it in while KMSAN wasn't working
reliably.

----------------------------------------------------------------
Eric Biggers (1):
      lib/crypto: tests: Fix KMSAN warning in test_sha256_finup_2x()

 lib/crypto/tests/sha256_kunit.c | 1 +
 1 file changed, 1 insertion(+)
