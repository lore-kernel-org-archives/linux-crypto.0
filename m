Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19C539C634
	for <linux-crypto@vger.kernel.org>; Tue, 24 Feb 2026 13:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771939912; cv=none; b=OQnXOJqpfBJNez3Kaa4VC6BjRqrTArUtJuWryrPg9kjBlqV/jmPi923tRrOoIU5YDQ5zve5W97G3h+vAFCbPlBvM7Ba6r9+Bv8dUUNnSdSRnun4oZMSFh49B22xoy1DaN7+jDDDjmGfUMBMu94Fcn2e0gwnHy+uuXhL8pOU+jaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771939912; c=relaxed/simple;
	bh=CyXybCP2CIrZVrNr/6Av/CKn/Tkw5kvvtvSdn1OVQfQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UAAFRcc8OtsOH30nC19yGNa2GqIs/Fc2s+dOYhBv7CeOx10RGrFHXqvvK8/hel15w5zMVzOnW4+0mZih4lD9bv5xcz7DWbXG6zSvCq60CVpG8+PAz/NHZe8khGJMN5epL5kreLVypy+8nrt1Tjy24FFTerjay46vDtvFVtyuUi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Qafm+dss; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Xa8UzC5A; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Qafm+dss";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Xa8UzC5A"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OAFSMi2560550
	for <linux-crypto@vger.kernel.org>; Tue, 24 Feb 2026 13:31:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	gBLQ8De82Wd4XTyosqLd7sRYfu8OUMzWZSMfRzba/Sc=; b=Qafm+dssDOA9e77r
	RCmSPAPd7B86iAhjvAPwtiXfQqXkUbWo36P+TyOjY1zZmBt7NplA/2a22wv2lftp
	VB5x9cv4kVYAO2cLvFV0RSAeIUOrhPtHC7G5gTPnsvH5Axfj6pMIcEzJAQnRe+o2
	ix9+LCzgQOjUr7UZwd+Kbijzr2kwt1ecSidZ7CYzsAvn9Hn6mqVaAj+r/A5VtXG6
	lh6esIMnmd2HdbUTAxTEEC1ZSlmQplPRmad+NdignJxmK1XBgbJg2zGHTWRmCI+h
	cBHsMZYEpXPLdLY3ys1WuWTuVYEmR6z5vGAm41hi2E9LcvW0C1TTdnU6yKCjqiuf
	j1hGSg==
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com [209.85.217.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ch4e39hgf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 24 Feb 2026 13:31:49 +0000 (GMT)
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-5f54dd17395so972157137.0
        for <linux-crypto@vger.kernel.org>; Tue, 24 Feb 2026 05:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771939909; x=1772544709; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gBLQ8De82Wd4XTyosqLd7sRYfu8OUMzWZSMfRzba/Sc=;
        b=Xa8UzC5AU6kNMCbiB5blOeipvCZ83WDftz9/DInzu2R00qeMJf4XFLcI6oRmspV+lF
         WmIDpr2uilwd9QVgttVF1WgsBJW6OSGhn42VDpRvsC/MhhjDjm5umy3zRD6hL7hOY/W2
         1FO81mgkMxUzHazcfKO2rT+qPNkaBhWSkoqeSLtQuHtRm6nbNUpv+zAwgjGrMgsWSBda
         o3muM8fS/22c7AKa9T2/VyTNQuKEcLANKfIyImvtPW46cuTzdcvXd48fjFXRW6Xksutg
         +S0O4Zk3Vqlw0m2VtWTZx+ywvgv9GuDIvV5fL14mylKfqEFHQd58nyhIgHmXqE2TkfgT
         xyxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771939909; x=1772544709;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gBLQ8De82Wd4XTyosqLd7sRYfu8OUMzWZSMfRzba/Sc=;
        b=mZRctx1FnmGh5wfcNDRZJxGeiLIpB5++Vbn+XdZmqu8BIQDWac0fK2QFSPVhC3aUQe
         90Btm7d1ym67z5x0CbfuHn1qnyJ/Wj+C3E8xj0twTHDZRqYsD+37WL2GQRTKV/oPqFev
         z11CA3PAhOCZ/KFDvLLet9rJiOP744vTKeA41kN9jufAfZKYIdqsfMi1qbFvigVbDZSx
         Bt8yaKh0SykQtXDaOf1f3k/TNVKebgdjmge6VdWrMoKW2oeeUoZ/wkCoGqTarSm6nAk9
         qGcblI3U4OQhtf/rscyUusTWQ53s5GLGAxEb29Q6wWO/xZnsbMU70dlPe00+CrxqvWr6
         rT6A==
X-Forwarded-Encrypted: i=1; AJvYcCVRn8BvtOO4N3vuWV99CSgYUe6UyCeQKaFafgdVw+dzPo1H8i9ghpnkrwFM+Pt0LBuG12tufiL/zyjvZjE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjM373penmtLXnVOohSMY4q9vo0EcglAlJVDRKpLHvZl3lHoBQ
	4IQ4/AxdH3Uqh5sb6DYFKaGxt4c2pGvN8HglLXVf3g0WTZFFIFPmmepM8d9T5GgRfB36MsalY7i
	esshJEJ4NXVVUzTZOa3+9Yn2a8IzZCvLZzbvJM/0yLXJypOSaeg0cSa6zY1PJJRPg3iQ=
X-Gm-Gg: ATEYQzxWYez8+f7uUFKyskrigiSHR5Qq5aJHK6DPeT2MDppSTIT4EIqdKpaMEPL69Xt
	tJm3OR82JMOkDvG0Z49GIzVCoYxMg38G7VqYIQncpQm+dLwTlkwrqEyrxbOb2MgBdi0BRlJG9Uc
	N+ED+7ebAha+02A6e5b9fLt6fAWCfGDL/FMiPwSladSiWrdIHl9Bsj4ucxw7CisZtHSwZenz7gT
	AGHiBzzjTyAkTa6lGxDxAy3o30JJsZhLLDZQABv4rEZPdBl5f0Yx/KwCLQbUS9w+NItH2XdT/N9
	8aE8dW9dQHFyE9XDhb2uFTZZ8n779OGHScnoiMf+9gRAsV2+hjy136ROjQzHSABVKsr7ImM0Kpr
	aDWThwVzwSn+GZ7LMlYajc5ZgK3yExFnjYyK0djJYVusKneQ70V01WQCs5ka55c6N3BqJtl8vr0
	OjFEg=
X-Received: by 2002:a05:6102:50a7:b0:5eb:fc32:9361 with SMTP id ada2fe7eead31-5feb2c1c2bamr2329983137.0.1771939909162;
        Tue, 24 Feb 2026 05:31:49 -0800 (PST)
X-Received: by 2002:a05:6102:50a7:b0:5eb:fc32:9361 with SMTP id ada2fe7eead31-5feb2c1c2bamr2329968137.0.1771939908693;
        Tue, 24 Feb 2026 05:31:48 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9084c5dcb2sm424792266b.6.2026.02.24.05.31.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Feb 2026 05:31:47 -0800 (PST)
Message-ID: <4bcf1512-a567-44a9-8a38-8976f65c00fa@oss.qualcomm.com>
Date: Tue, 24 Feb 2026 14:31:44 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/4] soc: qcom: ice: Add OPP-based clock scaling
 support for ICE
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
References: <20260211-enable-ufs-ice-clock-scaling-v5-0-221c520a1f2e@oss.qualcomm.com>
 <20260211-enable-ufs-ice-clock-scaling-v5-2-221c520a1f2e@oss.qualcomm.com>
 <bfbe04db-bf64-418b-a75a-88879bf0bf2d@oss.qualcomm.com>
 <aY7MidG/Kcrs83O9@hu-arakshit-hyd.qualcomm.com>
 <3ecb8d08-64cb-4fe1-bebd-1532dc5a86af@oss.qualcomm.com>
 <aZYMwyEQD9RPQnjs@hu-arakshit-hyd.qualcomm.com>
 <6d2c99c4-3fe0-4e79-94e8-98b752158bd6@oss.qualcomm.com>
 <aZgOUv+QweA7vE1W@hu-arakshit-hyd.qualcomm.com>
 <5bf31bf9-835b-4b87-a4d0-8452d516f13c@oss.qualcomm.com>
 <aZhCWMTi3seAbXo5@hu-arakshit-hyd.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <aZhCWMTi3seAbXo5@hu-arakshit-hyd.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=UtFu9uwB c=1 sm=1 tr=0 ts=699da845 cx=c_pps
 a=5HAIKLe1ejAbszaTRHs9Ug==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=zMuZoWC4Nr6WuNNbOkAA:9 a=QEXdDO2ut3YA:10 a=gYDTvv6II1OnSo0itH1n:22
