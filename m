Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359C819F42F
	for <linux-crypto@vger.kernel.org>; Fri, 20 Dec 2024 09:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734687978; cv=none; b=f8cRh9cI+qsGbp6hFkSkerh6bBByT6f+etxHIcuVv1LuVJ01DpOr1wOMbLAtRBZWAH3AgdSTkeRMmSLyK2C7yhgTyQ2gth69z7sHkk2yb6CcqjcTbwP73+3SMDlASjACuR6jJnbeeXT5vRFdkaZM1ARLDjKrUtgktcADu5dyRRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734687978; c=relaxed/simple;
	bh=XHHy09ydsqCogMppSGJ+Gt2u83nx58u4mpJvkQh0Qj4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BCv7cO5HtCZC7ZXT6KbO8j7nSk24JAgDFrv21a5Xj4Ows0cJICdUxr2BNvxnUSKZpXGBiGlRmX06REgPigLQuPJwD7pYp9gg7xq8+dvyAHsCH1JNKJda5wvNc4trNcM17pobWr7C1p2KyErXtMlkFZXstabA2u1uImEib5g8Kxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Dx58ElI4; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Dx58ElI4"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BK6mi3a027921
	for <linux-crypto@vger.kernel.org>; Fri, 20 Dec 2024 09:46:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	uu3beV9nqgRt6bygJC+dToUOYiThZQ4t4YOU0oZYnnQ=; b=Dx58ElI4/IVvGuiM
	/TCemoA9x4t7pKRLhMmdz+33m/1hNAl/3J4Gty/s1cX0pHVaDIo3voCxTcUImMrc
	QCZ2QPZTZM/8f6qRBwDbbOsRKVerPGDbdwQdoP64rF9A7eu/DlvoKsc0mOx34Xzq
	B4LV2q7NtsSPN1lPCFGfXCXcDF3WNnKP03TCF82+yjCt+kPZwZf6H4bL8GzCaoyH
	tytkG0H2T9WsA6XLZwpuIJAMpZJrvWn/1YeaIUbV1podSPWslNr0yIDlr1O2e4EO
	yUS499jWjcfGrcDFrIiHj3vJ3VzUf8RG8A6zhoQZpeCWGru4X0dqStnS9pEUaH8f
	yqHWhA==
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 43n3mxrfwm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 20 Dec 2024 09:46:15 +0000 (GMT)
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4679ef4565aso3102921cf.2
        for <linux-crypto@vger.kernel.org>; Fri, 20 Dec 2024 01:46:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734687975; x=1735292775;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uu3beV9nqgRt6bygJC+dToUOYiThZQ4t4YOU0oZYnnQ=;
        b=KqqWeOvaSALVb4bJ6pwvEgqq+oEEUDBmOAWekSsNmo1pGARu9WL529NBV1hX0zUE+A
         +a9qdcfsYjKLKPGIC3gjRXNngPMM/eUusrnfb0N4gPDsuQb1NI7xWoYiOM4PERM0GlpV
         jtEfTggX+NnBrWq0R6WPCYuYlWyN+qrU+EDEqDHW/xYoPljuCcY9E6uV+QPnfKjVuN3j
         8luW5I7J/uBS/MzIqaWP2fqXQt6zS5u9kHkMbFFnJFzAXvsVvUSvRNrelw8fxdYB2OM0
         beE2iFU2murTPWVauNovmpXLGNaGGDgT8HVE7C95RcRQnvbQQhkJLaNT0Zagiprh48oU
         SyBw==
X-Forwarded-Encrypted: i=1; AJvYcCUHqj26tfBlqDZ1PZ5F63TtDKkZc/QhGi2T5HXbmDnZXX8Y2RUU3OjVwSqB9E0iL2HRYLib91VXi9HPEF4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVoK2QcQPnY6RlO7m2OFSA5VGU0jx1+hun1u7vVKr2efsCMLT0
	tV0HR7ec75XndBfTMtL1VkOUMAJfNUdhtu7WSKKUyEQgMKqe1QeJNtn0FTpV1SgjVapPwdx91St
	Z4vPLowNOkAZWUOQqWDAHsopZDCnea9DhhLxvy1KtoCwmEXGyaUmd4GiYGylz128=
X-Gm-Gg: ASbGncsi5MsToO2YYCgseTGYi+ctZUGQPAywdIfoe1b0BRW6QWc8du1YLubawDJOuY+
	yqQyNa/caUS5f4BuBg5CJE9aqvvEGoInqL/+0jOfIBYUVu1jkjYx1bt+e0YH7VWWv5TPHlAGGql
	OQtSCa9aPTnvSeS3GzuEQDGiZZLWc1w8/uA1mi9YJrhy8018qpEnHdX4QcQw2CF/vqM9+EVRBJh
	DKp4WaVhzez245I65hVdK3H2ZvjP6M01rl8Wi0D/sGY9qZow4nz/km65hNLiqnUpfFcj3xPTn/k
	+w+3snYRz0tMQMNSFYVfjREpymCmGWTohG8=
X-Received: by 2002:a05:622a:14ce:b0:460:9026:6861 with SMTP id d75a77b69052e-46a4a8f9fa9mr10841351cf.9.1734687975102;
        Fri, 20 Dec 2024 01:46:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHr/MgWCLpFfmBCHnmU7oC+VsuVtB577PXhAqjgeyJSW6elrf+t820pkkN7X+Ky9ExDPpSwNw==
X-Received: by 2002:a05:622a:14ce:b0:460:9026:6861 with SMTP id d75a77b69052e-46a4a8f9fa9mr10841261cf.9.1734687974788;
        Fri, 20 Dec 2024 01:46:14 -0800 (PST)
Received: from [192.168.65.90] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0eae3a7bsm155719366b.83.2024.12.20.01.46.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2024 01:46:14 -0800 (PST)
Message-ID: <49cccc44-09d5-4756-aaa0-1c8cef473c82@oss.qualcomm.com>
Date: Fri, 20 Dec 2024 10:46:11 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] arm64: dts: qcom: ipq9574: update TRNG compatible
To: Md Sadre Alam <quic_mdalam@quicinc.com>, herbert@gondor.apana.org.au,
        davem@davemloft.net, robh@kernel.org, krzk+dt@kernel.org,
        conor+dt@kernel.org, andersson@kernel.org, konradybcio@kernel.org,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: quic_mmanikan@quicinc.com, quic_srichara@quicinc.com,
        quic_varada@quicinc.com
References: <20241220070036.3434658-1-quic_mdalam@quicinc.com>
 <20241220070036.3434658-4-quic_mdalam@quicinc.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20241220070036.3434658-4-quic_mdalam@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: 7P4PvqH52C3E9VrEMpuNpJ0vyC8WPvbJ
X-Proofpoint-ORIG-GUID: 7P4PvqH52C3E9VrEMpuNpJ0vyC8WPvbJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=675 mlxscore=0
 spamscore=0 suspectscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 clxscore=1015 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2412200080

On 20.12.2024 8:00 AM, Md Sadre Alam wrote:
> RNG hardware versions greater than 3.0 are Truly Random Number
> Generators (TRNG). In IPQ9574, the RNGblock is a TRNG.
> 
> This patch corrects the compatible property which correctly describes
> the hardware without making any functional changes
> 
> Signed-off-by: Md Sadre Alam <quic_mdalam@quicinc.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
