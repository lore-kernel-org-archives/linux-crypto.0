Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B9C1EE7DD
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734772291; cv=none; b=KQ8+TBPY19FfI+qUiDYP3LRY+vIF7XJZnsccMRVbZMa1nkRdnmMiaeENp0uViYKFZVUrl0XqXtaqZp7vdIN6TTF5ClhROKnX8uOZVgkRFQ/LtVgJCQpyk9XKcGSd0Wk1Ol+NUNmPvmoX+1/KFXbxObASqZCdTgi3Y5sk1gp/J4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734772291; c=relaxed/simple;
	bh=7uVm3CYoqa7+cTgqCe8InwCLob5UXrzsedA8gOn7b/Y=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJO2l1D2y2NgEqYM5kziMF2HXoyrFdSZDRbMoUIFVldo7b+uOk8fNdRLNS6f44bsTfvVt+2g99JpcljdBFdCv1dATcxiDfnOcaWj30fAEqmj3wqHP9h6dGxret3viSlK78wFz/XBiHk74QouUNhWEE5ZRHb7Az5fYswqNZFSIzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aoCPQn3K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aoCPQn3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E32C4CED7
	for <linux-crypto@vger.kernel.org>; Sat, 21 Dec 2024 09:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734772291;
	bh=7uVm3CYoqa7+cTgqCe8InwCLob5UXrzsedA8gOn7b/Y=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=aoCPQn3K836kxPpW9S4MdPSOkVON+qcT10+BB3jK2+QEFc1k9dNFoq1siFeyhakOL
	 TbwQq1kQz/X1RWQVkXK1EvT5PyTvixTD4YbCqUWSpgbU7WCO+kBvyndfV+OM7WxF39
	 TJeuwjoTo6g0oaLayechBR4At8MyTzZg8e6BCsPAuzGgRVi268TSxKvjevilQmTsHe
	 BdFMs63Sv1ONTCEd/MHkuBkQElEd3WK6ruPvCvls7BOvdA/Mx46xq0RU3rJVp0EDv0
	 kTKE2mB+NpF4dJJXFR1p8UAA3STIqkIu1rNOQ0igCS4mqZx2XsmSeIw30Bvi9r/vUE
	 SWKJP/BrwYadA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 04/29] crypto: skcipher - remove redundant check for SKCIPHER_WALK_SLOW
Date: Sat, 21 Dec 2024 01:10:31 -0800
Message-ID: <20241221091056.282098-5-ebiggers@kernel.org>
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

