Received: from lelvem-ot01.ext.ti.com (lelvem-ot01.ext.ti.com [198.47.23.234])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337FC1FF60B
	for <linux-crypto@vger.kernel.org>; Thu, 27 Mar 2025 07:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.234
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743060888; cv=none; b=Sf5C6acEIWHZHu6Hx2F7DEGAFniDIGAg0DCpSPrhi6qOKeSC0BvWLwYNhMWOUpI60ExJ0iHDNtHT0JnkjzqixhNnNz1ow1y7TNTt965N2b7GocOYmQqPs6CEX+TU8Ii8L2vUOjwjPFMJK4qrxoN89WxyLutG9pRoP6/BRDpPVX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743060888; c=relaxed/simple;
	bh=grtuwomLnm/MzT12jjV5K5Kc8WfZdyDRdZs9DHMVb7s=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CPPWRUph95AHA/N2BU1hJMxKXnNlXb7W195tafSqp27O14IsVPF3+/dNaLidr6iPEA67R6B89rK1loKGht21pD3tobUbQzNwHhXfV8L/1qik7CdzSOl9yljxCo9RLYO0O0tt63r7npDG/QSpegyCfEJUpw1fwSEWEny6iWz+GrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=szR+/Ur2; arc=none smtp.client-ip=198.47.23.234
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="szR+/Ur2"
Received: from fllv0035.itg.ti.com ([10.64.41.0])
	by lelvem-ot01.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 52R7YTRv1787121
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Mar 2025 02:34:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1743060869;
	bh=9pE7B0aGpxxYqQApalXqmK7THOj0jxfA0KyrmIKkWHE=;
	h=Date:From:To:CC:Subject:References:In-Reply-To;
	b=szR+/Ur2cNcUIYtVC129aepYYRH6kuoiA/cfDp95UXub+rZhNaen2FVgcvgOQjMbX
	 a64vAdCGT4/X3vpffERTurXCCovw3vNjVtLqY7vaa+o41WaPBSIlu+m4namI9csH1k
	 Ust2steaG669izdAt8X009L9kVylNoOAOW3EOXDg=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
	by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 52R7YTc8120437
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 27 Mar 2025 02:34:29 -0500
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Thu, 27
 Mar 2025 02:34:29 -0500
Received: from lelvsmtp5.itg.ti.com (10.180.75.250) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Thu, 27 Mar 2025 02:34:29 -0500
Received: from localhost (uda0497581-hp.dhcp.ti.com [172.24.227.253])
	by lelvsmtp5.itg.ti.com (8.15.2/8.15.2) with ESMTP id 52R7YSbU029797;
	Thu, 27 Mar 2025 02:34:28 -0500
Date: Thu, 27 Mar 2025 13:04:27 +0530
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
Subject: Re: [v2 PATCH] crypto: sa2ul - Use proper helpers to setup request
Message-ID: <20250327073427.amcyd4t6qvs7kw35@uda0497581-HP>
References: <cover.1739674648.git.herbert@gondor.apana.org.au>
 <2620cdada3777a66d3600cd1887cd34245d1e26a.1739674648.git.herbert@gondor.apana.org.au>
 <20250326090035.izxxf3sboom7hvcv@uda0497581-HP>
 <Z-PGEtO8JmyC5xU_@gondor.apana.org.au>
 <20250326100027.trel4le7mpadtaft@uda0497581-HP>
 <Z-PRckWg9Yw1hOVj@gondor.apana.org.au>
 <20250326123120.wjsldcblqhs5e2ta@uda0497581-HP>
 <Z-P78_9NKGMBFs3s@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z-P78_9NKGMBFs3s@gondor.apana.org.au>
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Hi Herbert,

