Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792041DF25C;
	Tue, 28 Apr 2026 02:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777344429; cv=none; b=knv7cSaYrYf1yFHGGQ8k0/yvKWu6hOk/A4HblAZt8NrRkXGetU1HJBg+bAEly22b2XZla6WWFGMAoH8e3qLrbPEyUvDsinipeZMX7EKb49TkGGeQMEJSEJCTMx3fxFPw380wl4MBVRyvvWn9e1brSyfxkn/sC4eYlE/FFqWWnps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777344429; c=relaxed/simple;
	bh=mVJSxfGuAiiALaqw6cebpSUplEdzz/52FbX/446Vss4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hkajIm4tJV3JcqVceR8GCQt71FYB4ZZ8UHwm1GBIq4bxCsKTlOgPBJLgMBnBe0W9ixVq69ZieOx784g/DDMKGNlrSMHhpMYCiM66iRdqUQc2lNc58O7QgtUWCpNqBUYTmPNlASI2kPXofEPF29Di4n+ooVZN9ecxwwfHCtZ6qFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aGLfRmXH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aGLfRmXH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE52C19425;
	Tue, 28 Apr 2026 02:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777344429;
	bh=mVJSxfGuAiiALaqw6cebpSUplEdzz/52FbX/446Vss4=;
	h=From:To:Cc:Subject:Date:From;
	b=aGLfRmXH0soAYiZ/0ex3mxiOOCHRykC6ohPg4bjVidPlq45DkA1CsFjMR2AkHlyle
	 1iHcuCJ6Jhb/SR60K87Y4I2Yc3ejvTrk8v8yRaNMA/fQxUhOWRBRhr0X5Yeeou8GnR
	 Z2HJv0RTpVlO3pEH5snvGhhyL+eqPnC86N1TzDfUMeMp6WDP7PW9M1oLgX4jGmb+VP
	 bv0rNj+3wXQwXDF0d3zyW/E5oLiPoqdzRTrvQuGIpX4SsL9arl4oVTaBkWawK7yd63
	 WbfOcwo0RbNhpg9/8FKfDU5JsSUNk0JX8KbyvmAKHX9HeBIaFGrLAKb4iG7qBXzaQo
	 S+A1mU13I3lCA==
From: Eric Biggers <ebiggers@kernel.org>
To: netdev@vger.kernel.org,
	linux-afs@lists.infradead.org
Cc: David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH net-next 0/5] Consolidate FCrypt and PCBC code into net/rxrpc/
Date: Mon, 27 Apr 2026 19:43:53 -0700
Message-ID: <20260428024400.123337-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[This series applies to v7.1-rc1 and is intended to be taken via
net-next.  Patches 4-5 could be left for later if desired.]

The FCrypt "block cipher" and the PCBC mode of operation are obsolete
and insecure.  Since their only user is net/rxrpc/, they belong there,
not in the crypto API.

Therefore, this series removes these algorithms from the crypto API and
replaces them with local implementations in net/rxrpc/.

The local implementations are simpler too, as they avoid the crypto API
boilerplate.

I don't know how to test all the code in net/rxrpc/, but everything
should still work.  I added a KUnit test for the crypto functions.

