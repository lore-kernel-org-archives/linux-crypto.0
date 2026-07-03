Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442A3383C85
	for <linux-crypto@vger.kernel.org>; Fri,  3 Jul 2026 08:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783069064; cv=none; b=fk1duBtmCPOvd5HraO9hWdVO7VhQj0Ly+rdm2NkjLCx7MM+AQE4OtsaC32FWsPWag45V9d8a/yoxsJhq4Zrhs6IYhOzf9PjLfgP2qPtIkJeQm4FWjdX2B3CLPxmZiFOZAh5OOHieI2XgekiaCuQuAAwzBfC009Yxh/pMZSdBcbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783069064; c=relaxed/simple;
	bh=dWBB8QHWzV0smXiNLQwKYnR7PGnvKRc6FyXeEmLh38c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I8xf2nzVOjuE7sc2SSc0SyTs262QPyzeIeSInEELnch/8jXOqGsK8GLSQdTOEZsJIT4QTiTD6w5JSF8dnNXNh/yktCloKPkSbZh4eMcA/tnN6ozr72lb6qG9nbdzQ/nv7BDcR0rJLDbXyY2EN+1Y8T8Hs/kYd3pJelbQPRy+FY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=hMm8lBFk; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=XKlUoR9H; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="hMm8lBFk";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="XKlUoR9H"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6636hN4v3144575
	for <linux-crypto@vger.kernel.org>; Fri, 3 Jul 2026 08:57:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	TUd+sBdE6ArmNncIlX7wMKayRRbzXx25rT/FYuJHI1I=; b=hMm8lBFk66PCdT6U
	BVKqFqO6el8z19lQ8Zdg5dx/X4axaBsp86f82xddAzMDKpJL7fOVkOiJIfFcpiuJ
	MpRP67hQCaUIUoHzDQAP9PlBYyro0Wyh4FWdA4DsMMFOgTkg7hs4ggYK/7ri3l/E
	Sk5GF3frlNrDxHsgn4+90wh+pfW5wNq3nNpDMg5eaXhVsRF6BCuhPDVCZdo+zzqS
	cQaBYzT+m171mxV16DM3j+xCV/oKf8vu2N64XXByjakGiwq+H59U5oYQZNq7LKLf
	qFNHcd/sX129k0uuxS5LJXfbPt92Y2D8W6pWB1ncrR44EoZoHhVdlRsyDJQAKBvj
	bWGvTw==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4f682brg3v-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 03 Jul 2026 08:57:42 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-51c2d2dd52eso549001cf.3
        for <linux-crypto@vger.kernel.org>; Fri, 03 Jul 2026 01:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783069061; x=1783673861; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TUd+sBdE6ArmNncIlX7wMKayRRbzXx25rT/FYuJHI1I=;
        b=XKlUoR9HPz6BeM1AJIqSuiVDeADP5lGYVUDd0poSMzk5VCDnKiMtXmax22kfit+LdT
         c3U8hX+AewGkvE2j3zX4swIrxlHGt0B3azsFd3HbQ5gUTJWlNQ3LSD+WoWkcCGYhkWEv
         D8bh88cj8QtZOwnCJn2OQcK1z5ULU6krrI6gvYV/c9gbie5vYORqEMNOy15bxxnFsFDq
         khUe855ITZa6+/lCHCxOaXyLhPFdLlNSfOZNLgSdq4eX4OTL1JyX3lB+7Ox8c1Okuygu
         t07TR1jlzV7iZs2qDm8QJGBG/x0BwE/7hW7Z+tro38vs6FAKGQKpfUnpzrwc0JDXgpwt
         8BSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783069061; x=1783673861;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TUd+sBdE6ArmNncIlX7wMKayRRbzXx25rT/FYuJHI1I=;
        b=KJ7BtPspgYZTK33qmS2wa0pLA0MsBt1lgZrg6d9vX9UfnLgaflhFuixMe8DXMB96AJ
         pxhklfntU0Q1dciUesqF0i3uhGirrA4JYUfzxzgCEHhAddzIfbmhCLNFXjoQgoXpTnTh
         Upoxulw9kmqKYb9atfUHs5FkcryZKUqg38lhBh8qXoFsPYvtlqINKgpY0InyOeqkGOEV
         eUB1ooTd8OJUuZegDm6/K6lgDIGNwvDf9i2/C/bb6mn7xMwjzz/zuiqCqc5TWP7D7B6D
         PQuGwKX9nkLzRNeIhnqC3sUE3acu1uczz2dimx2FqjxJEpS5BUu1Nost+XSNOAmeNvdj
         Y6CQ==
X-Forwarded-Encrypted: i=1; AFNElJ+MjZ3FD/X/b5k64XFK1i/S1MCG9X/Y/gKzT8Swf+SE8sN600RnzGKldQIUYozTvahMkw2+UVFs84hHs40=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1qK+1ox198yuT1Y/8PSqDiB7Mz4+uXhNLQpFdu5PFHxHnv8Eb
	sjYHXAHDNGn4k7FUs+Z8IlO/ELYKzv6CXOL1aZdTfNGouQZnZ4sAx5zMSggSRFgph9F6/a+Ebmj
	aG4zgXWadiaKuLj7yJ3EgDbsXyam9Jjbk0/q1grw9RyeL5DYPFrsBNsztxVr/on5xOg0=
