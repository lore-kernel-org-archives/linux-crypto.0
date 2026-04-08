Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B619037CD42
	for <linux-crypto@vger.kernel.org>; Wed,  8 Apr 2026 09:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775641542; cv=none; b=o+5seqxtoV6ZG8HmTS7uKiI4oMoWNFSh37vEeWQINRcHqpJRHSHRnCt+vlQHpnEJVJINfg/AnbasXOVA4D4VMDlLS288kF5h5lvr8tNBN/gsqLcDWZx8b7KuyKh7nNaXdPbzKylaTprGW3p1/hIRIlCsowPFylNzdldgOnJACdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775641542; c=relaxed/simple;
	bh=uU5MKqcc7S1AZTc7G0DzeE9Lz2K603zklKOucPKspro=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MoAEzwfOdZo4iEcI7NKuuBsXkHLmC9DB2Ivh6hIluyuivHT2bmn1i/wtDW8qWtHmWNH4+Gup4Nva54LAvhKjrOUx6TuApPkAp78VZ9aRsUop50IMe39SZOphzc0rMwQpOU6LdiOE5OJ7CO3tTu6VTVaVXChgakjb+Q7maWESTs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=h9REHJRJ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XFD2phYq; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="h9REHJRJ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XFD2phYq"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6385k6ii250047
	for <linux-crypto@vger.kernel.org>; Wed, 8 Apr 2026 09:45:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	PyuYaeJsnY00/XTkcl7oyT2eXIkuHhnCGydi3xSOPbI=; b=h9REHJRJ/zM7VS3t
	yLiAMnx5+zCrIn7pIVypDZhRVgJOfiqIyTLrR5WXR0DZOdVi8JjvdcgPMa7EzmBl
	SWhyGWFwMHfpfL1n4Lj6K6vLhG5VaZ2hnGeJNLD4dyp8emaS3fTTtqJZWezX5aMD
	Df8rX7rob+pp5efIbWUDoTr1fZSXoQKcSTc0abmP6U1+KFO4DwfrLnPpBTEn76dG
	CrKFHF23LxoWewcrszFFufxyZLHUBl4D877aUZQQmVVoC6eHrlnEQMc7PVVLBtHy
	9w4Nc509P08Vx66QZebX1ES1NQkPV1fEG31AelX7zzLTcJ+VDl4yroi/TNC5YZEx
	A2Barg==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dd8x9aebj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 08 Apr 2026 09:45:40 +0000 (GMT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8a18178713cso19856666d6.3
        for <linux-crypto@vger.kernel.org>; Wed, 08 Apr 2026 02:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775641539; x=1776246339; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PyuYaeJsnY00/XTkcl7oyT2eXIkuHhnCGydi3xSOPbI=;
        b=XFD2phYqetaG8/7wJiIwhFVPsLmTFw8NXVFv4mJA58bvPcUEUh+6CsCZPieY5dSBnB
         CfXNjp2dZuuD7T7jGCBE3OumpHK4FvmZC5/pXY2BUjotTR7WukMIq1G2GRdO1JOsUk14
         jeSOcAOyr3Dku8Rj/9tAMNg1HQU0mOQDZ1kOEYFjwqQExOifW0a0A3jqwFXuahk3cDr3
         Max0WGSKGRvwiYeBxmc272lHsuNui6VHlT2vJEbwlvWmgc0zDZQC0OXOMUe5J5ylw/qY
         f+DI6iGMFwoYXa2zSSTFfDiX6IgHBzv2rpHoJkLYpahbklhjqjlN0mjllWjr75yUt+jL
         kYBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775641539; x=1776246339;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PyuYaeJsnY00/XTkcl7oyT2eXIkuHhnCGydi3xSOPbI=;
        b=Dlnvcz9rcv4FZxK01fp+QE0lwSjCBIHm0IXPPRAa/VfRm/y5hBfuYXmkvq1LdDSjz2
         Qi0fdJullMhs8YnOhk0HPXAIgOMNIA/d86dBuoaSNo58xzr/xd5N+wf7MQNP1rnANp3a
         9K9BLVzHC+YYDHzsQ5J59VXD0fxFQkadwwhFCoCza5t8WcUxajBSWj/5q3jYNkB0Cggn
         vcwQ+i3DnwGRB1VPejE2kzhFU+yhxE7vCfos0tOfEHzfUHv3kSBtXBoczlU1Gyp3eD0A
         TIIORInGHyUSkfOmv4CBgkTwZ7K5z2fd/CrZvjnplxFQ7fPuwKPeQpSYd3KnZSsr84ed
         LpVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVhVWtyHbK1kzK3x5UtdOyEsU0RrSXbggsE5sI3zmcalPunPT9/sCAWGTefcIVFb1Gt3bH+JWd8njy2uCU=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywr0wa64tarjvcm8XHTBfL/S1Q6UGZGpRRMgq8lMkS1XzhCEj6R
	Ac1+lzpz44tvAmzgeBWSYd/LY+CD5fTWoK5yh5F6cUBG1YbaDFWQSNkv+jEf3lHPTndC85jG+0Q
	xEGzvcXWw1J9E3wW6AS3lzWRCCzRP4qbRLtFbVepE34EKuKyM+5l2tlh2j/qer6ZuKrg=
X-Gm-Gg: AeBDietqKg7NLIULo8ZwbCyn1wP6pXpXztg7wPo8C+jSn/AjWlDc1V/MiJ/XjNtT9H0
	55NYkkbbBAJbNJgurdSRZ6sKNNhB0AF87AwQqyv3F1eI+h0Rua+H+BoFBp0Mqc3G8iTtIgtxGlz
	7NW04kymWggehCpLaKEpGe406iLToPg0jlNupg9wOUAcBgMwLO2srLzUNM25VeQvzqBeVp4m06Q
	7YrAFFW1/FDRpyWGSfJvbkiAqf9NYF/9QzHlV7xmV06hfX+OstHfk2nL+TmtGr9+Yz+XqjoBElV
	jOzBEQdO2iL58uQUJYkuhzh/ft5SU098Cwn4GSNKZQb99vLnEUDavhKvan/MkT4Qs39R5sHb7L7
	jczjR6+r5u2/TqiYcXvq/kTeH1RCSrQQEdSaW878M0Dx7Is69I1q04hMdRfm6FDfnLH5ziUgEWj
	Do/2I=
X-Received: by 2002:ad4:5def:0:b0:8a2:2cc3:2764 with SMTP id 6a1803df08f44-8a701be043bmr237836846d6.1.1775641539105;
        Wed, 08 Apr 2026 02:45:39 -0700 (PDT)
X-Received: by 2002:ad4:5def:0:b0:8a2:2cc3:2764 with SMTP id 6a1803df08f44-8a701be043bmr237836646d6.1.1775641538720;
        Wed, 08 Apr 2026 02:45:38 -0700 (PDT)
Received: from [192.168.119.254] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9c3cec5c16sm623882466b.40.2026.04.08.02.45.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 02:45:37 -0700 (PDT)
Message-ID: <cbe889ff-327c-4e06-8747-3c81f9e561e8@oss.qualcomm.com>
Date: Wed, 8 Apr 2026 11:45:35 +0200
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
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260407-crypto-qcom-eliza-v1-2-40f61a1454a2@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=Rr716imK c=1 sm=1 tr=0 ts=69d623c4 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=9nldhgvQxnsrbX0ZkhUA:9 a=QEXdDO2ut3YA:10
 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDA4OSBTYWx0ZWRfX9bv6csZ39HkU
 C6iOXW39Rdw52X8UV9Lux61I/fZGDZtMmecLJ9TcVY3hjbh2vsATIIsta/dbwQLm00MUSTN0E7V
 YQozx2IBztAYtZB4QhELwcVkcLNb5HTU49dfWIBzbLw+HovP9k3Zx2Wsy4e3FaBVzNQh4q3i/Jt
 +ljeiEhwtc0yxyBBQpfaTzXnMk6YklWw20A5gFJn/Har9/pvSfMXJIlZvd25J01ZohjT1mfK6Dj
 +6+liGa/L/0FAWEwuadt3VliFijx3ANHFr9/9epB71qmQbvetk2PzRpKpGmgrHFyMahVi91zrQ8
 w5IhqWHr3zapoy0wsgI4BZpbT/37Hz17i4JxSNzFUWKyCGYtscuQ7Y8ppiaeKDPgGK36znCYjEQ
 y8Jqd+ECnMsSWZyEF5upFi35yPnMHpAmdtZeR1ns6NGHuDJJiQWyRNxzQdsENyfESszZbUZPQ2M
 nj2hvMzbqK3gshiJm0A==
X-Proofpoint-ORIG-GUID: GXZ7hcmPks4wMCgReGHKz4mYpUlBeOJp
X-Proofpoint-GUID: GXZ7hcmPks4wMCgReGHKz4mYpUlBeOJp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-08_03,2026-04-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 suspectscore=0 malwarescore=0
 clxscore=1015 bulkscore=0 phishscore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604010000
 definitions=main-2604080089

On 4/7/26 3:51 PM, Krzysztof Kozlowski wrote:
> Add nodes for the BAM DAM and QCE crypto engine.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
