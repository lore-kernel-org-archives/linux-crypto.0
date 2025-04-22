Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB192900B0;
	Tue, 22 Apr 2025 15:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745335337; cv=none; b=W6M4PYslqidgnCojWxgJvZ2v91qR6H8215WS9KwGNCVNkPfq2S4PlUCPr7wOrJnBbFdoYnwPb/AIDz+wx+JPLVLTJgycbtnb1nzdPSJsDJqWkQEwyRp8fxwTvoLNtBihVgHJN2rM2+mSdhp+GIlPm8BWCv2LXoU0PsFv1t5ssuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745335337; c=relaxed/simple;
	bh=aro69g61MSuLSeorgPEfvGEZ3Rr0qJd2AS0aSCwUgu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aajwAk0MfyVcSKSyvM+UMBD2xjNtEwE8DeHGhT5/5J7cPh89mi6Cz1AaLvlfotBkZFO11RhJE0fWMyydTz7PI1YpbQKGnwI1mr9ayz5PMWUQ4G16rjj9yd7E4hDtDsQuyt6XjQK6MycYzDIurzOT5QmDHSam+45vPRt0/U7/wHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g7sW68EQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g7sW68EQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB95C4CEEE;
	Tue, 22 Apr 2025 15:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745335337;
	bh=aro69g61MSuLSeorgPEfvGEZ3Rr0qJd2AS0aSCwUgu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g7sW68EQsewoNeDmYR6VB4eYsNnC0ccuM+mCMMExEqZTn11RAFt5DXrFW0BPNvwyh
	 xZSC8Wo+GaDAwfpO4vDhttd2lkX7cFpUo4EbKPbQHjpUMhnfXW+4TUckm1V751QgZ9
	 Re4Oj9DL4YuybB5mnw09yWCPeXgrW9Xl6Y5Kg9JEHwFmG0N12+lfoTAFXBcEAh5OjO
	 AAWXy9BTbvl0xpL8OcnuYHUDzefwWqCJpXEUpbKOyKGP/QOqcDyzIPy7fDuU6mCpaZ
	 mhEz3GNYOATmFFcNXO8Cks2ZbCxe+aOKoLZGDuHYCyhH8dM3TkWT3CBx8bNnx0fsWh
	 By1H3QJAv+obA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 9/9] crypto: testmgr - enable CRYPTO_MANAGER when CRYPTO_SELFTESTS
Date: Tue, 22 Apr 2025 08:21:51 -0700
Message-ID: <20250422152151.3691-10-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250422152151.3691-1-ebiggers@kernel.org>
References: <20250422152151.3691-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

crypto/testmgr.c is compiled only when CRYPTO_MANAGER is enabled.  To
make CRYPTO_SELFTESTS work as expected when CRYPTO_MANAGER doesn't get
enabled for another reason, automatically set CRYPTO_MANAGER to the
value of CRYPTO_ALGAPI when CRYPTO_SELFTESTS is enabled.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/Kconfig  | 5 +++--
 crypto/algapi.c | 3 +--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index fa354b54d09b1..0577cfb942fb0 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -147,14 +147,15 @@ config CRYPTO_HKDF
 	select CRYPTO_SHA512 if CRYPTO_SELFTESTS
 	select CRYPTO_HASH2
 
 config CRYPTO_MANAGER
 	tristate
+	default CRYPTO_ALGAPI if CRYPTO_SELFTESTS
 	select CRYPTO_MANAGER2
 	help
-	  Create default cryptographic template instantiations such as
-	  cbc(aes).
+	  This provides the support for instantiating templates such as
+	  cbc(aes), and the support for the crypto self-tests.
 
 config CRYPTO_MANAGER2
 	def_tristate CRYPTO_MANAGER || (CRYPTO_MANAGER!=n && CRYPTO_ALGAPI=y)
 	select CRYPTO_ACOMP2
 	select CRYPTO_AEAD2
diff --git a/crypto/algapi.c b/crypto/algapi.c
index 9030a30c89e84..25b5519e3b711 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -272,12 +272,11 @@ static void crypto_alg_finish_registration(struct crypto_alg *alg,
 
 static struct crypto_larval *crypto_alloc_test_larval(struct crypto_alg *alg)
 {
 	struct crypto_larval *larval;
 
-	if (!IS_ENABLED(CONFIG_CRYPTO_MANAGER) ||
-	    !IS_ENABLED(CONFIG_CRYPTO_SELFTESTS) ||
+	if (!IS_ENABLED(CONFIG_CRYPTO_SELFTESTS) ||
 	    (alg->cra_flags & CRYPTO_ALG_INTERNAL))
 		return NULL; /* No self-test needed */
 
 	larval = crypto_larval_alloc(alg->cra_name,
 				     alg->cra_flags | CRYPTO_ALG_TESTED, 0);
-- 
2.49.0

