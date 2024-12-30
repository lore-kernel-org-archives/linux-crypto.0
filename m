Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B39319D06B;
	Mon, 30 Dec 2024 00:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735517764; cv=none; b=cUzUcElA+q169eMNJnl9uu2VeqVRsxPYlyAW/qK+/K53HjaATTMJ00Qg6unpPA0wV3PzvF1GsSuyPyh/5yaOTXO3nuxYj/R5JtpLc/semJDnmyAaFzM5YxnV00vtMM+an4jnh9h9RPAJDRBsTbIbQUQ7pLodGp2948xGWq3SRx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735517764; c=relaxed/simple;
	bh=gTqiJ83GC+y9ntGuuGLBowL4XoaSaAg3tom8EPVefuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CXTOY+KWfvxDXlbm8uLNemo+cWnH1bZnnkXfs6Yorgtj7cN/XBnE6nvMJ9vhFrQd5704VmO2t/otbUWPd/toZKD75Ub/WKiaYhgQcCqXg7yZDls+KtvPqFvcWG0W7AuDoCJP669uExya0Jiy7NFNvI7v7wKGLEr+87zPCg9nnc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IUdR1nFG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IUdR1nFG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66AD3C4CED1;
	Mon, 30 Dec 2024 00:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735517764;
	bh=gTqiJ83GC+y9ntGuuGLBowL4XoaSaAg3tom8EPVefuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IUdR1nFG3ngakh3NdimrWkCgN4PdE+m133S7ezsBJQzwfeLSp1idebo1Sj5TQBfuf
	 IS0S1ZOxyqFbq7kjdQvuBkFlk/tByoIvo+qP/b6pAb34m8PQucBmP6hKLRaaknPbbr
	 llhwJtck7fOI/JgdBLjQZzE2SlSF5Y6v2Ma9g95AfDpEfkg/1BxzO6E2HnPDYM4MX9
	 fXvl0PnvrvJ6m6urLykmjXd8Mb1dza5s4M6gbcjTI4W/T/B3/klzpRKeXm+W1CFTLW
	 FRK6mucYaxwHxT19nG5D6kQzLWdJWpBJqxEvr/jUvDVui9wGzIIh2jMCIhb9t0iREW
	 IvAiOjk1GwqYA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 16/29] crypto: skcipher - use scatterwalk_start_at_pos()
Date: Sun, 29 Dec 2024 16:14:05 -0800
Message-ID: <20241230001418.74739-17-ebiggers@kernel.org>
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

In skcipher_walk_aead_common(), use scatterwalk_start_at_pos() instead
of a sequence of scatterwalk_start(), scatterwalk_copychunks(..., 2),
and scatterwalk_done().  This is simpler and faster.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/skcipher.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 441e1d254d36..7abafe385fd5 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -355,18 +355,12 @@ static int skcipher_walk_aead_common(struct skcipher_walk *walk,
 		walk->flags = 0;
 
 	if (unlikely(!walk->total))
 		return 0;
 
-	scatterwalk_start(&walk->in, req->src);
-	scatterwalk_start(&walk->out, req->dst);
-
-	scatterwalk_copychunks(NULL, &walk->in, req->assoclen, 2);
-	scatterwalk_copychunks(NULL, &walk->out, req->assoclen, 2);
-
-	scatterwalk_done(&walk->in, 0, walk->total);
-	scatterwalk_done(&walk->out, 0, walk->total);
+	scatterwalk_start_at_pos(&walk->in, req->src, req->assoclen);
+	scatterwalk_start_at_pos(&walk->out, req->dst, req->assoclen);
 
 	walk->blocksize = alg->base.cra_blocksize;
 	walk->stride = alg->chunksize;
 	walk->ivsize = alg->ivsize;
 	walk->alignmask = alg->base.cra_alignmask;
-- 
2.47.1

