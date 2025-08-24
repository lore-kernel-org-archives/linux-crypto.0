Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4741FB3;
	Sun, 24 Aug 2025 01:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755999613; cv=none; b=L2iBJmaAbnFRmvQSGMpIWwciQ8xnli/lsxiP6oe716C7bN9hNx49g3aXcM4n14LjiQhmUOJXWKpCnkoTGVRuce0zdLNkUM695jO4rStLKN1oCc5Pl4hEXvP4Zvy1yzFP2jNkSqAKbQgj8Rk6sHoN498osIjlPr/698ASfSVabHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755999613; c=relaxed/simple;
	bh=6EPVnLHz0Pz5WjonN5Q4v1n1t1qp2Lvggy/u4UvNalc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DwojC7slrqQTXc5FF2i0SuGGPalR/Ni4EAkE8ExffRpKcZPJ9Ahyb6+5mRy5Nybh9azJF8UARzGB6AfuRRCsm4kNIWJSNBdQTAt1Ot4KOHSAtsNeUSV0pASuo+XWA0hduT4voeuuo620MESlnKTlngeWND60eAt0nOtn/jjTGg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zgrbv9y0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zgrbv9y0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6F9C4CEE7;
	Sun, 24 Aug 2025 01:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755999612;
	bh=6EPVnLHz0Pz5WjonN5Q4v1n1t1qp2Lvggy/u4UvNalc=;
	h=From:To:Cc:Subject:Date:From;
	b=Zgrbv9y0JpXtEZCjuhrOevEaBPupj8EiLgrYnVOGNyyH0NKLR4Qhxspv946Svlgnm
	 1eAojdW715iqJmo1VdSBzbSlKYVWmW211o7Qt10oKSDgEg4d9jYE3twBlQgDl24dWl
	 lMr8fvpVeQBjNl4AZYv2uOqWfbwnK1iTA7x7wiB9RQlvihZlrGOUofm1lN3BCXkHcX
	 P40IhPV/oHD3S0t5ELqzLcMCh7smgPWlmHcGaW5WJ0eVtSa8gyyQnrfUL3HR3BuTXI
	 1KePYkz/xbcnsiw/JK187ozUV7KdSs3zIWcpqxWXDcl2p1OtXfoGwyoSRTWSZplsq0
	 rKARaxRv1+VZg==
From: Eric Biggers <ebiggers@kernel.org>
To: netdev@vger.kernel.org,
	Andrea Mayer <andrea.mayer@uniroma2.it>
Cc: David Lebrun <dlebrun@google.com>,
	Minhong He <heminhong@kylinos.cn>,
	linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH net-next v2 0/2] ipv6: sr: Simplify and optimize HMAC calculations
Date: Sat, 23 Aug 2025 21:36:42 -0400
Message-ID: <20250824013644.71928-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series simplifies and optimizes the HMAC calculations in
IPv6 Segment Routing.

Changed in v2:
- Rebased on top of latest net-next.  Dropped "ipv6: sr: Fix MAC
  comparison to be constant-time" since it was upstreamed already.
  Moved key preparation to seg6_hmac_info_add().

Eric Biggers (2):
  ipv6: sr: Use HMAC-SHA1 and HMAC-SHA256 library functions
  ipv6: sr: Prepare HMAC key ahead of time

 include/net/seg6_hmac.h |  20 ++--
 net/ipv6/Kconfig        |   7 +-
 net/ipv6/seg6.c         |   7 --
 net/ipv6/seg6_hmac.c    | 211 ++++++----------------------------------
 4 files changed, 42 insertions(+), 203 deletions(-)


base-commit: b1c92cdf5af3198e8fbc1345a80e2a1dff386c02
-- 
2.50.1

