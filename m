Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012F9404BF4
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 11:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784633178; cv=none; b=kgxJPaobWpX51ryZ6TbPkaVu/t4mhTGh26kE0VBAivtzPA9e3hdAfPD7TuMS1Cw5LjjTmsiBQNIVJVon2xWkFcnWGw9X8mk4yFOOJSyOneLL84fRNktcMhv+apmvYILKOMantQ4PGkGzYtjl0NNkTrqYHHcyJMzt6D3Z5Bqe9zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784633178; c=relaxed/simple;
	bh=HpT7lcuU5EJeAipheRFQ9pnZ/FrF9xNM91mOrGU32jA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gFdzKeeMUP/W+5htwLQEztUbTXXvMIaWhhEQIZvZvsMwx/hSGQ8Zi+iwB4kh1a+cpIXqBpXaOK58QhdnrrgO20EGRGfsI5ZP/hGo/9Vn0lUzbZ1iOO+AJi0kzisIjoMtzZTOeJOw2W15qGyK3AxMDD5TKE5KckU2C0dszA6Gr0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jGvmJOYy; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ijjPy00N; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jGvmJOYy";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ijjPy00N"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66LAQrPV2502594
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 11:26:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	3d2A5R4VU0d7iAg/nZVECdOcq08MuNuF8w9GZ9tGhjk=; b=jGvmJOYyWFSKx3fu
	4ADt72F2XgkMFQ704WlBly6QaGJCZw7ZkcgMUxIO2rVrUs7UHz40s/RM490lFK31
	xs9oLDj75bBniX3kNc9AWQT823HcnZKXPZwvrT1aF+fHrHWDD3IjZGgwI6tkdC/V
	jkXoeghhW/IqfSL/EVZJkPr3wvPit8HD1R/OezWep3F8Zh+Di1+pTvgY6W9ZSVvN
	3BnscH/5cXcij/k1hVohdeiG4NbzJdGiaQQ6NJ0i4FzZNCb7IoiC8GbmhdZZGODB
	68hW9M/8HUPppZuYfMTdaLcbAKSo8Kr5frlLuQA6OLrtbLxQw+42DoTq7Vbx9b0g
	aptuFg==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fj6nsrbfu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 11:26:11 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-84e048a801dso1044407b3a.3
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 04:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784633171; x=1785237971; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3d2A5R4VU0d7iAg/nZVECdOcq08MuNuF8w9GZ9tGhjk=;
        b=ijjPy00NLKyAhA8SdEtzZ/Egu+irJ4xAnc2QtFPYftW9FHK3NC2fQcgX6Ffw1QGj2c
         lRlDV3MY9/UrGVAeQjheJZdBpuK0ryOKjCMupg8AGYAHlsM/bKuyCki4Nff+h/5CG4rU
         VeHb8FIGDhr0I+F3rRyXwU/qIKdR1epU9LfmhxesXoJtQRNhM5jWiI6Tu19e2AqZBzv/
         lGczvDILh3MDkK5Lsv5T0iOo426YsSekOts4mjmm90k8KpN24KCK26CLxre1LyYFY6UL
         eAaaY0F0Dw5N68onWQDFXqtCBpYGnzyfHXnbpdrm+1yMr8yHIwGsn09bbyD6P5vLXbNc
         xVwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784633171; x=1785237971;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3d2A5R4VU0d7iAg/nZVECdOcq08MuNuF8w9GZ9tGhjk=;
        b=q2Mng3a126JPb9pg0GikY6A+jUTLYaZa0HqAbxfMoKMQJHlmzLjkEK0iYLCekJrHaP
         gS/+1XTTDgTAu+rjekJ6f3lQp2K99rmDP/Dfz4TWzCm3GaNacMN7bSPnw9W9WjgW6A6e
         /hpEyBL24BiWBQMMVsYCxowCQi88PZQMrs0Blrtlv4Qw7oK59PZoMbmx13UqDk2M90NX
         t/NS1xujGPfX5OkIv3o0+4uQErYTECgsGPMyjO2CJtJj11M9on0tYbu6OxvuryTkm74X
         n+s7nTrYhhzW47LmOvn31P64teTa0f+WKWEQOCRIQ0kHTLQAKFK4abzdDmUZvBvdhzbs
         +oXg==
