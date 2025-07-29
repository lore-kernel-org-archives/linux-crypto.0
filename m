Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0ED1292B59;
	Tue, 29 Jul 2025 15:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753802889; cv=none; b=a3hYt+b8XcMwrNKKMetBVRIyYnCFP8AJsWJ9UAq4rpiKjjCkFlhWceWclvEgH9mkkdLZ6A7GzJ/glZkAPQLZftG4ufJTwtCz4bDx4T2epCZwK901sa2VI2QnezLp79H9dus8HHh/UXa/yI5y+9ZOkJISgdoFvhmzCxLqHivf4Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753802889; c=relaxed/simple;
	bh=GbNLQ4X4Iz/xFhImyaXcbhr/EuKDVDV0rC2llqGvDAQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=THZUOILw4rClo9KsbHva+UTB9rrpgpweza1/HLunTz4PHmdrjptteMK55OZxl1mnTbDosou9kgdAn/jfJhsqDV4ABdJ4NtDR+uqBckwwI+qz6MOnm4vIwZ+8XmMuRcmx1YQWEakkAQRUGLpd+6LccYp94oHzsHtUEvuCjvTHfXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MzqCYFhp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MzqCYFhp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650C8C4CEEF;
	Tue, 29 Jul 2025 15:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753802889;
	bh=GbNLQ4X4Iz/xFhImyaXcbhr/EuKDVDV0rC2llqGvDAQ=;
	h=From:To:Cc:Subject:Date:From;
	b=MzqCYFhpn2kix7dUZAOH8Ax8J1+Hj/kYlFe8yHc7BG4uHiQbnjV/HZzXNBn4b3wzR
	 W+lEAHSbxuJZh1DjIkr+w6w0M7viCIQH++mvvEo1OSwUoo6ubjGCu7+Nel4P05nKZE
	 KpTgDb7ZUVCxiQpKFUoz8daiIH/0qB+jc6tq60SyfArMblUig6TMDy/uINp0xzvXWU
	 NL5LaaX7R7MJN1Ge5PiZrM4pxRndIS56+PpfxG1xZwQxGw2fblQ3GjjmprOvSPwCiw
	 Pfj5u+TrPzWrcjHJWEfW6hg4m5or6qTrzhMAkDfium6/H3YLg6jtAO5EQGIBI1UHVg
	 GGlBHyvqmcm/w==
From: Arnd Bergmann <arnd@kernel.org>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Cai Huoqing <cai.huoqing@linux.dev>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Dragan Simic <dsimic@manjaro.org>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Markus Mayer <mmayer@broadcom.com>,
	Lukas Bulwahn <lukas.bulwahn@redhat.com>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: nomadik: add ARM_AMBA dependency
Date: Tue, 29 Jul 2025 17:28:00 +0200
Message-Id: <20250729152804.2411621-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

Compile-testing this driver is only possible when the AMBA bus driver is
available in the kernel:

x86_64-linux-ld: drivers/char/hw_random/nomadik-rng.o: in function `nmk_rng_remove':
nomadik-rng.c:(.text+0x67): undefined reference to `amba_release_regions'
x86_64-linux-ld: drivers/char/hw_random/nomadik-rng.o: in function `nmk_rng_probe':
nomadik-rng.c:(.text+0xee): undefined reference to `amba_request_regions'
x86_64-linux-ld: nomadik-rng.c:(.text+0x18d): undefined reference to `amba_release_regions'

The was previously implied by the 'depends on ARCH_NOMADIK', but needs to be
specified for the COMPILE_TEST case.

Fixes: d5e93b3374e4 ("hwrng: Kconfig - Add helper dependency on COMPILE_TEST")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/hw_random/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 3227dcaa9111..aef4406973f3 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -312,6 +312,7 @@ config HW_RANDOM_INGENIC_TRNG
 config HW_RANDOM_NOMADIK
 	tristate "ST-Ericsson Nomadik Random Number Generator support"
 	depends on ARCH_NOMADIK || COMPILE_TEST
+	depends on ARM_AMBA
 	default HW_RANDOM
 	help
 	  This driver provides kernel-side support for the Random Number
-- 
2.39.5

