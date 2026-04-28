Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658871FDA61
	for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 01:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777340170; cv=none; b=kB495CKVhcc7cclMd96xv61koGJYfTqWRPVphT+gHcNXV31JkcnUnjCjnYyfS6vX1Rsx8HNpYsBCN7/arxkt2i5VLXyEEQZ66eEfEhHCK33aV+4NqfJ55YcopIEuuFvWcXSqonex8g9ExGhpyKHdVgP2NBpwVFbkqzR4VnGNh/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777340170; c=relaxed/simple;
	bh=Y7gKuCFiPboEfKzDAf73jyDXFOaCi/weSrK7a2Kqvuk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d1b3XKZTgwT0ZQhVlG9C0UmAx+G0iih2EQL5gcGfpMAZESNf8As+FyoQlJQlBvFtY3BBldOsp2x6QsEsrbqrf/nZg77MbNdjsVE6p9pNkxctVujvd+j0BAMGUm3z1SW9L4SavcGqPqH7bX+qwwtS8/dr9vU47MaK3KzLKu6Sn0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=N4CttKse; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NnjsHAik; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="N4CttKse";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NnjsHAik"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63RGYAvX3123516
	for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 01:36:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=kmuhBpsDaaHpjbrFXXWCLn7R
	VHpczN9SgLXRDFkeWwo=; b=N4CttKse4inMTMby51Mb1YAxD5xM1/fxIfjRhTVS
	iZno8VmHFOlMbCQVh1lFOWhaqm8tk0pluCgK13BzDyGZClkCKtyv0rltkqzDyZkR
	qjQwIjNZrNoJi29dR8kNUzvlnxVh0cPFApFnQemBDdY9tpzBzrQdnm1zR1AlacZ6
	/X7nsFhOFQDSnyJA2Tbmv7JqW2jWRjSOsXmz6OwqBmH1XnCZf0te4Z+O4DeCC1bQ
	WJ5MFIvKNrGGEboTE2z/+4Ph7NHfZJlJVb7+1/JjlhKFZjUFksRcz9RdSgrHFAtb
	s+rG6IiM4pZjnE0mnUEMx/MWvExHx0UMr8BwqibLi/o7Lw==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dt5qgk71y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 28 Apr 2026 01:36:08 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-2eaed3d96d7so2885299eec.0
        for <linux-crypto@vger.kernel.org>; Mon, 27 Apr 2026 18:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777340168; x=1777944968; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kmuhBpsDaaHpjbrFXXWCLn7RVHpczN9SgLXRDFkeWwo=;
        b=NnjsHAikA33BjHVi8SDVvQZRfPNka2MksUhwl7i/uaoDTakGNsMKepk89BDzkjj5jZ
         AhK+rJF6OwUP+VThX9h+jz4Lrv3pADLzr33jzE3bhaaeIXxuIEzR8LqsxjMfNvPQBPee
         KbwE109pCmSCCwspXSTUftjRxJTKhTpiqWR7HtX6J4v+yAd7V3HN9JosFE4/E9BL9hQq
         UFVIAuH6c4H8Zs4uLVABkoNOL6kMmKNlLxpRW79N+8dDN9NnpgfDgxeqCo0WsfpKjed9
         gIIBvYDLcM6yjKkSV1iRnzAOjMNfM93vOP5VMxfOPp1FnHkaM7VdEFkXiXjueK8HcJZp
         cplA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777340168; x=1777944968;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kmuhBpsDaaHpjbrFXXWCLn7RVHpczN9SgLXRDFkeWwo=;
        b=gkYVDY5sSD3vcjGts5zJf6nR4VrIBL8zFgI0CCQiXugZu3RaG9mHrOp/wtMYPv2OEq
         cbYEfQuE7B9nCOBN62tQyWQVcWfFoH7KSHP6UdHIm7WvCNb8ZFCyX6FfRb3VKmhnqu89
         /Sn1sKrmMK2VqnF6hrNnU+eB/3EoIFQQKvG1kJVTahLMnPQx145RUfexZ0QOjqBClRHc
         MvNAwNP2TeWG2UemLdKB/P+VZdB+UhAlG52itI0DOCtM+j9OlsPqoGToG/OKBSoPp8KL
         TZkEnk1bh2gHNi2rueHxyXUYzJ55w6UQntpWct9h90swd1T/U5Uq5+ogquD3nUBOR46X
         +Z5g==
X-Forwarded-Encrypted: i=1; AFNElJ9etiJ4zWzceKvCSftri/w8RTGFN4WHAKypruam4MoyLMGZaQU0e2KcydQMO/YKMu3QJj/GVu/GdmA3i/E=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywx7ImOCK3lE38Ta6QKW0OxNeT1AWHhEw3z6I311UGcXZo8Uc6k
	RIKg5bzbxbq8t9fadW5RohPsmYK9nJ00nEZKpKZ5nwT/ilG8L/Nc4mUBqh0WGEJqaQBBtkaDuwf
	kPyHiLnXGt4nXTNloOFXxGgVrujU+qL8nFqeIkgXpFPhZXU+9fs3ARMbJMKLqb0LAGDY=
