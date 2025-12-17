Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247EE335572
	for <linux-crypto@vger.kernel.org>; Wed, 17 Dec 2025 12:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765973566; cv=none; b=lI7/MttT2/k11VoDEu8jDDrKuFDyCumSEInDa6db6quynwS6v7/BhcpfL8MmmQf6NkMjEx+xL2e/YfboFXaitJUOQHGbkDUqpgd15KFuon6HQqYfgf8K2jtizVUy4LPi+wRxA8sEdxHd6uSusw/GMNa7PoteBrTCh25bHVi5gXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765973566; c=relaxed/simple;
	bh=aGe86kWkfD3nvG8oBci9toKNq0ktbkQOHU4AB26yg7w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oZEPrLbdvW9voFCucvDOITX6q7i6gk40IEkhVpHwHvfofp5kuCAIYlS9kO+MXe4XOW7uX0zcujEH442/IOcCoVSdBhSQA2qqfC+3Bhmja7qjNNg3qB/4YE1Kf+U9DLEcNe4v51PIByLHkzPVHJxWxOyqoZKBaHz/9s/SFrt6tps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=oTcWSqkb; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RHmgNxJT; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="oTcWSqkb";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RHmgNxJT"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BHCCbgc2484056
	for <linux-crypto@vger.kernel.org>; Wed, 17 Dec 2025 12:12:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	S5xgaoTT69/pBHPgbjFkA4EHKqWZuC60C9uOsst3bQ8=; b=oTcWSqkbsxGmFqcV
	DKUxPRuWDotNrXy9NN6FyIIqTPEINRlgdnyMVT44Lym0NS6udIUyMLxX2o7ECUbX
	3fXFEXkPE/1XsfXGA/W0F9sMfVgzACEaXtqLYMpgtYnMPXuQu4F6jK6RzDRK22C7
	GH6tQ+zpdBdKmJ68+al2GmL2nUXHI7pY5kwGVhXLYFtMVeMKXRuNM/DF9EZdwrxW
	XHrKoLGJpQ77NTWLNhKK0ZBFwQ09lgVw31bWwSU+UnahwQMWzAM7b+ZfE6CgTZ8J
	dIUQixMoNwmkWqJmuTzAeMS4p6kI9b7ru4UMb0c9ecdF4E89pkajgDuVeF43gw/w
	YPaV2A==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4b3rqa8san-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 17 Dec 2025 12:12:44 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4f34c24e2cbso3768041cf.3
        for <linux-crypto@vger.kernel.org>; Wed, 17 Dec 2025 04:12:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1765973563; x=1766578363; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S5xgaoTT69/pBHPgbjFkA4EHKqWZuC60C9uOsst3bQ8=;
        b=RHmgNxJTarPRp59DQ+JI7cNReInQ3PJY80o32rUMHnFJJ3Tjhln6+RdBtLR34x3p9j
         x8uXg88KJqWpWq9wZcbRli/hzQS6k9aG1n77vndm8goznRv1hhkjt3tndgoUlETKRSLj
         syz6W1UwJulL/D+gmamAAdkWjnbnLrlXSe9mh0j0JaWswX8VuzBOp+UBARsqiDgS3CV7
         W2OnBZ5z2maGo0WThLLg0n/aq3kAI0DmiURs6t76NX9/EZckK4dQ0JB+ea45acpeDrr/
         ofe+GuJ5pQoURGziZ+sH6bKVYqyPwuMJtW/wxGaCoSSy3mMyKZB4No6rxoGrNIOTweX3
         KgpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765973563; x=1766578363;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S5xgaoTT69/pBHPgbjFkA4EHKqWZuC60C9uOsst3bQ8=;
        b=dlYyu4CGHRHxgmltog5xGXpsxWoTo7uyRh3e3Czz5EKQeVfpFJQcDfTewq9oqDQ4BN
         SgxJqY/u7z4hL82RV+9HSkDad88DQybni8hEK5csxrrSbRkgMFp+94qPanZnmghQ9AMr
         P/buf4TfkoaFaSAvU6P+UpcIkTa+GU3GQoFhTfwdbqfZwDx5nYLAG7wqS+HzAgz1TSsC
         otwMPGYyaaL8OT5B0TjU2cF/ofBTrMsXxeF2THvC3rFop31z6sKH7YsKG5TS7k/Gu87+
         5vcTTnoIvHkQdrvGQhb7p3n5MO6CnSYimgaeCiI/XCXpXkO2uapoMhwTdXcajOQZgiPF
         loYw==
X-Forwarded-Encrypted: i=1; AJvYcCVpay8FzNdUIlBM30ASnlODUYbUV0775YCY2ORPnCMk3kksvqUni82DwWqC9SqvQPI0pn7ocKpcl91n+e0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOpcCrzlAc5sc/EQsvAIj6U/u4ZiMHoJq8fPnujnZiP1uKBl1X
	mvMHXIyyvE9ZDtJK6uu8wS7M4xm+qVxWGcligNwuKoObEXqisMN0Vb9sFgMrWjv48Sh6/oAKHTW
	yOoatK9qdm7qOhrOQ/LJgbcSFcTulepJ2UE0Gxk7dfJpWTdsmj9GS+6vrCoGLThxC7gY=
