Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B5B3B0AD4;
	Tue, 28 Apr 2026 02:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777344431; cv=none; b=axd97bzSN8HW1RYjjBHvT1Q45WClnqUcJZNUg9rMozxFR2YM7EW1Xw+jeAlrFlC9D5G7UEuolxD3xF/SdPmOAGKn4ObRGhb9uY3TUnPwlLEvN7fQ1bRAC5sjIxkZhaV8uQN9s7aAK+4AJ2CCtUqcoTpQFPHnRP8YqIY6UG79MfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777344431; c=relaxed/simple;
	bh=BBwwD1i8iYEsGQrYrKessOkF7wXuFkob2WzjXMS8vI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bYCTVWTcKnkJM+cmtbKl/koq9kcoRDXRWtcJZi6XpHS2fuQ8xQ88s+xas6JfYFoEQK3/c8G+CvHp6PlaUx1zrpyk6m4RAodtxxOCUE+Z52e9Ntnvkg9psWnMxKGjsTo4ZS/MOkMzM+6J/L15j4Ey7CEkapv7yk1imvjsduth0Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gUSZHAgZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gUSZHAgZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FC6C2BCB7;
	Tue, 28 Apr 2026 02:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777344431;
	bh=BBwwD1i8iYEsGQrYrKessOkF7wXuFkob2WzjXMS8vI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gUSZHAgZmDMOTbvmtghZ5KJKtAwML/qIWnnOlV6GybfmkiZYUe8VArd0VUT9b0zSb
	 EmVizKYGLJhQeiIy/m1b68BArV7cYP3K4JoyYEwHcX1ZGynjrBdwgft4NNz2mYJ5JT
	 keEYcWMwFkKrPgPuwIP4IP77vbPMuk9R9UNDh8s5VzPZAFFfGhSMsw4WEjNJPanUHl
	 kWQkirD3l9ZMZoG2VVcx7Lt70SCT+nkYRLdot6iXS8Hu3zPqB/C5c98WvAcLXGDs1H
	 8944e1RMsRRnbKQEUh5YeW3+JuIG5fk26q8jJ2+NGw+6wen/vj4BfbNYJSez0WmtNM
	 PnuDzfQUIGllw==
From: Eric Biggers <ebiggers@kernel.org>
To: netdev@vger.kernel.org,
	linux-afs@lists.infradead.org
Cc: David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH net-next 4/5] crypto: fcrypt - Remove support for FCrypt block cipher
Date: Mon, 27 Apr 2026 19:43:57 -0700
Message-ID: <20260428024400.123337-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260428024400.123337-1-ebiggers@kernel.org>
References: <20260428024400.123337-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Remove the insecure FCrypt block cipher from the crypto API.  Its only
user was net/rxrpc/, but now net/rxrpc/ implements it locally.  The
crypto API implementation is no longer needed.

