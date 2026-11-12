Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794453753;
	b=vOwwUFbELL6Y/PaLAVp7YEEZ63xrLT9CjhY+f0sPo2YAZiibUQTe4E4Dj91pXzCuIQpO
	 ttbRfuKcVj15SofDwTi9px+db0XioB7htKJxlwcUh0BxXhGUDsdD5EcVf1IWlDb6+XWCs
	 KTbj72kKgn4h+SNtDCIHwvfeGSk3lab8gGAECxJLvEAd38ihfhSDLY/rp2RF6Z5Lp0ZKI
	 UKAvBsFKVnrlWnARoP8b7Z1gS19pN+WwbqCQwafZtxsH4wdoXGr6I/2UZqX7/wo98BCOG
	 Ar2xmXOcNSBQbGu7OGpk/Ji3orHQtD/kl9IZT7oXVAASrVM/QP1K7S/R/ugWAJWyD2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794453753;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Authority-Analysis:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=Nia/3Fejzq/8pwGFpOYXDtAfbAIiNtIbDIVtuujz/Q0=;
	b=WGq8EGTRuu6MaGFa88euspFIJ7Kh3/ZN1+o0r71vxNc4nBXd2VKwyYDI3CxraAYaFdd8
	 vGGDZs2O0fn44fHAoxqnbbB9wB/REvV+lIb5GwsZiu6/i0v9Pr3TT+HIsR4u+36wAro5k
	 JCHfoYfQieQ5c7qTdFLRtGAPqSp+lOvfirr51NJy3a6svWZP+1YF36p1/NbvvTsk9VHNE
	 QNLUlUdG5/+KjIq/vevNDylhBamtQxOFFW5bdatu2qGhRokL05CiBkJqcIt+4CuakJPVg
	 SR2awexfevPPZuSDpmgH5eNDEmA63KjpSWz8OaAS3lg+AVJSQbiWmbgAx0NkPJukOzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=LOpIkJFk;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=YfcOO+8b;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208FF606A323
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 03:22:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 208FF606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=LOpIkJFk;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=YfcOO+8b
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AC2ZZYk022565
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 03:22:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Nia/3Fejzq/8pwGFpOYXDtAfbAIiNtIbDIVtuujz/Q0=; b=LOpIkJFk1qcw9dNR
	IGn4sA5UCOtmAyOLiqsLJomBSihf4tRG/wVsCktehqAKlkuNZgtYphQhJjW6Y110
	kTG5YWTTru2Y4kr1/8Qaz2fJNsQUA5m5Ka/oMwTdFZcaTTHwgtDbyWShJX3YM2kD
	EmjFp/er0dKt0SxCLGtWua47LlVvaLI2blykILXXkO3UwS+VXzUWZRxAMyr0kUAL
	D2ZraxIHHVBA5T54djHiEvNFaJ4a29MejhkgHnvgHbDKd2hHf1ktkpCFc9c1JW8w
	HlSYTbk1ggYxW2ytlV2rCexQSaEEvjbUKJ7IAbCnqhsZMIW4j1I8fuadDWk7094Z
	MUoEtQ==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hvgjdn36v-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 12 Nov 2026 03:22:31 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2eb5375cd68so34538525ad.0
        for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2026 19:22:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794453750; x=1795058550; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Nia/3Fejzq/8pwGFpOYXDtAfbAIiNtIbDIVtuujz/Q0=;
        b=YfcOO+8b58GCURpz5PXBLv24Uv1uH24sUAtfEyQOlUc9OwlPaHxRxUSu2Wb/xdKsDw
         9nNqgW7xq0qxgqaMr2Wbnrv2lxWwKO4qCJVKmNAeaWhLXOGKsyLr2FO3tqwiyEMcAKtF
         eopnhJ2XDhlR/ff9EIlREaT/fP6MarfDEOyZpQsDkJyCbP5b5QTm1G2QanAcyDn6yL7u
         0qFRl5AhkJ0RAI9Wh563lPvd12X53SiZRpjEphQr471LwLTDeEKjlyJMstJfqPSTjrJF
         KTU8mWBvJpuhlrCtzB3cY0UePYFekSC+EjfzsbCf/ghfk3y3qXlpZsicnvGR3fXBghZJ
         RL0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794453750; x=1795058550;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Nia/3Fejzq/8pwGFpOYXDtAfbAIiNtIbDIVtuujz/Q0=;
        b=Esu2ByVd48XNHZ999klP5Cs3Ydnbxvt5CQrygiuzW5BvB09Xr/GPo/8QJy4x/ZhU88
         WENRLRsD9CGua/6kN9LU1Q/ihMqmqqjuivr/M9U1BIkEK0FKHhvZ1h/GI7dqMml6E6W3
         NFus4o/l6mjwH0EWb7ib0BRtgHD8LYIoxTChVbtemkAdziGIB9ywBjxUYjm081nJZNhV
         TbhBDGMdCZXJ5UUIdqLxSXvhQEyQlXqarUE5A+sWJBbf59BvWNylpscgc1SJ4OXTxjPr
         0zxbwSnZoLaP0A+jIy8vazgDE0PyYi41S+C5Zgy57YXqDDzdpDBY3xuK1R1T7CAoSd8W
         FEPg==
