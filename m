Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DEE1CDFAE
	for <linux-crypto@vger.kernel.org>; Sun,  5 Jan 2025 19:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736105697; cv=none; b=ndq7OtU+SHYChPhRjOLLSlkAgpsApW1sVXC7NzSzTUpIBVlh7n/JnBacDM7K3NjqR/aTeHHim0675tZzI/S7mEHliXIMlV5mcIW61lZz336g8OmmW9aUWYAZrE82a/JTnyK8Blevzx7MD4QGXvKvrJfcPybnZrlB9wqxIIu4Wk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736105697; c=relaxed/simple;
	bh=gaMOcbKZNVJXlRF5msh3AmHXHZVVwOpWrFZVmfdFAG8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nW42hAM4GBII+HQ/sZlsE1ZuWSGNMU8cXSmwl7ThNnghMAszHFeTy9nVAZ8TMozW+cOIcAut5dFmJb4Cx3C7XebOypu7xxPagbNlU4mkYhE0DEjt3K9WDYaxtrrsWN9Qq6pULLIUG84cp0XE44KS/5qaWJYl82PWux7k0btSI1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nBTSjf9U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nBTSjf9U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18DBFC4CEE0
	for <linux-crypto@vger.kernel.org>; Sun,  5 Jan 2025 19:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736105697;
	bh=gaMOcbKZNVJXlRF5msh3AmHXHZVVwOpWrFZVmfdFAG8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=nBTSjf9U67DTDQmSmBBpwT/XFsg3iUM/2c8L9E6HrhiE5m4UrJgSxLlRszb1xybmw
	 b2lUV60s59rw4BgKWIYKoefj7Q0OQ2w6H/6fK6vtXbxVgYwRMcYlWocec3fwPXWirB
	 0Q9EDKDfFUSlG7X0TBXITR4EwiAUX9HLa2aYs742WbyDnkqOrzx8+Rq4goTdKCUYxP
	 tSK7QBE6fSdDDxkVtmgNJsy3J8uiHxClKhxJsICsrvTvfBQ05T7a1YcIkudf3Pf3jn
	 zTPStg3nbh/K1VL2h8LGZsEdh2o1qKNhNeAh1jJ/tgMPnXvx/Hi82yNTMjFSyLTm5v
	 gmHOnMMdrvC1A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH v3 8/8] crypto: skcipher - call cond_resched() directly
Date: Sun,  5 Jan 2025 11:34:16 -0800
Message-ID: <20250105193416.36537-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250105193416.36537-1-ebiggers@kernel.org>
References: <20250105193416.36537-1-ebiggers@kernel.org>
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
index 6b62d816f08d..a9eb2dcf2898 100644
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

