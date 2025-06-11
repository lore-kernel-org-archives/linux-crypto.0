Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0950026E71A
	for <linux-crypto@vger.kernel.org>; Wed, 11 Jun 2025 11:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749642094; cv=none; b=PILbyp/lVGzp0gWniCErttyE5U+VoN0qdA8twvBr5HDIalnc96lAVk/ZyZxp/k8x1huEV66JWbM2vMm4CLeI07uN2HqwJ6p2EMDBc9u5PwneAm0tV088qSeFY4ku8TeE9f3CgEkk3/WqhM5NsLwWEnmXgODOBHCbQfchh9TQi5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749642094; c=relaxed/simple;
	bh=ljOrfD1DmNbylpcSlP76RTFNedYKTqurtpHab4OwTsQ=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=gI4kvcAaTJRgQOPUnzy4mnEJtGeH7dMkVOmDCQTf7lMT7mqe9bFcHraa6aG+cxWrq7yJI5jdfwnjFXVVAdA4jnEpr7ykCy9wagugJ/XJ3wevgCVmXjYyQiAICT3pCc4AqcDpjTCInYEekY/PIjDYe//1op/Ld/IlqmlkEZi/f24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org; spf=pass smtp.mailfrom=cknow.org; dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b=g7qTMC0H; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cknow.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cknow.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cknow.org header.i=@cknow.org header.b="g7qTMC0H"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cknow.org; s=key1;
	t=1749642083;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fxnjuZ3xwpIpSVvv3DwGJe1m2GKwbpliPokqupcsJEU=;
	b=g7qTMC0HoMUUikZtkKCw10K/fst3gi13rV2DlZBzA8OXRlpRyecUMzvEwN6WtZunyuuFzp
	RGiwPMITezZhNtqp6+p9/xEUr5Lj+Czly3D3dO9LbwB5yW67gsNVYg20Ye36kfv1YHUS6q
	h2GwOmkqn3A5DorYiZsEFiQ27C31aakcSImY+ukKPY+ZFK5Ej6A3sBpkhuOJXDW2emW29c
	vg6j0wV3m6Jw4hHuHb+VgRA0vfiktrApkAwPCWIUxM/JycuQ5E4CQAPmUfWQnvnaEz2GBR
	1UwIwpj9yCfKbRcKBz08YGopEsW3zPAfouKlYR6DrhS491G1i1Gw7Qa0bhLAqw==
Content-Type: multipart/signed;
 boundary=c36e9657663e9deaef35050d42feea9240774d94463be57bf8f99adf8b46;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Wed, 11 Jun 2025 13:41:06 +0200
Message-Id: <DAJOCL4UQWZ1.2CB0NH55US5EI@cknow.org>
Subject: Re: [PATCH v3 3/7] crypto: testmgr - replace
 CRYPTO_MANAGER_DISABLE_TESTS with CRYPTO_SELFTESTS
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Diederik de Haas" <didi.debian@cknow.org>
To: "Eric Biggers" <ebiggers@kernel.org>, <linux-crypto@vger.kernel.org>,
 <linux-rockchip@lists.infradead.org>
Cc: <linux-kernel@vger.kernel.org>, "Corentin Labbe" <clabbe@baylibre.com>,
 <linux-arm-kernel@lists.infradead.org>
References: <20250505203345.802740-1-ebiggers@kernel.org>
 <20250505203345.802740-4-ebiggers@kernel.org>
In-Reply-To: <20250505203345.802740-4-ebiggers@kernel.org>
X-Migadu-Flow: FLOW_OUT

--c36e9657663e9deaef35050d42feea9240774d94463be57bf8f99adf8b46
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

Hi Eric,