X-Proofpoint-GUID: maRJMR9tl9X9eoheqKV5bR20WwSDjAmT
X-Proofpoint-ORIG-GUID: maRJMR9tl9X9eoheqKV5bR20WwSDjAmT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDEwNyBTYWx0ZWRfX1HSQuRcl3+Pi
 M+OzyA1mEtsUmf77+EBrTdL0oYJwN9pgl3N63bD8EFVNcg60u/A9YoWcFxFiP0FIQNOte6rttH/
 1wqKC7f/SgHcnTmwYmLCYbzfTM9D2T5GFEVvhVjXDNM2Ws+7u9VRgrt9E8zuI0MzV2Pm/Ca/AqR
 K82a/VInNihnZJqbJ/+WdbxUHM1MbSJonjZ4bYzUCl4EJDXdSkQY6Hzm2VexGF2lQOEO2aZeuiP
 +FxmJaFC1fkt/qs4YHsNuMr/h6N79ZtirN4X9/sGc/iVCn4Jj7qAoNQna+prQwGjdWM9vrV/IVF
 YRKk8p+I5+lJMArlLqkZ4x8A7y4VVHymut49vKOcA/j8PsE/XCRs2AaFCu6V+Tpyf3HMvuq0fdb
 FYe1gFBGqfH4pJCFUb/kUKx1VcJS9Oke7j7U5LoQi4UX8FAmi5fK0IqWxddoEYXXcx6y2+bYf+s
 EAhu8/25A2qVfRDE6wg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_01,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 spamscore=0 adultscore=0 malwarescore=0
 suspectscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2602240107

