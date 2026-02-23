Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC35366048
	for <linux-crypto@vger.kernel.org>; Mon, 23 Feb 2026 13:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771852490; cv=none; b=J1Vh/FqFot0Yfhq7S+CT9IkyRR9JnfhBFzfkUT+v3f/J3estPSTh8eISL5U6Hw2QAJrKr7KodLmCUfbB4KcCP5pwqAyrYmxOfRTdxdgQ5jMiaYB5S8hORDrpT7ZsSY/XsQyONT24AfrUOMvGsI9yY44EmeHeXm2Re4YZTmWecxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771852490; c=relaxed/simple;
	bh=HGPw30IvhAi0Qz9hdPZFbeQupTic9NG0gh3cwcnpU0s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XSCm5M556ZPVJFetSxKsdfy3cdmPaH5/lYNG1zX9vG3ZvThjVZjhLxUiAfrjLQatna9xi1BkPz2EZ3/Si6Tx5oRwE26mpfEj2in1FUX6vkJ2Lfe+I19jfZIpkEx4EKqpvcUqfRUCQKsyBf+UyaNEnQgl2Havmm8jGQ5C6Uk7d8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=KcRZ4Ga1; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QHcLrKJn; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="KcRZ4Ga1";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QHcLrKJn"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61NAYdOo322207
	for <linux-crypto@vger.kernel.org>; Mon, 23 Feb 2026 13:14:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	oJ09ARFhzE+iiwwCdtmvBFcq8IkTr/eQoxjEjsY0p88=; b=KcRZ4Ga1DNb2ypSU
	7TG4lEuZfCE/I7ePhX17pS17A0fkt8H9CmQknZ06WksCGtaEkSRCWd/V5vxpn+wf
	sUXfjipoO+eI4HLu7B76qT8CAhvO/rxXwzQxTfYXkwcBC5mwFBT/mlF7jQpc3AxE
	EOeqx52jDgothWoaYBm57lNjKkheTcLLtPP4zBWAopjxAD+k6FsDtE81y+AahwrQ
	RbY4JUaz1QdyGp0H5N7UxYxDhKyP8q0SC5V3qTa7mpFpiS43wlFrdMReGfpaemfr
	epG2EZIkrWhW3bKl3yAv3rU1ww65zrRJG6phBx9QHYqPKET3VRdDsLBi82X6csuQ
	822Ldw==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cgn8y0da1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 23 Feb 2026 13:14:48 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8cb3978cdb2so443391885a.1
        for <linux-crypto@vger.kernel.org>; Mon, 23 Feb 2026 05:14:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771852488; x=1772457288; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oJ09ARFhzE+iiwwCdtmvBFcq8IkTr/eQoxjEjsY0p88=;
        b=QHcLrKJnlGG4QPPiWIBv0bF45gvW+m6wF9JnrPAaUW46ya2uoKwzYzlqbH7ww33nvH
         yvg8tP2InprxfC+KVFI0WLF6sudWnqY3W3AFxK8Zxkw7u550aPFkaPUkiCyaPc973QD+
         aROT9yKYeYpdCSsAAR+1pHzTixtpSi/HmUJahVf7z6H9HZiyTsd5kOndlkF1SWWcU2wN
         WAAp8dd1UfJI+B8KH9ZtQnElLolesHqoUFIG/IGK+Dly+wMnwcZjBl9xh1f8ygNRqg1X
         0hqW/6peYBarid9Lon+LWiXTAOjNdSchzKAwS3rdbKRidJbdVlFVud9p5z7IiE2ELg+B
         kBYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771852488; x=1772457288;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oJ09ARFhzE+iiwwCdtmvBFcq8IkTr/eQoxjEjsY0p88=;
        b=ga/DuSnTXF2zAPJNz55n/4kGUWMdYPjuDvtCG0+qXF0qrjU+t9256cWLXjOkPAjgQs
         XMamPz6g7o7CIy70tQWXakKweeeq1emZvw6Iay7K78evPkGB7iiJZaU/QxzLOGhi3Lxg
         /7zhPBzNz0sqWph73ikGXqjAIWbfoJknumk3FyFt9QwubZDMDfOcqNjtam+LR4fhdT54
         Keb3zaDgHSH2qN8f+MSes9TfnYS3becut4N0N7rXbP9o9fCDq7eFI8ltoGvlGo8c9Spe
         GI68wE683fmMmTDd0r35Mn1qbt5tOgAnpZ4uNDp6ndO+YF8C9V0dE1Tl3aNeP5MRrB7s
         ECPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXOuDJ8n6onF6r7u+cZpz59ZV7GN712NUkxFf+FmruU06PscFqdZIyGhPfeKJRE70iXnlP5Y0JemqdIaGc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnHJFmPfIcT57IK3GxDGsnpVDpmqVBjtHeDWQwL5Jp5voo6/Mz
	cBgocAbQPyr6lYo1Okj7cztLCXtTNxcFbQr0R3MOmuzTuUkVGY/S+AObnPpMopqi8Syr6nwcYpa
	XrCnKwxVepuYN+dDG8fBwAl5L3q09KkQS4CwjhxBYtW9htnOYcmpVTOkzlENo0SzSpoA=
