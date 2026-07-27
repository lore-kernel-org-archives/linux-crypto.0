Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361EB3D564A
	for <linux-crypto@vger.kernel.org>; Mon, 27 Jul 2026 10:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785148949; cv=none; b=W5DgQjlD57AzW2ItWA8s+Vs6aCw9+/vu86YspJteQSN1+4vBcp8Q57nZos3GYov7JHWrqkmywR3CgoGyhzLUJ4WYhM0DPi7cLRduRF1t14YlfyrXrLclAbKS1kGJD6wF48Ty/MRffrTRHAzI6EoL9byRDK8QTFykFLjq5waG4AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785148949; c=relaxed/simple;
	bh=CtdYiuS6QtS3lif6AWyX2CnruS6hM8a+okkptYQVeAo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j62n+RNiQu/J4bhqYoOWb1vRBETSfrOjWuulsMH2xRM6qPY34aBkA5vSz5Nynl11Hs8QU0DEm/VK2D0yqo5wwqNB6GvDZe0bsXS1XSiyNSZP+QYu7W2tYORpiUt0nwkEqPQcYWX6HuLHyByh0wc5LJ0qtpWnlu9XqEB/VpQckvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=J4liDmZl; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kLPbxpaJ; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="J4liDmZl";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kLPbxpaJ"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RAMRXQ3594224
	for <linux-crypto@vger.kernel.org>; Mon, 27 Jul 2026 10:42:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	M4oHOytgcMdQhAoK9f4CiACxZmWlqT4sp/Gde6YdyeQ=; b=J4liDmZlG2B6WpZe
	LiMQMfoX5fO0dQ40W2U+TGYvRy2TKFtc+cd1vbTmqGo8rIBY91KNuXIUtQahxT5p
	0B3KgZqL+xA34IZYnYfvY0MrFWT7+vfRCeKM8F3l1b9uWIdz/fhssrveF73a9/14
	9Pk7vli9VcrjdDgIOiTeUBm5Z3fWFrYeSHzWZo/bkFwJdFPa3Up62i/EvnxAjLj4
	B5nvt7FZmw+DvsE1+H+V3cgBTVrP7kWP702YuZRUp80/hhATaxCBA3H/UJecod4g
	bQ9269C6WYu3TcrDRUHbZnro+aVcNhRzdNM1jPEm+EAQyTnh5K29N0juDmoviYJL
	LOoxmA==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fp4mq0aup-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 27 Jul 2026 10:42:27 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2ce7dff6253so34305235ad.1
        for <linux-crypto@vger.kernel.org>; Mon, 27 Jul 2026 03:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785148946; x=1785753746; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M4oHOytgcMdQhAoK9f4CiACxZmWlqT4sp/Gde6YdyeQ=;
        b=kLPbxpaJMt20WLVTgt/2I5Qqq/FgaCa1BSCtuPFZYwDUqDDYPZNRwNow2rzfgfMKNu
         oeOPKGtqcPwqYHZyKh12s5BeiDLxZxUvcaEn9FaFQubYAgBzM7OqbU8kg3CBcZZY8WIN
         iORsNFDaSbQYaqz9cqfHyRdSSUf7G3gTzgwB8FnwJ+enZurdVJSr1dk3pKBN5TljoKlM
         85QfPchG/UsHZrUCRID2ohQDJZSaecpXQ6RstkTCV+KAKmzAnEbZ9nrfzRJ38IRccfev
         eNAWyId+5nU6QFhZ1DJQvD6uVgAmXv1+r7OSXjRe0aNiexwhTdr7NCG76437QUc/4PIB
         ZtCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785148946; x=1785753746;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M4oHOytgcMdQhAoK9f4CiACxZmWlqT4sp/Gde6YdyeQ=;
        b=QDE85uJV0EXbfTDtq7cJzN19pehhbU3xYhru6Z97UKZLcLDmMsFpqjP/0YH+kiiu2Z
         I0sHpFQCFFjt6ikxock2HnqCbIEj2aH2C3FVQMpvdagiKBD67AfcWmG0cA4016+NY1C+
         9tm3hYNB7fCr6+xq6fFoQtlA0VUINp+2DWRYbtljnPJizS9S+8bdCow+dHPyFrZns7Wp
         VpBn2hcBYGwaRyGfR9TmT3ssOdEZsg9y/miYamh6NouHDY3VpCMHAS6aro+5W1t+sxsY
         ZITZ+0RnIWTJcKUU37spePq6nOEPxovLzCTrNIuXHQ6IlMsS0xktOi0MZGnnYRvPwpcF
         HPyQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp22UihlRJKS9v1JzM/a5tQLTCSMILYtW21skUWn5y/dx3RQjkDlIDmmSix58LPYmbcvs4oOpksllpMJec=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyv8M3sBO2b8eHorirNPfzQv2tjMClAbwaA9d4Im3NUqAc1HS6A
	twRTD/1JWBt1tkXSQkPxTxQQnXslj5o41vBNbuCqwUSzyWzs389mzNDaCu7XwbatzjTxSUk8/xT
	+dp3+h7YrZoVogbX0Yk/qsvPthbVX9lhuud95bY9/IKsoXVOiEo0863UDbTNaSbDEfmY=
