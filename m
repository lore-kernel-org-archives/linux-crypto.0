Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D117427702D
	for <linux-crypto@vger.kernel.org>; Tue,  7 Apr 2026 18:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775586939; cv=none; b=c3474elEWhDm4umz+25v0i06syLQ367uJ0vri21qh24CN8vUbeQm8BW4YxNAX2FV7KX/IMprPV7gknE+SbOUKXfJI0vc5UIFgA+g+iGIqJ+4ojD3H3v/3XTn0uvhkMwLWKnw+WJR5Z2n7du4QGjNVmRk72PVAH2LqksNEDDOB2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775586939; c=relaxed/simple;
	bh=MHJGXcxA6ApQp3i+FMoqVdeIvWaEkLC2LUn0bLLaJRo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RMz/c0DnHcCM85R4Nx8LqaaZTc0RtAErYYQEabWzi5j+cpK5IIKvLCqpUTBdBE+gCrLuldebjGGHOu8INnckvT6lbidyrC2eX8t2wB+JpecdLapg88svl5Za8GInsdCOYJdDR1rhvX0zcd6uk+7hRYkvcDnH6Ro3G2HnW6hqABs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=UEhcCZO+; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=bzW8Dej4; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="UEhcCZO+";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="bzW8Dej4"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 637IUxBX1405857
	for <linux-crypto@vger.kernel.org>; Tue, 7 Apr 2026 18:35:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1riLnPbcor9bSi/ogWna6Qb1k0gWNO+Fsg1bPadaaLI=; b=UEhcCZO+HwrUUwAX
	8AjnUVwwvm7F9s3RJuZ5nBARKFRZbAUUWcf/xdTj7UTzdDqiyB0S5b3Nvmbvfr2y
	FwH5fjOZ0w9qHZ20iErDhRx31kNRaCybb/IHRq5Kgr5woy6JY/TSslXWh0+ps/g2
	EeRJoCigCfFsKeO8wWqNx98JIb3D2PdcobjSO90UQE9f4l2dEGrT+YC5BfDd1slS
	5cAAhPZt6zYPTZIxFRJEPSm52nX25CHHMn37Gmk/dPhlGqTAdtsDaNXcVr+oHzmf
	8/Je5fi+Jw4Bc65+XAFR8wWEHtFW7tJG4709n4zOhxSdrjjLAW2Ze98puue3EXqi
	QSHPhw==
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dcmrav4re-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 07 Apr 2026 18:35:38 +0000 (GMT)
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-82cdf02bce5so3342819b3a.2
        for <linux-crypto@vger.kernel.org>; Tue, 07 Apr 2026 11:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775586937; x=1776191737; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1riLnPbcor9bSi/ogWna6Qb1k0gWNO+Fsg1bPadaaLI=;
        b=bzW8Dej4tlOSDZq3yC/XsY6mHwd+yjZ9mj698iWOXuBCpMZPasfZ2CdWN4kw2T4dtW
         KHHM5PTdY/N5C/EXmxfLm/yYH0bwA3PKcP1CQaP9RHdjLqtMsATuG3modBf7yzNgCAyt
         3cuEWOv4vy/AJq1B8uk2956ovess7qSD1idrSoydkkUk9uTE3PMZvbypqLODJZPcULR0
         r2o9AbQWdER23vK9N8QOA7zjkOQJBYvmZyys3Sb6gThaXo5KwH2Js2IlHhmgGLBW5ti5
         AexAVURI7RtdTpcp2CyzSTLgQd6UjbhZYAXDqQMfvtak+4aGp0q284dpFQheHeqbr2PV
         oEPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775586937; x=1776191737;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1riLnPbcor9bSi/ogWna6Qb1k0gWNO+Fsg1bPadaaLI=;
        b=MzviDr2I2nUJWsBo4s5Ogbta654fVgxbBWNRxebXcxUrZ2Z6gCbnfednli2JCsxluw
         xWLEb/fQz3MwIx8Ca9J+lEtd3IcBh0rBTZKXEOMi5WcfzGgleKSqDoE6UA4OF0H9eMGW
         RfGiH/3v48IzN4P1IHaVZIlcA/zGv+1OVu1MIoLDa8Sek3ZorNbLgkm+fDgxnMVc8A4q
         3CRmX8YzQzrScvPvc+q+ujgYXCjtJK1qj84NmFyLTHUtMs8JLJa3QLu7D8M89aQmfx7p
         Fk/MDltXE3mhWK2pE7wdpY0iMMG+Td97vGRoiyN00nQ8jlwmq3/HSM6k/T3G3mrMCLJU
         2fRg==
