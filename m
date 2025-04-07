Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061DD1FE454;
	Mon,  7 Apr 2025 16:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744043228; cv=none; b=BdZzA1gq9DilOCKKtgaGVWOAH1Wmv+cAW+icSap08NsKai0fckhUUkx1WkLUHqxXOpjYy61daXy+dAzpIggwmEiQ16uV7N0Kia1T56pgOncHe82aqKfHZkVKm3Ip26+HJHxgcyYh5oE5/ZscvGJBHTC8hYs/v+pdaA3GIiWadk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744043228; c=relaxed/simple;
	bh=uGljTwGwHyQfIKUhJ3rgVgi8PhrSqdfBARVYzZ39ZwM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=WNF1U6Pb4t/yfIyGs9CyohlOGk5ZqQpZqQFToLwQhu9eVYCwvQ/AaNG/BgYXEEO5CfEvJG2zbKX1ZaLNqU0IRt9YmKNNdFjnM4a6yfTGBPFJU4Vt94x1jYa3JdLFlWpbqP+joNqA9ExoAmVdvqbD0sgxdPVV8tGARetsfhX1TEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=od3xGPtF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="od3xGPtF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABEF3C4CEDD;
	Mon,  7 Apr 2025 16:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744043227;
	bh=uGljTwGwHyQfIKUhJ3rgVgi8PhrSqdfBARVYzZ39ZwM=;
	h=Date:From:To:Cc:Subject:From;
	b=od3xGPtFuaBYqVjju/bYhM4cxwm5meyXoVnl0K1d1myknCpTdX0RBwVBU8gNbzzrV
	 3DwJd/AA+sUJUxsHir5xyOKuhjImUh9fnepAYzhtCpVMb+2urCDm0cC5xBr1hIONl1
	 ZKayFQnAYLYO4iCplSzd26bY6kaGRNf4Fp/udmdRONNv07/TijciNghMSBZTvfVf0J
	 zuC++aiO7+rThVIZNYTK7fXc11F39pq0aNOspSSq3g1w6C5rQbEtp/rWTFM4JpXupO
	 dJSfn5RSgcwhFSObyoVVC7W+jTuUi0sSVXvkpC5CsiI7Z87rpLZyNAGuF8atUEq4XI
	 L8p/wxI9qtOvQ==
Date: Mon, 7 Apr 2025 09:27:06 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>, Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [GIT PULL] CRC cleanups for 6.15-rc2
Message-ID: <20250407162706.GA2536@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus, please consider this second set of CRC kconfig option cleanups for
6.15-rc2.  It could wait until 6.16 if you prefer, but I figured this would work
well for 6.15 since it's a straightforward cleanup that touches a lot of files.

The following changes since commit 91e5bfe317d8f8471fbaa3e70cf66cae1314a516:

  Merge tag 'dmaengine-6.15-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/vkoul/dmaengine (2025-04-01 12:57:14 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/crc-for-linus

for you to fetch changes up to b261d2222063a9a8b9ec284244c285f2998ee01e:

  lib/crc: remove CONFIG_LIBCRC32C (2025-04-04 11:31:42 -0700)

----------------------------------------------------------------

Finish cleaning up the CRC kconfig options by removing the remaining
unnecessary prompts and an unnecessary 'default y', removing
CONFIG_LIBCRC32C, and documenting all the CRC library options.

