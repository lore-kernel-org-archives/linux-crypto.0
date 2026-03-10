Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C302138B153
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773151914; cv=none; b=G19oysan+ctYNhlw/h07HE4IEAlPmIdz7bCNJ8/SiY3BpwL5hmCn/cBHNm75GWu8FjqBLg7WKZ6v6q0lzM3FBGckY8UisWt+OsYvnC5r378lO2zo9MY7FVHhu0NeanTj31Sx2wBt9UZGm3XUbLV2LhywjDT+/uYRaw6gcliYWZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773151914; c=relaxed/simple;
	bh=7muMfh6lcHWoySE4hvw56qjM02VGOSc1W+rxRD6Wf7M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LEy9Lup6aimiyAQuI97T5aqN+DbPZtNgU8/nF9TbU0NQjUpT/KP3nHpBO/zh+Cv5NBRyHqHPSXhpwAiYMxs9c61nDy3+AmdmAJHZW6gnORWb0zEvJGQHZyUS+McNEl656OQWjnb865F5ZXy3BpywVgbBNxyiQ6blQoou/Y6wkZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ppXc3x6I; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=eKSlLvXD; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ppXc3x6I";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="eKSlLvXD"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62ACndJt3893001
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:11:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	BvqiKT0wunx5Wn8N1T4C8ObS3BrVloNnACj2VIsFGmo=; b=ppXc3x6It3Uc3En8
	GdZ+fjEhhrvAjzqSqd9UxJcZeAVNJmwXRgoqzS5kZgQQYS34HwdvKJMPBHh+M0Pi
	s8azKCmcWlzLwHn62BtHCH5aVa2ge6SV2g5pmdSFexsMxCqf6NOyzNdghJiJRvsT
	NLFsSb4eSm7TMj23WoUgloheMhP6v/GPkHqo4rqyxjy0kfU6HZzPtAgTGaJ6My2e
	SxgH6PvG5pTwc1lqH6lyBQ3f1HgkSXo5ovGGwen0FHZa4Q1bPCwJZRqGgUMTFrGs
	eEceoVGrmn7+AEALCeHxqtmWakljzbBA8/urdRRDZfHRZPhPgdXEzD9xvSG7tGi0
	XZ0lNg==
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com [209.85.217.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctkmyra2r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 14:11:53 +0000 (GMT)
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-5ffc4993b02so1001829137.2
        for <linux-crypto@vger.kernel.org>; Tue, 10 Mar 2026 07:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773151912; x=1773756712; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BvqiKT0wunx5Wn8N1T4C8ObS3BrVloNnACj2VIsFGmo=;
        b=eKSlLvXD4InNC1ftENGV1C6iDaZtXonhHljd5mRI4oCm1bMLrd4hXJIrLaf5iI5g/a
         ZiFN6yYEmQORlPWSkje3oHwQ24CX/coDcDyOqMk632ODOQ5AHmkvTe+9o06lGA/W8S27
         sgUUsFYFA8CElbPB9nsHmfRO/OCVFKWYECQ6fqaYvr0mXSDOO3p6q7ZJBE91YTSE9rWB
         lhEmNk/K+lg88ooDWMcZ0KPs5k2H8tTTS/AmR9fQIcEbFtn2UYf1PtLh2GrZNIOUbKXn
         nn3TJBbfyliQLCiD+Isr58V4jiRvzYh327bnsdeg7/MSQBNvoO2Y6hz/dZNQTA5+6wt8
         k7CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773151912; x=1773756712;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BvqiKT0wunx5Wn8N1T4C8ObS3BrVloNnACj2VIsFGmo=;
        b=TPA2xT1Z1ig53M/8LvsLPBmswcAREJB+KJV3Exh4P2M/xmuTBuVAqMGXefsCFpoW2q
         /Nby2Hihb47JKiBLL8Ocn0XDasgBNCmHo/r3Rpunyrb1q3bW3mVzGovyRytqy4KKHMva
         oSAnySNUuwBkEd5YmCjg/CZwDAU0A+Meh5CEXbUXkeYu3u4DdMWd0Znr4Lgr1OlP4v+D
         /jaEuk7L23EKBwFdhBJkEEFj368d9Nl87kfd+iZDmgLr4FTut9jSTMo1k27smL9cK3B1
         sJ1qZd10QCBYUrBEfzFEQSXhOxKHumTW2+cg4EEtEc0myRpq3/+jEas+rtKhFxTje+b8
         C47g==
X-Forwarded-Encrypted: i=1; AJvYcCU/cD/IahEFaI5Pp0z17JhDKb1cSK9SX+jRjQkN6vAZeLGLQcp4tZrES0o5JKh//xpr6oqZBZqvuVci54g=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZ0ei54E5TKeQKlhxAX0Y9i1Ib06ruuqQSgzuYqNbSksf5pHm0
	1SliGlH7OJbvTwhNiZeLG2EqfeIkm0f50+3VlaqlvYbJNBccOS378D/CFC6qq28maulQ8y26q0d
	UEi8UPNr2u1nMqLJqwH1PTgPZTDIm5m2oCm1UyjMZjVXVj134q5X9BGwGEDGorRyqrw4=
X-Gm-Gg: ATEYQzxjobgIH/vYbL5rbShYgBUIBTkcxPRAuo7O/kidEpShOkizUWZI/Wb0gD6NSdt
	ahhjedxKn5/9hOJ1wtpHb/m1NVzNenCnl/HuEF6fud73r29DhspwLl/ZdRM7sa2gL/ZO7q2rgEA
	MU/PKArgJrL0eHMrJjeHu9wKiUpInte4ZyzXKkMAOxzlrKEEPx35OfY7GlwlXvk1TevUVQgmC0c
	fAizYS436E2+pDOMFjyvkP7N1UPnQ+M+/HgHoVU1740XFf78zet0t2Sw91NSzZhZ2tvchqUSKYo
	cYjxDnjtS/lwO5ZrLB72im7mBePQM/6vYLPCX7jirKTLY8YhjfnoPb9M7VePN7QYWisAESEIGlF
	hYBGRjRFdTTEXDvJhaNHDODlgQO4bgcaLk5RMnDFiUk613N0R5Ke+aA8Z2bZoU2Exe0bbrTzNze
	qo0QE=
X-Received: by 2002:a05:6102:5094:b0:5ff:2a5a:30ce with SMTP id ada2fe7eead31-5ffe5a6dbacmr2804816137.0.1773151912052;
        Tue, 10 Mar 2026 07:11:52 -0700 (PDT)
X-Received: by 2002:a05:6102:5094:b0:5ff:2a5a:30ce with SMTP id ada2fe7eead31-5ffe5a6dbacmr2804810137.0.1773151911583;
        Tue, 10 Mar 2026 07:11:51 -0700 (PDT)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b942f139e0dsm520650866b.41.2026.03.10.07.11.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2026 07:11:50 -0700 (PDT)
Message-ID: <5186fd6a-45a4-404e-895d-671a88fd0469@oss.qualcomm.com>
Date: Tue, 10 Mar 2026 15:11:48 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] arm64: dts: qcom: sm8250: Add inline crypto engine
To: Alexander Koskovich <akoskovich@pm.me>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
References: <20260309-sm8250-ice-v3-0-418bf5c5c042@pm.me>
 <20260309-sm8250-ice-v3-2-418bf5c5c042@pm.me>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260309-sm8250-ice-v3-2-418bf5c5c042@pm.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=RYudyltv c=1 sm=1 tr=0 ts=69b026a9 cx=c_pps
 a=DUEm7b3gzWu7BqY5nP7+9g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=HrWJjY-GxD1LJqCxqiEA:9 a=QEXdDO2ut3YA:10
 a=-aSRE8QhW-JAV6biHavz:22
