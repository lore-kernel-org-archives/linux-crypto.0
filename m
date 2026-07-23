Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849CB3BD625
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 07:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784791624; cv=none; b=QaZXd6lWlyRv6OF+gnjn1qCSLQf37myZYfyhA73U87lSAuBOy7mI6QLzs5NOUL3PfhBuNjyI64AL1Y5NWGcYFJ8G6ahIPVHZmSPPbliUZu1AAbgf9GKC9+/wz0NzuHvXDZgCbiCqT3sey/z3YTKj5zwscLuEVd2QH9scsoxCp+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784791624; c=relaxed/simple;
	bh=SZxLuPo3nupO9EgENaNy/Na5GfdFyAFcRsipN5CXojk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UkECH2T8nJEB8yin1ybmPsxFD7z+IcdmpC6aeyJfHWjzfrt0AjW+K15C9hFOe8DtUJXzWMH0xql+ZQB/QD/munD228xrZLk0Cfbj3yugJWFoghzA1h/id5V0rRuwLuPHho1ZUu79QcIwm6gf42qfZx1lOf90Vqe9dxPFTPLMOCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SWNBaCIB; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Kqc6VrYz; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SWNBaCIB";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Kqc6VrYz"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N7BbNg3416097
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 07:27:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	3IrEKno5Qp8Qgk63iqK87KlZZ8lw++1vvwO3p9fEpe8=; b=SWNBaCIBoCrXCxRx
	7Sevj7zLzk0T8W7Ah6oCtPcUXZ1SlKCXK0L/v7E3g5RiTk41YjPfBtQEBri6IOZY
	ZyKa8oRX1PUSn5DVkaaGrfqWgvnl6Keud3qUvHIRyyhsD0nUbh6vB9NsD9sa6KDk
	xyZbcXNfbH7/UY6ufqFbZcZnZGUMjji/EYcBoU1aadS3Y/HfbiIxql3HdqjlZmbT
	f9o0RScWXIWIipzheYeiy5ymy3tWpW6sz6YL3iJDQuXEfnxD0u6W5g2wVM6igrtw
	nQN5nel14LhhMpWi5XWxgEeXpqrq5CET3gbeSfK2Hv0JdfQy/n94Z7muEXKO6XUa
	/tk4DQ==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fk6c7ht1b-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 07:27:01 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-388b404eaa4so644677a91.0
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2026 00:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784791621; x=1785396421; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=3IrEKno5Qp8Qgk63iqK87KlZZ8lw++1vvwO3p9fEpe8=;
        b=Kqc6VrYzyMDUVPonPlWixDGxPlDMbljHLJT/bSUbPAiaZyNYsOTdX0cZsSf7GBwWQS
         5sy4L+K3EFJ8cW9SYl0IEqWv+0CL7XsDHWMpZ9J2UnmG/+/nfC+vMdlmihdbymBXJz5q
         YVbr2Ga7LhB5pJrHBKaEAKZd5x7hh6+WAEGiF75hwD33cb4qXuWjeafzUxup+py6AZSL
         ETGZi6/ICmCWb6SNEdrF/aV1CDglw6fEfkT2tTHo4DyWiKESAiQfsK+N055Y45CY0CPU
         3YDaMWTak13BBcnI/p0JR+7is2JuQWz2J6I5tzC+eRJATwxAD7r6RKmfjSbPfRpA3Ari
         gI2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784791621; x=1785396421;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=3IrEKno5Qp8Qgk63iqK87KlZZ8lw++1vvwO3p9fEpe8=;
        b=Dw8L3HazzQHnRqPplqYqJhGsdXFxgWV2RyEPWgNSJt2N0NcJiPBP2Cd0giYgzyzPUY
         /6QtY+g1L9XIVKPRiqT0va6DRss7f4V8tYHrlTS3crgyUD/i8WD1US6Ehw8kf4rsq08d
         C6PRxSJEzkKA5GvcN4RKXbXbYiVryxbGXboallQmUOpGydu6O5B5gAN7IxhhyA4GsTZs
         CRzUtP+HKITjtSkMail6X/8obPxmHmz+FfgXWLSKdFPnu0mZtVLN6hy2mFQU5XH+liEz
         8jUc5cQgY4IkUmBfq6cn7JfTYJf/jXR5WKf4qnC+cZ5MwRVq8vV1UPCxEoI3UsLoz6St
         V2mg==
X-Forwarded-Encrypted: i=1; AHgh+Ro1n3AmLc2eskBmHY2gj59UcPKFQPx11C/Sul3FuKooAng5OacMWkSs4iSIVsGAyAT3oIbBlsqTLXnDDKg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYAzANEdtSo3hyrYo1f4GuXizwZ4U1tmnI4wrrNDvLEPzBi/7+
	Tej6vfU7jnDk+50ohiNeUK9s/gDwB3srHKrHog3hu5lJMJcbMOCLyOEw8ipgpzppb/0+dcvAA6w
	BNMPzniukOL1hPmx5Nnm1QMtuXVUBkhgWYe8FpQs7j6MqsEvKLXRQajOIJWyTY8XMVaA=
