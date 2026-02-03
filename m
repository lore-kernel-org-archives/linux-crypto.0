Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8B0225788
	for <linux-crypto@vger.kernel.org>; Tue,  3 Feb 2026 09:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770111116; cv=none; b=OAt40sj9e/kd5VArP7MeDzyaWJtjNsi7itrdkHVUC3RSybXflKpn3zaHRCpHhWojECOG615hesh1gT6FE4F6+bOmL7TPkZE+l38/MGbmHZXyWzvEZ2ni0ldDFq5MnWN2Prm4j2m61pfezgrA7YQXvmsqH6WGc5W3QfS7vlcb7PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770111116; c=relaxed/simple;
	bh=7lWwlNRV+6r2H3mLL3UVH1qpDayK7pYL5ubxSaD9W38=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J2V1kZOKLqWo9wPBu/75TAJRxWDCbsQNMdBe+bHAHB6iq4dHMbgj81idpaiiLgbBXffpyBAzDzrU0WL7soVJGuzQUt/JGDj8pieo6vPswWydr0AwbhYnHzYcYo0hUKr85LyDKu8QtXbH1RZIQXMo5HTZkOdLSczjZPJIZR03880=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=S/DYMzqN; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=V5TOKK+s; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="S/DYMzqN";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="V5TOKK+s"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6136R6fd3916032
	for <linux-crypto@vger.kernel.org>; Tue, 3 Feb 2026 09:31:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	YdHSwOqniPyo27OYcD5Smnsc9jClWLTB1iwxoPHnzP4=; b=S/DYMzqNK+prf9J9
	YjaqJJ2xHmlwt+7/Of2U3ZAlamJN4S3nZsngHFg6FshIQxDnzQwQvkkkoNXK6XJE
	3cIk74xIijW44Y4oDkwDtflY0/YBT7TGg7whWXV2sUTx3CAKCTXccpNGqZsccL0+
	HzW0PyJmSzqycNpwZaDFVkIx+qhhLd1ZQe6gXDZ/2ahqkV78av05T67jY3Rrhpc1
	qfChTUDBD22Jocm7Tl3nSVPm3riCWCIHfpLGq5s/rxhpfw2Yw0W1h9P6EcViLxy2
	t9KsIJl5Zl4P+hLdsGpsjvJwQFn/vaaJ6WxDHguHzgp871XBIo5oAVyYlb89b7tE
	2m4PJg==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4c2tkmkt2b-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 03 Feb 2026 09:31:54 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c56848e6f53so3438049a12.0
        for <linux-crypto@vger.kernel.org>; Tue, 03 Feb 2026 01:31:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1770111113; x=1770715913; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YdHSwOqniPyo27OYcD5Smnsc9jClWLTB1iwxoPHnzP4=;
        b=V5TOKK+sNUyD96H9XRyy1xL9Tp/J+UzyXzCA600WOR5wQdtOwJukkfRTgS8HdOvWdh
         YIQmyDsdD0wKHnLzWOoUV0YE1q9kAlY+TqbNyj5hHlMI4cThFg7jmXysrR8ouZD65wl1
         BnJX140pLOW0vyvt5iQP0n4cbcGawii8b26XMFDWHViNnhHABLW+xFwDqH2PlQewaIDm
         pnL0tjpb1afnYWcpudlOKtvBhS5SsRJMWPA2FKjkPSitOLckhtzpC4s1ydWMfvif6B6n
         t5wpefFlXYw7BMz571Yx9GDsndkNwZiNpB5daLHiWw5cRnDq9tmhD5Tm7gX8QHBm8Sb3
         Ow1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770111113; x=1770715913;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YdHSwOqniPyo27OYcD5Smnsc9jClWLTB1iwxoPHnzP4=;
        b=FYBBKUQrazIzkGDU/E7FP9i6hCKUAe2yYl+yM2d1WHrmsRylw5RP6FFVr+2kMOib+d
         pM8MtbzQ7ny+XDwP1FvRoWZRaw6cHuLjOA82ojnLBb3DgQWMAB5qOJnx4YkYjqLm7s5M
         ejpEHJeupoOeFiDshtR1O9IO49mLmDdGyfuQ5Qr2xluZGXR3NAiOAS+g+sACxL0uuwUT
         BvMI9+nuJgRDRpks2S39BErMw21GvWQP0+hoQyAmI6kCFQNZI7vifcvge3dueFmbZilv
         gvTOvMwkLc9zNlnH3gv6O97LIMmuqpND/0T+cm/miuYGuhT1lYkR3a3GPaKUSdVA2QZ4
         pEmQ==
