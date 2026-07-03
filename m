Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A24932F75B
	for <linux-crypto@vger.kernel.org>; Fri,  3 Jul 2026 04:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783054405; cv=none; b=MVR2rLE4z67KeDfkqs8AhyDl5cnOfB/LdHcsbILj0jBXqEFn8ib2QJCT45JMTO7PgCPOokCnOT7sUjYr4nmvkN6DdjCkXcMl0Lu4q7iqAIK2eEhagKtl4qg+KLhBmwW4yZ1jm651lshV6X+iudELUaY5VYNY//zXgrJI29egPvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783054405; c=relaxed/simple;
	bh=NknhmZvh0kvHIBS3PtJIHQtzHj3i8LUsDKPzHhL8/dQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kl6I5TPByblDZSezC8vvUqh4431SmtzdnWa1UBAJBi+iNLPshLAgpXDIHidrUpAD9LsYMuQQbv05Mlf5sOAUNEFGhrfrxOV6hGdQEKuNitkwAR4h+Jp8/an7fgh5e2cChzMoGQq+dVk8++4pwamq6cuV/Wk6Infc3j3J2ahGY7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Wq+tKiU4; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fac0FvTc; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Wq+tKiU4";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fac0FvTc"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 663439YS2826009
	for <linux-crypto@vger.kernel.org>; Fri, 3 Jul 2026 04:53:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	8SMAhbfVSKwdD38G3f7xC/eXU4B+FvV86kCi6fke9xM=; b=Wq+tKiU48g3TImZY
	BVsG5SrMsXC0FkeoeAWd+nMsmVUlh9Q4f6sz2ooetk/bhZC4sIXjYhi2sfiQ9tNQ
	IOOb4PjFvr2kKN9Ikp9X63OqkwNnxdLcmCWknABhkOl16yyTmAreN/+yUNSVoTQh
	mVkVHCa2kCJfvPEm4S4xOIX16M1oVpVKKsAdiLRsCOazxuGNOmeyuXly1ow+23wU
	gR7xl8JJLFA4WibAOC9cpumJ3W5At3wHZgIa6eXO2AVv7c5QHL0U38NBzHVRUjTE
	liPvOYMjZwQwfyrUAh+TGaaQAPxJenzGRjHYBv4gg29gwnaunU4Zf3f8X2ROOo60
	UiTIVg==
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f65qcg6m1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 03 Jul 2026 04:53:14 +0000 (GMT)
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8479c6c6cbeso218436b3a.0
        for <linux-crypto@vger.kernel.org>; Thu, 02 Jul 2026 21:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783054394; x=1783659194; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8SMAhbfVSKwdD38G3f7xC/eXU4B+FvV86kCi6fke9xM=;
        b=fac0FvTcdpuBOJah3JkEoqD2LIdJveNtQOHKNPcY0Ml91gckkmx8E3TZC2fDVn/W0X
         QGAcLb+OeI6wfh31ZIkGwYIX4Z7FHpy3WbpuTQmqcJSbiUqRaC4GPGnZiVeIa3IjTrnd
         lAzlHeaNwu37pgufbWVMQrK/5oaVzrn4FbL64bV1ePY542c4Lzb9q4Wiz2ad1PXXzWhw
         htw1SdEJomWyR8nRqbWLH5KxA1N+AE3JQ5cgjvCOA+5bxlbLmJ7walRFvP6uA+sMfXVi
         3wIfxIccUYIjecNOVEdgym4DIHsSVyPJcBL871SBNf3gzbkpFV+VtEVpHm9Bw08cU12p
         j5Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783054394; x=1783659194;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8SMAhbfVSKwdD38G3f7xC/eXU4B+FvV86kCi6fke9xM=;
        b=XnEJbTT7uxnlPXHHuyhZrtc7ZNpiK9rvL4wm+uJsKgiGnxrHCjpQuHjT8vhaOGFApS
         Pj0wtsCFF8VaoWFCWYjPuOuOPyiPsDHcDF0KD9g5ySHu+IeGya+u6W5GtKviWXu1uwBD
         44Ad40eyraNbrpjYYw/u/plXZ3RHSbRHXKwk+H/NnB14jbPLtKPuum0/wQyJRfEZAtKP
         LgbKodfj8jb/jCHGlDgaLBm+x7pvc35eY+JHV2DEp8RqYH0MTgqkdBQaj5CvSTgaiAON
         ezMDu6ybhLx2PWS50bY9YffNuOLgiVS/9JlOml0cUOYT4/s3PBuWlepwmtWBZTvgtxuE
         K00Q==