On Mon May 5, 2025 at 10:33 PM CEST, Eric Biggers wrote:
> The negative-sense of CRYPTO_MANAGER_DISABLE_TESTS is a longstanding
> mistake that regularly causes confusion.  Especially bad is that you can
> have CRYPTO=3Dn && CRYPTO_MANAGER_DISABLE_TESTS=3Dn, which is ambiguous.
>
> Replace CRYPTO_MANAGER_DISABLE_TESTS with CRYPTO_SELFTESTS which has the
> expected behavior.
>
> The tests continue to be disabled by default.
> ---
>  <snip>
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index da352f1984ea..8f1353bbba18 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
>  <snip>
> @@ -171,20 +171,26 @@ config CRYPTO_USER
>  	select CRYPTO_MANAGER
>  	help
>  	  Userspace configuration for cryptographic instantiations such as
>  	  cbc(aes).
> =20
> -config CRYPTO_MANAGER_DISABLE_TESTS
> -	bool "Disable run-time self tests"
> -	default y
> +config CRYPTO_SELFTESTS
> +	bool "Enable cryptographic self-tests"
> +	depends on DEBUG_KERNEL
>  	help
> -	  Disable run-time self tests that normally take place at
> -	  algorithm registration.
> +	  Enable the cryptographic self-tests.
> +
> +	  The cryptographic self-tests run at boot time, or at algorithm
> +	  registration time if algorithms are dynamically loaded later.
> +
> +	  This is primarily intended for developer use.  It should not be
> +	  enabled in production kernels, unless you are trying to use these
> +	  tests to fulfill a FIPS testing requirement.

I built a 6.16-rc1 kernel [1] and its config is based upon Debian's and
that has enabled CRYPTO_SELFTESTS [2] (due to Debian bug 599441 [3]).

I then installed it on 3 Rockchip based devices and booted into that.
1. Radxa Rock 5B (rk3588)
2. PINE64 Quartz64 Model B (rk3568)
3. PINE64 RockPro64 (rk3399)

The full dmesg output for level 0-4 can be found at [4], [5] and [6]

The filtered dmesg output for Rock 5B:
ERROR:
[    0.709822] basic hdkf test(hmac(sha256)): failed to allocate transform:=
 -2
WARNING:
[    0.710686] alg: full crypto tests enabled.  This is intended for develo=
per use only.
[    8.877288] alg: skcipher: skipping comparison tests for xctr-aes-ce bec=
ause xctr(aes-generic) is unavailable

The filtered dmesg output for Quartz64-B:
ERROR:
[    1.479206] basic hdkf test(hmac(sha256)): failed to allocate transform:=
 -2
WARNING:
[    1.480685] alg: full crypto tests enabled.  This is intended for develo=
per use only.
[   18.176195] alg: skcipher: skipping comparison tests for xctr-aes-ce bec=
ause xctr(aes-generic) is unavailable

For both of these, 1 warning is to be expected (developer use only).
But I do wonder about the error and the other warning. Is that a
problem? And if so, is that on the crypto or the Rockchip side?

But the filtered dmesg output on RockPro64 seems way more serious:
ERROR:
[    1.232672] basic hdkf test(hmac(sha256)): failed to allocate transform:=
 -2
