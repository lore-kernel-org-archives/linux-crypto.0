Received: from baptiste.telenet-ops.be (baptiste.telenet-ops.be [195.130.132.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79B01F3BAA
	for <linux-crypto@vger.kernel.org>; Wed, 19 Feb 2025 15:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.130.132.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739977421; cv=none; b=Ign1o6YDNFDAZkfpXLzostHX3ZGYc0HyXT5wAa1Z61NZWLoXYXUiK2IVgr5CTUUqj8JGDpGUE1AqO8mgxoTa4Sx6EPzuENehH74eaU9EYNlRx+Tm8IUtTamCks1wzYIsbwY7WAx0YkiIe7X2zXSN6AALX5Gc5a1SfX+NLVVsWbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739977421; c=relaxed/simple;
	bh=2c/AWmO5i6aMpMjJu+qQZg9qk31xvfT1rHjn+iDPNOU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=heJ+jqUBj7qawDw2pWoUafrBM6eWePj8Hoqf7g7XujTKFgIujZ4coOrzD5+Ld1pIEC1MNtsdNcCPb2rbq/7Myg/70TtaBC4LZTOY4+uJ8BgpzPEdQD8ubKD/26Yt69ifgbhfQwp9/PbDbQfpsLy0Gas9xhb2A9TymhgPTINKtVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=glider.be; spf=none smtp.mailfrom=linux-m68k.org; arc=none smtp.client-ip=195.130.132.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=glider.be
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed80:47f6:a1ad:ad8e:b945])
	by baptiste.telenet-ops.be with cmsmtp
	id FT3a2E00L57WCNj01T3apE; Wed, 19 Feb 2025 16:03:37 +0100
Received: from rox.of.borg ([192.168.97.57])
	by ramsan.of.borg with esmtp (Exim 4.97)
	(envelope-from <geert@linux-m68k.org>)
	id 1tklbX-0000000B3WS-46QB;
	Wed, 19 Feb 2025 16:03:34 +0100
Received: from geert by rox.of.borg with local (Exim 4.97)
	(envelope-from <geert@linux-m68k.org>)
	id 1tklbq-0000000BbJe-2PpY;
	Wed, 19 Feb 2025 16:03:34 +0100
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Dragan Simic <dsimic@manjaro.org>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] hwrng: Fix indentation of HW_RANDOM_CN10K help text
Date: Wed, 19 Feb 2025 16:03:32 +0100
Message-ID: <54eae580e3ee5686db692dd6c0927b23134a1cec.1739977165.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change the indentation of the help text of the HW_RANDOM_CN10K symbol
from one TAB plus one space to one TAB plus two spaces, as is customary.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
While commit 67b78a34e48b9810 ("hwrng: Kconfig - Use tabs as leading
whitespace consistently in Kconfig") fixed some indentation for the
HW_RANDOM_CN10K symbol, it did not fix everything...
---
 drivers/char/hw_random/Kconfig | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 1ec4cad1e210a2ac..c67de9579664c762 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -583,11 +583,11 @@ config HW_RANDOM_CN10K
 	depends on HW_RANDOM && PCI && (ARM64 || (64BIT && COMPILE_TEST))
 	default HW_RANDOM if ARCH_THUNDER
 	help
-	 This driver provides support for the True Random Number
-	 generator available in Marvell CN10K SoCs.
+	  This driver provides support for the True Random Number
+	  generator available in Marvell CN10K SoCs.
 
-	 To compile this driver as a module, choose M here.
-	 The module will be called cn10k_rng. If unsure, say Y.
+	  To compile this driver as a module, choose M here.
+	  The module will be called cn10k_rng. If unsure, say Y.
 
 config HW_RANDOM_JH7110
 	tristate "StarFive JH7110 Random Number Generator support"
-- 
2.43.0

