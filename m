Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAC91BDDF;
	Mon, 30 Dec 2024 00:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735517760; cv=none; b=Vs5KURalkVpe3WibTQVXds7ALK7onBfhSE5vxIHRuFKGf8uX4k0DMD4sam7SisEy/rJoDgxC6Jkfe2Gzg6pcVYETBzuB7zzKD6mrzNGxtTO37JTXcBFVHpNUGUrrqYd8xmC6TV4oZqNY+q5zBl5+T/wrL7EhpDg4ohFu8Bypm2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735517760; c=relaxed/simple;
	bh=l9HLRzTyaTzJjaI3UCqrNcL/jvjXdUpirL97KFLMmiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LF3efJu+bOxsZyHDVNpkBeHv9kSvoJE5KOO/qwcCXC03QMA7qNdqUxqHttSx1P/R1xcRbMAI5UR0aS5LFV9f6nRCCUV8wzZHOrebaJh7IdzFjzII6ubD7RkRODUqUwi5cg3sFq0dSPFjDbFXHyqXKQ5Yn6emeVakGyalGTOG9SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B7Rk1Q3U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B7Rk1Q3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84A3C4CEDC;
	Mon, 30 Dec 2024 00:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735517760;
	bh=l9HLRzTyaTzJjaI3UCqrNcL/jvjXdUpirL97KFLMmiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B7Rk1Q3U5IxG2wqwIkpH2UiBhk8uFIf4ZAU3VhFPR+q0GcuAx94/MQ0Op5pc5p9Ze
	 DZeWemTcHgeheZrIxk5238wUwh47YKIQ6rbqIaReCxsztChlx5ZGcCGcr70VERevcS
	 +kJn0AYqY1e9SFFyiDW0VN76GVxb62YnWCchb7QzbFd87b9NtzkWZpNzbEZPVp9NqE
	 zfenIVT6st7zZDKQLqDXbZaGGhzfibUbYTojkOinu301+3mLNqYyjPqXrxDGtE06g+
	 yIKkoY7CwxKp8pjvoH8J9CdUWci6S2VCTfrOZDhu+gWkmRqIw69MJ1TkgWRm7cDfYV
	 U8c/ViwzEK+tg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 03/29] crypto: skcipher - remove redundant clamping to page size
Date: Sun, 29 Dec 2024 16:13:52 -0800
Message-ID: <20241230001418.74739-4-ebiggers@kernel.org>
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

