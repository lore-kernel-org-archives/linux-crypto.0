Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E804622D781;
	Sat, 15 Nov 2025 23:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763248178; cv=none; b=MxlBydn+W4Zd2KENZFX0x9hHmxzOQpbbZ6L5MfAUq9TT0lfX1OexBdb+QPYaM6gCAcEX6TPSxKQjz6orH1Mwzp1wWK1YXrCMcmWJ0In+yYvtsaABKPricn+s+xfH0KN8Vh0dgQ2W+qwVr96Io/yUisMpVtYIFNA728dOZk7YP94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763248178; c=relaxed/simple;
	bh=+pinOLeFZxQs93A84yEGNHG0OKL1EHDvdEp9Dg/hWqg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A2Bwiz+csk39x/uvOKzrIMzyDoOQekHiA5MsoUbrGwbSr5T1IKd9puvy5tayaE2vY5woAapU632UaQ4gIW6DcB53dfr5wH3eUKVkoeP3WQzKK1fSzjmIk4R1jkqEGj534n/bK0bWXLPoWKHorrNGU5VF7RNXlDLzT/kRarnVp3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D2bLRNFQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D2bLRNFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29505C4CEF8;
	Sat, 15 Nov 2025 23:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763248177;
	bh=+pinOLeFZxQs93A84yEGNHG0OKL1EHDvdEp9Dg/hWqg=;
	h=From:To:Cc:Subject:Date:From;
	b=D2bLRNFQ1NTesURfGJJmg0hnEVb467FGb6Rjq9OiQImP11WEKuVUzSIP79LQYF1Xx
	 Ry9+p9ZBe3jQfSpvJz+TBw6Kr+aS6BIrSzfqDmumYytOY7/uPTN7ELkA9zT+fOOCO3
	 YAOait1FUwlluCBPNTsdT6Cm1KFgxilSwTju3Pt/NBz3Z9RTanP+1R3PuAhBMbhNjv
	 VArReW/EjDKVMVvHD7jbuI1KaIzRH3nVfPbOgcY8oCy8Ym8IGVAGWvxahs034ZdTcD
	 H0OY7yCe1lLXDwBiR14oA9MiaNFUkFd4jYdeczujFJXBr5uEqZwqdjlTiJdfGgqXab
	 uw+AxYsl+EBDA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Colin Ian King <coking@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 0/2] crypto: Fix memcpy_sglist()
Date: Sat, 15 Nov 2025 15:08:15 -0800
Message-ID: <20251115230817.26070-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series rewrites memcpy_sglist() to fix the bug where it called
functions that could fail and ignored errors.

This series is targeting crypto/master.

Changed in v2:
    - Don't try to support arbitrary overlaps
    - Use memcpy_page()

Eric Biggers (2):
  crypto: scatterwalk - Fix memcpy_sglist() to always succeed
  Revert "crypto: scatterwalk - Move skcipher walk and use it for
    memcpy_sglist"

 crypto/scatterwalk.c               | 345 +++++++----------------------
 crypto/skcipher.c                  | 261 +++++++++++++++++++++-
 include/crypto/algapi.h            |  12 +
 include/crypto/internal/skcipher.h |  48 +++-
 include/crypto/scatterwalk.h       | 117 +++-------
 5 files changed, 431 insertions(+), 352 deletions(-)


base-commit: 59b0afd01b2ce353ab422ea9c8375b03db313a21
-- 
2.51.2