X-Gm-Message-State: AOJu0YxjOIAK2cF0QqRAbfddhd9bjbIJt6DMRgJKz4M5pshnTYF5vrak
	7l1Jw8xmGapBGwN5U6oTkrGNVB9zqMNuIHupx1yGMHaQ4J48J7Nodf/zDTMD4uYwJHb1Gji7oge
	Q8wroAvQ66UzmLHMJm1n5YahBEQvQqNbS/weiMi1KWE5mTwzw4zULzUa/yOkEWF5xb3k=
X-Gm-Gg: AR+sD13cAm0sT5iadIwiZk64bOdXn+ox1lyFcwLxPTQHxoXOlXnN6zlY/oK5KnvXH+v
	9Enzz0HP62oFEUfIxE8XIpbAqmIP1esuNsFjqRofhofYlSmM5xXez7A2mWBGOVXhi9l7kOHPMFT
	caOCuYiLi1sBeRndXUAUNhSYSc8SmQVm/0TNiDyK34aYAmVXfyuQAq7/PW2JlRWcVWq9aldAeVB
	Or0upqozIfAmJovrTqD3NZt8VYV+iToDwl6VBuBpBvuiQ7+mBo/+LvsMNgmQOtPKjiQgeUCRQND
	m/BbCNulf0F8dvaVhR7DC9DOBPKlsbmS3w6Vb/Q6pffOt1y6EaOmHfMC/Ly3RQAU9luPhljBkrA
	kQD2ddVzkDe1Al1WLgkTdhz6rSdSPyz2L+gTZ8++Gog+fteR9Iqx12bQNLQMs/tK9sA6cqjWw6K
	UzxSZIehD4SujTkjfgVw==
X-Received: by 2002:a05:6a00:99e:b0:84e:5e0:9db7 with SMTP id d2e1a72fcca58-84e05e0a28bmr2410398b3a.56.1784633170637;
        Tue, 21 Jul 2026 04:26:10 -0700 (PDT)
X-Received: by 2002:a05:6a00:99e:b0:84e:5e0:9db7 with SMTP id d2e1a72fcca58-84e05e0a28bmr2410371b3a.56.1784633170201;
        Tue, 21 Jul 2026 04:26:10 -0700 (PDT)
Received: from [10.190.201.34] (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84c2af31790sm7406873b3a.37.2026.07.21.04.26.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 04:26:09 -0700 (PDT)
Message-ID: <858a38a6-24f7-4bda-a763-315c50c78532@oss.qualcomm.com>
Date: Tue, 21 Jul 2026 16:56:05 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8] crypto: qce - Add runtime PM and interconnect
 bandwidth scaling support
To: Udit Tiwari <udit.tiwari@oss.qualcomm.com>, konrad.dybcio@oss.qualcomm.com,
        herbert@gondor.apana.org.au, thara.gopinath@gmail.com,
        davem@davemloft.net
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, quic_neersoni@quicinc.com
References: <20260517105233.807935-1-udit.tiwari@oss.qualcomm.com>
Content-Language: en-US
From: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
In-Reply-To: <20260517105233.807935-1-udit.tiwari@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: AbAZZV4qXZ8cw_rK4l51XZMRxZmn2--5
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDExOSBTYWx0ZWRfXxUV0O5wzkAff
 dmDQ2a52XZFz+dkShG+9MLEzP2zJvD3rx25DNAQ9T5UQ50/3tniJBvSh7TlDSIlGTYoLzPI8Gzl
 9UODLpb1r7q/xMGD1ckpPL5EfXUQKdI=
