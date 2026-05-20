Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A56F22A4E9;
	Wed, 20 May 2026 07:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779262764; cv=none; b=AV2Fcty3hhZckvfN1gdZQLJwR0NLDLmV3NE2yAmfZLkxfDAOUhLrOAcfQOQc/cRJi6tGY+951rCU2fjN5OXn8eHGSEEwBJBVwfIQiNyMY9PSEy/kY6DHoWXdPNffRTqRYbVQDnvMlbd7TQEMg0F5bBKtwh0fEx3QAzO+d+aF8/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779262764; c=relaxed/simple;
	bh=xhTIQ3x4oy3yxqiVslSA5RRg84TrczyWOCXLtyXfSAU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HK3JrqvbHkprNNstqdZvv39UNE9oaqVzhDMociwOxCgp3rvFYjNlaeL9CS38Nag0ke+9e8sMelhulDR7hRoYs/MFStLl5Sibw3b2p6Pks89yrMTBVau4xZyWUTTCV5srq/P1w33KE4cT4Z+Z20S49s5NY9MiTSF/simyug9J+OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VclR13Rh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VclR13Rh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3C31F000E9;
	Wed, 20 May 2026 07:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779262762;
	bh=ndEtke+/t3zcM+H5tloZeX272R/aTTYQ7iU5PnDulp8=;
	h=From:To:Cc:Subject:Date;
	b=VclR13Rhp4ShZdogSuUaeuyo9K/U6V6GYkevxVN+/eNIcFLyDj1f5M3SHq54wkMmo
	 6DkYU7iH2JVBwwk3fXtW12LUoUtPEbBvGv9Ju6K6Q1JP29jueVDcZIQyDPc/7MQ8st
	 8FBHDQH58UeZ0xPmCSaSxgAGS3/Jmy6zKGHSzOWjBIlYiMFmWwkvTBiOD0Su7c0xnF
	 9WpyUB9hX5vtGEe32QmEVQZR0fJud7ir1lnQybNqgTPPc76X8D9DZOZQFwqcBaKjER
	 +C11b+SsxBEVTWJiXeQlbN/HjsjEdS/SfB9qb973xlf1ehEoGYT79e/3a5u4DaNxPO
	 ur4kidkHJtKHA==
From: Arnd Bergmann <arnd@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Patrick Steuer <patrick.steuer@de.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] s390: crypto: add select CRYPTO_AEAD for aes
Date: Wed, 20 May 2026 09:38:44 +0200
Message-Id: <20260520073911.843561-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

The aes driver registers both skcipher and aead algorithms,
but when aead is not enabled this causes a link failure:

s390-linux-ld: arch/s390/crypto/aes_s390.o: in function `aes_s390_fini':
arch/s390/crypto/aes_s390.c:969:(.text+0x115e): undefined reference to `crypto_unregister_aead'
s390-linux-ld: arch/s390/crypto/aes_s390.o: in function `aes_s390_init':
arch/s390/crypto/aes_s390.c:1028:(.init.text+0x294): undefined reference to `crypto_register_aead'

Add the missing 'select' statement.

Fixes: bf7fa038707c ("s390/crypto: add s390 platform specific aes gcm support.")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/s390/crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/crypto/Kconfig b/arch/s390/crypto/Kconfig
index 00051d27db95..228570a1b233 100644
--- a/arch/s390/crypto/Kconfig
+++ b/arch/s390/crypto/Kconfig
@@ -4,6 +4,7 @@ menu "Accelerated Cryptographic Algorithms for CPU (s390)"
 
 config CRYPTO_AES_S390
 	tristate "Ciphers: AES, modes: ECB, CBC, CTR, XTS, GCM"
+	select CRYPTO_AEAD
 	select CRYPTO_SKCIPHER
 	help
 	  AEAD cipher: AES with GCM
-- 
2.39.5

