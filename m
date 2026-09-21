Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D4A18C933;
	Mon, 21 Sep 2026 06:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789971133; cv=none; b=c9PEQL6rEMIJekDD4FypN5ZosY/JIuM5tyQ5Q+9FgjPtGdGz6rBtRK3ik68C/nayEjmC0xD09ppJBgLvLxKP/tyLtyFx4Q8QM/Zy8nfrB5veEo6qUGbVvi5oPsyxMNRZQXzsjywYVOodoySYx/AvOjWf+BVdwt4ITEFTqQ1Z55c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789971133; c=relaxed/simple;
	bh=PLGfpoBPitfHZC5UoCH5L0QaKB+D/mefyUS3nk0rEkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/hORVzzPZZ7JCNMNHrVMrLwSsnqaDQDvHctVNkNLsgmbqWpMFIWauqCQO1FlIM8EIZQ9jLqH7k4bQrx+YO72XTlc8TeEg/k0HUYYIozjwnZ1qSFFAlWIUHSYw2WVuK5PhsGAOX4wnzGUbhooFJNBXfYgPQ5ftYSoFnjGDYsk98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dMS7RpCM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dMS7RpCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA7A1F00893;
	Mon, 21 Sep 2026 06:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789971129;
	bh=XCvWOAefToduzVagptTeD/lXcZvT6nwVNtVpL06EJJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dMS7RpCM14VLK7oxOyRcKPcC8Rz311Du25OD2ywmnpWerxAoY2fW/6QpC+VkX6DIW
	 8jRU8K52a9iTxPbc3RPdOrlqMntVF4pF9LE8BpkJKKo5qQCElp+cw3d4AejT86kvmP
	 Ak83CYkhKgCJ89HSsit0l5XRHI9yDfhixcBq9N6i2JEwQ65DDG56VsGh1hlZiWd7Hw
	 U2m9nIoxRdqGjMB1ABGE5s383WxMhWvb7ilJcnbNpJV7clmmKtXUZSzqbE27nZTeIw
	 K/oxBIewAH52em6pRf8CNfi2VORH0K16gfJY1xUgF3Zk1lhP2KLVqcajbPoTRWiw+d
	 Q7rKmouSuUUxw==
From: Thorsten Blum <blum@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <blum@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] crypto: cast6 - use memcpy_and_pad() in __cast6_setkey()
Date: Mon, 21 Sep 2026 08:11:21 +0200
Message-ID: <20260921061120.29694-7-blum@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921061120.29694-6-blum@kernel.org>
References: <20260921061120.29694-6-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=764; i=blum@kernel.org; h=from:subject; bh=PLGfpoBPitfHZC5UoCH5L0QaKB+D/mefyUS3nk0rEkM=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFkbTq34uGf52+iXziv8NY+KV5scFZnguLp+uZvx0/lrl e2XrNowsaOUhUGMi0FWTJHlwawfM3xLayo3mUTshJnDygQyhIGLUwAmUvqJ4a+Qeebber2rnCzR M9hOp7xZe/DM7CMdK5ZuXpIgr3T+0idmRoYL7bff2rZub85xeX0lm435ypK6m02zeHPXcPz6e/n BrUJuAA==
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

Use memcpy_and_pad() instead of separate memcpy() and memset() calls to
simplify __cast6_setkey().

Signed-off-by: Thorsten Blum <blum@kernel.org>
---
 crypto/cast6_generic.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/cast6_generic.c b/crypto/cast6_generic.c
index 4c08c42646f0..9b6bdd2aa511 100644
--- a/crypto/cast6_generic.c
+++ b/crypto/cast6_generic.c
@@ -112,8 +112,7 @@ int __cast6_setkey(struct cast6_ctx *c, const u8 *in_key, unsigned int key_len)
 	if (key_len % 4 != 0)
 		return -EINVAL;
 
-	memset(p_key, 0, 32);
-	memcpy(p_key, in_key, key_len);
+	memcpy_and_pad(p_key, sizeof(p_key), in_key, key_len, 0);
 
 	key[0] = be32_to_cpu(p_key[0]);		/* A */
 	key[1] = be32_to_cpu(p_key[1]);		/* B */
