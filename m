Received: from hall.aurel32.net (hall.aurel32.net [195.154.113.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131BB22F11
	for <linux-crypto@vger.kernel.org>; Sat, 24 Aug 2024 21:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.154.113.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724533951; cv=none; b=p5jb9ThQCKJLNnxT0PUlVAwCAPRPB83EKcn4ID4qLNQztfDCJWOn3wqj+ENVgLkPN4HNEGGgAtxxqYzcjJ78p3+mt+9TMs5L5J9kCj/LNMWV2Abc6GalfCjUOP+zBOayFszIi1aFLcrTOS2w/qlzNxVMNmCj+PCfzFnVnYxBIiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724533951; c=relaxed/simple;
	bh=jqg/hxb5iTJoEZUxF9ucctXF+Bf+rYk5joE5QQWZlRE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=nUZnHxsH218KWELywBl5AafoejUUvrufA99POHqGVhwm+bFx7zR/rW5aTdVDCXl7/l8Jp2wcG5jcMGGs2cHNOE6DiaRXRWbsxoKx2ey0D6NtNp7ogu5iT+5a9aACvomqPuzrJFzunOqssjqV4MKmLETbRyTYzuHWIiWVie02vUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aurel32.net; spf=pass smtp.mailfrom=aurel32.net; dkim=pass (2048-bit key) header.d=aurel32.net header.i=@aurel32.net header.b=Td3BzZrh; arc=none smtp.client-ip=195.154.113.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=aurel32.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aurel32.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aurel32.net header.i=@aurel32.net header.b="Td3BzZrh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=aurel32.net
	; s=202004.hall; h=Content-Transfer-Encoding:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:From:Reply-To:Subject:Content-ID:
	Content-Description:In-Reply-To:References:X-Debbugs-Cc;
	bh=4nY5++i41dpTSS2mCdP2J5oQwyTFedfkauL833e59jQ=; b=Td3BzZrhq4hX0mgcTctq35mRN9
	L701ZYvwOg9vdtyhQfIKbM4GpkHr5mjbGvyboRMC8JZiXB9UmyfcI7WiODG1TiIjFMQd4BMDF5j3d
	rxEGUEtHxz0hvpcCvp9zxdvTulFxyr/SUpRijPKTgiq8OhJK0skLsxruDc1pETHp2Xn2YcRXUsUw2
	9h4Wndz7xAdXTDmpmLetta7NW/ximrgp3Z5g+m4Z8drRs04LR417TEFDn4BXIaSBtwaBRvAc4+R4O
	5/EzOrcmn3dQlqVrZb8K9Earz7UULxTZ4/gCv2oKFsQY5VuqJp17wEaLmYL71YNLrgdp/8cy2YjNJ
	wGD+AAdg==;
Received: from ohm.aurel32.net ([2001:bc8:30d7:111::2] helo=ohm.rr44.fr)
	by hall.aurel32.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <aurelien@aurel32.net>)
	id 1shxSj-00363Z-0o;
	Sat, 24 Aug 2024 22:34:17 +0200
Date: Sat, 24 Aug 2024 22:34:16 +0200
From: Aurelien Jarno <aurelien@aurel32.net>
To: Jia Jie Ho <jiajie.ho@starfivetech.com>,
	William Qiu <william.qiu@starfivetech.com>
Cc: linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org,
	E Shattow <lucent@gmail.com>
Subject: crypto: starfive: kernel oops when unloading jh7110_crypto module
 and loading it again
Message-ID: <ZspDyIZiG8kvXaoS@aurel32.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
User-Agent: Mutt/2.2.13 (2024-03-09)

Hi,

I have been testing the jh7110_crypto module on a VisionFive 1.2a board,
running a 6.11-rc4 kernel. To benchmark the crypto with and without
acceleration, I have unloaded the module, and later on I loaded it
again. Unloading it works fine, but when loading it again, I get the
following kernel oops:

[ 1379.354601] jh7110-crypto 16000000.crypto: will run requests pump with r=
ealtime priority
[ 1379.397261] alg: aead: starfive-ccm-aes encryption test failed (wrong re=
sult) on test vector 0, cfg=3D"in-place (one sglist)"
[ 1379.408481] alg: self-tests for ccm(aes) using starfive-ccm-aes failed (=
rc=3D-22)
[ 1379.408490] ------------[ cut here ]------------
[ 1379.420469] alg: self-tests for ccm(aes) using starfive-ccm-aes failed (=
rc=3D-22)
[ 1379.420523] WARNING: CPU: 2 PID: 1402 at crypto/testmgr.c:5908 alg_test+=
0x5aa/0x5fa
[ 1379.420545] Modules linked in: jh7110_crypto(+) xts twofish_generic twof=
ish_common serpent_generic algif_skcipher af_alg ad7418 binfmt_misc sm3_gen=
eric sm3 nls_ascii nls_cp437 vfat fat snd_soc_simple_card sha512_generic sn=
d_soc_simple_card_utils jh7110_pwmdac snd_soc_spdif_tx sd_mod cdns3 snd_soc=
_core sg udc_core cdns_usb_common roles snd_pcm_dmaengine ccm snd_pcm ofpar=
t ghash_generic gf128mul spi_nor gcm crypto_null cdns3_starfive dw_axi_dmac=
_platform ctr snd_timer mtd snd starfive_wdt watchdog crypto_engine jh7110_=
trng soundcore sfctemp cpufreq_dt drm nvme_fabrics configfs drm_panel_orien=
tation_quirks nfnetlink efivarfs ip_tables x_tables autofs4 ext4 crc16 mbca=
che jbd2 uas usb_storage crc32c_generic scsi_mod scsi_common rtc_ds1307 dm_=
mod dax xhci_pci xhci_hcd motorcomm nvme nvme_core dwmac_starfive stmmac_pl=
atform stmmac usbcore axp20x_regulator axp20x_i2c axp20x mfd_core usb_commo=
n regmap_i2c pcs_xpcs dw_mmc_starfive dw_mmc_pltfm mdio_devres of_mdio dw_m=
mc fixed_phy phylink mmc_core clk_starfive_jh7110_vout
[ 1379.420856]  fwnode_mdio clk_starfive_jh7110_isp libphy phy_jh7110_dphy_=
rx clk_starfive_jh7110_aon spi_cadence_quadspi clk_starfive_jh7110_stg i2c_=
designware_platform phy_jh7110_usb i2c_designware_core phy_jh7110_pcie [las=
t unloaded: jh7110_crypto]
[ 1379.420903] CPU: 2 UID: 0 PID: 1402 Comm: cryptomgr_test Not tainted 6.1=
1-rc4+unreleased-riscv64 #1  Debian 6.11~rc4-1~exp3
[ 1379.420915] Hardware name: Unknown Unknown Product/Unknown Product, BIOS=
 2024.01+dfsg-3 01/01/2024
[ 1379.420921] epc : alg_test+0x5aa/0x5fa
[ 1379.420930]  ra : alg_test+0x5aa/0x5fa
[ 1379.420938] epc : ffffffff8045db18 ra : ffffffff8045db18 sp : ffffffc600=
8dbd60
[ 1379.420945]  gp : ffffffff81ba8980 tp : ffffffd6c3978000 t0 : ffffffff81=
a30570
[ 1379.420951]  t1 : ffffffffffffffff t2 : 2d2d2d2d2d2d2d2d s0 : ffffffc600=
8dbe80
[ 1379.420958]  s1 : ffffffffffffffff a0 : 0000000000000043 a1 : ffffffff81=
a95888
[ 1379.420964]  a2 : 0000000200000022 a3 : ffffffff81c1d158 a4 : 0000000000=
000000
[ 1379.420971]  a5 : 0000000000000000 a6 : 0000000000000001 a7 : 0000000000=
057fa8
[ 1379.420976]  s2 : ffffffd6d00e0a00 s3 : 0000000000000383 s4 : ffffffd6d0=
0e0a80
[ 1379.420983]  s5 : 000000000000017f s6 : ffffffffffffffea s7 : 0000000000=
000003
[ 1379.420989]  s8 : 000000000000002f s9 : 00000000000000c0 s10: 0000000000=
0000c0
[ 1379.420995]  s11: ffffffff81063b08 t3 : ffffffff81bbedef t4 : ffffffff81=
bbedef
[ 1379.421001]  t5 : ffffffff81bbedf0 t6 : ffffffc6008dbb68
[ 1379.421006] status: 0000000200000120 badaddr: 0000000000000000 cause: 00=
00000000000003
[ 1379.421013] [<ffffffff8045db18>] alg_test+0x5aa/0x5fa
[ 1379.421024] [<ffffffff8045a026>] cryptomgr_test+0x28/0x4a
[ 1379.421034] [<ffffffff8004906e>] kthread+0xc4/0xe2
[ 1379.421046] [<ffffffff80a1333e>] ret_from_fork+0xe/0x20
[ 1379.421059] ---[ end trace 0000000000000000 ]---

Regards
Aurelien

--=20
Aurelien Jarno                          GPG: 4096R/1DDD8C9B
aurelien@aurel32.net                     http://aurel32.net
