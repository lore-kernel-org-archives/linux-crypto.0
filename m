Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FD53242AD
	for <linux-crypto@vger.kernel.org>; Fri, 20 Feb 2026 09:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771580584; cv=none; b=Du/waGrexEMk8BZMZw/ZdZY1Ou52gnrMKx8ckxMZcPlZ125INC8iv4HQ/V5fop7pZbE3E7uJ/xWOwUkguY3uZvnBSPz8+oNmY0tqN9LkQnf0/BEWv8tl2OivhGWkgq96WppkdemcmM4gq3wtkV63ON3O14kxAEb5JJaMkwTytqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771580584; c=relaxed/simple;
	bh=CiWq+Xs4vmJh57HSDRnCX837eKkd1jg+USAW7LmCI34=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K7e4cbwUrR430aKjN9F+C9WmQgYC+qt+a6O9GK1/KtCzxlUNZzllVj8tuNdX5H0hLlXnRNrQ4W8pgms0wiOzt0PQMK1da4Io/yPzND8VGFwKiEeEi7gQte2KgitHvm0VCBEfqOEQbTP1WC5dK7Yf14TZQPCYCDYWcGyYZ+vXc8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SigV1Ufs; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iRrDifmY; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SigV1Ufs";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iRrDifmY"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61K5RwLn2380216
	for <linux-crypto@vger.kernel.org>; Fri, 20 Feb 2026 09:43:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Yq1Y/8D7dzvVWIg3adPvOmmq+xjHtt7YPV2lZuHm6v4=; b=SigV1UfsG8k21zWZ
	/++sdX/4++YVit6xZK1BheTCMXHzNp2CG3RyP6/BIplNRTUcEzTpxRWX7klVcJeF
	y9sMsznn/5KK5p9uLcxScVq9j7MivdK4gCJ9PsIZfw1jXKlJlPMEFYcn//GMGbGN
	oNfOF6xCfAB7N/cgLvY7brbgjpZTeMWpVKTz+4zuezbjjKs2xt0xi6AUG825rddn
	g9/QOEt772XFRPo0n0MslBOt1IsVF9HxxpyvJLGNLRF7UhWVn2P77f29H3zIz6BI
	1nSDTOE8XmieNAurj2Qh55hft3NXxun+J8yUnPXmtFWHAOJ7/85Qm0EUDxkcoZcp
	g7/+dg==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cechh995x-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 20 Feb 2026 09:43:02 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8c70cb31bcdso192100785a.1
        for <linux-crypto@vger.kernel.org>; Fri, 20 Feb 2026 01:43:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1771580582; x=1772185382; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Yq1Y/8D7dzvVWIg3adPvOmmq+xjHtt7YPV2lZuHm6v4=;
        b=iRrDifmYJ7xGqXAyT21BpE8q9uwu2Yc8i85fmKJ1t7yfIJQPiyhy321N+4plpSOGaw
         fa0dxq8eYugtVN45ha2Jm0NJLeGlXIyzQ71HFFEx57L2Mkl+V5xMEfcTJ33XIMgLYwSt
         DsZJCRilvQghrLyWQC5Oo6Iv2yMtG93Z9oyG3xvcbje5e9N/D9Py/GUmhufP7T08/+lJ
         3Ik1v/41X+8Fhsfv3gF4ESwoYTob5Slaes1oJvFymq5usztK5e+Xqr1sWGHZFcrXWw0f
         5DQaiG6054VjCAnsB3LvkouBFD6c/oSOE3UfHvuOD/IJtUXNIva1S5hIAbCMazr+PdPa
         oKDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771580582; x=1772185382;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yq1Y/8D7dzvVWIg3adPvOmmq+xjHtt7YPV2lZuHm6v4=;
        b=Wug6O0t7vXCaO7WhASm1Y/92jet4mQGmnaYg2jJMD93lw3Ylh+66Okje/kepPUwdUf
         3QV99d7bJFpkslWWaDwBdg3YohUS4IevGSnB6RZcucdx89gtTN3OqKZt++j8vN+tdf+/
         /4WVCKXczLWwlXbiKTwO1EIOsRDvS+9SrJfgnSXiCt5Vw4K1iriiIp+kCRUlvIr5heJ0
         7lLJlmHPIDnikVbaECtQBzTPTbZGoO+i/wFv8OjoRTu1at5FagXI6CuW4bu8/wVJm7xS
         MXAWJeeqe4QfQ1BoqD8RuIbuVdW0Lw3i5Gxp5TSo4SLrXKn4xYjL+LEu7SfSwqCLz1wN
         T6wA==