X-Forwarded-Encrypted: i=1; AJvYcCXiPh2hYglKxqyH0JiBhqw+BDvOjmIoyB1rQFQYt+Eji3q4MvGYap5qv7qhQE8mIBH4pTgR0SZ3Nw/K/do=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0W10E47b8J+TiSdklIWx/Dj2gaNZKNmt8xRHxA6e8xrfITIkk
	agCOfZY/kdTIYB9qAjhwEhggoBmFTi8x9vJ6Xdmt9mFdCYT6dc955icTbUVLeOyK2Pu4c0Zk5Pw
	8BC+uHghJ8UQ+1RqhoGpLgLkV72Bf40sGCj7y05NC6vhn59b1adsG7GLR9jYW/HLZsAY=
X-Gm-Gg: AZuq6aLtLVPLlqR0XU+zNN/wGjVf0vzIUC2mJgnXE/VrRjj5FC7uthidiczZU9+GoO3
	Gj/1xu6wNmtESPzAGlBIrzVYRXDcytV1amf7YPCrXLY/TSCzGHeqo2l8ySN+c91DTB81EFDtIGu
	YvYCzcc25ob6kcvOQlB2WyhzJs+nkJZd0FblZTBh435W19a6j4zuBCPmoMwgBSiB359EhfNM0S0
	gu8Z9HdwNeRGnVY8PF24bmjtKCGGtjBFzrXnm+qQaYCzmLjaRsnH+QMUbVmWZ1bS80jO6Q02ncb
	KqIoAQ8UlR7jDlDqj7Er80MiCYcEXj6UicO0L6aPXx2CukYQxM9utPuJWUMWVgoyyK1nit0cfDP
	cUC5yNP3YPOSbl10IbcK6bU50cHw+0sTMVY+zfeU=
X-Received: by 2002:a17:902:e982:b0:295:290d:4afa with SMTP id d9443c01a7336-2a8d96b0eb9mr115559105ad.23.1770111113165;
        Tue, 03 Feb 2026 01:31:53 -0800 (PST)
X-Received: by 2002:a17:902:e982:b0:295:290d:4afa with SMTP id d9443c01a7336-2a8d96b0eb9mr115558825ad.23.1770111112690;
        Tue, 03 Feb 2026 01:31:52 -0800 (PST)
Received: from [10.217.223.121] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a8dc225534sm111999505ad.68.2026.02.03.01.31.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Feb 2026 01:31:52 -0800 (PST)
Message-ID: <0f8c0e5e-4921-47e8-b602-e6c08bb1f6f8@oss.qualcomm.com>
Date: Tue, 3 Feb 2026 15:01:45 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/11] soc: qcom: ice: Add explicit power-domain and clock
 voting calls for ICE
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abel.vesa@oss.qualcomm.com>,
        cros-qcom-dts-watchers@chromium.org
Cc: Brian Masney <bmasney@redhat.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260123-qcom_ice_power_and_clk_vote-v1-0-e9059776f85c@qti.qualcomm.com>
 <20260123-qcom_ice_power_and_clk_vote-v1-11-e9059776f85c@qti.qualcomm.com>
 <7da1727a-c1cd-466d-88fc-e140b2e7fe5d@kernel.org>
 <54bf72b6-6397-4655-9c30-680b1374400b@kernel.org>
 <82a6ba61-94a4-48bc-a012-d09152b32781@oss.qualcomm.com>
 <646bee0a-8b10-4fa8-9d17-030876179c02@oss.qualcomm.com>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
