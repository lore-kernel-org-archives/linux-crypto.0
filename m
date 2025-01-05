Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B1018C02E
	for <linux-crypto@vger.kernel.org>; Sun,  5 Jan 2025 19:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736105696; cv=none; b=L8Zui6vSVzsrTPy+ooqxCpa7UpZ9ek6nV2GH4Oc/kpXrBaZlImrEDIfp/fXoU5ftJjGRK5sS7DebjVbg1HNBBZU1QVM9wsDzaUC9jwLfLIMwdwxvyBMU4pMB42SNmwRi5wLNP/ZWU7aLOtA9zXJtLBft+HpfFxciZIb1QhnVYbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736105696; c=relaxed/simple;
	bh=7uVm3CYoqa7+cTgqCe8InwCLob5UXrzsedA8gOn7b/Y=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ATO+2OBjj4IClj6nmbxEfCe3yxbTK878mR9aHWMrSMdDxlNYZ9De+ZHWKRUEzaxBRs3juDS8IgXFHbD2wPOOmaI/ef1hffruozVp8pHm9+bFKtq+RDYrM4jyzuM3gu8JZwVcddgSX53AhUmI5ObadUB8jqeF/8ftcUH12I3N6nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s14MzxkF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s14MzxkF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CFCBC4CEE2
	for <linux-crypto@vger.kernel.org>; Sun,  5 Jan 2025 19:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736105696;
	bh=7uVm3CYoqa7+cTgqCe8InwCLob5UXrzsedA8gOn7b/Y=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=s14MzxkFDwdMSQLaOWGQ5ncexJNgNlXpqi9zSHDWE0qL7GJlmeXUMLTVnarbihps7
	 E2nIwZShpPOcvt7bfYBsvOJp/QebX7ma3KuB2Ku6F5OdEnCvmfzCXa9+HRY0T+BiLY
	 J86XDx5gRTK396hVQGFQJ/WjrCoGdgFJa2BUk1xB3utfrFLqE8oSV0lnPQeMRmaPAX
	 bjTTFW9TmYM7aBuhS+bjkg5uh+bfWMZUiC6TsTeARDoqd9j1c+G7iAxU3vtv69YCLl
	 3bkIN/gh8RttyDt9+zfuYiECZhYhFGG0ZODmu+YxZhEgZVSU8cA+uSzFNyHQ48LSkk
	 +BZDPvkX3pHJg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH v3 4/8] crypto: skcipher - remove redundant check for SKCIPHER_WALK_SLOW
Date: Sun,  5 Jan 2025 11:34:12 -0800
Message-ID: <20250105193416.36537-5-ebiggers@kernel.org>
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

