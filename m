Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77492320F
	for <linux-crypto@vger.kernel.org>; Tue, 11 Feb 2025 13:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739280116; cv=none; b=hg077xp6RLNj6swkGvmr6xqPdlhVjcjFDU9JekMYoQoZ4ERpqZ4sYE81GeY2JpbYZVTUU6Bza3O/s8U+OXJhlxkhWcMtSagjHhEY8cEVGFJiYvBimzxpUQA+qqaPASTDBiDhSA6GeXi7rpPHGrrpqoSY/VdZ1qjDBWxGAUC+sMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739280116; c=relaxed/simple;
	bh=7EBzLd/MkkAQO/2gIs3RgMZYWCN0hifel1hX00qZrX0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ln4k4Nf7auFTWR+IvwSv+c93meTSWwuH0HaJCHZ/tqCIQT0ykqAm+KpB7wjZvi65UAfmBDIRnHaezrm52KD6MupCTgAxvy5F5NS+meXNuKqzFy4ONwxEeNmYzJ9Kf/1H20d6xzIis2S2C1K4XQYFNnqhXAVWY+T8gcvDj+iWQKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TQ4lQdem; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TQ4lQdem"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51BBA8cH000863
	for <linux-crypto@vger.kernel.org>; Tue, 11 Feb 2025 13:21:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	WxaAP2OfJQcefUPkd/AkugD6llbStw6Nvz+c51lPgbo=; b=TQ4lQdemhNvxlgq2
	XeHBvjp7cWkPU71K165PmuaP/MupUpjICDswGQAaxophv32VBKQQm/wMs1zW7J4g
	nLsNkkz8dXrA59l+2KM6w4/BYqafJkqh9PRzP5mjqc8INvndb9ytXWBrAP2GBRie
	DQ1yTqAezUDA4h1zCqpeu6Tg38dtKxNu7B/CekTAMb5pDg2vM9eTz7fy9Ok5tdnl
	ljgJDciZLsuCB6+daXRR9M8iUpc2P29t8e+SXdJHDh0Ngi7Z1sWFEhlPCz6tjS65
	5NeTt8A56w6OflbCArJPCQWpVjmFnneAaRnA8t+EOaUWyXNrZzru3g879zgRg6cw
	yWkksw==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 44qgtk3rwk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 11 Feb 2025 13:21:54 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7c060bcafebso30310285a.3
        for <linux-crypto@vger.kernel.org>; Tue, 11 Feb 2025 05:21:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739280113; x=1739884913;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WxaAP2OfJQcefUPkd/AkugD6llbStw6Nvz+c51lPgbo=;
        b=DkdEIQ8reGpDRIP8XrBGC8JP1Dd6+LGgOm+8JUXRFQdM4OJ3B9WinkB7St9FEoy4MC
         zFY/MDTYLmeGaw4oIiVuj2LdpGqhw5LRvsTPSOoTJOwrD6BcbjOvu2HZ2mGqIQEa8uie
         HRkCAl2QpL7CcL4CiQdhXNV0SzJ+sWsUxI2gZUSgG56plRRjSkzP6QsrZ0w+lKxhPFyr
         WrqBZBLvWdOZxB3sg977sOwyNet5UxC3XZhNxsuolT3qZJ8EqgzXv5CHjUNLKDvWEY49
         Sbef4oLOZ0z4iliSJslguDV0r/tDkQW79z1s3GtYMRKN2zmVRkrExtpwV2LFkraCyvxq
         Z6Iw==
X-Gm-Message-State: AOJu0YwqEhyIkNii3AEK6c1sCzTtrORfHzHhzhr6Gq2XNjhb980rm5Ss
	H+hN0tUdK4Yvya1nBlPGceqqs1wfkZxKQaZWrQ3Cg6SCJo13AAU+TdkdaxspjxRI3WY1VqYiesb
	VqYcV6v6JS62SkktTRZq3+CUOjt818XZYoc3pisxPEs3CmIayiu/H6wnY5uvg8WU=
X-Gm-Gg: ASbGnctU71XonvzZ94r50G1YHfEfCa8Kav59D2zyYcRFtvV89sP2rQLu0Lvp4zx1HAu
	BsS0TchejsHXPJE7krN+2uce+UGeTwmRzrfxV8TZBkpNA9S6Y1jfo1d5JvYwDHbMUZG2U3+SDMk
	FTTESkGod1oq6BrxK1GHHomrDGc0yRZnH7BJzopWT9mjRu01Rc/jrG5I76uMlx8+eOYyjoxNsKi
	xvL3kxZ4k2YOl4McG1iDPiBxRlDC90FS0DjOLu0JsSRCzbTcA3Zl5eqLM2tEekzukUTtId5j2M6
	i/SK/En9Nv0GwN/UlZxObwkyKkWOkHCGB/Y6l/4ITmhIS+FnxjKbTJMsFfo=
X-Received: by 2002:a05:620a:1a28:b0:7b6:c3ad:6cc4 with SMTP id af79cd13be357-7c069cf37c0mr143517585a.5.1739280113517;
        Tue, 11 Feb 2025 05:21:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE0dqsw15wKwS/BY+L64XWNIZkK61jXi1TTzfL+uXdnejS6AhoibNvrqpmqVJiiO/CfpHiYiw==
X-Received: by 2002:a05:620a:1a28:b0:7b6:c3ad:6cc4 with SMTP id af79cd13be357-7c069cf37c0mr143514985a.5.1739280113155;
        Tue, 11 Feb 2025 05:21:53 -0800 (PST)
Received: from [192.168.65.90] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dcf1b7adc4sm9578260a12.19.2025.02.11.05.21.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2025 05:21:51 -0800 (PST)
Message-ID: <59592224-7e99-4eba-b41d-7bfa6b1695cb@oss.qualcomm.com>
Date: Tue, 11 Feb 2025 14:21:49 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] arm64: dts: qcom: sm8750: Add ICE nodes
To: Melody Olvera <quic_molvera@quicinc.com>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Satya Durga Srinivasu Prabhala <quic_satyap@quicinc.com>,
        Trilok Soni <quic_tsoni@quicinc.com>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>
References: <20250113-sm8750_crypto_master-v1-0-d8e265729848@quicinc.com>
 <20250113-sm8750_crypto_master-v1-6-d8e265729848@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20250113-sm8750_crypto_master-v1-6-d8e265729848@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: ZARe8ODYCibQ1NcYIHX7D1toDSJCXKJK
X-Proofpoint-ORIG-GUID: ZARe8ODYCibQ1NcYIHX7D1toDSJCXKJK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-11_05,2025-02-11_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 suspectscore=0 phishscore=0 impostorscore=0
 adultscore=0 clxscore=1015 mlxscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=739 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2501170000 definitions=main-2502110088

On 13.01.2025 10:16 PM, Melody Olvera wrote:
> From: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> 
> Add the SM8750 nodes for the UFS Inline Crypto Engine (ICE).
> 
> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> Signed-off-by: Melody Olvera <quic_molvera@quicinc.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
