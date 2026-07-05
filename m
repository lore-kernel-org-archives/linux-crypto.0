Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4301133993
	for <linux-crypto@vger.kernel.org>; Sun,  5 Jul 2026 17:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783273557; cv=none; b=et+v4ebQh2fGBPKaWkDABaqRr363TzfvJ5ZloV+nhHJd9tJZp+W8clXMvHxE0uUSS6m3TE9x46vWpgAUexQqPZZK1n6ZUZ6JuesR0c9x/XzhQStWV/DaqgP/FEGZp67ucG6Kpc3k5178shqNaJDn/aKng7qBtd7Y7fTmWcUaDmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783273557; c=relaxed/simple;
	bh=AqeS2WQenKoV+dzXfsfoXUVRdKIljUEkzTivQu8QwVo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gmZ4YV/cFdulcS/WxkQoXLwgnerwPeODQj37YwfOXNTYNYIyCsxr0PsI0ckEo8ySHM5ZuXsP3bfk4ZIu2tC54VcIBnqRO8Zsp760OSdJ7KokFptnL820c+uNThizqSZB5r3nExRvj7KBvA3HtK9EgyzSeYd2/75KFO22KIdmx5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Rz7SGFtZ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CAYAIrfR; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Rz7SGFtZ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CAYAIrfR"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 665HhngF2271514
	for <linux-crypto@vger.kernel.org>; Sun, 5 Jul 2026 17:45:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	lm3jFZCfu7y4SHb5dEMYbHPrvclZNhMmF1bK6UjstW0=; b=Rz7SGFtZT3B9OxYc
	GmY2nfgr44tXPro9jct3cZLSPlEU1qt4Nzn2+NYAsmyegIu5hwQ9ondlNKDQpg6T
	FIU0LxAYX1N8O0tArVHwmb72Oh/hyVGed/9BzTc+okyjBrytxuYih8fnP8spJche
	/stSt4SMnoNv2O5AniVIuyR29UAvCHotUGXpre5Dl9tc/TehUvGzL1TIJ2hbS9Oh
	usjDts3mnkHekbuzIioNVz5hpAYAoWehULU427U90bDH/IPkR7JMZB3oLjRhc9o+
	WxnKlawVt9GlUOhg74eYG5He+CNWUCnBRbedgZEV9LhrNbw7VBaixx0K10vWWzCU
	Vw+lYg==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f6qhnke9s-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Sun, 05 Jul 2026 17:45:55 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2c81db324caso50150995ad.0
        for <linux-crypto@vger.kernel.org>; Sun, 05 Jul 2026 10:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783273554; x=1783878354; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lm3jFZCfu7y4SHb5dEMYbHPrvclZNhMmF1bK6UjstW0=;
        b=CAYAIrfREostOCWU0T9RTFvBtYcl0q/tl3/RuHHdeofzTa1XoN0dk7K7BF50bw65Y1
         mC1Hccrva9Ixt2PbZaAqvsaLAElYdvtCzXSYew1jF0jBp0H/GVyGZr7h7nJrYW67s9+S
         kdsRG9c6sahLP2f5fc38RZKfBfOok0Ise/JHm0LyB2rzYnNF8wfvxEajfpcKnHEETLl9
         r0u42lCADSjDNvJpFMPswQ9fqPTCVjgJjdZZZi36qb6JlfSIzJW3vBWzg11Sr3EL5gdP
         pJnF76JzTD2+qRjz8/kUfsmM8tJGNdXhDm2Oir60Ch3zZxBE+bwL/QyrPGZYvaW8ieBr
         gFrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783273554; x=1783878354;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lm3jFZCfu7y4SHb5dEMYbHPrvclZNhMmF1bK6UjstW0=;
        b=XG2OzRJE//ueXq7icPLlEzhisfLt4oUAXCpjQyeV4a0uf96FbWRvSXKAUHJriN69zC
         kSIZrWQERPkoG6VVaRenRffJNlGf56oRp6xmGiKN+Qx16aCDmEHaTiSs1brEba2EO74H
         uV7Qbkx0XuSMn+QByz7RuOv3pSI2/K1dk9OBLP8u/uxxdg3AVcdMOhMsbD/oftUbokx0
         RIMKUtuYeaqZuenf1t+bOunLC35IzomtXrCDXoYsMawz9qTdU56lKJkDgyg5J+q1JrX5
         M1LhmnmzWpy1DYZx3g12w56Oc7lZ6pFQ+lEXaX9w+M3e5ZnGnu91cawY0MvPAf2rnGXP
         CUxQ==
X-Forwarded-Encrypted: i=1; AHgh+RpN6rHWKYf5zRSB0xMNKEPkWj9Q5W39ako7V6sCsgLMvTmjOjctFzdllyIncfJTrmPMHwYaidkXXoVxzBM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwafaGtmNchXY5Vw7qWjtseDJmW7hrCPwUahgoPlgPsyVLWttU4
	MrqXAiZGzOBgAFKEa6t3uSoutmxp7Rw8wMUzTg790XQHV07xRn4R9rc5oh5ZEuKEfQqoLq5W9CV
	36MUeHgj8LawtDeiBrDMm6faqoH7xBobpAZHA5edKVHL2YqePjqCv3dYk1WuwMN+3JOI=
