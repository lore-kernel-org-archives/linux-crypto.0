Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62592FF144;
	Wed, 22 Jul 2026 02:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784686846; cv=none; b=kDnc6EH6bLXNA+BpE+kcHfOs7PFX+HM24Uj3Mk9Uff8IHIcgnPuhS6ImX0ig/c9YUH9I+h9NF0EvNEdxxaTgT76QXEgNdJpcbnfz4G5UqlPShABNuQ1/+lgaW55cl3nYFwLEkh4G0zBfOli4GXJNIBTkOdamJpIxQchvQHKrXBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784686846; c=relaxed/simple;
	bh=/mSoGc+9z6dZrZRk6AzOL1SpHVavU6ZBRwFByNkvpKM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tmEaM+EO3YxNhjYjvLQ37Ygj4mNtH3PTNbf7E0qIyuzXgwyFK5qDlt0MxeOit6fFMyy3IuEiaKv0/4KT/wArTl2R2K3Svu+b1yHDw+soBVK9PzgkAOLrPlGWujXKgxpdz6ng7CsohQLRVJQClcrznRtSpqOfeZtDk5pziZg3ExQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iTypvohy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iTypvohy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0EE1F000E9;
	Wed, 22 Jul 2026 02:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784686845;
	bh=SzVDMNMHTPNmC4BCnaoB8Cju/w7ux4WwzboG8yHPKbw=;
	h=From:To:Cc:Subject:Date;
	b=iTypvohyh40QVj4quZv1LAWybZI1DQi4N5zhVTkGSvbos+Wx5rI1RMKXmnPI9dAwp
	 K6i8xok3Z0OwtezC4OnRC1l4wG3XycXFy4P74hPKSFZUD5odhawqawOrn8j0k9cPCx
	 iFu3fzd99y0MB4+tDSEVQ5xMr2gtuolFZ8BmSnE80t8yH2IWY3jjNXy6EzLFLQfFf3
	 odA1U8070WE58VJTgYRjFSDFEezA19vIrCFR/0OVvn0S1V3RRLbye8P3kq5aOMRHi1
	 lbVN+lEfWKpC62VEtDk8ye+7XgW0P9UCReBkq9+NEFQnxFWghzq6+5SIh6VsqKyIB8
	 ZKazmNhCrwlFA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] lib/crypto: aes-gcm: Fix CRYPTO_LIB_GF128HASH selection
Date: Tue, 21 Jul 2026 19:17:30 -0700
Message-ID: <20260722021730.16897-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the selection of CRYPTO_LIB_GF128HASH from CRYPTO_LIB_AES_GCM to
CRYPTO_LIB_AES to avoid a build error when CRYPTO_LIB_AES=y &&
CRYPTO_LIB_AES_GCM=m.  Like the other AES modes, AES-GCM is included in
libaes as an optional feature rather than a dedicated module.

Fixes: 2bbb64399435 ("lib/crypto: aes: Add GCM support")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202607220918.2RL0wGGS-lkp@intel.com/
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 65a478f69715d..18cc911f79df6 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -8,6 +8,8 @@ config CRYPTO_LIB_UTILS
 
 config CRYPTO_LIB_AES
 	tristate
+	# Select dependencies of modes that are part of libaes.
+	select CRYPTO_LIB_GF128HASH if CRYPTO_LIB_AES_GCM != n
 	select CRYPTO_LIB_UTILS
 
 config CRYPTO_LIB_AES_ARCH
@@ -65,7 +67,6 @@ config CRYPTO_LIB_AES_GCM
 	tristate
 	select CRYPTO_LIB_AES
 	select CRYPTO_LIB_AES_CTR
-	select CRYPTO_LIB_GF128HASH
 	help
 	  The AES-GCM library functions.
 

base-commit: e4f23159c8d09b6b15d47f2c95e0a3e7c62f52a2
-- 
2.55.0

