Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902EA28489B
	for <linux-crypto@vger.kernel.org>; Wed, 22 Oct 2025 17:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761153600; cv=none; b=gjn/T6jafX/1kaS3vGSiCr8YRoDHvDeDkFPdfUCDe3HljwihO6MhclAztGj2MZxHGJqRpBf2Nb2qb1y+zTjjyxNZFQM/jlVL41/atQpsuSr4O1ogwjGZZx3hyORO4NqG1uxP3MVevix9rhRYM/aUBu/7hDBWM3gCPl8p+WbOBeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761153600; c=relaxed/simple;
	bh=p5nAGxvrAUP5cnUmvYosqNhypEEgsoHxE6IFoeIxcbM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a2p5zKzlxGsRzHvtdFpZUEXSGwRqeNclNiB5DC5WorUVCjqwRHtRMmvZLsgASNG7H+px3nJ94mt8aoE9kels9O04JjmneeRvu8t8aWkfkzWQuzy//STzS/heP4M1u8U+D9GWIavTPGrvyNCGwrbFnTkGNJaH3P8kptKP4d9ZBkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Thifikf3; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Thifikf3"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59MA00C3000307
	for <linux-crypto@vger.kernel.org>; Wed, 22 Oct 2025 17:19:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	SUfkHbNbJjInMBUp59+fC5w+6y+9d0fh7BrDW/sPOT4=; b=Thifikf3LnJuWReu
	Oms09SqNSFn85KENiEgeyFlT7i/h4ffoZl8TTyenEG3/svCbOpuyoAcFS/Z7WjrC
	XkzihHx2j73/oxs/t229GgqgJvRtUsRk7dzOYPrdLcDm2WiwYGxrvNTynD26Mm00
	zOQp3mozMppiiz9p7Oxjy5gDk7fRMY2bra7mwUIoelplbkghJ/okSXMdvDirHh99
	+5bDJqa9yT4ZAkcSHuwVobSMpOSHUvei7uhwXTyxpLZpwyF/vUAXCAdK3+H04A08
	gS5yh0qG1CWv3uO+wcoPY5wMvdjZpR1wwV6dCC/Zks8brZoTLPJPudRK8RixwMbt
	AfHO4A==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49w08wb4sj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 22 Oct 2025 17:19:57 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4e887bef16aso4408701cf.3
        for <linux-crypto@vger.kernel.org>; Wed, 22 Oct 2025 10:19:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761153596; x=1761758396;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SUfkHbNbJjInMBUp59+fC5w+6y+9d0fh7BrDW/sPOT4=;
        b=XTfn0QZpo35LIF3EjpZu6u8nl5DdqdvUIMLugfaM94lDKE6AgaYxo4yFKSq5qDuW5k
         +nrtLihmeRFz9qHM24olsgkRuHemW9mM0AM0CgFT1sCFh9J3uhoN6I1f6KU3upAH5gXL
         QJEECARwDHejPeLe9/EHNsbLLR5F9Ah2gVB+Ya5oJUKxi9qHDdkH9C8qCw7lQn6y22EP
         I7Qe9iQAK60mH3v6UOeUM5IBqaxDEOzFPYj99glGoLuO4a0VdToPQy97JOQRxGXMOnPj
         UtT9G+VXgVuQp/sVQibNNQEL+UFRjO0OKrfvfiNm8j15dud/68u5Z1vKu226x58lwK6N
         0njg==
X-Forwarded-Encrypted: i=1; AJvYcCXwYT7eSZWOnJPrHDBgSoZIcgdsefZWN/zMmci7fg5Da9IOGGumDukRXRvFBwSaenXQYfegccPVkqa13WM=@vger.kernel.org
X-Gm-Message-State: AOJu0YycTK62eNeF0fo0pHpixWXxtujNOUE3vVEm+vI1M7XkcnCYY7aa
	GL6J1c4u2NJ6t9c53cIWNbXXCtKRlLAz4JjoWuTsYJXM94/wkuYEicxu35LqBSeOmuoR6Z5UZEk
	cAutT5HroF5zkXMkPTgU4InkcdIm7HymZMX0BRuz/wlcTTTTzvcf/VIfXO5UBV3czykE=