For some additional context: FCrypt was designed in 1988 and is
essentially a weakened version of DES.  It has the same 56-bit key size
as DES, which is easily brute forced.  Moreover, it's cryptographically
weak and doesn't even provide the intended 56-bit security level.  Its
author considers it to be a mistake, as well
(https://lists.openafs.org/pipermail/openafs-devel/2000-December/005320.html).

But fortunately this 1980s-era homebrew block cipher was never adopted
outside of net/rxrpc/.  So its code can just be kept there.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/arm/configs/pxa_defconfig              |   1 -
 arch/m68k/configs/amiga_defconfig           |   1 -
 arch/m68k/configs/apollo_defconfig          |   1 -
 arch/m68k/configs/atari_defconfig           |   1 -
 arch/m68k/configs/bvme6000_defconfig        |   1 -
 arch/m68k/configs/hp300_defconfig           |   1 -
 arch/m68k/configs/mac_defconfig             |   1 -
 arch/m68k/configs/multi_defconfig           |   1 -
 arch/m68k/configs/mvme147_defconfig         |   1 -
 arch/m68k/configs/mvme16x_defconfig         |   1 -
 arch/m68k/configs/q40_defconfig             |   1 -
 arch/m68k/configs/sun3_defconfig            |   1 -
 arch/m68k/configs/sun3x_defconfig           |   1 -
 arch/mips/configs/bigsur_defconfig          |   1 -
 arch/mips/configs/decstation_64_defconfig   |   1 -
 arch/mips/configs/decstation_defconfig      |   1 -
 arch/mips/configs/decstation_r4k_defconfig  |   1 -
 arch/mips/configs/ip22_defconfig            |   1 -
 arch/mips/configs/ip27_defconfig            |   1 -
 arch/mips/configs/ip30_defconfig            |   1 -
 arch/mips/configs/ip32_defconfig            |   1 -
 arch/mips/configs/lemote2f_defconfig        |   1 -
 arch/mips/configs/malta_defconfig           |   1 -
 arch/mips/configs/malta_kvm_defconfig       |   1 -
 arch/mips/configs/maltaup_xpa_defconfig     |   1 -
 arch/mips/configs/rm200_defconfig           |   1 -
 arch/mips/configs/sb1250_swarm_defconfig    |   1 -
 arch/parisc/configs/generic-64bit_defconfig |   1 -
 arch/powerpc/configs/ppc6xx_defconfig       |   1 -
 arch/s390/configs/debug_defconfig           |   1 -
 arch/s390/configs/defconfig                 |   1 -
 arch/sh/configs/sh2007_defconfig            |   1 -
 arch/sparc/configs/sparc64_defconfig        |   1 -
 crypto/Kconfig                              |   9 -
 crypto/Makefile                             |   1 -
 crypto/fcrypt.c                             | 420 --------------------
 crypto/tcrypt.c                             |   4 -
 crypto/testmgr.c                            |  15 -
 crypto/testmgr.h                            |  45 ---
 39 files changed, 527 deletions(-)
 delete mode 100644 crypto/fcrypt.c

diff --git a/arch/arm/configs/pxa_defconfig b/arch/arm/configs/pxa_defconfig
index c51ae373ca88..53f1e5820c49 100644
--- a/arch/arm/configs/pxa_defconfig
+++ b/arch/arm/configs/pxa_defconfig
@@ -638,11 +638,10 @@ CONFIG_CRYPTO_CRYPTD=m
 CONFIG_CRYPTO_AUTHENC=m
 CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
-CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SEED=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
diff --git a/arch/m68k/configs/amiga_defconfig b/arch/m68k/configs/amiga_defconfig
index 47e48c18e55c..ca45670a6af4 100644
--- a/arch/m68k/configs/amiga_defconfig
+++ b/arch/m68k/configs/amiga_defconfig
@@ -522,11 +522,10 @@ CONFIG_CRYPTO_ARIA=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAMELLIA=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
 CONFIG_CRYPTO_DES=m
-CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SEED=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_SM4_GENERIC=m
 CONFIG_CRYPTO_TEA=m
diff --git a/arch/m68k/configs/apollo_defconfig b/arch/m68k/configs/apollo_defconfig
index 161586d611ab..2732a5b8b694 100644
--- a/arch/m68k/configs/apollo_defconfig
+++ b/arch/m68k/configs/apollo_defconfig
@@ -477,11 +477,10 @@ CONFIG_CRYPTO_ARIA=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAMELLIA=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
 CONFIG_CRYPTO_DES=m
-CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SEED=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_SM4_GENERIC=m
 CONFIG_CRYPTO_TEA=m
diff --git a/arch/m68k/configs/atari_defconfig b/arch/m68k/configs/atari_defconfig
index c13c6deeac22..242882b05fa4 100644
--- a/arch/m68k/configs/atari_defconfig
+++ b/arch/m68k/configs/atari_defconfig
@@ -499,11 +499,10 @@ CONFIG_CRYPTO_ARIA=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAMELLIA=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
 CONFIG_CRYPTO_DES=m
-CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SEED=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_SM4_GENERIC=m
 CONFIG_CRYPTO_TEA=m
diff --git a/arch/m68k/configs/bvme6000_defconfig b/arch/m68k/configs/bvme6000_defconfig
index d4f3f94b61ff..07e73c78a9e2 100644
--- a/arch/m68k/configs/bvme6000_defconfig
+++ b/arch/m68k/configs/bvme6000_defconfig
@@ -469,11 +469,10 @@ CONFIG_CRYPTO_ARIA=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAMELLIA=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
 CONFIG_CRYPTO_DES=m
-CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SEED=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_SM4_GENERIC=m
 CONFIG_CRYPTO_TEA=m
diff --git a/arch/m68k/configs/hp300_defconfig b/arch/m68k/configs/hp300_defconfig
index 58288f83349d..7188948da864 100644
--- a/arch/m68k/configs/hp300_defconfig
+++ b/arch/m68k/configs/hp300_defconfig
@@ -479,11 +479,10 @@ CONFIG_CRYPTO_ARIA=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAMELLIA=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
 CONFIG_CRYPTO_DES=m
-CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SEED=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_SM4_GENERIC=m
 CONFIG_CRYPTO_TEA=m
diff --git a/arch/m68k/configs/mac_defconfig b/arch/m68k/configs/mac_defconfig
index abb369fd1f55..fa5b04d59aa6 100644
--- a/arch/m68k/configs/mac_defconfig
+++ b/arch/m68k/configs/mac_defconfig
@@ -498,11 +498,10 @@ CONFIG_CRYPTO_ARIA=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAMELLIA=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
 CONFIG_CRYPTO_DES=m
-CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SEED=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_SM4_GENERIC=m
 CONFIG_CRYPTO_TEA=m
diff --git a/arch/m68k/configs/multi_defconfig b/arch/m68k/configs/multi_defconfig
index cb8de979700f..3bc9911549c0 100644
--- a/arch/m68k/configs/multi_defconfig
+++ b/arch/m68k/configs/multi_defconfig
@@ -585,11 +585,10 @@ CONFIG_CRYPTO_ARIA=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAMELLIA=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
 CONFIG_CRYPTO_DES=m
-CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SEED=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_SM4_GENERIC=m
 CONFIG_CRYPTO_TEA=m
diff --git a/arch/m68k/configs/mvme147_defconfig b/arch/m68k/configs/mvme147_defconfig
index 176540bd5074..9f5c8e0a07f3 100644
--- a/arch/m68k/configs/mvme147_defconfig
+++ b/arch/m68k/configs/mvme147_defconfig
@@ -469,11 +469,10 @@ CONFIG_CRYPTO_ARIA=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAMELLIA=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
 CONFIG_CRYPTO_DES=m
-CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SEED=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_SM4_GENERIC=m
 CONFIG_CRYPTO_TEA=m
diff --git a/arch/m68k/configs/mvme16x_defconfig b/arch/m68k/configs/mvme16x_defconfig
index 8b2e5cf4d2f2..e5a6299aeae0 100644
--- a/arch/m68k/configs/mvme16x_defconfig
+++ b/arch/m68k/configs/mvme16x_defconfig
@@ -470,11 +470,10 @@ CONFIG_CRYPTO_ARIA=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAMELLIA=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
 CONFIG_CRYPTO_DES=m
-CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SEED=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_SM4_GENERIC=m
 CONFIG_CRYPTO_TEA=m
diff --git a/arch/m68k/configs/q40_defconfig b/arch/m68k/configs/q40_defconfig
index d48f3cf5285b..e79bbb397261 100644
--- a/arch/m68k/configs/q40_defconfig
+++ b/arch/m68k/configs/q40_defconfig
@@ -488,11 +488,10 @@ CONFIG_CRYPTO_ARIA=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAMELLIA=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
 CONFIG_CRYPTO_DES=m
-CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SEED=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_SM4_GENERIC=m
 CONFIG_CRYPTO_TEA=m
diff --git a/arch/m68k/configs/sun3_defconfig b/arch/m68k/configs/sun3_defconfig
index 0b96428f25d4..7aa76de5c472 100644
--- a/arch/m68k/configs/sun3_defconfig
+++ b/arch/m68k/configs/sun3_defconfig
@@ -467,11 +467,10 @@ CONFIG_CRYPTO_ARIA=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAMELLIA=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
 CONFIG_CRYPTO_DES=m
-CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SEED=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_SM4_GENERIC=m
 CONFIG_CRYPTO_TEA=m
diff --git a/arch/m68k/configs/sun3x_defconfig b/arch/m68k/configs/sun3x_defconfig
index 6140e18244a1..2ecd8bd097ea 100644
--- a/arch/m68k/configs/sun3x_defconfig
+++ b/arch/m68k/configs/sun3x_defconfig
@@ -467,11 +467,10 @@ CONFIG_CRYPTO_ARIA=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAMELLIA=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
 CONFIG_CRYPTO_DES=m
-CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SEED=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_SM4_GENERIC=m
 CONFIG_CRYPTO_TEA=m
diff --git a/arch/mips/configs/bigsur_defconfig b/arch/mips/configs/bigsur_defconfig
index aa63ada62e28..74c6821e4c37 100644
--- a/arch/mips/configs/bigsur_defconfig
+++ b/arch/mips/configs/bigsur_defconfig
@@ -217,11 +217,10 @@ CONFIG_CRYPTO_SHA512=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAMELLIA=m
 CONFIG_CRYPTO_CAST6=m
-CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SEED=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
diff --git a/arch/mips/configs/decstation_64_defconfig b/arch/mips/configs/decstation_64_defconfig
index 7c43352fac6b..e98d218ed4c1 100644
--- a/arch/mips/configs/decstation_64_defconfig
+++ b/arch/mips/configs/decstation_64_defconfig
@@ -187,11 +187,10 @@ CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAMELLIA=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
-CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SEED=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
diff --git a/arch/mips/configs/decstation_defconfig b/arch/mips/configs/decstation_defconfig
index aee10274f048..2b4e06cc238b 100644
--- a/arch/mips/configs/decstation_defconfig
+++ b/arch/mips/configs/decstation_defconfig
@@ -182,11 +182,10 @@ CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAMELLIA=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
-CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SEED=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
diff --git a/arch/mips/configs/decstation_r4k_defconfig b/arch/mips/configs/decstation_r4k_defconfig
index a1698049aa7a..280553269156 100644
--- a/arch/mips/configs/decstation_r4k_defconfig
+++ b/arch/mips/configs/decstation_r4k_defconfig
@@ -182,11 +182,10 @@ CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAMELLIA=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
-CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SEED=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
diff --git a/arch/mips/configs/ip22_defconfig b/arch/mips/configs/ip22_defconfig
index e123848f94ab..50895ed06592 100644
--- a/arch/mips/configs/ip22_defconfig
+++ b/arch/mips/configs/ip22_defconfig
@@ -315,11 +315,10 @@ CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAMELLIA=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
-CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SEED=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
diff --git a/arch/mips/configs/ip27_defconfig b/arch/mips/configs/ip27_defconfig
index fea0ccee6948..ff7e06b92f58 100644
--- a/arch/mips/configs/ip27_defconfig
+++ b/arch/mips/configs/ip27_defconfig
@@ -307,11 +307,10 @@ CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAMELLIA=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
-CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SEED=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
diff --git a/arch/mips/configs/ip30_defconfig b/arch/mips/configs/ip30_defconfig
index 718f3060d9fa..d9f748f8cfaa 100644
--- a/arch/mips/configs/ip30_defconfig
+++ b/arch/mips/configs/ip30_defconfig
@@ -164,11 +164,10 @@ CONFIG_SECURITYFS=y
 CONFIG_CRYPTO_CRYPTD=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAMELLIA=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
-CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_CTS=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_PCBC=m
diff --git a/arch/mips/configs/ip32_defconfig b/arch/mips/configs/ip32_defconfig
index 9020c309dcda..4b15f895be63 100644
--- a/arch/mips/configs/ip32_defconfig
+++ b/arch/mips/configs/ip32_defconfig
@@ -167,11 +167,10 @@ CONFIG_CRYPTO_ARC4=y
 CONFIG_CRYPTO_BLOWFISH=y
 CONFIG_CRYPTO_CAMELLIA=y
 CONFIG_CRYPTO_CAST5=y
 CONFIG_CRYPTO_CAST6=y
 CONFIG_CRYPTO_DES=y
-CONFIG_CRYPTO_FCRYPT=y
 CONFIG_CRYPTO_KHAZAD=y
 CONFIG_CRYPTO_SERPENT=y
 CONFIG_CRYPTO_TEA=y
 CONFIG_CRYPTO_TWOFISH=y
 CONFIG_CRYPTO_DEFLATE=y
diff --git a/arch/mips/configs/lemote2f_defconfig b/arch/mips/configs/lemote2f_defconfig
index b9f3e1641105..bbcdfc8134cb 100644
--- a/arch/mips/configs/lemote2f_defconfig
+++ b/arch/mips/configs/lemote2f_defconfig
@@ -299,11 +299,10 @@ CONFIG_CRYPTO_CRYPTD=m
 CONFIG_CRYPTO_BENCHMARK=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAMELLIA=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
-CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_LRW=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_XTS=m
diff --git a/arch/mips/configs/malta_defconfig b/arch/mips/configs/malta_defconfig
index 81704ec67f09..85e781607299 100644
--- a/arch/mips/configs/malta_defconfig
+++ b/arch/mips/configs/malta_defconfig
@@ -397,10 +397,9 @@ CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAMELLIA=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
-CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
diff --git a/arch/mips/configs/malta_kvm_defconfig b/arch/mips/configs/malta_kvm_defconfig
index 82a97f58bce1..2db5f50fed3b 100644
--- a/arch/mips/configs/malta_kvm_defconfig
+++ b/arch/mips/configs/malta_kvm_defconfig
@@ -404,11 +404,10 @@ CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAMELLIA=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
-CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_RCU_CPU_STALL_TIMEOUT=60
diff --git a/arch/mips/configs/maltaup_xpa_defconfig b/arch/mips/configs/maltaup_xpa_defconfig
index 0f9ef20744f9..865ae23bf11d 100644
--- a/arch/mips/configs/maltaup_xpa_defconfig
+++ b/arch/mips/configs/maltaup_xpa_defconfig
@@ -403,10 +403,9 @@ CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAMELLIA=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
-CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
diff --git a/arch/mips/configs/rm200_defconfig b/arch/mips/configs/rm200_defconfig
index ad9fbd0cbb38..7e04a6b1b4eb 100644
--- a/arch/mips/configs/rm200_defconfig
+++ b/arch/mips/configs/rm200_defconfig
@@ -378,10 +378,9 @@ CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAMELLIA=m
 CONFIG_CRYPTO_CAST6=m
-CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
diff --git a/arch/mips/configs/sb1250_swarm_defconfig b/arch/mips/configs/sb1250_swarm_defconfig
index 4a25b8d3e507..fe8a5a3ff328 100644
--- a/arch/mips/configs/sb1250_swarm_defconfig
+++ b/arch/mips/configs/sb1250_swarm_defconfig
@@ -90,11 +90,10 @@ CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAMELLIA=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
 CONFIG_CRYPTO_DES=m
-CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TWOFISH=m
 CONFIG_CRYPTO_DEFLATE=m
 CONFIG_CRYPTO_LZO=m
 # CONFIG_CRYPTO_HW is not set
diff --git a/arch/parisc/configs/generic-64bit_defconfig b/arch/parisc/configs/generic-64bit_defconfig
index 0c4d54df9cf0..0503b4ef4c7a 100644
--- a/arch/parisc/configs/generic-64bit_defconfig
+++ b/arch/parisc/configs/generic-64bit_defconfig
@@ -279,11 +279,10 @@ CONFIG_NLS_CODEPAGE_1250=m
 CONFIG_NLS_CODEPAGE_1251=m
 CONFIG_NLS_ASCII=m
 CONFIG_NLS_ISO8859_1=m
 CONFIG_NLS_ISO8859_2=m
 CONFIG_NLS_UTF8=m
-CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_ECB=m
 CONFIG_CRYPTO_PCBC=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_DEFLATE=m
diff --git a/arch/powerpc/configs/ppc6xx_defconfig b/arch/powerpc/configs/ppc6xx_defconfig
index ccabc6e17168..7258ad903774 100644
--- a/arch/powerpc/configs/ppc6xx_defconfig
+++ b/arch/powerpc/configs/ppc6xx_defconfig
@@ -1061,11 +1061,10 @@ CONFIG_CRYPTO_SHA512=m
 CONFIG_CRYPTO_WP512=m
 CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAMELLIA=m
 CONFIG_CRYPTO_CAST6=m
-CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SEED=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
index c28f9a7d0bd8..b69f626b7cce 100644
--- a/arch/s390/configs/debug_defconfig
+++ b/arch/s390/configs/debug_defconfig
@@ -774,11 +774,10 @@ CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_ARIA=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
 CONFIG_CRYPTO_DES=m
-CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SEED=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_SM4_GENERIC=m
 CONFIG_CRYPTO_TEA=m
diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
index d89c988f33ea..9ea820882fdf 100644
--- a/arch/s390/configs/defconfig
+++ b/arch/s390/configs/defconfig
@@ -758,11 +758,10 @@ CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_ARIA=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
 CONFIG_CRYPTO_DES=m
-CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SEED=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_SM4_GENERIC=m
 CONFIG_CRYPTO_TEA=m
diff --git a/arch/sh/configs/sh2007_defconfig b/arch/sh/configs/sh2007_defconfig
index 5d9080499485..4a67f9c85806 100644
--- a/arch/sh/configs/sh2007_defconfig
+++ b/arch/sh/configs/sh2007_defconfig
@@ -180,11 +180,10 @@ CONFIG_CRYPTO_ANUBIS=y
 CONFIG_CRYPTO_ARC4=y
 CONFIG_CRYPTO_BLOWFISH=y
 CONFIG_CRYPTO_CAMELLIA=y
 CONFIG_CRYPTO_CAST5=y
 CONFIG_CRYPTO_CAST6=y
-CONFIG_CRYPTO_FCRYPT=y
 CONFIG_CRYPTO_KHAZAD=y
 CONFIG_CRYPTO_SEED=y
 CONFIG_CRYPTO_SERPENT=y
 CONFIG_CRYPTO_TEA=y
 CONFIG_CRYPTO_TWOFISH=y
diff --git a/arch/sparc/configs/sparc64_defconfig b/arch/sparc/configs/sparc64_defconfig
index 632081a262ba..c6009ebc806d 100644
--- a/arch/sparc/configs/sparc64_defconfig
+++ b/arch/sparc/configs/sparc64_defconfig
@@ -218,11 +218,10 @@ CONFIG_CRYPTO_AES=m
 CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_BLOWFISH=m
 CONFIG_CRYPTO_CAMELLIA=m
 CONFIG_CRYPTO_CAST5=m
 CONFIG_CRYPTO_CAST6=m
-CONFIG_CRYPTO_FCRYPT=m
 CONFIG_CRYPTO_KHAZAD=m
 CONFIG_CRYPTO_SEED=m
 CONFIG_CRYPTO_SERPENT=m
 CONFIG_CRYPTO_TEA=m
 CONFIG_CRYPTO_TWOFISH=m
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 103d1f58cb7c..0727cd5877da 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -462,19 +462,10 @@ config CRYPTO_DES
 	help
 	  DES (Data Encryption Standard)(FIPS 46-2, ISO/IEC 18033-3) and
 	  Triple DES EDE (Encrypt/Decrypt/Encrypt) (FIPS 46-3, ISO/IEC 18033-3)
 	  cipher algorithms
 
-config CRYPTO_FCRYPT
-	tristate "FCrypt"
-	select CRYPTO_ALGAPI
-	select CRYPTO_SKCIPHER
-	help
-	  FCrypt algorithm used by RxRPC
-
-	  See https://ota.polyonymo.us/fcrypt-paper.txt
-
 config CRYPTO_KHAZAD
 	tristate "Khazad"
 	depends on CRYPTO_USER_API_ENABLE_OBSOLETE
 	select CRYPTO_ALGAPI
 	help
diff --git a/crypto/Makefile b/crypto/Makefile
index 162242593c7c..1827f84192e6 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -124,11 +124,10 @@ endif
 CFLAGS_aegis128-neon-inner.o += -isystem $(shell $(CC) -print-file-name=include)
 
 obj-$(CONFIG_CRYPTO_PCRYPT) += pcrypt.o
 obj-$(CONFIG_CRYPTO_CRYPTD) += cryptd.o
 obj-$(CONFIG_CRYPTO_DES) += des_generic.o
-obj-$(CONFIG_CRYPTO_FCRYPT) += fcrypt.o
 obj-$(CONFIG_CRYPTO_BLOWFISH) += blowfish_generic.o
 obj-$(CONFIG_CRYPTO_BLOWFISH_COMMON) += blowfish_common.o
 obj-$(CONFIG_CRYPTO_TWOFISH) += twofish_generic.o
 obj-$(CONFIG_CRYPTO_TWOFISH_COMMON) += twofish_common.o
 obj-$(CONFIG_CRYPTO_SERPENT) += serpent_generic.o
diff --git a/crypto/fcrypt.c b/crypto/fcrypt.c
deleted file mode 100644
index 80036835cec5..000000000000
--- a/crypto/fcrypt.c
+++ /dev/null
@@ -1,420 +0,0 @@
-/* FCrypt encryption algorithm
- *
- * Copyright (C) 2006 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- *
- * Based on code:
- *
- * Copyright (c) 1995 - 2000 Kungliga Tekniska Högskolan
- * (Royal Institute of Technology, Stockholm, Sweden).
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- * 1. Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- *
- * 2. Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in the
- *    documentation and/or other materials provided with the distribution.
- *
- * 3. Neither the name of the Institute nor the names of its contributors
- *    may be used to endorse or promote products derived from this software
- *    without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE INSTITUTE AND CONTRIBUTORS ``AS IS'' AND
- * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
- * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
- * ARE DISCLAIMED.  IN NO EVENT SHALL THE INSTITUTE OR CONTRIBUTORS BE LIABLE
- * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
- * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
- * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
- * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
- * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
- * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
- * SUCH DAMAGE.
- */
-
-#include <asm/byteorder.h>
-#include <crypto/algapi.h>
-#include <linux/bitops.h>
-#include <linux/init.h>
-#include <linux/module.h>
-
-#define ROUNDS 16
-
-struct fcrypt_ctx {
-	__be32 sched[ROUNDS];
-};
-
-/* Rotate right two 32 bit numbers as a 56 bit number */
-#define ror56(hi, lo, n)					\
-do {								\
-	u32 t = lo & ((1 << n) - 1);				\
-	lo = (lo >> n) | ((hi & ((1 << n) - 1)) << (32 - n));	\
-	hi = (hi >> n) | (t << (24-n));				\
-} while (0)
-
-/* Rotate right one 64 bit number as a 56 bit number */
-#define ror56_64(k, n) (k = (k >> n) | ((k & ((1 << n) - 1)) << (56 - n)))
-
-/*
- * Sboxes for Feistel network derived from
- * /afs/transarc.com/public/afsps/afs.rel31b.export-src/rxkad/sboxes.h
- */
-#undef Z
-#define Z(x) cpu_to_be32(x << 3)
-static const __be32 sbox0[256] = {
-	Z(0xea), Z(0x7f), Z(0xb2), Z(0x64), Z(0x9d), Z(0xb0), Z(0xd9), Z(0x11),
-	Z(0xcd), Z(0x86), Z(0x86), Z(0x91), Z(0x0a), Z(0xb2), Z(0x93), Z(0x06),
-	Z(0x0e), Z(0x06), Z(0xd2), Z(0x65), Z(0x73), Z(0xc5), Z(0x28), Z(0x60),
-	Z(0xf2), Z(0x20), Z(0xb5), Z(0x38), Z(0x7e), Z(0xda), Z(0x9f), Z(0xe3),
-	Z(0xd2), Z(0xcf), Z(0xc4), Z(0x3c), Z(0x61), Z(0xff), Z(0x4a), Z(0x4a),
-	Z(0x35), Z(0xac), Z(0xaa), Z(0x5f), Z(0x2b), Z(0xbb), Z(0xbc), Z(0x53),
-	Z(0x4e), Z(0x9d), Z(0x78), Z(0xa3), Z(0xdc), Z(0x09), Z(0x32), Z(0x10),
-	Z(0xc6), Z(0x6f), Z(0x66), Z(0xd6), Z(0xab), Z(0xa9), Z(0xaf), Z(0xfd),
-	Z(0x3b), Z(0x95), Z(0xe8), Z(0x34), Z(0x9a), Z(0x81), Z(0x72), Z(0x80),
-	Z(0x9c), Z(0xf3), Z(0xec), Z(0xda), Z(0x9f), Z(0x26), Z(0x76), Z(0x15),
-	Z(0x3e), Z(0x55), Z(0x4d), Z(0xde), Z(0x84), Z(0xee), Z(0xad), Z(0xc7),
-	Z(0xf1), Z(0x6b), Z(0x3d), Z(0xd3), Z(0x04), Z(0x49), Z(0xaa), Z(0x24),
-	Z(0x0b), Z(0x8a), Z(0x83), Z(0xba), Z(0xfa), Z(0x85), Z(0xa0), Z(0xa8),
-	Z(0xb1), Z(0xd4), Z(0x01), Z(0xd8), Z(0x70), Z(0x64), Z(0xf0), Z(0x51),
-	Z(0xd2), Z(0xc3), Z(0xa7), Z(0x75), Z(0x8c), Z(0xa5), Z(0x64), Z(0xef),
-	Z(0x10), Z(0x4e), Z(0xb7), Z(0xc6), Z(0x61), Z(0x03), Z(0xeb), Z(0x44),
-	Z(0x3d), Z(0xe5), Z(0xb3), Z(0x5b), Z(0xae), Z(0xd5), Z(0xad), Z(0x1d),
-	Z(0xfa), Z(0x5a), Z(0x1e), Z(0x33), Z(0xab), Z(0x93), Z(0xa2), Z(0xb7),
-	Z(0xe7), Z(0xa8), Z(0x45), Z(0xa4), Z(0xcd), Z(0x29), Z(0x63), Z(0x44),
-	Z(0xb6), Z(0x69), Z(0x7e), Z(0x2e), Z(0x62), Z(0x03), Z(0xc8), Z(0xe0),
-	Z(0x17), Z(0xbb), Z(0xc7), Z(0xf3), Z(0x3f), Z(0x36), Z(0xba), Z(0x71),
-	Z(0x8e), Z(0x97), Z(0x65), Z(0x60), Z(0x69), Z(0xb6), Z(0xf6), Z(0xe6),
-	Z(0x6e), Z(0xe0), Z(0x81), Z(0x59), Z(0xe8), Z(0xaf), Z(0xdd), Z(0x95),
-	Z(0x22), Z(0x99), Z(0xfd), Z(0x63), Z(0x19), Z(0x74), Z(0x61), Z(0xb1),
-	Z(0xb6), Z(0x5b), Z(0xae), Z(0x54), Z(0xb3), Z(0x70), Z(0xff), Z(0xc6),
-	Z(0x3b), Z(0x3e), Z(0xc1), Z(0xd7), Z(0xe1), Z(0x0e), Z(0x76), Z(0xe5),
-	Z(0x36), Z(0x4f), Z(0x59), Z(0xc7), Z(0x08), Z(0x6e), Z(0x82), Z(0xa6),
-	Z(0x93), Z(0xc4), Z(0xaa), Z(0x26), Z(0x49), Z(0xe0), Z(0x21), Z(0x64),
-	Z(0x07), Z(0x9f), Z(0x64), Z(0x81), Z(0x9c), Z(0xbf), Z(0xf9), Z(0xd1),
-	Z(0x43), Z(0xf8), Z(0xb6), Z(0xb9), Z(0xf1), Z(0x24), Z(0x75), Z(0x03),
-	Z(0xe4), Z(0xb0), Z(0x99), Z(0x46), Z(0x3d), Z(0xf5), Z(0xd1), Z(0x39),
-	Z(0x72), Z(0x12), Z(0xf6), Z(0xba), Z(0x0c), Z(0x0d), Z(0x42), Z(0x2e)
-};
-
-#undef Z
-#define Z(x) cpu_to_be32(((x & 0x1f) << 27) | (x >> 5))
-static const __be32 sbox1[256] = {
-	Z(0x77), Z(0x14), Z(0xa6), Z(0xfe), Z(0xb2), Z(0x5e), Z(0x8c), Z(0x3e),
-	Z(0x67), Z(0x6c), Z(0xa1), Z(0x0d), Z(0xc2), Z(0xa2), Z(0xc1), Z(0x85),
-	Z(0x6c), Z(0x7b), Z(0x67), Z(0xc6), Z(0x23), Z(0xe3), Z(0xf2), Z(0x89),
-	Z(0x50), Z(0x9c), Z(0x03), Z(0xb7), Z(0x73), Z(0xe6), Z(0xe1), Z(0x39),
-	Z(0x31), Z(0x2c), Z(0x27), Z(0x9f), Z(0xa5), Z(0x69), Z(0x44), Z(0xd6),
-	Z(0x23), Z(0x83), Z(0x98), Z(0x7d), Z(0x3c), Z(0xb4), Z(0x2d), Z(0x99),
-	Z(0x1c), Z(0x1f), Z(0x8c), Z(0x20), Z(0x03), Z(0x7c), Z(0x5f), Z(0xad),
-	Z(0xf4), Z(0xfa), Z(0x95), Z(0xca), Z(0x76), Z(0x44), Z(0xcd), Z(0xb6),
-	Z(0xb8), Z(0xa1), Z(0xa1), Z(0xbe), Z(0x9e), Z(0x54), Z(0x8f), Z(0x0b),
-	Z(0x16), Z(0x74), Z(0x31), Z(0x8a), Z(0x23), Z(0x17), Z(0x04), Z(0xfa),
-	Z(0x79), Z(0x84), Z(0xb1), Z(0xf5), Z(0x13), Z(0xab), Z(0xb5), Z(0x2e),
-	Z(0xaa), Z(0x0c), Z(0x60), Z(0x6b), Z(0x5b), Z(0xc4), Z(0x4b), Z(0xbc),
-	Z(0xe2), Z(0xaf), Z(0x45), Z(0x73), Z(0xfa), Z(0xc9), Z(0x49), Z(0xcd),
-	Z(0x00), Z(0x92), Z(0x7d), Z(0x97), Z(0x7a), Z(0x18), Z(0x60), Z(0x3d),
-	Z(0xcf), Z(0x5b), Z(0xde), Z(0xc6), Z(0xe2), Z(0xe6), Z(0xbb), Z(0x8b),
-	Z(0x06), Z(0xda), Z(0x08), Z(0x15), Z(0x1b), Z(0x88), Z(0x6a), Z(0x17),
-	Z(0x89), Z(0xd0), Z(0xa9), Z(0xc1), Z(0xc9), Z(0x70), Z(0x6b), Z(0xe5),
-	Z(0x43), Z(0xf4), Z(0x68), Z(0xc8), Z(0xd3), Z(0x84), Z(0x28), Z(0x0a),
-	Z(0x52), Z(0x66), Z(0xa3), Z(0xca), Z(0xf2), Z(0xe3), Z(0x7f), Z(0x7a),
-	Z(0x31), Z(0xf7), Z(0x88), Z(0x94), Z(0x5e), Z(0x9c), Z(0x63), Z(0xd5),
-	Z(0x24), Z(0x66), Z(0xfc), Z(0xb3), Z(0x57), Z(0x25), Z(0xbe), Z(0x89),
-	Z(0x44), Z(0xc4), Z(0xe0), Z(0x8f), Z(0x23), Z(0x3c), Z(0x12), Z(0x52),
-	Z(0xf5), Z(0x1e), Z(0xf4), Z(0xcb), Z(0x18), Z(0x33), Z(0x1f), Z(0xf8),
-	Z(0x69), Z(0x10), Z(0x9d), Z(0xd3), Z(0xf7), Z(0x28), Z(0xf8), Z(0x30),
-	Z(0x05), Z(0x5e), Z(0x32), Z(0xc0), Z(0xd5), Z(0x19), Z(0xbd), Z(0x45),
-	Z(0x8b), Z(0x5b), Z(0xfd), Z(0xbc), Z(0xe2), Z(0x5c), Z(0xa9), Z(0x96),
-	Z(0xef), Z(0x70), Z(0xcf), Z(0xc2), Z(0x2a), Z(0xb3), Z(0x61), Z(0xad),
-	Z(0x80), Z(0x48), Z(0x81), Z(0xb7), Z(0x1d), Z(0x43), Z(0xd9), Z(0xd7),
-	Z(0x45), Z(0xf0), Z(0xd8), Z(0x8a), Z(0x59), Z(0x7c), Z(0x57), Z(0xc1),
-	Z(0x79), Z(0xc7), Z(0x34), Z(0xd6), Z(0x43), Z(0xdf), Z(0xe4), Z(0x78),
-	Z(0x16), Z(0x06), Z(0xda), Z(0x92), Z(0x76), Z(0x51), Z(0xe1), Z(0xd4),
-	Z(0x70), Z(0x03), Z(0xe0), Z(0x2f), Z(0x96), Z(0x91), Z(0x82), Z(0x80)
-};
-
-#undef Z
-#define Z(x) cpu_to_be32(x << 11)
-static const __be32 sbox2[256] = {
-	Z(0xf0), Z(0x37), Z(0x24), Z(0x53), Z(0x2a), Z(0x03), Z(0x83), Z(0x86),
-	Z(0xd1), Z(0xec), Z(0x50), Z(0xf0), Z(0x42), Z(0x78), Z(0x2f), Z(0x6d),
-	Z(0xbf), Z(0x80), Z(0x87), Z(0x27), Z(0x95), Z(0xe2), Z(0xc5), Z(0x5d),
-	Z(0xf9), Z(0x6f), Z(0xdb), Z(0xb4), Z(0x65), Z(0x6e), Z(0xe7), Z(0x24),
-	Z(0xc8), Z(0x1a), Z(0xbb), Z(0x49), Z(0xb5), Z(0x0a), Z(0x7d), Z(0xb9),
-	Z(0xe8), Z(0xdc), Z(0xb7), Z(0xd9), Z(0x45), Z(0x20), Z(0x1b), Z(0xce),
-	Z(0x59), Z(0x9d), Z(0x6b), Z(0xbd), Z(0x0e), Z(0x8f), Z(0xa3), Z(0xa9),
-	Z(0xbc), Z(0x74), Z(0xa6), Z(0xf6), Z(0x7f), Z(0x5f), Z(0xb1), Z(0x68),
-	Z(0x84), Z(0xbc), Z(0xa9), Z(0xfd), Z(0x55), Z(0x50), Z(0xe9), Z(0xb6),
-	Z(0x13), Z(0x5e), Z(0x07), Z(0xb8), Z(0x95), Z(0x02), Z(0xc0), Z(0xd0),
-	Z(0x6a), Z(0x1a), Z(0x85), Z(0xbd), Z(0xb6), Z(0xfd), Z(0xfe), Z(0x17),
-	Z(0x3f), Z(0x09), Z(0xa3), Z(0x8d), Z(0xfb), Z(0xed), Z(0xda), Z(0x1d),
-	Z(0x6d), Z(0x1c), Z(0x6c), Z(0x01), Z(0x5a), Z(0xe5), Z(0x71), Z(0x3e),
-	Z(0x8b), Z(0x6b), Z(0xbe), Z(0x29), Z(0xeb), Z(0x12), Z(0x19), Z(0x34),
-	Z(0xcd), Z(0xb3), Z(0xbd), Z(0x35), Z(0xea), Z(0x4b), Z(0xd5), Z(0xae),
-	Z(0x2a), Z(0x79), Z(0x5a), Z(0xa5), Z(0x32), Z(0x12), Z(0x7b), Z(0xdc),
-	Z(0x2c), Z(0xd0), Z(0x22), Z(0x4b), Z(0xb1), Z(0x85), Z(0x59), Z(0x80),
-	Z(0xc0), Z(0x30), Z(0x9f), Z(0x73), Z(0xd3), Z(0x14), Z(0x48), Z(0x40),
-	Z(0x07), Z(0x2d), Z(0x8f), Z(0x80), Z(0x0f), Z(0xce), Z(0x0b), Z(0x5e),
-	Z(0xb7), Z(0x5e), Z(0xac), Z(0x24), Z(0x94), Z(0x4a), Z(0x18), Z(0x15),
-	Z(0x05), Z(0xe8), Z(0x02), Z(0x77), Z(0xa9), Z(0xc7), Z(0x40), Z(0x45),
-	Z(0x89), Z(0xd1), Z(0xea), Z(0xde), Z(0x0c), Z(0x79), Z(0x2a), Z(0x99),
-	Z(0x6c), Z(0x3e), Z(0x95), Z(0xdd), Z(0x8c), Z(0x7d), Z(0xad), Z(0x6f),
-	Z(0xdc), Z(0xff), Z(0xfd), Z(0x62), Z(0x47), Z(0xb3), Z(0x21), Z(0x8a),
-	Z(0xec), Z(0x8e), Z(0x19), Z(0x18), Z(0xb4), Z(0x6e), Z(0x3d), Z(0xfd),
-	Z(0x74), Z(0x54), Z(0x1e), Z(0x04), Z(0x85), Z(0xd8), Z(0xbc), Z(0x1f),
-	Z(0x56), Z(0xe7), Z(0x3a), Z(0x56), Z(0x67), Z(0xd6), Z(0xc8), Z(0xa5),
-	Z(0xf3), Z(0x8e), Z(0xde), Z(0xae), Z(0x37), Z(0x49), Z(0xb7), Z(0xfa),
-	Z(0xc8), Z(0xf4), Z(0x1f), Z(0xe0), Z(0x2a), Z(0x9b), Z(0x15), Z(0xd1),
-	Z(0x34), Z(0x0e), Z(0xb5), Z(0xe0), Z(0x44), Z(0x78), Z(0x84), Z(0x59),
-	Z(0x56), Z(0x68), Z(0x77), Z(0xa5), Z(0x14), Z(0x06), Z(0xf5), Z(0x2f),
-	Z(0x8c), Z(0x8a), Z(0x73), Z(0x80), Z(0x76), Z(0xb4), Z(0x10), Z(0x86)
-};
-
-#undef Z
-#define Z(x) cpu_to_be32(x << 19)
-static const __be32 sbox3[256] = {
-	Z(0xa9), Z(0x2a), Z(0x48), Z(0x51), Z(0x84), Z(0x7e), Z(0x49), Z(0xe2),
-	Z(0xb5), Z(0xb7), Z(0x42), Z(0x33), Z(0x7d), Z(0x5d), Z(0xa6), Z(0x12),
-	Z(0x44), Z(0x48), Z(0x6d), Z(0x28), Z(0xaa), Z(0x20), Z(0x6d), Z(0x57),
-	Z(0xd6), Z(0x6b), Z(0x5d), Z(0x72), Z(0xf0), Z(0x92), Z(0x5a), Z(0x1b),
-	Z(0x53), Z(0x80), Z(0x24), Z(0x70), Z(0x9a), Z(0xcc), Z(0xa7), Z(0x66),
-	Z(0xa1), Z(0x01), Z(0xa5), Z(0x41), Z(0x97), Z(0x41), Z(0x31), Z(0x82),
-	Z(0xf1), Z(0x14), Z(0xcf), Z(0x53), Z(0x0d), Z(0xa0), Z(0x10), Z(0xcc),
-	Z(0x2a), Z(0x7d), Z(0xd2), Z(0xbf), Z(0x4b), Z(0x1a), Z(0xdb), Z(0x16),
-	Z(0x47), Z(0xf6), Z(0x51), Z(0x36), Z(0xed), Z(0xf3), Z(0xb9), Z(0x1a),
-	Z(0xa7), Z(0xdf), Z(0x29), Z(0x43), Z(0x01), Z(0x54), Z(0x70), Z(0xa4),
-	Z(0xbf), Z(0xd4), Z(0x0b), Z(0x53), Z(0x44), Z(0x60), Z(0x9e), Z(0x23),
-	Z(0xa1), Z(0x18), Z(0x68), Z(0x4f), Z(0xf0), Z(0x2f), Z(0x82), Z(0xc2),
-	Z(0x2a), Z(0x41), Z(0xb2), Z(0x42), Z(0x0c), Z(0xed), Z(0x0c), Z(0x1d),
-	Z(0x13), Z(0x3a), Z(0x3c), Z(0x6e), Z(0x35), Z(0xdc), Z(0x60), Z(0x65),
-	Z(0x85), Z(0xe9), Z(0x64), Z(0x02), Z(0x9a), Z(0x3f), Z(0x9f), Z(0x87),
-	Z(0x96), Z(0xdf), Z(0xbe), Z(0xf2), Z(0xcb), Z(0xe5), Z(0x6c), Z(0xd4),
-	Z(0x5a), Z(0x83), Z(0xbf), Z(0x92), Z(0x1b), Z(0x94), Z(0x00), Z(0x42),
-	Z(0xcf), Z(0x4b), Z(0x00), Z(0x75), Z(0xba), Z(0x8f), Z(0x76), Z(0x5f),
-	Z(0x5d), Z(0x3a), Z(0x4d), Z(0x09), Z(0x12), Z(0x08), Z(0x38), Z(0x95),
-	Z(0x17), Z(0xe4), Z(0x01), Z(0x1d), Z(0x4c), Z(0xa9), Z(0xcc), Z(0x85),
-	Z(0x82), Z(0x4c), Z(0x9d), Z(0x2f), Z(0x3b), Z(0x66), Z(0xa1), Z(0x34),
-	Z(0x10), Z(0xcd), Z(0x59), Z(0x89), Z(0xa5), Z(0x31), Z(0xcf), Z(0x05),
-	Z(0xc8), Z(0x84), Z(0xfa), Z(0xc7), Z(0xba), Z(0x4e), Z(0x8b), Z(0x1a),
-	Z(0x19), Z(0xf1), Z(0xa1), Z(0x3b), Z(0x18), Z(0x12), Z(0x17), Z(0xb0),
-	Z(0x98), Z(0x8d), Z(0x0b), Z(0x23), Z(0xc3), Z(0x3a), Z(0x2d), Z(0x20),
-	Z(0xdf), Z(0x13), Z(0xa0), Z(0xa8), Z(0x4c), Z(0x0d), Z(0x6c), Z(0x2f),
-	Z(0x47), Z(0x13), Z(0x13), Z(0x52), Z(0x1f), Z(0x2d), Z(0xf5), Z(0x79),
-	Z(0x3d), Z(0xa2), Z(0x54), Z(0xbd), Z(0x69), Z(0xc8), Z(0x6b), Z(0xf3),
-	Z(0x05), Z(0x28), Z(0xf1), Z(0x16), Z(0x46), Z(0x40), Z(0xb0), Z(0x11),
-	Z(0xd3), Z(0xb7), Z(0x95), Z(0x49), Z(0xcf), Z(0xc3), Z(0x1d), Z(0x8f),
-	Z(0xd8), Z(0xe1), Z(0x73), Z(0xdb), Z(0xad), Z(0xc8), Z(0xc9), Z(0xa9),
-	Z(0xa1), Z(0xc2), Z(0xc5), Z(0xe3), Z(0xba), Z(0xfc), Z(0x0e), Z(0x25)
-};
-
-/*
- * This is a 16 round Feistel network with permutation F_ENCRYPT
- */
-#define F_ENCRYPT(R, L, sched)						\
-do {									\
-	union lc4 { __be32 l; u8 c[4]; } u;				\
-	u.l = sched ^ R;						\
-	L ^= sbox0[u.c[0]] ^ sbox1[u.c[1]] ^ sbox2[u.c[2]] ^ sbox3[u.c[3]]; \
-} while (0)
-
-/*
- * encryptor
- */
-static void fcrypt_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
-{
-	const struct fcrypt_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct {
-		__be32 l, r;
-	} X;
-
-	memcpy(&X, src, sizeof(X));
-
-	F_ENCRYPT(X.r, X.l, ctx->sched[0x0]);
-	F_ENCRYPT(X.l, X.r, ctx->sched[0x1]);
-	F_ENCRYPT(X.r, X.l, ctx->sched[0x2]);
-	F_ENCRYPT(X.l, X.r, ctx->sched[0x3]);
-	F_ENCRYPT(X.r, X.l, ctx->sched[0x4]);
-	F_ENCRYPT(X.l, X.r, ctx->sched[0x5]);
-	F_ENCRYPT(X.r, X.l, ctx->sched[0x6]);
-	F_ENCRYPT(X.l, X.r, ctx->sched[0x7]);
-	F_ENCRYPT(X.r, X.l, ctx->sched[0x8]);
-	F_ENCRYPT(X.l, X.r, ctx->sched[0x9]);
-	F_ENCRYPT(X.r, X.l, ctx->sched[0xa]);
-	F_ENCRYPT(X.l, X.r, ctx->sched[0xb]);
-	F_ENCRYPT(X.r, X.l, ctx->sched[0xc]);
-	F_ENCRYPT(X.l, X.r, ctx->sched[0xd]);
-	F_ENCRYPT(X.r, X.l, ctx->sched[0xe]);
-	F_ENCRYPT(X.l, X.r, ctx->sched[0xf]);
-
-	memcpy(dst, &X, sizeof(X));
-}
-
-/*
- * decryptor
- */
-static void fcrypt_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
-{
-	const struct fcrypt_ctx *ctx = crypto_tfm_ctx(tfm);
-	struct {
-		__be32 l, r;
-	} X;
-
-	memcpy(&X, src, sizeof(X));
-
-	F_ENCRYPT(X.l, X.r, ctx->sched[0xf]);
-	F_ENCRYPT(X.r, X.l, ctx->sched[0xe]);
-	F_ENCRYPT(X.l, X.r, ctx->sched[0xd]);
-	F_ENCRYPT(X.r, X.l, ctx->sched[0xc]);
-	F_ENCRYPT(X.l, X.r, ctx->sched[0xb]);
-	F_ENCRYPT(X.r, X.l, ctx->sched[0xa]);
-	F_ENCRYPT(X.l, X.r, ctx->sched[0x9]);
-	F_ENCRYPT(X.r, X.l, ctx->sched[0x8]);
-	F_ENCRYPT(X.l, X.r, ctx->sched[0x7]);
-	F_ENCRYPT(X.r, X.l, ctx->sched[0x6]);
-	F_ENCRYPT(X.l, X.r, ctx->sched[0x5]);
-	F_ENCRYPT(X.r, X.l, ctx->sched[0x4]);
-	F_ENCRYPT(X.l, X.r, ctx->sched[0x3]);
-	F_ENCRYPT(X.r, X.l, ctx->sched[0x2]);
-	F_ENCRYPT(X.l, X.r, ctx->sched[0x1]);
-	F_ENCRYPT(X.r, X.l, ctx->sched[0x0]);
-
-	memcpy(dst, &X, sizeof(X));
-}
-
-/*
- * Generate a key schedule from key, the least significant bit in each key byte
- * is parity and shall be ignored. This leaves 56 significant bits in the key
- * to scatter over the 16 key schedules. For each schedule extract the low
- * order 32 bits and use as schedule, then rotate right by 11 bits.
- */
-static int fcrypt_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int keylen)
-{
-	struct fcrypt_ctx *ctx = crypto_tfm_ctx(tfm);
-
-#if BITS_PER_LONG == 64  /* the 64-bit version can also be used for 32-bit
-			  * kernels - it seems to be faster but the code is
-			  * larger */
-
-	u64 k;	/* k holds all 56 non-parity bits */
-
-	/* discard the parity bits */
-	k = (*key++) >> 1;
-	k <<= 7;
-	k |= (*key++) >> 1;
-	k <<= 7;
-	k |= (*key++) >> 1;
-	k <<= 7;
-	k |= (*key++) >> 1;
-	k <<= 7;
-	k |= (*key++) >> 1;
-	k <<= 7;
-	k |= (*key++) >> 1;
-	k <<= 7;
-	k |= (*key++) >> 1;
-	k <<= 7;
-	k |= (*key) >> 1;
-
-	/* Use lower 32 bits for schedule, rotate by 11 each round (16 times) */
-	ctx->sched[0x0] = cpu_to_be32(k); ror56_64(k, 11);
-	ctx->sched[0x1] = cpu_to_be32(k); ror56_64(k, 11);
-	ctx->sched[0x2] = cpu_to_be32(k); ror56_64(k, 11);
-	ctx->sched[0x3] = cpu_to_be32(k); ror56_64(k, 11);
-	ctx->sched[0x4] = cpu_to_be32(k); ror56_64(k, 11);
-	ctx->sched[0x5] = cpu_to_be32(k); ror56_64(k, 11);
-	ctx->sched[0x6] = cpu_to_be32(k); ror56_64(k, 11);
-	ctx->sched[0x7] = cpu_to_be32(k); ror56_64(k, 11);
-	ctx->sched[0x8] = cpu_to_be32(k); ror56_64(k, 11);
-	ctx->sched[0x9] = cpu_to_be32(k); ror56_64(k, 11);
-	ctx->sched[0xa] = cpu_to_be32(k); ror56_64(k, 11);
-	ctx->sched[0xb] = cpu_to_be32(k); ror56_64(k, 11);
-	ctx->sched[0xc] = cpu_to_be32(k); ror56_64(k, 11);
-	ctx->sched[0xd] = cpu_to_be32(k); ror56_64(k, 11);
-	ctx->sched[0xe] = cpu_to_be32(k); ror56_64(k, 11);
-	ctx->sched[0xf] = cpu_to_be32(k);
-
-	return 0;
-#else
-	u32 hi, lo;		/* hi is upper 24 bits and lo lower 32, total 56 */
-
-	/* discard the parity bits */
-	lo = (*key++) >> 1;
-	lo <<= 7;
-	lo |= (*key++) >> 1;
-	lo <<= 7;
-	lo |= (*key++) >> 1;
-	lo <<= 7;
-	lo |= (*key++) >> 1;
-	hi = lo >> 4;
-	lo &= 0xf;
-	lo <<= 7;
-	lo |= (*key++) >> 1;
-	lo <<= 7;
-	lo |= (*key++) >> 1;
-	lo <<= 7;
-	lo |= (*key++) >> 1;
-	lo <<= 7;
-	lo |= (*key) >> 1;
-
-	/* Use lower 32 bits for schedule, rotate by 11 each round (16 times) */
-	ctx->sched[0x0] = cpu_to_be32(lo); ror56(hi, lo, 11);
-	ctx->sched[0x1] = cpu_to_be32(lo); ror56(hi, lo, 11);
-	ctx->sched[0x2] = cpu_to_be32(lo); ror56(hi, lo, 11);
-	ctx->sched[0x3] = cpu_to_be32(lo); ror56(hi, lo, 11);
-	ctx->sched[0x4] = cpu_to_be32(lo); ror56(hi, lo, 11);
-	ctx->sched[0x5] = cpu_to_be32(lo); ror56(hi, lo, 11);
-	ctx->sched[0x6] = cpu_to_be32(lo); ror56(hi, lo, 11);
-	ctx->sched[0x7] = cpu_to_be32(lo); ror56(hi, lo, 11);
-	ctx->sched[0x8] = cpu_to_be32(lo); ror56(hi, lo, 11);
-	ctx->sched[0x9] = cpu_to_be32(lo); ror56(hi, lo, 11);
-	ctx->sched[0xa] = cpu_to_be32(lo); ror56(hi, lo, 11);
-	ctx->sched[0xb] = cpu_to_be32(lo); ror56(hi, lo, 11);
-	ctx->sched[0xc] = cpu_to_be32(lo); ror56(hi, lo, 11);
-	ctx->sched[0xd] = cpu_to_be32(lo); ror56(hi, lo, 11);
-	ctx->sched[0xe] = cpu_to_be32(lo); ror56(hi, lo, 11);
-	ctx->sched[0xf] = cpu_to_be32(lo);
-	return 0;
-#endif
-}
-
-static struct crypto_alg fcrypt_alg = {
-	.cra_name		=	"fcrypt",
-	.cra_driver_name	=	"fcrypt-generic",
-	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
-	.cra_blocksize		=	8,
-	.cra_ctxsize		=	sizeof(struct fcrypt_ctx),
-	.cra_module		=	THIS_MODULE,
-	.cra_u			=	{ .cipher = {
-	.cia_min_keysize	=	8,
-	.cia_max_keysize	=	8,
-	.cia_setkey		=	fcrypt_setkey,
-	.cia_encrypt		=	fcrypt_encrypt,
-	.cia_decrypt		=	fcrypt_decrypt } }
-};
-
-static int __init fcrypt_mod_init(void)
-{
-	return crypto_register_alg(&fcrypt_alg);
-}
-
-static void __exit fcrypt_mod_fini(void)
-{
-	crypto_unregister_alg(&fcrypt_alg);
-}
-
-module_init(fcrypt_mod_init);
-module_exit(fcrypt_mod_fini);
-
-MODULE_LICENSE("Dual BSD/GPL");
-MODULE_DESCRIPTION("FCrypt Cipher Algorithm");
-MODULE_AUTHOR("David Howells <dhowells@redhat.com>");
-MODULE_ALIAS_CRYPTO("fcrypt");
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index e54517605f5f..61a2501bfe9b 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1598,14 +1598,10 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 
 	case 30:
 		ret = min(ret, tcrypt_test("ecb(xeta)"));
 		break;
 