X-Forwarded-Encrypted: i=1; AFNElJ/myoCvjkpfmROn+2CUx885+YmDhV2yBSMUxs7RXUY2kUmBqde5UG1NInZiY7sNyadGFtJ7KyoQ8p9O7CE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzW3E7SnBbYFGRi8IEpnFAKzfMUVbkBT04FGOQMgcSYCG9MmVyz
	RIpLO7Phu8VZhIiXwjTxI9VUSEW9qqkSr6MjaE3TMTSavEZgAehp3/KOFglAwZ6fy8OfEv08wgb
	OUYXPdjKqdT+bHmhn0AzVQwqW5gZaNbMkC+YBQlaqeGLrqrfMeaB2r1FGcVLcCJakJh8=
X-Gm-Gg: AfdE7cnRar7vLAePm1V3aYbhtrQALZhGlNuZuJz22TnSPL/yaNNplHDrVnAx8w03NZu
	tcqfY5b0onPaqJh1VDOwtd1zZ/xQCeLNr83PalU70q4w8gnAz6Fi7XnOOcpyMLrEIExv2NjZmA9
	PbB5FKbNuYsXsQ8KXZiPkGOG41b+XEHT0q5t7//UcXltmjFYV5bqvfrDBIaamkcQePeQLCRyxZ8
	spWyhS1vL2xa8IaCJXRt8iu5F0zr94EDF1aC+HRyxKzlDcml54M/pZSakm+AeNbE8cwYzKGg8Ja
	3cSNxn/Q41NOfv/UY8F8MpvSVlc33kskuTX5WKOcCTzZujc2/jkxm7xuvgKCYhbjz6yhZNk138V
	91KauT9SlUGJqZhWV2YGjqaKTOcTdZA90IKumZrA+yYs=
X-Received: by 2002:a05:6a21:697:b0:3bf:e94e:e38d with SMTP id adf61e73a8af0-3bfed472a5cmr10107086637.43.1783054393107;
        Thu, 02 Jul 2026 21:53:13 -0700 (PDT)
X-Received: by 2002:a05:6a21:697:b0:3bf:e94e:e38d with SMTP id adf61e73a8af0-3bfed472a5cmr10107058637.43.1783054392522;
        Thu, 02 Jul 2026 21:53:12 -0700 (PDT)
Received: from [10.217.222.146] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f0bb843fasm15565027eec.18.2026.07.02.21.53.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2026 21:53:11 -0700 (PDT)
Message-ID: <66b34158-56cf-402d-9364-2522dfc45d80@oss.qualcomm.com>
Date: Fri, 3 Jul 2026 10:23:04 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] arm64: dts: qcom: shikra: Add ICE, TRNG and QCE nodes
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Frank Li <Frank.Li@kernel.org>, Andy Gross <agross@kernel.org>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
References: <20260521-shikra_crypto_changse-v1-0-0154cc9cc0de@oss.qualcomm.com>
 <20260521-shikra_crypto_changse-v1-5-0154cc9cc0de@oss.qualcomm.com>
 <enovafjkiuzr4bciu6bu6hh7h56wvnaq5fh7f46m4h7browyrd@7huwa5egaqaq>
 <55039d7e-34df-4f89-8188-fcb45fdea538@oss.qualcomm.com>
 <46005937-c1a9-409b-89cf-4b8f592dc5d1@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <46005937-c1a9-409b-89cf-4b8f592dc5d1@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: mqULTZezpQ_DGmduRCXHOL1H9lgvMbyw
X-Authority-Analysis: v=2.4 cv=Bb7oFLt2 c=1 sm=1 tr=0 ts=6a47403a cx=c_pps
 a=WW5sKcV1LcKqjgzy2JUPuA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=pHORTPgO1eFKx7QcuTIA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=OpyuDcXvxspvyRM73sMx:22