[   14.172991] alg: ahash: rk-sha1 export() overran state buffer on test ve=
ctor 0, cfg=3D"import/export"
[   14.202291] alg: ahash: rk-sha256 export() overran state buffer on test =
vector 0, cfg=3D"import/export"
[   14.230887] alg: ahash: rk-md5 export() overran state buffer on test vec=
tor 0, cfg=3D"import/export"
WARNING:
[    1.234017] alg: full crypto tests enabled.  This is intended for develo=
per use only.
[   14.173876] alg: self-tests for sha1 using rk-sha1 failed (rc=3D-75)
[   14.173883] ------------[ cut here ]------------
[   14.174845] alg: self-tests for sha1 using rk-sha1 failed (rc=3D-75)
[   14.174886] WARNING: CPU: 4 PID: 669 at crypto/testmgr.c:5807 alg_test+0=
x6ec/0x708
[   14.176112] Modules linked in: snd_soc_simple_card_utils snd_soc_spdif_t=
x snd_soc_rockchip_i2s des_generic gpio_ir_recv snd_soc_core v4l2_h264(+) r=
ockchip_rga videobuf2_dma_contig ecdh_generic videobuf2_dma_sg leds_gpio v4=
l2_mem2mem panfrost rfkill pwm_fan snd_compress dw_hdmi_i2s_audio pwrseq_co=
re gpu_sched rk_crypto(+) snd_pcm_dmaengine videobuf2_memops drm_shmem_help=
er dw_hdmi_cec videobuf2_v4l2 crypto_engine libdes snd_pcm videodev snd_tim=
er ofpart snd coresight_cpu_debug soundcore videobuf2_common spi_nor rockch=
ip_saradc mc mtd industrialio_triggered_buffer coresight_etm4x rockchip_the=
rmal kfifo_buf industrialio coresight cpufreq_dt evdev binfmt_misc pkcs8_ke=
y_parser efi_pstore configfs nfnetlink ip_tables x_tables autofs4 ext4 crc1=
6 mbcache jbd2 realtek phy_rockchip_samsung_hdptx phy_rockchip_naneng_combp=
hy panel_boe_th101mb31ig002_28a xhci_plat_hcd xhci_hcd rockchipdrm dw_hdmi_=
qp dw_hdmi dwc3 cec rc_core dw_mipi_dsi udc_core rk808_regulator dwmac_rk s=
tmmac_platform ulpi analogix_dp stmmac fusb302 tcpm
[   14.176292]  drm_dp_aux_bus pcs_xpcs fan53555 typec drm_display_helper p=
hylink mdio_devres drm_client_lib dwc3_of_simple pwm_regulator gpio_rockchi=
p gpio_keys fixed phy_rockchip_pcie of_mdio ehci_platform sdhci_of_arasan o=
hci_platform drm_dma_helper fixed_phy phy_rockchip_inno_usb2 ohci_hcd sdhci=
_pltfm ehci_hcd fwnode_mdio dw_wdt drm_kms_helper phy_rockchip_emmc rockchi=
p_dfi io_domain pwm_rockchip libphy phy_rockchip_typec sdhci nvmem_rockchip=
_efuse usbcore pl330 dw_mmc_rockchip drm spi_rockchip dw_mmc_pltfm mdio_bus=
 cqhci dw_mmc usb_common i2c_rk3x