X-Proofpoint-GUID: ghtLqYVQE5aGmDd6FHQQMCMQKVR986jq
X-Proofpoint-ORIG-GUID: ghtLqYVQE5aGmDd6FHQQMCMQKVR986jq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDEyMyBTYWx0ZWRfX6H2k1EaPCWw5
 p+EKkhc9BqSH/D0WtUGBHjWipf6qUtf8920JGBYbmkptOYfi8aFVkpd8daD2YhWnHDvoDTusdEu
 PvRTqf8E5oKPzvmlwMVgByHTgVgyn4MFMAsCMb+6K6kyJt6TVH3UO/a0Tdg6IqUJi1tCs30hvw2
 vijgHpq1rZ7kLhduEldLiiS8TkcbeWJnSHmnru3KG7JNf3W1gzSbhpNVdholqbCAZzeXb7N6rU3
 8eZd5spK/2LeebF+U35gpa8tC2eU65QsMA10v6+lvMsnJiNM21NOiYn6eC2E9jI0DU5BXvcsLSn
 rgh8edv68No76VzY9v6VHXOOewgTpMvFmEViawx6OI//TcTAE0JgNjYtaKgqcJnkycmLbtB9VHV
 cZATnzGN5U2EVa7ob59wgcwm4baRoFSPI/Id2PQx2A+Yjt+5FQN3nGL6sYJ28fuBzmcZrZzoQOr
 3N9qH+qqk6qWyup2n4Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 impostorscore=0 malwarescore=0 spamscore=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100123

On 3/10/26 4:12 AM, Alexander Koskovich wrote:
> Add the ICE found on sm8250 and link it to the UFS node.
> 
> qcom-ice 1d90000.crypto: Found QC Inline Crypto Engine (ICE) v3.1.81
> 
> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> Signed-off-by: Alexander Koskovich <akoskovich@pm.me>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
