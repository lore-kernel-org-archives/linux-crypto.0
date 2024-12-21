Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA04B1F190A
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734772292; cv=none; b=Sjja6dqiRQ3jpivfO1A930CoDkVzs77bn4wptIRwERm19HPmQe6JaA4B6dkB2gHumayUG+b/3EYOQxjaeUKzmAV+ba2g4fS2mazxgEdhLNocVHLCzR/Z6iCsiI+2Xb60bzaZcbIrOc0c7NlN/SlQYcmT2QlZgMigIcdkia5aAKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734772292; c=relaxed/simple;
	bh=2nhmId8pbA4hd6z9AgDYhLqfIP1ELc8P6LVbb7WGcqw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vDskzeM4/Q24PeIqp1tDXpUgnxtVuuNSRTs4ZjrcA8qFduP8/dEK5kyS9uTFLdsz1pyjzMw3Apg/tULYye4rPA8irEhGPhtAluJJficl9wje2TpnHF6kEV2nXY78dVMT+GvS3gdK0/y1Tf0NqxIjG3r5JvuG3HvMLipeCfVSwyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RMMOUh+n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RMMOUh+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503F2C4CED4
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734772292;
	bh=2nhmId8pbA4hd6z9AgDYhLqfIP1ELc8P6LVbb7WGcqw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=RMMOUh+npTSxrX4x6CngGwaLEw3dhtG2tAaaeLLIsWk7Hyn/8BzmFHUMcGKV9wwwX
	 oLwHSapa9R5GmyBciACQxf1/wGPiENP/8hSNKRUPpMEB3ssGfe/qf5lihwl0EnVGcI
	 lkjexImPCFrllbwkp7FOhAmkwNCnsO9s8cYEZT1N2i92MU4c0kcVyNIGLoR3mXQn3G
	 eaEdqBEeuYceX77gNcZfJL6xKkh1bKyM2aqf1ZY159QcHp3fpe7loXDeNh4v2oYSgL
	 khxkyI9UNZJmSnnyFgY1cvuQkW+aOJiF8NMhqLRT7nASB93OjW9TD+qsmQi8ByXvou
	 +BnO+lk+DuR4g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 08/29] crypto: skcipher - call cond_resched() directly
Date: Sat, 21 Dec 2024 01:10:35 -0800
Message-ID: <20241221091056.282098-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241221091056.282098-1-ebiggers@kernel.org>
References: <20241221091056.282098-1-ebiggers@kernel.org>
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

