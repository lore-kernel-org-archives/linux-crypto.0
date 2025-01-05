Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4D113D619
	for <linux-crypto@vger.kernel.org>; Sun,  5 Jan 2025 19:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736105696; cv=none; b=iQsOdeyBx3ijUcc17Nqt603FjXW0bxT/gXoq1qGMaynhQ6C1nEKC61FzcexLfb7KgeG/eetMCew6mfkMY6b/I4yr9lcn5t+awZaL3tdlE538MhOKl5hRZgzQ4j6+8zao59wFl4ujq7EWnNOSs3++MJTdhMQmmqD2+3QC8FDq0Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736105696; c=relaxed/simple;
	bh=vdaqg0aKfH75rLoLfkcmbDXtSepsAUaz4JjO0oxK6SM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=GnUY7L/hTBfYfTJKUS7VEi2/Du9QDwKL6b2Nv/AMw+/WcLeL5hHV3z0yUruwTek1s093HOqkZtH5/3I/2GbqucroD4oAROBB+QKCvvoPcle9GBz4XL9uX+Vsj1bzy2Mjs9YImtWXmFM7Dynuw1ALQ829QRFC7++AJDN8FsnTdAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ewQg2qAG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ewQg2qAG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837F0C4CED0
	for <linux-crypto@vger.kernel.org>; Sun,  5 Jan 2025 19:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736105695;
	bh=vdaqg0aKfH75rLoLfkcmbDXtSepsAUaz4JjO0oxK6SM=;
	h=From:To:Subject:Date:From;
	b=ewQg2qAGoihmg161snuEYBnIwiQ1/0qDtjYTrFVXqEdymNaUsxiGb/njx42UI2AJP
	 duWJGqQPrjcfUZxYf+L/50s6QJkHoaFMIrTTtFoOJab1wWzZPJl04P/3AlmodYEl/F
	 0xYbZbse3py0175xMqdzDHI+bCRzs0CsJQjxYOiAhDJBPP0dPX2YrY9Pw5JZwc3oik
	 nlLPsfrN7BxABV5ZoRhVHRQ0YZMYaX5Bj9VsUKT/3BqXmWnmSaW47yRrxBydrKFA26
	 8+FqkZmd6z+tkyKb2E+eDI78VmIf4rrPucEZ/Jv579Yo6R/VQPyM2orTSMaPWVKVmc
	 VLL0QkLe2Fxmg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH v3 0/8] crypto: skcipher_walk cleanups
Date: Sun,  5 Jan 2025 11:34:08 -0800
Message-ID: <20250105193416.36537-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series cleans up and optimizes some of the skcipher_walk code.

I've split this out from my original series
"crypto: scatterlist handling improvements"
(https://lore.kernel.org/linux-crypto/20241230001418.74739-1-ebiggers@kernel.org/).
Please consider applying this smaller set for 6.14, and we can do
patches 11-29 of the original series later.

Other changes in v3:
   - Added comments in the patch
     "crypto: skcipher - optimize initializing skcipher_walk fields"

Eric Biggers (8):
  crypto: skcipher - document skcipher_walk_done() and rename some vars
  crypto: skcipher - remove unnecessary page alignment of bounce buffer
  crypto: skcipher - remove redundant clamping to page size
  crypto: skcipher - remove redundant check for SKCIPHER_WALK_SLOW
  crypto: skcipher - fold skcipher_walk_skcipher() into
    skcipher_walk_virt()
  crypto: skcipher - clean up initialization of skcipher_walk::flags
  crypto: skcipher - optimize initializing skcipher_walk fields
  crypto: skcipher - call cond_resched() directly

 crypto/skcipher.c                  | 206 +++++++++++++----------------
 include/crypto/internal/skcipher.h |   2 +-
 2 files changed, 90 insertions(+), 118 deletions(-)


base-commit: 7fa4817340161a34d5b4ca39e96d6318d37c1d3a
-- 
2.47.1

