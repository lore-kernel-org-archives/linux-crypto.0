Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25F32EA72A;
	Fri, 22 May 2026 02:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779416766; cv=none; b=njJvWeA9dsdf91p+P3mFBg3fGeK1K9EnvALgWZKzZrOqpyJMD9eWU8+n14SU/QdG9LCuAkFJNf8+E48d+XvMz28GxHMEtnzzZsW+qbV7MftPSEjX1rbHaeXWC17Dh+h10acfpvAqFHO+i+yI6TqwsQLxaObJDP6JV3VJwc3ARAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779416766; c=relaxed/simple;
	bh=xoWe/+m2uwyphS1inhOSZytHSM3gZXT6DJYM10ypYu8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ic1Q9hvi5soONQtrggIxz8E1uFM2qbC+qI0K+z6nz/YXgvaEBGsbfyOEH71iCVTgvyUmKtYF8n8jYswIj3RUa1K/2bZ6YhwhAtE/vwnhRx3SgFP+qCsjqMkqZ9nh0XIUxBlmqlFlK2KEI4A7oYqbF8ct6sMcGVt4UFKO6l92d3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=geKfpRNZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="geKfpRNZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B806E1F000E9;
	Fri, 22 May 2026 02:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779416765;
	bh=aMY6QdKc1Q5aTrpMpPVY9ljk70gJaBOzFVGGGVwf+3Y=;
	h=From:To:Cc:Subject:Date;
	b=geKfpRNZcZpC2EiEwiaQPqs5fMwDMDVC2wwg8hScAHpDF+kA7Q90s4onVqn+4CBz+
	 MDNID8kya4q5km/fBL9kPTTiXGXMldU8PN2hy+WTV/RPa1+MfOqqD7sl4rayOomp4O
	 DKZJ4G4rYiCe5IYUPMYxTporFtF9TXFFwChxVGRXb7Y/4fqE+ug+LgE4D2YmqGHJYj
	 DPcDWkHTCPqvBxZdSuMpfV0S1KmShrBVbFtC5/CNbhEdvSoXFo1XsqTP0Anwaf10Tr
	 GB6IkZ4xXYNnzOVnSrz6j/MLW5jWgTVNjO9ZbjGo8N0glLdjzuxoeLoXQIGOmr8542
	 obgoxtEUQlcEw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	Huacai Chen <chenhuacai@kernel.org>,
	Qunqin Zhao <zhaoqunqin@loongson.cn>,
	Yinggang Gu <guyinggang@loongson.cn>,
	Lee Jones <lee@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	kernel test robot <lkp@intel.com>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: loongson - Select CRYPTO_RNG
Date: Thu, 21 May 2026 21:25:25 -0500
Message-ID: <20260522022525.12976-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This driver registers a rng_alg, so it requires CRYPTO_RNG.

Fixes: 766b2d724c8d ("crypto: loongson - add Loongson RNG driver support")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202605201622.qWOiiZTV-lkp@intel.com/
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/crypto/loongson/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/loongson/Kconfig b/drivers/crypto/loongson/Kconfig
index 15475da8fc11..f4e1544ffbb4 100644
--- a/drivers/crypto/loongson/Kconfig
+++ b/drivers/crypto/loongson/Kconfig
@@ -1,5 +1,6 @@
 config CRYPTO_DEV_LOONGSON_RNG
 	tristate "Support for Loongson RNG Driver"
 	depends on MFD_LOONGSON_SE
+	select CRYPTO_RNG
 	help
 	  Support for Loongson RNG Driver.

base-commit: 6c9dddeb582fde005360f4fe02c760d45ca05fb5
-- 
2.54.0

