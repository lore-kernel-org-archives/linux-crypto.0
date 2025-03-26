Received: from lelvem-ot02.ext.ti.com (lelvem-ot02.ext.ti.com [198.47.23.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9D836124
	for <linux-crypto@vger.kernel.org>; Wed, 26 Mar 2025 10:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742983247; cv=none; b=e7AvnO6L7eFaUdrtvoA6UQX2xEen691J2n9VtxuwZ6n3dfyX77ba2/uncP600KShkanae3g3g38XZDojW8Ju0LUzv6NYg9aarUGz/mwwXTVSRTJ2Tye7KlLk9oSmBqGjKJiypTb6k7i3CN0VUu0pu6CZipU16QUcDLdZenOWZaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742983247; c=relaxed/simple;
	bh=lCqpZJp39inRWwL+P9OASI3me8u+EcqIGYMzQgpdEnQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dyy60TvfnGLJIcwVfkElW5OvjGJEci7++4XX09RF09iDDRAQJQ7kYZd1N3qzZbA5QZbHwOlLmdGitD84kWpkBSwosDdVjCCJdF4W20Bg7NY/IezkQw+DHKQynUojxSXe9QxpyqL+I9oJTHagRsCTTNRtYUbVr6If+ZtpFex41FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=HU1KY6Mh; arc=none smtp.client-ip=198.47.23.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="HU1KY6Mh"
Received: from lelv0266.itg.ti.com ([10.180.67.225])
	by lelvem-ot02.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 52QA0Swe2072005
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 26 Mar 2025 05:00:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1742983228;
	bh=C4ZU6VlmYXsnZNJJ2Y/wFB8YlJfnpJ/Wl7Gv2yLxqy4=;
	h=Date:From:To:CC:Subject:References:In-Reply-To;
	b=HU1KY6Mhw++LlQmxC10tb0rWeAzmtU4Tpf3UYVxIGG/d9RVm3cHd/15m6M9pMb5Li
	 i+JDa5LLxuw9jsF9l61Vm7dzh50u1NKBBErKAM6EqM0U+m3ZtLUuo2W6w+QpJYMzoc
	 Oowp3MTDgTwtjVNau6rCno84yZTERA50lkUIprx0=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
	by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTP id 52QA0SMW034524;
	Wed, 26 Mar 2025 05:00:28 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Wed, 26
 Mar 2025 05:00:28 -0500
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Wed, 26 Mar 2025 05:00:28 -0500
Received: from localhost (uda0497581-hp.dhcp.ti.com [172.24.227.253])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 52QA0RpN087856;
	Wed, 26 Mar 2025 05:00:28 -0500
Date: Wed, 26 Mar 2025 15:30:27 +0530
From: Manorit Chawdhry <m-chawdhry@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers
	<ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Megha Dey
	<megha.dey@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Kamlesh
 Gurudasani <kamlesh@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>, Udit
 Kumar <u-kumar1@ti.com>,
        Pratham T <t-pratham@ti.com>
Subject: Re: [PATCH] crypto: sa2ul - Use proper helpers to setup request
Message-ID: <20250326100027.trel4le7mpadtaft@uda0497581-HP>
References: <cover.1739674648.git.herbert@gondor.apana.org.au>
 <2620cdada3777a66d3600cd1887cd34245d1e26a.1739674648.git.herbert@gondor.apana.org.au>
 <20250326090035.izxxf3sboom7hvcv@uda0497581-HP>
 <Z-PGEtO8JmyC5xU_@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z-PGEtO8JmyC5xU_@gondor.apana.org.au>
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Hi Herbert,

On 17:17-20250326, Herbert Xu wrote:
> On Wed, Mar 26, 2025 at 02:30:35PM +0530, Manorit Chawdhry wrote:
> >
> > The following patch seems to be breaking selftests in SA2UL driver.
> 
> Thanks for the report.
> 
> This patch should fix the problem:
> 
> ---8<---
> Rather than setting up a request by hand, use the correct API helpers
> to setup the new request.  This is because the API helpers will setup
> chaining.
> 
> Also change the fallback allocation to explicitly request for a
> sync algorithm as this driver will crash if given an async one.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 

Thanks for the quick fix, though now I see error in import rather than
init which was there previously.

root@j721e-evm:~# modprobe sa2ul
[  155.283088] omap_rng 4e10000.rng: Random Number Generator ver. 241b34c
root@j721e-evm:~# [  155.401918] Unable to handle kernel paging request at virtual address fefefefefefefeee
[  155.430127] Unable to handle kernel paging request at virtual address fefefefefefefeee
[  155.463959] Unable to handle kernel paging request at virtual address fefefefefefefeee
[  155.480086] Mem abort info:
[  155.503068] Mem abort info:
[  155.506689]   ESR = 0x0000000096000004
[  155.527264]   ESR = 0x0000000096000004
[  155.531009]   EC = 0x25: DABT (current EL), IL = 32 bits
[  155.538758] Mem abort info:
[  155.543371]   EC = 0x25: DABT (current EL), IL = 32 bits
[  155.559119]   ESR = 0x0000000096000004
[  155.580125]   SET = 0, FnV = 0
[  155.583176]   EA = 0, S1PTW = 0
[  155.589283]   EC = 0x25: DABT (current EL), IL = 32 bits
[  155.607886]   SET = 0, FnV = 0
[  155.610938]   EA = 0, S1PTW = 0
[  155.633650]   SET = 0, FnV = 0
[  155.638300]   FSC = 0x04: level 0 translation fault
[  155.667607]   FSC = 0x04: level 0 translation fault
[  155.673165]   EA = 0, S1PTW = 0
[  155.686121] Data abort info:
[  155.697270]   FSC = 0x04: level 0 translation fault
[  155.709990] Data abort info:
[  155.714312]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
[  155.736268]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
[  155.745374] Data abort info:
[  155.763508]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[  155.770677]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
[  155.791894]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[  155.801343]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[  155.815914]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[  155.829811]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[  155.847633] [fefefefefefefeee] address between user and kernel address ranges
[  155.859395]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[  155.872011] [fefefefefefefeee] address between user and kernel address ranges
[  155.893911] [fefefefefefefeee] address between user and kernel address ranges
[  155.901649] Internal error: Oops: 0000000096000004 [#1]  SMP
[  155.907297] Modules linked in: des_generic cbc libdes sa2ul authenc onboard_usb_dev rpmsg_ctrl rpmsg_char phy_cadence_torrent phy_cadence_sierra rtc_tps6594 tps6594_esm pinctrl_tps6594 tps6594_pfsm gpio_regmap tps6594_regulator ti_am335x_adc pru_rproc kfifo_buf irq_pruss_intc cdns3 cdns_pltfrm cdns_usb_common snd_soc_j721e_evm display_connector phy_can_transceiver omap_mailbox phy_j721e_wiz ti_k3_r5_remoteproc tps6594_i2c tps6594_core at24 tidss k3_j72xx_bandgap drm_client_lib drm_dma_helper cdns_mhdp8546 ti_am335x_tscadc m_can_platform snd_soc_davinci_mcasp drm_display_helper pruss snd_soc_ti_udma m_can snd_soc_ti_edma drm_kms_helper ti_j721e_ufs snd_soc_ti_sdma ti_k3_dsp_remoteproc snd_soc_pcm3168a_i2c cdns3_ti can_dev snd_soc_pcm3168a rti_wdt overlay cfg80211 rfkill fuse drm backlight ipv6
[  155.977452] CPU: 0 UID: 0 PID: 1252 Comm: cryptomgr_test Not tainted 6.14.0-rc7-next-20250324-build-configs-00001-g82a16a3a2a73-dirty #3 PREEMPT
[  155.990466] Hardware name: Texas Instruments J721e EVM (DT)
[  155.996022] pstate: 40000005 (nZcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  156.002966] pc : crypto_ahash_import+0x18/0x68
[  156.007409] lr : sa_sha_import+0x48/0x60 [sa2ul]
[  156.012024] sp : ffff8000853336f0
[  156.015326] x29: ffff8000853336f0 x28: 0000000000000000 x27: 0000000000000000
[  156.022447] x26: ffff000807ed6c00 x25: ffff8000853337e8 x24: 0000000000000000
[  156.029568] x23: ffff000801307440 x22: ffff800085333c08 x21: ffff000801307400
[  156.036688] x20: ffff800081510c10 x19: ffff8000814e13e8 x18: 00000000ffffffff
[  156.043809] x17: 0000000000000000 x16: 0010000000000000 x15: ffff800085333740
[  156.050929] x14: ffff800105333aa7 x13: 0000000000000000 x12: 0000000000000000
[  156.058049] x11: 0000000000000000 x10: ffff00087f7c8308 x9 : ffff80007be3aa38
[  156.065170] x8 : ffff000807ed6d50 x7 : fefefefefefefefe x6 : 0101010101010101
[  156.072291] x5 : 00000000ffffff8d x4 : 0000000000000000 x3 : fefefefefefefefe
[  156.079411] x2 : ffff000807ed6c00 x1 : ffff000803fc9c00 x0 : ffff000807ed6c90
[  156.086531] Call trace:
[  156.088966]  crypto_ahash_import+0x18/0x68 (P)
[  156.093399]  sa_sha_import+0x48/0x60 [sa2ul]
[  156.097658]  crypto_ahash_import+0x54/0x68
[  156.101744]  test_ahash_vec_cfg+0x638/0x800
[  156.105916]  test_hash_vec+0xbc/0x230
[  156.109568]  __alg_test_hash+0x288/0x3d8
[  156.113478]  alg_test_hash+0x108/0x1a0
[  156.117217]  alg_test+0x148/0x658
[  156.120520]  cryptomgr_test+0x2c/0x50
[  156.124171]  kthread+0x134/0x218
[  156.127390]  ret_from_fork+0x10/0x20
[  156.130958] Code: d503233f a9bf7bfd 910003fd f9401003 (385f0064)
[  156.137034] ---[ end trace 0000000000000000 ]---
[  156.147224] Internal error: Oops: 0000000096000004 [#2]  SMP
[  156.152873] Modules linked in: des_generic cbc libdes sa2ul authenc onboard_usb_dev rpmsg_ctrl rpmsg_char phy_cadence_torrent phy_cadence_sierra rtc_tps6594 tps6594_esm pinctrl_tps6594 tps6594_pfsm gpio_regmap tps6594_regulator ti_am335x_adc pru_rproc kfifo_buf irq_pruss_intc cdns3 cdns_pltfrm cdns_usb_common snd_soc_j721e_evm display_connector phy_can_transceiver omap_mailbox phy_j721e_wiz ti_k3_r5_remoteproc tps6594_i2c tps6594_core at24 tidss k3_j72xx_bandgap drm_client_lib drm_dma_helper cdns_mhdp8546 ti_am335x_tscadc m_can_platform snd_soc_davinci_mcasp drm_display_helper pruss snd_soc_ti_udma m_can snd_soc_ti_edma drm_kms_helper ti_j721e_ufs snd_soc_ti_sdma ti_k3_dsp_remoteproc snd_soc_pcm3168a_i2c cdns3_ti can_dev snd_soc_pcm3168a rti_wdt overlay cfg80211 rfkill fuse drm backlight ipv6
[  156.223015] CPU: 0 UID: 0 PID: 1253 Comm: cryptomgr_test Tainted: G      D             6.14.0-rc7-next-20250324-build-configs-00001-g82a16a3a2a73-dirty #3 PREEMPT
[  156.237588] Tainted: [D]=DIE
[  156.240456] Hardware name: Texas Instruments J721e EVM (DT)
[  156.246010] pstate: 40000005 (nZcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  156.252953] pc : crypto_ahash_import+0x18/0x68
[  156.257389] lr : sa_sha_import+0x48/0x60 [sa2ul]
[  156.261998] sp : ffff8000853cb6f0
[  156.265299] x29: ffff8000853cb6f0 x28: 0000000000000000 x27: 0000000000000000
[  156.272420] x26: ffff0008033aba00 x25: ffff8000853cb7e8 x24: 0000000000000000
[  156.279540] x23: ffff000808b8a040 x22: ffff8000853cbc08 x21: ffff000808b8a000
[  156.286660] x20: ffff800081510970 x19: ffff8000814e13e8 x18: ffff0008033abb28
[  156.293781] x17: 0000000000000050 x16: 000000000000005e x15: fefefefefefefefe
[  156.300900] x14: fefefefefefefefe x13: fefefefefefefefe x12: fefefefefefefefe
[  156.308021] x11: fefefefefefefefe x10: fefefefefefefefe x9 : ffff80007be3aa38
[  156.315141] x8 : ffff0008033abbb0 x7 : fefefefefefefefe x6 : 0101010101010101
[  156.322261] x5 : 00000000ffffff8d x4 : 0000000000000000 x3 : fefefefefefefefe
[  156.329381] x2 : ffff0008033aba00 x1 : ffff00080337da00 x0 : ffff0008033aba90
[  156.336502] Call trace:
[  156.338937]  crypto_ahash_import+0x18/0x68 (P)
[  156.343371]  sa_sha_import+0x48/0x60 [sa2ul]
[  156.347630]  crypto_ahash_import+0x54/0x68
[  156.351716]  test_ahash_vec_cfg+0x638/0x800
[  156.355888]  test_hash_vec+0xbc/0x230
[  156.359538]  __alg_test_hash+0x288/0x3d8
[  156.363449]  alg_test_hash+0x108/0x1a0
[  156.367187]  alg_test+0x148/0x658
[  156.370491]  cryptomgr_test+0x2c/0x50
[  156.374141]  kthread+0x134/0x218
[  156.377359]  ret_from_fork+0x10/0x20
[  156.380924] Code: d503233f a9bf7bfd 910003fd f9401003 (385f0064)
[  156.386999] ---[ end trace 0000000000000000 ]---
[  156.391626] Internal error: Oops: 0000000096000004 [#3]  SMP
[  156.397270] Modules linked in: des_generic cbc libdes sa2ul authenc onboard_usb_dev rpmsg_ctrl rpmsg_char phy_cadence_torrent phy_cadence_sierra rtc_tps6594 tps6594_esm pinctrl_tps6594 tps6594_pfsm gpio_regmap tps6594_regulator ti_am335x_adc pru_rproc kfifo_buf irq_pruss_intc cdns3 cdns_pltfrm cdns_usb_common snd_soc_j721e_evm display_connector phy_can_transceiver omap_mailbox phy_j721e_wiz ti_k3_r5_remoteproc tps6594_i2c tps6594_core at24 tidss k3_j72xx_bandgap drm_client_lib drm_dma_helper cdns_mhdp8546 ti_am335x_tscadc m_can_platform snd_soc_davinci_mcasp drm_display_helper pruss snd_soc_ti_udma m_can snd_soc_ti_edma drm_kms_helper ti_j721e_ufs snd_soc_ti_sdma ti_k3_dsp_remoteproc snd_soc_pcm3168a_i2c cdns3_ti can_dev snd_soc_pcm3168a rti_wdt overlay cfg80211 rfkill fuse drm backlight ipv6
[  156.467403] CPU: 0 UID: 0 PID: 1250 Comm: cryptomgr_test Tainted: G      D             6.14.0-rc7-next-20250324-build-configs-00001-g82a16a3a2a73-dirty #3 PREEMPT
[  156.481974] Tainted: [D]=DIE
[  156.484842] Hardware name: Texas Instruments J721e EVM (DT)
[  156.490396] pstate: 00000005 (nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  156.497340] pc : crypto_ahash_import+0x18/0x68
[  156.501773] lr : sa_sha_import+0x48/0x60 [sa2ul]
[  156.506379] sp : ffff8000851d36f0
[  156.509680] x29: ffff8000851d36f0 x28: 0000000000000000 x27: 0000000000000000
[  156.516800] x26: ffff000803c75400 x25: ffff8000851d37e8 x24: 0000000000000000
[  156.523920] x23: ffff000808b8b040 x22: ffff8000851d3c08 x21: ffff000808b8b000
[  156.531040] x20: ffff800081510e98 x19: ffff8000814e13e8 x18: 00000000ffffffff
[  156.538160] x17: 0000000000000000 x16: 0000000000000000 x15: ffff8000851d3740
[  156.545280] x14: ffff8001051d3aa7 x13: 0000000000000000 x12: 0000000000000000
[  156.552400] x11: 0000000000000000 x10: ffff00087f7c8308 x9 : ffff80007be3aa38
[  156.559520] x8 : ffff000803c75548 x7 : fefefefefefefefe x6 : 0101010101010101
[  156.566641] x5 : 00000000ffffff8d x4 : 0000000000000000 x3 : fefefefefefefefe
[  156.573761] x2 : ffff000803c75400 x1 : ffff000812686a00 x0 : ffff000803c75490
[  156.580881] Call trace:
[  156.583316]  crypto_ahash_import+0x18/0x68 (P)
[  156.587747]  sa_sha_import+0x48/0x60 [sa2ul]
[  156.592006]  crypto_ahash_import+0x54/0x68
[  156.596090]  test_ahash_vec_cfg+0x638/0x800
[  156.600261]  test_hash_vec+0xbc/0x230
[  156.603912]  __alg_test_hash+0x288/0x3d8
[  156.607822]  alg_test_hash+0x108/0x1a0
[  156.611560]  alg_test+0x148/0x658
[  156.614864]  cryptomgr_test+0x2c/0x50
[  156.618514]  kthread+0x134/0x218
[  156.621731]  ret_from_fork+0x10/0x20
[  156.625298] Code: d503233f a9bf7bfd 910003fd f9401003 (385f0064)
[  156.631372] ---[ end trace 0000000000000000 ]---

Regards,
Manorit