X-Gm-Gg: AfdE7ck6dbax+GBYitNSOsssdZ0F01WlY8HmudxsffZITSLu05Lyatj2cSVPIg/pZF1
	gvSnide0c1mj9vle4ZZnypbbZU49YuWqtZwc9xnjU2SdjftjAzrOzULcNExR4I1ozdOdOI/BaSW
	yv3hHACPi4OFf6gIGPJJBCN/bNdzhz9hTzmKOEivbbwISJEFGB1nXiD3oFh9nALrrJW5rU+cnAV
	ZPGmGApo9WQ2FkoJJifRpxAwfWSAftlX64oG/Eaai9CJgjxEOeNETJa1vKBKfDv7+1PdJQ90pED
	4h+9qXr4oxxZbzD1rOpHipNiS61tVF8iUvP4fHCmdcskXR0tZ74RVEX37kZxTNgo7gGUa+AmN5d
	l+W6S4QOKpqp7hJhqJmtWIlv0rYu4KKT6BsA=
X-Received: by 2002:ac8:7c51:0:b0:51b:f40b:2faf with SMTP id d75a77b69052e-51c26a7769dmr76954051cf.4.1783069061304;
        Fri, 03 Jul 2026 01:57:41 -0700 (PDT)
X-Received: by 2002:ac8:7c51:0:b0:51b:f40b:2faf with SMTP id d75a77b69052e-51c26a7769dmr76953791cf.4.1783069060725;
        Fri, 03 Jul 2026 01:57:40 -0700 (PDT)
Received: from [192.168.120.193] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c12b62fc72dsm256179766b.63.2026.07.03.01.57.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2026 01:57:40 -0700 (PDT)
Message-ID: <0b182566-2a54-4e31-9a1e-40bdbb0f4a65@oss.qualcomm.com>
Date: Fri, 3 Jul 2026 10:57:37 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/6] dt-bindings: dma: qcom,bam-dma: Increase iommus
 maxItems to seven
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Harshal Dev <harshal.dev@oss.qualcomm.com>,
        Vinod Koul <vkoul@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>,
        Konrad Dybcio
 <konradybcio@kernel.org>,
        Frank Li <Frank.Li@kernel.org>, Andy Gross <agross@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org
References: <20260702-b4-shikra_crypto_changse-v2-0-66173f2f28b3@qti.qualcomm.com>
 <20260702-b4-shikra_crypto_changse-v2-5-66173f2f28b3@qti.qualcomm.com>
 <20260703-steadfast-greedy-seagull-ad32ab@quoll>
 <e53f9b7d-66f1-4922-ab20-f6e66015c912@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <e53f9b7d-66f1-4922-ab20-f6e66015c912@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzAzMDA4NCBTYWx0ZWRfXz0CRZFQiOXMp
 ligDYPiNazAPBoy4TzS7IyFd67M4/z988+rruCqyM9NqEYe56Yh7wru3hofQ0oBG+rOCV/sEGVz
 yvMwLcdMYuDnebPbyUGvmhOLFx7bIF26E2VhYbIPN8RLcXN66z/wnemTpd7+H2PKS3/MPlRjtMM
 yBwF7f9IPWZVmfm5QJP22FQJVgxIu9YyAT0WTcAHirPIgAAmK9/ZTv14Ed7xddB8z4iANrc98X9
 s67aDOuhKeial4rLr44NAKii5wZZ27EZ93fdkDoZEHPuvFLB/cGB1vXsUxN38uvtunJDhoZTuy+
 zUNzPPKJ/4mGW7ih2mxEAUcfffJ8PsAbt+zWfuaJjaX6msgEuTydpGBTZSPYXDTWLd6LbFaRAU5
 lYtbETUCvjPx9wjeJUso/NafWXmdcbuevcAzt1+C+qia1RNAWvqm0T+EqrTwBLlTzn5J8p99pZV
 oXRsGdC4BSNmHw57yUg==
X-Proofpoint-ORIG-GUID: 0KkR5oZ6ZvT7EJefptZ_hX3Oq4EZCT-J
X-Authority-Analysis: v=2.4 cv=cc3iaHDM c=1 sm=1 tr=0 ts=6a477986 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=7f3yg-VG_fZZVZRDPQcA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzAzMDA4NCBTYWx0ZWRfXyshY1V5q1NH8
 KoiDu5tuEBl0Af85A8xr+k+Cx3PZh2mAj4d97cUDYvI+m8I3FO6N4acLxz3M5yf80N6uxq5yQX5
 uoYumXvLvi7h+z+DFUMqNLeJbKe212A=
X-Proofpoint-GUID: 0KkR5oZ6ZvT7EJefptZ_hX3Oq4EZCT-J
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-07-03_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 adultscore=0 bulkscore=0 priorityscore=1501
 phishscore=0 spamscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607030084

On 7/3/26 10:38 AM, Kuldeep Singh wrote:
> On 03-07-2026 12:24, Krzysztof Kozlowski wrote:
>> On Thu, Jul 02, 2026 at 01:47:15AM +0530, Kuldeep Singh wrote:
>>> Upcoming Shikra BAM DMA uses 7 IOMMU entries and not 6, so increase the
>>> `iommus` maxItems constraint.
>>>
>>> Fix below error:
>>> dma-controller@1b04000 (qcom,bam-v1.7.4): iommus: [[25, 132, 17], [25,
>>
>> There is no dma-controller@1b04000 in DTS. Please drop all the warnings
>> which do not exist.
> 
> Kindly check patch 6/6, it is introducing bam node with 7iommus which IP
> describes and hence, updated bindings before to accustom this which also
> helps in avoiding rob's dt-schema bot error.

Krzysztof is saying that the error doesn't exist in the tree (because
the offending DTS hunk is not merged), so you shouldn't claim this fixes
an error, rather that Shikra simply needs it

Konrad
