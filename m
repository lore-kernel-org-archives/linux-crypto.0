Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D856626FA60
	for <linux-crypto@vger.kernel.org>; Mon,  5 May 2025 19:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746472297; cv=none; b=DKSidntmvXp9ZE8oRTUNzwtTQK2ZqYXgMXVy4QjdTi/i1ZQMeB2cqb90Pn4OZKtn2d2sEGLo4VIlWVQsU8eOQA+iOmgAgiDbG4bnLbKoboJ+Rk455cxbmVgJBTYI1DOZMFE+/uG+hpmAVti5SpzV3KTjO7Fi2MR6cgSGzaef6Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746472297; c=relaxed/simple;
	bh=Ef9zmYIZe+4TF2b7Q1Lz2u+fhl0U7p7qqpocEBgQQ8o=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T5mEbXSIaqpbMMDtLM4fH9Fk00qzaENUmidusWrEm86zpuGJiSoHXf5OxxCawS7pF/ZP5bfSMbySb117blmXHi5wFXgVoM+/vsfZsN26+YZiw+LK5Pa9oE/wjv+D19q0p88Uq9mYQQ3jeFlGz8VT942EqIcELRQz4u6K5gNvvvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gGD8xjHt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gGD8xjHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0147C4CEF1
	for <linux-crypto@vger.kernel.org>; Mon,  5 May 2025 19:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746472297;
	bh=Ef9zmYIZe+4TF2b7Q1Lz2u+fhl0U7p7qqpocEBgQQ8o=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=gGD8xjHtUOzw6oCsX571V23i6FYfVsPtQlvX2cIuwl3/jB3N8v0ZLygqqjLA2Zlt2
	 R7gjhIV2hvrpnqFuIbUh3MX2tw4bUhSSSd2GRv61bZ6QJl/V3B2W9K4w5AYme0dgTF
	 CrwUzwt4LYqVqGU3OdKPjjpOmILAj/ybqnn0BR0uGZGnkOV1UAkp7XaA0ZAvDjHTKm
	 vcQnKShukJqeviQ4kBKbQisrNqF7vjC2rqquag9M21+0Xuu+KdxgcTMBSAcKlIkck6
	 YCA43zHoolXWPLXqflsz9WPzLmcdjHVCwKGfwVauPKxYdIQWiPkxtwOuwMYUstEDrw
	 LiVTdIIum2GBA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Subject: [PATCH 7/8] crypto: null - merge CRYPTO_NULL2 into CRYPTO_NULL
Date: Mon,  5 May 2025 12:10:44 -0700
Message-ID: <20250505191045.763835-8-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250505191045.763835-1-ebiggers@kernel.org>
References: <20250505191045.763835-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

There is no reason to have separate CRYPTO_NULL2 and CRYPTO_NULL
options.  Just merge them into CRYPTO_NULL.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/Kconfig  | 10 +++-------
 crypto/Makefile |  2 +-
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index cf5a427bb54d..7347277bedf3 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -190,20 +190,16 @@ config CRYPTO_MANAGER_EXTRA_TESTS
 	  This is intended for developer use only, as these tests take much
 	  longer to run than the normal self tests.
 
 config CRYPTO_NULL
 	tristate "Null algorithms"
-	select CRYPTO_NULL2
+	select CRYPTO_ALGAPI
+	select CRYPTO_SKCIPHER
+	select CRYPTO_HASH
 	help
 	  These are 'Null' algorithms, used by IPsec, which do nothing.
 
-config CRYPTO_NULL2
-	tristate
-	select CRYPTO_ALGAPI2
-	select CRYPTO_SKCIPHER2
-	select CRYPTO_HASH2
-
 config CRYPTO_PCRYPT
 	tristate "Parallel crypto engine"
 	depends on SMP
 	select PADATA
 	select CRYPTO_MANAGER
diff --git a/crypto/Makefile b/crypto/Makefile
index 84f6911dc9ba..0f77e093512c 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -69,11 +69,11 @@ cryptomgr-y := algboss.o testmgr.o
 obj-$(CONFIG_CRYPTO_MANAGER2) += cryptomgr.o
 obj-$(CONFIG_CRYPTO_USER) += crypto_user.o
 obj-$(CONFIG_CRYPTO_CMAC) += cmac.o
 obj-$(CONFIG_CRYPTO_HMAC) += hmac.o
 obj-$(CONFIG_CRYPTO_XCBC) += xcbc.o
-obj-$(CONFIG_CRYPTO_NULL2) += crypto_null.o
+obj-$(CONFIG_CRYPTO_NULL) += crypto_null.o
 obj-$(CONFIG_CRYPTO_MD4) += md4.o
 obj-$(CONFIG_CRYPTO_MD5) += md5.o
 obj-$(CONFIG_CRYPTO_RMD160) += rmd160.o
 obj-$(CONFIG_CRYPTO_SHA1) += sha1_generic.o
 obj-$(CONFIG_CRYPTO_SHA256) += sha256.o
-- 
2.49.0