X-Gm-Gg: AeBDietVtaJ91YgUDI1dA0mKCOQngzmgVYaM1Kq20o5KHLl43Hov/qELOwZV4058juQ
	qboKUpiIQIlSfJwkUvcpEbaUNCx3sKHx1YKTZob9+NlYoI76n7AKNbgBwus6jU8ciUDWxBJ//qV
	hC+m1qKs3G9fEbLpDi9b6f12MX+lT4crmRBNe3Yik/l6LNcyNpRPU5QMJPp2eL8x1QLkQvJBSk/
	KWMauyJjJwTzMHHG1Zp6LwCYbrkWmDq+fHMnOxiV1jo0Pb8VoIzfY1Bv7QuN9Tu4wKQNToEv25+
	tra76QpuGjGzY/P7jQChtB89RcRol9NASALxiSn4ACukl388JPQdJv96MzDdpTnJSDb6Y5zTj1m
	62coe1ENKjGwdVwUkdxzXhBtbUP8Q17E3Q2FqS1yhAg3xF0H4amLdPJeQlS4Vvoa4mnu1zH0BGQ
	Q=
X-Received: by 2002:a05:7300:3247:b0:2c4:ec89:bc7 with SMTP id 5a478bee46e88-2ed0a00248bmr597104eec.10.1777340167662;
        Mon, 27 Apr 2026 18:36:07 -0700 (PDT)
X-Received: by 2002:a05:7300:3247:b0:2c4:ec89:bc7 with SMTP id 5a478bee46e88-2ed0a00248bmr597080eec.10.1777340167102;
        Mon, 27 Apr 2026 18:36:07 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ed0a106524sm1074873eec.23.2026.04.27.18.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 18:36:06 -0700 (PDT)
Date: Tue, 28 Apr 2026 09:36:00 +0800
From: Shawn Guo <shengchao.guo@oss.qualcomm.com>
To: Harshal Dev <harshal.dev@oss.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <lumag@kernel.org>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dt-bindings: crypto: qcom,inline-crypto-engine:
 Document Nord ICE
Message-ID: <afAPACSt4JoLuYLn@QCOM-aGQu4IUr3Y>
References: <20260427010527.230473-1-shengchao.guo@oss.qualcomm.com>
 <f3e83bc2-36ef-4628-af1f-d9465eca72e3@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3e83bc2-36ef-4628-af1f-d9465eca72e3@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI4MDAxMyBTYWx0ZWRfX2VktognksUhl
 JcbC48BanuRRa8NmsXGmjznR8B7zuxJdqRuFztyrUshfAKqYFvRhWGJeOC08hxLHOjpDWsmv+IH
 EKjFc+nTYg/wGmpU3qEYBjf44QSX7MwwpeN1YlzVExaWBqz94mStXsCDxiRvHIy++VJ4rxcQvJo
 xF+sCrJr72DjizpoyKyItSbLVlp9+F4g/MFLFc6Y5ZTvYO06xC0LNEPsup2Eekf88SiZWOJUsWI
 L3MqtcCWuAf7NrYW0XUS8H1OkV4sqGiScxUKGmHHzcTlClciIx3vSoTlDsCfiFEyhB6gHPU3Mia
 3oln4GXnUw8OEL9cwrGe51U51depcksKZ4Il4X+Woax+DQn2IwejLiQAc4ze7musgznjpsbhXg6
 C7hf3oRpZ0PcFOL+XFWIRxMW+LOm3hWcliLy+wOfDXNIRbi+M18p3+XxIG1yJeeaLOaLSol7l31
 MdHNk8bFH0w+yyk/Wcg==
X-Authority-Analysis: v=2.4 cv=V69NF+ni c=1 sm=1 tr=0 ts=69f00f08 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=KIcV2tIvfCGpu7CZsroA:9 a=CjuIK1q_8ugA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-GUID: 7DrAokDOlzBr74hZ2OkhEE4-OkpnuL96
X-Proofpoint-ORIG-GUID: 7DrAokDOlzBr74hZ2OkhEE4-OkpnuL96
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-27_04,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2604280013

On Mon, Apr 27, 2026 at 12:50:40PM +0530, Harshal Dev wrote:
> Hi Shawn,
> 
> On 4/27/2026 6:35 AM, Shawn Guo wrote:
> > Document Inline Crypto Engine (ICE) on Qualcomm Nord SoC which is
> > compatible with 'qcom,inline-crypto-engine'.
> > 
> > Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
> > ---
> > Changes in v2:
> >  - Improve commit log to make the compatibility explicit
> >  - Link to v1: https://lore.kernel.org/all/20260420073301.1250197-1-shengchao.guo@oss.qualcomm.com/
> > 
> >  .../devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml    | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> > index 876bf90ed96e..9251db2b8fcd 100644
> > --- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> > +++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> > @@ -16,6 +16,7 @@ properties:
> >            - qcom,eliza-inline-crypto-engine
> >            - qcom,kaanapali-inline-crypto-engine
> >            - qcom,milos-inline-crypto-engine
> > +          - qcom,nord-inline-crypto-engine
> 
> Wanted to bring your attention to this patch we are hoping to send for 7.1 fixes window
> which mandates the iface clock and power-domain for ICE (from Eliza/Milos onwards) to avoid issues
> seen when these properties are missing:
> https://lore.kernel.org/all/20260416-qcom_ice_power_and_clk_vote-v5-1-5ccf5d7e2846@oss.qualcomm.com/
> 
> While I won't ask you to adjust your patch immediately, if our patch is merged, would request you to
> update this binding to comply with the newly introduced ones such that the iface clock and power-domain
> are made mandatory for Nord as well.

Thanks for the heads-up, Harshal!  Sure, I will update after your series
hits linux-next.

Shawn
