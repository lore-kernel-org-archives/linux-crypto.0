Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9422D1916
	for <linux-crypto@vger.kernel.org>; Thu, 25 Sep 2025 11:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758800946; cv=none; b=Pv60GlElMNMN7jQXP5eHkjoxknZ/uRKrkssClxW+VNgqwWElqRut/akwrGMVEo4PJZP3m+MPTAJb9Z5u5Qlmxaj3VKuHP5F8nLHpM5bLFrDx4VB+F/KG1ktSXMBIUS+3vkYkzMF4mBTcvtI1Q4BWz8DydiR7OrRSfkX18uq+lLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758800946; c=relaxed/simple;
	bh=toxgSbOuMYd0l1zBSSHDfmkI9Q5eCWB7QxXd6A9cDi0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=atI4gZFITAYVX1+F7L6wReFYu9xmTF22uiecgrhq/mKnAacPGTI2MaxeYuM/mR/jxiUMSP20zJ4VukaaLYyg526q73HPZKnv8Thqw6btFvH9k49Dzo0Af3RAVz3xlXrwr/UyUEp0WsgOv5vYfBWFJw/uVQ+uRuSoqJ1L5fZYrZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mOIzC4YF; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mOIzC4YF"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58P9xfEs029565
	for <linux-crypto@vger.kernel.org>; Thu, 25 Sep 2025 11:49:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	nX/7+Es5CEXVgmPLU51KFWh1W5gFD+wvMunPIFeNs98=; b=mOIzC4YF+zV4gcYV
	DVX2M16FN1bj/oQfzLXzFrje37j2ogmMyB9d4Ols67RKZOTJ6WdzGxVyyTiHHL27
	N2TpLQWURenH+h1Q1Pv2+xoWYZ+VTZEBuUtRaMVmBmKsyqB+OHa96CXOt8w3MF9N
	aR9dpanx+JpxN5TzuMa5Cd//D7gHlYpS1kW7aQWEwsPX8N1coiG9yUEZpN7kpuvW
	WqGUM26PdwDavOH+FRNtewWGg67tWfNQPP3M0z/taVCJBf9V0gKgKE/L/LaK2UMn
	alZE+bwczoVPCgDZo1GLvGRz94vFOB4b2TdWiUFNsEXW3W7qgDOY9oBi/3zldFIj
	nKqAbw==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 499n1fqtuj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 25 Sep 2025 11:49:04 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4d88b669938so1866951cf.2
        for <linux-crypto@vger.kernel.org>; Thu, 25 Sep 2025 04:49:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758800943; x=1759405743;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nX/7+Es5CEXVgmPLU51KFWh1W5gFD+wvMunPIFeNs98=;
        b=OwDZoP73Ie8DW9wRhHHO1ZbuAKx5WHoKHJweYXF6QK7yyPg1wNuM8GwmlXsLepXcUf
         uK4P/yIkzNIL+fkLiza87BizW3kd0TEPEIz3gjj74rwReMurwR5FqsFXcSnfafoBa6cG
         mwM0RR1zRRZcawTMwWFiOGG/4/18WKNy6T5H4Wyl0s0iSTgA+yPhkOWpvSJJAVOEv8iO
         NZ7eMSMtSFk2W5Stm3oGgNmdDaCH9aTiblF9jR4K0pTSj7C81EnKLvet1ycY4WvgLIsE
         2KEyM9GHkRfhJCYjIm01qwM3ctjQmJjf3yFoQ3I5evZlBsLaRPgX4dgw1x5AoQHRiVFU
         0n1w==
X-Forwarded-Encrypted: i=1; AJvYcCW2YFoChV3R65xykJN7lhU4gqffRjYq4OA1hqPhsGR45M+/EfoFG86SOMGQkTwXEUV10S8YqMABE7H2unM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxddiiap6BenXjv3WKgnO04vU6Hd2FC/lGAjyCRmyEoiQc9Rn6T
	9MzdB8MZfZ/ySGoASM/5UeL43/sCeCfNcu+wCe2poMFe9Yh4lSpfzWoyLIcyjNOQIOPyjWeok2F
	AkPbR090zA86JcCw0SuUXFT5E9Pg0k9kY8zFrCaDZxv+CgRUpP7qskpkose+7PuzJ68k=