X-Gm-Gg: AR+sD10CPAP7eIMUfg9EZa7DR+uFGatDhIlI7fDR53EEocU30FccYU/UrSFFJIC5Shj
	WXqez+UMYFwab0v/RdU5MbR3xvPTm1pqqTGePOjxpCHs0VRjCByfUsfpDf9K4ueeS3VfZ+yk8wD
	fnduPJuGzefR6SGkCWtOU7LieZWt5Ka77ztlgdINB+vjnAlva6GOM2qb3hjpVHGVubyn7vPUXRJ
	cVs+fuL0lvK2EfsDr+4W8sDEjk0SMNYeKk5E7tEU/QCw2BhS6dNSJczYddjF45qe4Ywrst8M0Nt
	+HEtZGy8xVfRJH+SwrttoRfdp8ZCsEJDm3W6saD3WYWEU3T02C0vnK2AaTEvyvRkIwiIGk/oXTD
	wfSUlcRWFHuzVf0hTPAicfTvHv7E=
X-Received: by 2002:a17:90b:4b08:b0:37f:db06:229c with SMTP id 98e67ed59e1d1-38ec65fc538mr2037595a91.22.1784791621008;
        Thu, 23 Jul 2026 00:27:01 -0700 (PDT)
X-Received: by 2002:a17:90b:4b08:b0:37f:db06:229c with SMTP id 98e67ed59e1d1-38ec65fc538mr2037570a91.22.1784791620591;
        Thu, 23 Jul 2026 00:27:00 -0700 (PDT)
Received: from [10.92.203.75] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38ecaaf26e7sm518567a91.13.2026.07.23.00.26.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 00:27:00 -0700 (PDT)
Message-ID: <bf2b6d96-d69e-42d3-9ef4-f5c1f13328ef@oss.qualcomm.com>
Date: Thu, 23 Jul 2026 12:56:55 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] dt-bindings: crypto: qcom,inline-crypto-engine:
 Add x1e80100 support
To: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@quicinc.com
References: <20260722-devtool-v2-0-d7e609ef7388@oss.qualcomm.com>
 <20260722-devtool-v2-1-d7e609ef7388@oss.qualcomm.com>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Organization: Qualcomm
In-Reply-To: <20260722-devtool-v2-1-d7e609ef7388@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: oRDVRGRbt3z7Mh7hVGol_HtGIxTXvN5I
X-Proofpoint-ORIG-GUID: oRDVRGRbt3z7Mh7hVGol_HtGIxTXvN5I
X-Authority-Analysis: v=2.4 cv=baZbluPB c=1 sm=1 tr=0 ts=6a61c245 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=HSc_6wNcEdKxni9k-c4A:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA3NCBTYWx0ZWRfX6+Nbi3ArJUKS
 bNf7OXGsDLcoMiBPr5lcK5KsV53ojO0qj0iDOwoCSXBFMssxGdwTo3nPQ27LDlg7bJ2Aq9+SRGn
 xGErErfvug/gYAPERpCKfYNxNnNeM+I=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA3NCBTYWx0ZWRfXw8lqdrTwAr88
 eqJtjR5lEEcGGPctkWHClZayTTUvi69QB41vXkWxnBh87AbUMO604hvBuiWO5qj0yPD2NWPXRP3
 9R0fCTE9kD6OB+0KVlOfsTaF4bbrsGC5Td4iMsUBe25ZKjkJ25WrYf08GGL0CMtK9NuOszXNa4i
 QTUbdgXmkB2Y7BsajjlVUXriXdpSQJiB5lxgYhsjxDVIP1f9EQMccP6IKK6nQR1QEI8Y0q83s9x
 eH/hBtRIPVM1CdpVobZBfKcIjX+GA4WbaAaKdByyyrNTpvuTjdcwL/o7d5gjUg2IK2chuvlaoqM
 NZ3qxPIAON4rtFLjsGmqId3rlhHz55gdZwDcbwZrS/AYu1NJ8QnuXexu1X2ASKCPacEE++HXqUX
 HgDYYEmX9YzyHkiG2tQGc6ivSPyJoh3EqjCNx0zwt9qseDNseYaPpNQnRVm/YKGb1zBWSm4n9/l
 Y26rpY/WPaWaCTe0hUg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 lowpriorityscore=0 phishscore=0 suspectscore=0
 adultscore=0 impostorscore=0 priorityscore=1501 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607230074



On 22-07-2026 02:56 pm, Wenjia Zhang wrote:
> Document the compatible string for inline crypto engine found
> on the Qualcomm X1E80100 SoC, used by the Hamoa IoT EVK board.
> 
> Signed-off-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
> ---
>  Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> index 92c3ba6eae13dbd8a6a448057e942a08cc3a3ea7..07d6778a287631262282d75c0d233919f4241edd 100644
> --- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> +++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> @@ -25,6 +25,7 @@ properties:
>            - qcom,sm8550-inline-crypto-engine
>            - qcom,sm8650-inline-crypto-engine
>            - qcom,sm8750-inline-crypto-engine
> +          - qcom,x1e80100-inline-crypto-engine


Reviewed-by: Harshal Dev <harshal.dev@oss.qualcomm.com>

Regards,
Harshal

>        - const: qcom,inline-crypto-engine
>  
>    reg:
> 