X-Gm-Gg: AfdE7cmCzCvo22BSEf8flmB7dbcJXrvqPTeLzXEuUiURaMrN/oNOEKBLEbAavaSvWTw
	9M/1bWrvdGybld+P2vbUwlYMt/XgpyKlqUt5HU2Iw3HOD+xquUvPmM/FYgI/TYYTm6mgaUCo+OP
	Ejvbe8StRPkwmLKIJwFGrOXKc6wvOCV1z5/RwhMcp0sdoAlA5T8WXL3HJuu7GIV36vXpkkOPYXf
	kSPV3rBw3CqitB73fyFXwUWwDOp4SZ+Y+pqQoAlxPKnnzOqrh53Q6Q20uN3u/EOjvoQ36RU64c9
	SZAdI2bOUwoONlhNvRJ9dHaNkKdDkmCCc830h5fdfbk3Pf9DFWol/kvSkhRjZ2PYnyzt6siHlCi
	6joKcLcQSuuUCo6OAvZp1oLUxI5GHe6xdhFaKGLByofk=
X-Received: by 2002:a17:902:f544:b0:2c9:9a2e:dab0 with SMTP id d9443c01a7336-2cbb808af01mr71570695ad.3.1783273554143;
        Sun, 05 Jul 2026 10:45:54 -0700 (PDT)
X-Received: by 2002:a17:902:f544:b0:2c9:9a2e:dab0 with SMTP id d9443c01a7336-2cbb808af01mr71570465ad.3.1783273553564;
        Sun, 05 Jul 2026 10:45:53 -0700 (PDT)
Received: from [192.168.1.10] ([182.65.247.208])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad7870ff3sm35571975ad.58.2026.07.05.10.45.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2026 10:45:52 -0700 (PDT)
Message-ID: <b693a9d2-4f1d-4c17-8a63-99c7ac79ed41@oss.qualcomm.com>
Date: Sun, 5 Jul 2026 23:15:45 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND] dt-bindings: crypto: qcom,inline-crypto-engine:
 Document Nord ICE
To: Shawn Guo <shengchao.guo@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <lumag@kernel.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>
References: <20260704004408.2303468-1-shengchao.guo@oss.qualcomm.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260704004408.2303468-1-shengchao.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA1MDE5MSBTYWx0ZWRfXwZ0aSKoBTUOk
 8LoLKPOPrMCEqbjxRU5TVxpMhVv1bXecGHz9MI6wP002pcEjgu8tIpGmthmOALjTuzvphVeUybH
 cnhF+BkLsmVsGc3zkbltiTJS5KLb2TY=
X-Proofpoint-ORIG-GUID: fhgdR3jmY4cf-60FcwDYjGBeBC_a-c3k
X-Authority-Analysis: v=2.4 cv=J+yaKgnS c=1 sm=1 tr=0 ts=6a4a9853 cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=PVj2vuZyEA0yLiFZlqDmwA==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=-O3zn3E73KuLMlEsYjUA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA1MDE5MSBTYWx0ZWRfX38tM2qLVxEFk
 D1rgrJzsfq1+pde7EuZVubDLRyuOx/lSAHXiyhyNuA6fRsRUZvGdUIAVnHFqnqSWxhcpo7JAjQp
 K41mOzPw2PIto23vi95guXLjhxu5JqCVlbZBbVdDz9M9KGrkXOWgwzNYOhV/FKeqqrirN2O83MN
 wXCZk5cwkrkazss0gKpqQSSf7YhM5f+m5cyUEMqDYMAtN3BCaL/nSC1O5Wpq7OoZwVq4N/haesu
 k3g8dk4jNe/HzrV3fCzKJzQ05xAOU2Xa7eGIQ7nfHnm0bV9lqNTqDYMKdA3D7lHrsrek0vfbIW7
 IxDv99EiW0K3eBZpU7YMP3aQgcIcNnEZ7KmEg6vHwHji5YmP48PvUcqzi4RKsBERWUr9SPqKthU
 gFmr2iyT52q4HyL5lsplJxYfNhohzUZTpIRdqKYylmAnLYB2iABWuRyA2bNNDhpV/Bn5EayrjL0
 /oVYCKrJtTn7blZiAOQ==
X-Proofpoint-GUID: fhgdR3jmY4cf-60FcwDYjGBeBC_a-c3k
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-05_01,2026-07-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501
 phishscore=0 impostorscore=0 adultscore=0 clxscore=1015 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607050191

On 04-07-2026 06:14, Shawn Guo wrote:
> Document Inline Crypto Engine (ICE) on Qualcomm Nord SoC.
> 
> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
> Reviewed-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
> Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
> ---
> It was included in the Nord SA8797P DTS series [1] due to that
> the prerequisite changes were picked up by Bjorn for 7.2. Resend it to
> Herbert as the dependency is gone now with 7.2-rc1.
> 
> [1] https://lore.kernel.org/all/20260526051300.1669201-1-shengchao.guo@oss.qualcomm.com/
> 
>  .../devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml   | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> index db895c50e2d2..d690eff2e86d 100644
> --- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> +++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> @@ -17,6 +17,7 @@ properties:
>            - qcom,hawi-inline-crypto-engine
>            - qcom,kaanapali-inline-crypto-engine
>            - qcom,milos-inline-crypto-engine
> +          - qcom,nord-inline-crypto-engine
>            - qcom,qcs8300-inline-crypto-engine
>            - qcom,sa8775p-inline-crypto-engine
>            - qcom,sc7180-inline-crypto-engine
> @@ -63,6 +64,7 @@ allOf:
>              enum:
>                - qcom,eliza-inline-crypto-engine
>                - qcom,milos-inline-crypto-engine
> +              - qcom,nord-inline-crypto-engine

With below patch, we don't need nord entry here.
https://lore.kernel.org/lkml/20260702-b4-shikra_crypto_changse-v2-1-66173f2f28b3@qti.qualcomm.com/

-- 
Regards
Kuldeep

