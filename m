Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797CB1BFDED
	for <linux-crypto@vger.kernel.org>; Tue, 27 Aug 2024 13:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724764840; cv=none; b=nWoc4fXODOJWu0/Crqhp3ciLuBlzSd9Ato/ShCbjvKBlQs5KCrxk7F+l1JmyeYYKWTOL/nG+s6pFV+X6SpNfd4MDrY6pcw3WSgSKSRNFXXYrSg9h+lk1xrcJmrGta9vouHygCfm/kFPy82nVdd8jWsyJdtZw4AF0nYwAZKkpGzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724764840; c=relaxed/simple;
	bh=fXN8UG0rJUoY1dO0Gpv0JbKri/vi7HB4lr/7tQrm/vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uA0sjk5qNQGWKNcqehjfhAwTpLDUA2uFJcNpc+nAVJmKqCEKpce3FUFWHarAMqOuPOAWYbsncXiwaNyANd345Wu33iVQ8SHIHVDpOKaloxQf8RLcJEqZixVo3sZolshFtlsK1eAViP5kamKN//7ACJVyUbnt5YZtqtI3mCu3oL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=VFfZY4GO; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="VFfZY4GO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1724764839;
	bh=fXN8UG0rJUoY1dO0Gpv0JbKri/vi7HB4lr/7tQrm/vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VFfZY4GODMcSgswzEY/UCQZ892DeugZAaaXsrkmaAgIZchxDgp/pBm1HncUpJP6+h
	 Uu1c4Wd4f5Oy7fcWHX7vCyf82N9d+4Of3RjYTwXbv6+vBr11xwd0oHwpCL1ZB1Vv+N
	 AtcDrh+GKbSh+rUZE8Y33GqBFe6SZB2KWztEztdA=
Received: from stargazer.. (unknown [113.200.174.85])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 125DE66F29;
	Tue, 27 Aug 2024 09:20:35 -0400 (EDT)
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
Subject: [PATCH v4 3/4] selftests/vDSO: Use KHDR_INCLUDES to locate UAPI headers for vdso_test_getrandom
Date: Tue, 27 Aug 2024 21:20:16 +0800
Message-ID: <20240827132018.88854-4-xry111@xry111.site>
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

Building test_vdso_getrandom currently leads to following issue:

    In file included from /home/xry111/git-repos/linux/tools/include/linux/compiler_types.h:36,
                     from /home/xry111/git-repos/linux/include/uapi/linux/stddef.h:5,
                     from /home/xry111/git-repos/linux/include/uapi/linux/posix_types.h:5,
                     from /usr/include/asm/sigcontext.h:12,
                     from /usr/include/bits/sigcontext.h:30,
                     from /usr/include/signal.h:301,
                     from vdso_test_getrandom.c:14:
    /home/xry111/git-repos/linux/tools/include/linux/compiler-gcc.h:3:2: error: #error "Please don't include <linux/compiler-gcc.h> directly, include <linux/compiler.h> instead."
        3 | #error "Please don't include <linux/compiler-gcc.h> directly, include <linux/compiler.h> instead."
          |  ^~~~~

It's because the compiler_types.h inclusion in
include/uapi/linux/stddef.h is expected to be removed by the
header_install.sh script, as compiler_types.h shouldn't be used from the
user space.

Signed-off-by: Xi Ruoyao <xry111@xry111.site>
---
 tools/testing/selftests/vDSO/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vDSO/Makefile b/tools/testing/selftests/vDSO/Makefile
index 180854eb9fec..e346890d4c91 100644
--- a/tools/testing/selftests/vDSO/Makefile
+++ b/tools/testing/selftests/vDSO/Makefile
@@ -38,7 +38,7 @@ $(OUTPUT)/vdso_test_correctness: LDFLAGS += -ldl
 
 $(OUTPUT)/vdso_test_getrandom: parse_vdso.c
 $(OUTPUT)/vdso_test_getrandom: CFLAGS += -isystem $(top_srcdir)/tools/include \
-                                         -isystem $(top_srcdir)/include/uapi
+                                         $(KHDR_INCLUDES)
 
 $(OUTPUT)/vdso_test_chacha: $(top_srcdir)/tools/arch/$(ARCH)/vdso/vgetrandom-chacha.S
 $(OUTPUT)/vdso_test_chacha: CFLAGS += -idirafter $(top_srcdir)/tools/include \
-- 
2.46.0

