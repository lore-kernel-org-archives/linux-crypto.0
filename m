Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615EE4A4987
	for <linux-crypto@vger.kernel.org>; Wed,  2 Sep 2026 15:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788363226; cv=none; b=sCaCZ9kVJ/2iNEZ/XoDMtehDRD/OMWmK7mHSxbcOgtQ7Khho8wEJRRCXxegHaiZCDjmNBrP5bWaCgY4egSdpcQIPmDoqmAVM3PB04UAOmlsVeXFxOdKRixK8AIg12J3Ol8AMEDidxAxi60mAwA8atmIbjv9cAnzBM5oJm5amINc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788363226; c=relaxed/simple;
	bh=6lYF9KV2HEwLFq6+al6aDkTRtGMquGYtFJdFYnQXEN8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JpuXA95wlmp02sZ9g/tegVhhHRXU0wETJgAbIlTKfnugijxEeRNQBBH8LWIQDga2FQb09zCSWI9zv5Rlczvl7QcQZwWy+9p/XWpKbaV2kNq9JbdkxCEXMmDWHrVBzXrs8rSRLzMZw3/30Th19W5M3gMr3DY98NxB00VtlmONUnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GE5dYC28; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ektIQOEE; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GE5dYC28";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ektIQOEE"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682CRHkP2001787
	for <linux-crypto@vger.kernel.org>; Wed, 2 Sep 2026 15:33:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rEUZ3PVE55ql740l9KlzWi1uLalDgnols2pTFF/fh60=; b=GE5dYC28o04T50C0
	MXh94TFSKPDeiSYrFJ1HggyWYY2E7z2bj12OGdQ9WZVTbNggrcxgO57Nb2usJh1o
	N/1ujNarxL4hmJeNoiMB1634vamDrENqIR30vnWvna+bPUUs4gKUVQr3Wjphgjpv
	+9ICOfwtZ4C7UREApQ0jio9n0N9EXHu/Q9Em9LqQKjIBun/kwmJv1vV1LjokUGjt
	uPtIX0yx9J35OEPpdfGMHgPybL7JNDjhVQlpX5wzKxOVMY7bV2bfY67irjMEt2xS
	2le7WpLIxdWm589t5rXlUrwQTiJF2g/qzPJUdrCIHZUnkR7kSg8fMNtg+wqdpws/
	0mNTUQ==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4geguy1h5w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 02 Sep 2026 15:33:43 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc39363cc88so1039152a12.0
        for <linux-crypto@vger.kernel.org>; Wed, 02 Sep 2026 08:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788363222; x=1788968022; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rEUZ3PVE55ql740l9KlzWi1uLalDgnols2pTFF/fh60=;
        b=ektIQOEExPBBQ8KqOSt0nLpKal2fSowYr+3KxPBDKTMXkWt/N8874yWx4a7gvhVrD3
         sjhQ8BDTTyxI0tpUs4HPvdmTxMCsBHh8NdEVUw9pGImUvTJy4+5PO/vF7nx3jAVlDW/l
         uq2gUXqC6+/dL9k2ZxrUq8ANVLV7GpzObOqmOTbHCXg0QH/AIeF8zf8NwHlGOnyDj/pE
         O59JtNShILPXlw270cBlBn33lxo8aK3hXDq2Zcs7B0PlxFarepIhkx2wgvPuWBSj4VeP
         2LPg/eHMGV+cOANNbMMYGat8/Qg7swHXv+rccXNvG3XeUyHf8JfRMBcHlnaPQcxZ2lon
         qvCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788363222; x=1788968022;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rEUZ3PVE55ql740l9KlzWi1uLalDgnols2pTFF/fh60=;
        b=Let+5bny4b+4hYeJWfVPkkrl/dJaYz7C9BMbPGPYZItKMiyzycX7ZiSerRNKeRWB2k
         8B7wxgNXTTs2K4P2zrJuhtVsp3hjlfRRBj9+8vHdiVztWLbW7QfMBBydMrd6R7elkrNs
         a7dc2b9ugLP6na2R3G4d4hsBWnoMW1JZV5gRmFYKEkLbJZmmeNfmuWsGI2A3xOv7/PNT
         NAt1kgM0n6N0ZgDalkdunKfoANKDmJjggEDESszMckv/dEP5jNQlIfp/aCVvkOi/kD5y
         d0SPH0L8wCXCBzYWjWzmt3RZzr4CA7CTp/xbKPkk1YWEx0Rp/JCiFQxfZfBShzgZDdYE
         CfYQ==
