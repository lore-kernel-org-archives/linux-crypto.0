Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176C946D080
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 18:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657796; cv=none; b=My4VCgpmUTFeteat52O17Tgkb+Q9v0+VX4bLduP45v56S0Wib0gimXswfFCIHVpswRNt+1zTrn/DiiGvFWba6xUSdGTRsUeZpEV+iUgedIy0gHvdB9J+Cc9e+wm2rSBqvHrH+ORzYn9XJpozzLJH2McjKhhZNez5W3hVmXRrJAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657796; c=relaxed/simple;
	bh=MmlXlxhp9jw6V64J1P8Fgez6/QyKKCBLRfu34RXe5Ek=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y79hbvjaWAub6MoGcNsumKRfqz5Azp7TC0ry4qY7c/sOWPfnHeTlKiDJDkZDhxgUJx2IC30/AiMYCjyz/0jeCzrCoPrdZsMsSGp+1+4aW/PGf5JegmnuIpRcfkRNau2FGhZJktPOASHBoxi+Jgud6subgZcx+yW4NglABNu7kKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=H1suFNFx; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=fk19x53h; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="H1suFNFx";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="fk19x53h"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66LH2dlc2280173
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 18:16:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	pxHJZKOUJ+mwEArxOGlqaPjUgMrI0m93hIaUp+NfhUE=; b=H1suFNFxOBwIeGth
	OA8vRhizIXFBG4CAe1KjeDlL7ay/+2XMOOc0F7TEF8C7Eqma16aRP5EBvZPitNxZ
	sNBI0PXkyhhpB94gUV+lE2bcEUeW4KzGPQqqUbuho5CiMErC7770aACl9taRh0I6
	X/JqfsjO7i3eUeghy84mlZ9nazJmN82A1rfMAtbxriyh5tYvYgMyBUNxE+VfaOjI
	j5IfcThdptWyZaxM5I92+8KGknTHRfOmp0L5mHc3K5W0ksIzFNa1kHCOn/KpBDrH
	WbV1xrc2wcb8xzURaa+SWghP23Msj57Twv3SPSd7k+FMMuLz699o1p5VyZls/Hex
	bHK3mQ==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fj6paabkp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 18:16:33 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cb733fc5024so3830507a12.2
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 11:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784657793; x=1785262593; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pxHJZKOUJ+mwEArxOGlqaPjUgMrI0m93hIaUp+NfhUE=;
        b=fk19x53hOa3r4MaWBiK3/lBFNJUPrpuXnQPefXGqQn+8hz83IIMZK/MRz7lf0uJQYY
         sU4C0LySNOeTgYpeV4ONkm+Z4dJpPFAqJO1mkWgp/H4+l39U6JJFo6uGPjdur5BBYbyu
         0yxg/myTSlsWJqIlJH1FesohF3l4523lujFtTQT0njzBxBACux+g1zvanZ2TzwPM6R3d
         3puH6t7YMbnkxdIPbk46ayoxIYKdQ6SCO9k0bB44OVRcvZTb5qmOCluM0HxbOyBSWyIe
         lLHd0Tp/b0eF+XT6cVVXylbHptOd7GBnnvh8R3KWc9+1zP68nVLVeZj4jP3+f19S4zvV
         MRdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784657793; x=1785262593;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pxHJZKOUJ+mwEArxOGlqaPjUgMrI0m93hIaUp+NfhUE=;
        b=qQObACZ9HbMvqN2xJlvcjLjTaEIL5su2hGYPiB9tTaTB9EWYi6Sj/k8ktb7LV2neQr
         /kCyhSMTOeufamTn5SYIAA0jjyVW2XgUq0K6WwBh1jWbJ4uZft/eXOamluWu416QJCaV
         NYxmpReSzKV37ViDRuyH4mLrElJN5w6GHC9kcfHueQVLI/CIsMjvr38h34vlC0kkwffj
         hFCppOXzhQj90F3HOU9eno38IUp9mOEgVnpQ7Szqe1F2fLR/oDV2vgEkqPsqd4JchD5Z
         TOaPOt+bABLzDL2ZKa210WripC6hlyfeVWoRfpxDJDcb+wZ0G6pUX82hCsnlvChoQTgw
         3LFQ==
X-Forwarded-Encrypted: i=1; AHgh+RpF0i9AqJpl4PZOCGwwGHyb6hRRoT31BS0Ln9oD7GL5ou+JZF+N9CoGtJcK1cxSiSakal8K9DEwASO0G3o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxr8qEqYLQTGfHTdwIwLLEvQ93HFBdK1hta5XQ6KxbBtlyHKPDZ
	QGb0iaiVqyA+3YSa6QlEBRTJsy+OoIiC821ZQgTMGWK+sInQZS6blZ+Xhq9xxKnOzjUnI0jPY7I
	HoJ5dlkkkkuYZLaZPQVYPQNySVH8VqinWbP1L6BRuPP0HbOnijPw2k2FRP0XuZexTo+8=
