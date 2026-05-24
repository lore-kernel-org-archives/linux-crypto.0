Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508352F872;
	Sun, 24 May 2026 21:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779658240; cv=none; b=bHjajEPUUf9SFZC0cFua7pYpuVRz+HI7aSaWb+TLrqgNQtvXKLwnzbyFjGi3AbhkeMv9NhXegkKU6dwJTXMPqADSHbNzkEOB1HSqT0j7EpNxzoiSTNuje1qGZ+nUsa+fNZIp3RY5c2pcwfEWsRIlZpCvpSh0XXPo6coANUdAM0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779658240; c=relaxed/simple;
	bh=qGi5JkH0/9nqzEpO+GWiB18MbRy1xh7/jEpBaJ6mNB4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=meKgpsZ68u8mYdI7TKob0PTq16k3htV8oXkNcKaGqDUmMLlj0ye2muf5zTxBsXYIiW27uCmGgl1ZFwAwmN95mHCF/QIQlpyn1KGEt5dQPOjtfvyecqXqkcxIgaNeoMGgR3dhheEV6XAQpQqFy2tPqwSgvguLQ00maU2gEUpRBEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CMOXgSwD; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CMOXgSwD"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779658235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9a9YmhOCMXCdtmBjQ+c3tIWRUeS6et3diSyOkSzdMjQ=;
	b=CMOXgSwDG0TJmSezRu5hp0o52kttpkinATv/up81d1a0uLK6EJHSy4N8uHxdc3d5gAQD27
	CXja7J4X3NPetR2yR1XaxTyzwQ71zAQTD0wr+xalOULW3dpkw62OGRgc5AaTXbGJFQGKXN
	JkRlLmD6IxFsZjPKYNvi/TqkFck6j5s=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	=?UTF-8?q?Breno=20Leit=C3=A3o?= <leitao@debian.org>,
	Nayna Jain <nayna@linux.ibm.com>,
	Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH] MAINTAINERS: powerpc: update VMX AES entries
Date: Sun, 24 May 2026 23:29:45 +0200
Message-ID: <20260524212943.799757-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1384; i=thorsten.blum@linux.dev; h=from:subject; bh=qGi5JkH0/9nqzEpO+GWiB18MbRy1xh7/jEpBaJ6mNB4=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFnCuSdeGsnPZfY4WZV/++7m+9//Hln+dD+3SJxKp+WLh eV3DD7ZdpSyMIhxMciKKbI8mPVjhm9pTeUmk4idMHNYmUCGMHBxCsBEmucy/HeXczjC2Hiw8tDJ BanrBarm8luYid3PTQor+C6w9mFgtgwjw1G5yxcm3Aw8sbiHcfvxBIlE9o9CS22vakdczPzFvfH TVy4A
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Commit 7cf2082e74ce ("lib/crypto: powerpc/aes: Migrate POWER8 optimized
code into library") removed arch/powerpc/crypto/aes.c and moved
arch/powerpc/crypto/aesp8-ppc.pl to lib/crypto/powerpc/.

However, the "IBM Power VMX Cryptographic instructions" entry still
references the removed file and no longer covers the moved aesp8-ppc.pl.

Remove the stale entry, add lib/crypto/powerpc/aesp8-ppc.pl, and tighten
the arch/powerpc/crypto/aesp8-ppc.* pattern to match the remaining
header only.

Fixes: 7cf2082e74ce ("lib/crypto: powerpc/aes: Migrate POWER8 optimized code into library")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b539be153f6a..c48cdb05e6dc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12349,13 +12349,13 @@ L:	linux-crypto@vger.kernel.org
 S:	Supported
 F:	arch/powerpc/crypto/Kconfig
 F:	arch/powerpc/crypto/Makefile
-F:	arch/powerpc/crypto/aes.c
 F:	arch/powerpc/crypto/aes_cbc.c
 F:	arch/powerpc/crypto/aes_ctr.c
 F:	arch/powerpc/crypto/aes_xts.c
-F:	arch/powerpc/crypto/aesp8-ppc.*
+F:	arch/powerpc/crypto/aesp8-ppc.h
 F:	arch/powerpc/crypto/ppc-xlate.pl
 F:	arch/powerpc/crypto/vmx.c
+F:	lib/crypto/powerpc/aesp8-ppc.pl
 F:	lib/crypto/powerpc/gf128hash.h
 F:	lib/crypto/powerpc/ghashp8-ppc.pl
 
