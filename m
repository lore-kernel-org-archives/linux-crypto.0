Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D60CDDC3;
	Sat, 21 Mar 2026 23:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774135909; cv=none; b=rsd4caGzpAu5jelUbbYXvbgu9Jv9LtiCa2bAEH71Iyt9+xECgdysMv+MptKQQ22yQ24m+FgIVvcTP+B8WasACAW9SX8mvGFKiboIVwrvHj7fkm9qQqZP1mx1bNw9m9mOI3qOzMoc7B2gG7bbgpjnWf5GdBav4SivtIzm7hPAHmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774135909; c=relaxed/simple;
	bh=UEvWh0dVHXTfT7HCHBETO9Z1PjWJ08TXe1O6/uTVUWk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D4B8YepkmrZtjGJglP820GQW8RZHlunzrHNmNffExVF9E0hN98GD18QyHqRbyx0r32rkBCod5WhjHtgRFyrY6t2C88e1lF6AsA8LCpxE2qtGDsR+7XXKhWeeMCJv4ZXXl9Xf1S8LS4EVtbjVsVYW8kGw9DgDAXX61wTuSdjT5pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EH0PbQgI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EH0PbQgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A955BC19421;
	Sat, 21 Mar 2026 23:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774135908;
	bh=UEvWh0dVHXTfT7HCHBETO9Z1PjWJ08TXe1O6/uTVUWk=;
	h=From:To:Cc:Subject:Date:From;
	b=EH0PbQgIuosWQZj4OFca4kqQCYWvyPs7bG7SVIwDr8FzhPbwV4pKqR+VJFUoZV2jh
	 shjlqveHV5kDVolbfoNVWnRdf7VtHvnuICzxTQJNTrDHsKFPt/BtDIdcZSY5i+rNH4
	 uOJZnkkrHBwojrah14SfmFWe8ivKVxCbYumR0im3JzRSE+L0u+iFLnAG72FAg+tSB8
	 I4/Ir1MMXR9PNjr6rog+/ibMRsHMKMEaf95U892UFrJqHWY+DJL76/6XRl4d76PthL
	 bGRHOBOVdDM4+1hVOnZszw6GUAOqpmITHqQl3XdbSTRwrxTjzDuimLrfzYeQ1JYMva
	 5l3lioEVPD6yw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] crypto: cryptomgr - Select algorithm types only when CRYPTO_SELFTESTS
Date: Sat, 21 Mar 2026 16:29:32 -0700
Message-ID: <20260321232932.98102-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enabling any template selects CRYPTO_MANAGER, which causes
CRYPTO_MANAGER2 to enable itself, which selects every algorithm type
option.  However, pulling in all algorithm types is needed only when the
self-tests are enabled.  So condition the selections accordingly.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting cryptodev/master

 crypto/Kconfig | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index e2b4106ac961..1330803628cf 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -155,18 +155,18 @@ config CRYPTO_MANAGER
 	  This provides the support for instantiating templates such as
 	  cbc(aes), and the support for the crypto self-tests.
 
 config CRYPTO_MANAGER2
 	def_tristate CRYPTO_MANAGER || (CRYPTO_MANAGER!=n && CRYPTO_ALGAPI=y)
-	select CRYPTO_ACOMP2
-	select CRYPTO_AEAD2
-	select CRYPTO_AKCIPHER2
-	select CRYPTO_SIG2
-	select CRYPTO_HASH2
-	select CRYPTO_KPP2
-	select CRYPTO_RNG2
-	select CRYPTO_SKCIPHER2
+	select CRYPTO_ACOMP2 if CRYPTO_SELFTESTS
+	select CRYPTO_AEAD2 if CRYPTO_SELFTESTS
+	select CRYPTO_AKCIPHER2 if CRYPTO_SELFTESTS
+	select CRYPTO_SIG2 if CRYPTO_SELFTESTS
+	select CRYPTO_HASH2 if CRYPTO_SELFTESTS
+	select CRYPTO_KPP2 if CRYPTO_SELFTESTS
+	select CRYPTO_RNG2 if CRYPTO_SELFTESTS
+	select CRYPTO_SKCIPHER2 if CRYPTO_SELFTESTS
 
 config CRYPTO_USER
 	tristate "Userspace cryptographic algorithm configuration"
 	depends on NET
 	select CRYPTO_MANAGER
-- 
2.53.0