X-Proofpoint-ORIG-GUID: mqULTZezpQ_DGmduRCXHOL1H9lgvMbyw
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDA0MyBTYWx0ZWRfX49KajRpqZpbc
 TVIKVoU/PmLfGZToxn7JBhKXsyMLRBirU5HU9XnHs3aoHXfoSTCvKy8aFfa2Egzek0EFLBZmtwP
 aHmb4PmVdxqhjyEIQMEyzhIg3CK2+FPZH0YWl5TCRIUebOay53nGbcApYBTvHrc+qZBa6Ux9xbo
 h0fnGD6e/33pRAlXpc1PeIzv+fjbb7zFBGnE+cwf+/DVltGrWgTb95WOj+d/GNIgbqhVdNBrcip
 XmSFeyrPnfMd0BwJYABRp+YKfk6ksNvdX59wTkSJkA1Q1/NpzjNiItjrJ8cDEk7rJ/evI+jwXjy
 tiVdGALtsP1FX/Lmx3YUTCtlhefpWUc0diug43hvlgahQ2wG6daUcz8kckfw1PmoCJNg3z0osNn
 UgY0ikBkwRVkBmFFMB01kV3Xlyde1NpvE1k628OAFLvaTiIB8sJXn2vexffhSMCioZP9ceoB1HT
 ZvZunEYzxdxaDgOf04A==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDA0MyBTYWx0ZWRfX+q2rF5UAh4C3
 LalhC2XdnhQc+dfvRicZ3Ia0FU5a1RzUJhf3lWK7ceAiFL6nTdzGqgRIG/KaqNVhBZr/+aQxlVL
 RNSu5VmUOf1+cQT7gW7BqHrUjk3UnEQ=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_01,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 clxscore=1015 impostorscore=0 suspectscore=0
 phishscore=0 adultscore=0 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607030043

On 29-06-2026 17:10, Konrad Dybcio wrote:
> On 6/8/26 12:09 PM, Kuldeep Singh wrote:
>>>> +		cryptobam: dma-controller@1b04000 {
>>>> +			compatible = "qcom,bam-v1.7.4", "qcom,bam-v1.7.0";
>>>> +			reg = <0x0 0x01b04000 0x0 0x24000>;
>>>> +			interrupts = <GIC_SPI 247 IRQ_TYPE_LEVEL_HIGH 0>;
>>>> +			#dma-cells = <1>;
>>>> +			iommus = <&apps_smmu 0x84 0x0011>,
>>>> +				 <&apps_smmu 0x86 0x0011>,
>>>> +				 <&apps_smmu 0x92 0x0>,
>>>> +				 <&apps_smmu 0x94 0x0011>,
>>>
>>> 0x84 / 0x0011 is exactly the same as 0x94 / 0x0011. Likewise 0x96
>>> duplicates 0x86. Drop the duplicate IOMMU specifiers or explain in the
>>> commit message why they are required.
>>
>> +Konrad too as there was same discussion in past too.
>>
>> 0x84/0x94 and 0x86/0x96 pairs are actually different even though
>> resulting sid is same.
>> Let me explain more.
>>
>> From sid sheet,
>> Description	   SID (hex)	MASK	RESULT_SID	S1 CB
>> CE descriptors     0x84, 0x85	0x11	0x0084		S1_CRYPTO_KERNEL
>> (for data pipe 4/5)
>> CE descriptors	   0x86, 0x87	0x11	0x0086		S1_CRYPTO_USER
>> (for data pipe 6/7)
>> CE data pipe 4/5   0x94, 0x95	0x11	0x84(same)	S1_CRYPTO_KERNEL
>> CE data pipe 6/7   0x96, 0x97	0x11	0x86(same)	S1_CRYPTO_USER
>>
>> Qualcomm BAM DMA engine driving QCE has 2 major components here:
>> * Descriptor pipe (0x84/0x86): This carries BAM command descriptors i,e
>> key, algorithm, length etc. which tell crypto engine what to do.
>> * Data pipe (0x94/0x96): This carries the actual data payload — the
>> plaintext/ciphertext buffers being read/written.
>>
>> The descriptor(SID 0x84) basically contain IOVA address that points to
>> the data buffer. That same IOVA address is then used by the data pipe
>> (SID 0x94) to actually DMA the data.
>>
>> Since, Crypto engine descriptor and crypto engine data are part of same
>> crypto operation and with the limited number of context banks, smmu
>> provides an optimization to logically group and resolve them to same
>> context bank/page tables.
>>
>> Pipe 4/5 contain 2 SID(0x84/0x94) for kernel and pipe 6/7 contain
>> sid(0x86/0x96) for user. Pipe 4/5 doesn't touch pipe6/7 buffers so both
>> are safe.
> 
> I understand they are different from the hardware perspective. Are they
> different as far as the OS is concerned? Will we ever need to separate
> their data flows? (I guess that would require iommu-maps anyway since
> currently they are bound to the same domain anyway)
> 
> Alternatively, if you'd like to keep this level of description, it would
> be good to describe the iommus:items: in dt-bindings, so that one can
> make sense out of it

Ok sure, I'll update iommus:bindings in that case.
Please note, I sent v2 and will incorporate in v3.
https://lore.kernel.org/lkml/20260702-b4-shikra_crypto_changse-v2-0-66173f2f28b3@qti.qualcomm.com/

-- 
Regards
Kuldeep