X-Gm-Gg: AR+sD11KZ5iGBzxIHLAEMj+69rdUR5xHCdrk9ANp22buxKX5l/SNS7K8dX/SxMBlpNa
	P/TwMlQtns90ngDOoEZQs9srLkeNTL80wv3JLH2ZAiCsUT46/fIK0Y95y/w/e0VveyuB0py/mSr
	U4ROaZaiX8pE7ZmC1NWbRuDmmSClCshvq/RXvtEJjfAQQLtzFqiHsJQedQ01Yww8J6xYTCt1C9L
	PE2BYmWHZorSATbPrqmZTBNOsuoYpo34037kYs3U8X9UkkDnRv03CwjuUlCmouSFENb2SwpMy8p
	RuciKroPmmCrd4mGCFQ8AVIPZrCidngXqjG2wjmvWb8WIjLeeWDNW9ssxamA+FScAASLdmJ9Rzd
	HHSGjIHTTAiXhERYaJ6Yp1fQ+pPXsOE8=
X-Received: by 2002:a17:903:17cc:b0:2c9:d56d:afa3 with SMTP id d9443c01a7336-2cfd717a2a5mr95672495ad.15.1785148946062;
        Mon, 27 Jul 2026 03:42:26 -0700 (PDT)
X-Received: by 2002:a17:903:17cc:b0:2c9:d56d:afa3 with SMTP id d9443c01a7336-2cfd717a2a5mr95672225ad.15.1785148945526;
        Mon, 27 Jul 2026 03:42:25 -0700 (PDT)
Received: from [10.218.31.125] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde59b451sm33396585ad.13.2026.07.27.03.42.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2026 03:42:24 -0700 (PDT)
Message-ID: <5b72725e-dec1-4f66-973e-d7620109800a@oss.qualcomm.com>
Date: Mon, 27 Jul 2026 16:12:19 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] dt-bindings: crypto: qcom,inline-crypto-engine:
 Add x1e80100 support
To: Krzysztof Kozlowski <krzk@kernel.org>,
        Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260722-devtool-v2-0-d7e609ef7388@oss.qualcomm.com>
 <20260722-devtool-v2-1-d7e609ef7388@oss.qualcomm.com>
 <20260723-impossible-invaluable-sturgeon-3b2ce1@quoll>
 <0971c95d-d848-4688-b67a-87b8488fc9b8@oss.qualcomm.com>
 <674753cb-f208-456a-90ba-a767293a8935@kernel.org>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <674753cb-f208-456a-90ba-a767293a8935@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDEwNCBTYWx0ZWRfX46QVHbe2lxxm
 E40LDkftQSS7q2j3cU8nuVONPDqAWL902awpFMJBFAdoILnk12BcDIAy3dlg1aoJiq1zN22lY14
 OQ50NOJaS+YjmkUQNknBICkY4S9tPZI=
X-Proofpoint-ORIG-GUID: zOryZGmwDEAIKb7RQoVcsKyozPvIqYm6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDEwNCBTYWx0ZWRfX5UCBl584D3Xg
 PPXzT7bzExra2nxFiqLDo1yUPwUe+pW48qDEFa7gA7LjtSWufN3O76DaH7Kj2N2umJxTEZWuYdT
 KU56+xe4e99lRRtEyoZ2HxmWHq89dpbj3wYMf0tRurwsmlDC2n6Yqh5q4ERom2y8Ba6njChq4eW
 kLdk4zwwdMZI8Re5ErFNLv/z83m3cNIjusowHLmSO1eLFVwBwc4A2JjHuCiAH8ukr0dz9lc+LMe
 Mq5r2OI6x13PYYv3uqvI/kERSohgJ/tp9VAjzUuntpe6V9Ys49CYH1YbHB/vMo5zlpYAIU98Q0E
 sORR/A4VwV9l3WqECSjSybu6W8QUY67njjGmrXWJiveYoGh6TAupZMGFsKwKkcSZNtB7g0F4JrQ
 dOrZIVshu1nJbbOHV7SR6c9T7/qQUzZe5aOnIuQsLvs0k/YLTOGE5vehqqjBl+FtpA0yJBiQDi6
 4lNwb/Z2hmYtW5E7qlA==
X-Proofpoint-GUID: zOryZGmwDEAIKb7RQoVcsKyozPvIqYm6
X-Authority-Analysis: v=2.4 cv=TemmcxQh c=1 sm=1 tr=0 ts=6a673613 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=ULJ7MOq4zP4UxKEn85kA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_03,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 impostorscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270104

>> I added the prerequisites and note information in the cover letter. Here 
> 
> That does not count as it is pointless.
> 
> Which maintainer should include these prerequisities? Both? Then patch
> is NAKed as DTS cannot depend on driver patches.

Hi Krzysztof,
Seems Wenjia rebased his hamoa effort on top of my work[1] and as per
latest update, Herbert has applied the dependent binding change to his
tree[2] and should be part of linux-next soon.

Please note, only [1] is prerequisite and not the entire series there.

With this, the dependency will be resolved and rebasing to latest
linux-next(with [2] as part of it) should make this series as standalone.
Will let Wenjia drop v3.

[1]
https://lore.kernel.org/lkml/20260714-b4-shikra_crypto_changse-v4-1-06a4ea97c209@oss.qualcomm.com/
[2]
https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=3360fa7604259a0341a9bdbb0a8cb0fd7f3109de

-- 
Regards
Kuldeep