On 21:06-20250326, Herbert Xu wrote:
> On Wed, Mar 26, 2025 at 06:01:20PM +0530, Manorit Chawdhry wrote:
> >
> > Thanks for the fix! Although, it still fails probably due to the
> > introduction of multibuffer hash testing in "crypto: testmgr - Add
> > multibuffer hash testing" but that we will have to fix for our driver I
> > assume.
> > 
> > [   32.408283] alg: ahash: sha1-sa2ul digest() failed on test vector 0; expected_error=0, actual_error=-22, cfg="random: inplace_two_sglists may_sleep use_digest multibuffer(9/13/uneven) src_divs=[100.0%@+860] key_offset=17"
> > [...]
> > [   32.885927] alg: ahash: sha512-sa2ul digest() failed on test vector 0; expected_error=0, actual_error=-22, cfg="random: use_digest multibuffer(6/9/uneven) nosimd src_divs=[93.34%@+3634, 6.66%@+16] iv_offset=9 key_offset=70"
> > [...]
> > [   33.135286] alg: ahash: sha256-sa2ul digest() failed on test vector 0; expected_error=0, actual_error=-22, cfg="random: inplace_two_sglists may_sleep use_digest multibuffer(15/16/uneven) src_divs=[100.0%@alignmask+26] key_offset=1"
> 
> There are no other messages?

This is the full failure log:

