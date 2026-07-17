Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEED217BED0;
	Fri, 17 Jul 2026 02:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784256371; cv=none; b=TUEzXkluGfhQxLxgNnMHfkWq6ginQWpm7rwRMuqag1hCRXS31jrR9uYKuDouY++TI0Rlc/MZv2acCWiKAqfkTzXGpaZ+yImwthTsmZZ+TZ03OV+TlFIxPteNUxbdFBYDKkKkN/w3E1J/qCh2eCV0mNY1JKz0MlegBgHi7w/SgOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784256371; c=relaxed/simple;
	bh=Uc6tPL40TXXmZZR9CjCKOs7PopY39nssFNhHzdNdDAE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IWRGYok8TX+uGykwr1RMyQHTyNk0wXAHUIvLudtZ+D6Lj0TrkaxpzU9UNMZIOVNrz4yYBwyQ+3VN5pk1hDx1gfxSH+AMYPlrcfQZ4+69oAK/QyqR0K3ZO1XC5gY0YLxVSmxuAkd4L+a+vbnp7oq0ZVcqZQnlkApAxk2/97LlfKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UrSnIZoC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UrSnIZoC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72AAA1F000E9;
	Fri, 17 Jul 2026 02:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784256370;
	bh=fOvHHw3n97SUlAqvXqIhB1vz79abbW269vIWOc4MQ2Y=;
	h=From:To:Cc:Subject:Date;
	b=UrSnIZoCdaAF6xnGHla530707ZVTmPR2bTcLfVC8Kso1+D6Fasj54im3ZZEQeu7c+
	 oIwNCk7wKFwpV8dcLzc9ZosetPPTahlGfin2kwEuxcKwP27kfjzIRGgw+IZKz+gWPn
	 pVdz7JWoa5+KBBJwJIw/kzje3T+miGABOD9xOWIEIRcBKk2G+bpzA0QQ5EPuVipqHH
	 krZWjIafAndo3QTKHm4cJSmDU25TkvQZyg/GEltXfqGh8B2n/r3DkRmbWJFi8xufCS
	 QLQ1yAkbHJOx6GwuwWzqE9nvVtX2hoDSV5N/Ue5lICX4GRrvu+JvgdPYkBUrEJB+Id
	 P0TEGHAps1u1g==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.12,6.6,6.1,5.15 0/2] crypto4xx stable backports
Date: Thu, 16 Jul 2026 19:44:01 -0700
Message-ID: <20260717024403.87052-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series backports "crypto: crypto4xx - Remove ahash-related code" in
order to make "crypto: crypto4xx - Remove insecure and unused rng_alg"
cherry-pick more cleanly.  Then it backports that commit too.

Eric Biggers (1):
  crypto: crypto4xx - Remove insecure and unused rng_alg

Herbert Xu (1):
  crypto: crypto4xx - Remove ahash-related code

 drivers/crypto/amcc/crypto4xx_alg.c     | 106 -------------------
 drivers/crypto/amcc/crypto4xx_core.c    | 130 +-----------------------
 drivers/crypto/amcc/crypto4xx_core.h    |  11 --
 drivers/crypto/amcc/crypto4xx_reg_def.h |  11 --
 4 files changed, 1 insertion(+), 257 deletions(-)


base-commit: 296aabce459470a4c1b68ffd0c0c0920e563aaad
-- 
2.55.0

