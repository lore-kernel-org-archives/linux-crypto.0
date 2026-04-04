Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DC7282F3D
	for <linux-crypto@vger.kernel.org>; Sat,  4 Apr 2026 13:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775310749; cv=none; b=CeO29zhJ3x0dgl7AC8QbqlvTlA0XZdiQiKUJ0lDvBptOIUng6R6M0NwXQETXLkkQef6k2j0jhF3mhFBOWLQ92cSlWozrTv3K4C39WwIPj1Z/lwxK4Tq+ioCHfAnpdXQ6aqvUgHPBZjTi1rLJmqSp5XRKXEnnmAL1Hni48eJsfq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775310749; c=relaxed/simple;
	bh=T+WBnsRzSsi9V7lBTNOlL6zTFFzPwMJQmCFrj4ILtQE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bgn0nfMJG6zirGjsbMMbtFNee472xeAPwD4mk0iXKJQSNS03uZPQoaBUO/AhOLyhnFeRZDPU0LY541GsWCjoyY1Fnn6kyOmVqAHRKi8FnZ9T+xvwL7ZLl+CMHDGmn0MywyNaJrTfbJjqGlD/ZxjaGpLmFb7+sx9YejboiRPFmYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SOs+2pv/; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SOs+2pv/"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775310736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=czDC25ht1eY1VXvbm8sYEHIoT3VxE/0qluN+o4Kueb0=;
	b=SOs+2pv/6Y+AX9IvNXarqe/IR26PA5yPV1Iyp07x8MiPKBIoF5ILo7bc19dYvDSBFztJFG
	ofBrnL56UqkzVbwUMEZlu1PM4pgHupwqy5faxm6u+m7tdF5sjxdGwWo60b2fzuoFZVY0di
	3XTLKxukhFETOUSTgKCl3X//zEi6dXw=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: vmx - remove CRYPTO_DEV_VMX from Kconfig
Date: Sat,  4 Apr 2026 15:52:03 +0200
Message-ID: <20260404135203.943986-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=910; i=thorsten.blum@linux.dev; h=from:subject; bh=T+WBnsRzSsi9V7lBTNOlL6zTFFzPwMJQmCFrj4ILtQE=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJkXxZv7HUszQl/MPriI++D8DX9aY86v7+cxfmW+k7PKu 0t47zyLjlIWBjEuBlkxRZYHs37M8C2tqdxkErETZg4rE8gQBi5OAZiIizHD/1R3/fBXU/lz2K4p n87cZJVQvNRA5N+udMW5t137xMTE8hn+1336PT2mcWvUc85uloS0IuOfmatP333LnNclrfdkD88 yTgA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

CRYPTO_DEV_VMX has been moved to arch/powerpc/crypto/Kconfig, remove it.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/crypto/Kconfig | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 8d3b5d2890f8..5b5b488ab09d 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -667,14 +667,6 @@ config CRYPTO_DEV_QCOM_RNG
 	  To compile this driver as a module, choose M here. The
 	  module will be called qcom-rng. If unsure, say N.
 
-#config CRYPTO_DEV_VMX
-#	bool "Support for VMX cryptographic acceleration instructions"
-#	depends on PPC64 && VSX
-#	help
-#	  Support for VMX cryptographic acceleration instructions.
-#
-#source "drivers/crypto/vmx/Kconfig"
-
 config CRYPTO_DEV_IMGTEC_HASH
 	tristate "Imagination Technologies hardware hash accelerator"
 	depends on MIPS || COMPILE_TEST
