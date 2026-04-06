Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E2033064A
	for <linux-crypto@vger.kernel.org>; Mon,  6 Apr 2026 15:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775491189; cv=none; b=an6d+1ur3c7h5E5EiXp9lnlObDmcAGJCG9qBF+6hepEk7xahT1lhx8MGT/8a+z7hKKsgz4V7Pyp7NZQUVPo1fndSaNsbfhD/GYVMgk2AJHex5sM8twmwTVCuzSvVuZNAFRf7LbKL1CDD686F3vS/MoIBlDD3nGxh4njDVkRJ7z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775491189; c=relaxed/simple;
	bh=Fs64JQKrSxYOf6f114JYVTywtVIpHrSO1lQ7xnNQ2w0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m3TOu+nuncwLtHOZMbO4br9l1rwTBJ533hWKi9AuTF9kztpknlLlZLjX5BuiU8xSMP8Y+bAKv+IRSep+TGKtm8BG9RglYw/R9DjB98T26Bw4HY5xG6ma+7vIbR21HiKnfkkzkaqNkFGb4c4uKWj5fN+8Sdy4mWGMzQuxqXf2Cl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZwGuYaUH; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=A3xadl8F; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZwGuYaUH";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="A3xadl8F"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 636EjAqY3146785
	for <linux-crypto@vger.kernel.org>; Mon, 6 Apr 2026 15:59:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	jjVuAZvqgjuFQQpcpQvR35Vtw2UNUGrsrSTa0onc9VM=; b=ZwGuYaUHr5jsCHcC
	Ux4Z/XgaY3NzNMIrlLM4wgiguoPxo0l7w7xWcnr20EGK6cvRCbbX1t63/JPKFGeY
	9XQvNe2bAViUOEVz3JCFEFdZmtf64Z8+8EeH2vAeIH8Siux8x17NtMBMOZP41kSr
	oQQNRWs6iKzXTGWkDEsBthkb4NC6UfwWiDBWvuxXVDB2yVkUxvs/g6H9zuSZy8gj
	VrL+AAh34F6nRF8jhSLQeYvU4DXXOclwlP0fYezg7hhzPp42kFhCrg2p7yagYN0F
	3ut2Kumj1KLu9IFM5iW4qixW4nvMKdykw0hcqrqbHq7/b0M4OyOOuYlEe9hS5Y2Q
	jIhUAw==
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dcev987xj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 06 Apr 2026 15:59:46 +0000 (GMT)
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-127337c8e52so19498056c88.1
        for <linux-crypto@vger.kernel.org>; Mon, 06 Apr 2026 08:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775491185; x=1776095985; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jjVuAZvqgjuFQQpcpQvR35Vtw2UNUGrsrSTa0onc9VM=;
        b=A3xadl8Fb505OUJfxE7j+dCSmKIzGBw8PRxVuHABjO+FWL9XNTdcsitvau9ZKNWOmK
         27zKobyld8PoPkUjjg+FjeAWpdUrU+rFePbg6NXmTcT0xyDMVoBocB19AizdiEh8Qk4z
         3uMh7vHs9G0p/cZrGOmdcGQ1rsbF5JCkOQVgr5+gBsXMwB1ngVWcUch8Y49S8XW6fzcc
         Jvt8aPlAlhleTHdQPY3TsBbubwQs7gWHaSWnhWlaBi2V6h8tCEYjpzml1F2ejy1tDSU/
         RlxOc8wkDINXMFQgjYXfCodnkPyKhyR+ohkTeAuszTt/E+ZCB/qI1l7/2Q0SJ3Wp73o0
         71Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775491185; x=1776095985;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jjVuAZvqgjuFQQpcpQvR35Vtw2UNUGrsrSTa0onc9VM=;
        b=IchUjJ2okURkJwPJQv/A4+5qt0xACmXesK/8I3I2ea/7unXv4jetFVAbtCGUXrUE7n
         +wh8x5bDjZ0SxrjGl3WcS77Zc8AzF7he+c69RZLqUnq0Y8APvgvgIWxMiR8Ubj5fsIbg
         F8fuhyDcpcWRDfvvuyMuCaK3X/Qg6lK248deA83EdESuMFp6Yq8idvlps9FafKnHmRKR
         DPVWPUitZDNlhw/ZmX5zYGTXxUQxihxchUACwGiIRnOOHfwzyPkwJM4wNCZ1o5o8XyCj
         POTKwiQx6UabSyOXE+Ask0gb/8FeMOadUeD14SVX3R02sSFCDekz7TF0Sr/7zJy7ito7
         cODg==