[   14.188362] CPU: 4 UID: 0 PID: 669 Comm: cryptomgr_test Not tainted 6.16=
-rc1+unreleased-arm64-cknow #1 PREEMPTLAZY  Debian 6.16~rc1-1~exp1
[   14.189451] Hardware name: Pine64 RockPro64 v2.1 (DT)
[   14.189897] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[   14.190510] pc : alg_test+0x6ec/0x708
[   14.190844] lr : alg_test+0x6ec/0x708
[   14.191170] sp : ffff800081df3d30
[   14.191463] x29: ffff800081df3dd0 x28: 00000000000000bd x27: 00000000fff=
fffb5
[   14.192094] x26: 00000000000000bf x25: ffffd9bef0455000 x24: 00000000000=
00178
[   14.192725] x23: 00000000ffffffff x22: ffff000008799880 x21: 00000000080=
0018f
[   14.193355] x20: ffff000008799800 x19: ffffd9beef0558b8 x18: 00000000000=
00018
[   14.193985] x17: 0000000000006fd8 x16: ffffd9beeef9e128 x15: 00000000000=
00000
[   14.194616] x14: 0f4bc94cbbc50b90 x13: 0000000000000325 x12: 000000000f4=
bc94c
[   14.195247] x11: ffffd9beeffffff8 x10: 0000000000000d30 x9 : ffffd9beee1=
16028
[   14.195877] x8 : ffff000007518d90 x7 : 0000000000000004 x6 : 00000000000=
00000
[   14.196506] x5 : 0000000000000000 x4 : 0000000000000001 x3 : 00000000000=
00010
[   14.197137] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0000075=
18000
[   14.197767] Call trace:
[   14.197986]  alg_test+0x6ec/0x708 (P)
[   14.198315]  cryptomgr_test+0x2c/0x58
[   14.198642]  kthread+0x150/0x250
[   14.198932]  ret_from_fork+0x10/0x20
[   14.199251] ---[ end trace 0000000000000000 ]---
[   14.203118] alg: self-tests for sha256 using rk-sha256 failed (rc=3D-75)
[   14.203122] ------------[ cut here ]------------
[   14.204104] alg: self-tests for sha256 using rk-sha256 failed (rc=3D-75)
[   14.204133] WARNING: CPU: 4 PID: 672 at crypto/testmgr.c:5807 alg_test+0=
x6ec/0x708
[   14.205381] Modules linked in: snd_soc_simple_card_utils snd_soc_spdif_t=
x snd_soc_rockchip_i2s des_generic gpio_ir_recv snd_soc_core v4l2_h264 rock=
chip_rga videobuf2_dma_contig ecdh_generic videobuf2_dma_sg leds_gpio v4l2_=
mem2mem panfrost rfkill pwm_fan snd_compress dw_hdmi_i2s_audio pwrseq_core =
gpu_sched rk_crypto(+) snd_pcm_dmaengine videobuf2_memops drm_shmem_helper =
dw_hdmi_cec videobuf2_v4l2 crypto_engine libdes snd_pcm videodev snd_timer =
ofpart snd coresight_cpu_debug soundcore videobuf2_common spi_nor rockchip_=
saradc mc mtd industrialio_triggered_buffer coresight_etm4x rockchip_therma=
l kfifo_buf industrialio coresight cpufreq_dt evdev binfmt_misc pkcs8_key_p=
arser efi_pstore configfs nfnetlink ip_tables x_tables autofs4 ext4 crc16 m=
bcache jbd2 realtek phy_rockchip_samsung_hdptx phy_rockchip_naneng_combphy =
panel_boe_th101mb31ig002_28a xhci_plat_hcd xhci_hcd rockchipdrm dw_hdmi_qp =
dw_hdmi dwc3 cec rc_core dw_mipi_dsi udc_core rk808_regulator dwmac_rk stmm=
ac_platform ulpi analogix_dp stmmac fusb302 tcpm
[   14.205591]  drm_dp_aux_bus pcs_xpcs fan53555 typec drm_display_helper p=
hylink mdio_devres drm_client_lib dwc3_of_simple pwm_regulator gpio_rockchi=
p gpio_keys fixed phy_rockchip_pcie of_mdio ehci_platform sdhci_of_arasan o=
hci_platform drm_dma_helper fixed_phy phy_rockchip_inno_usb2 ohci_hcd sdhci=
_pltfm ehci_hcd fwnode_mdio dw_wdt drm_kms_helper phy_rockchip_emmc rockchi=
p_dfi io_domain pwm_rockchip libphy phy_rockchip_typec sdhci nvmem_rockchip=
_efuse usbcore pl330 dw_mmc_rockchip drm spi_rockchip dw_mmc_pltfm mdio_bus=
 cqhci dw_mmc usb_common i2c_rk3x
[   14.217640] CPU: 4 UID: 0 PID: 672 Comm: cryptomgr_test Tainted: G      =
  W           6.16-rc1+unreleased-arm64-cknow #1 PREEMPTLAZY  Debian 6.16~r=
