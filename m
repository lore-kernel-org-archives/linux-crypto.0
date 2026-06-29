Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74B737DEA2;
	Mon, 29 Jun 2026 03:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782703689; cv=none; b=pUtbXnutX/6xqWp5Gv/YyS8cf8GqKJvqyATds02i25959vPpXmc0dUvNFc0eUUVsRyKKvg/ZOOpygHLWvFUiGfG6jAOW3fypk1HGLh5kTi4i1JqEbHNzKy7mVIcNzd6NY42h0nThvRipGR5iI6/R/OjcjFaxxsrA7kLVVjouq9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782703689; c=relaxed/simple;
	bh=5zB+je9lQ1tGhP/t9lxIm32J2PwQwLZjjKw3m4AhsNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=huAfdmVJeofwz1d1vTnSK1b9Oh5j2UXSOVdsDJ5tKtWASLwxS1GiaX9fYg8a3blowXxS6aMvlAmaApiz4UuCeIivWf50Ly5mBjGFue2Gnv3Qhavd3by5+t+FOnrEeYdcEezUs9tqxHDpSZqIsNHZJZNHIAijWkTwM4Utq7luGwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fel4PdcU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fel4PdcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606DF1F000E9;
	Mon, 29 Jun 2026 03:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782703688;
	bh=mkQir9JSn28EgBSoiIxqaa+E1e9/QhLgZWWbRzFEI40=;
	h=From:To:Cc:Subject:Date;
	b=fel4PdcUBmKsNQfQOR432qllH/glRENtfKDE42oAsEdWruCcIBehU+7534/UMHe7c
	 EIyDpsgEyA423oCJxkeoN1hOeFwvz7caKfPC0vxzd5pwtL2GpBO35jMml/WvA6V3lf
	 SRcDEaKz0JY2+hD0H/aVEbsdQQX8EY8htPIswqLO/z7xOqMVgHe15YytNi3ZBwmoZa
	 ELOmL9yLjLRnd04xlsQcDHpYjo1tKsW2t3j5JZqlu6VSg01Q+65vEuCtO4bnhuce6A
	 9PZL4KaC+2aXxEU4p3UuvhjKZ2vKnFy+sGfU7yDLaIa0JqxhIPdvKaglMTFcc5ejuv
	 z8S/vGPhl0SCw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: md5: Remove support for md5_mod_init_arch()
Date: Sun, 28 Jun 2026 20:25:52 -0700
Message-ID: <20260629032552.26100-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No definitions of md5_mod_init_arch() remain, so remove the code that
handles it.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/md5.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/lib/crypto/md5.c b/lib/crypto/md5.c
index 6bf130cfbbf9..3d2b017a0525 100644
--- a/lib/crypto/md5.c
+++ b/lib/crypto/md5.c
@@ -298,19 +298,5 @@ void hmac_md5_usingrawkey(const u8 *raw_key, size_t raw_key_len,
 }
 EXPORT_SYMBOL_GPL(hmac_md5_usingrawkey);
 
-#ifdef md5_mod_init_arch
-static int __init md5_mod_init(void)
-{
-	md5_mod_init_arch();
-	return 0;
-}
-subsys_initcall(md5_mod_init);
-
-static void __exit md5_mod_exit(void)
-{
-}
-module_exit(md5_mod_exit);
-#endif
-
 MODULE_DESCRIPTION("MD5 and HMAC-MD5 library functions");
 MODULE_LICENSE("GPL");

base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
-- 
2.54.0