-	case 31:
-		ret = min(ret, tcrypt_test("pcbc(fcrypt)"));
-		break;
-
 	case 32:
 		ret = min(ret, tcrypt_test("ecb(camellia)"));
 		ret = min(ret, tcrypt_test("cbc(camellia)"));
 		ret = min(ret, tcrypt_test("ctr(camellia)"));
 		ret = min(ret, tcrypt_test("lrw(camellia)"));
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 4d86efae65b2..f392d97fc469 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4825,19 +4825,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.alg = "ecb(des3_ede)",
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = __VECS(des3_ede_tv_template)
 		}
-	}, {
-		.alg = "ecb(fcrypt)",
-		.test = alg_test_skcipher,
-		.suite = {
-			.cipher = {
-				.vecs = fcrypt_pcbc_tv_template,
-				.count = 1
-			}
-		}
 	}, {
 		.alg = "ecb(khazad)",
 		.test = alg_test_skcipher,
 		.suite = {
 			.cipher = __VECS(khazad_tv_template)
@@ -5252,16 +5243,10 @@ static const struct alg_test_desc alg_test_descs[] = {
 	}, {
 		.alg = "p1363(ecdsa-nist-p521)",
 		.test = alg_test_null,
 		.fips_allowed = 1,
 	}, {
-		.alg = "pcbc(fcrypt)",
-		.test = alg_test_skcipher,
-		.suite = {
-			.cipher = __VECS(fcrypt_pcbc_tv_template)
-		}
-	}, {
 #if IS_ENABLED(CONFIG_CRYPTO_PHMAC_S390)
 		.alg = "phmac(sha224)",
 		.test = alg_test_hash,
 		.fips_allowed = 1,
 		.suite = {
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 9b4d7e11c9fd..3f0600bd9c05 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -25066,55 +25066,10 @@ static const struct cipher_testvec xeta_tv_template[] = {
 			  "\xea\xa5\x6a\x85\xd1\xf4\xa8\xa5",
 		.len	= 32,
 	}
 };
 
-/*
- * FCrypt test vectors
- */
-static const struct cipher_testvec fcrypt_pcbc_tv_template[] = {
-	{ /* http://www.openafs.org/pipermail/openafs-devel/2000-December/005320.html */
-		.key	= "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.klen	= 8,
-		.iv	= "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.ptext	= "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.ctext	= "\x0E\x09\x00\xC7\x3E\xF7\xED\x41",
-		.len	= 8,
-	}, {
-		.key	= "\x11\x44\x77\xAA\xDD\x00\x33\x66",
-		.klen	= 8,
-		.iv	= "\x00\x00\x00\x00\x00\x00\x00\x00",
-		.ptext	= "\x12\x34\x56\x78\x9A\xBC\xDE\xF0",
-		.ctext	= "\xD8\xED\x78\x74\x77\xEC\x06\x80",
-		.len	= 8,
-	}, { /* From Arla */
-		.key	= "\xf0\xe1\xd2\xc3\xb4\xa5\x96\x87",
-		.klen	= 8,
-		.iv	= "\xfe\xdc\xba\x98\x76\x54\x32\x10",
-		.ptext	= "The quick brown fox jumps over the lazy dogs.\0\0",
-		.ctext	= "\x00\xf0\x0e\x11\x75\xe6\x23\x82"
-			  "\xee\xac\x98\x62\x44\x51\xe4\x84"
-			  "\xc3\x59\xd8\xaa\x64\x60\xae\xf7"
-			  "\xd2\xd9\x13\x79\x72\xa3\x45\x03"
-			  "\x23\xb5\x62\xd7\x0c\xf5\x27\xd1"
-			  "\xf8\x91\x3c\xac\x44\x22\x92\xef",
-		.len	= 48,
-	}, {
-		.key	= "\xfe\xdc\xba\x98\x76\x54\x32\x10",
-		.klen	= 8,
-		.iv	= "\xf0\xe1\xd2\xc3\xb4\xa5\x96\x87",
-		.ptext	= "The quick brown fox jumps over the lazy dogs.\0\0",
-		.ctext	= "\xca\x90\xf5\x9d\xcb\xd4\xd2\x3c"
-			  "\x01\x88\x7f\x3e\x31\x6e\x62\x9d"
-			  "\xd8\xe0\x57\xa3\x06\x3a\x42\x58"
-			  "\x2a\x28\xfe\x72\x52\x2f\xdd\xe0"
-			  "\x19\x89\x09\x1c\x2a\x8e\x8c\x94"
-			  "\xfc\xc7\x68\xe4\x88\xaa\xde\x0f",
-		.len	= 48,
-	}
-};
-
 /*
  * CAMELLIA test vectors.
  */
 static const struct hash_testvec camellia_cmac128_tv_template[] = {
 	{ /* From draft-kato-ipsec-camellia-cmac96and128-01 */
-- 
2.54.0