In-Reply-To: <646bee0a-8b10-4fa8-9d17-030876179c02@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=TaebdBQh c=1 sm=1 tr=0 ts=6981c08a cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=TJZTRc1pyfe8BRA72ZMA:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-GUID: aJ8W51DIsc-AJEiMEpgcLfFhK1qSMxkJ
X-Proofpoint-ORIG-GUID: aJ8W51DIsc-AJEiMEpgcLfFhK1qSMxkJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAzMDA3NCBTYWx0ZWRfX8068rQiG+o3l
 eH27rzXcGvNr5H7MU6ShAAgNxnMSnss9yOkAqMaipCBC8hox0OBRx2aF/Y004TWl0NhXftw5VcL
 iEv0R8i67IHDktvqy1Cmws9ayAW9yS4gVBRIWgeQ5S7ES0AUNmkqPSwbnrLLTA7Pu1tS3bVLGoc
 BDuZp7M6tY84KoMZZZmHuWOc9XkImZOsb65NJqvgRZKgzrwhy2m6vdjln7+pR5EyVPChv7p0sju
 bmasEHWcSXDV831KivHax85mECsF6As5GsCpuRI+GkVg+WuFRIvnE+KqOZyTNy/O6N12uLAOZ0/
 TwbICg7K9Cf/uJyYONR9IVx0NlynhCJupDVHQY1EQsV0uyzNGdz7oagQImZ20T6ctys25zEH3HY
 Rb/4dSdXtJFHXRjjzIKFip3h8VNg3YL73EoYbF0K1rGvFH3KFSvPZxZB/Byb0fvivRU0JDonMib
 iyv8RaRtHJE/P6N7OJA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-03_03,2026-02-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602030074

Hi Konrad,

On 1/30/2026 4:16 PM, Konrad Dybcio wrote:
> On 1/23/26 12:12 PM, Harshal Dev wrote:
>> Hi Krzysztof,
>>
>> On 1/23/2026 4:27 PM, Krzysztof Kozlowski wrote:
>>> On 23/01/2026 09:58, Krzysztof Kozlowski wrote:
>>>>>  
>>>>>  	return 0;
>>>>> @@ -584,6 +597,10 @@ static struct qcom_ice *qcom_ice_create(struct device *dev,
>>>>>  	if (IS_ERR(engine->core_clk))
>>>>>  		return ERR_CAST(engine->core_clk);
>>>>>  
>>>>> +	engine->iface_clk = devm_clk_get_enabled(dev, "iface_clk");
>>>>> +	if (IS_ERR(engine->iface_clk))
>>>>> +		return ERR_CAST(engine->iface_clk);
>>>>
>>>> And here actual breakage of ALL in-tree and out-of-tree DTS.
>>>>
>>>> NAK.
>>>>
>>>> Please read internal guideline.
>>>
>>> Internal docs are pretty scattered and messy so I failed to find this
>>> there, which is surprising because this was frequent feedback. Therefore
>>> please update Kernel Upstreaming internal page with following:
>>>
>>> With few exceptions, it is not allowed to break the ABI, by making
>>> bindings or driver changes, where the existing or out of tree DTS would
>>> fail to boot. Updating in-tree DTS does not matter here, because DTS
>>> goes via different branch, thus driver branch would be always broken.
>>> This is explicitly documented in DT rules and explained also in
>>> maintainer-soc profile.
>>>
>>> You need to either provide strong justification for ABI break or make
>>> the changes backwards compatible.
> 
> If the ICE can not be powered on alone without this change (i.e. no UFS,
> just ICE), then please spell it out explicitly, Harshal. That makes for a
> valid reason to break the ABI.
> 
> Plus the fact that without an OPP table, the voltage requirements cannot
> be guaranteed to be met
> 

Ack, I have endorsed and stated this point on the DT-binding commit.
I'll wait for Krzysztof's view before updating the commit message to
strongly reflect this point.

>>
>> Ack and understood. Let me write this in a way that makes it backward
>> compatible by using devm_clk_get_optional_enabled(). Like I explained, for
>> Linux distros where CONFIG_SCSI_UFS_QCOM is override set to 'y'. This
>> clock vote isn't really needed during probe.
> 
> This is really a side-effect that we shouldn't be depending on, or
> even considering as a backup, since the UFS driver may change
> independently and stop behaving this way one day
> 
>> In qcom_ice_suspend/resume(). I'll only prepare/un-prepare this clock
>> if it was found during probe.
> 
> Clock APIs generally happily eat nullptrs

Ack, then I guess in either case we can continue to keep the calls to
prepare/un-prepare. Anyways, I am convinced we should specify and use the
'iface' clock.

Thanks,
Harshal

> 
> Konrad