----------------------------------------------------------------
Eric Biggers (7):
      lib/crc: remove unnecessary prompt for CONFIG_CRC32 and drop 'default y'
      lib/crc: remove unnecessary prompt for CONFIG_CRC_CCITT
      lib/crc: remove unnecessary prompt for CONFIG_CRC16
      lib/crc: remove unnecessary prompt for CONFIG_CRC_T10DIF
      lib/crc: remove unnecessary prompt for CONFIG_CRC_ITU_T
      lib/crc: document all the CRC library kconfig options
      lib/crc: remove CONFIG_LIBCRC32C

 arch/arm/configs/at91_dt_defconfig                |  1 -
 arch/arm/configs/collie_defconfig                 |  1 -
 arch/arm/configs/davinci_all_defconfig            |  1 -
 arch/arm/configs/dove_defconfig                   |  1 -
 arch/arm/configs/exynos_defconfig                 |  1 -
 arch/arm/configs/imx_v6_v7_defconfig              |  2 -
 arch/arm/configs/lpc18xx_defconfig                |  1 -
 arch/arm/configs/lpc32xx_defconfig                |  1 -
 arch/arm/configs/milbeaut_m10v_defconfig          |  2 -
 arch/arm/configs/mmp2_defconfig                   |  1 -
 arch/arm/configs/multi_v4t_defconfig              |  1 -
 arch/arm/configs/multi_v5_defconfig               |  1 -
 arch/arm/configs/mvebu_v5_defconfig               |  1 -
 arch/arm/configs/mxs_defconfig                    |  1 -
 arch/arm/configs/omap2plus_defconfig              |  3 --
 arch/arm/configs/orion5x_defconfig                |  1 -
 arch/arm/configs/pxa168_defconfig                 |  1 -
 arch/arm/configs/pxa910_defconfig                 |  1 -
 arch/arm/configs/pxa_defconfig                    |  2 -
 arch/arm/configs/s5pv210_defconfig                |  1 -
 arch/arm/configs/sama7_defconfig                  |  2 -
 arch/arm/configs/spitz_defconfig                  |  1 -
 arch/arm/configs/stm32_defconfig                  |  1 -
 arch/arm/configs/wpcm450_defconfig                |  2 -
 arch/hexagon/configs/comet_defconfig              |  3 --
 arch/m68k/configs/amcore_defconfig                |  1 -
 arch/mips/configs/ath79_defconfig                 |  1 -
 arch/mips/configs/bigsur_defconfig                |  1 -
 arch/mips/configs/fuloong2e_defconfig             |  1 -
 arch/mips/configs/ip22_defconfig                  |  1 -
 arch/mips/configs/ip27_defconfig                  |  1 -
 arch/mips/configs/ip30_defconfig                  |  1 -
 arch/mips/configs/ip32_defconfig                  |  1 -
 arch/mips/configs/omega2p_defconfig               |  1 -
 arch/mips/configs/rb532_defconfig                 |  1 -
 arch/mips/configs/rt305x_defconfig                |  1 -
 arch/mips/configs/sb1250_swarm_defconfig          |  1 -
 arch/mips/configs/vocore2_defconfig               |  1 -
 arch/mips/configs/xway_defconfig                  |  1 -
 arch/parisc/configs/generic-32bit_defconfig       |  2 -
 arch/parisc/configs/generic-64bit_defconfig       |  1 -
 arch/powerpc/configs/44x/sam440ep_defconfig       |  1 -
 arch/powerpc/configs/44x/warp_defconfig           |  2 -
 arch/powerpc/configs/83xx/mpc832x_rdb_defconfig   |  1 -
 arch/powerpc/configs/83xx/mpc834x_itx_defconfig   |  1 -
 arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig |  1 -
 arch/powerpc/configs/83xx/mpc837x_rdb_defconfig   |  1 -
 arch/powerpc/configs/85xx/ge_imp3a_defconfig      |  2 -
 arch/powerpc/configs/85xx/stx_gp3_defconfig       |  2 -
 arch/powerpc/configs/85xx/xes_mpc85xx_defconfig   |  1 -
 arch/powerpc/configs/86xx-hw.config               |  1 -
 arch/powerpc/configs/amigaone_defconfig           |  1 -
 arch/powerpc/configs/chrp32_defconfig             |  1 -
 arch/powerpc/configs/fsl-emb-nonhw.config         |  1 -
 arch/powerpc/configs/g5_defconfig                 |  1 -
 arch/powerpc/configs/gamecube_defconfig           |  1 -
 arch/powerpc/configs/linkstation_defconfig        |  2 -
 arch/powerpc/configs/mpc83xx_defconfig            |  1 -
 arch/powerpc/configs/mpc866_ads_defconfig         |  1 -
 arch/powerpc/configs/mvme5100_defconfig           |  2 -
 arch/powerpc/configs/pasemi_defconfig             |  1 -
 arch/powerpc/configs/pmac32_defconfig             |  1 -
 arch/powerpc/configs/ppc44x_defconfig             |  1 -
 arch/powerpc/configs/ppc64e_defconfig             |  1 -
 arch/powerpc/configs/ps3_defconfig                |  2 -
 arch/powerpc/configs/skiroot_defconfig            |  2 -
 arch/powerpc/configs/storcenter_defconfig         |  1 -
 arch/powerpc/configs/wii_defconfig                |  1 -
 arch/sh/configs/ap325rxa_defconfig                |  1 -
 arch/sh/configs/ecovec24_defconfig                |  1 -
 arch/sh/configs/edosk7705_defconfig               |  1 -
 arch/sh/configs/espt_defconfig                    |  1 -
 arch/sh/configs/hp6xx_defconfig                   |  2 -
 arch/sh/configs/kfr2r09-romimage_defconfig        |  1 -
 arch/sh/configs/landisk_defconfig                 |  1 -
 arch/sh/configs/lboxre2_defconfig                 |  1 -
 arch/sh/configs/magicpanelr2_defconfig            |  2 -
 arch/sh/configs/migor_defconfig                   |  1 -
 arch/sh/configs/r7780mp_defconfig                 |  1 -
 arch/sh/configs/r7785rp_defconfig                 |  1 -
 arch/sh/configs/rts7751r2d1_defconfig             |  1 -
 arch/sh/configs/rts7751r2dplus_defconfig          |  1 -
 arch/sh/configs/sdk7780_defconfig                 |  1 -
 arch/sh/configs/se7206_defconfig                  |  3 --
 arch/sh/configs/se7712_defconfig                  |  1 -
 arch/sh/configs/se7721_defconfig                  |  1 -
 arch/sh/configs/se7724_defconfig                  |  1 -
 arch/sh/configs/sh03_defconfig                    |  1 -
 arch/sh/configs/sh2007_defconfig                  |  2 -
 arch/sh/configs/sh7724_generic_defconfig          |  1 -
 arch/sh/configs/sh7763rdp_defconfig               |  1 -
 arch/sh/configs/sh7770_generic_defconfig          |  1 -
 arch/sh/configs/titan_defconfig                   |  1 -
 arch/sparc/configs/sparc64_defconfig              |  1 -
 drivers/block/Kconfig                             |  2 +-
 drivers/block/drbd/Kconfig                        |  2 +-
 drivers/md/Kconfig                                |  2 +-
 drivers/md/persistent-data/Kconfig                |  2 +-
 drivers/net/ethernet/broadcom/Kconfig             |  4 +-
 drivers/net/ethernet/cavium/Kconfig               |  2 +-
 fs/bcachefs/Kconfig                               |  2 +-
 fs/btrfs/Kconfig                                  |  2 +-
 fs/ceph/Kconfig                                   |  2 +-
 fs/erofs/Kconfig                                  |  2 +-
 fs/gfs2/Kconfig                                   |  1 -
 fs/xfs/Kconfig                                    |  2 +-
 lib/Kconfig                                       | 57 +++++++++++------------
 net/batman-adv/Kconfig                            |  2 +-
 net/ceph/Kconfig                                  |  2 +-
 net/netfilter/Kconfig                             |  4 +-
 net/netfilter/ipvs/Kconfig                        |  2 +-
 net/openvswitch/Kconfig                           |  2 +-
 net/sched/Kconfig                                 |  2 +-
 net/sctp/Kconfig                                  |  2 +-
 tools/testing/selftests/bpf/config.x86_64         |  1 -
 tools/testing/selftests/hid/config.common         |  1 -
 116 files changed, 46 insertions(+), 170 deletions(-)
