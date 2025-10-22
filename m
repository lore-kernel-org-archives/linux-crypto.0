Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81855224893;
	Wed, 22 Oct 2025 03:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761104248; cv=none; b=R4fV0QJmSHO0LUFiy7l0nLtRidZ1uPZ4a5Mq+3LpvM6JNn+7H/4It7dLTJOCOAMOwbmaSYbiK2+vNHMqmBgh8eHQAA6pzXCohPe+HgCOibycquG073fFeev7JkuW9XjjPYWXsBlHswXOGf8p7/TXNo00mYowUaVXyPTwtwBs5Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761104248; c=relaxed/simple;
	bh=Hlb9JiBZWMfBzK/UndbauuxjM6KStdrKstXCa7vxyJw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PCUt7B0HkCIQ+mfs4Jp2rJeWrsufyTJE+4e+V0DA/kni6uncAtdxbnmn70JUfFpZXPE4BWBins7DgOpucnBeilQFGzvi2ChOmkqVyZxTCF+2vGJnN8spI63s6k9IF8/dD9YKDMlQHn5hWA4WtmXGafhMDgYBroJZ1iGuO2S5lEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HqjjRdZf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HqjjRdZf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE6CC4CEE7;
	Wed, 22 Oct 2025 03:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761104248;
	bh=Hlb9JiBZWMfBzK/UndbauuxjM6KStdrKstXCa7vxyJw=;
	h=From:To:Cc:Subject:Date:From;
	b=HqjjRdZf6jR5AbWGjErUxogrkgYqKEoU5CuD5xMLa24DQaBurXTyhM/BzETK11IS0
	 F5NYFhJQtadGyIukFkmwTp1g8VZFM7ndqc7MG2JYWHWiDceeRKZ4t88vi1iANv3lIn
	 qlDTY7F/K9rXzMuv2ct8iKxxVvQDOa7+dBdjYICBOKb/rBsKSZH8vdsgYeQr+843Jo
	 yrJWnuBxPyfN23npzcAIhIhcZSwXH5fARQRgDc4W+PV1PL95RXiiYMCPUld1zBa5DH
	 nu4CfL6+Hx90+72R+E4CqcyRdOjaJF5CVnzJYbrWpkW87BjfInA+JGZgAoSZJBjcrw
	 IHSOci6aaDuog==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Alexander Potapenko <glider@google.com>,
	kasan-dev@googlegroups.com,
	Eric Biggers <ebiggers@kernel.org>,
	syzbot+01fcd39a0d90cdb0e3df@syzkaller.appspotmail.com
Subject: [PATCH] lib/crypto: poly1305: Restore dependency of arch code on !KMSAN
Date: Tue, 21 Oct 2025 20:34:05 -0700
Message-ID: <20251022033405.64761-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.1.dirty
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Restore the dependency of the architecture-optimized Poly1305 code on
!KMSAN.  It was dropped by commit b646b782e522 ("lib/crypto: poly1305:
Consolidate into single module").

Unlike the other hash algorithms in lib/crypto/ (e.g., SHA-512), the way
the architecture-optimized Poly1305 code is integrated results in
assembly code initializing memory, for several different architectures.
Thus, it generates false positive KMSAN warnings.  These could be
suppressed with kmsan_unpoison_memory(), but it would be needed in quite
a few places.  For now let's just restore the dependency on !KMSAN.

Note: this should have been caught by running poly1305_kunit with
CONFIG_KMSAN=y, which I did.  However, due to an unrelated KMSAN bug
(https://lore.kernel.org/r/20251022030213.GA35717@sol/), KMSAN currently
isn't working reliably.  Thus, the warning wasn't noticed until later.

Fixes: b646b782e522 ("lib/crypto: poly1305: Consolidate into single module")
Reported-by: syzbot+01fcd39a0d90cdb0e3df@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/68f6a48f.050a0220.91a22.0452.GAE@google.com/
Reported-by: Pei Xiao <xiaopei01@kylinos.cn>
Closes: https://lore.kernel.org/r/751b3d80293a6f599bb07770afcef24f623c7da0.1761026343.git.xiaopei01@kylinos.cn/
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index eea17e36a22be..8886055e938f2 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -95,11 +95,11 @@ config CRYPTO_LIB_POLY1305
 	  The Poly1305 library functions.  Select this if your module uses any
 	  of the functions from <crypto/poly1305.h>.
 
 config CRYPTO_LIB_POLY1305_ARCH
 	bool
-	depends on CRYPTO_LIB_POLY1305 && !UML
+	depends on CRYPTO_LIB_POLY1305 && !UML && !KMSAN
 	default y if ARM
 	default y if ARM64 && KERNEL_MODE_NEON
 	default y if MIPS
 	# The PPC64 code needs to be fixed to work in softirq context.
 	default y if PPC64 && CPU_LITTLE_ENDIAN && VSX && BROKEN

base-commit: 552c50713f273b494ac6c77052032a49bc9255e2
-- 
2.51.1.dirty