X-Forwarded-Encrypted: i=1; AJvYcCXxsmCnGBs9AmBfNczz9ru0M0qseELGvr2DvA7YYYk6SteiQ/IFvH5S3EIzJ6p+FaYaq3+0nHotMKN5lpA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzyup8UHm9Ayo7UiRQl6gL4OesbAXFWk8DvP+bs6rRAXRkCQaev
	xdh/wGDQZKn3/U6phhu5TbyJNWH/X1swNNbvivEo5uUIwnIKmJCSRk5AN3AjrNkiTn2H+VCIw8X
	vBpR4nkNn2QDumahvlGGnvX8la0ANBWRQ/IY3lm7R06Zdsm+cJ/vazOFlL2rKe+epqIU=
X-Gm-Gg: AZuq6aIzPm2+fXuFZVzuyvCUxedCjvBBant5kBKeq4NlxkTsmVobt4XgbORI2lgDt8H
	bp4lIi2J5oCDP0yJkV7PLC9178lie5BL6NdnxwxNpLp9EOV6OdQokGsrkSiMD/v/xKEtY0XPopA
	NVEAEJan/LfONwo8oQVKaLKp1VomDcbpBIx/Pq0UX9IJ7Y7hycWBCHGpxNYj6Xh4+9tlsejU5kH
	aIrAnMKLSVpLqLk6pTEVwrO1HTKYFnECAxYZM3mx8gd6gR5EsAwrhCGNxsb4YLVJAIVaUksDtaW
	Z86rd+K9IVFzIIXg4GEz7AaEsf6GbYNedfoVm/8pr+M3HHTlLv/pXC6IAEv9dHgzefAIHM6oWbi
	j/CEIv9uCLInVdkhPZCrO5W1yWNoYVjLaiGNqzTGB8fOA4HGrPbD9E62s1oyqfchtAxrUtorG/L
	l/ewM=
X-Received: by 2002:a05:620a:5dd1:b0:8cb:47cc:2dc8 with SMTP id af79cd13be357-8cb47cc3ad5mr1716687585a.3.1771580581644;
        Fri, 20 Feb 2026 01:43:01 -0800 (PST)
X-Received: by 2002:a05:620a:5dd1:b0:8cb:47cc:2dc8 with SMTP id af79cd13be357-8cb47cc3ad5mr1716684785a.3.1771580581218;
        Fri, 20 Feb 2026 01:43:01 -0800 (PST)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-65bad4fa7c7sm4793620a12.31.2026.02.20.01.42.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Feb 2026 01:43:00 -0800 (PST)
