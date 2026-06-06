Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2063BAD95
	for <linux-crypto@vger.kernel.org>; Sat,  6 Jun 2026 20:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780779577; cv=none; b=r8qJMr2hAXBxuxxaq430GMFEmJ/eYEEbARaSGknDZQzTGCesvfujNljiZ8ro2vDrMHGYW+1bsYbEsV6S65XifwE/ZbbnlxtVq1/lNTAmVgFqK0FGJ2N6TP8WJkis8edfu4ah5BY0RPd9rkolO/QR4wLpEyH8GHn9FH7DH8+6tVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780779577; c=relaxed/simple;
	bh=arhEzyLmfNvArxErmFJXcle+VH0Ew1YYMMZrQmaMspg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kWP8wxHeyPcb34KwtgxiESFea2ZpJW2Wu34HXYcL5RizxxUKU93ha2F5CoPgGcDcx9BpuqOA5YCl1qfTfbFqNHDdiVrfs9L6Grgf4Haej/H+86Eeg5GnMo4L4ISOlycqwAum7DPsap+squyfcsfjhxxyNONTJCAIKwF/qtVNy3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=nRmcpg67; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=QrNpQvdl; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="nRmcpg67";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="QrNpQvdl"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 656IiXZJ2679994
	for <linux-crypto@vger.kernel.org>; Sat, 6 Jun 2026 20:59:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Fdjzngtrv13KXGZ9M/pUsJxJulidxzwkCLaGZt9cbdM=; b=nRmcpg67b5vBJrol
	vOsUdeY7t7RFsETTXM7Wmy6Y0vCE2gWZbK/+xXFlzil/dSB5bH0Om7zbcuwlFJHA
	3LNT5386CzxTb4wqTvd13UrRIwxMwFiPCKM9yc1TIjSGNz+daiv93v0srcigvPLi
	ZwxeFZYdBw720Xa1oNFdqv5SHvtW4IjINTGSDqnzPVxwDM3pGq3PloTarmcaKB7/
	7EgxEgLfkFzGM0iTMl70ZVvVXWl5E0xO3mzBA97JSDaPwHqa0hYj65TIqVywhg88
	F/Tjkq6lXeJYmRcqBL/38rnrIkp2RBmb0IfWhgdUPL312r3yTOrrWmUKA9TotCW9
	jXdKLg==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4emaj4tfcj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Sat, 06 Jun 2026 20:59:34 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2c0c32f4b1bso32078195ad.2
        for <linux-crypto@vger.kernel.org>; Sat, 06 Jun 2026 13:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780779574; x=1781384374; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fdjzngtrv13KXGZ9M/pUsJxJulidxzwkCLaGZt9cbdM=;
        b=QrNpQvdlIVE3vlKzam55+X1wO0KwanVKu6r1Dk6MrUUwM61yrDUDA7hglE+hu5KxcL
         2RychWRXBgqZCgIMUNlPon+LE+eciPGWbe6xavAsfXq0jaNHgk8EUEAZaQDC2NtfX5hL
         HBG0dqrFMdtJeiV+3UcGuMTYQWROkiEpN+SMmusj8qZEmwkxE38nwekObGxrSVa1xYL6
         zP2ybUUyzirMPDCBcvbnyH65D8YOWLZaYxnAhLKIgFhSVV1nwjmVfz28uqxj4J9zRA/E
         TRvp8tdvIQnQpJqgfytHKGUN4aolD3zb3G76tBJTUIyZHFTYHqLDm/hM8whIJHYCJGS7
         NJ/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780779574; x=1781384374;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fdjzngtrv13KXGZ9M/pUsJxJulidxzwkCLaGZt9cbdM=;
        b=Ccpe9/52rXdtoQ6EvxDCwe5KS+HljZoG6iZy2/8nEWNeBTJvHoex89AjgCmLG1gVUm
         wyaBC0rQWfNSlxyaEXpKj5v37dYkM6zT2yzQJxnkIOYkm+tpNgSk9SdSkiP4li70XUCf
         eigxydy7WQQa/ujJYTqzhGJWtjeWQMCtdXkivj714LRCNX3MqWhqF1JtfQuCd777zn/e
         wtKCgzRHmjbIX76PrbCVMCkwkcqpKLO7xtuSyy7wfyOBIptC3rhOZzaMZLoAAzbXiXhe
         HqC5EjjDkkkvwxMwY3GstbwPFTIzsC7e4+iKsBMuhzHUjzdtW1uPlWZm/79PC8p/wyM0
         qIYA==
X-Forwarded-Encrypted: i=1; AFNElJ8iXtVWnSHsg4scF8B/E599nigeHaFVYZbGhGvkN0gH1fJQwm5PWT/cKL4FSzKMtY8dVdnTwlXmzzcXOqo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzt0lZki/b2ggpHXskD5FwG1GQMewEaXNUR/vveEMwpHIieflFj
	F4OfQOyHdH3BdFvtbqcu1zFM+LByotLC79QMiwusU6GvBhpA661q7H88afqpn4/TuKSOuv3TClg
	p1Y7TMFHEM8Da3dA4YF0b4tygnhDLHsKfsSy0zR5P85u7ePsjvqWp/oWzGdAXXexya4jfKMUjRJ
	s=
