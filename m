Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D946B1BF810
	for <linux-crypto@vger.kernel.org>; Tue, 27 Aug 2024 13:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724764837; cv=none; b=o3IebDq1DZn7EXTw2y4w1RoerDEu3ejXXqGG2/MDx5hYrQdovjy5LyhRI4rcUmix/Eg7M6H9Htd2xJbHpp3i7eeGHN/rXKybXJnzvtaPSxEMzxHQuzy1PoRmkmXlVhwKfUEWm9zW9vFu4urWDBMMFKOL7L91sxwvqkJZ/N7gtUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724764837; c=relaxed/simple;
	bh=tTP9I3zHVghO4BCG6u2iICldKSjz3Dk3ORekSpnAYkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQgRJaAJCFrUnewUnzKhIWZGR1/6msKmZECV1Z5O7eb7GSBV1kpzfQr7cq2C40NUtb6fd74b1OKJCfcN70zFWzu67F19+eWLw8L6AOf0pSDi0I38VYKEsnK0qmOj2QKT83NIykeNOte7a0pJM9nOWGaLqwhPXfHFXHz4G5QG1zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=KqcUpZ4l; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="KqcUpZ4l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1724764835;
	bh=tTP9I3zHVghO4BCG6u2iICldKSjz3Dk3ORekSpnAYkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KqcUpZ4lxuXyXtsUvS3YKt4wFl17DA4h8Vi7LK23oni4+cTYFqX490vLrhbUjnwIj
	 78zGKdq/6B+CTZXCbiAqHAQidsdn+gD0IuKY5eQA6WX7rzJkWYlfuQoL9UTu0egK24
	 NeX6UBTPJs+UUOLgE8mJZCgtfZFQfP398JA2+Tjk=
Received: from stargazer.. (unknown [113.200.174.85])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 5ECFE66F28;
	Tue, 27 Aug 2024 09:20:32 -0400 (EDT)
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
Subject: [PATCH v4 2/4] selftests/vDSO: Add --cflags for pkg-config command querying libsodium
Date: Tue, 27 Aug 2024 21:20:15 +0800
Message-ID: <20240827132018.88854-3-xry111@xry111.site>
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

When libsodium is installed into its own prefix, the --cflags output is
needed for the compiler to find libsodium headers.

Signed-off-by: Xi Ruoyao <xry111@xry111.site>
---
 tools/testing/selftests/vDSO/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vDSO/Makefile b/tools/testing/selftests/vDSO/Makefile
index 10ffdda3f2fa..180854eb9fec 100644
--- a/tools/testing/selftests/vDSO/Makefile
+++ b/tools/testing/selftests/vDSO/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 uname_M := $(shell uname -m 2>/dev/null || echo not)
 ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
-SODIUM := $(shell pkg-config --libs libsodium 2>/dev/null)
+SODIUM := $(shell pkg-config --libs --cflags libsodium 2>/dev/null)
 
 TEST_GEN_PROGS := vdso_test_gettimeofday
 TEST_GEN_PROGS += vdso_test_getcpu
-- 
2.46.0

