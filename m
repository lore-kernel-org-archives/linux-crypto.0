Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A6725A321
	for <linux-crypto@vger.kernel.org>; Tue,  7 Apr 2026 18:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775587641; cv=none; b=jtPxKiabfeeckvWemKvr5+Du/tO/GhMVD5VuXXgmBaHfFdN4+jbngwJOzBH9lhhPRettduT7zktNhd70gGqT0BZkArCSEReMf1DAlAHhYkeIydE11DOBZYKFluKEQSGYQ3Yp0sikMWaZP92H6sFYmUPV+xCusnvU57Jn/SNYWHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775587641; c=relaxed/simple;
	bh=BUTI2FI5DAeRrl2AB6Ysms6i3ByyTsOJvc/eQBCfqzk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o5tcIOhswzk6YpsgSlDQyPk5zbSyUA1W+1p57ZMgKYtkpT5vRsTCPWhDD3pSqZX2h2Yk9e+Gn0pfEWAGYVbSXhQNcDyh6RB0jAXYyAGYzYcd6qIdBFDumxfDOmsGsTITDq4vm2zqQ/CPNpluTkr1cQkNY7UQ7zJ8eNOWpSlGxSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DOTHBGpm; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HcNPMznJ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DOTHBGpm";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HcNPMznJ"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 637DIBA73402359
	for <linux-crypto@vger.kernel.org>; Tue, 7 Apr 2026 18:47:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	kV/sZvlksbOGct8Rbamewlp0csnui5SJDj5GeVVHGDw=; b=DOTHBGpmPssIoIOa
	h6gThNeMlPvNjfV1eMQfISNlTeMif+D5ReGkikiPJCz807PH4kq4RlU9IGUezN9M
	fxnHTNJsS2yCAVKgphxKa16TAjp15+xwJqzMCe3dwEHVq26mg9eUxaTL4uoxiwcC
	98WcBeOWoSVbLaab+MtpcNrQxxw7PqKuBTfosBYGNnnXCDPEQUAbAfR+XYLmszCM
	QU1tEp7MxEyYMuiDJ1pqb8UDrCQDsbkB3lSI6cuI+hJw6wVUmckbwCQbqr24+BeR
	NQxC+VlXI7AF2b1zsxXQneSCSWuJKvHsal62OWAVSviOZprdk9DILPSAk5AyQ74+
	YBodwA==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dcmrhv64r-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 07 Apr 2026 18:47:19 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2b258636d16so55589735ad.2
        for <linux-crypto@vger.kernel.org>; Tue, 07 Apr 2026 11:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1775587638; x=1776192438; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kV/sZvlksbOGct8Rbamewlp0csnui5SJDj5GeVVHGDw=;
        b=HcNPMznJNQ/hhUWnW+/9MFJ776GR0Z1iaeBn3eKZVQ4CJ8jOgWKQU6m6UrV90Jcsjq
         H35uOhVr6b/Rtot4twZevw5Lq2Qjeuh+EsjhuwWKfRlL/iJ8x/GHNuLkT36KW1l41OLG
         Vz3dgjrUe7RJONVsf/jTUUmnnMQTt4itoHv+fpVofNYXmdCfuIsqerGOZv8ucMDSmspE
         fsBN4nSjNX09vztMGtzytAZFD3SU8tFL72AXmtgf1Aygp8g6QPmGcHTyX+v3IY5F08lH
         n5IXVso5/g7pi8d9D4TR3U0kSoiHfYw8YMrZdT60ZUolg3s+6bgfWhC6LVOfaz6ZvXZl
         xoKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775587638; x=1776192438;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kV/sZvlksbOGct8Rbamewlp0csnui5SJDj5GeVVHGDw=;
        b=qRc7M1eWDmQsI5Mp1it0vz7+CEjg2ynUDQR6uGSjIxVZbb8Q/01eY9c0n5byt2MmCw
         0rBflfMoqbzPWYbc9sVhjp+OjdKjnC+ifyV+UQvOWXeu3TNDucxXFIqf8hucJu5SQzUo
         Hkh8wVkJZmIabPJS8VR1hEWJWQxAXL8DLYFxBPRy1zIEMdNAk5Jtl3/kfS5+7kjSryYJ
         BlW+nlmQ0aGScBpi94JfpJPL8daDCxVzQNKBYPvqxR5ev8cfyDh+STntCQB81gkZCLT9
         L7KtrVBpMTf0CfP4uogY4OSavo2pFkw0wHLUgu/g9QIkM19CNlKn/gkwBwgPp2BLBE00
         08hQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZpJl0Grv1/EaDXV/F4Eum3niTU298m9U07d0wXDRcqn3+PrjplioSQ+w9qQ5V82RSK+UYuDKJuXsr20o=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPs5wt5MaqybXELDqDr+592i4LCC7s76QoYmyaqF47VMqkrsqI
	UE/Sm3IvCuJgL3/n2b1DsalLxySCUy4TOHpY+FxIGLBndxob59boNEVCUd0X0lTuwNjjgZu0nWL
	iG6hoUJArb01ehz8DcPIr0HuDlApeN+pFJUOckbgpFgfU/gn2n+XZlvLnoZ47ImUYgDs=