c1-1~exp1
[   14.218866] Tainted: [W]=3DWARN
[   14.219130] Hardware name: Pine64 RockPro64 v2.1 (DT)
[   14.219576] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[   14.220188] pc : alg_test+0x6ec/0x708
[   14.220521] lr : alg_test+0x6ec/0x708
[   14.220847] sp : ffff800081e03d30
[   14.221140] x29: ffff800081e03dd0 x28: 00000000000000bd x27: 00000000fff=
fffb5
[   14.221771] x26: 00000000000000c1 x25: ffffd9bef0455000 x24: 00000000000=
00178
[   14.222402] x23: 00000000ffffffff x22: ffff00000b49c880 x21: 00000000080=
0018f
[   14.223033] x20: ffff00000b49c800 x19: ffffd9beef0558b8 x18: 00000000fff=
ffffe
[   14.223663] x17: 7463657620747365 x16: ffffd9beee6829e8 x15: ffffd9bef03=
eb09f
[   14.224294] x14: 0000000000000000 x13: ffffd9bef03eb0a3 x12: ffffd9bef00=
85e60
[   14.224923] x11: ffffd9bef002deb8 x10: ffffd9bef0085eb8 x9 : ffffd9beee1=
7c8cc
[   14.225553] x8 : 0000000000000001 x7 : 0000000000017fe8 x6 : c0000000fff=
fefff
[   14.226183] x5 : ffff0000f7766448 x4 : 0000000000000000 x3 : 00000000000=
00027
[   14.226812] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0000075=
1bb40
[   14.227443] Call trace:
[   14.227662]  alg_test+0x6ec/0x708 (P)
[   14.227991]  cryptomgr_test+0x2c/0x58
[   14.228319]  kthread+0x150/0x250
[   14.228611]  ret_from_fork+0x10/0x20
[   14.228929] ---[ end trace 0000000000000000 ]---
[   14.231753] alg: self-tests for md5 using rk-md5 failed (rc=3D-75)
[   14.231758] ------------[ cut here ]------------
[   14.232696] alg: self-tests for md5 using rk-md5 failed (rc=3D-75)
[   14.232742] WARNING: CPU: 4 PID: 674 at crypto/testmgr.c:5807 alg_test+0=
x6ec/0x708
[   14.233943] Modules linked in: v4l2_vp9 snd_soc_audio_graph_card snd_soc=
_simple_card_utils snd_soc_spdif_tx snd_soc_rockchip_i2s des_generic gpio_i=
r_recv snd_soc_core v4l2_h264 rockchip_rga videobuf2_dma_contig ecdh_generi=
c videobuf2_dma_sg leds_gpio v4l2_mem2mem panfrost rfkill pwm_fan snd_compr=
ess dw_hdmi_i2s_audio pwrseq_core gpu_sched rk_crypto(+) snd_pcm_dmaengine =
videobuf2_memops drm_shmem_helper dw_hdmi_cec videobuf2_v4l2 crypto_engine =
libdes snd_pcm videodev snd_timer ofpart snd coresight_cpu_debug soundcore =
videobuf2_common spi_nor rockchip_saradc mc mtd industrialio_triggered_buff=
er coresight_etm4x rockchip_thermal kfifo_buf industrialio coresight cpufre=
q_dt evdev binfmt_misc pkcs8_key_parser efi_pstore configfs nfnetlink ip_ta=
bles x_tables autofs4 ext4 crc16 mbcache jbd2 realtek phy_rockchip_samsung_=
hdptx phy_rockchip_naneng_combphy panel_boe_th101mb31ig002_28a xhci_plat_hc=
d xhci_hcd rockchipdrm dw_hdmi_qp dw_hdmi dwc3 cec rc_core dw_mipi_dsi udc_=
core rk808_regulator dwmac_rk stmmac_platform ulpi
[   14.234122]  analogix_dp stmmac fusb302 tcpm drm_dp_aux_bus pcs_xpcs fan=
53555 typec drm_display_helper phylink mdio_devres drm_client_lib dwc3_of_s=
imple pwm_regulator gpio_rockchip gpio_keys fixed phy_rockchip_pcie of_mdio=
 ehci_platform sdhci_of_arasan ohci_platform drm_dma_helper fixed_phy phy_r=