X-Gm-Gg: AR+sD10aFvrcOp7QgFDbZlGfQKDRb+SYjOy7mUJKS4jBnSPu5VOXfk7X9pZQDVLlhWA
	weMT7kONWNOq/zL9JlZCn5roYT0SNYuS3L8qPICSY/c4X2SQg5mPajNhVccuV5l6vLCD2KMsIVc
	Q9GozRUcxLm7/etHdwe4xFTYLRa0OQAMTZr3B10llFR25P50Yr+XbUJ59qOuJD0+TsJAsXlGUAU
	BJQTmDmHwkiM8gfIT65LDrG/p8fH+kkhUx0Ynf05ieMWvc64kyubq+Rk03irS5BkG9TarCh31Iy
	kDYJ9ZUUpssykKNMpGSAlbK4yn6pAqckeEA1/YM8nJvHzyFjKXBq5VZTrR3caTHDE9FYDhZQVoW
	39IIhGhftJl5I4lmRkIqlQa2S7i8VjjwI2fA=
X-Received: by 2002:a05:6a21:a382:b0:3bf:96c6:78a9 with SMTP id adf61e73a8af0-3c3ad665b3fmr20297988637.2.1784657792865;
        Tue, 21 Jul 2026 11:16:32 -0700 (PDT)
X-Received: by 2002:a05:6a21:a382:b0:3bf:96c6:78a9 with SMTP id adf61e73a8af0-3c3ad665b3fmr20297943637.2.1784657792331;
        Tue, 21 Jul 2026 11:16:32 -0700 (PDT)
Received: from [192.168.1.8] ([106.222.235.145])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147e081985sm1059348eec.23.2026.07.21.11.16.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 11:16:31 -0700 (PDT)
Message-ID: <ebf99b7a-8da5-4974-ab7f-fe26e331b982@oss.qualcomm.com>
Date: Tue, 21 Jul 2026 23:46:22 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v23 11/14] crypto: qce - Use existing devres APIs in
 devm_qce_dma_request()
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Udit Tiwari <quic_utiwari@quicinc.com>,
        Md Sadre Alam <mdalam@qti.qualcomm.com>,
        Dmitry Baryshkov
 <lumag@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Stephan Gerhold <stephan.gerhold@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Michal Simek <michal.simek@amd.com>, Frank Li <Frank.Li@kernel.org>,
        Andy Gross <agross@codeaurora.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        brgl@kernel.org, Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
References: <20260721-qcom-qce-cmd-descr-v23-0-1be02deffda9@oss.qualcomm.com>
 <20260721-qcom-qce-cmd-descr-v23-11-1be02deffda9@oss.qualcomm.com>
Content-Language: en-US
From: Mukesh Savaliya <mukesh.savaliya@oss.qualcomm.com>
In-Reply-To: <20260721-qcom-qce-cmd-descr-v23-11-1be02deffda9@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: l9rX0ePaBwIMqVowH_NKtGWVy5gswyYj
X-Proofpoint-ORIG-GUID: l9rX0ePaBwIMqVowH_NKtGWVy5gswyYj
X-Authority-Analysis: v=2.4 cv=eYYNubEH c=1 sm=1 tr=0 ts=6a5fb781 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=nYgDJefOb7ZtON2RxEtQrg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=Kkr9414Gf28UH8S5ubQA:9
 a=QEXdDO2ut3YA:10 a=_Vgx9l1VpLgwpw_dHYaR:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDE5MSBTYWx0ZWRfX2EAXGLtibObq
 ZFWn761xcgOU2O60F3kY/d1JFt54SLpJJjJNX1/4HtzGvMnhCDimtio+DI1p9L2pa6sXoTZVKpA
 agP5gQCMT9kLUwUyUjEm3Uyi6y+he6E3/1+X9qNgdIWPo/ymfjOjDEXwPVcclPX1rvOcbdchqIo
 2Kl5ishT0bqQKs51C12OZX2+ttjS9B37WntTGD2NE1NPHczxJq41CNyL9i85ZNQJRjk0JWyl52u
 mW51vs1P4oMzcHqaw2KTEnwm6cfkhXWDEmESGn4bEZ96BlQ3CCAwhiYdv8CySVGW4YCYLAQyxXv
 1K7qqU8tt+x1/gs//xaB3y/D7652tCuEpFflUxRxkRikPNxdEHkASone/y4INI5SFUry0SIZ+rE
 aqNnQAzZWJEuUC4cGNe246ArtO5eoHt7xLb64oXkAe67HOdQtRz1hQX9MsKAK77CzorBgSX0Xem
 7RYYeeJw5ghW75OktJQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDE5MSBTYWx0ZWRfX6k9QsEXnnPMI
 SX8vaQMCt8FygldcUggE4TAnYtSyC2zVU/Z5j4zwO+I1dLwswRaJQzH42ZVQiYmtRtO4UrcRgqP
 JGUKAGXy1Ww4r6Fa+NxCFDFFLIqw2Hk=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-21_03,2026-07-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 lowpriorityscore=0 malwarescore=0 priorityscore=1501
 spamscore=0 bulkscore=0 impostorscore=0 phishscore=0 adultscore=0
 clxscore=1011 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607210191



On 7/21/2026 7:03 PM, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> Switch to devm_kmalloc() and devm_dma_alloc_chan() in
> devm_qce_dma_request(). This allows us to drop two labels and shrink the
> function.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> ---

Acked-by: Mukesh Kumar Savaliya <mukesh.savaliya@oss.qualcomm.com>


