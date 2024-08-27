Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6FC1BD514
	for <linux-crypto@vger.kernel.org>; Tue, 27 Aug 2024 13:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724764844; cv=none; b=riEGcoFmjfH6rw/ufGhONS9FFt9NdoFtJ6OTmMrxsNmldtawQTY1wsH/a3VyOIY0XjACiFB39qffw5wtIyL91he190nxa7G1hHlt003kxgT30fuhEr335W5LvcJCb5h/uemUihDoYiX6oUb9W9DH3Z0VlwoUQxxLMSD6mZJ6Mdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724764844; c=relaxed/simple;
	bh=vSiHdjycb9BkOejRCco5hOWhYBDjhhf9CWN2DYr+Qls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yn12V4H597mbGXMZgGXk5LmpO9BXfcIq+Q/fPtGmlQfHesTtn0qOCkm77GdpBz0/3D4izPlNFM3Hc5VBn8pI5YAt/HEUBRYfZwqeI5HkhKrZURf+x1vqkgmPm/WKvC1CWxdszLs79eitIIpFUDrgEDDIXn9GbWHyWZ1jcEh6FD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=I1iEhgk3; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="I1iEhgk3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1724764842;
	bh=vSiHdjycb9BkOejRCco5hOWhYBDjhhf9CWN2DYr+Qls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I1iEhgk3TQ6bYZzWRRGWiVWwJhRxoBFFEoaB1Wt9+K8MK7Zp/BjFn2s31vZp6kk/V
	 t26lSgWME9+v5i99Ilp7rSk4rnlXwLpQ+WkGqa/VYnO/ic9SeeGc/7cCeFZApA5poW
	 OhOqdLhdUuFUBcQAUlGCTwdKsKXFpfvYi9nTyjak=
Received: from stargazer.. (unknown [113.200.174.85])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 66C8866F2A;
	Tue, 27 Aug 2024 09:20:39 -0400 (EDT)
From: Xi Ruoyao <xry111@xry111.site>
To: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>
Cc: Xi Ruoyao <xry111@xry111.site>,
	linux-crypto@vger.kernel.org,
	loongarch@lists.linux.dev,
	Jinyang He <hejinyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v4 4/4] selftests/vDSO: Enable vdso getrandom tests for LoongArch
Date: Tue, 27 Aug 2024 21:20:17 +0800
Message-ID: <20240827132018.88854-5-xry111@xry111.site>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827132018.88854-1-xry111@xry111.site>
References: <20240827132018.88854-1-xry111@xry111.site>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Create the symlink to the LoongArch vdso directory, and correct set ARCH
for LoongArch.

Signed-off-by: Xi Ruoyao <xry111@xry111.site>
---
 tools/arch/loongarch/vdso             | 1 +
 tools/testing/selftests/vDSO/Makefile | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)
 create mode 120000 tools/arch/loongarch/vdso

diff --git a/tools/arch/loongarch/vdso b/tools/arch/loongarch/vdso
new file mode 120000
index 000000000000..ebda43a82db7
--- /dev/null
+++ b/tools/arch/loongarch/vdso
@@ -0,0 +1 @@
+../../../arch/loongarch/vdso
\ No newline at end of file
diff --git a/tools/testing/selftests/vDSO/Makefile b/tools/testing/selftests/vDSO/Makefile
index e346890d4c91..2ad98afce111 100644
--- a/tools/testing/selftests/vDSO/Makefile
+++ b/tools/testing/selftests/vDSO/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 uname_M := $(shell uname -m 2>/dev/null || echo not)
-ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
+ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/x86/ -e s/x86_64/x86/ -e /loongarch/s/[0-9]//g)
 SODIUM := $(shell pkg-config --libs --cflags libsodium 2>/dev/null)
 
 TEST_GEN_PROGS := vdso_test_gettimeofday
@@ -11,7 +11,7 @@ ifeq ($(ARCH),$(filter $(ARCH),x86 x86_64))
 TEST_GEN_PROGS += vdso_standalone_test_x86
 endif
 TEST_GEN_PROGS += vdso_test_correctness
-ifeq ($(uname_M),x86_64)
+ifeq ($(uname_M),$(filter $(uname_M),x86_64 loongarch64))
 TEST_GEN_PROGS += vdso_test_getrandom
 ifneq ($(SODIUM),)
 TEST_GEN_PROGS += vdso_test_chacha
-- 
2.46.0