X-Forwarded-Encrypted: i=1; AJvYcCW3pKE50DlTcjjEBr2Nbow5i5+0KSySgh0d20GSHdq6IcebbkNcMeJJb5ddLRBdferBKyrHvKaHmZsmGBA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhALEI8lB9wvQ/SXuf3GzzgifGsXhrv0uw1tjlnGMnB4Ms8mpA
	Lg7A8L+fGQFRWfpvtBZzQ1NXMCOtVf5fhtRsAYlBQWk1wKjexQ1YdG1YgZiTu+YIFOipqQQrTuC
	BZG0wru9TFniPQ+H3WGJN1n4drHkhlL/tGPeJFYXtqT6oQto4Mvw1jevAvj/O8XIfFuU=
X-Gm-Gg: AeBDievCXRvF3GPW59LIOIpshCrfYHJ0Dm2jHToJLF7nTVw0JzWNzkSQNLTgvK7abH6
	aOq0oQgUoKmdPl+dHU5ufBGqA6xVt/jy7LNnqDSAe8HVYUHvMxJELh1wXte+jfPqy/0GMAmefBO
	JINj9tNNwbA8ksDpzKuBN7JnrwdgFqTHicwhg0Uhr5tsGc0/i6NW9RWSecif1sFymZZoz+fq9fj
	EKumHYt2lRc0XTrHUVQq57ctSeKKFsK9XFsW+kkdIEZPJh/ZILXkuCGZ/sMiDMVSdTJY127G+ss
	o9NnjR09ajl7tKYx+ggbEE9vQw0QDT44GeRYz4iUVtNPlmKk44VuON1AdqoIpxDcf1VUR5gK0Dq
	Xi/UjjS0LDNCHvM04wqVs3DbLrQfM5NFYkffP7HVWjDo6qAAeXA==
X-Received: by 2002:a05:6a00:4fd6:b0:82c:f035:6748 with SMTP id d2e1a72fcca58-82d0dba9c80mr19478629b3a.42.1775586937447;
        Tue, 07 Apr 2026 11:35:37 -0700 (PDT)
X-Received: by 2002:a05:6a00:4fd6:b0:82c:f035:6748 with SMTP id d2e1a72fcca58-82d0dba9c80mr19478584b3a.42.1775586936950;
        Tue, 07 Apr 2026 11:35:36 -0700 (PDT)
Received: from [192.168.1.58] ([49.205.241.63])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9b3e169sm18775152b3a.18.2026.04.07.11.35.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2026 11:35:36 -0700 (PDT)
Message-ID: <6f3a593e-9537-490e-bea4-72ee20c5372b@oss.qualcomm.com>
Date: Wed, 8 Apr 2026 00:05:30 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] arm64: dts: qcom: eliza: Add QCE crypto
To: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260407-crypto-qcom-eliza-v1-0-40f61a1454a2@oss.qualcomm.com>
 <20260407-crypto-qcom-eliza-v1-2-40f61a1454a2@oss.qualcomm.com>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
In-Reply-To: <20260407-crypto-qcom-eliza-v1-2-40f61a1454a2@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: Xok1eu-8nr98lyDXZAqsPVXGJJCHgUpT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA3MDE2OCBTYWx0ZWRfX4/IrJ7hLvf3R
 5FuKCbAB+R7DNlNUlLEEZBSIB7DRBK82plKi0/V/FG2021dx1IUsF3mPIAnrij20TqBie72tEZw
 c+CgYQap+7R+4B8PKcz+dDeI/IgUHLZ9rdtJL9JiM02UKQJ9HHLhaFJmc56etculeHozf8eWITB
 2doZDFAvychAhEvVtZD9Hb5Xj6A7CtgrfCEvOxU/j0BtVt+rppn+J5AJ5VucsXvR1E5Y16zBhHk
 4NxSMZf82t69a897i6rZzAjQ8aPXwuVM4mMYO9UbsHqkovEycw938kDjCm8zhfE52EGlBiLRGFm
 BSpzlaq0cY437Vm7OYi6z4Pcf2M0FJFlEixbu2CqjLiIWLxrxCIkckdaUOF+dQrFZoRXkQcRk62
 juhWiMUN+dAXIv2XEVKibSERjce0SN194XumrXs9Ca6bRsTrOTzkNfXSxKrwyPYPZJn3FmnrukP
 sX5fpmsbdqjK6CzWSQg==
X-Proofpoint-GUID: Xok1eu-8nr98lyDXZAqsPVXGJJCHgUpT
X-Authority-Analysis: v=2.4 cv=D/d37PRj c=1 sm=1 tr=0 ts=69d54e7a cx=c_pps
 a=m5Vt/hrsBiPMCU0y4gIsQw==:117 a=Rz+oJFlrletnL8nt2WZDKg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=9nldhgvQxnsrbX0ZkhUA:9 a=QEXdDO2ut3YA:10
 a=IoOABgeZipijB_acs4fv:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-07_04,2026-04-07_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 phishscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604070168



On 4/7/2026 7:21 PM, Krzysztof Kozlowski wrote:
> Add nodes for the BAM DAM and QCE crypto engine.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
> ---
>  arch/arm64/boot/dts/qcom/eliza.dtsi | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 

Reviewed-by: Harshal Dev <harshal.dev@oss.qualcomm.com>

Regards,
Harshal

