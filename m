Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F642AEED;
	Fri, 28 Mar 2025 16:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743179904; cv=none; b=S/qLiclm5jIVVpZ+uCJHIg00BAyHh32tepytc7s8dSrHoPGsI9KWdcwagNoAF+BSeQ1yP1j7byf/9nIWzm/P14GgvyIt/lBLP+JFyI8lSzQ+0PInQlqR7l2deskYeKgNKxfaiFz1hjKrVe1NnDlwEBzQ1IzU83N+x7q4mkiYUes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743179904; c=relaxed/simple;
	bh=+wK2eUITZVc9tdHtbzul7Y3+LJaTyu/T6awkWEcmYpg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=timVagcJf1xT84W34+kdCFEolGF/jNh7gu1H+3deK3AaoGA8T0MxT5u3GwiP9xvoW/z7/4NrsEwV/4XMLqiBT4TAZTrq2Jef0B2YNznOj0ZdEpLKc8u4u97z7oqLEOsQyk+LmkvrA1htEZ4dywmzCgFMTJEa3F15OzRh0sF4sRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ogWnfSoM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ogWnfSoM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A044AC4CEE4;
	Fri, 28 Mar 2025 16:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743179902;
	bh=+wK2eUITZVc9tdHtbzul7Y3+LJaTyu/T6awkWEcmYpg=;
	h=Date:From:To:Cc:Subject:From;
	b=ogWnfSoMKq2jVCNQfPQ21eiyjSEvEgAboLN0LumziA1CRLCCfEVJX+Fbm5R1uxWJ7
	 x48rgsUu+2DcXdqoRFxZKC4l+otVixx0o+EO16fhLnPE9SyTvHznlrwWZ+IXB/dwot
	 J3+7ZasZ2zquo60E7sH3prgZIce1GaHkWgHQr/QovL4cI0zAAsu1pgRiJoLR0xxo0C
	 y38IvrFFxjPmuWitw52rdpRq2BonxjWQg+DAnOvz6iB889+LoV9QIytmEjovxDoiqw
	 o8gCR6r09tbwns+Vwq9SeouvVNpiyqwQZazfWPwi/JM0NioDhHilMpN7jI19Mc/vvy
	 925MTySUCeR1Q==
Date: Fri, 28 Mar 2025 09:38:21 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	David Binderman <dcb314@hotmail.com>
Subject: [GIT PULL] CRC fixes for 6.15
Message-ID: <20250328163821.GA148488@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 1e26c5e28ca5821a824e90dd359556f5e9e7b89f:

  Merge tag 'media/v6.15-1' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media (2025-03-25 21:00:31 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/crc-for-linus

for you to fetch changes up to d48b663f410f8b35b8ba9bd597bafaa00f53293b:

  arm64/crc-t10dif: fix use of out-of-scope array in crc_t10dif_arch() (2025-03-26 14:04:43 -0700)

----------------------------------------------------------------

Fix out-of-scope array bugs in arm and arm64's crc_t10dif_arch().

----------------------------------------------------------------
Eric Biggers (2):
      arm/crc-t10dif: fix use of out-of-scope array in crc_t10dif_arch()
      arm64/crc-t10dif: fix use of out-of-scope array in crc_t10dif_arch()

 arch/arm/lib/crc-t10dif-glue.c   | 4 +---
 arch/arm64/lib/crc-t10dif-glue.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)
