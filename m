Received: from mailout3.hostsharing.net (mailout3.hostsharing.net [144.76.133.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8BF35C1B6;
	Wed,  8 Apr 2026 06:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.133.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775628972; cv=none; b=cWizhg4mpG+Wl/C59HVOhg2zQhJKdmPiq2AJP36V/Aue4SHanL/20RRWIIOKJVt30TTy9ckyYHstjOhpv/w4d5X1pPfqskvrEg4vZwpNK4soZswD5o42i1lK9QVUnTgDNq65XHFKFBM4HYdfIC+kA1dLRBN83HHBKR/4tOCElBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775628972; c=relaxed/simple;
	bh=3dA5L01qEbPR0BYS0ADg4PgEjpsP5vA5/M4ysAUqwlU=;
	h=Message-ID:From:Date:Subject:To:Cc; b=iwz6u01sIo/FPQxu7q9PETtKtBS7RVycjOOgfu0VLmPI74a+Z+X6dtCBMEEjhdxdMGUIzVhKR40N2zEhzNt2QdbdAAXanX07TXdtpXdKnSWFi7sitpeUQMdYxB7F3Z9bi3dd4KfCKwTsJERaZgcxlyQtcwfgCWrJRymuXELETlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de; spf=pass smtp.mailfrom=wunner.de; arc=none smtp.client-ip=144.76.133.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wunner.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wunner.de
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384
	 client-signature ECDSA (secp384r1) client-digest SHA384)
	(Client CN "*.hostsharing.net", Issuer "GlobalSign GCC R6 AlphaSSL CA 2025" (verified OK))
	by mailout3.hostsharing.net (Postfix) with ESMTPS id D8CB7C06;
	Wed, 08 Apr 2026 08:16:05 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
	id A1F2C60CF552; Wed,  8 Apr 2026 08:16:05 +0200 (CEST)
Message-ID: <abfaede9ab2e963d784fb70598ed74935f7f8d93.1775628469.git.lukas@wunner.de>
From: Lukas Wunner <lukas@wunner.de>
Date: Wed, 8 Apr 2026 08:15:49 +0200
Subject: [PATCH] crypto: ecc - Unbreak the build on arm with
 CONFIG_KASAN_STACK=y
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Ignat Korchagin <ignat@linux.win>, Stefan Berger <stefanb@linux.ibm.com>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Andrew reports the following build breakage of arm allmodconfig,
reproducible with gcc 14.2.0 and 15.2.0:

  crypto/ecc.c: In function 'ecc_point_mult':
  crypto/ecc.c:1380:1: error: the frame size of 1360 bytes is larger than 1280 bytes [-Werror=frame-larger-than=]

gcc excessively inlines functions called by ecc_point_mult() (without
there being any explicit inline declarations) and doesn't seem smart
enough to stay below CONFIG_FRAME_WARN.

clang does not exhibit the issue.

The issue only occurs with CONFIG_KASAN_STACK=y because it enlarges the
frame size.  This has been a controversial topic a couple of times:

https://lore.kernel.org/r/CAK8P3a3_Tdc-XVPXrJ69j3S9048uzmVJGrNcvi0T6yr6OrHkPw@mail.gmail.com/

Prevent gcc from going overboard with inlining to unbreak the build.
The maximum inline limit to avoid the error is 101.  Use 100 to get a
nice round number per Andrew's preference.

Reported-by: Andrew Morton <akpm@linux-foundation.org> # off-list
Signed-off-by: Lukas Wunner <lukas@wunner.de>
---
 crypto/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/crypto/Makefile b/crypto/Makefile
index 04e269117589..b3ac7f29153e 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -181,6 +181,11 @@ obj-$(CONFIG_CRYPTO_ZSTD) += zstd.o
 obj-$(CONFIG_CRYPTO_ECC) += ecc.o
 obj-$(CONFIG_CRYPTO_ESSIV) += essiv.o
 
+# Avoid exceeding stack frame due to excessive gcc inlining in ecc_point_mult()
+ifeq ($(ARCH)$(CONFIG_KASAN_STACK)$(LLVM),army)
+CFLAGS_ecc.o += $(call cc-option,-finline-limit=100)
+endif
+
 ecdh_generic-y += ecdh.o
 ecdh_generic-y += ecdh_helper.o
 obj-$(CONFIG_CRYPTO_ECDH) += ecdh_generic.o
-- 
2.51.0

