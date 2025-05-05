Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE451270570;
	Mon,  5 May 2025 20:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746477437; cv=none; b=UfPJyOcPnL8uRdlHrKxs+1/MvCZ9D62CYBMsDFSiLLW+BXnnrEaYnnRqYZYFSwO3PCxA6Tik3wefrDRjHWAdjumQYh3Vuko8G6MNuXVgq0UPTYPgNQg1vLkXifR6i+h1fEG/jIZ10qrS2vrYcaULs6H9kuIF5rS8a5Cat0iA5xU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746477437; c=relaxed/simple;
	bh=86AotSM9q0N0N6slvANNauE9kd/qOH9P5rB82f/dZKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AfjUS4B2qBXeRe48Dgz4IHHQEQhNDquz3WTTKeu5/HxRCJFU5N9Z/GHYu3Ef9eXre61EfNEyHubBqHhmn4qJoYhH6lqplVg/6dtuB9q+G9dDDJ0XWJU6NloexofU3qmxVvGQNN03E5b5Xh6XJBIVTov1kyTqpnI4X109n8F8U+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Grg81EGV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Grg81EGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE15EC4CEF6;
	Mon,  5 May 2025 20:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746477436;
	bh=86AotSM9q0N0N6slvANNauE9kd/qOH9P5rB82f/dZKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Grg81EGVc5okSAWPbGbDILLSEEWE1Xs7adMPzKfTDj8r7B8PwW1a5+H5QnS6OhJiu
	 Tjnn5h8Lec/piaWwDoDJ5SRtIzhcnNr3KXGYGq7K1y7oK3u08QPsG8s+JFWyyl01Lf
	 bmbDENx/gDyBAu+FRdLnxbZn0CMFpKAqkmAtT1UZ5+QBvMC9SWFV3gpdH44EqsX1xy
	 JBXFK5hlyn3byoL8LsFMCl3XJWRL767hT05CZzfdj1oducznViZUZN73gGehjQDNdZ
	 MTxEN2I5RQfxMl2bKwVdUq13LPSUrlun93I/2dgr7xSdNkTjKfyPgJNz5E997DdkKQ
	 KOylSXDWOgi5Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v3 7/7] crypto: testmgr - enable CRYPTO_MANAGER when CRYPTO_SELFTESTS
Date: Mon,  5 May 2025 13:33:45 -0700
Message-ID: <20250505203345.802740-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250505203345.802740-1-ebiggers@kernel.org>
References: <20250505203345.802740-1-ebiggers@kernel.org>
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
index f160537a5550..24955eb56045 100644
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