X-Forwarded-Encrypted: i=1; AKwUvBxctaCYmsTiYfoVrc01UoZu+TG9X6naYcsQGj0Erd8TtoVyzLm5HZs63jFPMeKCNle95kkUdniTI6q7hN4=@vger.kernel.org
X-Gm-Message-State: AFuF++kDW+jKbR89u+ocCpeJDFIiBnw2BD3DIlTes1dRh5CF36al0GSP
	PaBqmI7avKxlUdxXUCj8TCmAe0ipOedhk63/WTqGuVpAa066izgftuLAQID3f0M/CNwQVl0cOnT
	mjgpPg74A1REgcN+1rQzMBfnX6jA5PUAQPo8SRi2k1D+vs5z3D4Q2WRRiEDC4HfyFBr0=
X-Gm-Gg: AR+sD101ovroh7RaiX4XxLvC3UjXIiWDRbe7/TBopvQD74y9OC/LbaELq2Z9FJ4NXoL
	KpSGZmYM/OJTctKYmAkLIEGkb86EWL5dqv9pn/fkKtnAVSdDGanBMPdLSRGHuOyLF5k8BWqM9ND
	kLYVufL/rA1fmplsrteniJt5aHss4VHEJUFUJ9STSWifdRkPn42CzgJNpqCFOXUeVRbNMZ44Qc/
	NX5LnTeHlf3VL7G+HS/yRLD7BOVir7CXaoLfCcQ7rj3syaTAPDHrFCzCQ5gXLpeYHvTVZmWpLpm
	yq3+09AKpLMEevylJBB5aPYcTedDOIkZ8fugIau1sWTGdvXQmmk7ayaSfdCXFQZ/kzxkceMysA6
	xjUTpdfSZUKDcihu4acYgUBcU2NPoD0cCguMd4EWe7hlv+aG84UgQbjacYg==
X-Received: by 2002:a05:6a20:9f43:b0:3d3:adbf:777c with SMTP id adf61e73a8af0-3d9aecf72e3mr9896590637.24.1788363222098;
        Wed, 02 Sep 2026 08:33:42 -0700 (PDT)
X-Received: by 2002:a05:6a20:9f43:b0:3d3:adbf:777c with SMTP id adf61e73a8af0-3d9aecf72e3mr9896470637.24.1788363221571;
        Wed, 02 Sep 2026 08:33:41 -0700 (PDT)
Received: from [10.110.114.54] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32f079ee369sm7964033eec.7.2026.09.02.08.33.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2026 08:33:41 -0700 (PDT)
Message-ID: <418e2285-bb95-42cc-8543-bd540df9d0b5@oss.qualcomm.com>
Date: Wed, 2 Sep 2026 23:33:33 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 03/11] soc: qcom: crypto_virt: add support for create,
 prepare and import keys
To: Krzysztof Kozlowski <krzk@kernel.org>, ebiggers@kernel.org,
        axboe@kernel.dk, mst@redhat.com, jasowangio@gmail.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-scsi@vger.kernel.org, virtualization@lists.linux.dev,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: neeraj.soni@oss.qualcomm.com, gaurav.kashyap@oss.qualcomm.com,
        mani@kernel.org, andersson@kernel.org, konradybcio@kernel.org,
        bvanassche@acm.org, alim.akhtar@samsung.com, avri.altman@sandisk.com,
        stefanha@redhat.com, pbonzini@redhat.com, eperezma@redhat.com,
        xuanzhuo@linux.alibaba.com, linux-kernel@vger.kernel.org
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
 <20260827160806.1295313-4-linlin.zhang@oss.qualcomm.com>
 <4594e3db-a8e3-4f8d-95c2-a4edcbc8ca7c@kernel.org>
 <40156974-6637-49b7-8629-11e7d0d4e55d@oss.qualcomm.com>
 <650ac172-312f-43a3-ab5f-82318796472d@kernel.org>
Content-Language: en-US
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
In-Reply-To: <650ac172-312f-43a3-ab5f-82318796472d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=UZthjqSN c=1 sm=1 tr=0 ts=6a9841d7 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=7gRScLy_F1O9BZcavHAA:9 a=QEXdDO2ut3YA:10 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-GUID: J7undPmMKnXqToMYx38aIYngGUggONut
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDEzNiBTYWx0ZWRfXysN0Mc49ev61
 I2kNKDoerq16nigoE54Zu3/wjHXVceTK2m6BV30kytuTGeH6iBq9THumH0pxvJTHLKnXjyjklxg
 9jAFzIQd21MvMHmL4TDuYaC8Y/se8cg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDEzNiBTYWx0ZWRfX/txsVNZGwX4N
 OU0hE6ahs/aCeQdh+WDGZtc4nCRLeTZvgrS6SRO8YGQ9zRrqvmBDEu9B27DMFogY/ypIe1UFz5G
 If2EDxvGzmETHwCXUnxRIxgtIlzjW3jyqO/NFr8Pfb3wwpmIwURmkLB49LGtw1UoaptaiHYwmpY
 MtlXuaixhPBP4IfQbR71LflhHA8e1xfVp2Qnx5oUyl01gud+MgBx74Da75uM5sVSfVtemjsTnK5
 aiHv7tMcSvnqRhRoiA82a7BNrwSAH/3i5YSZrCG/lR9kPqBnLuLn/k1gIC/LgY+K1ek66aga33e
 Oki3pclHRflbgGMqYBJOCfitbTa02IM5D7gt6fffnjb6ZmP3jx0LfhfUlg1YJd6LqjIzIIS8G82
 NK64nQ0Smbh725CaBqDrRfX1hs98ZRDwCshmbtbeDwP/YE1w94x8yppsZzTljZAx0AjTqkyC2bc
 TVCvhQMkNIrZWexra/w==
