Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF3C1FC7F5
	for <linux-crypto@vger.kernel.org>; Thu, 20 Feb 2025 14:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740061636; cv=none; b=bqUrnmk9zG3kjKJyURrPTFi7c/ZkeZnheU5HQPuCGFTEUcwXAsBeYcxN82o3pN8uCAiThwlkGSw+mYpIEMWBLaAuc9m6hT33ovJUcFOlZqs54EFWyqmkXRZtsIUdcF9gXtGPMHIrcvlCMhKrAY1/w2ay5A7Zdr2E3kxeKdgSxkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740061636; c=relaxed/simple;
	bh=D6cKUGAMjY2KP9aAcuVHBx8VTJJeLQ/lOCGq6SoaKoY=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WUBAwsrbqdtuDwVkMEdQjrGSXhE57lXQCoDA2hClvc+HntASMFUyhJwJPU8gZvqLyAZXMeHOR+ikU0k2dmoBIFg8uEMkHkDEfIq3+jnfX8XBPjCb+I+owQoeOqk6qsrAblCBAygwZnN9PD8HvQ+yLZ2Ea8EE5Lj51L2dLTQ8XKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=1m3xmRyk; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="1m3xmRyk"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-309311e7b39so9257811fa.2
        for <linux-crypto@vger.kernel.org>; Thu, 20 Feb 2025 06:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1740061633; x=1740666433; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:references:mime-version:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=f4w4pCG0U42bM1eFKeaBN0EiFoNbUjvKtinnx1nWT1E=;
        b=1m3xmRykIuZhKeySuszDijNS5tRgWKAj3JorvIq88ISoinxUpTQqYJ8kElekvXgTnL
         hx3K9+bo+Sv40qqPlCkdYWDol0/+UivyxvriNVn3fhfifaYGofdvXCWqpMZd7I9VosKS
         3/u1NCKXNvaXf7MT8iouYxLoK4kQQ11B14CzKaXb/Y5Pj6eNyuI8tE5aJHefEvMwU1Cq
         ey4tnWvMGRUdaG92IR9swdufHVZ9gCXUeSJP5ShNYvni6jM6afPTA+MPNoXBdrB4O5Z4
         KPuwd2G3w2NCe5Cn60iA9aUQSqueXs3suE+J1Pvu23Mt+BBU90emWuV49welFUqCXnuv
         ZOUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740061633; x=1740666433;
        h=cc:to:subject:message-id:date:references:mime-version:in-reply-to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f4w4pCG0U42bM1eFKeaBN0EiFoNbUjvKtinnx1nWT1E=;
        b=B3wAcZUJHHoDRepUpBiAqCtRTa7OFBJkVkVrWB379thpT1xb7gMQA1j5UHPgh2kIMK
         bWJIEKFmDDgPlPVcx//iJ35ZN0iuj8S79+MwETDS2zIN9pW6naflvnQgrIIBlWpsd9GW
         OjymXhnfERa/oY7/MXdUQtol1p7ZDCQ7YWyenJGt2xvINecRU4tJp2O12QI2WLx2FjzD
         Ff6dPMuELbaxIevaHUshJcAXZNmNEfniad3O4tH6iC5j8RS8v2W337JDCafIU9uAGoJK
         EebrFvM5fJIQ9sActqJWxeyzIrBpCCvuxYd1nZPnDX4BsSuNwcLiXTYqCn54EftkHmmE
         db5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVyxt1NtgK2MulxurZui2ieq5ufPgLGm/U5OO+4C47NtmPu/9QwtmRwfCOSAQ8JqHlxut0fAvxQeIFKoHA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhBC8hiKoXLnG79TAYeBKVmN8ttOw/pCN7HH/YkyvA2y5TNac5
	BTfP+NY/E3uXmhYrp7qYA5+bXwv5qXZnum1PaDhAUdXV73vYbpKifuwPenWChBn1y6tFMMzWfdE
	LeG9PTDm1L2aQZDVIQXDIfKP99QldA2lnalapLQ==
X-Gm-Gg: ASbGncsNjulJupU08PqKYe6zzeCTe+pMtJh3MJOwdOrsWOQVYOHbt4q94MFVVfeU8Fi
	LIbsiIT0DFSRDhLakCf6pSw5oScK7EvY6oDqA2qV4zLZJa0WNG0qUxzJxlHlaKqkUMcS/DztDIZ
	8FWH7NWW1ccyPs5s6tHdSyeMtALes=
