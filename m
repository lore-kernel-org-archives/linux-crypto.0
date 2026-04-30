Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2115739B974;
	Thu, 30 Apr 2026 07:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777532614; cv=none; b=ErrA9rLgLndq2HtB3un/mHmtYq6PtXGze8yT6KGSioABpeK14Lu1qEYk/g8SShDNZFqH0w6gnyLjUJab/Br11V6s2qj5fVpjzPRUVRhiRmHCiVYaY61/cDva+e8WH42PrzAEB7VfsOc3BBok+9a/7eBxhdMjlSugHSefS2EGWo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777532614; c=relaxed/simple;
	bh=cUMrQAIr1rwOn7Nd+3RxgyIqxbRhhrPFoeZpH6q5AoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bAPxrcYPqBr8k8Hnstq1hGQ/tABOFnFwWD+TRBdSbSX4A/sWNF2LDE3SlX9WBaZBOs8zSgZiE5w44EmuXDv98XVKZW/8+MEfg6WVqlA5o5+gor6RMhYmvgMbSrq9XCwgDDeb/bYS69OCAkPMvRIltk/rXxZKYY+gziYc0hvzT6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZIPzLJ3E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZIPzLJ3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09E8C2BCC4;
	Thu, 30 Apr 2026 07:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777532614;
	bh=cUMrQAIr1rwOn7Nd+3RxgyIqxbRhhrPFoeZpH6q5AoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZIPzLJ3E/1fR8OxYHPgNfLSAdRZxqV3JhDLwH/wPayKerid4ZIHbKPuWMQJRCHlq5
	 KP5qzGugVxlMPAxYACZPXf+Ob6vlUoTAy+goIeg3OK6m6vrgn6gcqsViJysBlasz5f
	 cOWmJqwwBiUlgzHLMUZy4gQ68j+XV/9qu6iEnLXxW29rfR0k+g8LyZDi5PntNTZ2A5
	 qnZ/yGmNsE9VnLU6nWlxVWWCM2+d7iHG7QlA8ORSwgFmmOE/GAOHj8ek018hJ113RY
	 qN3WL8123M1+65bLI7D7/TU1l1c9PvE0rqbBjAhJlmEirQ0BmK1H/ewaW4q0XSlzvL
	 AXfJRHSJJwGAA==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	syzbot+aa11561819dc42ebbc7c@syzkaller.appspotmail.com,
	Daniel Pouzzner <douzzer@mega.nu>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.10 10/10] crypto: algif_aead - Fix minimum RX size check for decryption
Date: Thu, 30 Apr 2026 00:01:28 -0700
Message-ID: <20260430070128.219863-11-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430070128.219863-1-ebiggers@kernel.org>
References: <20260430070128.219863-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Herbert Xu <herbert@gondor.apana.org.au>

commit 3d14bd48e3a77091cbce637a12c2ae31b4a1687c upstream.

The check for the minimum receive buffer size did not take the
tag size into account during decryption.  Fix this by adding the
required extra length.

Reported-by: syzbot+aa11561819dc42ebbc7c@syzkaller.appspotmail.com
Reported-by: Daniel Pouzzner <douzzer@mega.nu>
Fixes: d887c52d6ae4 ("crypto: algif_aead - overhaul memory management")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/algif_aead.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 24e77f4968a6..4a285994d106 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -148,11 +148,11 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	 * of the input data.
 	 */
 	if (usedpages < outlen) {
 		size_t less = outlen - usedpages;
 
-		if (used < less) {
+		if (used < less + (ctx->enc ? 0 : as)) {
 			err = -EINVAL;
 			goto free;
 		}
 		used -= less;
 		outlen -= less;
-- 
2.54.0

