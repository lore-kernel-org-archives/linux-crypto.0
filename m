Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4339117D8BE;
	Tue, 25 Jun 2024 19:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719345479; cv=none; b=J/BLgAbjZSaWnHpIpy85qSzgaElTo7ulwT7Tbt47Ogmfe+BPyWbNLexpq31kwR/RgBqBXkJYYZkNGuWavI/xnNcov/9GszvdlAYVG/1uOaMObD3eNwn4wTnY4zimW7HfEk8KlFvbPH/8E9aXzgxxxqY7EJcYf+WU1oHPJMWqci8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719345479; c=relaxed/simple;
	bh=5WXuGLJgM+QtAIwqwDjoNKPak65DDHF2eYjfAS6luTg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=trdKc/wcx9WuQiHNyRmllnAKxlkTkWI5k6KzeQ8KpJe2ezDjfA9Hul+8PY+m42NcwtpNxxqxVqiMRfuOKSHzDN/9OiQJ8D8lTka9csum5gimfu8gDFF6fdB37yTwehOfJYZ5iTs63e6m4l1VuIB68sPo8f5CjPygvCU5JO/8xJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=n3Wtluo9; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="n3Wtluo9"
Received: from francesco-nb.pivistrello.it (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id A053B1FACA;
	Tue, 25 Jun 2024 21:57:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1719345472;
	bh=mTXmTyJB6Z16tkKRKJPTeo4y+EeQ33t7StEL4G7pefM=; h=From:To:Subject;
	b=n3Wtluo9CY/ZpmDsBaRaLJGIdRIlFtqyG8HeR+smMxSV4SlPj0P+LjDIYhrwdLzWw
	 6fazspF2nXAI2Zv15SnmQqnoleC3a3yhzDeh86uF9FVfW3OJjCSSuexlvGVMR7hx3t
	 GtCy9CfuTHTd4B8eIA0j/NMHk0GNe3bCzpx+sCfeoSIuGFI7+qA4wa6CQoabuE+JZn
	 DZiDXBcLRGvr411TY4HVOVejjRPmCzXOe/HvGgXG8h7f2B+Lvr1bob8C9+DLbD4Zio
	 p+f+kJjbBoqDv8sGNtE3/s8SSKnZp06CmXXdavn/fWb3bJVkD1iWCR3oDGUcRjACoq
	 C8RASSzdAC6Ww==
From: Francesco Dolcini <francesco@dolcini.it>
To: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: Francesco Dolcini <francesco.dolcini@toradex.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1] hwrng: Kconfig - Do not enable by default CN10K driver
Date: Tue, 25 Jun 2024 21:57:46 +0200
Message-Id: <20240625195746.48905-1-francesco@dolcini.it>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Francesco Dolcini <francesco.dolcini@toradex.com>

Do not enable by default the CN10K HW random generator driver.

CN10K Random Number Generator is available only on some specific
Marvell SoCs, however the driver is in practice enabled by default on
all arm64 configs.

Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
---
as an alternative I could propose

default HW_RANDOM if ARCH_THUNDER=y

---
 drivers/char/hw_random/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
index 442c40efb200..01e2e1ef82cf 100644
--- a/drivers/char/hw_random/Kconfig
+++ b/drivers/char/hw_random/Kconfig
@@ -555,7 +555,6 @@ config HW_RANDOM_ARM_SMCCC_TRNG
 config HW_RANDOM_CN10K
        tristate "Marvell CN10K Random Number Generator support"
        depends on HW_RANDOM && PCI && (ARM64 || (64BIT && COMPILE_TEST))
-       default HW_RANDOM
        help
 	 This driver provides support for the True Random Number
 	 generator available in Marvell CN10K SoCs.
-- 
2.39.2