ockchip_inno_usb2 ohci_hcd sdhci_pltfm ehci_hcd fwnode_mdio dw_wdt drm_kms_=
helper phy_rockchip_emmc rockchip_dfi io_domain pwm_rockchip libphy phy_roc=
kchip_typec sdhci nvmem_rockchip_efuse usbcore pl330 dw_mmc_rockchip drm sp=
i_rockchip dw_mmc_pltfm mdio_bus cqhci dw_mmc usb_common i2c_rk3x
[   14.246439] CPU: 4 UID: 0 PID: 674 Comm: cryptomgr_test Tainted: G      =
  W           6.16-rc1+unreleased-arm64-cknow #1 PREEMPTLAZY  Debian 6.16~r=
c1-1~exp1
[   14.247667] Tainted: [W]=3DWARN
[   14.247931] Hardware name: Pine64 RockPro64 v2.1 (DT)
[   14.248377] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[   14.248991] pc : alg_test+0x6ec/0x708
[   14.249332] lr : alg_test+0x6ec/0x708
[   14.249664] sp : ffff800081e0bd30
[   14.249957] x29: ffff800081e0bdd0 x28: 00000000000000bd x27: 00000000fff=
fffb5
[   14.250588] x26: 00000000000000a4 x25: ffffd9bef0455000 x24: 00000000000=
00178
[   14.251220] x23: 00000000ffffffff x22: ffff00000b49c280 x21: 00000000080=
0018f
[   14.251852] x20: ffff00000b49c200 x19: ffffd9beef0558b8 x18: 00000000000=
00018
[   14.252484] x17: 0000000000007050 x16: ffffd9beeef9e128 x15: 00000000000=
00000
[   14.253114] x14: 0a8fc7a77222d736 x13: 00000000000003da x12: 000000000a8=
fc7a7
[   14.253747] x11: ffffd9beeffffff8 x10: 0000000000000d30 x9 : ffffd9beee1=
16028
[   14.254377] x8 : ffff00000b6d3510 x7 : 0000000000000004 x6 : 00000000000=
00000
[   14.255008] x5 : 0000000000000000 x4 : 0000000000000001 x3 : 00000000000=
00010
[   14.255637] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff00000b6=
d2780
[   14.256268] Call trace:
[   14.256498]  alg_test+0x6ec/0x708 (P)
[   14.256835]  cryptomgr_test+0x2c/0x58
[   14.257164]  kthread+0x150/0x250
[   14.257455]  ret_from_fork+0x10/0x20
[   14.257774] ---[ end trace 0000000000000000 ]---
[   14.828425] alg: skcipher: skipping comparison tests for xctr-aes-ce bec=
ause xctr(aes-generic) is unavailable

I'm assuming this is problematic and hopefully you can tell whether this
is on the crypto or Rockchip side as well. In case of the latter, if
you'd have pointers as to where the problem is/may be, that would be
appreciated.

[1] https://salsa.debian.org/diederik/linux/-/tree/cknow/general
[2] https://salsa.debian.org/kernel-team/linux/-/commit/6991dd77f350
6991dd77f350 ("crypto: Explicitly enable algorithm self-tests (Closes: #599=
441)")
[3] https://bugs.debian.org/599441
[4] https://paste.sr.ht/~diederik/c18ad65427080d4c48e8bd2ac27282682069aff1
[5] https://paste.sr.ht/~diederik/8fde0c2c1d005a15bb8a3b6d7ba8ae3298733250
[6] https://paste.sr.ht/~diederik/cdcb6c4522fa782f9a692b7ea0cf33c2301e2176

Cheers,
  Diederik

--c36e9657663e9deaef35050d42feea9240774d94463be57bf8f99adf8b46
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQT1sUPBYsyGmi4usy/XblvOeH7bbgUCaElrXAAKCRDXblvOeH7b
bs/+AQClPPe4tZNNFJz24t2cRxLV/95TtxY52ZefqGhDPjneogEA9gnaR1mtglZq
721GhOOKRssXZBg0Hlt4d3KnKhzPXw4=
=y3gL
-----END PGP SIGNATURE-----

--c36e9657663e9deaef35050d42feea9240774d94463be57bf8f99adf8b46--
