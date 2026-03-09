Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9288A3A784F
	for <linux-crypto@vger.kernel.org>; Mon,  9 Mar 2026 11:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773057587; cv=none; b=C0ABO2kfFxKHl56cUhsT5/rOoYY7Hix4yV7z2whSOBw4MKBuZigOrYL4Rdhc+/DEExN5IH/0tLUdhGUsFCCX83iMBIr/b7v3+J4d1cjw7R8QqNvyup550J/+LYHee9cOAqe3ZJwstBC9krbYIzne8Ukv0SnUWDORLNB9zoz+g7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773057587; c=relaxed/simple;
	bh=F7mbc8jx1k//IBI08Up4qfho24mFsNsH5IucY27FyRM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZZxWsJsvOePdd6KPqaKHHf0kwa5MZDfZPtj0uHnbQBxEm510z3qkDjqQ34ioNV4jxd3jPRtEEmGeiXTtJRWH9E/tSxs7cuFwLtL3eY1DWrvr2zh88jcW3v7qAvLFZCkSMc5u31mcR5H/bjAPuxp2ppba8JkFnj17Wi1CKTfIvyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SAWZUL5o; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=S8Ir8nFA; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SAWZUL5o";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="S8Ir8nFA"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6298IuCQ3464415
	for <linux-crypto@vger.kernel.org>; Mon, 9 Mar 2026 11:59:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Ct+JOW0U7zgweeondUjCYiRFut8xAJES8GcNUAQtRb0=; b=SAWZUL5oP2s2HCn2
	/7ZZB5Oc5ImMnhRbhXlBEXS559YlA99R+ujepq/TvDGtuiqLUygjHcji4TaqlSFC
	Emg4oZMrZpy09Cpxw9geVfaYE9hqqstraDZjcKR3cZgLZv5hhEXjFdbwXYtlvI3M
	sWxDXdiai7vkgnEa2E9kgkhavreBDMzzfnPLcRogoDPkvoumIEPzRIrxn1RfqPJ7
	FJsDqADK91p25YFcnORazX43dejfqlrBWcMUaJvhi+1T+VwyepzCats7dMXIOWPo
	2KT7rk3wz1lVEzAHuwX9RxvzkfgeBVeY+UqwgzxPMkDy+QxSO4pHPCNOeFp1wS3f
	PcOKBw==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4crcd8d6va-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 09 Mar 2026 11:59:43 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ae4af66f40so88313315ad.1
        for <linux-crypto@vger.kernel.org>; Mon, 09 Mar 2026 04:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773057582; x=1773662382; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ct+JOW0U7zgweeondUjCYiRFut8xAJES8GcNUAQtRb0=;
        b=S8Ir8nFAdXV33qnB+BceN9VcKIBmimXRdP8dSeSmHcXBuMnPnmgNLkizlrSTa6Sgp8
         wVzCnR31WMH+4H6iZf+YrnAQAxOp2+XmptOWg4F3RHswnBNPN7s+KQeMPBL8LT5megJJ
         sQc0DoX1uzBzKE1LsM3/B/+32xKanY/sF/k/3u8uRksx9L/88KVJCROJVF9lc4dVdg+5
         auRU4B2FgI3Md8Hwmuj4A7c7Bg19f34ST1ac2nmGwlgeR0zEfpVSWLZ/DqoIxDGp1Jwu
         NaJsqaU/K/wXNXYCULq3Oz9mHdosN/2NQIjNlkm69wS+DjXt/JxB/nMjGE2+8wtoXs4+
         8Y+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773057582; x=1773662382;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ct+JOW0U7zgweeondUjCYiRFut8xAJES8GcNUAQtRb0=;
        b=Ir5Iy3b8nrJt4uTqwhqwZ99KRwBX0IuYw/7SUFnW/Rxr753I4Ujs0fbwRRs3qOdQf8
         3GygV7liGdmMh4mNtU31x7kLwZCkfgrrtdS+6SLs1nroGAH6USZM9WIAQ6NpLv05yAW6
         1AmqsUcPLA/zqS+W9amPjUMaqUOpaCZ5/goAmO2DFGpy5yNydn0VEsx2iutBI9ND64iA
         6meVsV9VRIxotNZrtUjrEgtxZ5mP2GROz05OUmho2/ROnv/GZToNGJSscyY4AEyZZyYL
         81EqEldATRofxhESasR0EbYB/FTk5wCJ3zzU4w5mdFgNJa6PGRVoJeaRsGrbnLHZDRcb
         ZwTg==
