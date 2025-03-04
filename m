Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25D4278173;
	Tue,  4 Mar 2025 23:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741129682; cv=none; b=oFj94Aiwb64dTcmxKD7W54xj1uDaLdMNUxfSI3ggbQ0nDlNcDbxVdkAUK4HG4jcGIcSeJqMIu2HzjWkDCdbXyId4ZoFcrQAQSdoIY0EhtiJfdmZKiwwwKRzV7nGlr4+ZweMtx8pyb5Jsta16lemM9K2xGxxWB0XEcmi3eJ/4cwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741129682; c=relaxed/simple;
	bh=avOBrQp+1xCaw6mvPe4FyA6ZZt6QMofEYyrAYjc4Hy8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r7IoH+p+xAKreZ1cSuqiXESD0mLhiT8H8D01IKhNf/aMiOqqbMm4n7w6gmbtMOJBVqrA+7J4Gd1ppaRTsQO5oxSo84fL9evENyoMzMVMo/bDr0sCC+x3lRiJ++o3c3gYsDE6qPhqf/WROBPbOC5E0XE1TR2z9j/XJqKbYmtEA+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pKdmDevV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pKdmDevV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1829AC4CEE5;
	Tue,  4 Mar 2025 23:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741129682;
	bh=avOBrQp+1xCaw6mvPe4FyA6ZZt6QMofEYyrAYjc4Hy8=;
	h=From:To:Cc:Subject:Date:From;
	b=pKdmDevVVMyapK/ylJ264FIA9AJNR9ei5kAhLaLfi7QQmScCfSvN0pe6DTOs/bTAn
	 3f7HtY4GcIrsqU6cHEWBnPooeTjitKP8riXv/By6qRSPS1VbJrvRj88LplEZNM0TSz
	 buYm/IJTiS+5JZiuoDDISYueh9HA9EPzGk6t5+zvtCsuVqqoj/Kf9RPjMd8lTsFjEu
	 wqZdcgvPfskcFJaYBMwC3ESVhotCV6Ln9gzvMdNSMUVcDZ4qpRoTNtdQZyjDUnAQ7H
	 rwoUmDPxuVxj3mZfJjWS38iqtepSlNZmVVdMJ6EtN83FoCWhL0QpseHjPqtiyroHJo
	 sXqWSmN3pMZMw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 0/5] Remove unnecessary prompts for CRC library (batch 1)
Date: Tue,  4 Mar 2025 15:07:07 -0800
Message-ID: <20250304230712.167600-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Library functions are already selected when they are needed, so there is
no need to ask users whether to enable them or not.  This patchset fixes
this for the first batch of CRC library options.

There will be a batch 2 later to handle the rest.

Eric Biggers (5):
  lib/crc: remove unnecessary prompt for CONFIG_CRC4
  lib/crc: remove unnecessary prompt for CONFIG_CRC7
  lib/crc: remove unnecessary prompt for CONFIG_CRC8
  lib/crc: remove unnecessary prompt for CONFIG_LIBCRC32C
  lib/crc: remove unnecessary prompt for CONFIG_CRC64

 arch/arm/configs/dove_defconfig              |  1 -
 arch/arm/configs/ep93xx_defconfig            |  1 -
 arch/arm/configs/imx_v6_v7_defconfig         |  2 --
 arch/arm/configs/lpc18xx_defconfig           |  1 -
 arch/arm/configs/multi_v5_defconfig          |  1 -
 arch/arm/configs/mvebu_v5_defconfig          |  1 -
 arch/arm/configs/mxs_defconfig               |  1 -
 arch/arm/configs/omap1_defconfig             |  1 -
 arch/arm/configs/omap2plus_defconfig         |  2 --
 arch/arm/configs/spitz_defconfig             |  1 -
 arch/arm/configs/stm32_defconfig             |  1 -
 arch/arm/configs/wpcm450_defconfig           |  1 -
 arch/hexagon/configs/comet_defconfig         |  1 -
 arch/mips/configs/bigsur_defconfig           |  1 -
 arch/mips/configs/cobalt_defconfig           |  1 -
 arch/mips/configs/fuloong2e_defconfig        |  1 -
 arch/mips/configs/ip32_defconfig             |  1 -
 arch/parisc/configs/generic-64bit_defconfig  |  1 -
 arch/powerpc/configs/85xx/ge_imp3a_defconfig |  1 -
 arch/powerpc/configs/skiroot_defconfig       |  1 -
 arch/s390/configs/debug_defconfig            |  3 --
 arch/s390/configs/defconfig                  |  3 --
 arch/sh/configs/se7206_defconfig             |  2 --
 arch/sh/configs/sh2007_defconfig             |  1 -
 arch/sh/configs/titan_defconfig              |  1 -
 arch/sparc/configs/sparc32_defconfig         |  1 -
 arch/sparc/configs/sparc64_defconfig         |  1 -
 lib/Kconfig                                  | 29 ++++----------------
 28 files changed, 5 insertions(+), 58 deletions(-)


base-commit: 13f3d13d88b5dcba104a204fcbee61c75f8407d0
-- 
2.48.1