X-Gm-Message-State: AOJu0YxnJ2B9xTWh1hbSQqp1DPfzdEVoUEF8dhJraaZRabgF4T4NqKvl
	NkBrF97n8bs2iLgSEwbrUEMGyYagaQOfokilsmO5mBd+61/jr1KhkQjggHwSPtiupzIMlMyUCjl
	2+Ck3uj+0Rh2rAHiKbJbZQNmenfn42eXx3cfuI7ZD6F8n1m6EJ/s0LWxwFp5jo7c8Bto=
X-Gm-Gg: AeBDieu7KxcQD2zCaDsGYuQYlMM5wM9pScMhbztcmrMOfpPJEtMWDJVB+hcOG6Iv8pN
	ccPuWV3CAhjTy4qsNFMcS4MhuJBYaO22PFbF8/1UtCGzH72bXZJl4CpdNfyZfnh+L6pYx9/7Wkj
	nDgCjbjh6IvaibieA4R4lFAj/+RFTkvEbC9C45MyNIfRvAn4XbofGtx5XR7A0J9UMETs5ey9BxC
	0101/bK4lw42H1jn8TJ68gaKjTRFvWtnTIk8oIDhrGzb5LiWnitIa0FdHW7mXEM+h7CuG6A04HA
	ypDI3VhqrVaKszmUTWmEGoA+Q3iBDfFQ01VwuFhuo45woE7b8K03RfUf873I8S4ldSLIR2Rbjwm
	grYbR5U8kumYUlvk8n8rNoj36HX+/Mvv0gesqDZqQJzt3BOz4BiNUEwMZsRFyiiSz9X7qVTlGFU
	zpyq2lywRq2+2zyA==
X-Received: by 2002:a05:7300:6c1f:b0:2ca:e4f2:31de with SMTP id 5a478bee46e88-2cbf99ecc03mr7572732eec.4.1775491185351;
        Mon, 06 Apr 2026 08:59:45 -0700 (PDT)
X-Received: by 2002:a05:7300:6c1f:b0:2ca:e4f2:31de with SMTP id 5a478bee46e88-2cbf99ecc03mr7572708eec.4.1775491184636;
        Mon, 06 Apr 2026 08:59:44 -0700 (PDT)
Received: from [192.168.1.44] (c-24-130-122-79.hsd1.ca.comcast.net. [24.130.122.79])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ca792f3f54sm12750506eec.7.2026.04.06.08.59.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2026 08:59:44 -0700 (PDT)
Message-ID: <01c3a67a-abd2-4eb3-b6dd-f87a4b33065b@oss.qualcomm.com>
Date: Mon, 6 Apr 2026 08:59:43 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next 0/6] Consolidate Michael MIC code into
 mac80211
To: Eric Biggers <ebiggers@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <20260405052734.130368-1-ebiggers@kernel.org>
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <20260405052734.130368-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA2MDE1NyBTYWx0ZWRfX74rex8yNbAWl
 ZPl6HFg5+L/zORls7Pi5CfDWLH6Xa0zJ4+6tPzNebhy9KIiX2fhv/+eSVWhU6qxPhlG9jbd418m
 +5AvrfnEIcVJTl8Y1J0m/BN0hrsWVeG6FWEwOnNVn3Lfi+kDzioriLaJ+8T7Xm4PO7DnSoZBVIP
 Sru1J1p29rvZsKsVuCK+7xjNthvabKMP6rCx8KgauWALiAzWxXYDppoNiTMNYdjXpT60KIGg3al
 BGEbHVGudRq1YtJjzzsiC2kBCjovCDx4CasdidWuAvxPyAVhZ0IzOxy+pgm1n8cbFua70S8e+pR
 TSaWrYbm43TSdw+GqCRPiGLj6Oa8CHyf8xb5iebYvVgb+Ld7xu/G5NPqDhRevCeCO94DL3U9jtH
 rPtCRV4CGPS5idt4dZ+xorVXZEELfh4IO2s+pNZmk2vCrb0XM+O2/iKOUg/2CDeVwvu4T+DPZrX
 ZXQZmog2c6lnr3MirQA==