X-Gm-Gg: ASbGncuJWmwYu2XFgux3UK6k9vNvzRk04eiODV2eGiYGuhH1dzcJpefsixC2dLYpN7e
	5kH6BJrEbHqijZnz2siR+amuazxOSd5jRjqmBbVYesc6FnPw4msmTTC9M4EZwKHG73zDJAQXkcq
	C3rmJLSApZWHWbwR/T/RcQEHd1EmVCNCCJ5n7kkML1Dpw+EYspw2w9CDOvuRGW5J+llBzWBrRGe
	BWcZjBB0t7ZNvSqj0LL1IIQxz6/596MpOJqNG4vK0fEGXBB6uY6VPGeTZ4Y20PH+yx77/ahlIEq
	M/ffwkyBUrDF9r75re1HIVqOjZiFtDb0PVw1O2B4idTpkuq9zmCcBBYXIYrXznj4E4PaSbbBRDt
	zCeUwnC31cyC981V654+Mjw==
X-Received: by 2002:a05:622a:1988:b0:4d9:7eeb:3f76 with SMTP id d75a77b69052e-4da4b42881bmr27497481cf.8.1758800943226;
        Thu, 25 Sep 2025 04:49:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGVDTxNrr1MXCU1YXwmH3hI/4HBUQONc/+oEm+jljQypOdh5NlhLYUBxtFh9nstaa+aDjP86A==
X-Received: by 2002:a05:622a:1988:b0:4d9:7eeb:3f76 with SMTP id d75a77b69052e-4da4b42881bmr27497281cf.8.1758800942641;
        Thu, 25 Sep 2025 04:49:02 -0700 (PDT)
Received: from [192.168.149.223] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b353e5d155asm159172266b.6.2025.09.25.04.48.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 04:49:02 -0700 (PDT)
Message-ID: <39f6f7af-4b0a-496f-9391-880932634551@oss.qualcomm.com>
Date: Thu, 25 Sep 2025 13:48:58 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] crypto: qce: add support for QCE major version 6
To: Jingyi Wang <jingyi.wang@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        aiqun.yu@oss.qualcomm.com, tingwei.zhang@oss.qualcomm.com,
        trilok.soni@oss.qualcomm.com, yijie.yang@oss.qualcomm.com,
        Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>
References: <20250924-knp-crypto-v1-0-49af17a231b7@oss.qualcomm.com>
 <20250924-knp-crypto-v1-3-49af17a231b7@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20250924-knp-crypto-v1-3-49af17a231b7@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: 7j5ZQV-HhO66M-Ue0LTCKmGHEgTJEQu9
X-Proofpoint-GUID: 7j5ZQV-HhO66M-Ue0LTCKmGHEgTJEQu9
X-Authority-Analysis: v=2.4 cv=No/Rc9dJ c=1 sm=1 tr=0 ts=68d52c30 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=EUspDBNiAAAA:8 a=um4aV7xw4E9mcPOvuVgA:9
 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAzNyBTYWx0ZWRfX1AiL99NIRIG0
 0kcdGxnJoXM7Efi/LJ9v/r6sSH++Yt8yBtvLSX55irmJlneDbmTjd2OigLdeNmyQc1QNELMvyEW
 hAYtitImyRdtdw5JuV/adj6jF3hHoQBYiszY2L00XVFedtydak+VgyEsMTn++aFnogh1a6anrQk
 T54vFifQH+UXYlUH8XVWPMKfp4/F3zTLfQJgwe81gzjlY8Hb+zsR7d8N6pYm1QBPWHQhsDHIQfN
 7bh3dvF3H+7cK/VlGP62UnP686X5zEwQyy6JKoc7oTF5okxtOW4fZ5IUhvtm6t+oTh0M53zEEIj
 LwvTwSBDLjcldogFf2aJ8stX7SZiG9eX8WTvcyLBoXnqQ+ooaKTD1hrc+oapLFJ9TPGp3yx13JE
 Lwhxjk7t
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-25_01,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 spamscore=0 suspectscore=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509200037

On 9/25/25 1:38 AM, Jingyi Wang wrote:
> From: Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>
> 
> The Qualcomm General Purpose Crypto Engine (GPCE) has
> upgraded to version 6 on newer socs, this makes the
> version check logic obsolete and needs to be updated
> to account for v6.0.
> 
> As part of this, unnecessary version macros has also
> been removed.
> 
> Signed-off-by: Gaurav Kashyap <gaurav.kashyap@oss.qualcomm.com>
> Signed-off-by: Jingyi Wang <jingyi.wang@oss.qualcomm.com>
> ---

This commit message does not reflect what the code does (or at
least it does so very indirectly)

You can instead title the commit message "fix version check" and
mention in the commit text that this is necessary e.g. for v6

Konrad
