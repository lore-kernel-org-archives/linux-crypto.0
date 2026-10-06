Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3F93C871E;
	Tue,  6 Oct 2026 08:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791275740; cv=none; b=riNoijefbVWfKiTUNad7Dx4zC4MIKB+IeC4SQ86xWVBVDGqAyLoRzJULjoHJIyvOflPiOaFi7Psp0k9q10dyCjEzBNFxAWwpR1h/ZlV2B3VThm7ZCmdmW6EfqrCqVlz/8aDSnAodP9+kjaKFHDKox5B8Js0ICjMEWzPhvwfUIY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791275740; c=relaxed/simple;
	bh=9eJD3A/h+7Xu1zNmMcrerWDoMWr/yNipexMr60RpsZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mhNPSC+BJFmmTqqpHn0Mn58XGQYQDmyN8VeIDaf0PT45ZTVc5bM/ncsAOB82qg/kHes5o+8umCY9jReM8idnZJHtz7w8IUD1qY4vxWWzkQYSWMjT0ENzSf2QxxWLDjhBNnhcvv5lwN4zSBdKRz/CQjvgefJvmj9jVMgciDFpY10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h3UkQGmZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h3UkQGmZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584FD1F000FF;
	Tue,  6 Oct 2026 08:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791275739;
	bh=9kAGnm6WKEBB8Q/yVVpPtBraDvfpu6wEiPKRs9xavOU=;
	h=From:To:Cc:Subject:Date;
	b=h3UkQGmZMi9LhJhd3Vcmc8yg5IyU5m/YUeX4+GVjGWy/aevGNACB4/BVyZhytCDoK
	 paRjJfiWGMWaKTII+sS1oTQG3fSlpdpM8Z/g4EH76MrACQxI/1DE0M9jNTr9HqPRBJ
	 4eCkwW6PKiFg4Uc5aAT8pDRvjD6xJRZ90cy0Q8zhH1TZbnEnXpfU+eSSFTBp/eX1Qa
	 dG5IK6Qr1L11RBI42MQdo5OJPN31q7YIo22dHTKiIBszuqEfkGtOJjlOsj0kENl8+V
	 vf1yurfGNwD+YgxM3+CRL68eorfTlt6w5xlPzkVXo3ml3kqX7mMf928b3kRYg0NPk9
	 bHUhLzCbujVqw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH] lib/crypto: poly1305: Use memzero_explicit() in poly1305_final()
Date: Tue,  6 Oct 2026 10:34:32 +0200
Message-ID: <20261006083432.16328-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use memzero_explicit() instead of a plain struct assignment to guarantee
zeroization of the 'struct poly1305_desc_ctx'.

Note that dead store elimination was only theoretically possible with
link-time optimization here.  But it's still worth fixing.

Fixes: a1d93064094c ("crypto: poly1305 - expose init/update/final library interface")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-c3a6bd76-f6ab-4203-892a-cd06f7aa0c34
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/poly1305.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/crypto/poly1305.c b/lib/crypto/poly1305.c
index f313ccc4b4dd2..048c7afe86138 100644
--- a/lib/crypto/poly1305.c
+++ b/lib/crypto/poly1305.c
@@ -78,7 +78,7 @@ void poly1305_final(struct poly1305_desc_ctx *desc, u8 *dst)
 	}
 
 	poly1305_emit(&desc->state.h, dst, desc->s);
-	*desc = (struct poly1305_desc_ctx){};
+	memzero_explicit(desc, sizeof(*desc));
 }
 EXPORT_SYMBOL(poly1305_final);
 

base-commit: 6a50ce0af5c91fd665d65d357af8ae55db1df7d0
-- 
2.56.0

