Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101DA29422
	for <linux-crypto@vger.kernel.org>; Sat,  7 Dec 2024 19:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733601513; cv=none; b=J7szlCRhQO0ars62+PIcW6Kc6318Sf3HzWg8yuVQcmbtQvkETK9hG6URr3demdzOCjl43yqgqPp/ggj5NHaq83sSiwXftDJ5Ah5nyiVsZ6Dm1+usFdIxbpHGrCeFauJwsu7p45AJg/AYCoYCGjpP7tdrmKawLhwk2PL+czJGzbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733601513; c=relaxed/simple;
	bh=CdCXh1fS1Qi7F0Ixa24GM6LGKFkc7xmdaMC7czCKotg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=lS0xnQJjZizvmemiHFxK1ITW/fSR0mzTroYhvSUC85yqfqXmOgx8Q8kXrdszunvwgbpMm296WVruAWHgmlRlEWzgKeWJLaOC4KoI9uOjXEwgzUVOt/V8RJ5xDwfSrFsyDndU0YwZy6F8b7yO1JwhCwCIA7lwnvkF+RXzclDQZVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cFI4FWnD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cFI4FWnD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE4CC4CECD
	for <linux-crypto@vger.kernel.org>; Sat,  7 Dec 2024 19:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733601512;
	bh=CdCXh1fS1Qi7F0Ixa24GM6LGKFkc7xmdaMC7czCKotg=;
	h=From:To:Subject:Date:From;
	b=cFI4FWnDHKuZw0utoM223sudGszMRZFyGug3VTk26PjnX7gyhfOc5Og0rXqBT5ylJ
	 ZXjmWg/TLxnMWRBbQF6hO/xgZWUDa8rT9mWlYs1S5EiPMJKD4w/AqMupCX4/qVYXsF
	 TvH3aMKHdhTnLAjIcP6KXhvLl2Ougk3LNqY5DdR/sXRMtyWPD2I9q9sgqq5K2pXY1H
	 ngfa3uWkFtfA5Dj3ETtCyp4a7gY11UBUL2dm7GHtBAqCyeLXK9kTPUz33yhCj2vnab
	 0xZQtotYA1EkXxKLCSGsh4tI+rNt9WI+/QeP7eJnyTKCIKujFoqxaz8tvkveNc3KDm
	 aWnJoN2pgpUcA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 0/8] crypto: more alignmask cleanups
Date: Sat,  7 Dec 2024 11:57:44 -0800
Message-ID: <20241207195752.87654-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove some of the remaining uses of cra_alignmask.

Eric Biggers (8):
  crypto: anubis - stop using cra_alignmask
  crypto: aria - stop using cra_alignmask
  crypto: tea - stop using cra_alignmask
  crypto: khazad - stop using cra_alignmask
  crypto: seed - stop using cra_alignmask
  crypto: x86 - remove assignments of 0 to cra_alignmask
  crypto: aegis - remove assignments of 0 to cra_alignmask
  crypto: keywrap - remove assignment of 0 to cra_alignmask

 arch/x86/crypto/aegis128-aesni-glue.c |  1 -
 arch/x86/crypto/blowfish_glue.c       |  1 -
 arch/x86/crypto/camellia_glue.c       |  1 -
 arch/x86/crypto/des3_ede_glue.c       |  1 -
 arch/x86/crypto/twofish_glue.c        |  1 -
 crypto/aegis128-core.c                |  2 -
 crypto/anubis.c                       | 14 ++---
 crypto/aria_generic.c                 | 37 ++++++------
 crypto/keywrap.c                      |  1 -
 crypto/khazad.c                       | 17 ++----
 crypto/seed.c                         | 48 +++++++---------
 crypto/tea.c                          | 83 +++++++++++----------------
 12 files changed, 82 insertions(+), 125 deletions(-)


base-commit: b5f217084ab3ddd4bdd03cd437f8e3b7e2d1f5b6
-- 
2.47.1