X-Proofpoint-ORIG-GUID: J7undPmMKnXqToMYx38aIYngGUggONut
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-02_03,2026-09-01_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 impostorscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 phishscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020136



On 9/1/2026 10:01 PM, Krzysztof Kozlowski wrote:
> On 01/09/2026 12:31, Linlin Zhang wrote:
>>
>>
>> On 8/31/2026 2:58 PM, Krzysztof Kozlowski wrote:
>>> On 27/08/2026 18:07, Linlin Zhang wrote:
>>>> +static void crypto_virt_remove(struct platform_device *pdev)
>>>> +{
>>>> +	virtblk_set_crypto_ops(NULL);
>>>> +}
>>>> +
>>>> +static const struct of_device_id crypto_virt_of_match[] = {
>>>> +	{ .compatible = "qcom,crypto-virt" },
>>>
>>> Undocumented ABI, also not really allowed. We don't take bindings for
>>> drivers.
>>>
>>
>> The dt-binding document is included in another patch in this series.
> 
> And what does the submitting patches document ask you?
> 
> 
>> The concern about introducing a DT binding for a software-only driver.
>> The underlying problem I am trying to solve is how to communicate the
>> wrapped-key size to the guest.
> 
> I am not asking about your problem. Can you please stop answering to
> actual problems with irrelevant other aspects?
> 
> You cannot have DT for a driver.

ACK

I'll drop the DT binding and this patch, and look for an alternative
mechanism to convey the wrapped-key size and key relevant requests.

> 
> That's it, please read DTS101 slides.
> 
> 
>>
>> Because the guest has no access to the ICE hardware, it cannot get
>> the key size by reading the ICE hardware directly. In the other hand,
>> the wrapped key size may vary across ICE versions, it's infeasible
>> to have a fixed wrapped key size in the code. Additionally, wrapped
>> key size is vendor-specific, it's nor proper to pass it via virtio.
>>
>> As an experiment, I used a DT property to set this wrapped key and
>> wanted to get feedback on whether this is a reasonable approach.
>>
>> Is there a preferred mechanism for handling this kind of vendor-specific
>> configuration, or are there similar examples elsewhere in the kernel
>> that I should follow?
> 
> Not DT. Use whatever other mechanism kernel provides.
> 
> 
>>
>>>> +	{ }
>>>> +};
>>>> +MODULE_DEVICE_TABLE(of, crypto_virt_of_match);
>>>> +
>>>> +static struct platform_driver crypto_virt_driver = {
>>>> +	.probe = crypto_virt_probe,
>>>> +	.remove = crypto_virt_remove,
>>>> +	.driver = {
>>>> +		.name = "crypto_virt",
>>>> +		.of_match_table = crypto_virt_of_match,
>>>> +	},
>>>> +};
>>>> +
>>>> +static int __init crypto_virt_init(void)
>>>> +{
>>>> +	return platform_driver_register(&crypto_virt_driver);
>>>> +}
>>>>  module_init(crypto_virt_init);
>>>>  
>>>>  #if IS_MODULE(CONFIG_QCOM_CRYPTO_VIRT)
>>>>  static void __exit crypto_virt_exit(void)
>>>>  {
>>>> -	virtblk_set_crypto_ops(NULL);
>>>> +	platform_driver_unregister(&crypto_virt_driver);
>>>
>>> You just added this line, so previous code was simply wrong?
>> No. In previous patch, virtblk_set_crypto_ops is called in
>> crypto_virt_init and crypto_virt_exit. This patch moves the caller
>> to the driver probe and remove APIs.
> 
> Heh?
> 
> Let's look at your previous patch:
> 
> +#if IS_MODULE(CONFIG_QCOM_CRYPTO_VIRT)
> +static void __exit crypto_virt_exit(void)
> +{
> +	virtblk_set_crypto_ops(NULL);
> +}
> +module_exit(crypto_virt_exit);
> +#endif
> 
> And you claim that you did not add this line?
> 
> Do you understand how diff format works?
> 
> Best regards,
> Krzysztof

