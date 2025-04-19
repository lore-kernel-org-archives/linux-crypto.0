Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF651E22E9;
	Sat, 19 Apr 2025 16:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745079455; cv=none; b=A1rpjI5YcynYeD61JmhDEPTfRaC5uAnMsj5RqtH9y8suHEFX/SzJZRwbpDQjGJ0ybMZIgQFzx5ot4ltanYO4wdHMdiGTjLDL8HxuyHV316kVfw15sbstEXl4XIHTktld6fQs3kKXEKpEDtRvmNcyRKWOtWeUDYUTdRzLofBQdLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745079455; c=relaxed/simple;
	bh=c+ZfnCHBB/xdo4pLdvwg/vGfuPMyzIrC+/q3vpZ/CcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shvZ2k6w9vUl9QjzxhxzFSFxd2aUGbRQ+4ReMkoR1AtSMhqEXB6YEARNc/D/gDJ+UJ6pvCziONtPoypftCbUcx8tA+TNJGNSOOeuABpbDrl0CsMhrGbkNCHcT7TE0gy3yOZ5wl4VIIgZIhxV/i6nvs469eAej1XmbSmhf+prwVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d+BsHPso; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d+BsHPso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C84C4CEE9;
	Sat, 19 Apr 2025 16:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745079454;
	bh=c+ZfnCHBB/xdo4pLdvwg/vGfuPMyzIrC+/q3vpZ/CcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d+BsHPsoKBsk8hG1z0zw325wTAUJ285D8C1ZKOlLEXaDmTQOnDsUL17CChv1G/Er9
	 1S7mJkj5m/ktTQSRU0de2q+F68N8i1MruFtMxw0+jVnMxf2SPMdUR6jZI5WqvkydXR
	 LVMyYqbVgmtpCNt8Mu6fw+JoUjFXiGgLRTac0xRNT1dkqU1d6StbYe4xA8cy6lrDtR
	 aK+FIAF4yY4obfGKc+aBD2Lyx3djuQGP00qzAkgHxAomqYEZsUgomJBEDYb6jAt2eT
	 TdHYIOMkaaThVbodeSo7yHIo9SQ2w+cr3jV2fh8uK1pLyGWF1Qhs8BgNHY/xE73bSM
	 UUzAI4NjGOR6A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] crypto: testmgr - enable CRYPTO_MANAGER when CRYPTO_SELFTESTS
Date: Sat, 19 Apr 2025 09:15:43 -0700
Message-ID: <20250419161543.139344-10-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250419161543.139344-1-ebiggers@kernel.org>
References: <20250419161543.139344-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

crypto/testmgr.c is compiled only CRYPTO_MANAGER is enabled.  To make
CRYPTO_SELFTESTS work as expected when CRYPTO_MANAGER doesn't get
enabled for another reason, automatically set CRYPTO_MANAGER to the
value of CRYPTO_ALGAPI when CRYPTO_SELFTESTS is enabled.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/Kconfig  | 5 +++--
 crypto/algapi.c | 3 +--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index fa354b54d09b..0577cfb942fb 100644
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
index 9030a30c89e8..25b5519e3b71 100644
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

