Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACC11DFE1;
	Sat,  7 Dec 2024 19:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733598327; cv=none; b=Msxj9YXbR/+ScK6CEo181akwN4o0dPp4dfp/vo5grTeg4Ltf0qgiLwKSGMv+nFU64SUPKmRvRcV2wlOBXAgWmTb0usHlrMLfofzY6XgM3L09ThOqB6dj3mFyXWc1P3Ha8iEoC5hffFfkJ/+ocXuJ1/8HBbW7hM0ZN/x5jTQK7lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733598327; c=relaxed/simple;
	bh=CoXQkqHdNRrmU3BZeAsQAt3Z9wYBXxXc65c8Jvvg8fE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PRMzqj74mt0sZs2UbC4hkelaUACC8CWFf7tHfc+TxuV7DsNo6/zz8DClfjblWxaOTOjEp02rak1NfBjIQGkxkcQxPRtZObXymfdsNuTtmW9r9PusEzAWn+sF1rpkb2TMuZwmf2Wh8upzlTw2ohQMhn//snlNUdJBdblavRA7bvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IrxGrJ5r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IrxGrJ5r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A44C4CECD;
	Sat,  7 Dec 2024 19:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733598327;
	bh=CoXQkqHdNRrmU3BZeAsQAt3Z9wYBXxXc65c8Jvvg8fE=;
	h=From:To:Cc:Subject:Date:From;
	b=IrxGrJ5rslsOE4T1+rvn6dtdxRYPAn0ubJ79VVffTQsMRw6x8DG+zXgXJyPWvU8Q3
	 hA5uBQYy0zlAXN/XeV3pJKwS0c2C9rX0z0je0299GFUHeMZmKcPVZHKYpFr6oMQeGA
	 rPsDL9pQvu/NETU9xDnLgGNTi9cVxDeNS5S/FGx7B9NhNmqMcttBv5m2+OVYPflHUs
	 EsvI1PEDxVYIZ3T8/4hfWh6Rw3Iux9lBQthk9IY5WB5j7MVq3wnCQYyd4TaqoH01xa
	 Kb0BoqVqYs8VZYPg5Lm5QQTb7RCMWSHkaC1VlR0pe0Ykxmsf5QZnpLvxA61rEjXBTV
	 A2GTVjq6sRhGw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S . Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] crypto: remove physical address support in skcipher_walk
Date: Sat,  7 Dec 2024 11:05:01 -0800
Message-ID: <20241207190503.53440-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series removes the unnecessary physical address support in
skcipher_walk and the single obsolete driver that was using it.

Eric Biggers (2):
  crypto: drivers - remove Niagara2 SPU driver
  crypto: skcipher - remove support for physical address walks

 crypto/skcipher.c                  |  187 +--
 drivers/crypto/Kconfig             |   17 -
 drivers/crypto/Makefile            |    2 -
 drivers/crypto/n2_asm.S            |   96 --
 drivers/crypto/n2_core.c           | 2168 ----------------------------
 drivers/crypto/n2_core.h           |  232 ---
 include/crypto/internal/skcipher.h |   12 -
 7 files changed, 26 insertions(+), 2688 deletions(-)
 delete mode 100644 drivers/crypto/n2_asm.S
 delete mode 100644 drivers/crypto/n2_core.c
 delete mode 100644 drivers/crypto/n2_core.h


base-commit: b5f217084ab3ddd4bdd03cd437f8e3b7e2d1f5b6
-- 
2.47.1