X-Gm-Gg: AY/fxX52BO3kXwkSdFZhVpT9LlUx2ouxjk6Y9Z0r2dO47Ug1YwXBT0rVZT91o1deXUl
	9ItcaMkQk1A1iIBsyJRXDpBlnwSiAKBpQ9kwrs/bU+IrxLW0r2DBkL9mEG0nbWkUuC76T1Y5nII
	HgOEPEAUydNNlboFRr0mGICO2JWkhl6Y6qoDK01S6OcdXqbjLi9/CqexJgcpOxx/RtlxFx2UgvW
	nb/b5HuDcZuhnEnVnztkOHiFj67gqeG2fkZtEelkQegOo1Y5DF/o+xSkYF1E8kAQ1Kgm54yRe4i
	TnFNe4VZxi83kIOJsF1C0whvwHhKYLgc3NrmKY9n54Wkbf0uML0njEV2KfBhCRyJGmnKFQc+fik
	/99fi/57r2N6dcXWW8Wm3q89WEKMKzhbNRem6v8NSvpURvZxHOZqg6zAOXovqxkVa7Q==
X-Received: by 2002:ac8:584a:0:b0:4f1:b3c0:2ae7 with SMTP id d75a77b69052e-4f1d062fccbmr159588591cf.6.1765973563349;
        Wed, 17 Dec 2025 04:12:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE5eVGC3ZWYSUKoHlLO+PfDj5QMt25oSCp8OK57mCn7+0Tam8KJf/1iWxw5fxtG/X/1ogAfiA==
X-Received: by 2002:ac8:584a:0:b0:4f1:b3c0:2ae7 with SMTP id d75a77b69052e-4f1d062fccbmr159588381cf.6.1765973562909;
        Wed, 17 Dec 2025 04:12:42 -0800 (PST)
Received: from [192.168.119.72] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7cfa29f6cbsm1991353966b.5.2025.12.17.04.12.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Dec 2025 04:12:42 -0800 (PST)
Message-ID: <c786d33d-6c6c-4932-8593-857e7054dfda@oss.qualcomm.com>
Date: Wed, 17 Dec 2025 13:12:38 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 8/9] arm64: dts: qcom: Add initial Milos dtsi
To: Luca Weiss <luca.weiss@fairphone.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Vinod Koul <vkoul@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Andersson
 <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org
References: <20251210-sm7635-fp6-initial-v4-0-b05fddd8b45c@fairphone.com>
 <20251210-sm7635-fp6-initial-v4-8-b05fddd8b45c@fairphone.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20251210-sm7635-fp6-initial-v4-8-b05fddd8b45c@fairphone.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: yopsYALCrVflempSfeIRafvopFBuJ9YQ
X-Authority-Analysis: v=2.4 cv=ALq93nRn c=1 sm=1 tr=0 ts=69429e3c cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=6H0WHjuAAAAA:8 a=EUspDBNiAAAA:8
 a=WSIVeowOIUgBBEAWWbIA:9 a=QEXdDO2ut3YA:10 a=AYr37p2UDEkA:10
 a=a_PwQJl-kcHnX1M80qC6:22 a=Soq9LBFxuPC4vsCAQt-j:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE3MDA5NSBTYWx0ZWRfX6tY65iDFGAOF
 rUU/uoUa/O/GOlLAcs6Sfu8wQ+S9w72UExIwuX+kq0rdvYW91n3eHI5YXUEpaAmkSOISbDNDg+g
 ynfxU6iBoEfkQhuEu65Dfs5PGxdBd0GBSmr9ziQKvSdIQSrzprQP43+Bsf9CxtYtJGGn7QtVrOQ
 RTbormlfTJhmyYPybd2ZnPjD3+pHDIB4Oho19OPQfxc0I46X85zf6AMBvUtsarwNVL0Kw6OBJ9i
 TM3ryICdFFYalf5QyK/ylPec4aWgjx4JK0/nYBUuh0e0JME9sEwzCI4V32zMQszB02pC3NcHC8E
 8ZWoisUWGepdsioFxkIq6QPL6KPNr+LZxft9FEhsKbqLVh1EgxBziH2SPcvOXZE9n3fKSrmI3TT
 MpZkCxO5M3RD5yVP7sUbDGGmjQ7SZw==
X-Proofpoint-GUID: yopsYALCrVflempSfeIRafvopFBuJ9YQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-17_01,2025-12-16_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 impostorscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2510240001
 definitions=main-2512170095

On 12/10/25 2:43 AM, Luca Weiss wrote:
> Add a devicetree description for the Milos SoC, which is for example
> Snapdragon 7s Gen 3 (SM7635).
> 
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
