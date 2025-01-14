Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49EB03DABE7;
	Tue, 14 Jan 2025 09:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736848558; cv=none; b=uKFygJPviTMvjjJgT7nwE2kb6wa0H34Zw45JzyDMMtHSaKoG0RrSmoRSGmDJYFcCe9fE4Gt8FYh7QB4YPu7uqziMJd6bJYmY3m8D9A9zxDhYEsIHu415aJOfDg5sEjjA/IHlgeH6ROH64u94ekVZ1qeu88EuWcfoJslpo7+tYf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736848558; c=relaxed/simple;
	bh=vYZ+b7z3Rh+NAIqqyO0p1CDWWXienaA+n4UpToFEOhM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=j/WinJPwvrWal5UgsRTSAzsht1qz7mccl+vQ6jTv/j4eFm7a32Z+uhAIYD9VbPiGmXgfiqoOmTbDeYryTmHzcr0EOHbBAjeWwrNQhPDehiSjU086M3Q8HNr19xtan/Rjly1Wi5h8Fk8IxdZBUG7hKFT686vMz2cQLzrRc9oBO/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.40.54.90])
	by gateway (Coremail) with SMTP id _____8BxYa+pNIZn2h9jAA--.64309S3;
	Tue, 14 Jan 2025 17:55:53 +0800 (CST)
Received: from localhost.localdomain (unknown [10.40.54.90])
	by front1 (Coremail) with SMTP id qMiowMBxReSoNIZnct0hAA--.2343S2;
	Tue, 14 Jan 2025 17:55:52 +0800 (CST)
From: Qunqin Zhao <zhaoqunqin@loongson.cn>
To: lee@kernel.org,
	herbert@gondor.apana.org.au,
	gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	arnd@arndb.de,
	derek.kiernan@amd.com,
	dragan.cvetic@amd.com,
	Qunqin Zhao <zhaoqunqin@loongson.cn>
Subject: [PATCH v1 0/3] Drivers for Loongson security engine
Date: Tue, 14 Jan 2025 17:55:24 +0800
Message-Id: <20250114095527.23722-1-zhaoqunqin@loongson.cn>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxReSoNIZnct0hAA--.2343S2
X-CM-SenderInfo: 52kd01pxqtx0o6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW7tFWDGF17Cry3Zr43ur1fZrc_yoW8GFykpF
	4FyryrCF4UJFZrGryfJry8GFyfXa4fXrW3KrW2qw1kX3sxAFykJrW3CFyUJFn7AFy7Jry2
	gF95G3yUGF1UJacCm3ZEXasCq-sJn29KB7ZKAUJUUUU3529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUB0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1ln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2
	x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1D
	McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr4
	1lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_
	Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67
	AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8I
	cVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI
	8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU4SoGDUUUU

Loongson SE supports random number generation, hash, symmetric encryption
and asymmetric encryption. Based on these encryption functions, TPM2.0
and SDF have been implemented in SE. SDF is the functions specified in
"GB/T 36322-2018".

mfd is the baser driver, crypto and misc are users.

Qunqin Zhao (3):
  mfd: Add support for Loongson Security Module
  crypto: loongson - add Loongson RNG driver support
  misc: ls6000se-sdf: Add driver for Loongson 6000SE SDF

 MAINTAINERS                            |  14 +
 drivers/crypto/Kconfig                 |   1 +
 drivers/crypto/Makefile                |   1 +
 drivers/crypto/loongson/Kconfig        |   6 +
 drivers/crypto/loongson/Makefile       |   2 +
 drivers/crypto/loongson/ls6000se-rng.c | 190 +++++++++++++
 drivers/mfd/Kconfig                    |   9 +
 drivers/mfd/Makefile                   |   2 +
 drivers/mfd/ls6000se.c                 | 373 +++++++++++++++++++++++++
 drivers/misc/Kconfig                   |   9 +
 drivers/misc/Makefile                  |   1 +
 drivers/misc/ls6000se-sdf.c            | 123 ++++++++
 include/linux/mfd/ls6000se.h           |  75 +++++
 13 files changed, 806 insertions(+)
 create mode 100644 drivers/crypto/loongson/Kconfig
 create mode 100644 drivers/crypto/loongson/Makefile
 create mode 100644 drivers/crypto/loongson/ls6000se-rng.c
 create mode 100644 drivers/mfd/ls6000se.c
 create mode 100644 drivers/misc/ls6000se-sdf.c
 create mode 100644 include/linux/mfd/ls6000se.h


base-commit: c2b148f3bc94b61e885dc8529d6b6136576bd865
-- 
2.43.0