X-Forwarded-Encrypted: i=1; AL+hErFEoa+dM+X8H5JYjHDYfMjvqNcLlSWnE8mBDw/lNWcobiI+x2XAu60g1r4qih50DKGPXuLm8wJaPYxrX/s=@vger.kernel.org
X-Gm-Message-State: APuU4Z8UrnudG9SC+zUpoJJ3OzXFmwkbIkHQPYP6JgUugCzwHSd0Qz/N
	G2JqayYQ6o8QWmItKfoz5uMT08XUDVkvf3ZLYY+6c1eteGHCCdKzIAOTDNQcKJRIPa24ssDi/KF
	0ujcrgskP/O6oePSZ0OouLAp79FUevAjiSGkNWZedXgqzS4nos2uvzGI6wvy25czIsNA=
X-Gm-Gg: AYBFou2PiyPU4MocPKzcl16BJx/tslfWGAYhtUgtpVcL2N++DyDJIIjqZna4/IUKhuf
	pnyfnMxg2Lsh+7OOKiY7RsVThb56KUAlRVF75V8wlXg5Hz/7VI7zKJAY+Td56D72I85tlDe67Xm
	+HoiMMpMz03MVMxM0sWyIkPSE0VvI2Pw1kzFDMfecOt9CduTCgngBlLTYQt1JnE1cCqrKohEVJ7
	wX3xNibkB0yoVMrXuC/rGnjRg+Dd7jtreYB/Au7G+3ozpCzF2DSEgSirwp7t95It5XbsaDSDOWK
	RkbvIblBEqrZeze20lP3DiiCjiWYSpRLqCBVYx5nXlVL+oxcixIqGVeFkZfBZKpw74cpgkioeNy
	xBFoVZrmQoK4qJPoSYyCQLUng/ftY28RLkDuzodXn3FsLSqzt1ZKHWh1GRgeI82KmTs2AoA9tBf
	ZQ5rDE4LDMOTBiTogKOTAg8mOsESXRKCWSls1WfgIDfsV4sA==
X-Received: by 2002:a17:903:2ad0:b0:2e9:58c5:8c68 with SMTP id d9443c01a7336-2edd7acfcd0mr38208925ad.54.1794453750526;
        Wed, 11 Nov 2026 19:22:30 -0800 (PST)
X-Received: by 2002:a17:903:2ad0:b0:2e9:58c5:8c68 with SMTP id d9443c01a7336-2edd7acfcd0mr38208695ad.54.1794453750048;
        Wed, 11 Nov 2026 19:22:30 -0800 (PST)
Received: from [10.133.33.220] (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6dfb58dsm26134275ad.66.2026.11.11.19.22.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 19:22:29 -0800 (PST)
Message-ID: <acd476e0-fb24-4f11-b917-c4e86f86171a@oss.qualcomm.com>
Date: Thu, 12 Nov 2026 11:22:16 +0800
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] cpufreq: ondemand: Include <asm/cpu_device_id.h>
 unconditionally
To: Pavel Popov <pavel.e.popov@intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin
 <tursulin@ursulin.net>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Hans de Goede <hansg@kernel.org>,
        =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Peter Huewe <peterhuewe@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Logan Gunthorpe <logang@deltatee.com>, Arnd Bergmann <arnd@arndb.de>,
        Len Brown <lenb@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, David Airlie <airlied@gmail.com>,
        Simona Vetter <simona@ffwll.ch>,
        "David S . Miller" <davem@davemloft.net>, x86@kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, platform-driver-x86@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
