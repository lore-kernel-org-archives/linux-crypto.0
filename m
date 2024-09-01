Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40C0524B4;
	Sun,  1 Sep 2024 06:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725171238; cv=none; b=TB6QIsQpBwmQMkOYn8vrZLIBWHMXThw3OVag4DU4kWLsAxlFMsiUX0HuDZXmlDrrD2PllqvZLX5oOC+eNpSZ1Nzif+0xn0Y5YqIGlpI81dRq/4gVW2l8EN3tigI+wwmHxLK0jDGSYfjMsumwfONyHl3QOy5aAplyOpWWasrKJPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725171238; c=relaxed/simple;
	bh=dwxKp4a2baTzLJelYswz7WwU5A4oJrOlV7SPaBtCC3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+eo1KqGaQcTbAZY+6uaDpsweUsxbweiNmoF2B8thZK6IeNRvent8ZyNtr8WV4TrTUGJYzkmn6bpxIeglpWC7mrFVVh5qp/CzRZr0UTMTx4o/zvbTvBUq0YFhOz21JBKHiqVmrwgnCup6fB6nOiNVjO3dbt8tc26VUsEHq4T1ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Received: from stargazer.. (unknown [IPv6:240e:358:11b0:f100:dc73:854d:832e:2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 3FAB31A3FE1;
	Sun,  1 Sep 2024 02:13:50 -0400 (EDT)
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
Subject: [PATCH v6 1/3] arch: vDSO: Add a __vdso_getrandom prototype for all architectures
Date: Sun,  1 Sep 2024 14:13:10 +0800
Message-ID: <20240901061315.15693-2-xry111@xry111.site>
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

Without a prototype, we'll have to add a prototype for each architecture
implementing vDSO getrandom.  As most architectures will likely have the
vDSO getrandom implemented in a near future, and we'd like to keep the
declarations compatible everywhere (to ease the Glibc work), we should
really just have one copy of the prototype.

Suggested-by: Huacai Chen <chenhuacai@kernel.org>
Signed-off-by: Xi Ruoyao <xry111@xry111.site>
---
 arch/x86/entry/vdso/vgetrandom.c | 2 --
 include/vdso/getrandom.h         | 5 +++++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/entry/vdso/vgetrandom.c b/arch/x86/entry/vdso/vgetrandom.c
index 52d3c7faae2e..430862b8977c 100644
--- a/arch/x86/entry/vdso/vgetrandom.c
+++ b/arch/x86/entry/vdso/vgetrandom.c
@@ -6,8 +6,6 @@
 
 #include "../../../../lib/vdso/getrandom.c"
 
-ssize_t __vdso_getrandom(void *buffer, size_t len, unsigned int flags, void *opaque_state, size_t opaque_len);
-
 ssize_t __vdso_getrandom(void *buffer, size_t len, unsigned int flags, void *opaque_state, size_t opaque_len)
 {
 	return __cvdso_getrandom(buffer, len, flags, opaque_state, opaque_len);
diff --git a/include/vdso/getrandom.h b/include/vdso/getrandom.h
index 4cf02e678f5e..08b47b002bf7 100644
--- a/include/vdso/getrandom.h
+++ b/include/vdso/getrandom.h
@@ -56,4 +56,9 @@ struct vgetrandom_state {
  */
 extern void __arch_chacha20_blocks_nostack(u8 *dst_bytes, const u32 *key, u32 *counter, size_t nblocks);
 
+/**
+ * __vdso_getrandom: Prototype of vDSO getrandom.
+ */
+extern ssize_t __vdso_getrandom(void *buffer, size_t len, unsigned int flags, void *opaque_state, size_t opaque_len);
+
 #endif /* _VDSO_GETRANDOM_H */
-- 
2.46.0