X-Proofpoint-ORIG-GUID: VGJ97OG41ifL2QvM7nnEf5lbcsggUDQw
X-Proofpoint-GUID: VGJ97OG41ifL2QvM7nnEf5lbcsggUDQw
X-Authority-Analysis: v=2.4 cv=JZOxbEKV c=1 sm=1 tr=0 ts=69d3d872 cx=c_pps
 a=JYo30EpNSr/tUYqK9jHPoA==:117 a=Tg7Z00WN3eLgNEO9NLUKUQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=9DdjR0jtjGRORKJrtHgA:9 a=QEXdDO2ut3YA:10 a=Fk4IpSoW4aLDllm1B1p-:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-06_03,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2604060157

On 4/4/2026 10:27 PM, Eric Biggers wrote:
> Michael MIC is an inherently weak algorithm that is specific to WPA
> TKIP, which itself was an interim security solution to replace the
> broken WEP standard.
> 
> Currently, the primary implementation of Michael MIC in the kernel is
> the one in the mac80211 module.  But there's also a duplicate
> implementation in crypto/michael_mic.c which is exposed via the
> crypto_shash API.  It's used only by a few wireless drivers.
> 
> Seeing as Michael MIC is specific to WPA TKIP and should never be used
> elsewhere, this series migrates those few drivers to the mac80211
> implementation of Michael MIC, then removes the crypto implementation of
> Michael MIC.  This consolidates duplicate code and prevents other kernel
> subsystems from accidentally using this insecure algorithm.
> 
> This series is targeting wireless-next.
> 
> Eric Biggers (6):
>   wifi: mac80211: Export michael_mic()
>   wifi: ath11k: Use michael_mic() from mac80211
>   wifi: ath12k: Use michael_mic() from mac80211
>   wifi: ipw2x00: Depend on MAC80211
>   wifi: ipw2x00: Use michael_mic() from mac80211
>   crypto: Remove michael_mic from crypto_shash API
> 
>  arch/arm/configs/omap2plus_defconfig          |   1 -
>  arch/arm/configs/spitz_defconfig              |   1 -
>  arch/arm64/configs/defconfig                  |   1 -
>  arch/m68k/configs/amiga_defconfig             |   1 -
>  arch/m68k/configs/apollo_defconfig            |   1 -
>  arch/m68k/configs/atari_defconfig             |   1 -
>  arch/m68k/configs/bvme6000_defconfig          |   1 -
>  arch/m68k/configs/hp300_defconfig             |   1 -
>  arch/m68k/configs/mac_defconfig               |   1 -
>  arch/m68k/configs/multi_defconfig             |   1 -
>  arch/m68k/configs/mvme147_defconfig           |   1 -
>  arch/m68k/configs/mvme16x_defconfig           |   1 -
>  arch/m68k/configs/q40_defconfig               |   1 -
>  arch/m68k/configs/sun3_defconfig              |   1 -
>  arch/m68k/configs/sun3x_defconfig             |   1 -
>  arch/mips/configs/bigsur_defconfig            |   1 -
>  arch/mips/configs/decstation_64_defconfig     |   1 -
>  arch/mips/configs/decstation_defconfig        |   1 -
>  arch/mips/configs/decstation_r4k_defconfig    |   1 -
>  arch/mips/configs/gpr_defconfig               |   1 -
>  arch/mips/configs/ip32_defconfig              |   1 -
>  arch/mips/configs/lemote2f_defconfig          |   1 -
>  arch/mips/configs/malta_qemu_32r6_defconfig   |   1 -
>  arch/mips/configs/maltaaprp_defconfig         |   1 -
>  arch/mips/configs/maltasmvp_defconfig         |   1 -
>  arch/mips/configs/maltasmvp_eva_defconfig     |   1 -
>  arch/mips/configs/maltaup_defconfig           |   1 -
>  arch/mips/configs/mtx1_defconfig              |   1 -
>  arch/mips/configs/rm200_defconfig             |   1 -
>  arch/mips/configs/sb1250_swarm_defconfig      |   1 -
>  arch/parisc/configs/generic-32bit_defconfig   |   1 -
>  arch/parisc/configs/generic-64bit_defconfig   |   1 -
>  arch/powerpc/configs/g5_defconfig             |   1 -
>  arch/powerpc/configs/linkstation_defconfig    |   1 -
>  arch/powerpc/configs/mvme5100_defconfig       |   1 -
>  arch/powerpc/configs/powernv_defconfig        |   1 -
>  arch/powerpc/configs/ppc64_defconfig          |   1 -
>  arch/powerpc/configs/ppc64e_defconfig         |   1 -
>  arch/powerpc/configs/ppc6xx_defconfig         |   1 -
>  arch/powerpc/configs/ps3_defconfig            |   1 -
>  arch/s390/configs/debug_defconfig             |   1 -
>  arch/s390/configs/defconfig                   |   1 -
>  arch/sh/configs/sh2007_defconfig              |   1 -
>  arch/sh/configs/titan_defconfig               |   1 -
>  arch/sh/configs/ul2_defconfig                 |   1 -
>  arch/sparc/configs/sparc32_defconfig          |   1 -
>  arch/sparc/configs/sparc64_defconfig          |   1 -
>  crypto/Kconfig                                |  12 --
>  crypto/Makefile                               |   1 -
>  crypto/michael_mic.c                          | 176 ------------------
>  crypto/tcrypt.c                               |   4 -
>  crypto/testmgr.c                              |   6 -
>  crypto/testmgr.h                              |  50 -----
>  drivers/net/wireless/ath/ath11k/Kconfig       |   1 -
>  drivers/net/wireless/ath/ath11k/dp.c          |   2 -
>  drivers/net/wireless/ath/ath11k/dp_rx.c       |  60 +-----
>  drivers/net/wireless/ath/ath11k/peer.h        |   1 -
>  drivers/net/wireless/ath/ath12k/Kconfig       |   1 -
>  drivers/net/wireless/ath/ath12k/dp.c          |   2 -
>  drivers/net/wireless/ath/ath12k/dp_peer.h     |   1 -
>  drivers/net/wireless/ath/ath12k/dp_rx.c       |  55 +-----
>  drivers/net/wireless/ath/ath12k/dp_rx.h       |   4 -
>  drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c |   7 +-
>  drivers/net/wireless/intel/ipw2x00/Kconfig    |   7 +-
>  .../intel/ipw2x00/libipw_crypto_tkip.c        | 120 +-----------
>  include/linux/ieee80211.h                     |   5 +
>  net/mac80211/michael.c                        |   5 +-
>  net/mac80211/michael.h                        |  22 ---
>  net/mac80211/wpa.c                            |   1 -
>  69 files changed, 32 insertions(+), 558 deletions(-)
>  delete mode 100644 crypto/michael_mic.c
>  delete mode 100644 net/mac80211/michael.h
> 
> 
> base-commit: dbd94b9831bc52a1efb7ff3de841ffc3457428ce

Note this series does not bisect cleanly since the introduction of the export
in 1/6 causes build failures:

../drivers/net/wireless/intel/ipw2x00/libipw_crypto_tkip.c:467:12: error: conflicting types for 'michael_mic'; have 'int(struct crypto_shash *, u8 *, u8 *, u8 *, size_t,  u8 *)' {aka 'int(struct crypto_shash *, unsigned char *, unsigned char *, unsigned char *, long unsigned int,  unsigned char *)'}
  467 | static int michael_mic(struct crypto_shash *tfm_michael, u8 *key, u8 *hdr,
      |            ^~~~~~~~~~~
In file included from ../drivers/net/wireless/intel/ipw2x00/libipw_crypto_tkip.c:25:
../include/linux/ieee80211.h:1926:6: note: previous declaration of 'michael_mic' with type 'void(const u8 *, struct ieee80211_hdr *, const u8 *, size_t,  u8 *)' {aka 'void(const unsigned char *, struct ieee80211_hdr *, const unsigned char *, long unsigned int,  unsigned char *)'}
 1926 | void michael_mic(const u8 *key, struct ieee80211_hdr *hdr,
      |      ^~~~~~~~~~~

