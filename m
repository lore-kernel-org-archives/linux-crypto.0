Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA9518EB0;
	Mon, 30 Dec 2024 00:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735517760; cv=none; b=i7PZaUsd6EV60wDV6kUX7+rTBty/myUFvlGAslSxvG3hJ+xIF5MGdygMRhT0sCLm5Il2SkESQsPR38wLD2PvYG6iiagMRJ4xJSrEIbmOtQqIR46qKMAaJbcxnOc3wmfjjSCBi9uESY/JDIknToZajDm7adA/Q4oBBZHv9bwfqEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735517760; c=relaxed/simple;
	bh=7uVm3CYoqa7+cTgqCe8InwCLob5UXrzsedA8gOn7b/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UMzVNbetNR8/FuUolU4Q70VK6Vgboi3LKgZ4eABWswtSO2BiIFbqqQChcpdT9lYtm37AIE61ML90LVwnSdzJPo1vBIVP76eJNpPx1O4oqH4srSFlpWw2N1cI6IblKGgriOKIJpYvcEWbw886s+meMWEQPf8wCcVGipkc+Ht2mqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=emALD3YB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="emALD3YB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C31C4CEDD;
	Mon, 30 Dec 2024 00:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735517760;
	bh=7uVm3CYoqa7+cTgqCe8InwCLob5UXrzsedA8gOn7b/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=emALD3YB1G99ePmpruIuIykcrGHRoLeNnePWIthGG5XfZMHencEMweAYsuv1Eb/VY
	 kRX+xXxkrhmAtDE6+HzyZdxDsSvhCg/Og3egnfeQtOihHODmxJap8ay0N9EOfJl+xK
	 X6v5gi3tYb40L6uwfT64na66vsa0fODtzsVadrNaWJGzEU2w1S4yL8CY3wVAgv5UGN
	 gb0AiJ3NTeZ5XHOzkhca9bkcZ12dgVEQY621eSd9YUpIO8Gx30Dfih6iFNsbATaU56
	 JblOuvnIG2ppcNxlLnQLzi+V12CTkxJKNBpHDnoqkgvrFW/lURjjc5JPi+l9OjzEuB
	 7krS+qPes5mCA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 04/29] crypto: skcipher - remove redundant check for SKCIPHER_WALK_SLOW
Date: Sun, 29 Dec 2024 16:13:53 -0800
Message-ID: <20241230001418.74739-5-ebiggers@kernel.org>
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

In skcipher_walk_done(), remove the check for SKCIPHER_WALK_SLOW because
it is always true.  All other flags (and lack thereof) were checked
earlier in the function, leaving SKCIPHER_WALK_SLOW as the only
remaining possibility.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/skcipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index c627e267b125..98606def1bf9 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -118,11 +118,11 @@ int skcipher_walk_done(struct skcipher_walk *walk, int res)
 		goto unmap_src;
 	} else if (walk->flags & SKCIPHER_WALK_COPY) {
 		skcipher_map_dst(walk);
 		memcpy(walk->dst.virt.addr, walk->page, n);
 		skcipher_unmap_dst(walk);
-	} else if (unlikely(walk->flags & SKCIPHER_WALK_SLOW)) {
+	} else { /* SKCIPHER_WALK_SLOW */
 		if (res > 0) {
 			/*
 			 * Didn't process all bytes.  Either the algorithm is
 			 * broken, or this was the last step and it turned out
 			 * the message wasn't evenly divisible into blocks but
-- 
2.47.1

