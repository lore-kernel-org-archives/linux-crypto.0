Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942541B4132
	for <linux-crypto@vger.kernel.org>; Sun,  5 Jan 2025 19:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736105696; cv=none; b=NrmsMTEXh9/y7RQYDNfAuODKaOZ/n+R2eM92mJOKnejiuZWV0qGN/jJxkcszMmkAcbDa8i9u8l3M9IR9j9qMhXt89vv6KmnoA4Q1tC9aX6my29YPqtfkoW+eKrUzt9woPrak/k8hlHfuco83EuA8qgj4YOM4tcmUbR0skhUZ3Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736105696; c=relaxed/simple;
	bh=l9HLRzTyaTzJjaI3UCqrNcL/jvjXdUpirL97KFLMmiQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6rB+A6lT/facC+04E5hXCGu/fQWTlwmrInwiQ6f/98nv+TTh9aigWC1OYgASRl5UctfI1DYVnSJsAE5FKSYVuuhrIYhqO+S7C3V4WKRm325k0dduIbkGUO/VQkBxiGIwBruOZJGQLcLKwWb2esUQ9F6KeUAZD6PP6mfUIxyBfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dFdC0djC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dFdC0djC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDE9C4CEE0
	for <linux-crypto@vger.kernel.org>; Sun,  5 Jan 2025 19:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736105696;
	bh=l9HLRzTyaTzJjaI3UCqrNcL/jvjXdUpirL97KFLMmiQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=dFdC0djCLPdRewWv5b+jEMW03Fz/+ejIq2IMWL6yT2XMngBhWI8U1QQCEJztt929s
	 MDcEFsEqYZmlkNK20laTU47Y/mZ1G024yQ/NGVvbNBgrokzqHrlLUcLdm6ozZvujY5
	 0o1rtF/VJLeRRTxZ2o5Fsiin3jQL9wwhsAMzjD6oFhA67DjN/mS/eSmC3oQ4VBwfGr
	 tvW5JQsqW2cLV16DlhyDit7MrVW07ADKC4S8sLyku/3OtwpgismBKsOlJAmURF/T4k
	 xDxVxg8t2/e92CSGBC47ql9EyYg1ZqxCEkp4XLRnmKHd6CXMKEjDyC5pq0WTGuWNon
	 CFI4XTpg7lGww==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH v3 3/8] crypto: skcipher - remove redundant clamping to page size
Date: Sun,  5 Jan 2025 11:34:11 -0800
Message-ID: <20250105193416.36537-4-ebiggers@kernel.org>
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

In the case where skcipher_walk_next() allocates a bounce page, that
page by definition has size PAGE_SIZE.  The number of bytes to copy 'n'
is guaranteed to fit in it, since earlier in the function it was clamped
to be at most a page.  Therefore remove the unnecessary logic that tried
to clamp 'n' again to fit in the bounce page.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/skcipher.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 887cbce8f78d..c627e267b125 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -248,28 +248,24 @@ static int skcipher_walk_next(struct skcipher_walk *walk)
 			return skcipher_walk_done(walk, -EINVAL);
 
 slow_path:
 		return skcipher_next_slow(walk, bsize);
 	}
+	walk->nbytes = n;
 
 	if (unlikely((walk->in.offset | walk->out.offset) & walk->alignmask)) {
 		if (!walk->page) {
 			gfp_t gfp = skcipher_walk_gfp(walk);
 
 			walk->page = (void *)__get_free_page(gfp);
 			if (!walk->page)
 				goto slow_path;
 		}
-
-		walk->nbytes = min_t(unsigned, n,
-				     PAGE_SIZE - offset_in_page(walk->page));
 		walk->flags |= SKCIPHER_WALK_COPY;
 		return skcipher_next_copy(walk);
 	}
 
-	walk->nbytes = n;
-
 	return skcipher_next_fast(walk);
 }
 
 static int skcipher_copy_iv(struct skcipher_walk *walk)
 {
-- 
2.47.1