X-Gm-Gg: AeBDieuNxH4Mysk92bJNAVFdyWR+/UiGYlTPtEBg7Kbaby5k25VUFLehy4I4Cvu1hqm
	anvnI9m34sNpoocnuooOSGqv2uwyktWuYs91AelqxNvFbuJ8KT40O60EM2nPKJ6/VTHr/8A2de3
	vYbpGq/aNxZkX/sHDE2qz8wtX0rUGTBKGkeZUuy9jZe8j9wezV+CbKuU7hhFX4li6cDteP0VILE
	aLB/9KCX6skVeu6jVY5SuRzk0B4Pac4DjzbJsv0NQNQtgbL43xec82qWtHyt5MrfT3jlzd7qYfU
	y0WeVHZk5Q1iL39S3BuW2imwb+Mq80NluQzrYsTkvs/a6rdzCCMjcpdQkZ2rejm6yHsZAv5n5NF
	OqVPF6LNHVVz2IAHo59nDTiZ6089/uFyzsGgv35BWfiL2FiD+C/WycXI=
X-Received: by 2002:a17:902:e54a:b0:2b2:9f45:2266 with SMTP id d9443c01a7336-2b29f454708mr99925685ad.21.1775587638242;
        Tue, 07 Apr 2026 11:47:18 -0700 (PDT)
X-Received: by 2002:a17:902:e54a:b0:2b2:9f45:2266 with SMTP id d9443c01a7336-2b29f454708mr99925255ad.21.1775587637752;
        Tue, 07 Apr 2026 11:47:17 -0700 (PDT)
Received: from [192.168.1.10] ([122.164.176.228])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b27473583dsm179498565ad.9.2026.04.07.11.47.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2026 11:47:17 -0700 (PDT)
Message-ID: <ec528927-36d7-4bec-b550-94c13c8f316c@oss.qualcomm.com>
Date: Wed, 8 Apr 2026 00:17:11 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] dt-bindings: crypto: qcom-qce: Add Qualcomm Eliza QCE
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
 <20260407-crypto-qcom-eliza-v1-1-40f61a1454a2@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260407-crypto-qcom-eliza-v1-1-40f61a1454a2@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA3MDE3MCBTYWx0ZWRfX8S1k2CDhMuvo
 WGg62wAVTSgJNtxzaKvsgif5v2lvTStOWaFEyIsvnWhlv137k9pf2KSqMib3lEHvsEAn77P4DLr
 jhy8zyaud//2b02FZS0TGP1Sc6Dcl+bg8tVRPHYlQW9+xmjRMvtKKpaYuNx9UK2CYo6Yi0WBQ6p
 LgMrlSlNJCxSTEestSgWqfT2lxkkXkhO+Pp0NBO6mNHNLH7QzmbEa6bnpKc9lYicGD9uDm+oGv3
 KQX4Qz2YXSGSy895WFaliJU9JMqxikXSSJ5iYNNB5JOcb6qswydL5+iTwtGMHgP7oQ1xZaScrV4
 zUHqfMkRm4cVC1Ml/y7WjUFRK428sRRdZ+U8kw8/+W/po1Yx9C/gKJTNKh7rr0IxFMh/xzc4I98
 ZUIL+iTnes+Uepp5HAUwvy9VRMVykUG5SGf2NNEcXlwV38La3pr/1kfSj4GiNGgfsGKIDdoiqBJ
 fRueLs3HrRIEraEXR3w==
X-Proofpoint-GUID: FBdJzvIIC7C1U5Gshhzo3fsC5Ez9Rh_E
X-Authority-Analysis: v=2.4 cv=XPUAjwhE c=1 sm=1 tr=0 ts=69d55137 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=zb/CHAQdlIs4C5+TDoMSQA==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=Xf1yJYGQRHwPKPLo8RgA:9 a=QEXdDO2ut3YA:10
 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-ORIG-GUID: FBdJzvIIC7C1U5Gshhzo3fsC5Ez9Rh_E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-07_04,2026-04-07_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 clxscore=1015 adultscore=0 phishscore=0 bulkscore=0 spamscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604010000
 definitions=main-2604070170

On 4/7/2026 7:21 PM, Krzysztof Kozlowski wrote:
> Document the QCE crypto engine on Qualcomm Eliza SoC, fully compatible
> with earlier generations.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

-- 
Regards
Kuldeep

