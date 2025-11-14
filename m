Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F423A221FB2;
	Fri, 14 Nov 2025 22:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763161192; cv=none; b=oUxTdrazKMxJhBdwHFxiaztoq0nAHlbAeaedeGrdfmBFMm/Gf0VF3I29IRvn4x/s8zl1SVErD0/7Jv3BenIisCHzIKRoU+jHXAw9m//Npjor83iiFF7OPyZvzskxiEq/Mu+XoKw7VlvT72d2GGU3MJU3iza9Dx2zCuZawYpauXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763161192; c=relaxed/simple;
	bh=IHtQuLGuiQ9vhLqFWU0n46/BSGAL6m3EPzW45EVGP8A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TIpvHeG8ZMNgmLucfZTWbQm2S3DyqxgFyYxMiBE7qaogLdAAPxs2AhqWLh2ydr12KJLrwd05aX79UmcJuaS9Zf7Z4Hwcynw7sFTtA0unFMxPx9skJUonhPhFQnBeqMnmZ+M0VS3gpRL6Fo6YOdHQTERNgQFhf/TwTVRwHBNiETg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oiKMO9Tb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oiKMO9Tb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF2AC4CEF1;
	Fri, 14 Nov 2025 22:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763161191;
	bh=IHtQuLGuiQ9vhLqFWU0n46/BSGAL6m3EPzW45EVGP8A=;
	h=From:To:Cc:Subject:Date:From;
	b=oiKMO9TbffF81/726sBorGGxRN36hUhGygco5Kz0goA63Xad2QeiE00Z0ypLHLZ9U
	 WrNY5oApt37uXBpjjz7g6jpd98nuBF8rTMoBbXwXswJzSBxTNUSlhUjI4YgtM0brj6
	 1Jm20zPb9fYfQ8MJwYsIeAXUsq1/MIy28UaJtaj9L218BJxMUMu3c3nSBZ3PAHi1DF
	 Us8tnawatD/txA1d0JU6to/Pbis5ySWnk76jAliCeBvilqa7rUH9G2Z9fkTd+XqyGZ
	 r8perk0FqosFbGxbnukfXubaOc/SNEZbU3KqDB1I7xivmstyHuFnYeJqmpg/QOCEi1
	 mWyfEJZlAZfNw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Colin Ian King <coking@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/2] crypto: Fix memcpy_sglist()
Date: Fri, 14 Nov 2025 14:58:49 -0800
Message-ID: <20251114225851.324143-1-ebiggers@kernel.org>
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

Eric Biggers (2):
  crypto: scatterwalk - Fix memcpy_sglist() to always succeed
  Revert "crypto: scatterwalk - Move skcipher walk and use it for
    memcpy_sglist"

 crypto/scatterwalk.c               | 351 ++++++++---------------------
 crypto/skcipher.c                  | 261 ++++++++++++++++++++-
 include/crypto/algapi.h            |  12 +
 include/crypto/internal/skcipher.h |  48 +++-
 include/crypto/scatterwalk.h       | 117 +++-------
 5 files changed, 437 insertions(+), 352 deletions(-)


base-commit: 59b0afd01b2ce353ab422ea9c8375b03db313a21
-- 
2.51.2