Eric Biggers (5):
  net/rxrpc: Add local FCrypt-PCBC implementation
  net/rxrpc: Use local FCrypt-PCBC implementation
  net/rxrpc: Reimplement DES-PCBC using DES library
  crypto: fcrypt - Remove support for FCrypt block cipher
  crypto: pcbc - Remove support for PCBC mode

 arch/arm/configs/am200epdkit_defconfig        |   1 -
 arch/arm/configs/dove_defconfig               |   1 -
 arch/arm/configs/multi_v5_defconfig           |   1 -
 arch/arm/configs/mv78xx0_defconfig            |   1 -
 arch/arm/configs/mvebu_v5_defconfig           |   1 -
 arch/arm/configs/omap1_defconfig              |   1 -
 arch/arm/configs/orion5x_defconfig            |   1 -
 arch/arm/configs/pxa_defconfig                |   2 -
 arch/arm/configs/wpcm450_defconfig            |   1 -
 arch/m68k/configs/amiga_defconfig             |   2 -
 arch/m68k/configs/apollo_defconfig            |   2 -
 arch/m68k/configs/atari_defconfig             |   2 -
 arch/m68k/configs/bvme6000_defconfig          |   2 -
 arch/m68k/configs/hp300_defconfig             |   2 -
 arch/m68k/configs/mac_defconfig               |   2 -
 arch/m68k/configs/multi_defconfig             |   2 -
 arch/m68k/configs/mvme147_defconfig           |   2 -
 arch/m68k/configs/mvme16x_defconfig           |   2 -
 arch/m68k/configs/q40_defconfig               |   2 -
 arch/m68k/configs/sun3_defconfig              |   2 -
 arch/m68k/configs/sun3x_defconfig             |   2 -
 arch/mips/configs/bigsur_defconfig            |   2 -
 arch/mips/configs/decstation_64_defconfig     |   2 -
 arch/mips/configs/decstation_defconfig        |   2 -
 arch/mips/configs/decstation_r4k_defconfig    |   2 -
 arch/mips/configs/fuloong2e_defconfig         |   1 -
 arch/mips/configs/gpr_defconfig               |   1 -
 arch/mips/configs/ip22_defconfig              |   2 -
 arch/mips/configs/ip27_defconfig              |   2 -
 arch/mips/configs/ip30_defconfig              |   2 -
 arch/mips/configs/ip32_defconfig              |   2 -
 arch/mips/configs/lemote2f_defconfig          |   2 -
 arch/mips/configs/malta_defconfig             |   2 -
 arch/mips/configs/malta_kvm_defconfig         |   2 -
 arch/mips/configs/malta_qemu_32r6_defconfig   |   1 -
 arch/mips/configs/maltaaprp_defconfig         |   1 -
 arch/mips/configs/maltasmvp_defconfig         |   1 -
 arch/mips/configs/maltasmvp_eva_defconfig     |   1 -
 arch/mips/configs/maltaup_defconfig           |   1 -
 arch/mips/configs/maltaup_xpa_defconfig       |   2 -
 arch/mips/configs/mtx1_defconfig              |   1 -
 arch/mips/configs/rm200_defconfig             |   2 -
 arch/mips/configs/sb1250_swarm_defconfig      |   2 -
 arch/parisc/configs/generic-64bit_defconfig   |   2 -
 arch/powerpc/configs/44x/akebono_defconfig    |   1 -
 arch/powerpc/configs/44x/bamboo_defconfig     |   1 -
 arch/powerpc/configs/44x/currituck_defconfig  |   1 -
 arch/powerpc/configs/44x/ebony_defconfig      |   1 -
 arch/powerpc/configs/44x/eiger_defconfig      |   1 -
 arch/powerpc/configs/44x/fsp2_defconfig       |   1 -
 arch/powerpc/configs/44x/icon_defconfig       |   1 -
 arch/powerpc/configs/44x/iss476-smp_defconfig |   1 -
 arch/powerpc/configs/44x/katmai_defconfig     |   1 -
 arch/powerpc/configs/44x/rainier_defconfig    |   1 -
 arch/powerpc/configs/44x/redwood_defconfig    |   1 -
 arch/powerpc/configs/44x/sequoia_defconfig    |   1 -
 arch/powerpc/configs/44x/taishan_defconfig    |   1 -
 arch/powerpc/configs/52xx/cm5200_defconfig    |   1 -
 arch/powerpc/configs/52xx/motionpro_defconfig |   1 -
 arch/powerpc/configs/52xx/tqm5200_defconfig   |   1 -
 arch/powerpc/configs/83xx/asp8347_defconfig   |   1 -
 .../configs/83xx/mpc8313_rdb_defconfig        |   1 -
 .../configs/83xx/mpc8315_rdb_defconfig        |   1 -
 .../configs/83xx/mpc832x_rdb_defconfig        |   1 -
 .../configs/83xx/mpc834x_itx_defconfig        |   1 -
 .../configs/83xx/mpc834x_itxgp_defconfig      |   1 -
 .../configs/83xx/mpc837x_rdb_defconfig        |   1 -
 arch/powerpc/configs/amigaone_defconfig       |   1 -
 arch/powerpc/configs/cell_defconfig           |   1 -
 arch/powerpc/configs/chrp32_defconfig         |   1 -
 arch/powerpc/configs/ep8248e_defconfig        |   1 -
 arch/powerpc/configs/fsl-emb-nonhw.config     |   1 -
 arch/powerpc/configs/g5_defconfig             |   1 -
 arch/powerpc/configs/linkstation_defconfig    |   1 -
 arch/powerpc/configs/mgcoge_defconfig         |   1 -
 arch/powerpc/configs/mpc83xx_defconfig        |   1 -
 arch/powerpc/configs/mvme5100_defconfig       |   1 -
 arch/powerpc/configs/pmac32_defconfig         |   1 -
 arch/powerpc/configs/powernv_defconfig        |   1 -
 arch/powerpc/configs/ppc44x_defconfig         |   1 -
 arch/powerpc/configs/ppc64_defconfig          |   1 -
 arch/powerpc/configs/ppc64e_defconfig         |   1 -
 arch/powerpc/configs/ppc6xx_defconfig         |   2 -
 arch/powerpc/configs/ps3_defconfig            |   1 -
 arch/s390/configs/debug_defconfig             |   2 -
 arch/s390/configs/defconfig                   |   2 -
 arch/sh/configs/hp6xx_defconfig               |   1 -
 arch/sh/configs/r7780mp_defconfig             |   1 -
 arch/sh/configs/r7785rp_defconfig             |   1 -
 arch/sh/configs/se7712_defconfig              |   1 -
 arch/sh/configs/sh2007_defconfig              |   2 -
 arch/sparc/configs/sparc32_defconfig          |   1 -
 arch/sparc/configs/sparc64_defconfig          |   2 -
 crypto/Kconfig                                |  18 -
 crypto/Makefile                               |   2 -
 crypto/pcbc.c                                 | 195 -------
 crypto/tcrypt.c                               |   4 -
 crypto/testmgr.c                              |  15 -
 crypto/testmgr.h                              |  45 --
 net/rxrpc/.kunitconfig                        |   6 +
 net/rxrpc/Kconfig                             |  13 +-
 net/rxrpc/Makefile                            |   3 +-
 net/rxrpc/ar-internal.h                       |  21 +-
 {crypto => net/rxrpc}/fcrypt.c                | 329 +++++-------
 net/rxrpc/key.c                               |   1 -
 net/rxrpc/rxkad.c                             | 479 +++++-------------
 net/rxrpc/server_key.c                        |   1 -
 net/rxrpc/tests/Makefile                      |   3 +
 net/rxrpc/tests/rxrpc_kunit.c                 | 140 +++++
 109 files changed, 445 insertions(+), 956 deletions(-)
 delete mode 100644 crypto/pcbc.c
 create mode 100644 net/rxrpc/.kunitconfig
 rename {crypto => net/rxrpc}/fcrypt.c (65%)
 create mode 100644 net/rxrpc/tests/Makefile
 create mode 100644 net/rxrpc/tests/rxrpc_kunit.c


base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
-- 
2.54.0

