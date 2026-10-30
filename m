Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793379850;
	b=3vvaApPCVdQwikydNlONejAQkR4cP4IqDa0v0YQ0l/+z/3GTkF5icjGbQ53PUym45pom
	 /Dp+zSCymWBv7qS1ejoEp9KU3K/Xs9OjfW3rr2SP1voqhSLi8C0Fzk3vm0U/9yCWakmz5
	 RzGtUhmqmhikmcOFSJpCgOnatlhGs60VEB6FUML9uhSL5O5bchBAkQCBuEd59+whHu0LH
	 14fh2BK1c6SR7e3H5q9g+GOLGsOfvVbeAVyhsmopoNVmQ2Vmp6W9pCZV6mDoMZD9cDwm0
	 WyHFbt5Ql2+jOOAV1fiYEBsexjVEyjm7OdRW/UgWSUIwAoifs3pUaMqFeDEm3v0Sddw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793379850;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+34ks+hrX+FFlPYQetQftjRSiKRJt49ZVAdtANlFkJY=;
	b=KmMrptrUOwZzvi0vJNazUrFBkrcYV3oEkQcXoE+6aPVVzyES4k8hEC5iO08Jjm8yZidw
	 tHU3QtCaM4UaDzzyIWO3ZbMc8Hn/TQKOllTzF+PPZkVK8q+MIPx5D3KLOvIHrLocIVUyD
	 t36x2WaPMsgeWQLVJoaubIao1lxPtPbTxkc7U2UDnhZ3viDOpWCcP2QJ/Hfadg0WA6stj
	 0Zgo7HNYAwbNvGLw0SsixkQSBv95/I7Oz4UjVJwJW84NsPP05YLYWOI8mo81gG95HfeFS
	 /UL8VxYBZfnfGjQMwUr6lBjVpeNC3hz+VbKznYITqUVBBXVx3I/omr0J4G2jMqnbI5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QWPXpFav;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4506F606A31C;
	Fri, 30 Oct 2026 17:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QWPXpFav
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBA471F000C1;
	Fri, 30 Oct 2026 17:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793379850;
	bh=+34ks+hrX+FFlPYQetQftjRSiKRJt49ZVAdtANlFkJY=;
	h=From:To:Cc:Subject:Date;
	b=QWPXpFavuM+yqkk7SUhJ+BxD+FebIEOus7ZAjeu33cqGQpad5zaVaNsjSb4Zhvtlp
	 HK7qCsmH0z974sEXA3p96FRx3w5RN7AYwgDWZRVdI8ySe+j7EY/dbKMK6hATpDJeZJ
	 mJL/bCmBZ2GP37BzTj0J3p/T9TbYiTvQ9eQSdsaLavHuSxwJSWqUm7ve/2LdcAAXnS
	 6rbxHBkoHF0x0dH9TpGVT70lqR47J6J8IjuwWVn8eIxXuOCP41HgFUYohnGUDQXkar
	 bGIrs1/d+UG04s605fwriKeRuFrUW3ETaLJNZ7dZ44ZdCQOwV4TwQJjU/GhYHTwi2C
	 ExibH0t3j/Xww==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.1 0/3] Fix incorrect backports
Date: Fri, 30 Oct 2026 10:02:17 -0700
Message-ID: <20261030170220.120015-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Eric Biggers (2):
  Revert "crypto: jitterentropy - replace long-held spinlock with mutex"
  Revert "crypto: jitter - replace LFSR with SHA3-256"

Haixin Xu (1):
  crypto: jitterentropy - replace long-held spinlock with mutex

 crypto/Kconfig               |   1 -
 crypto/jitterentropy-kcapi.c | 182 ++++-------------------------------
 crypto/jitterentropy.c       | 145 +++++++++++++++++++---------
 crypto/jitterentropy.h       |  10 +-
 4 files changed, 120 insertions(+), 218 deletions(-)


base-commit: 08889840163ebcdb7e24bf7ec311bc2e6fc3aaea
-- 
2.56.0

