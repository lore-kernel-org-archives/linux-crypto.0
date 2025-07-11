Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6C61EA7EB;
	Fri, 11 Jul 2025 07:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752218649; cv=none; b=crp3S9yPsuVNI2gP98i14Ny6rKficwNu3hKTDPJIp8nEEPvHr47xTWbZiBmMjZg1WykAI1GQkRZzwOVmN+Mh1EFToz8iiqPD90GWxTfo2rPX6JLS/LKSa3HkZyJ7a84T2v4NMdcdFz84TxGQe4J09mP1R/O+mhLZrk+JWGOZaWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752218649; c=relaxed/simple;
	bh=7ZuhYqLkRnTSKCgyebV0Pe82Zzj9bAFdf+3x3p+JtVo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=im+k7fvLk8i8zIpQSLoqoov0rQ1CiTRxA1Z91vQ6uuTgslJh9ievAcL9yqXSb/GEkHM9RMOM5LARcr3aZ8YEZcI6kJ0QeCeMWvAt2jm61DNrDZd+n1Wf3kBA+Q3ASukTzkIYncd5PeJ9/jdycR7zSMbEX0/da1zTHhS1EUkC6j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aIfRPJy3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aIfRPJy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208C6C4CEEF;
	Fri, 11 Jul 2025 07:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752218649;
	bh=7ZuhYqLkRnTSKCgyebV0Pe82Zzj9bAFdf+3x3p+JtVo=;
	h=From:To:Cc:Subject:Date:From;
	b=aIfRPJy3qmcd6h1HEKutm8znGYtVSBCSlwYvds9LnbI8Hu2/tEGmhEVz5QMsE/N0w
	 ckZVh8tKnt1tm4+meTakoecAUFc2C4ERs0Jzb0+SGrXtImn5sXPaTFssGXXqxf1kST
	 lddEoWQC3opjpHbF+N1cCGpVup2w5uIKKmu5MXs2fJE95OkTpyJE+twyuxuPmBXjHT
	 nr9DuHCsLAqCbsQOu9OUSBQT5hJBrRKUdIfol25W2d7av1lgYuf8WKa8yjZvEEgXyT
	 nUSRNFIobAY1EZ2VEMzr7aE/+14jQwLLCbLnfIRj6q3TU4yJt2mOaGSBvqyKdgvjyO
	 kD2A+KCPVYnBg==
From: Arnd Bergmann <arnd@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sohil Mehta <sohil.mehta@intel.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] lib/crypto: arm/poly1305: fix poly1305_blocks_neon link failure
Date: Fri, 11 Jul 2025 09:23:59 +0200
Message-Id: <20250711072404.2629868-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

The reference to poly1305_blocks_neon from generated assembler code is
apparently the reason we had the silly __weak function in the wrapper.
Removing it introduced a link failure:

ERROR: modpost: "poly1305_blocks_neon" [lib/crypto/arm/poly1305-arm.ko] undefined!

Moving the reference inside of the #if ARMv7 block avoids this problem.

Fixes: 16f9e0cc99ec ("lib/crypto: arm/poly1305: Remove unneeded empty weak function")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
I see that the neon code is always built when targetting ARMv7, even in
configurations without CONFIG_KERNEL_MODE_NEON where it is never called.
I tried cleaning that up as well but couldn't figure it out.
---
 lib/crypto/arm/poly1305-armv4.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/crypto/arm/poly1305-armv4.pl b/lib/crypto/arm/poly1305-armv4.pl
index d57c6e2fc84a..dd7a996361a7 100644
--- a/lib/crypto/arm/poly1305-armv4.pl
+++ b/lib/crypto/arm/poly1305-armv4.pl
@@ -46,7 +46,6 @@ $code.=<<___;
 # define poly1305_init   poly1305_block_init_arch
 # define poly1305_blocks poly1305_blocks_arm
 # define poly1305_emit   poly1305_emit_arch
-.globl	poly1305_blocks_neon
 #endif
 
 #if defined(__thumb2__)
@@ -722,6 +721,7 @@ poly1305_init_neon:
 	ret				@ bx	lr
 .size	poly1305_init_neon,.-poly1305_init_neon
 
+.globl	poly1305_blocks_neon
 .type	poly1305_blocks_neon,%function
 .align	5
 poly1305_blocks_neon:
-- 
2.39.5