X-Authority-Analysis: v=2.4 cv=ZJjnX37b c=1 sm=1 tr=0 ts=6a5f5753 cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=VwQbUJbxAAAA:8 a=COk6AnOGAAAA:8 a=EUspDBNiAAAA:8 a=KIb8oVNHrCvuKONrHFUA:9
 a=QEXdDO2ut3YA:10 a=IoOABgeZipijB_acs4fv:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-ORIG-GUID: AbAZZV4qXZ8cw_rK4l51XZMRxZmn2--5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDExOSBTYWx0ZWRfX+yksaWnFROgx
 z045ckcH9z3dcwUpix7isVkHzqZ0S5JQUxA0E6/YBOt5gI4mGBlf9AUAbFyizmlNabHZ0XZFL9u
 eoT/eNT7ycSnzuQ0FVZENT4XdfPBZZbft2He5ee9CeuFxlJHehkGvl/wDtuuzHiYH9AEyof7w9j
 pHS7egoVaoX/sslrwuOFU9BX5zHHDDCgysFCMpi1Uu9koxL5dCOPQ6WT0QPp9AFGojlkES4MIkB
 Q8YxupljVU/sacnalTpjoU0weIXix5wdjkkdP06dbwDW2sQbUQxZDQC23/5ST0rQVkKlf+qw+Vz
 y68W8mDdDXWcP0NL25+l0tQQYX4N96svTjEYzNV8TofKzxYZA8iv9SXR9uNR27k0QfAcOeEs60b
 SOfgigk8VzbRXgpOZSFCNeVqzmDl1WDE4doaOc3a9DT7lKTxnQH1pqagNC1J4MCSZNM4/GkmG2U
 +BEwz1bqWHL5ZL91crw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-21_01,2026-07-20_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 phishscore=0 priorityscore=1501 suspectscore=0 impostorscore=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607210119

On 5/17/2026 4:22 PM, Udit Tiwari wrote:
> The Qualcomm Crypto Engine (QCE) driver currently lacks support for
> runtime power management (PM) and interconnect bandwidth control.
> As a result, the hardware remains fully powered and clocks stay
> enabled even when the device is idle. Additionally, static
> interconnect bandwidth votes are held indefinitely, preventing the
> system from reclaiming unused bandwidth.
> 
> Address this by enabling runtime PM and dynamic interconnect
> bandwidth scaling to allow the system to suspend the device when idle
> and scale interconnect usage based on actual demand. Improve overall
> system efficiency by reducing power usage and optimizing interconnect
> resource allocation.
> 
> Signed-off-by: Udit Tiwari <udit.tiwari@oss.qualcomm.com>
> ---
Checked interconnect vote summary while triggering s2idle and resume

Tested-by: Pankaj Patil <pankaj.patil@oss.qualcomm.com>

> Tested:
> 
> - Verify that ICC votes drop to zero after probe and upon request
>   completion.
> - Confirm that runtime PM usage count increments during active
>   requests and decrements afterward.
> - Observe that the device correctly enters the suspended state when
>   idle.
> 
> Changes in v8:
> - Drop pm_clk framework (devm_pm_clk_create/pm_clk_add/pm_clk_suspend/
>   pm_clk_resume); use devm_clk_get_optional() and direct
>   clk_prepare_enable()/clk_disable_unprepare() in runtime PM callbacks.
>   This removes the CONFIG_PM_CLK dependency and the build error reported
>   by the kernel test robot.
> - Replace icc_disable() with icc_set_bw(path, 0, 0) in runtime suspend
>   to avoid corrupting the internal 'enabled' flag, which would cause
>   subsequent icc_set_bw() calls in resume to be silently skipped during
>   aggregation.
> - Fix ICC vote ordering: cast bandwidth vote before enabling clocks in
>   resume; disable clocks before dropping ICC vote in suspend.
> - Use PM_RUNTIME_ACQUIRE_AUTOSUSPEND()/PM_RUNTIME_ACQUIRE_ERR() wrapper
>   macros instead of raw ACQUIRE() in both qce_handle_queue() and probe.
> - Drop __maybe_unused from runtime PM callbacks; use RUNTIME_PM_OPS /
>   SYSTEM_SLEEP_PM_OPS (non-SET_ prefix) and pm_ptr(&qce_crypto_pm_ops).
> - Drop unnecessary ret = 0 initializations in qce_handle_queue() and
>   qce_runtime_resume().
> - Extend probe comment to explain ICC + clock ordering rationale.
> - Link to v7:
>   https://lore.kernel.org/lkml/20260220072818.2921517-1-quic_utiwari@quicinc.com/
[...]