X-Forwarded-Encrypted: i=1; AJvYcCVKNpvDcnvhCVmt+cfNnHRNH8XfqKeRAJjv9sLjEMdEm8kT4tT6i/NLj7Sp8oshOgiKBQR1SYCSI9LDtOY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxm0FqKggMkvldIwXCt1Kgg01cZ9IIMoKFd7lw+WvkSm9E1YXzR
	6AIIJtbiU+eSR6xivRgI3eYFM8PNRu2xiHiL6rhOY3zqG5314K0vdme5qSJNQIw+9Ic1xR5Z+6W
	k5nK63LebIC9yKb+xwzJu2hPJEVRqTwdmOClcrsTKceEER8IGjsPQQG3RqTRCZfVUHBM=
X-Gm-Gg: ATEYQzxJ/8W9qB6C8y0OwUejMBHa8F7Llv1rDpabzCLd91rJ27Gz7CwBaGujL4AHdAk
	PODXDObHX6FaicvytFy7439bCzR7cODQ/9XL0cSu9ffGxDp+DGxngWIGsZTQ3QjiSMJLwjxAulH
	bslOAblry2Qg2FgHp2WsR8t1Du1QnyHcJ+i2VCifSEOPC+FwnbFS/d4onZsrbfkAOARZ0fuRhGG
	6bpuReSm2zG4FYE4OtXFz8pk11jhKoUEKJU3iRdSqIZ4xTICGqa0C55vqTB/IPT4sJD2c3s41/z
	BW2ruj2mZ/QQ2QtE76+gBIlpNrs1IruYbd5cVAcGMsWmIWd5Tq61i64owQhvNN6nZnMZnFaS8Qk
	r4Pzq0+PvHLB81WN0/xO6Jqz6vqGP7eNPIgIH0n1yKIb9KGGIdfpGw7Y46iKDl4jwY6vE5Gtpx6
	GJyfEemX40ww==
X-Received: by 2002:a17:902:c406:b0:2a9:484c:ff2f with SMTP id d9443c01a7336-2ae823a1df5mr108954105ad.23.1773057582303;
        Mon, 09 Mar 2026 04:59:42 -0700 (PDT)
X-Received: by 2002:a17:902:c406:b0:2a9:484c:ff2f with SMTP id d9443c01a7336-2ae823a1df5mr108953825ad.23.1773057581756;
        Mon, 09 Mar 2026 04:59:41 -0700 (PDT)