On 2/20/26 12:15 PM, Abhinaba Rakshit wrote:
> On Fri, Feb 20, 2026 at 10:42:58AM +0100, Konrad Dybcio wrote:
>> On 2/20/26 8:33 AM, Abhinaba Rakshit wrote:
>>> On Thu, Feb 19, 2026 at 03:20:31PM +0100, Konrad Dybcio wrote:
>>>> On 2/18/26 8:02 PM, Abhinaba Rakshit wrote:
>>>>> On Mon, Feb 16, 2026 at 01:18:57PM +0100, Konrad Dybcio wrote:
>>>>>> On 2/13/26 8:02 AM, Abhinaba Rakshit wrote:
>>>>>>> On Thu, Feb 12, 2026 at 12:30:00PM +0100, Konrad Dybcio wrote:
>>>>>>>> On 2/11/26 10:47 AM, Abhinaba Rakshit wrote:
>>>>>>>>> Register optional operation-points-v2 table for ICE device
>>>>>>>>> and aquire its minimum and maximum frequency during ICE
>>>>>>>>> device probe.
>>>>
>>>> [...]
>>>>
>>>>>>> However, my main concern was for the corner cases, where:
>>>>>>> (target_freq > max && ROUND_CEIL)
>>>>>>> and
>>>>>>> (target_freq < min && ROUND_FLOOR)
>>>>>>> In both the cases, the OPP APIs will fail and the clock remains unchanged.
>>>>>>
>>>>>> I would argue that's expected behavior, if the requested rate can not
>>>>>> be achieved, the "set_rate"-like function should fail
>>>>>>
>>>>>>> Hence, I added the checks to make the API as generic/robust as possible.
>>>>>>
>>>>>> AFAICT we generally set storage_ctrl_rate == ice_clk_rate with some slight
>>>>>> play, but the latter never goes above the FMAX of the former
>>>>>>
>>>>>> For the second case, I'm not sure it's valid. For "find lowest rate" I would
>>>>>> expect find_freq_*ceil*(rate=0). For other cases of scale-down I would expect
>>>>>> that we want to keep the clock at >= (or ideally == )storage_ctrl_clk anyway
>>>>>> so I'm not sure _floor() is useful
>>>>>
>>>>> Clear, I guess, the idea is to ensure ice-clk <= storage-clk in case of scale_up
>>>>> and ice-clk >= storage-clk in case of scale_down.
>>>>
>>>> I don't quite understand the first case (ice <= storage for scale_up), could you
>>>> please elaborate?
>>>
>>> Here I basically mean to say is that, as you mentioned "we generally set
>>> storage_ctrl_rate == ice_clk_rate, but latter never goes above the FMAX of the former".
>>> I guess, the ideal way to handle this is to ensure using _floor when we want to scale_up.
>>> This ensures the ice_clk does not vote for more that what storage_ctrl is running on.
>>
>> Right, but what I was asking specifically is why we don't want that to happen
> 
> I would argue saying that, having ice_clk higher than storage_ctrl_clk does
> not makes sense, as it will not improve the throughput since the controller
> clock rate will still be a bottle-neck and it will surely drain more power.

Got it

Konrad
