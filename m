Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9311EE7D3
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734772291; cv=none; b=Xk+hbuYjzKWNR1yV86bb9VQJDcymx3ZhA/PiX1uxzc7x4MYjDJJQuSNnORufKYK0uGKGULcOwyF8SluGzvr1jK6Q5X7yfHjHLTt6biP6OVn+ylseVi2CAqspIewo9xPbTSCdpPZlmpQa0ptDQ2SEeZs90ze0W105+E9ZF/AjxuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734772291; c=relaxed/simple;
	bh=l9HLRzTyaTzJjaI3UCqrNcL/jvjXdUpirL97KFLMmiQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shjoHq5ka8xd3sbCsGLl33nLilRODNgRQlwBINN5Ybe08XedH0X6OnHbF723J4ycIXUd+eIYwWX+yhNx24hcrfmU3av1w1xX/XNIvOdmkx8KnQtTu/A3yVePZxJ8y9b8HeZv0Ly/reRTDcYKB0oZ7cIJeGknaHyMwY8PJrpcJsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lDRT8cSW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lDRT8cSW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654C6C4CEDD
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734772291;
	bh=l9HLRzTyaTzJjaI3UCqrNcL/jvjXdUpirL97KFLMmiQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=lDRT8cSWLrJs/VwBKyzrNwVsw7xvrFhtb6YT4HrJBvfOA2L1Z2SQ6QrrILCMa6q0P
	 HHmbMxoD37gREd7ywK63dQyXrO0v7d3JaCrIshVCoYGcXljCwnnAEZWiUy1Hbrm5Zz
	 Df0lZugAx4KiKEIbTj60qQWEppp9ds65P5BkkxuBPPm5PbBQjWdih1cZ1fjG26EBGi
	 ba9t584Windn4gj/PPLZHIC+XDqmGA5QrWqyf3X6ZQAH0ZHXSYdf/DLChdFa0zMWqW
	 kpMSof04D2ENFErN1IYa5GmCbGKUeYSGF0FsCm/qNJ41b8iJC7NBS7Bm3WZvqGvPOe
	 1gT6mSHBZPjYg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 03/29] crypto: skcipher - remove redundant clamping to page size
Date: Sat, 21 Dec 2024 01:10:30 -0800
Message-ID: <20241221091056.282098-4-ebiggers@kernel.org>
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