Message-ID: <5bf31bf9-835b-4b87-a4d0-8452d516f13c@oss.qualcomm.com>
Date: Fri, 20 Feb 2026 10:42:58 +0100
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
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <aZgOUv+QweA7vE1W@hu-arakshit-hyd.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: lnKKHUXDK3Pv1zgTQvFW7CM8CPWxJN1z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIwMDA4NCBTYWx0ZWRfXw9KsNZ5cxm6s
 t3ipTdb8vSYwcTyfXcmWEyao87/EkWLWaJG8QyEBN0P7ka1QpaVBOGGEczDFVcsnWokKYXp1tDF
 BOnHS4+z/rzNyECqZZk1CxNX6vrBaRTHk21jrtb1hJby6nXaJR5DlI+3aiIfFaPh73FaF5qi4vq
 QA0FDgRwQ9V+YFthOO+Y0k1l92Yj9nR/BhOzDtJhbekmTtSLwceqyYChFsSvuK/ukZqhBsj2xMs
 aXKf9rIQ2caZg7JqLS4GZ77MAXa9kaRDPIz/DiZzXus9sIDJBZQfP9D+B7/+jzqv7eAjbj5rVpz
 00syRpT6dgLfAC/iQVSWTj9xMtt7nQzZpFDmxdyTT68VcgIE9WTi9a2BZLAP2MmrjNF0i2oVA12
 9MCWTrIu5UYCU71WG4hy/aV1fZ+dn2bly9l/yWTZAI0if7UqrnfZRaRb9gle+gly7TtEIwyLK23
 2tnaarAM+WWmu2QFXFg==
X-Proofpoint-ORIG-GUID: lnKKHUXDK3Pv1zgTQvFW7CM8CPWxJN1z
X-Authority-Analysis: v=2.4 cv=KYzfcAYD c=1 sm=1 tr=0 ts=69982ca6 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=A-1GGxaxaoYmO2IoDNcA:9 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-20_01,2026-02-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 impostorscore=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602200084

On 2/20/26 8:33 AM, Abhinaba Rakshit wrote:
> On Thu, Feb 19, 2026 at 03:20:31PM +0100, Konrad Dybcio wrote:
>> On 2/18/26 8:02 PM, Abhinaba Rakshit wrote:
>>> On Mon, Feb 16, 2026 at 01:18:57PM +0100, Konrad Dybcio wrote:
>>>> On 2/13/26 8:02 AM, Abhinaba Rakshit wrote:
>>>>> On Thu, Feb 12, 2026 at 12:30:00PM +0100, Konrad Dybcio wrote:
>>>>>> On 2/11/26 10:47 AM, Abhinaba Rakshit wrote:
>>>>>>> Register optional operation-points-v2 table for ICE device
>>>>>>> and aquire its minimum and maximum frequency during ICE
>>>>>>> device probe.
>>
>> [...]
>>
>>>>> However, my main concern was for the corner cases, where:
>>>>> (target_freq > max && ROUND_CEIL)
>>>>> and
>>>>> (target_freq < min && ROUND_FLOOR)
>>>>> In both the cases, the OPP APIs will fail and the clock remains unchanged.
>>>>
>>>> I would argue that's expected behavior, if the requested rate can not
>>>> be achieved, the "set_rate"-like function should fail
>>>>
>>>>> Hence, I added the checks to make the API as generic/robust as possible.
>>>>
>>>> AFAICT we generally set storage_ctrl_rate == ice_clk_rate with some slight
>>>> play, but the latter never goes above the FMAX of the former
>>>>
>>>> For the second case, I'm not sure it's valid. For "find lowest rate" I would
>>>> expect find_freq_*ceil*(rate=0). For other cases of scale-down I would expect
>>>> that we want to keep the clock at >= (or ideally == )storage_ctrl_clk anyway
>>>> so I'm not sure _floor() is useful
>>>
>>> Clear, I guess, the idea is to ensure ice-clk <= storage-clk in case of scale_up
>>> and ice-clk >= storage-clk in case of scale_down.
>>
>> I don't quite understand the first case (ice <= storage for scale_up), could you
>> please elaborate?
> 
> Here I basically mean to say is that, as you mentioned "we generally set
> storage_ctrl_rate == ice_clk_rate, but latter never goes above the FMAX of the former".
> I guess, the ideal way to handle this is to ensure using _floor when we want to scale_up.
> This ensures the ice_clk does not vote for more that what storage_ctrl is running on.

Right, but what I was asking specifically is why we don't want that to happen

> Also, this avoids the corner case, where target_freq provided is higher that the supporter
> rates (descriped in ICE OPP-table) for ICE, using _ceil makes no sense.

This is potentially a valid concern, do we have cases of storage_clk > ice_clk?

Konrad
