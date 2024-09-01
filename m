Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109A313B58D;
	Sun,  1 Sep 2024 06:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725171250; cv=none; b=gFeCUEWBb7qXgIGrjazHclyWOUYJBYV6qhNAYXIWp6VY0u3I8Ig39/8OybLTqgjWbRIj0zXf1RfA06z0EwXDEEGlI3uSd2yt2pUJuR7gCFdPRL9XqBhmfcwouMDfZhB5as7OU3YqueAEJ8TXUZnWQbzniNnjrL2VjzarfGacNuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725171250; c=relaxed/simple;
	bh=QFb4MaQg3SHhJHLScZg2HV6RZkn894nB6X22QplYIOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHEScxN3KewVSbLVWpZ/EWDAm0ks1hb4sG7WvZQskvDNeAaH0Ebv7GYlA8luQaXM8hSfl2Pvdmt72SPgnMNFgR6lmDOTwbyHWp9p4CPFcn4n1zANvrFXulfGcdIEgVFrsNNbNzzCrdS7MY4A102MvwPjR8WAmMz8o8TXxseCu2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Received: from stargazer.. (unknown [IPv6:240e:358:11b0:f100:dc73:854d:832e:2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 562BA1A3FE1;
	Sun,  1 Sep 2024 02:14:02 -0400 (EDT)
From: Xi Ruoyao <xry111@xry111.site>
To: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>
Cc: Xi Ruoyao <xry111@xry111.site>,
	linux-crypto@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Jinyang He <hejinyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v6 3/3] selftests/vDSO: Enable vdso getrandom tests for LoongArch
Date: Sun,  1 Sep 2024 14:13:12 +0800
Message-ID: <20240901061315.15693-4-xry111@xry111.site>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901061315.15693-1-xry111@xry111.site>
References: <20240901061315.15693-1-xry111@xry111.site>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Create the symlink to the arch/loongarch/vdso directory, and correctly
set the ARCH variable for LoongArch.

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
index 5ead6b1f0478..c992fe8dbf55 100644
--- a/tools/testing/selftests/vDSO/Makefile
+++ b/tools/testing/selftests/vDSO/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-ARCH ?= $(shell uname -m | sed -e s/i.86/x86/)
+ARCH ?= $(shell uname -m | sed -e s/i.86/x86/ -e /loongarch/s/[0-9]//g)
 SRCARCH := $(subst x86_64,x86,$(ARCH))
 
 TEST_GEN_PROGS := vdso_test_gettimeofday
@@ -10,7 +10,7 @@ ifeq ($(ARCH),$(filter $(ARCH),x86 x86_64))
 TEST_GEN_PROGS += vdso_standalone_test_x86
 endif
 TEST_GEN_PROGS += vdso_test_correctness
-ifeq ($(ARCH),$(filter $(ARCH),x86_64))
+ifeq ($(ARCH),$(filter $(ARCH),x86_64 loongarch))
 TEST_GEN_PROGS += vdso_test_getrandom
 TEST_GEN_PROGS += vdso_test_chacha
 endif
-- 
2.46.0

