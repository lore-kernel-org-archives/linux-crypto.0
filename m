Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEC486AE3;
	Mon, 30 Dec 2024 00:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735517761; cv=none; b=k2/2d+t6pc3yynNqH4iwp9xDzhxhhDP5CGqIcn0RZf2bo5KbDsY6HnUrIx0hAcTX/zlyEWNvFnHlKVz1+sFru7VpUTjYUMK/xaOo3mZ9aQeoqqveV7JQnWvFh7yQlhZHubKUTtbnQsx9KdQVcd6uNnGeHwV61ZKRTTHQU9tSWek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735517761; c=relaxed/simple;
	bh=2nhmId8pbA4hd6z9AgDYhLqfIP1ELc8P6LVbb7WGcqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8ZCqVbmpDsERb0tRi/b2ocDDVuTGwxamtKJfBcZQpXVgkt4D2HBoJRmEAC7ZTYWo3i6grtsLJQT9Jltrc5sPzzNzjEhgWjjt4gsducqrIddEtwUGzhRhlmuRyIcaUBW1XKazpHUejnehRr6i1QajHvGi9pBOQGCIGxNreFDLAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZMFkLnqR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZMFkLnqR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3CEC4CEF1;
	Mon, 30 Dec 2024 00:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735517761;
	bh=2nhmId8pbA4hd6z9AgDYhLqfIP1ELc8P6LVbb7WGcqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZMFkLnqRtA04wVaHvzFSb6Gmt7tuCWYk6txsA7zvAlBLdQWt7M/lTNI1Pd1JSpzIx
	 bleUScTLiFxDqucG1nRoqFi6fskuYKpxUXtuyv2GqmEzg6zZMtAlO4Gtd0qH/V9/S0
	 UumW5V9vZ7lj0Zyf8pker73f1dpmrFVfnCtKKVk1YMBrbFfTMTRDTgFdZgD9ev3pvg
	 BtNRFoxVJljicnRWnljKoWn4bK/9zmszf6hSUZpEqbH2LNgnQZsJEWkaiHMu0v/kGW
	 ocS08eH6t3kRx75WwOyCTS74IQdSlPJXp/CS7u+ljqaaL0vVCHELZQbuBCIKhz82PE
	 KKsxc/tFOY5QA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 08/29] crypto: skcipher - call cond_resched() directly
Date: Sun, 29 Dec 2024 16:13:57 -0800
Message-ID: <20241230001418.74739-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230001418.74739-1-ebiggers@kernel.org>
References: <20241230001418.74739-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

In skcipher_walk_done(), instead of calling crypto_yield() which
requires a translation between flags, just call cond_resched() directly.
This has the same effect.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/skcipher.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 7ef2e4ddf07a..441e1d254d36 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -144,12 +144,12 @@ int skcipher_walk_done(struct skcipher_walk *walk, int res)
 	scatterwalk_advance(&walk->out, n);
 	scatterwalk_done(&walk->in, 0, total);
 	scatterwalk_done(&walk->out, 1, total);
 
 	if (total) {
-		crypto_yield(walk->flags & SKCIPHER_WALK_SLEEP ?
-			     CRYPTO_TFM_REQ_MAY_SLEEP : 0);
+		if (walk->flags & SKCIPHER_WALK_SLEEP)
+			cond_resched();
 		walk->flags &= ~(SKCIPHER_WALK_SLOW | SKCIPHER_WALK_COPY |
 				 SKCIPHER_WALK_DIFF);
 		return skcipher_walk_next(walk);
 	}
 
-- 
2.47.1

