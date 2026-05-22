Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5CE3624BC;
	Fri, 22 May 2026 05:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779426469; cv=none; b=sLAYjp1q0gdN5eZUy075S1k+4SUPBS7trswKY2B8tPk+hlzlgKe4KO/424QU5aVfq65QDc1i/p4glbDkTCaTRx3s83lHcj8rt1RVmYKulla8eD1T3ySok+VgN5HKpFM9qrKgp1/4O8xGktD2koTq8j6xhvwSjruTi9azWccmlb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779426469; c=relaxed/simple;
	bh=XRaP13Cx+jXI1HSp39tijTlJ/WCsJx+09g66+aMv3Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ttN2vDnk0GyBJ+3YkXvvHvhfjenbKFgYnYQjciTCj9ZKfLIiihYBKtZDNiZBJk5xEL/yNylx3ZXQwHNoiQbijp+72BvKhZrfqclumoteqbpS/CUhzQzcDO2Pntf1G+/OzZsi5FFKRLhvySILccsNtEj49eqLwqLfQa3hqCdxdWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mOsL+y2f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mOsL+y2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541541F000E9;
	Fri, 22 May 2026 05:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779426468;
	bh=OirFU4J8edbnkGYQjSL4iBniGJ6v+txcWQW9mPXg3Dc=;
	h=From:To:Cc:Subject:Date;
	b=mOsL+y2fIgEFtvbqDaYm/64qDsnKq6W5Pdnq7jbIAx9SRBlLLVcOKG7HPOF0jK6qN
	 X/EyN0urs9h4anT2Ru0BlLkErwCvGjasr8ho+wKHPtvi79v7qF17CbLmjvyQiR+VJT
	 E3oCUa6qmKQ6/yRLaGf+YlW3OIK+4ej70+7BTQz06zJQydL5bDJjqgGxPdxf4xntsh
	 hLVQtsh4rNed/3QZoTby7QF/atRjyj7Umltr36gvVFXJ9ra0VVHmvdqZl1fp5eopNA
	 D1TqPXaIqWK/CjO+6ld6a24mKJcV4c0O4iLFRjJqRIZtVhKU+Jd1PDQywU7XiKiaIN
	 HgCQjEDvr05AA==
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
Subject: [PATCH net-next v2 0/5] Consolidate FCrypt and PCBC code into net/rxrpc/
Date: Fri, 22 May 2026 00:07:31 -0500
Message-ID: <20260522050740.84561-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The FCrypt "block cipher" and the PCBC mode of operation are obsolete
and insecure.  Since their only user is net/rxrpc/, they belong there,
not in the crypto API.

Therefore, this series removes these algorithms from the crypto API and
replaces them with local implementations in net/rxrpc/.

The local implementations are simpler too, as they avoid the crypto API
boilerplate.

I don't know how to test all the code in net/rxrpc/, but everything
should still work.  I added a KUnit test for the crypto functions.

Changed in v2:
    - Added missing export of fcrypt_preparekey().
    - Write "RxRPC crypto KUnit test" instead of "RxRPC KUnit test".
    - Rebased onto latest net-next where decryption now happens in the
      linear buffer rxrpc_call::rx_dec_buffer, simplifying the code.

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
 crypto/pcbc.c                                 | 195 --------
 crypto/tcrypt.c                               |   4 -
 crypto/testmgr.c                              |  15 -
 crypto/testmgr.h                              |  45 --
 net/rxrpc/.kunitconfig                        |   6 +
 net/rxrpc/Kconfig                             |  13 +-
 net/rxrpc/Makefile                            |   3 +-
 net/rxrpc/ar-internal.h                       |  21 +-
 {crypto => net/rxrpc}/fcrypt.c                | 330 ++++++--------
 net/rxrpc/key.c                               |   1 -
 net/rxrpc/rxkad.c                             | 429 +++++-------------
 net/rxrpc/server_key.c                        |   1 -
 net/rxrpc/tests/Makefile                      |   3 +
 net/rxrpc/tests/rxrpc_kunit.c                 | 140 ++++++
 109 files changed, 427 insertions(+), 925 deletions(-)
 delete mode 100644 crypto/pcbc.c
 create mode 100644 net/rxrpc/.kunitconfig
 rename {crypto => net/rxrpc}/fcrypt.c (65%)
 create mode 100644 net/rxrpc/tests/Makefile
 create mode 100644 net/rxrpc/tests/rxrpc_kunit.c


base-commit: 1a1f055318d82e64485a6ff8420e5f70b4267998
-- 
2.54.0

