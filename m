Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5FE1A00E7
	for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2024 13:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728888; cv=none; b=QorcoM61dqZAWoBeFzVIYRqfoBxmVRk/bDTNjb9Z0rEHhcaLx4dvaNJyt+awUckYo5nYmGsT6jzRr23kTjfmpvQWlIqad0b3QNgbudCjfce2rZTS0fU6Z7BRI57UxCSMB59HCh3X12Dlgul45OF/IpoP5DuNTw/uI0QhP5LiSFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728888; c=relaxed/simple;
	bh=GSmbhNEtJKlVj6umc3y0ZnpaLV7wkyHaVSTfECdJRzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N66SYTQSDti1/08mguoPJUJ+gUrd+vbdVH5rkxZANCl4BkEP5wGX7vnDt6c6bpNfSt9rnuRqHyo9VXzR0ETI8/EuhHJR9zfvUh45QuettHv+t1FU56D32Jcevg2jV7uGnQJJSWD+XSojZl7qZVP2jDatpK/wotWX+R8z6SRpKF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=CvzciSvW; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="CvzciSvW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1723728887;
	bh=GSmbhNEtJKlVj6umc3y0ZnpaLV7wkyHaVSTfECdJRzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CvzciSvWIhId3MJ4p35ORBfSM2vvcgX0UeGa7P2keL45wYTZuNRxrx4BD4nau32pI
	 2DRjNp8HkZzdmHJb3fPyIO0TM3P73AE3QJJw87j7HOkKNRuDCFO3FowaHEL1bgen+v
	 AUOj1ywemtj5ECYHotjIcQMiHT7Nuy/yXx8Vw2/o=
Received: from stargazer.. (unknown [IPv6:240e:456:1030:181:abd4:6e7f:e826:ac0f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 02B5F66F26;
	Thu, 15 Aug 2024 09:34:40 -0400 (EDT)
From: Xi Ruoyao <xry111@xry111.site>
To: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>
Cc: linux-crypto@vger.kernel.org,
	loongarch@lists.linux.dev,
	Jinyang He <hejinyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Arnd Bergmann <arnd@arndb.de>,
	Xi Ruoyao <xry111@xry111.site>
Subject: [PATCH v2 1/2] LoongArch: Perform alternative runtime patching on vDSO
Date: Thu, 15 Aug 2024 21:33:56 +0800
Message-ID: <20240815133357.35829-2-xry111@xry111.site>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815133357.35829-1-xry111@xry111.site>
References: <20240815133357.35829-1-xry111@xry111.site>
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
index 90dfccb41c14..d606ddf65b97 100644
--- a/arch/loongarch/kernel/vdso.c
+++ b/arch/loongarch/kernel/vdso.c
@@ -17,6 +17,7 @@
 #include <linux/time_namespace.h>
 #include <linux/timekeeper_internal.h>
 
+#include <asm/alternative.h>
 #include <asm/page.h>
 #include <asm/vdso.h>
 #include <vdso/helpers.h>
@@ -99,7 +100,7 @@ struct loongarch_vdso_info vdso_info = {
 
 static int __init init_vdso(void)
 {
-	unsigned long i, cpu, pfn;
+	unsigned long i, cpu, pfn, vdso;
 
 	BUG_ON(!PAGE_ALIGNED(vdso_info.vdso));
 	BUG_ON(!PAGE_ALIGNED(vdso_info.size));
@@ -111,6 +112,11 @@ static int __init init_vdso(void)
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
index 56ad855896de..746d31bd4e90 100644
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