X-Gm-Gg: ASbGncvIyvg4YzBt42sHRZ7ajXSGqo/qia+kwyTMrb1lKbXbG/nbZEj9jWN7tQ9225N
	5cqVzibQYP6CVpIp8mwJ1+PpB9lUyXPJi4cGl8sL86Im5RlTYj7Q6YObQN99imKMV6uvjsNf2au
	o5ikDAQRiHRyE5VdSDJ6WW0dvLFUL7a7QTIRWxABTZiWE4KBTYwRvEvk16sXfmJrXpDQLZPNChE
	WXuXZtLT6qyNOovHFH8T4DI2zWUqjIdnxe2rqqjpvH3QO6yBfPUfAguP0rrcsl8Mcmclv2KUavo
	A1uJrP/YtiE1Y6WcYLlSCh+x3GAOlzlGqVjnLHHKn7pvgNOj3VOoP4oSuTK3OKnFcQ9gFJKKVq1
	SyB1MzB+DaVYmxm+FMuc7DWPMFyvPPIIrJ7y95QskqWtmzpHEMTaNmKdc
X-Received: by 2002:ac8:7c49:0:b0:4b5:f521:30f7 with SMTP id d75a77b69052e-4ea116abda8mr69680011cf.4.1761153596332;
        Wed, 22 Oct 2025 10:19:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFoDqiu6KupAbR/QDMwKjaiqJhOG1EKNGUxTwxB/cS9oa2UhBHiyfq+I4SkjnmLz6AmKkPWeQ==
X-Received: by 2002:ac8:7c49:0:b0:4b5:f521:30f7 with SMTP id d75a77b69052e-4ea116abda8mr69679481cf.4.1761153595715;
        Wed, 22 Oct 2025 10:19:55 -0700 (PDT)
Received: from [192.168.119.202] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b65eb526490sm1376226466b.65.2025.10.22.10.19.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 10:19:55 -0700 (PDT)
Message-ID: <6235f1f0-6ae7-43b5-a881-d5bb7d8bb8b4@oss.qualcomm.com>
Date: Wed, 22 Oct 2025 19:19:52 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] dts: qcom: qcs615-ride: Enable ice ufs and emmc
To: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
References: <20251009-add-separate-ice-ufs-and-emmc-device-nodes-for-qcs615-platform-v1-0-2a34d8d03c72@oss.qualcomm.com>
 <20251009-add-separate-ice-ufs-and-emmc-device-nodes-for-qcs615-platform-v1-5-2a34d8d03c72@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20251009-add-separate-ice-ufs-and-emmc-device-nodes-for-qcs615-platform-v1-5-2a34d8d03c72@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: BTNGrh9cQQPIadSn8Jzyli2U4DywzTvy
X-Proofpoint-GUID: BTNGrh9cQQPIadSn8Jzyli2U4DywzTvy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE5MDA5MCBTYWx0ZWRfXy7UmVw3Mwgnv
 l58YAQIycBmjFJvtLhHuqTJ4tXgfcdojPJ5bD5im3s8RNhAP6CFgfjPdQn3jSExxSDEjPEbOS5D
 7nOa5DmO9XEpE4Dh2nkXFaqRRJH8WYA2t8TJcJe051DdTkCNvsqPpdl04Jnk/b5+8/V5wMRqasc
 KaEt4bqLQBgpXOD4WG05J1lwjiKfR8g8Zdne1pfPzPTLQ5Km5kcaDmo47TqmqYT7mQoqjQSNdoq
 d+qnttABMyT15YqtZXTjSsdTvKa5+xlaR7aysWqN1B6SpbjZoWn+pS9c6z/0bxyalwr3bBl3xlK
 VePRwYgBLf47pVAnnM9cD6WQnglY26dfHeM9+BoxzZ8KIVFcts/9CemwPJhFOzkHopve9hOM5MW
 CAUqI0VUJU35sB8ewKw9XCIxwCNkSw==
X-Authority-Analysis: v=2.4 cv=V5NwEOni c=1 sm=1 tr=0 ts=68f9123d cx=c_pps
 a=WeENfcodrlLV9YRTxbY/uA==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EUspDBNiAAAA:8 a=67M-hd6uxsQcvR6J9HkA:9 a=QEXdDO2ut3YA:10
 a=kacYvNCVWA4VmyqE58fU:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_07,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 suspectscore=0 clxscore=1015 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510190090

On 10/9/25 8:18 AM, Abhinaba Rakshit wrote:
> Enable ICE UFS and eMMC for QCS615-ride platform.
> 
> Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
> ---

Is there a reason to disable them in the first place?

Konrad 