X-Google-Smtp-Source: AGHT+IFS//uyEFsNocKn2QLBwjZb9V54vS30Ztrpi06h9vM6OhVZ6S9T58uetg7ksyx1gj4KaWKe+Evafv0S+hCPfHg=
X-Received: by 2002:a2e:900f:0:b0:309:26cd:9304 with SMTP id
 38308e7fff4ca-30a45043f96mr31527421fa.26.1740061632696; Thu, 20 Feb 2025
 06:27:12 -0800 (PST)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 20 Feb 2025 15:27:11 +0100
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 20 Feb 2025 15:27:11 +0100
From: brgl@bgdev.pl
In-Reply-To: <20250115103004.3350561-1-quic_mdalam@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250115103004.3350561-1-quic_mdalam@quicinc.com>
Date: Thu, 20 Feb 2025 15:27:11 +0100
X-Gm-Features: AWEUYZnDIRu5h76xjpO3J8aX5TCNfdHy8wWm6gSkGIVob_i8mUp6Yw4WICtLlfY
Message-ID: <CAMRc=MeW7D+6rUNWBQ61kP-zx9paiLKFF-Y7SbFq+_fRKiq8=w@mail.gmail.com>
Subject: Re: [PATCH v6 00/12] dmaengine: qcom: bam_dma: add cmd descriptor support
To: Md Sadre Alam <quic_mdalam@quicinc.com>
Cc: quic_utiwari@quicinc.com, quic_srichara@quicinc.com, 
	quic_varada@quicinc.com, vkoul@kernel.org, corbet@lwn.net, 
	thara.gopinath@gmail.com, herbert@gondor.apana.org.au, davem@davemloft.net, 
	martin.petersen@oracle.com, enghua.yu@intel.com, u.kleine-koenig@baylibre.com, 
	dmaengine@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 15 Jan 2025 11:29:52 +0100, Md Sadre Alam
<quic_mdalam@quicinc.com> said:
> Requirements:
>   In QCE crypto driver we are accessing the crypto engine registers
>   directly via CPU read/write. Trust Zone could possibly to perform some
>   crypto operations simultaneously, a race condition will be created and
>   this could result in undefined behavior.
>
>   To avoid this behavior we need to use BAM HW LOCK/UNLOCK feature on BAM
>   pipes, and this LOCK/UNLOCK will be set via sending a command descriptor,
>   where the HLOS/TZ QCE crypto driver prepares a command descriptor with a
>   dummy write operation on one of the QCE crypto engine register and pass
>   the LOCK/UNLOCK flag along with it.
>

On rb3gen2 I'm seeing the following when running cryptsetup benchmark:

# cryptsetup benchmark
# Tests are approximate using memory only (no storage IO).
PBKDF2-sha1      1452321 iterations per second for 256-bit key
PBKDF2-sha256    2641249 iterations per second for 256-bit key
PBKDF2-sha512    1278751 iterations per second for 256-bit key
PBKDF2-ripemd160  760940 iterations per second for 256-bit key
PBKDF2-whirlpool     N/A
argon2i       4 iterations, 1008918 memory, 4 parallel threads (CPUs)
for 256-bit key (requested 2000 ms time)
argon2id      4 iterations, 1048576 memory, 4 parallel threads (CPUs)
for 256-bit key (requested 2000 ms time)
[   43.558496] NET: Registered PF_ALG protocol family
[   43.570034] arm-smmu 15000000.iommu: Unhandled context fault:
fsr=0x402, iova=0xfffdf000, fsynr=0x7b0003, cbfrsynra=0x4e4, cb=0
[   43.582069] arm-smmu 15000000.iommu: FSR    = 00000402 [Format=2
TF], SID=0x4e4
[   43.592758] arm-smmu 15000000.iommu: FSYNR0 = 007b0003 [S1CBNDX=123 PLVL=3]
[   43.608107] Internal error: synchronous external abort:
0000000096000010 [#1] PREEMPT SMP
[   43.616509] Modules linked in: algif_skcipher af_alg bluetooth
ecdh_generic ecc ipv6 snd_soc_hdmi_codec phy_qcom_edp venus_dec
venus_enc videobuf2_dma_contig videobuf2_memops nb7vpq904m
lontium_lt9611uxc msm leds_qcom_lpg qcom_battmgr pmic_glink_altmode
aux_hpd_bridge ocmem qcom_pbs venus_core ucsi_glink drm_exec
typec_ucsi qcom_pon qcom_spmi_adc5 led_class_multicolor
qcom_spmi_temp_alarm rtc_pm8xxx gpu_sched v4l2_mem2mem ath11k_ahb
qcom_vadc_common nvmem_qcom_spmi_sdam drm_dp_aux_bus videobuf2_v4l2
qcom_stats dispcc_sc7280 drm_display_helper videodev ath11k
videobuf2_common coresight_stm drm_client_lib camcc_sc7280
videocc_sc7280 mac80211 mc i2c_qcom_geni phy_qcom_qmp_combo stm_core
coresight_replicator aux_bridge coresight_tmc coresight_funnel
llcc_qcom libarc4 gpi icc_bwmon typec phy_qcom_snps_femto_v2 coresight
qcrypto qcom_q6v5_pas authenc qcom_pil_info qcom_q6v5 gpucc_sc7280
ufs_qcom libdes qcom_sysmon qcom_common pinctrl_sc7280_lpass_lpi
qcom_glink_smem mdt_loader phy_qcom_qmp_ufs lpassaudiocc_sc7280
[   43.616763]  pinctrl_lpass_lpi cfg80211 phy_qcom_qmp_pcie
icc_osm_l3 rfkill qcom_rng qrtr nvmem_reboot_mode display_connector
socinfo drm_kms_helper pmic_glink pdr_interface qcom_pdr_msg
qmi_helpers drm backlight
[   43.727571] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted
6.14.0-rc3-next-20250220-00012-g2a8d60663e03-dirty #53
[   43.738291] Hardware name: Qualcomm Technologies, Inc. Robotics RB3gen2 (DT)
[   43.745535] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   43.752685] pc : bam_dma_irq+0x374/0x3b0
[   43.756736] lr : bam_dma_irq+0x2c8/0x3b0
[   43.760781] sp : ffff800080003e90
[   43.764200] x29: ffff800080003e90 x28: ffffd03eaae84880 x27: 000000009edf8000
[   43.771543] x26: ffff45a746642c80 x25: 0000000a24f8499b x24: ffff45a742dca080
[   43.778886] x23: ffff45a742df7600 x22: 000000000000006e x21: ffff8000811c3000
[   43.786228] x20: ffff45a742df7630 x19: ffff45a742eaab80 x18: 0000000000000001
[   43.793568] x17: ffff75698e7b4000 x16: ffff800080000000 x15: 0000000000000034
[   43.800902] x14: 0000000000000038 x13: 0000000000010008 x12: 071c71c71c71c71c
[   43.808244] x11: 0000000000000040 x10: ffff45a74000a230 x9 : ffff45a74000a228
[   43.815587] x8 : ffff45a7407a1dd0 x7 : 0000000000000000 x6 : 0000000000000000
[   43.822920] x5 : ffff45a7407a1da8 x4 : 0000000000000000 x3 : 0000000000000018
[   43.830253] x2 : ffff8000811c0000 x1 : ffff8000811c0018 x0 : 0000000000000002
[   43.837594] Call trace:
[   43.840115]  bam_dma_irq+0x374/0x3b0 (P)
[   43.844163]  __handle_irq_event_percpu+0x48/0x140
[   43.849006]  handle_irq_event+0x4c/0xb0
[   43.852961]  handle_fasteoi_irq+0xa0/0x1bc
[   43.857186]  handle_irq_desc+0x34/0x58
[   43.861054]  generic_handle_domain_irq+0x1c/0x28
[   43.865812]  gic_handle_irq+0x4c/0x120
[   43.869680]  call_on_irq_stack+0x24/0x64
[   43.873728]  do_interrupt_handler+0x80/0x84
[   43.878039]  el1_interrupt+0x34/0x68
[   43.881732]  el1h_64_irq_handler+0x18/0x24
[   43.885955]  el1h_64_irq+0x6c/0x70
[   43.889465]  cpuidle_enter_state+0xac/0x320 (P)
[   43.894133]  cpuidle_enter+0x38/0x50
[   43.897826]  do_idle+0x1e4/0x260
[   43.901151]  cpu_startup_entry+0x38/0x3c
[   43.905195]  rest_init+0xdc/0xe0
[   43.908531]  console_on_rootfs+0x0/0x6c
[   43.912490]  __primary_switched+0x88/0x90
[   43.916621] Code: b9409063 1b047c21 8b030021 8b010041 (b9000020)
[   43.922881] ---[ end trace 0000000000000000 ]---
[   43.927633] Kernel panic - not syncing: synchronous external abort:
Fatal exception in interrupt
[   43.936653] SMP: stopping secondary CPUs
[   43.941042] Kernel Offset: 0x503e28e00000 from 0xffff800080000000
[   43.947306] PHYS_OFFSET: 0xfff0ba59c0000000
[   43.951615] CPU features: 0x300,00000170,00801250,8200720b
[   43.957257] Memory Limit: none
[   43.960405] ---[ end Kernel panic - not syncing: synchronous
external abort: Fatal exception in interrupt ]---

Bartosz
