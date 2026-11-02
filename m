Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.202.192.35
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793619611;
	b=X/JhuojYFBSTFrEcyuoEbU39kIxO4CdM2CwkHQ1pvOzZ8O6I6VpWgHNst0sG/NF21Pmw
	 4N/uQTxmCFSMrPxrkriXTNK2gB4SaTwRyJdrM3VUqhjvGG55XXfxbsoGO6rKKrU5eVriX
	 02o6XSUaEXJ6o+ESYQxif2DYng81cB+FC6pcbJ37ZadD+Y6L2AbujcH+3WKhqFJeAGfqi
	 hW0UpzvZ/Z8xRqzr+2CVeIc5WHJrctIB/sQO2yhSveWbFa6a2+D0e4mBnsha81nd+gexT
	 bR7oV8sP+e4cgZrzcgtlDP3yjbFoFE740TnSbuwpkXDCVehSObXJXTEZmcaemvjjR8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793619611;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Received:From:To:Cc:
	 Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=6mAYvJKwDCcIUAopmkZI6/KWN92g5bQX0j++JR6bRII=;
	b=QzcziNCQPbBn23NgTCBuMz5HqMJbKQX7v8lJcJW+DeNBS+UZgkgs+xdisPE9Rne2ab1h
	 SZvJtYXPwq3MLl1bi2c4iDDujtN5XSsWzMpONJnVDhF9GGzJ26z8TZi3Pcienc3h1AAFm
	 1h7dhZhuzUx7pGgcte8Gr7pPvdeNyQZwLKqFS2cN2Qt3i1Zgrc+aoJO34SHeweU9WuJh2
	 ERSj/1iKxaA/gQn8/sh5iwpyjASsuXBEu98pvIex2XyDLwMOenezL8P0XcGVmyKYyt31R
	 XzXa2GaaqZkP8pbgMv45dATTZ5Z8iUwsmmMfwT4FmT7cVEPKpKA49X2J5b/3F/IC/dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=strongswan.org;
	spf=pass smtp.mailfrom=strongswan.org;
	dkim=pass header.d=strongswan.org header.i=@strongswan.org header.a=rsa-sha256 header.s=default header.b=inKJP3Ew;
	arc=none smtp.remote-ip=109.202.192.35
Received: from mail.codelabs.ch (mail.codelabs.ch [109.202.192.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2DE606A32C
	for <linux-crypto@vger.kernel.org>; Mon,  2 Nov 2026 11:40:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D2DE606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=strongswan.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strongswan.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=strongswan.org header.i=@strongswan.org header.a=rsa-sha256 header.s=default header.b=inKJP3Ew
Received: from localhost (localhost [127.0.0.1])
	by mail.codelabs.ch (Postfix) with ESMTP id 680975A0009;
	Mon, 02 Nov 2026 12:39:57 +0100 (CET)
Received: from mail.codelabs.ch ([127.0.0.1])
 by localhost (fenrir.codelabs.ch [127.0.0.1]) (amavis, port 10024) with ESMTP
 id Ulj0apsi5Dll; Mon,  2 Nov 2026 12:39:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=strongswan.org;
	s=default; t=1793619596;
	bh=WG2y8HlndVuSnMenXa6EqbII/P9oFW45H2jH/bJDR8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=inKJP3EwfKMP4oCPOs3ks700yNynFgx2ZeB+U0QU97CwBKDfVePs08BqdDj2KHdcA
	 +6XHpBg0JAEto22WMhM3LdmhIK+Z5a9rA51GlInBjAyqAid968MNG1lWQLSKiKijST
	 XpSlqak3wIf+TJvWQ3AfVjCPSUUg+0qzcCyJLk5awJGDtmaGStILd8+wVNp9i8GCzf
	 OQp4VQq1x0w2FUxgJULLdJXWdfIv1W1GKtepajj4xphlm2gnYsYD6jNx1pC0nZcBLd
	 Uhec5htTiRvjzTjFj2s+AVhUqOyvjKxZBcVkR6LwQseiXYpxVALqIcaLMGlmi4Loz3
	 jViDEIiOdQQ9g==
Received: from ee00200a.home (unknown [185.12.128.224])
	by mail.codelabs.ch (Postfix) with ESMTPSA id 4DB455A0005;
	Mon, 02 Nov 2026 12:39:56 +0100 (CET)
From: Martin Willi <martin@strongswan.org>
To: Eric Biggers <ebiggers@kernel.org>,
	linux-crypto@vger.kernel.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Antonio Quartulli <antonio@mandelbit.com>
Subject: [PATCH v2 1/3] lib/crypto: x86/chacha: Rename the AVX-512VL assembly file
Date: Mon,  2 Nov 2026 12:39:24 +0100
Message-ID: <20261102113926.2765176-2-martin@strongswan.org>
In-Reply-To: <20261102113926.2765176-1-martin@strongswan.org>
References: <20261102113926.2765176-1-martin@strongswan.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The file is going to hold a 16-block function on 512-bit zmm registers,
which does not depend on the VL extension. So rename it to
chacha-avx512-x86_64.S and drop VL from its header comment.

Signed-off-by: Martin Willi <martin@strongswan.org>
---
 lib/crypto/Makefile                                             | 2 +-
 .../x86/{chacha-avx512vl-x86_64.S => chacha-avx512-x86_64.S}    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
 rename lib/crypto/x86/{chacha-avx512vl-x86_64.S => chacha-avx512-x86_64.S} (99%)

diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 126e72419ebb..171b926afc39 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -129,7 +129,7 @@ libchacha-$(CONFIG_RISCV) += riscv/chacha-riscv64-zvkb.o
 libchacha-$(CONFIG_S390) += s390/chacha-s390.o
 libchacha-$(CONFIG_X86) += x86/chacha-ssse3-x86_64.o \
 			   x86/chacha-avx2-x86_64.o \
-			   x86/chacha-avx512vl-x86_64.o
+			   x86/chacha-avx512-x86_64.o
 endif # CONFIG_CRYPTO_LIB_CHACHA_ARCH
 
 ################################################################################
diff --git a/lib/crypto/x86/chacha-avx512vl-x86_64.S b/lib/crypto/x86/chacha-avx512-x86_64.S
similarity index 99%
rename from lib/crypto/x86/chacha-avx512vl-x86_64.S
rename to lib/crypto/x86/chacha-avx512-x86_64.S
index 259383e1ad44..cf784e148bdf 100644
--- a/lib/crypto/x86/chacha-avx512vl-x86_64.S
+++ b/lib/crypto/x86/chacha-avx512-x86_64.S
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * ChaCha 256-bit cipher algorithm, x64 AVX-512VL functions
+ * ChaCha 256-bit cipher algorithm, x64 AVX-512 functions
  *
  * Copyright (C) 2018 Martin Willi
  */
-- 
2.53.0