Received: from ?IPV6:2405:201:c009:3829:7df8:e92f:daa5:e6d1? ([2405:201:c009:3829:7df8:e92f:daa5:e6d1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae8852e638sm146193095ad.2.2026.03.09.04.59.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2026 04:59:41 -0700 (PDT)
Message-ID: <320ff1c6-34ed-4b6f-b0f8-db79a14b7101@oss.qualcomm.com>
Date: Mon, 9 Mar 2026 17:29:34 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/11] soc: qcom: ice: Add explicit power-domain and clock
 voting calls for ICE
To: Manivannan Sadhasivam <mani@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        cros-qcom-dts-watchers@chromium.org, Brian Masney <bmasney@redhat.com>,
        Neeraj Soni
 <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260123-qcom_ice_power_and_clk_vote-v1-0-e9059776f85c@qti.qualcomm.com>
 <20260123-qcom_ice_power_and_clk_vote-v1-11-e9059776f85c@qti.qualcomm.com>
 <vimd3tbnu4mr2uqporj7d4fv23aq2cb6e5een43yz5spe4u2xx@ufyzb2lzlc6j>
 <b32c7091-b2c4-443d-b58e-759b471f67db@oss.qualcomm.com>
 <4a76fuanyf45d56p64qmc7c3qcovbzt7jc27uern4lr4bchl6n@l6buzvakrrcg>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
In-Reply-To: <4a76fuanyf45d56p64qmc7c3qcovbzt7jc27uern4lr4bchl6n@l6buzvakrrcg>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: 7mF7PP79anhPCiNVlU6M8PuFqR12uSgH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA5MDExMCBTYWx0ZWRfXyYLlFzXBoxJy
 Arqc8FqUypvcF4g76F6FbhGOv9wIWDdugbFuJu6bhtZvuxANHWaxLsKtXECG5T5hTVG8mOoPgQx
 K3+wDPw1pEyf0tYCOn2uxJAI4JMDZ+WlZRC4MIr4mbbLDhOO2Mj2j6xTSJrlvnep2d7w3cFJq/i
 GkG4sghDfoQ9F0fYLB1ASGobiwv7XjuR8RvB/IjWI2Ip8y5igY2KOdnh76cceHh/kl+fD4MN042
 pinUsOTIUpARCVsF04NI56whrrJaulbGODjVJ8O8EidJI1OMP9i69HaIFpJ7drcjblvJ4ORzDuP
 8n8QvYHezUiCm/AIpNZLV0grqQFOHDTt9L1dMbqs7Xm47YLXABRrbRpH9IYJALNYLW5tBmKwvKC
 zTIXv7aHc7zGln6vJCHAsOQhVdzh2QKNrKpE27tb7Z2pw1pLIXdMrHbeQznbFS4rEggnq/9EXEK
 NFQoFWRz2HtLpp+hO0Q==
X-Authority-Analysis: v=2.4 cv=O/w0fR9W c=1 sm=1 tr=0 ts=69aeb62f cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=EUspDBNiAAAA:8
 a=zUsFzlfcqSlsMlHV8JIA:9 a=QEXdDO2ut3YA:10 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-GUID: 7mF7PP79anhPCiNVlU6M8PuFqR12uSgH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-09_03,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 spamscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 impostorscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603090110

Hi Manivannan,

On 3/3/2026 10:38 PM, Manivannan Sadhasivam wrote:
> On Tue, Mar 03, 2026 at 02:11:06PM +0530, Harshal Dev wrote:
>> Hi Manivannan,
>>
>> On 2/20/2026 8:14 PM, Manivannan Sadhasivam wrote:
>>> On Fri, Jan 23, 2026 at 12:41:35PM +0530, Harshal Dev wrote:
>>>> Since Qualcomm inline-crypto engine (ICE) is now a dedicated driver
>>>> de-coupled from the QCOM UFS driver, it should explicitly vote for it's
>>>> needed resources during probe, specifically the UFS_PHY_GDSC power-domain
>>>> and the 'core' and 'iface' clocks.
>>>
>>> You don't need to vote for a single power domain since genpd will do that for
>>> you before the driver probes.
>>>
>>
>> Unfortunately, without enabling the power domain during probe, I am seeing occasional
>> clock stuck messages on LeMans RB8. Am I missing something? Could you point me to any
>> docs with more information on the the genpd framework?
>>
> 
> genpd_dev_pm_attach() called before a platform driver probe(), powers ON the
> domain.

You are correct. I just double confirmed this. I am going to remove all pm_runtime_* API
calls from this commit as they aren't needed. Ack.

> 
>> Logs for reference:
>>
>> [    6.195019] gcc_ufs_phy_ice_core_clk status stuck at 'off'
>> [    6.195031] WARNING: CPU: 5 PID: 208 at drivers/clk/qcom/clk-branch.c:87 clk_branch_toggle+0x174/0x18c
>>
>> [...]
>>
>> [    6.248412] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>> [    6.248415] pc : clk_branch_toggle+0x174/0x18c
>> [    6.248417] lr : clk_branch_toggle+0x174/0x18c
>> [    6.248418] sp : ffff80008217b770
>> [    6.248419] x29: ffff80008217b780 x28: ffff80008217bbb0 x27: ffffadf880a5f07c
>> [    6.248422] x26: ffffadf880a5c1d8 x25: 0000000000000001 x24: 0000000000000001
>> [    6.248424] x23: ffffadf8a0d1e740 x22: 0000000000000001 x21: ffffadf8a1d06160
>> [    6.248426] x20: ffffadf89f86e5a8 x19: 0000000000000000 x18: fffffffffffe9050
>> [    6.248429] x17: 000000000404006d x16: ffffadf89f8166c4 x15: ffffadf8a1ab6c70
>> [    6.347820] x14: 0000000000000000 x13: ffffadf8a1ab6cf8 x12: 000000000000060f
>> [    6.355145] x11: 0000000000000205 x10: ffffadf8a1b11d70 x9 : ffffadf8a1ab6cf8
>> [    6.362470] x8 : 00000000ffffefff x7 : ffffadf8a1b0ecf8 x6 : 0000000000000205
>> [    6.369795] x5 : ffff000ef1ceb408 x4 : 40000000fffff205 x3 : ffff521650ba3000
>> [    6.377120] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0000928dd780
>> [    6.384444] Call trace:
>> [    6.386962]  clk_branch_toggle+0x174/0x18c (P)
>> [    6.391530]  clk_branch2_enable+0x1c/0x28
>> [    6.395644]  clk_core_enable+0x6c/0xac
>> [    6.399502]  clk_enable+0x2c/0x4c
>> [    6.402913]  devm_clk_get_optional_enabled+0xac/0x108
>> [    6.408096]  qcom_ice_create.part.0+0x50/0x2fc [qcom_ice]
>> [    6.413646]  qcom_ice_probe+0x58/0xa8 [qcom_ice]
>> [    6.418384]  platform_probe+0x5c/0x98
>> [    6.422153]  really_probe+0xbc/0x29c
>> [    6.425826]  __driver_probe_device+0x78/0x12c
>> [    6.430307]  driver_probe_device+0x3c/0x15c
>> [    6.434605]  __driver_attach+0x90/0x19c
>> [    6.438547]  bus_for_each_dev+0x7c/0xe0
>> [    6.442486]  driver_attach+0x24/0x30
>> [    6.446158]  bus_add_driver+0xe4/0x208
>> [    6.450013]  driver_register+0x5c/0x124
>> [    6.453954]  __platform_driver_register+0x24/0x30
>> [    6.458780]  qcom_ice_driver_init+0x24/0x1000 [qcom_ice]
>> [    6.464229]  do_one_initcall+0x80/0x1c8
>> [    6.468173]  do_init_module+0x58/0x234
>> [    6.472028]  load_module+0x1a84/0x1c84
>> [    6.475881]  init_module_from_file+0x88/0xcc
>> [    6.480262]  __arm64_sys_finit_module+0x144/0x330
>> [    6.485097]  invoke_syscall+0x48/0x10c
>> [    6.488954]  el0_svc_common.constprop.0+0xc0/0xe0
>> [    6.493790]  do_el0_svc+0x1c/0x28
>> [    6.497203]  el0_svc+0x34/0xec
>> [    6.500348]  el0t_64_sync_handler+0xa0/0xe4
>> [    6.504645]  el0t_64_sync+0x198/0x19c
>> [    6.508414] ---[ end trace 0000000000000000 ]---
>> [    6.514544] qcom-ice 1d88000.crypto: probe with driver qcom-ice failed
>>  
>>>> Also updated the suspend and resume callbacks to handle votes on these
>>>> resources.
>>>>
>>>> Signed-off-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
>>>
>>> Where is the Fixes tag?
>>
>> Ack, I will add it in v2 of this patch.
>>
>>>
>>>> ---
>>>>  drivers/soc/qcom/ice.c | 20 ++++++++++++++++++++
>>>>  1 file changed, 20 insertions(+)
>>>>
>>>> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c
>>>> index b203bc685cad..4b50d05ca02a 100644
>>>> --- a/drivers/soc/qcom/ice.c
>>>> +++ b/drivers/soc/qcom/ice.c
>>>> @@ -16,6 +16,8 @@
>>>>  #include <linux/of.h>
>>>>  #include <linux/of_platform.h>
>>>>  #include <linux/platform_device.h>
>>>> +#include <linux/pm.h>
>>>> +#include <linux/pm_runtime.h>
>>>>  
>>>>  #include <linux/firmware/qcom/qcom_scm.h>
>>>>  
>>>> @@ -108,6 +110,7 @@ struct qcom_ice {
>>>>  	void __iomem *base;
>>>>  
>>>>  	struct clk *core_clk;
>>>> +	struct clk *iface_clk;
>>>>  	bool use_hwkm;
>>>>  	bool hwkm_init_complete;
>>>>  	u8 hwkm_version;
>>>> @@ -310,12 +313,20 @@ int qcom_ice_resume(struct qcom_ice *ice)
>>>>  	struct device *dev = ice->dev;
>>>>  	int err;
>>>>  
>>>> +	pm_runtime_get_sync(dev);
>>>
>>> This is not needed as the power domain would be enabled at this point.
>>
>> Would this be enabled due to the genpd framework? I am not observing that
>> during probe. Because this call is made by the UFS/EMMC driver, perhaps you
>> mean the situation at this point is different?
>>
> 
> If you pass 'power-domains' property in DT, genpd will power it ON at this
> point.

Ack.

> 
>>>
>>>>  	err = clk_prepare_enable(ice->core_clk);
>>>>  	if (err) {
>>>>  		dev_err(dev, "failed to enable core clock (%d)\n",
>>>>  			err);
>>>>  		return err;
>>>>  	}
>>>> +
>>>> +	err = clk_prepare_enable(ice->iface_clk);
>>>> +	if (err) {
>>>> +		dev_err(dev, "failed to enable iface clock (%d)\n",
>>>> +			err);
>>>> +		return err;
>>>> +	}
>>>
>>> Use clk_bulk API to enable all clocks in one go.
>>
>> Ack, I'll use clk_bulk_prepare_enable().
>>
>>>
>>>>  	qcom_ice_hwkm_init(ice);
>>>>  	return qcom_ice_wait_bist_status(ice);
>>>>  }
>>>> @@ -323,7 +334,9 @@ EXPORT_SYMBOL_GPL(qcom_ice_resume);
>>>>  
>>>>  int qcom_ice_suspend(struct qcom_ice *ice)
>>>>  {
>>>> +	clk_disable_unprepare(ice->iface_clk);
>>>
>>> Same here.
>>
>> Ack, clk_bulk_disable_unprepare() would look good.
>> As Konrad pointed out, if iface clock is not present in DT, thse APIs are
>> fine with NULL pointers here.
>>
>>>
>>>>  	clk_disable_unprepare(ice->core_clk);
>>>> +	pm_runtime_put_sync(ice->dev);
>>>
>>> Not needed.
>>>
>>>>  	ice->hwkm_init_complete = false;
>>>>  
>>>>  	return 0;
>>>> @@ -584,6 +597,10 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
>>>>  	if (IS_ERR(engine->core_clk))
>>>>  		return ERR_CAST(engine->core_clk);
>>>>  
>>>> +	engine->iface_clk = devm_clk_get_enabled(dev, "iface_clk");
>>>> +	if (IS_ERR(engine->iface_clk))
>>>> +		return ERR_CAST(engine->iface_clk);
>>>> +
>>>
>>> Same here. Use devm_clk_bulk_get_all_enabled().
>>
>> As per discussion on the DT binding patch, I can do this once we decide to break the
>> DT backward compatibility with a subsequent patch which makes both clocks mandatory.
>> For v2, I am planning to continue to treat the 'iface' clock as optional via
>> devm_clk_get_optional() API.
>>
> 
> Even if you do not mark 'iface' as 'required', this API will work just fine. It
> will get and enable whatever clocks defined in the DT node. It is upto the
> binding to define, what all should be present.

Agreed Manivannan, however, I realize that for legacy DT bindings, where ICE instance is
specified as part of the UFS/EMMC driver node, qcom_ice_create() receives the storage
device, if we call devm_clk_bulk_get_all_enabled() then all clocks specified in the
storage node would be returned and enabled. However, qcom_ice_create() should only enable
clocks relevant for ICE operation, i.e., core and iface clocks. iface being optional
for the time being as discussed.

And so, for suspend() and resume() as well, it seems I will have to continue with preparing
and enabling/disabling both the clocks individually.

> 
>>>
>>>>  	if (!qcom_ice_check_supported(engine))
>>>>  		return ERR_PTR(-EOPNOTSUPP);
>>>>  
>>>> @@ -725,6 +742,9 @@ static int qcom_ice_probe(struct platform_device *pdev)
>>>>  		return PTR_ERR(base);
>>>>  	}
>>>>  
>>>> +	devm_pm_runtime_enable(&pdev->dev);
>>>> +	pm_runtime_get_sync(&pdev->dev);
>>>
>>> If you want to mark & enable the runtime PM status, you should just do:
>>>
>>> 	devm_pm_runtime_set_active_enabled();	
>>>
>>> But this is not really needed in this patch. You can add it in a separate patch
>>> for the sake of correctness.
>>
>> If my understanding is correct, I need to call pm_runtime_get_sync() to enable
>> the power domain after enabling the PM runtime to ensure further calls to enable
>> the iface clock do not encounter failure. Just calling devm_pm_runtime_set_active_enabled()
>> will only enable the PM runtime and set it's status to 'active'. It will not enable
>> the power domain.
>>
> 
> Again, you DO NOT need to handle a single power domain in the driver, genpd will
> do it for you. If that is not helping, then something else is going wrong.
> 

Ack.

Regards,
Harshal

> - Mani
> 