X-Gm-Gg: AZuq6aIZrLS8TbgKuXolh0u4Wdu59OXERK6aHyivvsLNFzs1LSBfDX4LPLA5z8uFIUx
	cY3JPsedpYW9EiyUm+jLRnHmDVFkpZmoxu/KlBFipAW0HglQVQoG4MyxsjYtUwxrrptXi2qRX0K
	7Ehw/KT17LyzNsHJvD/V9p3iqYBHGWAFDMWzdaK1MUM7ZvdzXFbNpKsO4eAE0PbiPayj6knFep6
	Q26Kc9NLN1MofwAVplzUx7HlqBSJrKcwDLF9TfJysoxnkd9ZMq5VxKNEqCNSz42rRVc2Mrd/QWG
	lqZSPkqnmEpoauYtszoEg1Wcy5AUjIucKpJXggYhbfjvmfAOP4rD3DnNu5m6Nf92RwXelDz42Ie
	X7Ze0VmQz/5OghiPpjT6ZvdZjk+VPax/K9Zzkt/PZWXh+C4CWE15Nd+a/wSVldCSQ5z1feSu6iq
	Zt5DA=
X-Received: by 2002:a05:620a:1a25:b0:8c7:1aea:53b7 with SMTP id af79cd13be357-8cb8caa40f8mr819520685a.9.1771852487655;
        Mon, 23 Feb 2026 05:14:47 -0800 (PST)
X-Received: by 2002:a05:620a:1a25:b0:8c7:1aea:53b7 with SMTP id af79cd13be357-8cb8caa40f8mr819517985a.9.1771852487150;
        Mon, 23 Feb 2026 05:14:47 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9084e8b790sm329522566b.49.2026.02.23.05.14.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Feb 2026 05:14:46 -0800 (PST)
Message-ID: <ee3facd2-5670-43d5-8da5-65dd0a1a9752@oss.qualcomm.com>
Date: Mon, 23 Feb 2026 14:14:44 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7] crypto: qce - Add runtime PM and interconnect
 bandwidth scaling support
To: Bjorn Andersson <andersson@kernel.org>
Cc: quic_utiwari@quicinc.com, herbert@gondor.apana.org.au,
        thara.gopinath@gmail.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, quic_neersoni@quicinc.com
References: <20260220072818.2921517-1-quic_utiwari@quicinc.com>
 <ab5725df-8454-4e3d-8806-a711ef0e6a42@oss.qualcomm.com>
 <fnsagbqvriuxdz4xrvs76kwovu3oir3662tu4niii56tgz2cag@zrxyd36qmujb>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <fnsagbqvriuxdz4xrvs76kwovu3oir3662tu4niii56tgz2cag@zrxyd36qmujb>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIzMDExNCBTYWx0ZWRfX7yx/4OoiYjAM
 Wx9cYlLwqoPySW9xIemJtrPe6g/EFbO/T5B+mmqbEGJdk5ffX8fcorSoVtAXjYWu1Ta3PZ+N9wW
 aB7s42kWPBy0APavcnt4gkRn+WSHW/WB7CZEESqwDFMsJr/GIeLLfyGhBnh9Dkolhz0q3bCc6aT
 3my5UKv5ONtyX/mofIMzbbinq/tU6UG/SCqQuG4uJdyU6xf/Xyk4vubgs9x3BniQfEhIcKa4C9S
 i3UF3mpM3ImyEAb1dqoMXlZZ1oJDEOe3LicZcomLE6p0zmSvgheiasb3OZYubJ4MIsfrQuTBlWO
 n/W2tNUO+Vr2hbeItWTMmnm635lQOEqE8DM8mTN6dVAGenTC8v0pQtup3ihBcPjwnGXK4DRpWTL
 xvyLuKY1tXmHNWF8jk4lXfTFpRYNHmesOS+g+woP6C1zfISwd8aaBx73ZOAWHY6UMHW5joQpxhf
 j/eyf9jsj6lhomTUGzA==