References: <20261111234821.4814-1-pavel.e.popov@intel.com>
 <20261111234821.4814-5-pavel.e.popov@intel.com>
Content-Language: en-US
From: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
In-Reply-To: <20261111234821.4814-5-pavel.e.popov@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=E7tYNqdl c=1 sm=1 tr=0 ts=6af530f7 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=EUspDBNiAAAA:8 a=L27Nr_72VT4YvYD4_PkA:9
 a=QEXdDO2ut3YA:10 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-ORIG-GUID: bxczD9Iqjq3D43JLVhPtgZikLhO_NUXb
X-Proofpoint-GUID: bxczD9Iqjq3D43JLVhPtgZikLhO_NUXb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDAxMyBTYWx0ZWRfX1LK8mO5ox3zg
 EPSwWDzG9BGtk0l3fGHoQvFljtcdN3NE+iOopPYuzfOzMuEJPNYuiUut5MsN350zFBzjswpw30a
 i1JS7ySJF2zaugabuoMi4662AitSDGGOyVBzbuoynhsUuDxADWBzAHZCzers2h9PFjASZRIXejm
 ++86hrSaofOWOILhmtl1cVQyN/XU5azBipqpse/KBK252iqD2Q9tXzuaJvD1xj4xHpUVA/WhGfm
 T1dUR1nMTxbbYEp/RzcG/wzNf+VI7Xt+fA9Kq8QBDJCI2xE9JgseDTex9XcHvBcnFQyCvVCEip5
 0PmEL3tYsIQvBqnffNQdntli2q6iA0egfBH2r5UC7KeU3ltFkLLRxOdqcFs62sj7MRaD/Qq0POx
 GZhb82oFUNfM/ZZ3Sc4yFnFJgiWqCPmVaBH61c6ftR+qnFoEBI2/kBAGruUpmMnKfoQB+tE9slf
 Xo1mAPGbmMGrON1nSlg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDAxMyBTYWx0ZWRfX/hkOI+sB/U5x
 Y6ar2ARhQ+MiXuz8GvukXc4xZn1PoOQ44bAkC07qNxrPUTUEkrOCwwQvtlopqVdDAw9S6xgSTw3
 Ho0zky8O3PIHGNoMeY7VMbB7gtOe698=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 malwarescore=0 clxscore=1015 bulkscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120013

On 11/12/2026 7:48 AM, Pavel Popov wrote:
> <asm/cpu_device_id.h> now has a generic version, so the #ifdef
> CONFIG_X86 around the include is no longer needed.
> 
> od_should_io_be_busy() still needs CONFIG_X86 for boot_cpu_data.
> 
> Signed-off-by: Pavel Popov <pavel.e.popov@intel.com>
> ---
> Depends on <asm-generic/cpu_device_id.h> from [1]; please apply after
> it is in mainline.


Yeah, this patch strictly depends on [1] (series patch 1/3) being in
mainline first; otherwise non-x86 builds break.

Reviewed-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>

> 
> [1] https://lore.kernel.org/r/20261111234439.4098-1-pavel.e.popov@intel.com
> 
>   drivers/cpufreq/cpufreq_ondemand.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq_ondemand.h b/drivers/cpufreq/cpufreq_ondemand.h
> index 2ca8f1aaf2e..0e33865f9d3 100644
> --- a/drivers/cpufreq/cpufreq_ondemand.h
> +++ b/drivers/cpufreq/cpufreq_ondemand.h
> @@ -6,6 +6,8 @@
>    * Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>    */
>   
> +#include <asm/cpu_device_id.h>
> +
>   #include "cpufreq_governor.h"
>   
>   struct od_policy_dbs_info {
> @@ -26,8 +28,6 @@ struct od_dbs_tuners {
>   };
>   
>   #ifdef CONFIG_X86
> -#include <asm/cpu_device_id.h>
> -
>   /*
>    * Not all CPUs want IO time to be accounted as busy; this depends on
>    * how efficient idling at a higher frequency/voltage is.


-- 
Thx and BRs,
Zhongqiu Han
