Received: from fllvem-ot03.ext.ti.com (fllvem-ot03.ext.ti.com [198.47.19.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE713185920
	for <linux-crypto@vger.kernel.org>; Wed, 26 Mar 2025 09:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742979650; cv=none; b=g56NEgfneVZMouRTYSJaX4H1eWEaiF3o4YXOFzPJwFEuWsaWRo3jrc8e9E4SZzFA6r5umFiVfCKd2YiDSmVMnEpUnkgE00xLKLKDZpfn/3XC6ZpjN6QA32tBqAi2X1zGI9GularIp9PUJ40W/VQpztyWgHHcrlK/DRftkotxgq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742979650; c=relaxed/simple;
	bh=Wbjl+HnF0XEMIlBc93hm55bhxMZ/rxuHrKFl7IR1lHI=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PRO/aMdyhcm60EVh2OXAPKRIDTM21jzl59oq0cgQdMKwD4Wrgjn5Sf1FFTSiU38NWBq7TLxxZDhZe81Juadonxdq7vHpBMzjzpwcb9qfY1oQFUaDcqvudfWtE4vIcQXXICW0ECVlz+JXT0mVrtDMUH4oceo9i/nGGBg4vpbBbDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=Z3l1aCHM; arc=none smtp.client-ip=198.47.19.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Z3l1aCHM"
Received: from fllv0034.itg.ti.com ([10.64.40.246])
	by fllvem-ot03.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 52Q90bs71493767
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Mar 2025 04:00:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1742979637;
	bh=Ad5N6obHNF1uiVUyO6aHmgLxajoXuvbvtjnJy6mC8P8=;
	h=Date:From:To:CC:Subject:References:In-Reply-To;
	b=Z3l1aCHMQXJH1U819iQ+sz6ElIKjMJjeNy/GSeEV3a3R6q3Okwa8xjBbmSHDMqcbF
	 VJkbkMBDVCn3jJ4Y76ZKcUNgJ+9BCorPm3wdubl8kknBfTc3Ecgr4bYj2H531RIC5z
	 jhgdPEYCBzpuHKhDDzg79uLRa9SKGjFbTViS4bjQ=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
	by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 52Q90bAd045803
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 26 Mar 2025 04:00:37 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Wed, 26
 Mar 2025 04:00:36 -0500
Received: from lelvsmtp6.itg.ti.com (10.180.75.249) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Wed, 26 Mar 2025 04:00:36 -0500
Received: from localhost (uda0497581-hp.dhcp.ti.com [172.24.227.253])
	by lelvsmtp6.itg.ti.com (8.15.2/8.15.2) with ESMTP id 52Q90ad8020194;
	Wed, 26 Mar 2025 04:00:36 -0500
Date: Wed, 26 Mar 2025 14:30:35 +0530
From: Manorit Chawdhry <m-chawdhry@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers
	<ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Megha Dey
	<megha.dey@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Manorit
 Chawdhry <m-chawdhry@ti.com>,
        Kamlesh Gurudasani <kamlesh@ti.com>,
        Vignesh
 Raghavendra <vigneshr@ti.com>, Udit Kumar <u-kumar1@ti.com>,
        Pratham T
	<t-pratham@ti.com>
Subject: Re: [v2 PATCH 03/11] crypto: hash - Add request chaining API
Message-ID: <20250326090035.izxxf3sboom7hvcv@uda0497581-HP>
References: <cover.1739674648.git.herbert@gondor.apana.org.au>
 <2620cdada3777a66d3600cd1887cd34245d1e26a.1739674648.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2620cdada3777a66d3600cd1887cd34245d1e26a.1739674648.git.herbert@gondor.apana.org.au>
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Hi Herbert,

On 11:07-20250216, Herbert Xu wrote:
> This adds request chaining to the ahash interface.  Request chaining
> allows multiple requests to be submitted in one shot.  An algorithm
> can elect to receive chained requests by setting the flag
> CRYPTO_ALG_REQ_CHAIN.  If this bit is not set, the API will break
> up chained requests and submit them one-by-one.
> 
> A new err field is added to struct crypto_async_request to record
> the return value for each individual request.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  crypto/ahash.c                 | 261 +++++++++++++++++++++++++++++----
>  crypto/algapi.c                |   2 +-
>  include/crypto/algapi.h        |  11 ++
>  include/crypto/hash.h          |  28 ++--
>  include/crypto/internal/hash.h |  10 ++
>  include/linux/crypto.h         |  24 +++
>  6 files changed, 299 insertions(+), 37 deletions(-)

The following patch seems to be breaking selftests in SA2UL driver.

The failure signature:

root@j721e-evm:~# modprobe sa2ul
[   32.254126] omap_rng 4e10000.rng: Random Number Generator ver. 241b34c
root@j721e-evm:~# [   32.374996] Unable to handle kernel paging request at virtual address fefefefefefeff46
[   32.401815] Unable to handle kernel paging request at virtual address fefefefefefeff46
[   32.449576] Unable to handle kernel paging request at virtual address fefefefefefeff46
[   32.459025] Mem abort info:
[   32.461812]   ESR = 0x0000000096000044
[   32.480762] Mem abort info:
[   32.503389]   ESR = 0x0000000096000044
[   32.512483]   EC = 0x25: DABT (current EL), IL = 32 bits
[   32.519478] Mem abort info:
[   32.534472]   EC = 0x25: DABT (current EL), IL = 32 bits
[   32.542380]   ESR = 0x0000000096000044
[   32.546123]   EC = 0x25: DABT (current EL), IL = 32 bits
[   32.554977]   SET = 0, FnV = 0
[   32.572112]   SET = 0, FnV = 0
[   32.579134]   EA = 0, S1PTW = 0
[   32.597889]   EA = 0, S1PTW = 0
[   32.603045]   FSC = 0x04: level 0 translation fault
[   32.615500]   SET = 0, FnV = 0
[   32.628186]   FSC = 0x04: level 0 translation fault
[   32.645274]   EA = 0, S1PTW = 0
[   32.651268] Data abort info:
[   32.654145]   ISV = 0, ISS = 0x00000044, ISS2 = 0x00000000
[   32.675265] Data abort info:
[   32.678614]   FSC = 0x04: level 0 translation fault
[   32.701391]   ISV = 0, ISS = 0x00000044, ISS2 = 0x00000000
[   32.721251] Data abort info:
[   32.725864]   CM = 0, WnR = 1, TnD = 0, TagAccess = 0
[   32.742907]   ISV = 0, ISS = 0x00000044, ISS2 = 0x00000000
[   32.751647]   CM = 0, WnR = 1, TnD = 0, TagAccess = 0
[   32.770854]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[   32.790381]   CM = 0, WnR = 1, TnD = 0, TagAccess = 0
[   32.795591]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[   32.807232] [fefefefefefeff46] address between user and kernel address ranges
[   32.826504]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[   32.832211] [fefefefefefeff46] address between user and kernel address ranges
[   32.854007] Internal error: Oops: 0000000096000044 [#1]  SMP
[   32.859661] Modules linked in: des_generic libdes cbc sa2ul authenc onboard_usb_dev rpmsg_ctrl rpmsg_char phy_cadence_torrent phy_cadence_sierra rtc_tps6594 pinctrl_tps6594 tps6594_esm tps6594_regulator gpio_regmap tps6594_pfsm ti_am335x_adc kfifo_buf pru_rproc cdns3 irq_pruss_intc cdns_pltfrm cdns_usb_common snd_soc_j721e_evm display_connector phy_can_transceiver phy_j721e_wiz omap_mailbox ti_k3_r5_remoteproc tidss tps6594_i2c drm_client_lib cdns_mhdp8546 drm_dma_helper tps6594_core at24 drm_display_helper k3_j72xx_bandgap drm_kms_helper m_can_platform m_can ti_am335x_tscadc pruss snd_soc_davinci_mcasp snd_soc_ti_udma ti_j721e_ufs can_dev snd_soc_ti_edma ti_k3_dsp_remoteproc snd_soc_ti_sdma cdns3_ti snd_soc_pcm3168a_i2c snd_soc_pcm3168a rti_wdt overlay cfg80211 rfkill fuse drm backlight ipv6
[   32.929820] CPU: 0 UID: 0 PID: 1253 Comm: cryptomgr_test Not tainted 6.14.0-rc7-next-20250324-build-configs-dirty #2 PREEMPT
[   32.941098] Hardware name: Texas Instruments J721e EVM (DT)
[   32.946653] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   32.953598] pc : crypto_ahash_init+0x6c/0xf0
[   32.957866] lr : crypto_ahash_init+0x50/0xf0
[   32.962124] sp : ffff8000851cb590
[   32.965425] x29: ffff8000851cb590 x28: 0000000000000000 x27: ffff8000851cb788
[   32.972546] x26: ffff000802dace00 x25: 0000000000000000 x24: ffff000804294010
[   32.979667] x23: ffff80007be3fb30 x22: 0000000000000000 x21: ffff0008095c1250
[   32.986787] x20: ffff000802dace90 x19: fefefefefefefefe x18: 00000000ffffffff
[   32.993908] x17: 0000000000373931 x16: 2d3732322d34322d x15: ffff8000851cb740
[   33.001028] x14: ffff8001051cbaa7 x13: 0000000000000000 x12: 0000000000000000
[   33.008148] x11: 0000000000000100 x10: 0000000000000001 x9 : ffff80007be3fadc
[   33.015268] x8 : ffff8000851cb668 x7 : 0000000000000000 x6 : 0010000000000000
[   33.022388] x5 : efcdab8967452301 x4 : 1032547698badcfe x3 : 00000000c3d2e1f0
[   33.029509] x2 : 0000000000000000 x1 : ffff0008095c1280 x0 : 0000000000000000
[   33.036629] Call trace:
[   33.039065]  crypto_ahash_init+0x6c/0xf0 (P)
[   33.043325]  sa_sha_init+0x4c/0xa0 [sa2ul]
[   33.047419]  ahash_do_req_chain+0x144/0x280
[   33.051591]  crypto_ahash_init+0xc8/0xf0
[   33.055502]  do_ahash_op+0x34/0xb8
[   33.058895]  test_ahash_vec_cfg+0x3e4/0x800
[   33.063068]  test_hash_vec+0xbc/0x230
[   33.066719]  __alg_test_hash+0x288/0x3d8
[   33.070629]  alg_test_hash+0x108/0x1a0
[   33.074367]  alg_test+0x148/0x658
[   33.077672]  cryptomgr_test+0x2c/0x50
[   33.081322]  kthread+0x134/0x218
[   33.084542]  ret_from_fork+0x10/0x20
[   33.088109] Code: eb13029f 540001e0 d503201f f94012a1 (f9002661)
[   33.094185] ---[ end trace 0000000000000000 ]---
[   33.100497] [fefefefefefeff46] address between user and kernel address ranges
[   33.114241] Internal error: Oops: 0000000096000044 [#2]  SMP
[   33.119887] Modules linked in: des_generic libdes cbc sa2ul authenc onboard_usb_dev rpmsg_ctrl rpmsg_char phy_cadence_torrent phy_cadence_sierra rtc_tps6594 pinctrl_tps6594 tps6594_esm tps6594_regulator gpio_regmap tps6594_pfsm ti_am335x_adc kfifo_buf pru_rproc cdns3 irq_pruss_intc cdns_pltfrm cdns_usb_common snd_soc_j721e_evm display_connector phy_can_transceiver phy_j721e_wiz omap_mailbox ti_k3_r5_remoteproc tidss tps6594_i2c drm_client_lib cdns_mhdp8546 drm_dma_helper tps6594_core at24 drm_display_helper k3_j72xx_bandgap drm_kms_helper m_can_platform m_can ti_am335x_tscadc pruss snd_soc_davinci_mcasp snd_soc_ti_udma ti_j721e_ufs can_dev snd_soc_ti_edma ti_k3_dsp_remoteproc snd_soc_ti_sdma cdns3_ti snd_soc_pcm3168a_i2c snd_soc_pcm3168a rti_wdt overlay cfg80211 rfkill fuse drm backlight ipv6
[   33.190029] CPU: 0 UID: 0 PID: 1256 Comm: cryptomgr_test Tainted: G      D             6.14.0-rc7-next-20250324-build-configs-dirty #2 PREEMPT
[   33.202868] Tainted: [D]=DIE
[   33.205737] Hardware name: Texas Instruments J721e EVM (DT)
[   33.211293] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   33.218236] pc : crypto_ahash_init+0x6c/0xf0
[   33.222498] lr : crypto_ahash_init+0x50/0xf0
[   33.226756] sp : ffff8000852ab590
[   33.230057] x29: ffff8000852ab590 x28: 0000000000000000 x27: ffff8000852ab788
[   33.237178] x26: ffff000807d69a00 x25: 0000000000000000 x24: ffff000804204810
[   33.244298] x23: ffff80007be3fb30 x22: 0000000000000000 x21: ffff0008095c1890
[   33.251419] x20: ffff000807d69a90 x19: fefefefefefefefe x18: 00000000ffffffff
[   33.258539] x17: 0000000000000000 x16: 0000000000000000 x15: ffff8000852ab740
[   33.265659] x14: ffff8001052abaa7 x13: 0000000000000000 x12: 0000000000000000
[   33.272779] x11: 0000000000000000 x10: ffff00087f7c8308 x9 : ffff80007be3fadc
[   33.279899] x8 : bb67ae8584caa73b x7 : 3c6ef372fe94f82b x6 : a54ff53a5f1d36f1
[   33.287019] x5 : 510e527fade682d1 x4 : 9b05688c2b3e6c1f x3 : 1f83d9abfb41bd6b
[   33.294139] x2 : 5be0cd19137e2179 x1 : ffff0008095c1100 x0 : 0000000000000000
[   33.301259] Call trace:
[   33.303695]  crypto_ahash_init+0x6c/0xf0 (P)
[   33.307954]  sa_sha_init+0x4c/0xa0 [sa2ul]
[   33.312045]  ahash_do_req_chain+0x144/0x280
[   33.316217]  crypto_ahash_init+0xc8/0xf0
[   33.320129]  do_ahash_op+0x34/0xb8
[   33.323520]  test_ahash_vec_cfg+0x3e4/0x800
[   33.327691]  test_hash_vec+0xbc/0x230
[   33.331341]  __alg_test_hash+0x288/0x3d8
[   33.335252]  alg_test_hash+0x108/0x1a0
[   33.338990]  alg_test+0x148/0x658
[   33.342294]  cryptomgr_test+0x2c/0x50
[   33.345944]  kthread+0x134/0x218
[   33.349161]  ret_from_fork+0x10/0x20
[   33.352727] Code: eb13029f 540001e0 d503201f f94012a1 (f9002661)
[   33.358803] ---[ end trace 0000000000000000 ]---
[   33.363437] Internal error: Oops: 0000000096000044 [#3]  SMP
[   33.369081] Modules linked in: des_generic libdes cbc sa2ul authenc onboard_usb_dev rpmsg_ctrl rpmsg_char phy_cadence_torrent phy_cadence_sierra rtc_tps6594 pinctrl_tps6594 tps6594_esm tps6594_regulator gpio_regmap tps6594_pfsm ti_am335x_adc kfifo_buf pru_rproc cdns3 irq_pruss_intc cdns_pltfrm cdns_usb_common snd_soc_j721e_evm display_connector phy_can_transceiver phy_j721e_wiz omap_mailbox ti_k3_r5_remoteproc tidss tps6594_i2c drm_client_lib cdns_mhdp8546 drm_dma_helper tps6594_core at24 drm_display_helper k3_j72xx_bandgap drm_kms_helper m_can_platform m_can ti_am335x_tscadc pruss snd_soc_davinci_mcasp snd_soc_ti_udma ti_j721e_ufs can_dev snd_soc_ti_edma ti_k3_dsp_remoteproc snd_soc_ti_sdma cdns3_ti snd_soc_pcm3168a_i2c snd_soc_pcm3168a rti_wdt overlay cfg80211 rfkill fuse drm backlight ipv6
[   33.439214] CPU: 0 UID: 0 PID: 1255 Comm: cryptomgr_test Tainted: G      D             6.14.0-rc7-next-20250324-build-configs-dirty #2 PREEMPT
[   33.452052] Tainted: [D]=DIE
[   33.454921] Hardware name: Texas Instruments J721e EVM (DT)
[   33.460476] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   33.467419] pc : crypto_ahash_init+0x6c/0xf0
[   33.471678] lr : crypto_ahash_init+0x50/0xf0
[   33.475935] sp : ffff8000851fb590
[   33.479236] x29: ffff8000851fb590 x28: 0000000000000000 x27: ffff8000851fb788
[   33.486357] x26: ffff000808b0da00 x25: 0000000000000000 x24: ffff000801270c10
[   33.493477] x23: ffff80007be3fb30 x22: 0000000000000000 x21: ffff0008095c1490
[   33.500596] x20: ffff000808b0da90 x19: fefefefefefefefe x18: 00000000ffffffff
[   33.507717] x17: 0000000000000000 x16: 0000000000000000 x15: ffff8000851fb740
[   33.514837] x14: ffff8001051fbaa7 x13: 0000000000000000 x12: 0000000000000000
[   33.521956] x11: 0000000000000000 x10: ffff00087f7c8308 x9 : ffff80007be3fadc
[   33.529077] x8 : ffff8000851fb668 x7 : 0000000000000000 x6 : 0010000000000000
[   33.536197] x5 : bb67ae856a09e667 x4 : a54ff53a3c6ef372 x3 : 9b05688c510e527f
[   33.543316] x2 : 5be0cd191f83d9ab x1 : ffff0008095c1680 x0 : 0000000000000000
[   33.550437] Call trace:
[   33.552871]  crypto_ahash_init+0x6c/0xf0 (P)
[   33.557130]  sa_sha_init+0x4c/0xa0 [sa2ul]
[   33.561217]  ahash_do_req_chain+0x144/0x280
[   33.565388]  crypto_ahash_init+0xc8/0xf0
[   33.569299]  do_ahash_op+0x34/0xb8
[   33.572691]  test_ahash_vec_cfg+0x3e4/0x800
[   33.576861]  test_hash_vec+0xbc/0x230
[   33.580512]  __alg_test_hash+0x288/0x3d8
[   33.584423]  alg_test_hash+0x108/0x1a0
[   33.588161]  alg_test+0x148/0x658
[   33.591465]  cryptomgr_test+0x2c/0x50
[   33.595115]  kthread+0x134/0x218
[   33.598334]  ret_from_fork+0x10/0x20
[   33.601898] Code: eb13029f 540001e0 d503201f f94012a1 (f9002661)
[   33.607973] ---[ end trace 0000000000000000 ]---
[   47.186729] kauditd_printk_skb: 5 callbacks suppressed
[   47.186738] audit: type=1334 audit(1742976993.333:24): prog-id=20 op=UNLOAD
[   47.200991] audit: type=1334 audit(1742976993.345:25): prog-id=19 op=UNLOAD
[   47.208310] audit: type=1334 audit(1742976993.345:26): prog-id=18 op=UNLOAD

Don't have sufficient knowledge to understand what is going wrong with
this change, could you help out?

Regards,
Manorit
