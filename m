Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE7E198E7E
	for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2024 11:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723806506; cv=none; b=dq8YMYxXo7/mOsUpE08B/a1IJchkuPh6gqXILJJoF2Ldui6+xHsGfxTpUD56U/PTHg2OK+QzLGKa3jOXi4jpnglQi15uaQlM8WXYrW6n1rKhCHfGUq0yDf6J9md5DaPIwiE7Q+llzb+X/wSGaRv3aiPzHsdyK05rm0U8yslrNUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723806506; c=relaxed/simple;
	bh=huVSt3hvB1YK7wxUMvdb+dL43EiEEO3UtFynjBvkLQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bmNf5Am8MknOZ1T3uZLaSAAuXcNuHQsVjkaka9JOwoDvHVXi8+exfyORODtH5Rwbi64tLW7BOogLQDAdKl1KPozkYkAdK3fqWzF06PYcBYX7DdljKcN26h+BWwu+aWHY7sXPLR5LSx5Lw66p2ntF8yRkL8BGilQ8YqlREKq1aLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=Rf9WnYLF; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="Rf9WnYLF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1723806504;
	bh=huVSt3hvB1YK7wxUMvdb+dL43EiEEO3UtFynjBvkLQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rf9WnYLF7dhpfGSPL3fanhdK5ixjzjhn5pozRh3h+jFRfQWPgJU2uMYuQzewavq9Y
	 NN+tT1K4JWKfa0mv7mp6++XFAck9L0eq03kYVZnrON/N4NFKpB0bWUMTr2Aqyzkq/0
	 wVcFANnVlp0jnDlMXALdaopmHFVbVUFQEdrx/tT0=
Received: from stargazer.. (unknown [IPv6:240e:457:1000:1603:4ab7:c07d:7ab1:44b2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 11D4266F26;
	Fri, 16 Aug 2024 07:08:18 -0400 (EDT)
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
Subject: [PATCH v3 2/3] LoongArch: Perform alternative runtime patching on vDSO
Date: Fri, 16 Aug 2024 19:07:15 +0800
Message-ID: <20240816110717.10249-3-xry111@xry111.site>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240816110717.10249-1-xry111@xry111.site>
References: <20240816110717.10249-1-xry111@xry111.site>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To implement getrandom() in vDSO, we need to implement stack-less
ChaCha20.  ChaCha20 is designed to be SIMD-friendly, but LSX is not
guaranteed to be available on all LoongArch CPU models.  Perform
alternative runtime patching on vDSO so we'll be able to use LSX in
vDSO.

Signed-off-by: Xi Ruoyao <xry111@xry111.site>
---
 arch/loongarch/kernel/vdso.c   | 8 +++++++-
 arch/loongarch/vdso/vdso.lds.S | 6 ++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/kernel/vdso.c b/arch/loongarch/kernel/vdso.c
index 15b65d8e2fdc..d500436f252b 100644
--- a/arch/loongarch/kernel/vdso.c
+++ b/arch/loongarch/kernel/vdso.c
@@ -17,6 +17,7 @@
 #include <linux/time_namespace.h>
 #include <linux/timekeeper_internal.h>
 
+#include <asm/alternative.h>
 #include <asm/page.h>
 #include <asm/vdso.h>
 #include <vdso/helpers.h>
@@ -105,7 +106,7 @@ struct loongarch_vdso_info vdso_info = {
 
 static int __init init_vdso(void)
 {
-	unsigned long i, cpu, pfn;
+	unsigned long i, cpu, pfn, vdso;
 
 	BUG_ON(!PAGE_ALIGNED(vdso_info.vdso));
 	BUG_ON(!PAGE_ALIGNED(vdso_info.size));
@@ -117,6 +118,11 @@ static int __init init_vdso(void)
 	for (i = 0; i < vdso_info.size / PAGE_SIZE; i++)
 		vdso_info.code_mapping.pages[i] = pfn_to_page(pfn + i);
 
+	vdso = (unsigned long)vdso_info.vdso;
+
+	apply_alternatives((struct alt_instr *)(vdso + vdso_offset_alt),
+			   (struct alt_instr *)(vdso + vdso_offset_alt_end));
+
 	return 0;
 }
 subsys_initcall(init_vdso);
diff --git a/arch/loongarch/vdso/vdso.lds.S b/arch/loongarch/vdso/vdso.lds.S
index 2c965a597d9e..ac63dc080bc9 100644
--- a/arch/loongarch/vdso/vdso.lds.S
+++ b/arch/loongarch/vdso/vdso.lds.S
@@ -35,6 +35,12 @@ SECTIONS
 
 	.rodata		: { *(.rodata*) }		:text
 
+	.altinstructions : ALIGN(4) {
+		VDSO_alt = .;
+		*(.altinstructions)
+		VDSO_alt_end = .;
+	} :text
+
 	_end = .;
 	PROVIDE(end = .);
 
-- 
2.46.0