X-Authority-Analysis: v=2.4 cv=edYwvrEH c=1 sm=1 tr=0 ts=699c52c8 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=COk6AnOGAAAA:8 a=1nBFhei-SnZgKy-kEtUA:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: l9-q7_RMl-611WjHPB9EznwT_d6Y6MUo
X-Proofpoint-ORIG-GUID: l9-q7_RMl-611WjHPB9EznwT_d6Y6MUo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-23_02,2026-02-23_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 malwarescore=0 phishscore=0 clxscore=1015 priorityscore=1501
 spamscore=0 impostorscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602230114

On 2/21/26 5:00 AM, Bjorn Andersson wrote:
> On Fri, Feb 20, 2026 at 10:52:04AM +0100, Konrad Dybcio wrote:
>> On 2/20/26 8:28 AM, quic_utiwari@quicinc.com wrote:
>>> From: Udit Tiwari <quic_utiwari@quicinc.com>
>>>
>>> The Qualcomm Crypto Engine (QCE) driver currently lacks support for
>>> runtime power management (PM) and interconnect bandwidth control.
>>> As a result, the hardware remains fully powered and clocks stay
>>> enabled even when the device is idle. Additionally, static
>>> interconnect bandwidth votes are held indefinitely, preventing the
>>> system from reclaiming unused bandwidth.
>>>
>>> Address this by enabling runtime PM and dynamic interconnect
>>> bandwidth scaling to allow the system to suspend the device when idle
>>> and scale interconnect usage based on actual demand. Improve overall
>>> system efficiency by reducing power usage and optimizing interconnect
>>> resource allocation.
>>
>> [...]

[...]

>>
>>
>>> +static int __maybe_unused qce_runtime_suspend(struct device *dev)
>>
>> I think you should be able to drop __maybe_unused if you drop the
>> SET_ prefix in pm_ops
> 
> I believe that's correct.
> 
>> and add a pm_ptr() around &qce_crypto_pm_ops in
>> the assignment at the end
>>
> 
> Doesn't that turn into NULL if CONFIG_PM=n and then you get a warning
> about unused struct?

If I'm reading

1a3c7bb08826 ("PM: core: Add new *_PM_OPS macros, deprecate old ones")

correctly, it should be fine.. I'm seeing e.g. 

161266c754e7 ("can: rcar_canfd: Convert to DEFINE_SIMPLE_DEV_PM_OPS()")

do that, but I don't fully understand why this works. Perhaps __maybe_unused
does not resolve recursively?

> 
>>> +{
>>> +	struct qce_device *qce = dev_get_drvdata(dev);
>>> +
>>> +	icc_disable(qce->mem_path);
>>
>> icc_disable() can also fail, since under the hood it's an icc_set(path, 0, 0),
>> please check its retval
>>
> 
> Given that the outcome of returning an error from the runtime_suspend
> callback is to leave the domain in ACTIVE state I presume that also
> means we need to turn icc_enable() again if pm_clk_suspend() where to
> fail?

Seems that way

> Two things I noted while looking at icc_disable():
> 
> 1) icc_bulk_disable() return type is void. Which perhaps relates to the
> fact that qcom_icc_set() can't fail?

I think both of these are problems.


> 2) Error handling in icc_disable() is broken.
> 
> icc_disable() sets enabled = false on the path, then calls icc_set_bw()
> with the current bandwith again. This stores the old votes, then calls
> aggregate_requests() (which ignored enabled == false votes) and then
> attempts to apply_contraints().
> 
> If the apply_contraints() fails, it reinstate the old vote (which in
> this case is the same as the new vote) and then does the
> aggregate_requests() and apply_contraints() dance again.
> 
> I'm assuming the idea here is to give the provider->set() method a
> chance to reject the new votes.

For obscure cases where e.g. going under a certain total bandwidth
across a bus would be strictly forbidden and only enforced in .set()?

> But during the re-application of the old votes (which are same as the
> new ones) enabled is still false across the path, so we're not
> reinstating anything and while we're exiting icc_disabled() with an
> error, the path is now disabled - in software, because we have no idea
> what the hardware state is.

What you described also seems like a real issue. The latter part, we
probably just have to hope that the "enable back" vote goes through.
Else, the system would likely fall apart within seconds anyway

Konrad