root@j721e-evm:~# modprobe sa2ul
[59910.170612] omap_rng 4e10000.rng: Random Number Generator ver. 241b34c
root@j721e-evm:~# [59910.331792] alg: ahash: sha1-sa2ul digest() failed on test vector 0; expected_error=0, actual_error=-22, cfg="random: may_sleep use_digest multibuffer(0/10/uneven) src_divs=[53.50%@+816, 14.50%@+2101, 32.0%@+1281] key_offset=114"
[59910.354517] alg: ahash: sha512-sa2ul digest() failed on test vector 0; expected_error=0, actual_error=-22, cfg="random: may_sleep use_digest multibuffer(0/6/uneven) src_divs=[3.96%@+26, 88.54%@+3968, 7.50%@+20] dst_divs=[100.0%@alignmask+2] key_offset=33"
[59910.454646] alg: ahash: sha256-sa2ul digest() failed on test vector 0; expected_error=0, actual_error=-22, cfg="random: use_digest multibuffer(4/14/uneven) nosimd src_divs=[50.0%@+29, 25.0%@+28, 25.0%@+4] key_offset=65"
[59910.494415] alg: self-tests for sha1 using sha1-sa2ul failed (rc=-22)
[59910.494424] ------------[ cut here ]------------
[59910.505522] alg: self-tests for sha1 using sha1-sa2ul failed (rc=-22)
[59910.512463] alg: self-tests for sha512 using sha512-sa2ul failed (rc=-22)
[59910.548673] ------------[ cut here ]------------
[59910.560115] alg: self-tests for sha512 using sha512-sa2ul failed (rc=-22)
[59910.577041] WARNING: CPU: 0 PID: 1959 at crypto/testmgr.c:5997 alg_test+0x5d0/0x658
[59910.591470] Modules linked in: sa2ul authenc des_generic libdes cbc onboard_usb_dev rpmsg_ctrl rpmsg_char phy_cadence_torrent phy_cadence_sierra rtc_tps6594 tps6594_pfsm tps6594_esm pinctrl_tps6594 tps6594_regulator gpio_regmap ti_am335x_adc kfifo_buf pru_rproc irq_pruss_intc cdns3 cdns_usb_common cdns_pltfrm snd_soc_j721e_evm display_connector phy_j721e_wiz phy_can_transceiver omap_mailbox ti_k3_r5_remoteproc at24 tps6594_i2c tps6594_core tidss drm_client_lib k3_j72xx_bandgap drm_dma_helper cdns_mhdp8546 m_can_platform drm_display_helper m_can ti_am335x_tscadc pruss drm_kms_helper snd_soc_pcm3168a_i2c snd_soc_davinci_mcasp can_dev snd_soc_pcm3168a snd_soc_ti_udma snd_soc_ti_edma ti_j721e_ufs ti_k3_dsp_remoteproc cdns3_ti snd_soc_ti_sdma rti_wdt overlay cfg80211 rfkill fuse drm backlight ipv6 [last unloaded: authenc]
[59910.663794] CPU: 0 UID: 0 PID: 1959 Comm: cryptomgr_test Tainted: G        W          6.14.0-rc1-build-configs-00186-g8b54e6a8f415-dirty #1
[59910.676286] Tainted: [W]=WARN
[59910.679241] Hardware name: Texas Instruments J721e EVM (DT)
[59910.684797] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[59910.691740] pc : alg_test+0x5d0/0x658
[59910.695392] lr : alg_test+0x5d0/0x658
[59910.699042] sp : ffff80008515bd40
[59910.702343] x29: ffff80008515bde0 x28: 0000000000000000 x27: 0000000000000000
[59910.709464] x26: 00000000ffffffea x25: 00000000ffffffff x24: 000000000000017b
[59910.716585] x23: ffff80008384be88 x22: 000000000000118f x21: ffff0008032c5a80
[59910.723705] x20: ffff0008032c5a00 x19: ffff8000814bf320 x18: 0000000002004c00
[59910.730825] x17: 0000000002004400 x16: 00000000000000ee x15: cb299d3b567fbd0e
[59910.737945] x14: 6cc9dff4249846de x13: 0000000000000000 x12: 0000000000020005
[59910.745066] x11: 000000e200000016 x10: 0000000000000af0 x9 : ffff8000800f8ba0
[59910.752186] x8 : ffff000809b10b50 x7 : 00000000005285f6 x6 : 000000000000001e
[59910.759305] x5 : 0000000000000000 x4 : 0000000000000002 x3 : 0000000000000208
[59910.766425] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff000809b10000
[59910.773545] Call trace:
[59910.775981]  alg_test+0x5d0/0x658 (P)
[59910.779634]  cryptomgr_test+0x2c/0x50
[59910.783286]  kthread+0x134/0x218
[59910.786504]  ret_from_fork+0x10/0x20
[59910.790070] ---[ end trace 0000000000000000 ]---
[59910.799050] alg: self-tests for sha256 using sha256-sa2ul failed (rc=-22)
[59910.799057] ------------[ cut here ]------------
[59910.810440] alg: self-tests for sha256 using sha256-sa2ul failed (rc=-22)
[59910.810468] WARNING: CPU: 0 PID: 1962 at crypto/testmgr.c:5997 alg_test+0x5d0/0x658
[59910.824882] Modules linked in: sa2ul authenc des_generic libdes cbc onboard_usb_dev rpmsg_ctrl rpmsg_char phy_cadence_torrent phy_cadence_sierra rtc_tps6594 tps6594_pfsm tps6594_esm pinctrl_tps6594 tps6594_regulator gpio_regmap ti_am335x_adc kfifo_buf pru_rproc irq_pruss_intc cdns3 cdns_usb_common cdns_pltfrm snd_soc_j721e_evm display_connector phy_j721e_wiz phy_can_transceiver omap_mailbox ti_k3_r5_remoteproc at24 tps6594_i2c tps6594_core tidss drm_client_lib k3_j72xx_bandgap drm_dma_helper cdns_mhdp8546 m_can_platform drm_display_helper m_can ti_am335x_tscadc pruss drm_kms_helper snd_soc_pcm3168a_i2c snd_soc_davinci_mcasp can_dev snd_soc_pcm3168a snd_soc_ti_udma snd_soc_ti_edma ti_j721e_ufs ti_k3_dsp_remoteproc cdns3_ti snd_soc_ti_sdma rti_wdt overlay cfg80211 rfkill fuse drm backlight ipv6 [last unloaded: authenc]
[59910.897196] CPU: 0 UID: 0 PID: 1962 Comm: cryptomgr_test Tainted: G        W          6.14.0-rc1-build-configs-00186-g8b54e6a8f415-dirty #1
[59910.909688] Tainted: [W]=WARN
[59910.912642] Hardware name: Texas Instruments J721e EVM (DT)
[59910.918198] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[59910.925141] pc : alg_test+0x5d0/0x658
[59910.928792] lr : alg_test+0x5d0/0x658
[59910.932443] sp : ffff800085313d40
[59910.935744] x29: ffff800085313de0 x28: 0000000000000000 x27: 0000000000000000
[59910.942865] x26: 00000000ffffffea x25: 00000000ffffffff x24: 000000000000018d
[59910.949986] x23: ffff80008384be88 x22: 000000000000118f x21: ffff000808b03e80
[59910.957106] x20: ffff000808b03e00 x19: ffff8000814bf320 x18: 00000000fffffffe
[59910.964226] x17: ffff8007fd27e000 x16: ffff800080000000 x15: ffff8000852bb8e0
[59910.971346] x14: 0000000000000000 x13: ffff800083814452 x12: 0000000000000000
[59910.978465] x11: ffff00087f7a4d80 x10: 0000000000000af0 x9 : ffff8000800f8ba0
[59910.985586] x8 : ffff0008052e8b50 x7 : 0000000000019aff x6 : 000000000000000d
[59910.992705] x5 : 0000000000000000 x4 : 0000000000000002 x3 : 0000000000000208
[59910.999825] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0008052e8000
[59911.006946] Call trace:
[59911.009382]  alg_test+0x5d0/0x658 (P)
[59911.013034]  cryptomgr_test+0x2c/0x50
[59911.016685]  kthread+0x134/0x218
[59911.019905]  ret_from_fork+0x10/0x20
[59911.023469] ---[ end trace 0000000000000000 ]---
[59911.028107] WARNING: CPU: 0 PID: 1961 at crypto/testmgr.c:5997 alg_test+0x5d0/0x658
[59911.035749] Modules linked in: sa2ul authenc des_generic libdes cbc onboard_usb_dev rpmsg_ctrl rpmsg_char phy_cadence_torrent phy_cadence_sierra rtc_tps6594 tps6594_pfsm tps6594_esm pinctrl_tps6594 tps6594_regulator gpio_regmap ti_am335x_adc kfifo_buf pru_rproc irq_pruss_intc cdns3 cdns_usb_common cdns_pltfrm snd_soc_j721e_evm display_connector phy_j721e_wiz phy_can_transceiver omap_mailbox ti_k3_r5_remoteproc at24 tps6594_i2c tps6594_core tidss drm_client_lib k3_j72xx_bandgap drm_dma_helper cdns_mhdp8546 m_can_platform drm_display_helper m_can ti_am335x_tscadc pruss drm_kms_helper snd_soc_pcm3168a_i2c snd_soc_davinci_mcasp can_dev snd_soc_pcm3168a snd_soc_ti_udma snd_soc_ti_edma ti_j721e_ufs ti_k3_dsp_remoteproc cdns3_ti snd_soc_ti_sdma rti_wdt overlay cfg80211 rfkill fuse drm backlight ipv6 [last unloaded: authenc]
[59911.108050] CPU: 0 UID: 0 PID: 1961 Comm: cryptomgr_test Tainted: G        W          6.14.0-rc1-build-configs-00186-g8b54e6a8f415-dirty #1
[59911.120541] Tainted: [W]=WARN
[59911.123495] Hardware name: Texas Instruments J721e EVM (DT)
[59911.129049] pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[59911.135992] pc : alg_test+0x5d0/0x658
[59911.139643] lr : alg_test+0x5d0/0x658
[59911.143293] sp : ffff8000852bbd40
[59911.146594] x29: ffff8000852bbde0 x28: 0000000000000000 x27: 0000000000000000
[59911.153714] x26: 00000000ffffffea x25: 00000000ffffffff x24: 000000000000017f
[59911.160835] x23: ffff80008384be88 x22: 000000000000118f x21: ffff000803f5aa80
[59911.167954] x20: ffff000803f5aa00 x19: ffff8000814bf320 x18: 00000000fffffffe
[59911.175074] x17: ffff8007fd27e000 x16: ffff800080000000 x15: 0000000000000000
[59911.182194] x14: 00003d0971c5fa00 x13: ffffffff919fcffd x12: 0000000000000000
[59911.189313] x11: ffff00087f7a4d80 x10: 0000000000000af0 x9 : ffff8000800f8ba0
[59911.196433] x8 : ffff000809a37450 x7 : 0000000000026a7c x6 : 000000000000000f
[59911.203553] x5 : 0000000000000000 x4 : 0000000000000002 x3 : 0000000000000208
[59911.210672] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff000809a36900
[59911.217793] Call trace:
[59911.220227]  alg_test+0x5d0/0x658 (P)
[59911.223879]  cryptomgr_test+0x2c/0x50
[59911.227529]  kthread+0x134/0x218
[59911.230746]  ret_from_fork+0x10/0x20
[59911.234310] ---[ end trace 0000000000000000 ]---

> 
> This means that one of the filler test requests triggered an EINVAL
> from your driver.  A filler request in an uneven test can range from
> 0 to 2 * PAGE_SIZE bytes long.
> 

I tracked it down and see [0] returning -EINVAL. Do you have any
insights as to what changed that it's not working anymore...

[0]: https://github.com/torvalds/linux/blob/38fec10eb60d687e30c8c6b5420d86e8149f7557/drivers/crypto/sa2ul.c#L1177

Regards,
Manorit

> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