X-Gm-Gg: Acq92OFdUL3H/SY45BAqTShGI5fUMLcdZkZnj3tzhjaGywc6v/rlGCYnYZPt836YfXH
	UHNFLZMNoQ4U6HjD/znFL19wEoBPzJko5SWGC2okXNFlcfDgOJynkfMnbX7VgnlIHKeQaAxDV3Y
	CdbD6V8SemanRfkI5w/vhclWKUh+10bfBhUqb4Yj1G37FyOFETumS9Wn38D08gZoM+NdfbrGkBD
	a6Tg39nwiGqhTZyzAmc2lMT50x9odeytvuXQXDASixgGaj8HIxi/aBP+qloIHWTeN/8/JsMeX1B
	R3GUUVqr2PhNglKkSm4gdPlPwqCKf338DOecasj0eN15aDWoVy0O5vmRe1JYYrH1jKxtXFqoOwF
	3d5pP2NTHpsKPlQP4vfW5y3yBkY/EkdcTVN7uXrpivxcgLeISl8XzlsUMUFUPj2k=
X-Received: by 2002:a17:903:1245:b0:2c0:bcb3:86f with SMTP id d9443c01a7336-2c1e78e431dmr97381985ad.6.1780779573747;
        Sat, 06 Jun 2026 13:59:33 -0700 (PDT)
X-Received: by 2002:a17:903:1245:b0:2c0:bcb3:86f with SMTP id d9443c01a7336-2c1e78e431dmr97381835ad.6.1780779573318;
        Sat, 06 Jun 2026 13:59:33 -0700 (PDT)
Received: from [192.168.1.8] ([223.190.87.199])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c16609e627sm134635495ad.52.2026.06.06.13.59.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Jun 2026 13:59:32 -0700 (PDT)
Message-ID: <289a5bca-5491-4fc2-92d9-1102aa664021@oss.qualcomm.com>
Date: Sun, 7 Jun 2026 02:29:24 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] dt-bindings: dma: qcom,bam-dma: Increase iommus
 maxItems to seven
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Konrad Dybcio <konradybcio@kernel.org>, Frank Li <Frank.Li@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
References: <20260521-shikra_crypto_changse-v1-0-0154cc9cc0de@oss.qualcomm.com>
 <20260521-shikra_crypto_changse-v1-4-0154cc9cc0de@oss.qualcomm.com>
 <20260530-spiffy-glittering-quail-dff199@quoll>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260530-spiffy-glittering-quail-dff199@quoll>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: KM9UwN7C4bHwDw6Wvz2CTIbNNy8OpBm_
X-Proofpoint-GUID: KM9UwN7C4bHwDw6Wvz2CTIbNNy8OpBm_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA2MDIxNiBTYWx0ZWRfX+gUZpQlFAL1o
 uBu8viv4/M/92tu3e1Enk5+9ZApanU/26gUXqFHJNcgDQ+ob9UiyaDTAoW2KKHz8Jx/jnGO2o1J
 6bzOYQodj8hGan5Iw6aWPeomfV8VoviErARiXablGAFTw4oEnycjyzThzIvYIgSf93O3Bmyt3Iz
 eWNAtO9WMiGyyPvPXMOMvqrBYVjStxDMOvS/BCdslScjzfz8K46Lupx3hK4SLyBJMeTXJa1EqAL
 dkY56nivpEDQtgNmJw8sYovo0ojkNEQjrdQrwEOO7QZRldmWj3qnyqiH3qrh+b7r7lqF6vRfuoQ
 V72kzk3q/amrprwxvyCPm3iRpLOe6msEDLwbDQDk7gHKs5HSLyaSaUjtyqqmSjY1z4WOyJS3Ip9
 qb+zZegcNanGjdNXbi48AEkfImKEypcQ5j5iYx9tDYiPOoxN3DWt60unnvGOfxO8HNTLpQBxr4S
 1IBNOiDy8XvVTqgtZiQ==
X-Authority-Analysis: v=2.4 cv=TLh1jVla c=1 sm=1 tr=0 ts=6a248a36 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=hwwt4TTrG29xD97kRhuzDQ==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=UrYlmxekfit7Iro2dVEA:9 a=QEXdDO2ut3YA:10 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-06_05,2026-06-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 spamscore=0 adultscore=0 clxscore=1015
 phishscore=0 malwarescore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606060216

On 30-05-2026 16:09, Krzysztof Kozlowski wrote:
> On Thu, May 21, 2026 at 06:47:11PM +0530, Kuldeep Singh wrote:
>> Shikra bam dma engine support 7 iommu entries and not 6.
>> Increase maxItems property for iommus to pass dtbs_check errors.
> 
> What errors? There is no Shikra in upstream so how could we have errors?
dt-bindings updates are prerequisites for the DT changes of ice,rng, qce
and hence updated bindings in patch [1-4]/5.
Also, the commit message mention about shikra and DT change is also in
same series.

I hope this clarifies.

-- 
Regards
Kuldeep

